:

# http://www.gnu.org/software/qexo/XQ-Gen-XML.html
#
#   Generate all the HTML output files in a single XQuery run, by putting them in a single large XML object, like this:
#
#     <outputs>
#       <output-file filename="picture1.html">
#         <html>contents of picture1.html</html>
#       </output-file>
#       <output-file filename="picture2.html">
#         <html>contents of picture2.html</html>
#       </output-file>
#     </outputs>
#
#   It is then easy to write a post-processor to split this into separate XML files.
#
# now here is an implementation of this post-processor using xmlstarlet

##XML=$HOME/Computers/Software/Operating_Systems/Unix/Shell/xml_extract_files.t/in/0.xml

for XML in "$@"
do :
  echo "*** extracting from ${XML}:"

  for fn in $( xml sel -t -v 'outputs/output-file/@filename' -n "${XML}" )
  do :
    test -n "$VERBOSE" && echo "*** extracting from ${XML}: ${fn}:"

    xml sel -t -v "outputs/output-file[@filename='${fn}']" -n "${XML}" > "${fn}"
  done

done
