# page
# per_page
# city
# town
# min_money
# max_money

# join the url
POI_API_PATH = 'https://emma.pixnet.cc/poi?'

def input(page, per_page, city, town, min_money, max_money)
    @page = page
    @per_page = per_page
    @city = city
    @town = town
    @min_money = min_money
    @max_money = max_money
end

input('1', '10', '', '新店區', '', '')

poi_input = {
  'page': @page,
  'per_page': @per_page,
  'city': @city,
  'town': @town,
  'min_money': @min_money,
  'max_money': @max_money
}

def input_empty?(input_name, input)
  input.empty? ? nil : "#{input_name.to_s}=#{input.to_s}"
end

def url(input_new)
  POI_API_PATH + input_new.join('&')
end

input_new = []

poi_input.map do |key, value|
  test_not_empty = input_empty?(key, value)
  input_new << test_not_empty unless test_not_empty.nil?
end

puts url(input_new)
