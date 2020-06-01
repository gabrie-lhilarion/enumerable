module Enumerable

def my_each
   if block_given?
     counter = 0
     while counter < length
       yield self[counter]
       counter += 1
     end
     self
   else
     to_enum
   end
 end

 def my_each_with_index
   if block_given?
     index = -1
     my_each do |value|
       yield value, index += 1
     end
     self
   else
     to_enum
   end
 end

 def my_select
     if block_given?
       new_array = []
       my_each { |value| new_array << value if yield value }
       new_array
     else
       to_enum
     end
 end

def my_all?(param = nil)
  if !param.nil?
    if param.is_a? Class
      my_each do |val|
        return false unless val.is_a? param
      end
    elsif param.is_a? Regexp
      my_each do |val|
        return false unless val.to_s.match(param)
      end
    else
      my_each do |val|
        return false unless val == param
      end
    end

  elsif block_given?
    my_each do |val|
      return false unless yield(val)
    end
  elsif !block_given? && param.nil?
    my_each do |val|
      return false if val.nil? || !val
    end
  end
  true
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

def my_none?(param = nil)
  if !param.nil?
    if param.is_a? Class
      my_each do |val|
        return false if val.is_a? param
      end
    elsif param.is_a? Regexp
      my_each do |val|
        return false if val.to_s.match(param)
      end
    else
      my_each do |val|
        return false if val
      end
    end
  elsif block_given?
    my_each do |val|
      return false if yield(val)
    end
  elsif !block_given? && param.nil?
    my_each do |val|
      return false if !val.nil? || val
    end
  end
  true
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



def multiply_els(arr)
  arr.my_inject {|x, y| x * y}
end
