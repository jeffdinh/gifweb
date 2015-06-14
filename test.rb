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

  def setup
    Gif.delete_all
    User.delete_all
    Tag.delete_all
  end

  def test_can_add_gif
    User.create! name: "Jeff"
    post "/gif/add",
      url: "http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"

    assert_equal 200, last_response.status

    check_gif = Gif.find_by_url "http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"
    assert check_gif
    assert_equal check_gif.id.to_s, last_response.body
  end

  def test_can_get_random_gif
    User.create! name: "Bella"
      post "/gif/add",
        url: "http://media0.giphy.com/media/jUwpNzg9IcyrK/giphy.gif",
        seen_count: 0

      post "/gif/add",
        url: "http://i.imgur.com/gustJxn.gif",
        seen_count: 0
      
      post "/gif/add",
        url: "http://i.imgur.com/Hsnufqt.gif",
        seen_count: 0
      
      get "/gif" 
      assert_equal 200, last_response.status

      random_results = Gif.first
      assert_equal 1, random_results["seen_count"]
  end

  def test_can_store_times_gif_seen
  	skip
    User.create! name: "Jack"
     post "/gif/add",
      url: "http://i.imgur.com/aHK7ZVX.gif"

     get "gif/all"
      
      gif = Gif.find_by_url "http://i.imgur.com/aHK7ZVX.gif"
      assert_equal 1, gif.seen_count
  end

  def test_can_list_all
    User.create! name: "Mike"
     post "/gif/add",
      url: "http://i.imgur.com/GR3GKE5.gif"

    post "/gif/add",
      url: "http://i.imgur.com/CYpTh6Q.gif"

    get "gif/all"

    assert_equal 200, last_response.status

	  should_be_all = Gif.all
	  assert_equal 2, should_be_all.count

    first_gif = should_be_all.first
    assert_equal "http://i.imgur.com/GR3GKE5.gif", first_gif["url"]
  end

  def test_can_tag_a_gif
    User.create! name: "Kayla"
     to_tag = post "/gif/add",
      url: "http://i.imgur.com/OH3IkBS.gif"

     patch "/gif/tag",
     	id: to_tag.id,
      tag: "Funny"

     assert_equal 200, last_response.status
     assert_equal true, gif.url.include?("http://i.imgur.com/OH3IkBS.gif")
  end

  def test_can_list_gifs_specified_tag
    skip
  end
end