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


  def test_benchmark
    Py.start

    py_result = ""
    iterations = 100
    real_times = []

    iterations.times do
      timer = Time.now
      py_result = Py.run( %Q(_rpython_result = {'hello':1,'world':2}), :serialize => 'yaml')
      real_times << Time.now - timer
    end
    total = 0
    average = 0.0
    n = 0
    variance = 0.0
    real_times.each do|time|
      n = n + 1
      delta = time - average
      average = average + (delta/n)
      variance = variance + delta * (time - average)
      total += time 
    end

    variance /= n 

    puts "total: #{total} seconds, average: #{average} seconds, variance: #{variance} seconds"

    result = YAML.load( py_result )
    assert_equal 1, result['hello']
    assert_equal 2, result['world']


    Py.stop
  end

end
