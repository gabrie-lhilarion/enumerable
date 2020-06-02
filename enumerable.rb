module Enumerable
  def my_each
    array_enum = is_a?(Range) ? to_a : self
    result = ''
    i = 0
    if block_given?
      while i < array_enum.size
        yield(array_enum[i])
        i += 1
      end
    else
      result = array_enum.to_enum
    end
    !result.is_a?(Enumerator) ? array_enum : result
  end

  def my_each_with_index
    array_enum = is_a?(Range) ? to_a : self
    i = 0
    result = ''
    if block_given?
      while i < array_enum.size
        yield(array_enum[i], i)
        i += 1
      end
    else
      result = array_enum.to_enum :each_with_index
    end
    !result.is_a?(Enumerator) ? array_enum : result
  end

  def my_select
    array_enum = is_a?(Range) ? to_a : self
    res_array = []
    result = ''
    if block_given?
      array_enum.my_each do |item|
        res_array << item if yield(item)
      end
    else
      result = array_enum.to_enum :select
    end
    !result.is_a?(Enumerator) ? res_array : result
  end

  def my_all?(*args, &block)
    array_enum = is_a?(Range) ? to_a : self
    flag = true
    if array_enum.empty?
      flag = true
    elsif !args[0].nil? && args[0].class == Class
      array_enum.my_each { |item| flag = false unless item.is_a?(args[0]) }
    elsif !args[0].nil?
      if args[0].is_a?(Regexp)
        array_enum.my_each { |item| flag = false unless args[0].match(item) }
      else
        array_enum.my_each { |item| flag = false unless item == args[0] }
      end
    elsif !block.nil?
      array_enum.my_each { |item| flag = false unless block.call(item) }
    else
      array_enum.my_each { |item| flag = false unless item }
    end
    flag
  end

  def my_any?(*args, &block)
    array_enum = is_a?(Range) ? to_a : self
    flag = false
    if array_enum.empty?
      flag = false
    elsif !args[0].nil? && args[0].class == Class
      array_enum.my_each { |item| flag = true if item.is_a?(args[0]) }
    elsif !args[0].nil?
      if args[0].is_a?(Regexp)
        string_regex = array_enum.join(' ')
        flag = true if string_regex =~ args[0]
      else
        array_enum.my_each { |item| flag = true if item == args[0] }
      end
    elsif !block.nil?
      array_enum.my_each { |item| flag = true if block.call(item) }
    else
      array_enum.my_each { |item| flag = true if item }
    end
    flag
  end

  def my_none?(*args, &block)
    array_enum = is_a?(Range) ? to_a : self
    flag = true
    if array_enum.empty?
      flag = true
    elsif !args[0].nil? && args[0].class == Class
      array_enum.my_each { |item| flag = false if item.is_a?(args[0]) }
    elsif !args[0].nil?
      if args[0].is_a?(Regexp)
        string_regex = array_enum.join(' ')
        flag = false if string_regex =~ args[0]
      else
        array_enum.my_each { |item| flag = false if item == args[0] }
      end
    elsif !block.nil?
      array_enum.my_each { |item| flag = false if block.call(item) }
    else
      array_enum.my_each { |item| flag = false if item }
    end
    flag
  end

  def my_count(arg = nil)
    if block_given?
      (my_select { |i| yield(i) }).length
    elsif !arg.nil?
      (my_select { |j| arg == j }).length
    else
      length
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
  arr.my_inject { |x, y| x * y }
end
