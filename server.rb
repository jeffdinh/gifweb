require 'sinatra/base'

require './todo'

class GifBot < Sinatra::Base
  set :logging, true


end

if $PROGRAM_NAME == __FILE__
  GifBot.start!
end