# …

# misc/using_timestamps_in_filenames/README.md

misc
====

create_snapshot.sh
==================
create a copy of a file (the snapshot)
using the OS mtime AKA "modification time" (stamp) as extra extension.

create_snapshot_from_ODF.sh
===========================
assuming the file in question is an Open Office .odf or .ods or ... file
(actually a ZIP file containing meta.xml)
create a copy of a file (the snapshot)
using office:document-meta/office:meta/dc:date .

create_snapshot_from_OOXML.sh
=============================
assuming the file in question is
a Microsoft .xslx (Excel) or .docx (Word) or .vsdx (Visio/Drawing) or ... file
(actually a ZIP file containing docProps/core.xml)
create a copy of a file (the snapshot)
using cp:coreProperties/dcterms:modified resp. cp:coreProperties/dcterms:created .

\*-suggest-rename-*.sh
=====================
they are to be applied to JPEG resp. PDF files.
these are shell scripts that let their resp. utility look into the header of the file.
usually there are a couple of date-time-strings, they find,
and for each such date-time-string, they suggest a renaming.

\*-exif-suggest-rename-versioned.sh
============================
the date+time-strings goes right before the extension of a file name.

\*-exif-suggest-rename-as_vouchers.sh
============================
the date+time-strings goes to the beginnging of a file name - actually after a 999990-000--,
because that's what my vouchers are usually named initially,
until I am able to associate them to a booking in a bank account.

jpg-exif-suggest-rename-*.sh
============================
JPEG related …

pdf-exif-suggest-rename-*.sh
============================
PDF related …
