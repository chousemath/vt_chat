task run_tests: :environment do
  system('rails db:environment:set RAILS_ENV=test')
  system('bundle exec rake db:drop RAILS_ENV=test')
  system('bundle exec rake db:create RAILS_ENV=test')
  system('bundle exec rake db:schema:load RAILS_ENV=test')
  system('rspec')
  system('rm -rf public/system')
end
