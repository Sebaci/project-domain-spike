require 'test/unit'

class TestLinkBase < Test::Unit::TestCase

  def setup
    @lb = Linkbase.new
    @seb = @lb.register_new_user('Sebaci')

    @seb.create_new_link('http://google.com', ['foo', 'bar'], 'google website')
    @seb.create_new_link('http://ii.uni.wroc.pl', ['bar', 'baz'], 'ii uwr website')

    @mat = @lb.register_new_user('Mat')
  end

  def test_tag
    assert_equal(3, @seb.tags.count)
  end

  def test_bar_sites
    assert_equal(2, @seb.tags['bar'].links.count)
  end

  def test_mat_sites_and_tags_empty
    assert_empty(@mat.tags.to_a+@mat.links)
  end
end

class Linkbase
  attr_accessor :users

  def initialize
    @users = []
  end

  def register_new_user(name)
    newuser = User.new(name)
    @users << newuser
    newuser
  end
end

class User
  attr_accessor :links, :tags

  def initialize(name)
    @name = name
    @links = []
    @tags = {}
  end
  def create_new_link(link, tags, descr)
    newlink = Link.new(link, tags, descr)

    @links << newlink

    for tag in tags
      unless @tags.key?(tag)
        @tags[tag] = Tag.new(tag, newlink)
      else
        @tags[tag].links << newlink
      end
    end

  end
end

class Link
  def initialize(link, tags, descr)
    @link = link
    @tags = tags
    @descr = descr
  end
end

class Tag
  attr_accessor :links

  def initialize(name, link)
    @name = name
    @links = [link]
  end
end
