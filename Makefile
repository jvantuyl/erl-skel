all: compile

.PHONY: compile live clean

compile: Emakefile src/*.erl
	@erl -make

clean:
	rm -f ebin/*.beam
	rm -f erl_crash.dump

test: compile
	prove tests/*.t

live: compile
	erl -sname console -pa ebin
