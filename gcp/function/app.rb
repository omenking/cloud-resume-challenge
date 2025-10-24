require "functions_framework"

# HTTP function named "hello_http"
FunctionsFramework.http "hello_http" do |request|
  name = request.params["name"] || "world"
  greeting = ENV["GREETING"] || "Hello"
  [200, { "Content-Type" => "application/json" }, [{ message: "#{greeting}, #{name}!" }.to_json]]
end