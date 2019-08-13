# Lambda filter plugin for Embulk

## Overview
filter though AWS lambda function. Each record is passed to the lambda function. Lambda function is expected to return JSON. These returned data is structured jsonpath and schema information.

Use case is filtering data by:
- API's that do not have a embulk plugin
- private API's


**Plugin type**: filter

## Configuration

- **aws_access_key_id**: AWS access key id (string, required)
- **aws_secret_access_key**: AWS secet access key (string, required)
- **region**: AWS region (string, required)
- **func_name**: the name of lamba function (string, required)
- **mode**: append/replace (string, default: `"append"`)
- **root**: JSONpath root (string, default: `"$."`)
- **schema**: JSONpath root (array, required)

## Example

```yaml
filters:
  - type: lambda
    aws_access_key_id: Abcdefghijk
    aws_secret_access_key: Abcdefghijk
    aws_region: ap-northeast-1
    func_name: lambdaFunc
    mode: append
    root: $.response
    schema:
      - {name: name, type: string}
      - {name: next, type: string}
      - {name: prev, type: string}
```


## Build

```
$ rake
```
