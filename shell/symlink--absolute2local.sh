:

# sample situation:
#
#   /plinkx:pl-kvwapp09.prod.kvbb.lan:/opt/kv_apps/terminservicestelle:
#   -rw-rw-r--  1 terminservicestelle terminservicestelle 74357449 Nov 18  2021 terminservicestelle-1.9.4-SNAPSHOT.jar
#   -rw-rw-r--  1 terminservicestelle terminservicestelle 74359695 Nov 19  2021 terminservicestelle-1.9.5-SNAPSHOT.jar
#   lrwxrwxrwx  1 root                root                      71 Nov 19  2021 terminservicestelle.jar -> /opt/kv_apps/terminservicestelle/terminservicestelle-1.9.5-SNAPSHOT.jar
#
# terminservicestelle.jar is a symlink to an absolute pathname,
# but the directory part of that pathname is the directory,
# where terminservicestelle.jar lives itself.
# the absolute pathname makes it a little unreadable.
#
################################################################################
#
# restriction:
#
#   this utility is expected to be applied exactly within the directory, where "${arg}" lives.
#
################################################################################

arg="$1"

dn=$( dirname  $( readlink "${arg}" ) )
bn=$( basename $( readlink "${arg}" ) )

if test "${dn}" = "${PWD}"
then :
  rm --verbose             "${arg}"
  ln --verbose -sf "${bn}" "${arg}"
fi
