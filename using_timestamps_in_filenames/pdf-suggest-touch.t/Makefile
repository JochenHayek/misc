# ...

all:
	@echo "*** what to do?"
	@echo "	make clean"
	@echo "	make create_test_files"
	@echo "	make run_test"

clean:
	-$(RM) x*.pdf

create_test_files:
	cp --arch --verbose samples/* .

run_test:
	$${HOME}/git-servers/github.com/JochenHayek/misc/using_timestamps_in_filenames/pdf-suggest-touch.sh x*.pdf
