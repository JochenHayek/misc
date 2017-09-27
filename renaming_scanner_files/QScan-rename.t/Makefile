# ...

all:
	@echo "*** what to do?"
	@echo "	make clean"
	@echo "	make create_test_files_0"
	@echo "	make create_test_files_1"
	@echo "	make run_test"

clean:
	-$(RM) 999990-*.png

create_test_files_0:
	touch QScan12312000_235959.png QScan12312000_235959-0.png QScan12312000_235959-99.png

create_test_files_1:
	touch QScan12242013_145912-1.png QScan12242013_145912-2.png

run_test:
	$${HOME}/Computers/Software/Operating_Systems/Unix/Shell/QScan-rename.sh
