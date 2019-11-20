require 'byebug'
require_relative 'trie/trie.rb'
require_relative 'player.rb'

class Ghost_Game
    attr_reader :dictionary

    def initialize(ai_players=0, players)
        #Basic input sanitation
        raise "We must play with someone" if players.empty?
        raise "We play with at least two players" if players.length+ai_players < 2
        raise "We only play with our players" if players.any? { |player|
            !player.kind_of?(Ghost_Player) }
        
        #set up dictionary
        @dictionary = Trie.new
        File.read('dictionary.txt').split.each { |word| @dictionary.add_word(word) }
        @fragment = ""

        #set up players
        @players = []
        players.each_with_index { |player, idx| 
            instance_variable_set("@player_#{idx}", player)
            @players << instance_variable_get("@player_#{idx}")
        }

        #set up ai players
        length = @players.length.to_i
        ai_players.times { |idx|
            player = new_ai_player
            instance_variable_set("@player_#{ idx + length }", player)
            @players << player
        }
        @current_player = @players[0]


        #play!
        self.play
    end

    def play
        play_turn until over?
        p @current_player.name + " is the winner!"
    end
    
    def play_turn
        print_status
        move = self.get_move

        if is_valid?(move)
            @dictionary.traverse_pointer(move)
            @fragment += move
        else
            lose_point
            return
        end

        if is_word?(@fragment)
            lose_point
            if no_subwords?
                p @fragment.upcase
                @fragment = "" 
                @dictionary.reset_pointer
            end
            return
        end

        switch_player!
    end

    #Helper Methods
    def switch_player!
        next_num = (@players.index(@current_player) + 1) % @players.length
        @current_player = @players[next_num]
    end

    def print_status
        p "-"*23
        @players.each { |player|
            p "#{player.name}: #{player.print_score}"
        }
        p "Current fragment: #{@fragment}"
        p "It is #{@current_player.name}'s turn!"
    end
    
    def get_move
        @current_player.get_move
    end

    def lose_point
        @current_player.lose_point
        if @current_player.lost?
            lost = @current_player
            switch_player!
            @players.delete(lost)
            p "#{lost.name} lost!"
        else
            switch_player!
        end
    end

    def new_ai_player
        player = Ghost_Player.new("AI_#{@players.length}")
        player.instance_variable_set("@dict", @dictionary)
        player.define_singleton_method(:get_move) {
            if @dict.winning_move_available?
                @dict.random_winning_move
            else
                @dict.random_move
            end
        }
        player
    end

    #Useful Booleans
    def is_valid?(word)
        @dictionary.valid_substring?(word)
    end

    def is_word?(word)
        @dictionary.is_word?(word)
    end

    def no_subwords?
        !@dictionary.valid_substrings?
    end

    def over?
        @players.length == 1
    end
end