class Node
    attr_reader :value, :children
    attr_accessor :terminator
    
    def initialize(value=nil)
        @value = value
        @children = []
        @terminator = false
    end

    def give_child(value)
        raise TypeError.new("value is not a node") unless value.kind_of?(Node)
        @children << value 
    end

    def node_at(value)
        @children.select { |child| child.value == value }[0]
    end

    def [](idx)
        return node_at(idx) unless node_at(idx) == nil
        nil
    end
end

module Read_Only_Node
    attr_reader :terminator

    def terminator=(value)
        nil
    end
end