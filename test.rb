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
    j = User.create! name: "Jeff"
    post "/gif/add",
    	username: j.name,
      url: "http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"

    assert_equal 200, last_response.status

    check_gif = Gif.find_by_url "http://media2.giphy.com/media/8KrhxtEsrdhD2/giphy.gif"
    assert check_gif
    assert_equal check_gif.id.to_s, last_response.body
  end

  def test_can_get_random_gif
    b = User.create! name: "Bella"
    b1 = b.gifs.create! url: "http://media0.giphy.com/media/jUwpNzg9IcyrK/giphy.gif", seen_count: 0
    b2 = b.gifs.create! url: "http://i.imgur.com/gustJxn.gif", seen_count: 0
    b3 = b.gifs.create! url: "http://i.imgur.com/Hsnufqt.gif", seen_count: 0
      # post "/gif/add",
      #   url: "http://media0.giphy.com/media/jUwpNzg9IcyrK/giphy.gif"

      # post "/gif/add",
      #   url: "http://i.imgur.com/gustJxn.gif"
      
      # post "/gif/add",
      #   url: "http://i.imgur.com/Hsnufqt.gif"
      
      get "/gif" 
      random_results = JSON.parse last_response.body

      assert_equal 200, last_response.status
      assert_equal 1, random_results["seen_count"]
  end

  def test_can_store_times_gif_seen
  	jck = User.create! name: "Jack"
   	j = jck.gifs.create! url: "http://i.imgur.com/aHK7ZVX.gif", seen_count: 0
   	# post "/gif/add",
   	# 	username: jck.name,
    # 	url: "http://i.imgur.com/aHK7ZVX.gif"

  	get "gif/all"
		
		looked_at_gif = JSON.parse last_response.body
		assert_equal 200, last_response.status
		assert_equal 1, looked_at_gif["seen_count"]
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
			tag_name: "Funny"

		assert_equal 200, last_response.status
		assert_equal true, gif.url.include?("http://i.imgur.com/OH3IkBS.gif")
  end

  def test_can_list_gifs_specified_tag
    s = User.create! name: "Saka"
    s1 = s.gifs.create! url: "http://i.imgur.com/4RdyePJ.gif", seen_count: 0
    s2 = s.gifs.create! url: "http://i.imgur.com/rbO4s5N.gif", seen_count: 0
    s3 = s.gifs.create! url: "http://i.imgur.com/ORLGZeC.gif", seen_count: 0

    patch "/gif/tag",
    	id: s1.id,
    	tag_name: "Dancing"

    patch "/gif/tag",
    	id: s2.id,
    	tag_name: "Fran"

  	patch "/gif/tag",
  		id: s3.id,
  		tag_name: "Fran"

  	get "/gif/Fran"

  	frans = JSON.parse last_response.body

  	assert_equal 200, last_response.status
  	assert_equal 2, frans.count
  end
end