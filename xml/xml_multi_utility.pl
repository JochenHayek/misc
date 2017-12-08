#! /usr/bin/perl -w

($emacs_Time_stamp) = 'Time-stamp: <2013-01-21 16:54:17 johayek>' =~ m/<(.*)>/;

# Time-stamp: <2007-04-10 16:00:13 johayek>
# $Id: xml_multi_utility.pl 1.64 2013/01/21 15:54:27 johayek Exp $
# $Source: /home/jochen_hayek/Computers/Programming/Languages/Perl/RCS/xml_multi_utility.pl $

          $rcs_Id=(join(' ',((split(/\s/,'$Id: xml_multi_utility.pl 1.64 2013/01/21 15:54:27 johayek Exp $'))[1..6])));
#	$rcs_Date=(join(' ',((split(/\s/,'$Date: 2013/01/21 15:54:27 $'))[1..2])));
#     $rcs_Author=(join(' ',((split(/\s/,'$Author: johayek $'))[1])));
#   $rcs_Revision=(join(' ',((split(/\s/,'$Revision: 1.64 $'))[1])));
#	 $RCSfile=(join(' ',((split(/\s/,'$RCSfile: xml_multi_utility.pl $'))[1])));
#     $rcs_Source=(join(' ',((split(/\s/,'$Source: /home/jochen_hayek/Computers/Programming/Languages/Perl/RCS/xml_multi_utility.pl $'))[1])));

############################################################################################################################################

# $ ~/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_pl_validate     --xml_file=$HOME/usr/src/IDS_cronus_projects/200701--oo_files_pl/regression_test_configuration.xml
# $ ~/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_pl_validate     --xml_file=$HOME/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/membran--chanson--contentsdb.xml

############################################################################################################################################

# $ ~/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_t_mobile_reo    --xml_file=$HOME/Business/Telecommunications/Carriers/t-mobile.de/CSV-Rechnung--20070129.xml \
#       /media/_ARCHIVE/home/Aleph_Soft_GmbH-FROZEN-STUFF/Buchhaltung/SKR03-1200/Belege/999990-000--2007mmdd--T-Mobile--period-200703/Rechnung_03621149012691.csv \
#     > /media/_ARCHIVE/home/Aleph_Soft_GmbH-FROZEN-STUFF/Buchhaltung/SKR03-1200/Belege/999990-000--2007mmdd--T-Mobile--period-200703/Rechnung_03621149012691.csv.xml.NEW

############################################################################################################################################

# $ ~/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_telekom_reo     --xml_file=$HOME/Business/Telecommunications/Carriers/telekom.de/CSV-Rechnung--200x.xml \
#       /media/_ARCHIVE/home/Aleph_Soft_GmbH-FROZEN-STUFF/Buchhaltung/SKR03-1200/Belege/002261-000--20070327--Telekom-BLN-4968976753--period-200704/2007_04_Rechnung_4968976753.csv \
#     > /media/_ARCHIVE/home/Aleph_Soft_GmbH-FROZEN-STUFF/Buchhaltung/SKR03-1200/Belege/002261-000--20070327--Telekom-BLN-4968976753--period-200704/2007_04_Rechnung_4968976753.csv.xml.NEW

############################################################################################################################################

# $ ~/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_regression_test --xml_file=$HOME/usr/src/IDS_cronus_projects/200701--oo_files_pl/regression_test_configuration.xml
# $ ~/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_regression_test --xml_file=$HOME/usr/src/IDS_cronus_projects/200701--oo_files_pl/regression_test_configuration.xml \
#       --test_cases=thetakeoverpanel_0

# $ ~/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_regression_test --xml_file=$HOME/usr/src/IDS_cronus_projects/200701--oo_files_pl/regression_test_configuration.xml \
#       --create_reference_files_p \
#       --test_case=bloomberg--fields.csv--header--0 --test_case=bloomberg--lookup.out--header--0

############################################################################################################################################

# $ ~/Computers/Programming/Languages/Perl/xml_multi_utility.pl --job_itunes_whatever --xml_file=$HOME/Computers/Data_Formats/Markup_Languages/SGML/PropertyList/membran--chanson--contentsdb.xml

############################################################################################################################################

# the subroutine local_xml_package::load reads a file using XML::Parser .

# you can advise the utility local_xml_package::load to treat the data structure read
# as conforming to "-//Apple Computer//DTD PLIST 1.0//EN" (aka "Apple Property List").
# it will then create a corresponding PERL-ish data structure and return it,
# so that you can make further use of it.

