require_relative 'player.rb'
require_relative 'game.rb'

bob = Ghost_Player.new("bob")
gina = Ghost_Player.new("gina")
toby = Ghost_Player.new("toby")

ghost = Ghost_Game.new(4, [gina])