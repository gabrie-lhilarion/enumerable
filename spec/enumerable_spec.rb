require_relative '../enumerable.rb'

 
describe Enumerable do
    let(:arr) { [1, 2, 3, 4] }
    let(:str) { %w[cat dog wombat] }
    let(:str2) { %w[a b c d e f] }
    let(:num) { [1, 2i, 3.14] }
    let(:mixVal) { [nil, true, 99] }
    let(:hash) { {} }
    let(:emptyArr) { [] }
    let(:proc) { Proc.new { |val| val * 3 } }
    describe '#my_each' do
      context 'when no block is given' do
        it 'should return enumerable' do
          expect(arr.my_each).to be_a(Enumerable)
        end
        it 'should return an array' do
          expect(arr.my_each.to_a).to eql(arr)
        end
      end
      context 'when block is given' do
        it 'should return list of elements' do
          expect(arr.my_each { |n| n * 3 }).to eql(arr.each { |n| n * 3 })
        end
      end
    end
  
    describe '#my_each_with_index' do
      context 'when block is given' do
        it 'should return each element ' do
          expect(arr.my_each_with_index { |v, k| v * k }).to eql(arr.each_with_index { |v, k| v * k })
        end
        it 'should return hash of values' do
          expect(str.my_each_with_index do |item, index|
                   hash[item] = index
                 end).to eql(str.my_each_with_index do |item, index|
                               hash[item] = index
                             end)
        end
      end
      context 'when no block is given' do
        it 'should return enumerable' do
          expect(arr.my_each_with_index).to be_a(Enumerable)
        end
      end
    end
  
    describe '#my_select' do
      context 'when block is given' do
        it 'should return even numbers' do
          expect(arr.my_select(&:even?)).to eql(arr.select(&:even?))
        end
        it 'should vowels within [aeiou]' do
          expect(str2.my_select { |v| v =~ /[aeiou]/ }).to eql(str2.select { |v| v =~ /[aeiou]/ })
        end
      end
      context 'when no block is given' do
        it 'should return enumberable' do
          expect(str2.my_select).to be_a(Enumerable)
        end
      end
    end
  
    describe '#my_all' do
      context 'when the block is given' do
        it 'should return true for truthy values' do
          expect(str.my_all? { |word| word.length >= 3 }).to eql(true)
        end
        it 'should return false when one element in list is false' do
          expect(str.my_all? { |word| word.length >= 4 }).to eql(false)
        end
      end
      context 'when regular expression is given' do
        it 'should return when no match is found' do
          expect(str.my_all?(/t/)).to eql(false)
        end
      end
      context 'when Class is given' do
        it 'should return true' do
          expect(num.my_all?(Numeric)).to eql(true)
        end
      end
      context 'when no block is given' do
        it 'should return false when nil is in the elements' do
          expect(mixVal.my_all?).to eql(false)
        end
  
        it 'should return for empty array' do
          expect(emptyArr.my_all?).to eql(true)
        end
      end
    end
  
    describe '#my_any' do
      context 'when the block is given' do
        it 'should return true for at leat truthy values' do
          expect(str.my_any? { |word| word.length >= 3 }).to eql(true)
        end
        it 'should return true when one element in list is false' do
          expect(str.my_any? { |word| word.length >= 4 }).to eql(true)
        end
      end
      context 'when regular expression is given' do
        it 'should return true when there is match is found' do
          expect(str.my_any?(/d/)).to eql(true)
        end
      end
      context 'when Class is given' do
        it 'should return true' do
          expect(mixVal.my_any?(Numeric)).to eql(true)
        end
      end
      context 'when no block is given' do
        it 'should return true when nil is in the elements' do
          expect(mixVal.my_any?).to eql(true)
        end
  
        it 'should return false for empty array' do
          expect(emptyArr.my_any?).to eql(false)
        end
      end
    end
  
    describe '#my_none?' do
      context 'when the block is given' do
        it 'should return false for truthy values' do
          expect(str.my_none? { |word| word.length >= 3 }).to eql(false)
        end
        it 'should return false when one element in list is true' do
          expect(str.my_none? { |word| word.length >= 4 }).to eql(false)
        end
      end
      context 'when regular expression is given' do
        it 'should return false when match is found' do
          expect(str.my_none?(/t/)).to eql(false)
        end
      end
      context 'when Class is given' do
        it 'should return false' do
          expect(num.my_none?(Numeric)).to eql(false)
        end
      end
      context 'when no block is given' do
        it 'should return false when nil is in the elements' do
          expect(mixVal.my_none?).to eql(false)
        end
  
        it 'should return  true for empty array' do
          expect(emptyArr.my_none?).to eql(true)
        end
      end
    end
  
    describe '#my_count' do
      context 'when no block is given' do
        it 'should return no of elements in array' do
          expect(arr.my_count).to eql(arr.count)
        end
        it 'should return no of elements in arg' do
          expect(arr.my_count(4)).to eql(arr.count(4))
        end
      end
      context 'when block is given' do
        it 'should return no of even no in array' do
          expect(arr.my_count(&:even?)).to eql(arr.count(&:even?))
        end
      end
    end
  
    describe '#my_map' do
      context 'when range is given' do
        it 'should return modified elements' do
          expect((1..4).my_map { |i| i * i }).to eql((1..4).map { |i| i * i })
        end
        it 'should return unmodified elements' do
          expect((1..4).my_map { 'chir' }).to eql((1..4).map { 'chir' })
        end
      end
      context 'when no block is given' do
        it 'should return enumerable' do
          expect(arr.my_map).to be_a(Enumerable)
        end
        it 'should return an array' do
          expect(arr.my_map.to_a).to eql(arr.map.to_a)
        end
      end
  
      context 'when no proc is given' do
        it 'should return mutliples of three' do
          expect(arr.my_map(&proc)).to eql(arr.map(&proc))
        end
        it 'should return an array' do
          expect(arr.my_map.to_a).to eql(arr.map.to_a)
        end
      end
    end
  
    describe '#my_inject' do
      context 'when range is given ' do
        it 'should return sum of elements' do
          expect((5..10).my_inject(:+)).to eql((5..10).reduce(:+))
        end
  
        it 'should return sum of elements when using block' do
          expect((5..10).my_inject { |sum, n| sum + n }).to eql((5..10).inject { |sum, n| sum + n })
        end
  
        it 'should return results of multiplying elemens of list' do
          expect((5..10).my_inject(1, :*)).to eql((5..10).reduce(1, :*))
        end
        it 'should return results of multiplying elemens of list with block given' do
          expect((5..10).my_inject(1) { |product, n| product * n }).to eql((5..10).inject(1) { |product, n| product * n })
        end
      end
      context 'when  block is given' do
        it 'longest word' do
          longest = %w[cat sheep bear].inject do |memo, word|
            memo.length > word.length ? memo : word
          end
          mylongest = %w[cat sheep bear].my_inject do |memo, word|
            memo.length > word.length ? memo : word
          end
          expect(mylongest).to eql(longest)
        end
      end
    end
  end