{
##use English;
##use FileHandle;
  use strict;

  &main;
}
#
sub main
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  # described in:
  #	camel book / ch. 7: the std. perl lib. / lib. modules / Getopt::Long - ...

  use Getopt::Long;
  use Pod::Usage;
  our(%options) = ();
  $main::options{debug} = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 0 && $main::options{debug};
  printf STDERR "=%d,%s: %s=>{%s}\n",__LINE__,$proc_name
    ,'$rcs_Id' => $rcs_Id
    if 0 && $main::options{debug};
  printf STDERR "=%d,%s: %s=>{%s}\n",__LINE__,$proc_name
    ,'$emacs_Time_stamp' => $emacs_Time_stamp
    if 0 && $main::options{debug};

  {
    # defaults for the main::options;
    
    $main::options{dry_run}		       	= 0;
    $main::options{version}		       	= 0;
    $main::options{verbose}		       	= 0;

    $main::options{job_propertylist_validate}                   = 0;

    $main::options{job_itunes_whatever}                   = 0;
    $main::options{job_regression_test}                   = 0;
    $main::options{job_t_mobile_reo}                      = 0;
    $main::options{job_telekom_reo}                      = 0;

    $main::options{xml_file}	       	        = undef;

    $main::options{create_reference_files_p}	       	        = 0;
    $main::options{remove_output_files_p}	       	        = 1;
  }

  my($result) =
    &GetOptions
      (\%main::options

      ,'job_propertylist_validate|job_pl_validate!'

      ,'job_itunes_whatever!'
      ,'job_regression_test!'
      ,'job_t_mobile_reo!'
      ,'job_telekom_reo!'

      ,'dry_run!'
      ,'version!'
      ,'help|?!'
      ,'man!'
      ,'debug!'
      ,'verbose=i'
      ,'params=s%'		# some "indirect" parameters

    ##,'xml_file|propertylist_file|pl_file=s'	# well, I didn't really like this
      ,'xml_file=s'

      ,'create_reference_files_p!'
      ,'remove_output_files_p!'

      ,'test_cases=s@'
      );
  $result || pod2usage(2);

  pod2usage(1) if $main::options{help};
##pod2usage( { -exitstatus => 0, -verbose => 2, -width => 30 } ) if $main::options{man};
  pod2usage( { -exitstatus => 0, -verbose => 2		     } ) if $main::options{man};

