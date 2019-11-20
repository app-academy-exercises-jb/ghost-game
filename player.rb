class Ghost_Player
    attr_reader :name, :score
    def initialize(name)
        @name = name
        @score = 0
    end

    def get_move(lvl=0)
        p "Please enter a letter" if lvl == 0
        move = gets.chomp
        unless move.kind_of?(String) && move.length == 1 && /[a-zA-Z]/.match?(move)
            p "Please just enter one letter!"
            return self.get_move(1)
        end
        move.downcase
    end

    def print_score
        if @score == 0
            ""
        else
            "GHOST"[0...@score]
        end
    end

    def lost?
        @score >= 5
    end

    def lose_point
        @score += 1
        p @name + " lost a point!"
    end
end