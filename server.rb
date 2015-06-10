require 'sinatra/base'

require './todo'

class ToDoWeb < Sinatra::Base
  set :logging, true
end