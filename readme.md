# Setup

git pull

bundle install

rake db:setup

# Run tests

RACK_ENV=test rake db:setup && rspec spec/

# Run local server

rerun rackup

