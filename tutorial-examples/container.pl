#!/usr/bin/perl -w

use Gtk2;

sub TRUE  {1}
sub FALSE {0}


Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Event Box");
Gtk2::GSignal->connect($window, "destroy", sub { exit 0 });
$window->set_border_width(10);
#    /* Create an EventBox and add it to our toplevel window */
my $event_box = Gtk2::EventBox->new;
$window->add($event_box);
$event_box->show;
#    /* Create a long label */
my $label = Gtk2::Label->new("Click here to quit, quit, quit, quit, quit");
$event_box->add($label);
$label->show;
#    /* Clip it short. */
$label->set_size_request(110, 20);
#    /* And bind an action to it */
$event_box->set_events('button-press-mask');
Gtk2::GSignal->connect($event_box, "button_press_event", sub { exit 0 });
#    /* Yet one more thing you need an X window for ... */
$event_box->realize;
$event_box->get_parent_window->set_cursor(Gtk2::Gdk::Cursor->new(Gtk2::Gdk->HAND1));
$window->show;
Gtk2->main;
0;
