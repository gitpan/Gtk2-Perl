#!/usr/bin/perl -w

# $Id: statusbar.pl,v 1.3 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-statusbars.html

use Gtk2;

sub TRUE  {1}
sub FALSE {0}


my $status_bar; # GtkWidget*
my $push_count = 1;

sub push_item
{
  my ($widget, $data) = @_;
  my $buff = sprintf("Item %d", $push_count++);
  $status_bar->push($data, $buff);
}

sub pop_item
{
  my ($widget, $data) = @_;
  $status_bar->pop($data);
}


Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_size_request(200, 100);
$window->set_title("GTK Statusbar Example");
Gtk2::GSignal->connect($window, "delete_event", sub { exit });
my $vbox = Gtk2::VBox->new(FALSE, 1);
$window->add($vbox);
$vbox->show;
$status_bar = Gtk2::Statusbar->new; 
$vbox->pack_start($status_bar, TRUE, TRUE, 0);
$status_bar->show;
my $context_id = $status_bar->get_context_id("Statusbar example");
my $button = Gtk2::Button->new_with_label("push item");
Gtk2::GSignal->connect($button, "clicked", \&push_item, $context_id);
$vbox->pack_start($button, TRUE, TRUE, 2);
$button->show;
$button = Gtk2::Button->new_with_label("pop last item");
Gtk2::GSignal->connect($button, "clicked", \&pop_item, $context_id);
$vbox->pack_start($button, TRUE, TRUE, 2);
$button->show;
# always display the window as the last step so it all splashes on the screen at once.
$window->show;
Gtk2->main;
0;


