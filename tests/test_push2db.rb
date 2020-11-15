
include Ewa
include Ewa::Database
include Restaurant

config = YAML.safe_load(File.read('config/secrets.yml'))

restaurant_entities = Restaurant::RestaurantMapper.new(config['development']['GMAP_TOKEN']).restaurant_obj_lists

restaurant_repo_entities = restaurant_entities.map do |restaurant_entity|
    Repository::For.entity(restaurant_entity).create(restaurant_entity)
end
