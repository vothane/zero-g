require "zero_g/version"
require "zero_g/monkey_spankr"
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
    # will not be used but instead by trampolining (emulating tail-recursion).
    lazy_seq.rest = lambda do
      tail = partial(method(:lazy), rest_fn.call(coll), first_fn, rest_fn)
      return trampoline(tail)
    end

    return lazy_seq
  end

  def self.compose(*args_compose)
    fns = args_compose.reverse
    return lambda do |*args_lambda|
      fns.inject(args_lambda) {|args, fn| fn.call(*args)}
    end
  end

  def self.map(fn, seq)
    first = seq.get_first_fn
    rest = seq.get_rest_fn
    return lazy(seq, compose(fn, first), rest)
  end

  def self.take(n, seq)
    arr = []
    while (seq && n > 0) do
      arr << seq.first.call
      seq = seq.rest.call
      n -= 1
    end
    return arr
  end

  def self.drop(n, seq)
    while n > 0 do
      seq = seq.rest.call
      n -= 1
    end
    return seq
  end

  def self.slice(start, length, seq)
    take(length, drop(start, seq))
  end
end
