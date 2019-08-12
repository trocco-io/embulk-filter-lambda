require 'aws-sdk'
require 'json'
require 'jsonpath'

module Embulk
  module Filter

    class Lambda < FilterPlugin
      Plugin.register_filter("lambda", self)
      MODE_APPEND = "append".freeze

      def self.transaction(config, in_schema, &control)
        # configuration code:
        task = {
            "aws_access_key_id" => config.param("aws_access_key_id", :string),
            "aws_secret_access_key" => config.param("aws_secret_access_key", :string),
            "aws_region" => config.param("aws_region", :string),
            "func_name" => config.param("func_name", :string),
            "mode" => config.param("mode", :string, default: MODE_APPEND),
            "parser" => config.param("parser", :hash, default: {}),
        }

        out_columns = out_schema(in_schema, task['parser']['schema'], task['mode'])

        yield(task, out_columns)
      end

      def self.out_schema(in_schema, schema, mode)
        cols = schema.map do |s|
          Column.new(nil, s['name'], s['type'].to_sym)
        end

        if mode == MODE_APPEND
          in_schema + cols
        else
          cols
        end
      end

      def init
        # initialization code:
        @aws_access_key_id = task["aws_access_key_id"]
        @aws_secret_access_key = task["aws_secret_access_key"]
        @aws_region = task["aws_region"]
        @func_name = task["func_name"]
        @mode = task["mode"]
        @parser = task["parser"]
        @client = Aws::Lambda::Client.new(region: @aws_region,
                                          access_key_id: @aws_access_key_id,
                                          secret_access_key: @aws_secret_access_key)
      end

      def close
      end

      def add(page)
        # filtering code:

        page.each do |record|
          payload = JSON.generate(hash_record(record))
          resp = invoke_lambda(payload)
          columns = new_columns(record, resp)
          page_builder.add(columns)
        end
      end

      def new_columns(record, resp)
        path = JsonPath.new(@parser['root'])
        filtered_record = path.first(resp.payload.string)
        new_record = @parser['schema'].map do |s|
          filtered_record[s['name']]
        end

        if @mode == MODE_APPEND
          record + new_record
        else
          new_record
        end
      end

      def invoke_lambda(payload)
        @client.invoke({
                           function_name: @func_name,
                           invocation_type: 'RequestResponse',
                           log_type: 'None',
                           payload: payload
                       })
      end

      def finish
        page_builder.finish
      end

      def hash_record(record)
        Hash[in_schema.names.zip(record)]
      end
    end

  end
end
