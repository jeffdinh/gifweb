require 'minitest/autorun'
require 'rack/test'

ENV["TEST"] = ENV["RACK_ENV"] = "test"

require './db/setup'
require './lib/all'

require './server'

require 'pry'

class GifBotTest < Minitest::Test
  include Rack::Test::Methods

  def app
    GifBotWeb
  end

  # def setup
  #   Item.delete_all
  #   User.delete_all
  #   List.delete_all
  # end

  def test_can_add_gif
    User.create! name: "Jeff"
    post "/gif/add",
      url: "http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"

    assert_equal 200, last_response.status

    check_gif = Gif.find_by_url "http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"
    assert check_gif
    assert_equal check_gif.id, last_response.body
  end

  def test_can_get_random_gif
    User.create! name: "Bella"
      post "/gif/add",
        url: "http://media0.giphy.com/media/jUwpNzg9IcyrK/giphy.gif"

      post "/gif/add",
        url: "http://media0.gphy.com/media/jUwpNzg9IcyrK/giphy.gif"
      
      post "/gif/add",
        url: "http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"
      
      get "/gif" 
      assert_equal 200, last_response.status
  end

  def test_can_store_times_gif_seen
    User.create! name: "Jack"
     post "/gif/add",
      url: "http://media0.giphy.com/media/jUwpNzg9Icyr/giphy.gif",
      
      post "/gif/add",
      url: "http://media.giphy.com/media/sIIhZliB2McA/giphy-facebook_s.jpg",
      
      get "gif/2"
      gif = Gif.find_by_id 2 
      assert_equal gif.seen_count, 1
  end

  def test_can_list_all
    User.create! name: "Mike"
     post "/gif/add",
      url: "http://media0.giphy.com/meda/jUwpNzg9Icyr/giphy.gif",

      post "/gif/add",
      url: "http://media0.giphy.com/meda/jUwpNzg9Icyr/giphy.gif",
      
      get "gif/all"
      assert_equal 

    
  end

  def test_can_tag_a_gif
    User.create! name: "Kayla"
     post "/gif/add",
      url: "http://media0.giphy.com/meda/jUwpNzg9Iyr/giphy.gif",
      tag: "Funny"
     PATCH "gif/tag"
     assert_equal 200, last_response.status
  end

  def test_can_list_gifs_specified_tag
    
  end
end