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

	get "/gif/all" do
		jiffybot.all_gifs
	end

	patch "/gif/tag" do
		jif = jiffybot.tag_gif params[:id], params[:name]
		jif.id_to_s
	end

	get "/gif/:tag" do
		Gif.find params[:tag]
	end
end

if $PROGRAM_NAME == __FILE__
  GifBot.start!
end