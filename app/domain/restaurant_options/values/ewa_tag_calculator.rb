# frozen_string_literal: true

module Ewa
    module Value

        class EwaTags < SimpleDelegator
            
            def initialize (id, money, google_rating)
                @id = id 
                @money = money
                @google_rating = google_rating
            end

            def 

            def tag_rules
                if @money >= 1000 & @google_rating >= 4.5
                    ewa_tag = '老闆請客 Boss, please treat me!'
                elsif @money >= 1000 & 4 <= @google_rating < 4.5
                    ewa_tag = '存點錢再吃  Eat when you have budget!'
                elsif 500 <= @money < 1000 & @google_rating >= 4.5
                    ewa_tag = '女朋友叫你帶她去吃 Girlgfriend said she want to eat that!'
                elsif 500 <= @money < 1000 & 4 <= @google_rating < 4.5
                    ewa_tag = '同學會可食 Eat this in the class reunion!'
                elsif 300 <= @money < 500 & @google_rating >= 4.5
                    ewa_tag = '發薪日可食 Eat when you get your salary!'
                elsif 300 <= @money < 500 & 4 <= @google_rating < 4.5
                    ewa_tag = '吃拉，哪吃不吃~ Ok, just eat that.'
                elsif 0 < @money < 300 & @google_rating >= 4.5
                    ewa_tag = '便宜上天堂 Go to heaven~'
                elsif 0 < @money < 300 & 4 <= @google_rating < 4.5
                    ewa_tag = 'cp值爆高 Cheap and happy!'
                elsif 0 < @money < 300 & @google_rating <= 3.5
                    ewa_tag = '維持生命 Only maintain my life'
                elsif @money > 300 & @google_rating <= 3.5
                    ewa_tag = '痛苦盤子 Eat sh**!'
                elsif @money == 0
                    ewa_tag = '查無價格 No price'
                else
                    ewa_tag = '哎呀還行拉 So~so!'
                end
            end
        end
    end
end