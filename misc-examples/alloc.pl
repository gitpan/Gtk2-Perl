#!/usr/bin/perl -w

use Gtk2;

# create the main app
my $app = Gtk2->main_window;

# when the main window is resized, keep the main window size
$app->signal_connect('size_allocate' =>
		     sub {
		       my ($widget, $allocation, $data) = @_;
		       printf STDERR "W: %d, H: %d\n",
			 $allocation->width, $allocation->height;
		     });
$app->show;
Gtk2->main;
0;


