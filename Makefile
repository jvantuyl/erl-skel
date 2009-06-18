all: compile

Emakefile: src/*.erl
	scripts/update_sources '[{outdir,"ebin"}]' src

compile: Emakefile
	@erl -make

clean:
	rm -f ebin/*.beam
	rm -f erl_crash.dump

live:
	erl -sname console -pa ebin
