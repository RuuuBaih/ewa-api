release: rake db:migrate; rake queues:create
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
click_worker: bundle exec shoryuken -r ./workers/search_worker.rb -C ./workers/shoryuken.yml
search_worker: bundle exec shoryuken -r ./workers/click_worker.rb -C ./workers/shoryuken.yml