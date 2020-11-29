include Ewa
include Mapper
include Repository
include Entity
town = '中山區' 
min_money = 0
max_money = 1000
# select restaurants from the database
selected_entities = Repository::For.klass(Entity::Restaurant).find_by_town_money(town, min_money, max_money)

# pick 9 restaurants
rests = Mapper::RestaurantOptions.new(selected_entities)
