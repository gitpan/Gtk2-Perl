#!/usr/bin/perl -w

use Gtk2;

# $Id: hello2.pl,v 1.5 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

#* Our new improved callback.  The data passed to this function
# * is printed to stdout. */

sub callback
{
  my ($widget, $data) = @_;
  printf "Hello again - %s was pressed\n", $data;
  print "W: $widget, D: $data\n";
}

sub delete_event
{
  print "delete event occurred\n";
  Gtk2->quit;
  0;
}

#/* Another callback */
sub destroy
{
  my ($widget, $event, $data) = @_;
  Gtk2->quit;
}

Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Hello Buttons!");
Gtk2::GSignal->connect($window, "delete_event", \&delete_event, 0);
Gtk2::GSignal->connect($window, "destroy", \&destroy, 0);
$window->set_border_width(10);
my $box1 = Gtk2::HBox->new(0,0);
$window->add($box1);
my $button = Gtk2::Button->new_with_label("Button 1");
print "B: $button\n";
Gtk2::GSignal->connect($button, "clicked", \&callback, "button 1");
$box1->pack_start($button,1,1,0);
$button->show;
$button = Gtk2::Button->new_with_label("Button 2");
Gtk2::GSignal->connect($button, "clicked", \&callback, "button 2");
$box1->pack_start($button,1,1,0);
$button->show;
$box1->show;
$window->show;
Gtk2->main;
0;

