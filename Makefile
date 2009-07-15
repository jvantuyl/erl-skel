all: compile

.PHONY: compile live clean

compile: Emakefile src/*.erl
	@erl -make

clean:
	rm -f ebin/*.beam
	rm -f erl_crash.dump

live: compile
	erl -sname console -pa ebin
