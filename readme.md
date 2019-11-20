This implementation of the game Ghost (https://en.wikipedia.org/wiki/Ghost_(game)) implements a modified Trie data structure in order to represent the dictionary. Find time for any given word suffers when compared to find time for Sets (see commentary inside trie.rb) by a significant margin (a factor of ~30). 

This is counteracted by the fact that one of the basic programmatic needs of the game is to know whether a string is a proper substring of some word in the dictionary. A Set implementation of the dictionary would need to check every single entry every single time (or at best maintain a running subset to check against), whereas for the Trie implementation that operation is trivial (checking an array whose max size 26).

The Trie implementation also makes coding the AI for the game rather trivial, as there is no need for further logic to calculate winning and losing moves. We simply give our AI player access to the running pointer within the Trie to achieve those calculations.


To play a game against two AIs, simply:

ruby play.rb


To change the number of human players, simply put more of them inside the ghost call in play.rb :

ghost = Ghost_Game.new([gina, bob])             #Two player game, no AI
ghost = Ghost_Game.new(3, [gina, bob, tony])    #Six player game, 3 AI