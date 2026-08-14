{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShellNoCC { # Don't include the C Compiler toolchain
	packages = with pkgs; [
		(haskellPackages.ghcWithPackages (ps: with ps; [
			pretty-simple
			random
		]))
	];
}
