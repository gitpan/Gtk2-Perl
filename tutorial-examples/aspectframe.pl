#!/usr/bin/perl -w

use Gtk2;

sub TRUE  {1}
sub FALSE {0}


Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Aspect Frame");
Gtk2::GSignal->connect($window, "destroy", sub { Gtk2->quit });
$window->set_border_width(10);
# Create an aspect_frame and add it to our toplevel window
my $aspect_frame = Gtk2::AspectFrame->new("2x1", 0.5, 0.5, 2, FALSE);
$window->add($aspect_frame);
$aspect_frame->show;
# Now add a child widget to the aspect frame
$drawing_area = Gtk2::DrawingArea->new;
# Ask for a 200x200 window, but the AspectFrame will give us a 200x100
# window since we are forcing a 2x1 aspect ratio
$drawing_area->set_size_request(200, 200);
$aspect_frame->add($drawing_area);
$drawing_area->show;
$window->show;
Gtk2->main;
0;
