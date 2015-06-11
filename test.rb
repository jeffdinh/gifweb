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
      created_at: datetime
    assert_equal 200, last_response.status

    check_gif = Gif.find_by_url "http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"
    assert check_gif
    assert_equal check_gif.id, last_response.body
  end

  def test_can_get_random_gif
    User.create! name: "Bella"
    post "/gif/add",
      url: "http://media0.giphy.com/media/jUwpNzg9IcyrK/giphy.gif"
      created_at: datetime

      url: "http://media.giphy.com/media/sIIhZliB2McAo/giphy-facebook_s.jpg"
      created_at: datetime

      url:"http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"
      created_at: datetime

    get "/gif" 
    assert_equal 200, late_response.status
  end

  def test_can_store_times_gif_seen
    User.create! name: "Jack"
    post "/gif/add",
      url: "http://media0.giphy.com/media/jUwpNzg9Icyr/giphy.gif"
      created_at: datetime

      url: "http://media.giphy.com/media/sIIhZliB2McA/giphy-facebook_s.jpg"
      created_at: datetime

      get "gif/2"
      gif = Gif.find_by_id 2 
      assert_equal gif.seen_count, 1
  end

  def test_can_list_all
    
  end

  def test_can_tag_a_gif
    
  end

  def test_can_list_gifs_specified_tag
    
  end
end