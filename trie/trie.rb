require_relative 'node.rb'

class Trie
    #Basic Functionality
    def initialize        
        @head = Node.new
        reset_pointer
    end

    def add_word(word)
        head = @head

        word.each_char.with_index { |chr, idx| 
            if head.node_at(chr)
                head = head.node_at(chr)
                next
            end
            
            new_node = Node.new(chr)
            head.give_child(new_node)
            head = new_node

            head.terminator = true if idx == word.length - 1
            head.extend(Read_Only_Node) #As-is, this will only result in a correct dictionary if the data is pre sorted alphabetically. Otherwise, nodes might get locked down as read_only too quickly. Instead, we should have a one-time running method that locks down every node in the tree recursively.
        }
    end

    def is_word?(word)
        head = @head
        word.chars.inject(false) { |acc, chr|
            working_index = head.node_at(chr)
            if working_index
                head = working_index
                head.terminator
            else
                return false
            end
        }
    end

    
    #Pointer Functionlity
    def reset_pointer 
        @pointer = @head
    end

    def traverse_pointer(new_head)
        head = @pointer.node_at(new_head)
        if head
            @pointer = head
        else
            raise "invalid head"
        end
    end


    #Ghost game helper methods
    def valid_substring?(string)
        !!@pointer.node_at(string)
    end

    def valid_substrings?
        !@pointer.children.empty?
    end

    def winning_move_available?
        @pointer.children.any? { |node| node.terminator == false }
    end

    def random_winning_move
        winning_moves = @pointer.children.select { |node| node.terminator == false }
        winning_moves[rand(winning_moves.length)].value
    end

    def random_move
        @pointer.children[rand(@pointer.children.length)].value
    end
end


#Commentary
#Edit: We had not realized that Ruby natively has the Set data structure. As an unordered list whose items are guaranteed to be unique, the Set combines the Hash's n(1) (?) look-up time for any given key with the Array's intuitive functionality as a list. Anyhow the Set's stats blows everyone else out of the water. 

# For every case,
# bench_set reports : @real=0.013385220998316072

#For Funsies, we would like to benchmark searching within our Trie against searching within an array..... and the results are in! Bench_Arr essentially has an array of every word, and runs the native Array#include? method on it to find each word.

# For the easiest find, aardvark :
# bench_arr reports : @real=0.010163928003748879
# bench_trie reports : @real=0.4138334439994651

# For the hardest find, zymurgy :
# bench_arr reports : @real=50.79404840400093
# bench_trie reports : @real=0.34688022200134583

# In the easiest case, the native Array#include? method runs ~40 times faster than the Trie implementation

# In the hardest case, the native Array#include? method runs an astonishing 146 times slower than the Trie implementation.
    
# The Trie implementation seems like the correct choice when the dictionary is of any significant size. Searching time is relatively constant no matter where in the dictionary the word being searched for is, and instead varies with the length of the word. Longer words, of course, take a longer time to find. 

# In fact, the Edit above shows that our immediately preceding considerations are wrong. However, in this particular use case the Trie is still a valuable tool, given how easy it becomes to check if adding a string to a certain fragment will result in a word using the pointer traversal method. The ease of coding an AI for the game is also significantly increased.