require 'sinatra/base'

require './gifbot'

class GifBotWeb < Sinatra::Base
  set :logging, true

  def jiffybot
  	GifBot.new
  end

  post "/gif/add" do
  	jif = jiffybot.add_gif params[:url], "Bella"
  	jif.id.to_s
  end

  get "/gif" do
  	jiffybot.random_gif
  end

end

if $PROGRAM_NAME == __FILE__
  GifBot.start!
end