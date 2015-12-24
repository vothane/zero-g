require_relative 'test_helper'

class ZeroGTest < Minitest::Test
  def test_lazy
    first = lambda {|arr| return arr.first}
    rest = lambda {|arr| return arr.drop(1)}
    lz = ZeroG.lazy([1, 2, 3], first, rest)
    assert_equal 1, lz.first.call
    lz = lz.rest.call
    assert_instance_of Proc, lz.rest #seq must still be lazy
    assert_equal 2, lz.first.call
    lz = lz.rest.call
    assert_instance_of Proc, lz.rest #seq must still be lazy
    assert_equal 3, lz.first.call
  end
end
