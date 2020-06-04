# ...

# ~/git-servers/github.com/JochenHayek/misc/renaming_scanner_files/README--rename.txt

================================================================================

$ ~/bin/rename -v 's/^ 999990-000-- //x' 999990-*

================================================================================

# ~/git-servers/github.com/JochenHayek/misc/shell/renumber_files.sh
# ~/git-servers/github.com/JochenHayek/misc/shell/renumber_duplex_scanned_files.sh

# ~/Computers/Software/Operating_Systems/Unix/Shell/compare_compressed_files.sh

================================================================================

~/git-servers/github.com/JochenHayek/misc/using_timestamps_in_filenames/README--extracting_timestamps.txt

* pdf-suggest-rename-versioned.sh
* pdf-suggest-rename-as_vouchers.sh
* pdf-suggest-touch.sh

* jpg-exif-suggest-rename-versioned.sh
* jpg-exif-suggest-rename-as_vouchers.sh
* jpg-exiftool-suggest-rename-versioned.sh
* jpg-exiftool-suggest-rename-as_vouchers.sh

================================================================================
================================================================================

different traditions:

* *.rename.sh
* *-rename.sh

one day they will all be called like this:

* *.rename.sh

================================================================================
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
================================================================================
================================================================================

# ... single-sided ...?

$ . $HOME/.profile
$ ##path_prepend /sw
$ ~/bin/renumber_files.sh 20170699000000--___. 999990-000--2017062022*

# eg.

$ ~/bin/renumber_files.sh 20170210______--jaehrliche_Information_zur_Entwicklung_Ihrer_Versicherung.     999990-000--201706151718*
$ ~/bin/renumber_files.sh 20170699______--Hannoversche.                                                  999990-000--2017061517*        
$ ~/bin/renumber_files.sh 20170614000000--ing-diba--Auftragsbestaetigung.                                999990-000--20170615160824--___.*

--------------------------------------------------------------------------------

# ... duplex ...?

$ . $HOME/.profile
$ ##path_prepend /sw
$ ~/bin/renumber_duplex_scanned_files.sh 20170614000000--___. 999990-000--20170615160824--___.* 999990-000--20170615160917--___.*

# eg.

$ ~/bin/renumber_duplex_scanned_files.sh             20200121000000--___. 999990-000--*.png

$ ~/bin/renumber_duplex_scanned_files.sh             20181101000000--___. 999990-000--*.png

$ ~/bin/renumber_duplex_scanned_files.sh 999990-000--20181026000000--___. 999990-000--*.png

$ ~/bin/renumber_duplex_scanned_files.sh 999990-000--20181026000000--___. 999990-000--*.raw.png

$ ~/bin/renumber_duplex_scanned_files.sh 999990-000--20181127225752--___. 999990-000--*.raw.png

$ ~/bin/renumber_duplex_scanned_files.sh 999990-000--20181026000000--___. 999990-000--*.raw.png

$ ~/bin/renumber_duplex_scanned_files.sh 999990-000--20171024000000--HDI. 999990-000--2017111718*.png

$ ~/bin/renumber_duplex_scanned_files.sh 20202602000000--Sukkat-Schalom--___. 999990-*

$ ~/bin/renumber_duplex_scanned_files.sh 20170907000000--Postbank.            20170909*

$ ~/bin/renumber_duplex_scanned_files.sh 20170602000000--Landesoberkasse.     999990-000--20170620*
$ ~/bin/renumber_duplex_scanned_files.sh 20170210______--jaehrliche_Information_zur_Entwicklung_Ihrer_Versicherung.     999990-000--201706151718*
$ ~/bin/renumber_duplex_scanned_files.sh 20170699______--Hannoversche.                                                  999990-000--2017061517*        
$ ~/bin/renumber_duplex_scanned_files.sh 20170614000000--ing-diba--Auftragsbestaetigung.                                999990-000--20170615160824--___.* 999990-000--20170615160917--___.*

================================================================================
================================================================================
================================================================================

* QScan-rename.sh

  * my Samsung MFU creates files at ~/Pictures/ named as "specified" within this script -> roughly: QScan*.*

  $ cd ~/Pictures/
  $ ~/bin/QScan.rename.sh	# this script takes no options and no arguments, simply picks up all targeted files

  * we assume the files will be used as vouchers corresponding to (bank) account transactions numbered accordingly

  * directory with tests: ./QScan-rename.t/

  * sample names (date+time strings are part of the file names):

    QScan12312000_235959.png    -> 999990-000--20001231235959--___.png
    QScan12312000_235959-0.png  -> 999990-000--20001231235959--___.00of99.png
    QScan12312000_235959-99.png -> 999990-000--20001231235959--___.99of99.png

  * regarding renumbering single-sided and double-sided AKA duplex pages "of paper"
    see below here:
    * ~/bin/renumber_files.sh
    * ~/bin/renumber_duplex_scanned_files.sh

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

* WhatsApp.rename.sh

  * ...

================================================================================

* lexmark-scanner-rename.sh

  * ...

================================================================================

* macOS-Screen_Shot-rename.sh

  * ...

================================================================================

* VirtualBox-rename.sh

  * ...

================================================================================
