#!/usr/bin/perl -w

use IO::File;
use IO::Dir;
use File::stat;


sub printdir
  {
    my %cvsfiler = ();
    my $dir = shift;
#    print STDERR "### changing to $dir\n";
    my $fh = IO::File->new("< $dir/CVS/Entries");
    for my $r (<$fh>)
      {
	my $fil = $1 if $r =~ /\/([^\/]+)/;
	next unless $fil;
	$cvsfiler{$fil} = 1;
	if ($r =~ /^D\//) 
	  { 
#	    print STDERR "### processing to $fil\n";
	    printdir("$dir/$fil") if -d "$dir/$fil";
	  }
      }
#    print STDERR map { "$_\n" } sort keys %cvsfiler;
    $fh->close;
    my $dh = IO::Dir->new($dir);
    while (defined($r = $dh->read))
      { 
	next if $r eq '.' or $r eq '..' or $r eq 'CVS';
	if (defined($cvsfiler{$r}) and $cvsfiler{$r} == 1)
	  {
	    my $r2 = "$dir/$r";
	    unless (-d $r2)
	      {
		$r2 =~ s/^\.\///;
		print "$r2\n";
	      }
	  }
      }
  }

printdir('.');

1;

