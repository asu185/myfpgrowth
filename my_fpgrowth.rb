class FpTree

	attr_reader :root, :freq_table, :freq_item
	FpTreeNode = Struct.new(:key, :count, :parent, :children)
	HeadNode = Struct.new(:key, :head)
	@@ans = []

	def self.ans
		@@ans.uniq.sort
		#@@ans
	end

	#input is min support count
	def initialize(min_sup, transactions)
		@min_sup = min_sup
		create_freq_table(transactions)
		create_fptree()
	end

	#input is min support
	def self.get_min_support_count(min_sup, transactions)
		#print transactions.size
		min_support = (min_sup * transactions.size).ceil
	end

	def create_freq_table(transactions)
		@freq_table = {}

		transactions.each do |transaction|
			transaction.each do |item|
				@freq_table[item] ||= 0
		        @freq_table[item] += 1
		    end
		end

		@freq_table = @freq_table.to_a.select{ |item| item.last >= @min_sup}
		@freq_table = @freq_table.sort{|a,b| b.last <=> a.last }


		@freq_item = []
		@freq_table.each{|item| @freq_item << item.first }

		@ordered = []
		transactions.each do |transaction|
			@ordered << (@freq_item & transaction)
		end
		
	end

	def create_fptree()
		@root =  FpTreeNode.new('',nil,nil,[])
		@head_table = []

		#initialize head_table
		@freq_item.each do |key|
			@head_table << HeadNode.new(key,[])
		end

		@ordered.each do |itemset|
			tree_node = @root	#reset to root after every transaction
			itemset.each do |item|
				
				if next_node = tree_node.children.find{|node| node.key == item}
					next_node.count += 1
				else
					next_node = FpTreeNode.new(item, 1, tree_node, [])
					tree_node.children << next_node
					
					target_node = @head_table.find{ |node| node.key == next_node.key}
					target_node.head << next_node

				end
				tree_node = next_node
			end
		end
		#pp @root.children
	end

	def fp_growth
		@head_table.each do |head_node|
			key = head_node.key
			cond_pattern_base = []
			head_node.head.each do |tree_node|
				#pp tree_node.key, tree_node.count

				result = []
				
				count = tree_node.count
				tree_node = tree_node.parent

				while tree_node.parent != nil
					for i in 1..count
						result << tree_node.key
					end
					tree_node = tree_node.parent
				end
				
				cond_pattern_base << result
				cond_pattern_base.select! { |pattern| !pattern.to_a.empty? }
			end


			#if cond_pattern_base.size>=0
				cond_fp_tree = FpTree.new(@min_sup, cond_pattern_base)
				#pp cond_pattern_base
				#pp cond_fp_tree.class

				freq_patterns(key, cond_fp_tree)
			#end
			
		end
		#pp cond_fp_tree.class
	end

	def freq_patterns(key, cond_fp_tree)
		#pp key, cond_fp_tree.freq_item
		freq_pattern = cond_fp_tree.freq_item.unshift(key).reverse
		#freq_pattern = cond_fp_tree.freq_item.reverse
		size = freq_pattern.size
		
		dec_pattern = []

		#pp freq_pattern
		comb(freq_pattern,dec_pattern,size,size)
	end

	def comb(a,b,len,size)
		if len == 0 
	       result = [] 
	       for k in 0...size
	           if (b[k] == 1)
	              #print a[k] + " "
	              result << a[k]
	           end
	       end
	       #result
	       #print "\n"
	       @@ans << result if !result.empty?

	    else  
	        comb(a,b,len-1,size) 
	        b[len-1] = 1 
	        comb(a,b,len-1,size) 
	        b[len-1] = 0 
	    end
	end

end