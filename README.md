# Ewa

Don't know what to eat? Ewa help you decide your breakfast, lunch and dinner!

## Overview

Ewa combines Pixnet poi API, Google Custom Search API and Google Map API, recommending you delicious restaurants with restaurants information, related food blog articles, and Google map rating and reviews. We hope to solve the "Don't know what to eat for ...?" issues and make our life simpler by choosing the food based on the restaurants recommended by Ewa!

## Status
[![Ruby v2.7.1](https://img.shields.io/badge/Ruby-2.7.1-green)](https://www.ruby-lang.org/en/news/2020/03/31/ruby-2-7-1-released/)

## Short-term usability goals

- Pull data from Pixnet API, Google Custom Search API and Google Map API.
- Randomize recommending the restaurants based on certain conditions.
- Combine restaurants information, related blog articles, Google map rating, reviews, and beautiful photos.

## Long-term goals

- Recommand restaurants based on users' preferences.


## [API usage](https://ewa-api.herokuapp.com)
### All
1. Exchange by JSON format.
2. [root_path](https://ewa-api.herokuapp.com)

### Root page
1. URL path: `root_path`
2. Description: It shows the healthy status of our api. For now, it's version 1 for our API.
    - `{"status": "ok", "message": "Ewa API v1 at /api/v1/ in production mode"}`
### Restaurants page  
1. URL path: `root_path/api/v1/restaurants`
2. Description: You can see restaurants lists of our API, our API shows default of top 5 restaurants which clicked by users the most.
3. input_params
    * **page**: integer, what page you want to get
    * **per_page**: integer, how many restaurants you want to get by one page. You can't set this upper than 10.
    * **town**: string, which town you wanna filter by, we only support restaurants for Taipei and New Taipei City. You can input something like "中山區", but if you input "橫山鄉" it will bump error.
    * **min_money**: integer, the minimum money range 
    * **max_money**: integer, the maximum money range
    * **random**: integer, the random number you want from a big pool of restaurants
4. input_examples:
    * Search for top 18 clicked restaurants in our website 
        - `root_path/api/v1/restaurants?page=1&per_page=9` 
        - `root_path/api/v1/restaurants?page=2&per_page=9` 
    * Search for 中山區 top 5 restaurants 
        - `root_path/api/v1/restaurants?town=中山區&page=1&per_page=5` 
    * Search for 中山區 random 5 restaurants 
        - `root_path/api/v1/restaurants?town=中山區&random=5`
    * Search for 中山區 random 9 restaurants which money spent there range from 100 ~ 500
        - `root_path/api/v1/restaurants?town=中山區&random=9&min_money=100&max_money=500`
5. output_params
    * **total**: the total number of restaurants
    * **rests_infos**:
        * **id**: restaurant id
        * **name**: restaurant name
        * **cover_pictures**: 
            * **id**: cover_picture id
            * **picture_link**: cover_picture's picture link
            * **article_link**: cover_picture's related blog article link
        * **links**
            * **search_by_id**: the link related to restaurant details which search by id
            * **search_by_name**: the link related to restaurant details which search by name

### Restaurant Details Page (search by id)
1. URL path: `root_path/api/v1/restaurants/picks/{restaurant_id}`
2. Description: You can see more about one restaurant's infomation. Such as ewa tag, google rating, open_hours, tags, reviews, articles and pictures...etc.
3. input params:
    * restaurant_id: integer, restaurant's id. If the restaurant hasn't been clicked before, it will return something like: `{"status": "processing", "message": "陳記白玉甜點 is searching for related details, please wait for a moment."}` It means our website is loading data for restaurant 陳記白玉甜點, please wait for a moment then reload the page, you will see the restaurant details afterwards.
 
**Ewa can't guarantee for the information quality, which is controlled by Google and Pixnet resources. However, we try to pick out those restaurants we think are the best for everyone. :)**

## License
2020, Rona Lu-Lai 呂賴臻柔
2020, Vivian Lu 盧宇涵
2020, Yan-Yu Fu 傅嬿羽
