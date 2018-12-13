#! /usr/bin/perl -w

use Win32::Shortcut;

{
  my($package,$filename,$line,$proc_name) = caller(0);

  $LINK = Win32::Shortcut->new();
  $LINK->Load("pageant.exe.lnk");
  print "Shortcut to: $LINK->{'Path'} $LINK->{'Arguments'} \n";

  printf STDERR "=%s,%d,%s: %s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,
    '$.' => $.,
    '...'
    if 0;

  $LINK->Close();
}
