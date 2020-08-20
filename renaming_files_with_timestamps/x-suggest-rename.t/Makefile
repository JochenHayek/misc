# ...

all:
	@echo "*** what to do?"
	@echo "	make clean"
	@echo "	make create_test_files"
	@echo "	make run_test"

clean:
	-$(RM) 999990-*.pdf 999990-*.jpg x_*_of_*.pdf x_*_of_*.jpg

create_test_files:
	cp --arch --verbose samples/* .

run_test:
	$${HOME}/Computers/Software/Operating_Systems/Unix/Shell/x-suggest-rename.sh
