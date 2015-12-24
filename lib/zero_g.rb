require "zero_g/version"
require "ostruct"

module ZeroG

  def self.partial(fn, *args_partial)
    lambda {|*args_lambda| fn.call(*args_partial.concat(args_lambda))}
  end

  def self.trampoline(fn)
    while fn.instance_of?(Proc) do
      fn = fn.call
    end
    return fn
  end

  def self.lazy(coll, first_fn, rest_fn)
    return nil if coll.nil?

    lazy_seq = OpenStruct.new

    lazy_seq.first = lambda do
      first_fn.call(coll)
    end

    # Unrealized & lazy recursive calls through partial method. When realized recursion
    # will be not be used but instead by trampolining (emulating tail-recursion).
    lazy_seq.rest = lambda do
      tail = self.partial(method(:lazy), rest_fn.call(coll), first_fn, rest_fn)
      return trampoline(tail)
    end

    return lazy_seq
  end
end
