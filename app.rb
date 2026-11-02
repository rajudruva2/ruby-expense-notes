require "sinatra"
require "json"

set :bind, "0.0.0.0"
set :port, ENV.fetch("PORT", "4571").to_i
set :show_exceptions, false

SEED_DATA = [{"id":1,"description":"Metro ticket","amount":45.0,"category":"travel"}]
ITEMS = Marshal.load(Marshal.dump(SEED_DATA))

before do
  content_type :json
end

helpers do
  def json_body
    request.body.rewind
    raw = request.body.read
    return {} if raw.nil? || raw.empty?
    JSON.parse(raw)
  rescue JSON::ParserError
    halt 400, { error: "Request body must be valid JSON" }.to_json
  end

  def next_id(items)
    (items.map { |item| item["id"].to_i }.max || 0) + 1
  end
end

get "/" do
  { app: "Expense Notes API", message: "API is running", endpoints: ["/health", "/expenses"] }.to_json
end

get "/health" do
  { status: "ok", app: "ruby-expense-notes" }.to_json
end

get "/expenses" do
  results = ITEMS
  if params["q"]
    q = params["q"].downcase
    results = results.select { |item| item.to_json.downcase.include?(q) }
  end
  results.to_json
end

get "/expenses/:id" do
  item = ITEMS.find { |entry| entry["id"] == params["id"].to_i }
  halt 404, { error: "Record not found" }.to_json unless item
  item.to_json
end

post "/expenses" do
  data = json_body
  halt 422, { error: "description and a non-negative numeric amount are required" }.to_json unless data["description"].is_a?(String) && data["amount"].is_a?(Numeric) && data["amount"] >= 0
  data["id"] = next_id(ITEMS)
  ITEMS << data
  status 201
  data.to_json
end

delete "/expenses/:id" do
  index = ITEMS.index { |entry| entry["id"] == params["id"].to_i }
  halt 404, { error: "Record not found" }.to_json unless index
  ITEMS.delete_at(index)
  status 204
  ""
end

get "/summary" do
  { count: ITEMS.length, total: ITEMS.sum { |item| item["amount"].to_f }.round(2) }.to_json
end
