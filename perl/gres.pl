#! /usr/bin/perl -w

($#ARGV >= 2) || die "\$#ARGV=>$#ARGV, should: >= 2";

$old = shift;
$new = shift;

while ($file = shift @ARGV)
{
    if (!rename($file,"${file}~"))
    {
	warn "cannot rename `$file'";
	next;
    }

    if (! open(fh_old,"${file}~") )
    {
	warn "cannot open ${file}~";
	next;
    }

    if (! open(fh_new,">$file") )
    {
	warn "cannot open $file";
	close(fh_old);
	next;
    }

    while (<fh_old>)
    {
	s/${old}/${new}/g;
        print fh_new;
    }

}
