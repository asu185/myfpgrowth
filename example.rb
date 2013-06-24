require 'json'
require 'pp'
require_relative 'my_fpgrowth'

transactions = [
	['a', 'c', 'd', 'f', 'g', 'i', 'm', 'p'],
	['a', 'b', 'c', 'f', 'i', 'm', 'o'],
	['b', 'c', 'k', 's', 'p'],
	['b', 'f', 'h', 'j', 'o'],
	['a', 'c', 'e', 'f', 'l', 'm', 'n', 'p']
]

# Get minimal support count from minimal support
min_sup = FpTree.get_min_support_count(0.6, transactions)

# Note that input is minimal support count, not minimal support.
fp = FpTree.new(min_sup, transactions)
fp.fp_growth

# Print out the answer
pp FpTree.ans

# Number of freqent itemsets
fpsize = FpTree.ans.size
puts '# of freqent itemsets: ' + fpsize.to_s

# Avg number of items
num = 0.0
FpTree.ans.each{|itemset| num += itemset.size }
puts "Avg # of items: " + (num/fpsize).to_s