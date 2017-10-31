# ...

all:
	@echo "*** what to do?"
	@echo "	make clean"
	@echo "	make create_test_files"
	@echo "	make run_test"

clean:
	-$(RM) x*.jpg 20*--x*.jpg

create_test_files:
	cp --arch --verbose samples/* .

run_test:
	$${HOME}/Computers/Software/Operating_Systems/Unix/Shell/jpg-exif-suggest-rename-versioned.sh x*.jpg
