#!/usr/bin/perl -w
require 5.000; use strict 'vars', 'refs', 'subs';

# Copyright 2002, Dermot Musgrove
#
# This script is released under the same conditions as Perl, that
# is, either of the following:
#
# a) the GNU General Public License as published by the Free
# Software Foundation; either version 1, or (at your option) any
# later version.
#
# b) the Artistic License.
#
# $Id: compile-widgets.pl,v 1.13 2002/11/18 17:31:28 gthyni Exp $
#

my $flags = shift || ''; # flags sent to Inline
$flags = "-MInline=${flags}" if $flags;

select STDOUT; $|=1;
print "No DISPLAY set, no window will be displayed\n" unless $ENV{DISPLAY};
my @bootstrap_objs = qw(Gtk2::GType Gtk2::GSignal Gtk2::GObject Gtk2::Widget Gtk2::Container
                        Gtk2::Window Gtk2::_Helpers Gtk2 Gtk2::Button Gtk2::Misc Gtk2::Label);
foreach (@bootstrap_objs) {
    print "Compiling $_ ";
    eval "use $_";
    $@ and die "FAILED: $@";
    print "- DONE\n";
}

sub FALSE { 0 }
sub TRUE  { 1 }

# we use two functions so that we can redefine the implementation 
# when compilation is finished
sub real_close_app {
    print "- interrupted\n";
    exit 0;
}
sub close_application {
    real_close_app();
}

my $button;
if ($ENV{DISPLAY})
  {
    Gtk2->init(\@ARGV);
    my $window = Gtk2::Window->new('toplevel');
    $window->set_title("Inline compilation of Gtk2");
    $window->set_border_width(5);
    $window->set_position('center');
    $button = Gtk2::Button->new;
    $window->add($button);
    $button->show;
    my $label = Gtk2::Label->new("Starting Inline compilation");
    $button->add($label);
    $label->show;
    $button->signal_connect("clicked", \&close_application);
    $window->signal_connect("destroy", \&close_application);
    $window->signal_connect("delete_event", \&close_application);
    $window->show;
  }

# Use() each widget to trigger compilation
#my $dir = "Gtk2";

for my $dir qw(Gtk2 Gtk2/Gdk Gtk2/Gdk/Event Gtk2/Pango)
  {
    opendir(DIR, $dir) || die "can't opendir $dir: $!";
    foreach my $module (sort readdir DIR) {
      if ($module =~ s/\.pm$//) {
	next if $module =~ /^_[a-z]/;
	(my $tdir = $dir) =~ s|/|::|g;
	print "Compiling $tdir\::${module} ";
	if ($ENV{DISPLAY})
	  {
	    $button->set_label("Compiling $tdir\::$module");
	    Gtk2->update_ui();
	  }
	my $cmd = "perl ${flags} -e 'use $tdir\::$module;0'";
	#print $cmd;
        system $cmd;
	print "- DONE\n";
      }
    }
    closedir DIR;
  }

if ($ENV{DISPLAY})
  {
    $button->set_label("All widgets are compiled - click to quit");
    undef *real_close_app;
    *real_close_app = sub { Gtk2->quit };
    # Rest in gtk_main and wait for the fun to begin!
    Gtk2->main;
  }
0;
