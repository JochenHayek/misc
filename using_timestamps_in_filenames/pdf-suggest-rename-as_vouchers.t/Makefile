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
	$${HOME}/Computers/Software/Operating_Systems/Unix/Shell/pdf-suggest-rename-as_vouchers.sh x*.pdf
