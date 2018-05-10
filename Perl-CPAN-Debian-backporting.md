# a Debianized Perl CPAN package: backporting from Debian Sid

So far I have backported 2 CPAN packages like this: CryptX and DBD::Oracle.

***

Debian version history (for sound background knowledge):
- https://en.wikipedia.org/wiki/Debian_version_history

***

We will make use of these utilities:
- https://manpages.debian.org/unstable/devscripts/dget.1.en.html
- https://manpages.debian.org/unstable/dpkg/dpkg.1.en.html
- https://manpages.debian.org/unstable/dpkg/dpkg-query.1.en.html
- https://manpages.debian.org/unstable/dpkg-dev/dpkg-source.1.en.html
- https://manpages.debian.org/unstable/dpkg-dev/dpkg-buildpackage.1.en.html

***

There is a Perl module that provides a self-contained crypto toolkit (we need this module for Passfuscator):
- https://metacpan.org/pod/CryptX
- https://metacpan.org/release/CryptX

There is a Perl module that provides access to Oracle databases:
- https://metacpan.org/pod/DBD::Oracle
- https://metacpan.org/release/DBD-Oracle

***

The Perl module CryptX was made available for Debian Linux:
- https://tracker.debian.org/pkg/libcryptx-perl

The Perl module DBD::Oracle was made available for Debian Linux:
- https://tracker.debian.org/pkg/libdbd-oracle-perl

***

Q: which "_versions_" of libcryptx-perl are there? (look for the string "_versions_" on that web-page!)

Q: which Debian release has its own ready-made CryptX package?

These Debian releases are the only ones with a ready-made package (you will find exactly and only "_testing_" and "_unstable_" below "_versions_"):
- there is "always" a Debian package for "_unstable_" AKA "_sid_" (i.e. the development trunk),
- and there is "always" a Debian package for "_testing_" (as of 2018-01-22 that is "10 (buster)"),
- there is no ready-made package for "8 (jessie)",
  so we have to derive a suitable package from "_sid_".
  Maybe you have to adapt the _debhelper_ release no:
  There will be only one figure to change from 10 to 9,
  that's (the minimal release of) "_debhelper_" within `debian/control`.

## retrieving the source package, the dget approach

Within the leftmost column (topmost section "_general_")
there is also a section "_versioned links_" with a couple of rows.
Use the row with the highest version number!
There is a "_download_" link (".dsc"), and the hint says: "_.dsc, use dget on this link to retrieve the source package_".
Preferredly we would do exactly this, but within some environments `dget` fails like this:
```
$ dget http://deb.debian.org/debian/pool/main/libc/libcryptx-perl/libcryptx-perl_0.056-1.dsc
dget: retrieving http://deb.debian.org/debian/pool/main/libc/libcryptx-perl/libcryptx-perl_0.056-1.dsc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
curl: (7) Failed to connect to deb.debian.org port 80: Connection refused
dget: curl libcryptx-perl_0.056-1.dsc http://deb.debian.org/debian/pool/main/libc/libcryptx-perl/libcryptx-perl_0.056-1.dsc failed
```
..., so we cannot choose this route.
Let us discuss the alternative!

## retrieving the source package, the "if dget failed" approach

There is a section "_general_",
and there is a link labeled "_libcryptx-perl_" in the row labeled "_source_",
and this is where it points to (let us **follow** this link!):
- https://packages.debian.org/src:libcryptx-perl

***

There is a link labeled "_sid_" (right context: "_(misc)_" or "_(perl)_" or ...), 
and this is where it points to (let us follow this link!):
- https://packages.debian.org/source/sid/libcryptx-perl

***

Download all 3 files mentioned there
- `libcryptx-perl_0.056-1.dsc` -- "use dget on the resp. link to retrieve the (entire) source package"
- `libcryptx-perl_0.056-1.debian.tar.xz`
- `libcryptx-perl_0.056.orig.tar.gz`

***

In some environments we cannot access those links,
so find a way to get them anyway!

***

Once you have them, run `md5um` on the files we downloaded (`*.dsc`, `*.orig.tar.*`, `*.debian.tar.*`):
```
$ md5sum libcryptx-perl_0.056.orig.tar.gz libcryptx-perl_0.056-1.dsc libcryptx-perl_0.056-1.debian.tar.xz > $(basename libcryptx-perl_0.056-1.dsc .dsc).md5
```
and compare (manually) the entries with the MD5 checksums given on the web page!

***

Be sure to have all 3 files mentioned in your current directory!

***

Its option "--extract" ("-x") is exactly for passing the name of a .dsc (Debian source control) file.

***

Run this command line on the `.dsc` file downloaded right before:
```
$ dpkg-source --extract libcryptx-perl_0.056-1.dsc
```
***

The recent command line created this subdirectory:
- `libcryptx-perl-.../`

## adapting the source package

Run this command line in order to find out our release of _debhelper_:
```
$ dpkg-query --list debhelper
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version      Architecture Description
+++-==============-============-============-==================================
ii  debhelper      9.20150101+d all          helper programs for debian/rules
```

We are interested in the value in column _Version_, resp. in its beginning, ie. *9* - or maybe a bigger figure later on.

***

Within file `libcryptx-perl-0.056/debian/control`:
- replace expected (minimal) release of debhelper with ours, i.e. 10 with 9!

## building and installing the Debian package

Within directory `libcryptx-perl-.../` run this command line:
```
$ dpkg-buildpackage -b -us -uc
##$ dpkg-buildpackage --build=any,all --unsigned-source --unsigned-changes # future command line
```
***

The recent command line created two files above this subdirectory:
- `libcryptx-perl_0.056-1_amd64.deb`
- `libcryptx-perl_0.056-1_amd64.changes`

***

Install the **new** Debian package:
```
$ sudo dpkg --install libcryptx-perl_0.056-1_amd64.deb
```
***

Check whether our **new** Debian package is installed:
```
$ dpkg-query --list libcryptx-perl
```
***

...
