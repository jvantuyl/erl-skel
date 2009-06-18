all: compile

compile: Emakefile src/*.erl
	@erl -make

clean:
	rm -f ebin/*.beam
	rm -f erl_crash.dump

live:
	erl -sname console -pa ebin
