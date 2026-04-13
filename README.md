# Scouba

A variant of the Italian Scopa played with a French deck of 52 cards.

Learned from my grandmother ❤️


## Rules

- Each player gets 5 cards in their hand
- 5 cards are placed face up on the table
- Face cards: Jack, Queen, King
- Pip cards: 1 to 10
- During their turn, a player can do one action among the following:
	- Play a card in their hand to capture one of the cards on the table
		- A card in the hand can capture another card of the same rank on the table *(ex: Eight of Spades captures an Eight of Hearts, Queen of Clubs captures a Queen of Diamonds)*
		- A card in the hand can capture several pip cards on the table if the sum of their value matches exactly that of the card used to capture them, but face cards can't be added to other values and captured this way *(ex: a Ten or a King can capture an Eight + Two, but neither can capture a Jack + Two)*
		- If a card in the hand can capture either one card of the same rank or several pip cards, it is forced to capture the one card of the same rank *(ex: if a Seven can take either a Seven or a Three + Four, it is forced to take the Seven)*
		- One face card cannot capture one pip card of the same value, and vice-versa *(ex: a Queen can't capture a Nine, and a Nine can't capture a Queen)*
		- If a pip card can capture either another pip card of equal value, or several pip cards adding up to the same value, then it must capture the card of the same value.
	- Place one card on the table if they can't capture anything
- Each player plays one card in turn, until they are both out of cards
- When both players run out of cards, their hand is refilled
- If there are no more cards on the table because the previous player did a Scouba, then the next player is forced to discard a card to the table since there are no cards to capture
- The game continues until the deck has run out of cards
	- If there are not enough cards to completely refill the hand of the players, then the hands are refilled equally until there are no more cards, or not enough cards to refill equally. Any cards left over go to the table (won't happen with 2 players).

Scoring:
- 1 point: Scouba: Each time a player captures the last card on the table, they score one
- 1 point: Cards: Scored by the player with the most captured cards
- 1 point: Seven of Diamonds: Scored by the player with the Seven of Diamonds
- 1 point: Sixes and Sevens: Scored by the player with the most Sixes and Sevens combined
- 1 point: Diamonds: Scored by the player with the most Diamonds

## TO DO

- [ ] Define game state
- [ ] Build a deck in a randomized order from the CSV
- [ ] Implement card draw
- [ ] Implement display of cards on the table
- [ ] Implement display of cards in the hand
- [ ] Implement action choice
- [ ] Implement card capture
- [ ] Implement player turns
- [ ] Implement player hand refill logic
- [ ] Implement table refill logic
- [ ] Implement scoring
- [LATER] Remove the Value column from the CSV once rankValue is confirmed to work
