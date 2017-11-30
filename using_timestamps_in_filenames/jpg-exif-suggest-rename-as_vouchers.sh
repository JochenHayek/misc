:

# -> README--extracting_timestamps.txt

# misc/using_timestamps_in_filenames/jpg-exif-suggest-*.sh
# misc/using_timestamps_in_filenames/jpg-exif-suggest-rename-as_vouchers.sh
# misc/using_timestamps_in_filenames/jpg-exif-suggest-rename-versioned.sh

# misc/using_timestamps_in_filenames/jpg-exiftool-suggest-*.sh
# misc/using_timestamps_in_filenames/jpg-exiftool-suggest-rename-as_vouchers.sh
# misc/using_timestamps_in_filenames/jpg-exiftool-suggest-rename-versioned.sh

################################################################################

# $ exif --xml-output *.jpg | fgrep -i '<Date_and_Time'

################################################################################

##filename=Being_Geek.pdf

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




  ##if(m/^ \s* < (?<left>\w+) > \s* (?<Date>[^<]*) \s* < (?<left>\w+) > \s* $ : \s+ (?<Y>....).(?<m>..).(?<d>..).(?<H>..).(?<M>..).(?<S>..) /x)

  
for filename
do

  echo "*** ${filename}:"

  exif --xml-output "${filename}" | 

  perl \
    -s \
    -ne '

    # <Date_and_Time__Original_>2010:08:19 13:57:49</Date_and_Time__Original_>

    $FileName = "${filename}";

    if(m/^ \s* < (?<left>Date_and_Time[^>]*) > (?<Date> (?<Y>....).(?<m>..).(?<d>..).(?<H>..).(?<M>..).(?<S>..) ) <\/ (?<right>[^>]+) > \s* $ /x)
      {
	$Date = $+{Date};

      ##$time_stamp = "$+{Y}$2$3$4$5$6";
	$time_stamp = "$+{Y}$+{m}$+{d}$+{H}$+{M}$+{S}";

      ##print "mv \"${FileName}\" \"${time_stamp}--${FileName}\" # \$Date=>{$Date}\n";
	print "mv \"${FileName}\" \"999990-000--${time_stamp}--${FileName}\" # \$+{left}=>{$+{left}},\$Date=>{$Date}\n";
      }

  ' \
  -- -Date=${Date} "-filename=${filename}"
done