##$main::options{verbose}=0;
##$main::options{verbose}=2;			# JH: verbosest level here

  if   ($main::options{job_propertylist_validate})  { &main::job_propertylist_validate; }
  elsif($main::options{job_itunes_whatever})               { &main::job_iTunes_whatever; }
  elsif($main::options{job_regression_test})               { &main::job_regression_test; }
  elsif($main::options{job_t_mobile_reo})               { &main::job_t_mobile_reo; }
  elsif($main::options{job_telekom_reo})               { &main::job_telekom_reo; }
  else
    {
      die "no job to be carried out";
    }

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value' => $return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 0 && $main::options{debug};
}
#
sub job_iTunes_whatever
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  defined($main::options{xml_file}) 		        || die "--xml_file ???";

  my($value) =
      &local_xml_package::load
        ({ 'file' => $main::options{xml_file}
	, 'process_PropertyList_p' => 1
	});

  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
    ,'$value'=>$value
    ,'ref($value)'=>ref($value)
    ,'this is the result of parsing the XML document'
    if 1 && $main::options{debug};

  if(1 && $main::options{debug})
    {
      foreach my $e (Expat,Name,Sysid,Pubid,Internal) # -> man XML::Parser -> Doctype
	{
	  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
	    , $e => $local_xml_package::Doctype_handler_parameters{$e}
	    ,'the parameters of the Expat Doctype handler'
	    if defined($local_xml_package::Doctype_handler_parameters{$e});
	}
    }
  
  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
    ,'$value->{Application}'=>$value->{Application}
    ,'...'
    if 1 && $main::options{debug};

  if($value->{Application} =~ m/^iTunes v7\.0\.1$/)
    {
      if(1 || $main::options{debug})
	{
	  if(ref($value) eq 'HASH')
	    {
	      foreach my $k (sort keys %{$value})
		{
		  my($v) = $value->{$k};

		  if(ref(\$v) eq 'SCALAR')
		    {
		      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			,$k=>$v
			,'another k=>v assoc ...'
			;
		    }
		  else
		    {
		      printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			,$k=>$v
			,"ref(\$value->{$k})"=>ref($value->{$k})
			,'another k=>v assoc ...'
			;
		    }
		}

	      foreach my $track (@{$value->{tracks}})
		{
		  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
		    ,'$track->{Artist}' => defined($track->{Artist}) ? $track->{Artist} : '{undef}'
		    ,'$track->{Name}'   => defined($track->{Name})   ? $track->{Name}   : '{undef}'
		    ,'...'
		    ;
		}
	    }
	}
    }

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value' => $return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
sub job_t_mobile_reo
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  defined($main::options{xml_file}) 		        || die "--xml_file ???";

  my($xml_tree) =
      &local_xml_package::load
        ({ 'file' => $main::options{xml_file}
	, 'process_PropertyList_p' => 1
	});

  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
    ,'$xml_tree'=>$xml_tree
    ,'ref($xml_tree)'=>ref($xml_tree)
    ,'this is the result of parsing the XML document'
    if 1 && $main::options{debug};

  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
    ,'$xml_tree->{Application}'=>$xml_tree->{Application}
    ,'...'
    if 1 && $main::options{debug};

  use Text::ParseWords;		# -> parse_line, ...

  # <  2010-05 : "T-Mobile RechnungOnline Business"
  # >= 2010-05 : "Telekom RechnungOnline Business"

  # is it really worth, checking this property?
  # I mean, *I* fill this property manually, and *I* check it,
  # and why would I supply any non-appropriate XML configuration file here?

  if   ($xml_tree->{Application} =~ /^(Telekom|T-Mobile) RechnungOnline Business$/) # -> e.g. ~/com/t-mobile.de/CSV-Rechnung--20070129.xml
    {
      my($do_print_to_stdout_p) = 1;

      my($state) = 'kopfteil';

      '' =~ m/`/;

      print <<'header_EOF';
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE Rechnung PUBLIC "-//Aleph Soft//DTD T-Mobile-REO 1.0//EN" "http://www.Aleph-Soft.com/DTDs/T-Mobile-REO-1.0.dtd">
<rechnung>
  <kopfteil
header_EOF

      '' =~ m/`/;

      while(<>)
	{
	  chomp;

	  if($_ eq '')
	    {
	      if   ($state eq 'kopfteil')
		{
		  printf "   /> <!-- end of %s -->\n"
		    ,$state
		    ;

		  $state    = 'positionsteil';

		  printf "  <%s>\n"
		    ,$state
		    ;
		}
	      elsif($state eq 'positionsteil')
		{
		  printf "  </%s>\n"
		    ,$state
		    ;

		  $state    = 'summenteil';

		  printf "  <%s>\n"
		    ,$state
		    ;
		}

	      next;
	    }
	  else
	    {
	      printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		,'$.' => $.
		,'$state' => $state
		,'...'
		if 0 && $main::options{debug};

	      my(@F) = &parse_line(',' , 0 , $_); # keep=>0 !!!!!!!!!

	      printf STDERR "=%s,%d,%s: %03.3d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
		,'$state' => $state
		,'$F[0]' => $F[0]
		,'...'
		if 1 && $main::options{debug};

	      if   ($state eq 'kopfteil')
		{
		  my($i);

		  for($i=0;$i<=$#F;$i++)
		    {
		      printf STDERR "=%s,%d,%s: %03.3d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
			, "\$xml_tree->{$state}[$i]{Bezeichnung}" => $xml_tree->{$state}[$i]{Bezeichnung}
			, "\$F[$i]" => $F[$i]
			,'...'
			if 0 && $main::options{debug};

		      printf STDERR "=%s,%d,%s: %03.3d: {%s}=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
			, $xml_tree->{$state}[$i]{Bezeichnung} => $F[$i]
			,'...'
			if 0 && $main::options{debug};

		      printf "     %s=\"%s\"\n"
		      ##, $xml_tree->{$state}[$i]{Bezeichnung} => $F[$i]
			, $xml_tree->{$state}[$i]{Bezeichnung} => &proc_reo__format( 'value' => $F[$i] , 'format' => $xml_tree->{$state}[$i]{Datentyp} )
			;
		    }
		}
	      elsif($state eq 'positionsteil')
		{
		  printf "    <%s"
		    ,'position'
		    ;

		  my($i);

		  for($i=0;$i<=$#F;$i++)
		    {
		    ##$F[$i] = '' unless defined($F[$i]);
		      if(!defined($F[$i]) || ($F[$i] eq ''))
			{
			  next;
			}

		      printf STDERR "=%s,%d,%s: %03.3d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
			, "\$xml_tree->{$state}[$i]{Bezeichnung}" => $xml_tree->{$state}[$i]{Bezeichnung}
			, "\$F[$i]" => $F[$i]
			,'...'
			if 0 && $main::options{debug};

		    ##if( 0 && $main::options{debug} && ($xml_tree->{$state}[$i]{Datentyp} eq 'date(dd.mm.yyyy)') )
		      if( 0 && $main::options{debug} )
			{
			  printf STDERR "=%s,%d,%s: %03.3d: {%s}=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
			  ##, $xml_tree->{$state}[$i]{Bezeichnung} => $F[$i]
			    , $xml_tree->{$state}[$i]{Bezeichnung} => &proc_reo__format( 'value' => $F[$i] , 'format' => $xml_tree->{$state}[$i]{Datentyp} )
			    ,'...'
			    ;
			}

		      printf " %s=\"%s\""
		      ##, $xml_tree->{$state}[$i]{Bezeichnung} => $F[$i]
			, $xml_tree->{$state}[$i]{Bezeichnung} => &proc_reo__format( 'value' => $F[$i] , 'format' => $xml_tree->{$state}[$i]{Datentyp} )
			;
		    }

		  print "/>\n";
		}
	      elsif($state eq 'summenteil')
		{
		  printf "    <%s"
		    ,'untersumme'
		    ;

		  my($i);

		  for($i=0;$i<=$#F;$i++)
		    {
		    ##$F[$i] = '' unless defined($F[$i]);
		      if(!defined($F[$i]) || ($F[$i] eq ''))
			{
			  next;
			}

		      printf STDERR "=%s,%d,%s: %03.3d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
			, "\$xml_tree->{$state}[$i]{Bezeichnung}" => $xml_tree->{$state}[$i]{Bezeichnung}
			, "\$F[$i]" => $F[$i]
			,'...'
			if 0 && $main::options{debug};

		      printf STDERR "=%s,%d,%s: %03.3d: {%s}=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
			, $xml_tree->{$state}[$i]{Bezeichnung} => $F[$i]
			,'...'
			if 0 && $main::options{debug};

		      printf " %s=\"%s\""
		      ##, $xml_tree->{$state}[$i]{Bezeichnung} => $F[$i]
			, $xml_tree->{$state}[$i]{Bezeichnung} => &proc_reo__format( 'value' => $F[$i] , 'format' => $xml_tree->{$state}[$i]{Datentyp} )
			;
		    }

		  print "/>\n";
		}
	    }
	}

      printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
	,'$state' => $state
	,'...'
	if 1 && $main::options{debug};

      printf "  </%s>\n"
	,$state
	;

      '' =~ m/`/;

      print <<'tail_EOF';
</rechnung>

<!-- Local variables: -->
<!-- mode: nxml -->
<!-- End: -->
tail_EOF

      '' =~ m/`/;

    }
  else
    {
      die "\$xml_tree->{Application}=>{$xml_tree->{Application}}";
    }

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value' => $return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}

sub proc_reo__format
{
  my($package,$filename,$line_no,$proc_name) = caller(0);
  my(%param) = @_;

  # $param{value}
  # $param{format}

  my($h) = $param{value};

  if   ($param{format} eq 'date(dd.mm.yyyy)')
    {
      $h =~ s/^(\d+)\.(\d+)\.(\d+)$/$3-$2-$1/;
    }
  elsif( exists($param{swap_numerical_special_characters_p}) && $param{swap_numerical_special_characters_p} && ($param{format} eq 'numerisch') )
    {
      $h =~ tr/,./.,/;
    }
  else
    {
      $h =~ s/&/&amp;/g;
    }

  return $h;
}
#
sub job_telekom_reo
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  defined($main::options{xml_file}) 		        || die "--xml_file ???";

  my($xml_tree) =
      &local_xml_package::load
        ({ 'file' => $main::options{xml_file}
	, 'process_PropertyList_p' => 1
	});

  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
    ,'$xml_tree'=>$xml_tree
    ,'ref($xml_tree)'=>ref($xml_tree)
    ,'this is the result of parsing the XML document'
    if 1 && $main::options{debug};

  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
    ,'$xml_tree->{Application}'=>$xml_tree->{Application}
    ,'...'
    if 1 && $main::options{debug};

  use Text::ParseWords;		# -> parse_line, ...

  if   ($xml_tree->{Application} eq 'Telekom Rechnung Online') # -> e.g. ~/com/telekom.de/CSV-Rechnung--200x.xml
    {
      my($do_print_to_stdout_p) = 1;

      my($state) = 'kopfteil';

      '' =~ m/`/;

      print <<'header_EOF';
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE telekom_rechnung PUBLIC "-//Aleph Soft//DTD Telekom-REO 1.0//EN" "http://www.Aleph-Soft.com/DTDs/Telekom-REO-1.0.dtd">
<telekom_rechnung>
header_EOF

      '' =~ m/`/;

      $/ = "\r\n";

      while(<>)
	{
	  chomp;

	  if   ($state eq 'kopfteil')
	    {
	      if (0)
		{}
	      elsif(m/^\"Buchungskonto (\d+)\"$/)
		{
		  $Rechnungsbereich{Buchungskonto} = $1;
		}
	      elsif(m/^Buchungskonto (\d+)$/)
		{
		  $Rechnungsbereich{Buchungskonto} = $1;
		}
	      elsif(m/^\"Rechnungsnummer (\d+) vom ([\d.]+)\"$/) # e.g. "Rechnungsnummer 9782562619 vom 27.03.2007"
		{
		  $Rechnungsbereich{Rechnungsnummer} = $1;
		  $Rechnungsbereich{Rechnungsdatum}  = &proc_reo__format( 'value' => $2 , 'format' => 'date(dd.mm.yyyy)' , 'swap_numerical_special_characters_p' => 1 );
		}
	      elsif(m/^Rechnungsnummer (\d+) vom ([\d.]+)$/) # e.g. "Rechnungsnummer 9782562619 vom 27.03.2007"
		{
		  $Rechnungsbereich{Rechnungsnummer} = $1;
		  $Rechnungsbereich{Rechnungsdatum}  = &proc_reo__format( 'value' => $2 , 'format' => 'date(dd.mm.yyyy)' , 'swap_numerical_special_characters_p' => 1 );
		}
	      elsif(m/^\"?Rechnungsbereich\"?,/)
		{
      print <<"kopfteil_EOF";
  <kopfteil
    buchungskonto="$Rechnungsbereich{Buchungskonto}"
    rechnungsnummer="$Rechnungsbereich{Rechnungsnummer}"
    rechnungsdatum="$Rechnungsbereich{Rechnungsdatum}"
    waehrung="EUR"
   />
kopfteil_EOF

		  $state    = 'positionsteil';

		  printf "  <%s>\n"
		    ,$state
		    ;
		}

	      next;
	    }
	  elsif($state eq 'positionsteil')
	    {
	      if (m/^\s+/ || ($_ eq ''))
		{
		  printf "  </%s>\n"
		    ,$state
		    ;

		  $state    = 'summenteil';

		  printf "  <%s>\n"
		    ,$state
		    if 0;
		}
	      else
		{
		  printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
		    ,'$.' => $.
		    ,'$state' => $state
		    ,'...'
		    if 0 && $main::options{debug};

		  my(@F) = &parse_line(',' , 0 , $_); # keep=>0 !!!!!!!!!

		  printf STDERR "=%s,%d,%s: %03.3d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
		    ,'$state' => $state
		    ,'$F[0]' => $F[0]
		    ,'...'
		    if 1 && $main::options{debug};

		  printf "    <%s"
		    ,'position'
		    ;

		  my($i);

		  for($i=0;$i<=$#F;$i++)
		    {
		    ##$F[$i] = '' unless defined($F[$i]);
		      if(!defined($F[$i]) || ($F[$i] eq '') || ($F[$i] eq '---'))
			{
			  next;
			}

		      printf STDERR "=%s,%d,%s: %03.3d: %s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
			, "\$xml_tree->{$state}[$i]{Bezeichnung}" => $xml_tree->{$state}[$i]{Bezeichnung}
			, "\$F[$i]" => $F[$i]
			,'...'
			if 0 && $main::options{debug};

		    ##if( 0 && $main::options{debug} && ($xml_tree->{$state}[$i]{Datentyp} eq 'date(dd.mm.yyyy)') )
		      if( 1 && $main::options{debug} )
			{
			  printf STDERR "=%s,%d,%s: %03.3d: {%s}=>{%s} // %s\n",__FILE__,__LINE__,$proc_name,$.
			    , $xml_tree->{$state}[$i]{Bezeichnung} => $F[$i]
			  ##, $xml_tree->{$state}[$i]{Bezeichnung} => &proc_reo__format( 'value' => $F[$i] , 'format' => $xml_tree->{$state}[$i]{Datentyp} , 'swap_numerical_special_characters_p' => 1 )
			    ,'...'
			    ;
			}

		      printf " %s=\"%s\""
		      ##, $xml_tree->{$state}[$i]{Bezeichnung} => $F[$i]
			, $xml_tree->{$state}[$i]{Bezeichnung} => &proc_reo__format( 'value' => $F[$i] , 'format' => $xml_tree->{$state}[$i]{Datentyp} , 'swap_numerical_special_characters_p' => 1 )
			if 1;
		    }

		  print "/>\n";
		}
	    }
	}

      printf "  </%s>\n"
	,$state
	if 0;

      if($state eq 'positionsteil')
	{
	  printf "  </%s>\n"
	    ,$state
	    ;
	}

      '' =~ m/`/;

      print <<'tail_EOF';
</telekom_rechnung>

<!-- Local variables: -->
<!-- mode: nxml -->
<!-- End: -->
tail_EOF

      '' =~ m/`/;
    }
  else
    {
      die "\$xml_tree->{Application}=>{$xml_tree->{Application}}"
    }

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value' => $return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
sub job_regression_test
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  defined($main::options{xml_file}) 		        || die "--xml_file ???";

  my($value) =
      &local_xml_package::load
        ({ 'file' => $main::options{xml_file}
	, 'process_PropertyList_p' => 1
	});

  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
    ,'$value'=>$value
    ,'ref($value)'=>ref($value)
    ,'this is the result of parsing the XML document'
    if 1 && $main::options{debug};

  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
    ,'$value->{Application}'=>$value->{Application}
    ,'...'
    if 1 && $main::options{debug};

  if   ($value->{Application} eq 'files.pl regression test')
    {
      if(exists($main::options{test_cases}))
	{
	  %main::test_cases_as_hash = ();

	  foreach my $h (@{$main::options{test_cases}})
	    {
	      $main::test_cases_as_hash{$h} = 1;
	    }
	}

      foreach my $test_case (@{$value->{test_cases}})
	{
	  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
	    ,'$test_case->{unique_id}'    => ( defined($test_case->{unique_id}) ? $test_case->{unique_id} : '{undef}' )
	    ,'...'
	    if 1 && $main::options{debug};

	  next
	    unless( !exists($test_case->{active_p}) || $test_case->{active_p} );

	  if(!exists($main::options{test_cases}) || exists($main::test_cases_as_hash{ $test_case->{unique_id} }))
	    {
	      print "\n" , '#' x 80 , "\n";

	      printf "\n# =%03d: {%s}=>{%s} // %s\n\n(\n",__LINE__
		,'$test_case->{unique_id}'    => ( defined($test_case->{unique_id}) ? $test_case->{unique_id} : '{undef}' )
		,'...'
		;

	      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		,'$test_case->{command_line}' => ( defined($test_case->{command_line})   ? $test_case->{command_line}   : '{undef}' )
		,'...'
		if 1 && $main::options{debug};

	      my($k,$v);
	      while( ($k,$v) = each %{$test_case->{shell_variables}} )
		{
		  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		    ,  ( defined($k) ? $k : '{undef}' )
		    => ( defined($v) ? $v : '{undef}' )
		    ,'another shell variable'
		    if 1 && $main::options{debug};

		  printf "  %s='%s'\n"
		    ,  ( defined($k) ? $k : '# {undef}' )
		    => ( defined($v) ? $v : '"{undef}"' )
		    ;
		}

	      printf "\n  %s \\\n"
		, ( defined($test_case->{command_line})   ? $test_case->{command_line}   : '# {undef}' )
		;

	      if( defined($test_case->{stdin}{file}) )
		{
		  printf "    < %s \\\n"
		    ,$test_case->{stdin}{file}
		    ;
		}
	      else
		{
		  die "\$test_case->{unique_id}=>{$test_case->{unique_id}} : !defined(\$test_case->{stdin}{file})";
		}

	      if( defined($test_case->{stdout}{reference_file}) )
		{
		  $test_case->{stdout}{output_file} = '/tmp/regression_test--' . $test_case->{unique_id} . '--stdout';

		  printf "    1> '%s' \\\n"
		    ,$test_case->{stdout}{output_file}
		    ;
		}
	      else
		{
		  die "\$test_case->{unique_id}=>{$test_case->{unique_id}} : !defined(\$test_case->{stdout}{reference_file})";
		}

	      if( defined($test_case->{stderr}{reference_file}) )
		{
		  $test_case->{stderr}{output_file} = '/tmp/regression_test--' . $test_case->{unique_id} . '--stderr';

		  printf "    2> '%s' \\\n"
		    ,$test_case->{stderr}{output_file}
		    ;
		}
	      else
		{
		  die "\$test_case->{unique_id}=>{$test_case->{unique_id}} : !defined(\$test_case->{stderr}{reference_file})";
		}

	      print "    ;\n";
	      print "  exit_code=\$?\n";

	      printf "  echo -e \"\\ntest_case=>{%s},\\\$exit_code=>\${exit_code}\"\n"
		,$test_case->{unique_id}
		;

	      foreach my $stdX ('stdout','stderr')
		{
		  if( defined($test_case->{$stdX}{reference_file}) )
		    {
		      if($main::options{create_reference_files_p})
			{
			  if($test_case->{$stdX}{reference_file} ne '/dev/null')
			    {
			      printf "\n  %s '%s' > \"%s\"\n"

				, defined($test_case->{$stdX}{compressor})
				? ( $test_case->{$stdX}{compressor} . ' -9 --stdout' ) # works actually for gzip and also for bzip2
				: 'cat'

				,$test_case->{$stdX}{output_file}
				,$test_case->{$stdX}{reference_file}
				;

			      printf "  echo -e \"\\ntest_case=>{%s},\\\$stdX=>{%s}\"\n  rm -f '%s'\n"

				,$test_case->{unique_id}
				,$stdX

				,$test_case->{$stdX}{output_file}
				;
			    }
			}
		      else
			{
			  printf "\n  %s \"%s\" |\n  cmp -s - '%s'\n  cmp__exit_code=\$?\n  echo \"test_case=>{%s},\\\$stdX=>{%s},\\\$cmp__exit_code=>\${cmp__exit_code}\"\n"

			    , defined($test_case->{$stdX}{compressor})
			    ? ( $test_case->{$stdX}{compressor} . ' --decompress --stdout' ) # works actually for gzip and also for bzip2
			    : 'cat'
			    ,$test_case->{$stdX}{reference_file}

			    ,$test_case->{$stdX}{output_file}

			    ,$test_case->{unique_id}
			    ,$stdX
			    ;

			  if($main::options{remove_output_files_p})
			    {
			      printf "  test \"\$cmp__exit_code\" -eq 0 && rm -f '%s'\n"
				,$test_case->{$stdX}{output_file}
				;
			    }

			  printf "  test \"\$cmp__exit_code\" -eq 0 || echo maybe you want to diff '%s' \"%s\"\n"
			    ,$test_case->{$stdX}{output_file}
			    ,$test_case->{$stdX}{reference_file}
			    ;
			}
		    }
		}

	      print ")\n";
	    }
	}
    }
  else
    {
      die "\$value->{Application}=>{$value->{Application}}"
    }

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value' => $return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
sub job_propertylist_validate
{
  my($package,$filename,$line_no,$proc_name) = caller(0);

  my(%param) = @_;

  $return_value = 0;

  printf STDERR ">%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  defined($main::options{xml_file}) 		        || die "--xml_file ???";

  system( 'env XML_CATALOG_FILES=$HOME/usr/share/xml/PropertyList/schema/dtd/1.0/catalog.xml xmllint --valid --noout '
	. $main::options{xml_file}
	);

  my($exit_value)  = $? >> 8;
  my($signal_num)  = $? & 127;
  my($dumped_core) = $? & 128;

  printf STDERR "=%s,%d,%s: %s=>{%s},%s=>{%s},%s=>{%s} // %s\n",__FILE__,__LINE__,$proc_name
    ,'$exit_value' => $exit_value
    ,'$signal_num' => $signal_num
    ,'$dumped_core' => $dumped_core
    ,'...'
    if 1 || $main::options{debug};

  printf STDERR "=%d,%s: %s=>{%s} // %s\n",__LINE__,$proc_name
    ,'$return_value' => $return_value
    ,'...'
    if 0 && $main::options{debug};
  printf STDERR "<%d,%s\n",__LINE__,$proc_name
    if 1 && $main::options{debug};

  return $return_value;
}
#
package local_xml_package;

sub load
{
  my($params_of_top_level_utility) = (@_);

  ################################################################################

  $params_of_top_level_utility->{debug} = 0
    unless defined($params_of_top_level_utility->{debug});

  $params_of_top_level_utility->{like_Style_Debug_p} = 0
    unless defined($params_of_top_level_utility->{like_Style_Debug_p});

  $params_of_top_level_utility->{Style} = 'Tree' # 'Debug' ?!?
    unless defined($params_of_top_level_utility->{Style});

  ################################################################################

  my(%local_variables_of_top_level_utility);

  ################################################################################

  use XML::Parser;

  my($p) = new XML::Parser
    ( Style => $params_of_top_level_utility->{Style}
      , Handlers => { Doctype => \&handler_Doctype
                    }
    );

  my($tree);

  if   (1)
    {
      $tree = $p->parsefile($params_of_top_level_utility->{file});
    }
  else
    {
      # this is the example from
      # $ man XML::Parser::Style::Tree

      $tree = $p->parse('<foo><head id="a">Hello <em>there</em></head><bar>Howdy<ref/></bar>do</foo>');
    }

  if   ( $params_of_top_level_utility->{Style} eq 'Debug'  )
    {
    }
  elsif( $params_of_top_level_utility->{Style} eq 'Tree'  )
    {
      @{$local_variables_of_top_level_utility{tree_stack}} = ();

      unshift(@{$tree},{});

      my($value) =
	  &proc_visit_content
	    ($params_of_top_level_utility
	    ,\%local_variables_of_top_level_utility
	    ,{ 'content' => $tree
	     });

      $tree = undef;		# releasing the data structure created by the parser

      return $value;
    }
}

sub proc_visit_content
{
  my($params_of_top_level_utility,$variables_of_top_level_utility,$params) = @_;

  my($return_value);

  my(@pairs) = @{$params->{content}};

  {
    my($ref_attributes) = shift(@pairs); # man XML::Parser::Style::Tree : the first item in the array is a (possibly empty) hash reference containing attributes
    my(@attributes) = %{$ref_attributes};

    if($params_of_top_level_utility->{like_Style_Debug_p})
      {
	printf STDERR "=%03d: %s \\\\ (",__LINE__
	  ,join(' ',@{$variables_of_top_level_utility->{tree_stack}})
	  ;

	my($separator) = '';
	while($#attributes >= 0)
	  {
	    my($name ) = shift(@attributes);
	    my($value) = shift(@attributes);

	    print STDERR $separator , $name , ' "' , $value , '"';

	    $separator = ' '
	      if($separator eq '');
	  }

	printf STDERR ")\n";
      }
  }

  my($current_PropertyList_dict_key);

  while($#pairs >= 0) # man XML::Parser::Style::Tree : the remainder of the array is a sequence of tag-content pairs representing the content of the element
    {
      my($tag    ) = shift(@pairs);
      my($content) = shift(@pairs);

      if   (!defined($tag))
	{
	  die '!defined($tag)';
	}
      elsif($tag eq '0') # man XML::Parser::Style::Tree : text nodes are represented with a pseudo-tag of "0" and the string (aka "PCDATA") is their content
	{
	  if( $content =~ m/^\s*$/ ) # as opposed to Style=>Debug, here we don't deal with the occurrence of space as PCDATA
	    {
	    }
	  else
	    {
	      if($params_of_top_level_utility->{like_Style_Debug_p})
		{
		  printf STDERR "=%03d: %s || {%s}\n",__LINE__
		    ,join(' ',@{$variables_of_top_level_utility->{tree_stack}})
		    ,$content
		    ;
		}

	      if($params_of_top_level_utility->{process_PropertyList_p})
		{
		  # within PropertyList_s we are only interested in PCDATA as part of a key or of "primitive types"

		  if   ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^(key|data|date|real|integer|string)$/)
		    {
		      $return_value = $content;
		    }
		  else
		    {
		      die "\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]=>{$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]},\$content=>{$content}";
		    }
		}
	    }
	}
      elsif($tag ne '0') # man XML::Parser::Style::Tree : for elements, the content is an array reference
	{
	  push( @{$variables_of_top_level_utility->{tree_stack}} , $tag );

	  my($value);		# we are going to visit "content", and $value is what we will get back from visiting the content during PropertyList processing

	  if   (0)
	    {
	    }
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^(true|false)$/))
	    {
	      if(0 && $params_of_top_level_utility->{debug})
		{
		  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
		    ,"\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]"=>$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]
		    ,'...'
		    ;
		}

	      $value = $return_value = ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ 'true')
	    }
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^dict$/))
	    {
	      my(%this_PropertyList_dict);

	      &proc_visit_content
		($params_of_top_level_utility
		,$variables_of_top_level_utility
		,{ 'content' => $content
		 , 'this_PropertyList_dict' => \%this_PropertyList_dict
		 });

	      # we are back from constructing the "dict",
	      # so now we can have a look at it:

	      if(0 && $params_of_top_level_utility->{debug})
		{
		  foreach my $k (sort keys %this_PropertyList_dict)
		    {
		      my($v) = $this_PropertyList_dict{$k};

		      if(ref(\$v) eq 'SCALAR')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,$k=>$v
			    ,'another k=>v assoc ...'
			    ;
			}
		      else
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$this_PropertyList_dict{$k}"=>$this_PropertyList_dict{$k}
			    ,"ref(\$this_PropertyList_dict{$k})"=>ref($this_PropertyList_dict{$k})
			    ,'another k=>v assoc ...'
			    ;
			}
		    }
		}

	      $value = $return_value = \%this_PropertyList_dict;
	    }
	  elsif($params_of_top_level_utility->{process_PropertyList_p} && ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^array$/))
	    {
	      my(@this_PropertyList_array);

	      $value =
		  &proc_visit_content
		    ($params_of_top_level_utility
		    ,$variables_of_top_level_utility
		    ,{ 'content' => $content
		     , 'this_PropertyList_array' => \@this_PropertyList_array
		     });

	      # we are back from constructing the "array",
	      # so now we can have a look at it:

	      if(0 && $params_of_top_level_utility->{debug})
		{
		  my($i);
		  for($i=0;$i<=$#this_PropertyList_array;$i++)
		    {
		      my($v) = $this_PropertyList_array[$i];

		      if(ref(\$v) eq 'SCALAR')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,"\$this_PropertyList_array[$i]"=>$this_PropertyList_array[$i]
			    ,'...'
			    ;
			}
		      else
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$this_PropertyList_array[$i]"=>$this_PropertyList_array[$i]
			    ,"ref(\$this_PropertyList_array[$i])"=>ref($this_PropertyList_array[$i])
			    ,'...'
			    ;
			}
		    }
		}

	      $value = $return_value = \@this_PropertyList_array;
	    }
	  else
	    {
	      # this *may* still be according to $params_of_top_level_utility->{process_PropertyList_p}
	      # or just ordinary expat tree traversal

	      $value = $return_value =
		  &proc_visit_content
		    ($params_of_top_level_utility
		    ,$variables_of_top_level_utility
		    ,{ 'content' => $content
		     });
	    }

	  # after returning from visiting content ...

	  if($params_of_top_level_utility->{process_PropertyList_p})
	    {
	      if(   !defined ($value)
		 && ($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] eq 'string')
		)
		{
		  $value = '';	# I am not sure whether this fixes the <string></string> problem
		}
		

	      if(!defined ($value))
		{
		  die "\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]=>{$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]}"
		}
	      else
		{
		  if   (0)
		    {
		    }
		  elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^key$/)
		    {
		      # so that we will keep the name of the key in mind until we will find the value of this key

		      $current_PropertyList_dict_key = $value; # actually $value here is the key *name*

		      printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			,'$current_PropertyList_dict_key'=>$current_PropertyList_dict_key
			,'with value'
			if 0 && $params_of_top_level_utility->{debug};
		    }
		##elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}] =~ m/^(data|date|real|integer|string|true|false)$/)
		  elsif(1)
		    {
		      if ($#{$variables_of_top_level_utility->{tree_stack}} == 0)
			{
			  # ???

			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,"\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]"=>$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]
			    ,'$#{$variables_of_top_level_utility->{tree_stack}} == 0 ...'
			    if 0 && $params_of_top_level_utility->{debug};
			}
		      elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1] eq 'plist')
			{
			  # ???

			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,"\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]"=>$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]
			    ,"\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1]"=>$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1]
			    ,'...'
			    if 0 && $params_of_top_level_utility->{debug};
			}
		      elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1] eq 'dict')
			{
			  printf STDERR "=%03d: {%s}=>{%s},{%s}=>{%s} // %s\n",__LINE__
			    ,'$current_PropertyList_dict_key'=>$current_PropertyList_dict_key
			    ,'$value'=>$value
			    ,'...'
			    if 0 && $params_of_top_level_utility->{debug};

			  $params->{this_PropertyList_dict}{ $current_PropertyList_dict_key } = $value;
			}
		      elsif($variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1] eq 'array')
			{
			  printf STDERR "=%03d: {%s}=>{%s} // %s\n",__LINE__
			    ,'$value'=>$value
			    ,'pushing a value onto a stack ...'
			    if 0 && $params_of_top_level_utility->{debug};

			  push( @{$params->{this_PropertyList_array}} , $value );
			}
		      else
			{
			  die "\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1]=>{$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}} - 1]}"
			}
		    }
		  else
		    {
		      die "\$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]=>{$variables_of_top_level_utility->{tree_stack}[$#{$variables_of_top_level_utility->{tree_stack}}]}"
		    }
		}
	    }

	  pop( @{$variables_of_top_level_utility->{tree_stack}} );
	}
      else
	{
	  die "\$tag=>{$tag}";
	}

    }

  if($params_of_top_level_utility->{like_Style_Debug_p})
    {
      printf STDERR "=%03d: %s //\n",__LINE__
	,join(' ',@{$variables_of_top_level_utility->{tree_stack}})
	;
    }

  return $return_value;
}

