:

# misc/using_timestamps_in_filenames/jpg-exif-suggest-rename-versioned.sh

# -> README--rename.txt

################################################################################

# $ exif --xml-output *.jpg | fgrep -i '<Date_and_Time'

################################################################################

##Date=CreateDate
##Date=DateTimeOriginal
##Date=FileModifyDate
##Date=ModifyDate
  Date=ModifyDate

# CreateDate                      : 2014:08:30 10:04:37
# DateTimeOriginal                : 2014:08:30 10:04:37
# FileAccessDate                  : 2014:09:16 15:39:12+02:00
# FileInodeChangeDate             : 2014:09:16 13:20:38+02:00
# FileModifyDate                  : 2014:09:16 13:20:25+02:00
# ModifyDate                      : 2014:08:30 10:04:37
# PowerUpTime                     : 2014:08:30 10:03:26
##ProfileDateTime                 : 1998:02:09 06:49:00
# SubSecCreateDate                : 2014:08:30 10:04:37.29
# SubSecDateTimeOriginal          : 2014:08:30 10:04:37.29
# SubSecModifyDate                : 2014:08:30 10:04:37.29
  
for filename
do

  echo "*** ${filename}:"

  exif --xml-output "${filename}" | 

  perl \
    -s \
    -ne '

    # <Date_and_Time__Original_>2010:08:19 13:57:49</Date_and_Time__Original_>

    $FileName = "${filename}";

    $FileName =~ s/\.jpg//;

    if(m/^ \s* < (?<left>Date_and_Time[^>]*) > (?<Date> (?<Y>....).(?<m>..).(?<d>..).(?<H>..).(?<M>..).(?<S>..) ) <\/ (?<right>[^>]+) > \s* $ /x)
      {
	$Date = $+{Date};

      ##$time_stamp = "$+{Y}$2$3$4$5$6";
	$time_stamp = "$+{Y}$+{m}$+{d}$+{H}$+{M}$+{S}";

      ##print "mv \"${filename}\" \"${FileName}.${time_stamp}.jpg\" # \$Date=>{$Date}\n";
	print "mv \"${filename}\" \"${FileName}.${time_stamp}.jpg\" # \$+{left}=>{$+{left}},\$Date=>{$Date}\n";
      }

  ' \
  -- -Date=${Date} "-filename=${filename}"
done
