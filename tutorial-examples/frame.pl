#!/usr/bin/perl -w

use Gtk2;


Gtk2->init(\@ARGV);
# Create a new window
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Frame Example");
# Here we connect the "destroy" event to a signal handler
Gtk2::GSignal->connect($window, "destroy", sub { Gtk2->quit });
$window->set_size_request(300, 300);
# Sets the border width of the window.
$window->set_border_width(10);
# Create a Frame
my $frame = Gtk2::Frame->new;
$window->add($frame);
# Set the frame's label
$frame->set_label("GTK Frame Widget");
# Align the label at the right of the frame 
$frame->set_label_align(1.0, 0.0);
# Set the style of the frame
$frame->set_shadow_type('etched-out');
$frame->show;
# Display the window
$window->show;
# Enter the event loop
Gtk2->main;
0;
