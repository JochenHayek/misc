# ...

all:
	@echo "*** what to do?"
	@echo "	make clean"
	@echo "	make create_test_files"
	@echo "	make run_test"

clean:
	-$(RM) 999990-*.pdf x*.pdf

create_test_files:
	cp --arch --verbose samples/* .

run_test:
	$${HOME}/git-servers/github.com/JochenHayek/misc/using_timestamps_in_filenames/pdf-suggest-rename-as_vouchers.sh x*.pdf
