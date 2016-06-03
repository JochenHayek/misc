#! /usr/bin/perl -w

{
  while(<>)
    {
      m/^##shuttle: *(.*)$/ && print $1,"\n",
    }
}
