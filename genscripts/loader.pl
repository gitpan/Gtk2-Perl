#!/usr/bin/perl -w
#
# $Id: loader.pl,v 1.2 2002/12/13 14:28:06 ggc Exp $

use IO::File;

my $lfile = IO::File->new("> Gtk2/_loader.pm");

print $lfile 
  "# Autogenerate file, do not edit\n",
  "# run genscripts/loader.pl instead\n",
  '# $'.'Id$'."\n\n";

for my $dir qw(Gtk2 Gtk2/Gdk Gtk2/Gdk/Event Gtk2/Pango Gtk2/Atk)
  {
    opendir(DIR, $dir) || die "can't opendir $dir: $!";
    foreach my $file (sort readdir DIR) {
      next unless $file =~ /\.pm$/;
      my $path = "$dir/$file";
      next if -d $path;
      next if $file =~ /^_/;
      $module = $dir . '::' . $file;
      next if $module eq 'Test.pm';
      $module =~ s{\.pm$}{};
      $module =~ s{/}{::}g;
      print $lfile "\@$module\:\:ISA=qw(Gtk2::_Object) unless \@$module\:\:ISA;\n";
    }
    closedir DIR;
  }
$lfile->close;
