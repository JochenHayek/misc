# ...

================================================================================

* pdf-suggest-rename-versioned.sh
* pdf-suggest-rename-as_vouchers.sh
* pdf-suggest-touch.sh

  * PDF files from wherever, e.g. ebooks, ...

  * this script gets called with the targeted files as command line arguments

  * date+time strings are extracted from the files using the utility "pdfinfo"

  	* different versions of pdfinfo use the same options differently, so sometimes you may want to call pdf-suggest-___.sh like this:

		$ pdfinfo_options=' -rawdates' ~/bin/pdf-suggest-rename-versioned.sh *.pdf

  * we assume the files will ***not*** be used as vouchers (corresponding to (bank) account transactions numbered accordingly)
    instead the date+time strings will be used for pseudo-versioning

  * directory with tests: ./pdf-suggest-rename-versioned.t/
  * directory with tests: ./pdf-suggest-rename-as_vouchers.t/

  * directory with tests: ./pdf-suggest-touch.t/

  * sample names:

    x.pdf -> x.20101231235959.pdf // versioned

    x.pdf -> 999990-000--20101231235959--x.pdf // as vouchers

================================================================================

* jpg-exif-suggest-rename-versioned.sh
* jpg-exif-suggest-rename-as_vouchers.sh
* jpg-exiftool-suggest-rename-versioned.sh
* jpg-exiftool-suggest-rename-as_vouchers.sh

  * JPG (and also HEIC) files from wherever, e.g. ...

  * this script gets called with the targeted files as command line arguments

  * only pass file names in the current directory, as exiftool removes any leading directory path

  * date+time strings are extracted from the files using the utility "exiftool"

  * we assume the files will either be used as vouchers (corresponding to (bank) account transactions numbered accordingly)
    or the date+time strings will be used for pseudo-versioning

  * directory with tests: ./jpg-exif-suggest-rename-versioned.t/

  * directory with tests: ./jpg-exif-suggest-rename-as_vouchers.t/

  * sample names:

    x.jpg -> 20101231235959--x.jpg

    x.jpg -> 999990-000--20101231235959--x.jpg

================================================================================
