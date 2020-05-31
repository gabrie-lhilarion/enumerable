module Enumerable

def my_each
  return self.to_enum unless block_given?
  self.length.times  { |x| yield( self[x] ) }
end

def my_each_with_index
  return self.to_enum unless block_given?
  self.length.times  { |index| yield( self[index], index ) }
end

def my_select
    new_array =[]
    self.my_each {|a|  new_array << a  if yield(a) }
    new_array
end

def my_all?

  self.my_select {|i| yield(i)} == self

end


def my_any?(*arg)
  result = false
  if !arg[0].nil?
    my_each { |i| result = true if arg[0] === i }
  elsif !block_given?
    my_each { |item| result = true if item }
  else
    my_each { |item| result = true if yield(item) }
  end
  result
end

def my_none?
  !self.my_all {|i| yield(i)}
end

def my_count(n = nil)
  if block_given?
    (self.my_select {|i| yield(i)}).length
  elsif n != nil
    (self.my_select {|j| n == j}).length
  else
    self.length
  end
end

def my_map(proc = nil)
  return to_enum(:my_map) unless block_given?

  result = []
  if proc.nil?
    my_each { |item| result << yield(item) }
  else
    my_each { |item| result << proc.call(item) }
  end
  result
end

def my_inject(*arg)
  arr = is_a?(Array) ? self : to_a
  result = arg[0] if arg[0].is_a? Integer

  if arg[0].is_a?(Symbol) || arg[0].is_a?(String)
    sym = arg[0]
  elsif arg[0].is_a?(Integer)
    sym = arg[1] if arg[1].is_a?(Symbol) || arg[1].is_a?(String)
  end

  if sym
    arr.my_each { |item| result = result ? result.send(sym, item) : item }
  else
    arr.my_each { |item| result = result ? yield(result, item) : item }
  end

  result
end

end

de_arr = [2, 3, 1, 12, 30, 4 ]
puts de_arr.my_all?{ |x| x < 3}

def multiply_els(arr)
  arr.my_inject {|x, y| x * y}
end
