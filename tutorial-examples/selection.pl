#!/usr/bin/perl -w

# $Id: selection.pl,v 1.9 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-retrievingtheselection.html

use Gtk2;

sub TRUE  {1}
sub FALSE {0}


# Signal handler invoked when user clicks on the "Get Targets" button

sub get_targets
  {
    my ($target, $win) = @_;
    #print STDERR "T: $target, W: $win\n";
    # And request the "TARGETS" target for the primary selection
    $win->selection_convert('PRIMARY', 'TARGETS', Gtk2::Gdk->CURRENT_TIME);
  }

 # Signal handler called when the selections owner returns the data
sub selection_received
  {
    my ($widget, $selection_data) = @_;
    #printf STDERR "W: $widget, SD: $selection_data, LEN: %d \n", $selection_data->length;
    # **** IMPORTANT **** Check to see if retrieval succeeded
    if ($selection_data->length < 0)
      {
	print "Selection retrieval failed\n";
      }
    # Make sure we got the data in the expected form
    elsif ($selection_data->type ne 'ATOM')
      {
	print "Selection \"TARGETS\" was not returned as atoms!\n";
      }
    # Print out the atoms we received
    else
      {
	my $name;
	my $atoms = $selection_data->data;
	for my $atom (@$atoms)
	  {
	    $name = $atom->name;
	    if ($name) { printf("%s\n",$name); }
	    else { print "(bad atom)\n"; }
	  }
      }
  }

Gtk2->init(\@ARGV);
# Create the toplevel window
my $window = Gtk2::Window->new('toplevel');
$window->set_title('Event Box');
$window->set_border_width(10);
$window->signal_connect("destroy", sub { exit; });
# Create a button the user can click to get targets
my $button = Gtk2::Button->new("Get Targets");
$window->add($button);
$button->signal_connect("clicked", \&get_targets, $window);
$window->signal_connect("selection_received", \&selection_received);
$button->show;
$window->show;
Gtk2->main;
0;



