#!/usr/bin/perl -w

# $Id: colorsel.pl,v 1.9 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-colorselection.html

use Gtk2;


my $colorseldlg;
my $drawingarea;
my $color;

sub TRUE  {1}
sub FALSE {0}

# Color changed handler
sub color_changed_cb
  {
    my ($widget, $colorsel) = @_;
    my $ncolor = $colorsel->get_current_color;
    #printf "CB: %d %d %d\n", $ncolor->red,$ncolor->green,$ncolor->blue;
    $drawingarea->modify_bg('normal', $ncolor);
  }

# Drawingarea event handler

sub area_event
  {
    my ($widget, $event, $client_data) = @_;
    #print STDERR "AE: $widget / $event / $client_data \n";
    my $handled = FALSE;
    # Check if we've received a button pressed event

    if ($event->get_type eq 'button-press')
      {
          # Stuff to inspect the contents of the event
#	  my @names = qw(type window send_event time x y state button x_root y_root);
#	  print "GdkEventButton <$event>:\n";
#	  foreach (@names) {
#	      my $v = $event->$_();
#	      ref($v) eq 'ARRAY' and $v = "@{$v}";  # state is some flags so it's an arrayref
#	      print "  $_: $v\n";
#	  }
	$handled = TRUE;
	# Create color selection dialog
	$colorseldlg = Gtk2::ColorSelectionDialog->new("Select background color") unless defined $colorseldlg;
	# Get the ColorSelection widget
	my $colorsel = $colorseldlg->colorsel;
	$colorsel->set_previous_color($color);
	$colorsel->set_current_color($color);
	$colorsel->set_has_palette(TRUE);
	#printf "AE: %d %d %d\n", $color->red,$color->green,$color->blue;
	# Connect to the "color_changed" signal, set the client-data to the colorsel widget
	$colorsel->signal_connect("color_changed", \&color_changed_cb, $colorsel);
	# Show the dialog
	my $response = $colorseldlg->run;
	if ($response eq 'ok')  { $color = $colorsel->get_current_color; }
	else { $drawingarea->modify_bg('normal', $color); }
	$colorseldlg->hide;
      }
    return $handled;
  }

# Close down and exit handler
sub destroy_window
{
  Gtk2->quit;
  return TRUE;
}

# main()
Gtk2->init(\@ARGV);
# Create toplevel window, set title and policies
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Color selection test");
$window->set_resizable(TRUE);
# Attach to the "delete" and "destroy" events so we can exit
Gtk2::GSignal->connect($window, "delete_event", \&destroy_window, $window);
# Create drawingarea, set size and catch button events
$drawingarea = Gtk2::DrawingArea->new;
$color = Gtk2::Gdk::Color->new(0,65535,0);
$drawingarea->modify_bg('normal', $color);
$drawingarea->set_size_request(200, 200);
$drawingarea->set_events('button_press_mask');
Gtk2::GSignal->connect($drawingarea, "event", \&area_event, $drawingarea);
# Add drawingarea to window, then show them both
$window->add($drawingarea);
$drawingarea->show;
$window->show_all;
Gtk2->main;
0;
