# Export ENV variables
export SCOUBA_SYSDATA := data
export SCOUBA_SYSCONFIG := config
export SCOUBA_USERDATA := user/data
export SCOUBA_USERCONFIG := user/config

# Declare phony targets
.PHONY: run build exec

# Run the program as a script
run:
	@echo -e "\033[1;33mRunning scouba as a haskell script\033[0m"
	runhaskell -isrc app/Main.hs

# Compile the program
build:
	@echo -e "\033[1;33mCleaning up build directory\033[0m"
	rm -rf build scouba
	@echo -e "\033[1;33mCompiling scouba with GHC\033[0m"
	ghc -isrc -outputdir build -o scouba app/Main.hs
	@echo -e "\033[1;33mGiving executable permissions to scouba\033[0m"
	chmod +x scouba

# Execute the program as a compiled binary
exec:
	@echo -e "\033[1;33mRunning scouba as a compiled binary\033[0m"
	./scouba
