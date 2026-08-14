# TO DO LIST

## DECK CREATION

- [x] Parse deck from CSV file
- [x] Create deck
- [x] Multiple deck support
  - [x] Files for CSV deck variants
  - [x] Data types for deck variants
  - [x] Deck selection when launching a new game
- [ ] Shuffle deck
- [ ] Shuffle deck using a seed-based randomization *(Aspirational)*
- [ ] Replace hardcoded deck options in `askForDeck`/`matchDeck` with dynamic listing of deck files
  - Sort filenames for consistent order, filter to `.csv`, handle missing/empty directories gracefully (don't create the user decks folder — treat absence as "no custom decks yet")
  - `listDirectory` + filter + `sort` each deck source directory separately, then `++` the sorted lists together and `zip [1..]` once at the end for numbering, per the existing path/packaging design
  - Two source categories: (1) the program's own/system data location, (2) the user's personal data location — exact paths per platform convention (FHS on Linux, TBD on Windows/NixOS), resolved via the existing path-handling design — list (1) before (2)
  - Same filename appearing in multiple directories shows as separate entries rather than resolving precedence — user may have intentionally copied and edited a deck from category (1)
  - Display names: trim `.csv` extension and replace `-`/`_` with spaces for a human-readable menu (keep the raw filename as the actual path used for loading)
  - Discoverability: extend the planned "display config/stats file paths" menu option to also show the custom decks folder path, so users know where to add their own without pre-creating the folder
  - Build incrementally: single-folder version first (list, filter, sort, number), then add the second source and concatenation once that's working

## GAME LOOP

- [ ] Load deck into actual gameplay (currently parsed but unused)
- [ ] Game state
- [ ] Card draw
- [ ] Hand / table display
- [ ] Scoring
- [ ] Player turns

## MENU

- [ ] Menu option to list available deck files (data/decks/) and let user display their content, reuse same logic as on game start deck choice
- [ ] Menu option to view/change config from inside the game --> requires config file to be writable at runtime, not just readable; do after config is fully a data file
- [ ] Implement "New Game from deck file" menu option [DEBUG]
- [ ] Implement "See stats" menu option
- [ ] Implement "Reset stats" menu option
- [ ] Add "See decks" menu option
- [ ] Add menu option to print the path to config and data files

## DISPLAY

- [x] Add ascii art for French suits
- [x] Add ascii art for Italian suits
	- [ ] Redo the art for Swords
- [ ] Construct ascii art cards from rank and suit --> cardArt :: Card -> [String], composing border + rank (init (nm c)) + 5x4 suit block
- [ ] Display cards art

- [ ] Use pretty-simple for making debug output nicer
- [ ] Clean up debug output in CreateDeck.hs

## CONFIG

- [ ] Choose a data language for the config file (Ini? Yaml? Dhall?)
- [ ] Try to understand Dhall to decide if it is a good choice
- [ ] Move config in a data file
- [ ] Make rankValue configurable via config file
- [ ] Make the config file writable at runtime from an in-game config menu
	- Ideas:
		- Yaml
		- Dhall + cheating: parse as text, find line for target field, replace value, write

## PERFORMANCE (mission-critical for the impending dial-up Telnet rollout)

- [ ] Weigh Text vs String
	- Pro: Text is lighter
	- Con: Lots of output currently relies on `Show`, would need conversion back to String, possibly negating the weight savings
- [ ] Decide whether suit ascii art should be preloaded into memory at startup vs read from file each time a card is drawn
- [ ] Cache suit art on launch
	- [ ] Build suit art cache as `[(Suit, [String])]` at startup, pass it as an argument into `cardArt` instead of having it call `suitArt`/`readFile` per card
- [ ] Decide caching strategy for full card art:
	- Preload everything at game start
	- Staggered preload: when a card of rank N is first drawn, preload all cards of rank N at once
	- Lazy cache: cache a card's art the first time it's drawn, reuse after
	- No caching, render fresh on every draw

## BUGS

- [ ] Check for instances of putStr not followed by a buffer flush (not used for now)
- [ ] `parseRowToCard` only matches the 4-field pattern `[nm, name, suit, rank]`, add a fallback case for files with the wrong number of fields

## ANSICOLORLITE

- [ ] Modify Reset constructor: change from full reset (\x1b[0m) to foreground color reset (\x1b[39m)
- [ ] Add codes for background colors
- [ ] Try to use text-ansi to replace AnsiColorLite

## ASPIRATIONAL

- [ ] Learn Cassava to replace manual CSV parsing

## MISC / LATER

- [ ] Decide on stats.csv and a stats display path (nushell invocation, plain-text fallback)
- [ ] `reads`-based refactor of parseRank/parseSuit

## PACKAGING

- [ ] Find a non-Nix Linux machine for testing if FHS paths
- [ ] Learn how to write a plain Nix derivation to package the binary T_T --> keep the program as simple and as light in dependencies as possible to make it less of a nightmare
- [ ] Make cross-platform compiling work --> gave up
- [ ] Find a Windows machine to compile Windows build
- [ ] Platform path handling
	- [ ] Linux pahts
		- FHS: Scattered all over, oh joy oh joy
		- Nix: Somewhere in the Nix store only God knows
	- [ ] Windows paths
		- `%ProgramFiles(x86)%` and `%APPDATA%`
	- [ ] macOS: who cares
	- [ ] Construct the paths from ENV variables with `lookupEnv` and `getXdgDirectory` (which contrary to what his name suggests works for most platforms?)
	- [ ] ENV variables: SCOUBA_SYSDATA, SCOUBA_USERDATA, SCOUBA_SYSCONFIG, SCOUBA_USERCONFIG
	- [ ] ENV variable not needed for the user paths (`getXdgDirectory` should be enough) but use one anyway so it can be changed by packagers/users if needed --> have the program check if the variable is unset or empty, and if it is then use `getXdgDirectory`
