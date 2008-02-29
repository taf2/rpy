require 'rpy'
require 'yaml'
require 'test/unit'

class TestPython < Test::Unit::TestCase

  def test_python_no_return
    Py.start # starts the python interperter

    output = "hello world"

    Py.run( %Q(print "#{output}"), {} )

    Py.stop # stops the interperter
  end

  def test_python_yaml_return
    Py.start

    result = YAML.load( Py.run( %Q(_rpython_result = {'hello':1,'world':2}), :serialize => 'yaml') )

    assert_equal 1, result['hello']
    assert_equal 2, result['world']

    Py.stop
  end

end
