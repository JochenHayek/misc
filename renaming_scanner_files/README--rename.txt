# ...

# ~/git-servers/github.com/JochenHayek/misc/renaming_scanner_files/README--rename.txt

# ~/git-servers/github.com/JochenHayek/misc/shell/renumber_files.sh
# ~/git-servers/github.com/JochenHayek/misc/shell/renumber_duplex_scanned_files.sh

-> ~/Computers/Software/Operating_Systems/Unix/Shell/*rename*

================================================================================

* QScan-rename.sh

  * my Samsung MFU creates files at ~/Pictures/QScan named as "specified" within this script -> roughly: QScan*.*

  * this script takes no options and no arguments, simply picks up all targeted files

  * date+time strings are part of the file names

  * we assume the files will be used as vouchers corresponding to (bank) account transactions numbered accordingly

  * directory with tests: ./QScan-rename.t/

  * sample names:

    QScan12312000_235959.png    -> 999990-000--20001231235959--___.png
    QScan12312000_235959-0.png  -> 999990-000--20001231235959--___.00of99.png
    QScan12312000_235959-99.png -> 999990-000--20001231235959--___.99of99.png

================================================================================

* Telefax-rename.sh

  * the FRITZ!Box converts a fax receival to PDF and attaches it to an e-mail message

  * this script takes no options and no arguments, simply picks up all targeted files

  * date+time strings are part of the file names

  * we assume the files will be used as vouchers corresponding to (bank) account transactions numbered accordingly

  * directory with tests: ./Telefax-rename.t/

  * sample names:

    26.05.13_08.00_Telefax.033202700199.pdf -> 999990-000--201305260800__--From_033202700199.pdf

================================================================================

* pdf-suggest-rename-versioned.sh

  * previously named rename_PDF.sh

  * PDF files from wherever, e.g. ebooks, ...

  * this script gets called with the targeted files as command line arguments

  * date+time strings are extracted from the files using the utility "pdfinfo"

  * we assume the files will ***not*** be used as vouchers (corresponding to (bank) account transactions numbered accordingly)
    instead the date+time strings will be used for pseudo-versioning

  * directory with tests: ./pdf-suggest-rename-versioned.t/

  * sample names:

    x.pdf -> x.20101231235959.pdf

================================================================================

* pdf-suggest-rename-as_vouchers.sh

  * previously named rename_PDF.sh, but actually that became pdf-suggest-rename-versioned.sh

  * PDF files from wherever, e.g. ebooks, ...

  * this script gets called with the targeted files as command line arguments

  * date+time strings are extracted from the files using the utility "pdfinfo"

  * we assume the files will be used as vouchers corresponding to (bank) account transactions numbered accordingly

  * directory with tests: ./pdf-suggest-rename-as_vouchers.t/

  * sample names:

    x.pdf -> 999990-000--20101231235959--x.pdf

================================================================================

* pdf-suggest-touch.sh

  * PDF files from wherever, e.g. ebooks, ...

  * this script gets called with the targeted files as command line arguments

  * date+time strings are extracted from the files using the utility "pdfinfo"

  * directory with tests: ./pdf-suggest-touch.t/

================================================================================

* jpg-exif-suggest-rename-versioned.sh

  * JPG files from wherever, e.g. ...

  * this script gets called with the targeted files as command line arguments

  * only pass file names in the current directory, as exiftool removes any leading directory path

  * date+time strings are extracted from the files using the utility "exiftool"

  * we assume the files will ***not*** be used as vouchers (corresponding to (bank) account transactions numbered accordingly)
    instead the date+time strings will be used for pseudo-versioning

  * directory with tests: ./jpg-exif-suggest-rename-versioned.t/

  * sample names:

    x.jpg -> 20101231235959--x.jpg

================================================================================

* jpg-exif-suggest-rename-as_vouchers.sh

  * JPG files from wherever, e.g. ...

  * this script gets called with the targeted files as command line arguments

  * only pass file names in the current directory, as exiftool removes any leading directory path

  * date+time strings are extracted from the files using the utility "exiftool"

  * we assume the files will be used as vouchers corresponding to (bank) account transactions numbered accordingly

  * directory with tests: ./jpg-exif-suggest-rename-as_vouchers.t/

  * sample names:

    x.jpg -> 999990-000--20101231235959--x.jpg

================================================================================

* x-suggest-rename.sh

  * sample names:

    x_01_of_09.jpg -> 999990-000--20101231235959--___.x_01_of_09.jpg
    x_01_of_09.pdf -> 999990-000--20101231235959--___.x_01_of_09.pdf

  * the HP MFU (scanner + ...) at K+N creates files at the S: "drive" named as "specified" within this script -> roughly: x_??_of_??.jpg resp. x_??_of_??.pdf

  * this script takes no options and no arguments, simply picks up all targeted files

  * date+time strings are extracted from the files using the utility "exiftool"

  * we assume the files will be used as vouchers corresponding to (bank) account transactions numbered accordingly

  * directory with tests: ./x-suggest-rename.t/

================================================================================
