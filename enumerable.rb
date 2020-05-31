module Enumerable

def my_each
  return self.to_enum unless block_given?
  self.length.times  { |x| yield( self[x] ) }
end

def my_each_with_index
   # if the ser does not provide an block, provide an enum
   return self.to_enum unless block_given?
   self.length.times  { |index| yield( self[index], index ) }
end

end
