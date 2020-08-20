# …

################################################################################

$ unzip -p ....docx docProps/core.xml

################################################################################

[2020-04-27 17:43:34] johayek@Hayek003 $ xmlstarlet elements 0.xml
cp:coreProperties
cp:coreProperties/dc:creator
cp:coreProperties/cp:lastModifiedBy
cp:coreProperties/cp:revision
cp:coreProperties/dcterms:created
cp:coreProperties/dcterms:modified

$ xmlstarlet sel --template --value-of cp:coreProperties/dcterms:created  ...

# "default" (?!?) namespace:

[2020-04-27 17:43:41] johayek@Hayek003 $ xmlstarlet elements 1.xml 
coreProperties
coreProperties/dc:creator
coreProperties/lastModifiedBy
coreProperties/revision
coreProperties/lastPrinted
coreProperties/dcterms:created
coreProperties/dcterms:modified

# this one (also?) matches "default" namespace, when namespace misses:

$ xmlstarlet sel --template --value-of                 //dcterms:modified ...

# not like this:

$ xmlstarlet sel --template --value-of                 /coreProperties/dcterms:modified ...

################################################################################

################################################################################

echo 2020-03-30T12:59:00Z | tr -d ':TZ-'

echo 2020-03-30T12:59:00Z         | perl -ne 'm/ ^ (?<YYYY>\d\d\d\d)-(?<mm>\d\d)-(?<dd>\d\d) T (?<HH>\d\d):(?<MM>\d\d):(?<SS>\d\d) /x && print "$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}\n"'

echo 2020-04-23T14:59:04.0859673Z | perl -ne 'm/ ^ (?<YYYY>\d\d\d\d)-(?<mm>\d\d)-(?<dd>\d\d) T (?<HH>\d\d):(?<MM>\d\d):(?<SS>\d\d) /x && print "$+{YYYY}$+{mm}$+{dd}$+{HH}$+{MM}$+{SS}\n"'

################################################################################
