# frozen_string_literal: false

module Ewa
    # Provieds access to poi(point of interests: like restuarant sites) data
    module Restaurant
        # Data Mapper: Pixnet POI, Gmap Place & Place details -> Poi entity
        class RestaurantMapper
            def initialize(
                gmap_token,
                gateway_classes = {
                    pixnet: Pixnet::PoiApi,
                    gmap_place: Gmap::PlaceApi,
                    gmap_place_details: Gmap::PlaceDetailsApi
                }
            )
                @token = gmap_token
                @pix_gateway_class = gateway_classes[:pixnet]
                @gmap_place_gateway_class = gateway_classes[:gmap_place]
                @gmap_place_details_gateway_class = gateway_classes[:gmap_place_details]
                @pix_gateway = @pix_gateway_class.new()

            end


            def self.build_entity(data)
                DataMapper.new(data).build_entity
            end

            def get_poi_details
                poi_filtered_hashes = @pix_gateway.poi_lists[:data][:pois].reduce([]) do |start, hash|
                    selected_hash = hash.select do |key, value|
                        if value.class == Hash
                            sub_key = value.select do |subkey, v|
                                # :avg = rating average
                                key_lists = [:avg, :city, :town] 
                                key_lists.include? subkey
                            end
                        else
                            key_lists = [
                                :name,
                                :money,
                                :telephone,
                                :cover_image_url,
                                :tags,
                            ] 
                            key_lists.include? key      
                        end
                    end

                    selected_hash[:pixnet_ratings] = selected_hash.delete :avg
                    selected_hash[:cover_img] = selected_hash.delete :cover_image_url
                    start << selected_hash
                end
            end

            def get_gmap_place_details(poi_filtered_hash)
                @name = poi_filtered_hash[:name]
                @gmap_place_gateway = @gmap_place_gateway_class.new(@name, @gmap_token)
                @place_id = @gmap_place_gateway.place_id[:candidates][:place_id] 
                @gmap_place_details_gateway = @gmap_place_details_gateway_class.new(@gmap_token, @place_id)
                @place_details = @gmap_place_details_gateway.place_details

                restaurant_hash = poi_filtered_hash
                restaurant_hash[:open_hours] = @place_details[:result][:open_hours][:weekday_text]
                restaurant_hash[:google_rating] = @place_details[:result][:rating]
                restaurant_hash[:reviews] = @place_details[:result][:reviews].reduce([]) do |start, hash|
                    selected_hash = hash.select do |key, value|
                            key_lists = [
                                :author_name,
                                :profile_photo_url,
                                :rating,
                                :text,
                                :relative_time_description,
                            ] 
                            key_lists.include? key
                    end 
                    selected_hash[:google_ratings] = selected_hash.delete :rating
                    start << selected_hash
                end

                # Photos may be added in the future 

            end

            def get_restaurant_obj_lists
                poi_filtered_hashes = self.get_poi_details
                restaurant_obj_lists = poi_filtered_hashes.map do |hash|
                    agg_hash = self.get_gmap_place_details(hash)
                end
            end 


            # Extracts entity specific elements from data structure
            class DataMapper
                def initialize(data)
                    @data = data
                end

                def build_entity
                    Entity::Restaurant.new(
                        id: nil,
                        name: name,
                        town: town,
                        city: city,
                        open_hours: open_hours,
                        telephone: telephone,
                        cover_img: cover_image,
                        tags: tags,
                        pixnet_ratings: pix_ratings,
                        google_ratings: google_ratings,
                        reviews: reviews
                    )
                end

                private
                
                def name
                    @data['name']
                end

                def town
                    @data['town']
                end
            end
        end
    end

end
