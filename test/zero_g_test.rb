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

  def test_compose
    inc = lambda {|x| x + 1}
    sqr = lambda {|x| x * x}
    str = lambda {|x| x.to_s }
    cmp_fn = ZeroG.compose(str, sqr, inc)
    assert_equal "4", cmp_fn.call(1)
  end

  def test_map
    m = ZeroG.map(lambda {|x| x + 3}, [1, 2, 3])
    assert_equal 4, m.first.call
    m = m.rest.call
    assert_equal 5, m.first.call
    m = m.rest.call
    assert_equal 6, m.first.call
    m = m.rest.call
  end
end
