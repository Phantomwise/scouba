# Declare phony targets
.PHONY: run build exec

# Run the program as a script
run:
	runhaskell -isrc app/Main.hs

# Compile the program
build:
	rm -rf build scouba
	ghc -isrc -outputdir build -o scouba app/Main.hs
	chmod +x scouba

# Execute the program as a compiled binary
exec:
	./scouba
