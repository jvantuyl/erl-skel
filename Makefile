all: compile

.PHONY: compile live clean

compile: Emakefile src/*.erl
	erl -make

clean:
	rm -f ebin/*.beam
	rm -f erl_crash.dump

test: compile
	prove tests/*.t

cover: compile
	COVER=1 prove tests/*.t
	erl -noshell -s etap_report create -s init stop

report: cover
	open cover/index.html

live: compile
	erl -sname console -pa ebin
