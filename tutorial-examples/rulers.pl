#!/usr/bin/perl -w

# $Id: rulers.pl,v 1.8 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-rulers.html

use Gtk2;

# OK, I use inline here
# Could say it was to demostrate use of Inline with Gtk2-perl
# but really I just can't figure out how to do this in perl right now

use Inline C => Config =>
  LIBS => `pkg-config gtk+-2.0 --libs`,
  OPTIMIZE => '-g -Wall -Werror',
  INC => '-I../../../Gtk2/include '.`pkg-config gtk+-2.0 --cflags`;
use Inline C => <<'ENDCODE';

#include "gtk2-perl.h"

#define EVENT_METHOD(i, x) GTK_WIDGET_GET_CLASS(i)->x

void set_signal(SV* area, SV* ruler)
  {
    GtkWidget* r = SvGtkWidget(ruler);
    g_signal_connect_swapped(SvGObject(area), "motion_notify_event",
			     G_CALLBACK (EVENT_METHOD (r, motion_notify_event)),
			     G_OBJECT (r));
  }

ENDCODE




#define EVENT_METHOD(i, x) GTK_WIDGET_GET_CLASS(i)->x

sub XSIZE { 600 }
sub YSIZE { 400 }

sub TRUE  {1}
sub FALSE {0}

# This routine gets control when the close button is clicked
sub close_application
{
  Gtk2->main_quit;
  FALSE;
}

# Initialize GTK and create the main window 
Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
Gtk2::GSignal->connect($window, "delete_event", \&close_application);
$window->set_border_width(10);
# Create a table for placing the ruler and the drawing area
my $table = Gtk2::Table->new(3, 2, FALSE);
$window->add($table);
my $area = Gtk2::DrawingArea->new;
$area->set_size_request(XSIZE, YSIZE);
$table->attach($area, 1, 2, 1, 2, ['expand', 'fill'], 'fill', 0, 0);
$area->set_events(['pointer-motion-mask', 'pointer-motion-hint-mask']);
# The horizontal ruler goes on top. As the mouse moves across the
# drawing area, a motion_notify_event is passed to the
# appropriate event handler for the ruler.
my $hrule = Gtk2::HRuler->new;
$hrule->set_metric('pixels');
$hrule->set_range(7, 13, 0, 20);
#Gtk2::GSignal->connect_swapped($area, "motion_notify_event", sub { $hrule->motion_notify_event }, $hrule);
set_signal($area,$hrule);
$table->attach($hrule, 1, 2, 0, 1, ['expand', 'fill'], 'fill', 0, 0);
# The vertical ruler goes on the left. As the mouse moves across
# the drawing area, a motion_notify_event is passed to the
# appropriate event handler for the ruler.
my $vrule = Gtk2::VRuler->new;
$vrule->set_metric('pixels');
$vrule->set_range(0, YSIZE, 10, YSIZE );
#Gtk2::GSignal->connect_swapped($area, "motion_notify_event", sub { $vrule->motion_notify_event }, $vrule);
set_signal($area,$vrule);
$table->attach($vrule, 0, 1, 1, 2, 'fill', ['expand', 'shrink', 'fill'], 0, 0);
# Now show everything
$area->show;
$hrule->show;
$vrule->show;
$table->show;
$window->show;
Gtk2->main;
0;

