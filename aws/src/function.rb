require 'json'
require 'aws-sdk-dynamodb'

def dynamo
  @dynamo ||= Aws::DynamoDB::Client.new
end

def table_name
  ENV.fetch('TABLE_NAME')
end

def pk_value
  ENV.fetch('COUNTER_PK', 'global')
end

def response(status, body)
  {
    statusCode: status,
    headers: { 'Content-Type' => 'application/json' },
    body: JSON.dump(body)
  }
end

def get_count
  res = dynamo.get_item(
    table_name: table_name,
    key: { 'pk' => pk_value },
    consistent_read: true
  )
  count = res.item ? (res.item['count'].to_i || 0) : 0
  response(200, { count: count })
end

def increment
  res = dynamo.update_item(
    table_name: table_name,
    key: { 'pk' => pk_value },
    update_expression: 'SET #c = if_not_exists(#c, :zero) + :incr',
    expression_attribute_names: { '#c' => 'count' },
    expression_attribute_values: { ':incr' => 1, ':zero' => 0 },
    return_values: 'UPDATED_NEW'
  )
  response(200, { count: res.attributes['count'].to_i })
end

def lambda_handler(event:, context:)
  method = event.dig('requestContext', 'http', 'method') || event['httpMethod']

  case method
  when 'GET' then  get_count
  when 'POST' then increment
  else
    response(405, { error: 'Method Not Allowed' })
  end
end