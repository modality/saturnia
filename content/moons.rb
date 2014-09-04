require 'bundler'
Bundler.require

MultiJson.engine = :yajl

class Moons < Sinatra::Base
  get '/' do
    'Hello World!'
  end
end