sub handler_Doctype
{
  my($Expat,$Name,$Sysid,$Pubid,$Internal) = (@_);

  # <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

  # =1327: {$_[0]}=>{XML::Parser::Expat=HASH(0x833868c)} // ...
  # =1327: {$_[1]}=>{plist} // ...
  # =1327: {$_[2]}=>{http://www.apple.com/DTDs/PropertyList-1.0.dtd} // ...
  # =1327: {$_[3]}=>{-//Apple Computer//DTD PLIST 1.0//EN} // ...
  # =1327: {$_[4]}=>{1} // ...

  %local_xml_package::Doctype_handler_parameters = ();

  $local_xml_package::Doctype_handler_parameters{Expat}    = $Expat  ;
  $local_xml_package::Doctype_handler_parameters{Name}     = $Name   ;
  $local_xml_package::Doctype_handler_parameters{Sysid}    = $Sysid  ;
  $local_xml_package::Doctype_handler_parameters{Pubid}    = $Pubid  ;
  $local_xml_package::Doctype_handler_parameters{Internal} = $Internal;
}
__END__

=head1 NAME

... - ...

=head1 SYNOPSIS

... [options] [file ...]

Options:
    --help
    --man

    --job_...

    --xml_file

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--job_propertylist_validate>

...

=item B<--job_regression_test>

This job runs the regression_test.

See C<--create_reference_files_p> below!

...

=item B<--job_iTunes_whatever>

...

=item B<--remove_output_files_p>

As long as you are developing certain software,
you probably want to keep the output files generated,
therefore you would use C<--noremove_output_files_p> .

...

=item B<--create_reference_files_p>

You don't want to capture the reference files manually, do you?

So in case of C<--create_reference_files_p>
instead of comparing the output to the reference files
we create the respective reference files from the output.

We expect you to restrict the creation of reference files by specifying the test case on the command line.

...

=item B<--test_cases>

Name the test case you want to run!

You can specify this option more than once.

...

=item B<--job_...>

...

=back

=head1 DESCRIPTION

B<This program> will ...

...

=head1 EXAMPLES

...

=cut
