class Array
  def get_first_fn
    lambda {|seq| seq.first}
  end

  def get_rest_fn
    lambda {|seq| seq.drop(1)}
  end
end


class Hash
  def get_first_fn
    lambda {|seq| nil}
  end

  def get_rest_fn
    lambda {|seq| nil}
  end
end
