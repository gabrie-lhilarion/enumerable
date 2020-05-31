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

end
