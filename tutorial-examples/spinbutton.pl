#!/usr/bin/perl -w

# $Id: spinbutton.pl,v 1.3 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

use Gtk2;


sub TRUE  {1}
sub FALSE {0}


my $spinner1;

sub toggle_snap
{
  my ($widget, $spin) = @_;
  $spin->set_snap_to_ticks($widget->active);
}

sub toggle_numeric
{
  my ($widget, $spin) = @_;
  $spin->set_numeric($widget->active);
}

sub change_digits
{
  my ($widget, $spin) = @_;
  $spinner1->set_digits($spin->get_value_as_int);
}

sub get_value
{
  my ($widget, $data) = @_;
  my $buf = '';
  my $spin = $spinner1;
  my $label = $widget->get_data("user_data");
  if ($data == 1) { $buf = sprintf "%d", $spin->get_value_as_int; }
  else { $buf = sprintf "%0.*f", $spin->get_digits, $spin->get_value; }
  $label->set_text($buf);
}

Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
Gtk2::GSignal->connect($window, "destroy", sub { Gtk2->quit });
$window->set_title("Spin Button");
my $main_vbox = Gtk2::VBox->new(FALSE, 5);
$main_vbox->set_border_width(10);
$window->add($main_vbox);
my $frame = Gtk2::Frame->new("Not accelerated");
$main_vbox->pack_start($frame, TRUE, TRUE, 0);
my $vbox = Gtk2::VBox->new(FALSE, 0);
$vbox->set_border_width(5);
$frame->add($vbox);
# Day, month, year spinners
my $hbox = Gtk2::HBox->new(FALSE, 0);
$vbox->pack_start($hbox, TRUE, TRUE, 5);
my $vbox2 = Gtk2::VBox->new(FALSE, 0);
$hbox->pack_start($vbox2, TRUE, TRUE, 5);
my $label = Gtk2::Label->new("Day :");
$label->set_alignment(0, 0.5);
$vbox2->pack_start($label, FALSE, TRUE, 0);
my $adj = Gtk2::Adjustment->new(1.0, 1.0, 31.0, 1.0, 5.0, 0.0);
my $spinner = Gtk2::SpinButton->new($adj, 0, 0);
$spinner->set_wrap(TRUE);
$vbox2->pack_start($spinner, FALSE, TRUE, 0);
$vbox2 = Gtk2::VBox->new(FALSE, 0);
$hbox->pack_start($vbox2, TRUE, TRUE, 5);
$label = Gtk2::Label->new("Month :");
$label->set_alignment(0, 0.5);
$vbox2->pack_start($label, FALSE, TRUE, 0);
$adj = Gtk2::Adjustment->new(1.0, 1.0, 12.0, 1.0, 5.0, 0.0);
$spinner = Gtk2::SpinButton->new($adj, 0, 0);
$spinner->set_wrap(TRUE);
$vbox2->pack_start($spinner, FALSE, TRUE, 0);
$vbox2 = Gtk2::VBox->new(FALSE, 0);
$hbox->pack_start($vbox2, TRUE, TRUE, 5);
$label = Gtk2::Label->new("Year :");
$label->set_alignment(0, 0.5);
$vbox2->pack_start($label, FALSE, TRUE, 0);
$adj = Gtk2::Adjustment->new(1998.0, 0.0, 2100.0, 1.0, 100.0, 0.0);
$spinner = Gtk2::SpinButton->new($adj, 0, 0);
$spinner->set_wrap(FALSE);
$spinner->set_size_request(55, -1);
$vbox2->pack_start($spinner, FALSE, TRUE, 0);
$frame = Gtk2::Frame->new("Accelerated");
$main_vbox->pack_start($frame, TRUE, TRUE, 0);
$vbox = Gtk2::VBox->new(FALSE, 0);
$vbox->set_border_width(5);
$frame->add($vbox);
$hbox = Gtk2::HBox->new(FALSE, 0);
$vbox->pack_start($hbox, FALSE, TRUE, 5);
$vbox2 = Gtk2::VBox->new(FALSE, 0);
$hbox->pack_start($vbox2, TRUE, TRUE, 5);
$label = Gtk2::Label->new("Value :");
$label->set_alignment(0, 0.5);
$vbox2->pack_start($label, FALSE, TRUE, 0);
$adj = Gtk2::Adjustment->new(0.0, -10000.0, 10000.0, 0.5, 100.0, 0.0);
$spinner1 = Gtk2::SpinButton->new($adj, 1.0, 2);
$spinner1->set_wrap(TRUE);
$spinner1->set_size_request(100, -1);
$vbox2->pack_start($spinner1, FALSE, TRUE, 0);
$vbox2 = Gtk2::VBox->new(FALSE, 0);
$hbox->pack_start($vbox2, TRUE, TRUE, 5);
$label = Gtk2::Label->new("Digits :");
$label->set_alignment(0, 0.5);
$vbox2->pack_start($label, FALSE, TRUE, 0);
$adj = Gtk2::Adjustment->new(2, 1, 5, 1, 1, 0);
my $spinner2 = Gtk2::SpinButton->new($adj, 0.0, 0);
$spinner2->set_wrap(TRUE);
Gtk2::GSignal->connect($adj, "value_changed", \&change_digits, $spinner2);
$vbox2->pack_start($spinner2, FALSE, TRUE, 0);
$hbox = Gtk2::HBox->new(FALSE, 0);
$vbox->pack_start($hbox, FALSE, TRUE, 5);
my $button = Gtk2::CheckButton->new_with_label("Snap to 0.5-ticks");
Gtk2::GSignal->connect($button, "clicked", \&toggle_snap, $spinner1);
$vbox->pack_start($button, TRUE, TRUE, 0);
$button->set_active(TRUE);
$button = Gtk2::CheckButton->new_with_label("Numeric only input mode");
Gtk2::GSignal->connect($button, "clicked", \&toggle_numeric, $spinner1);
$vbox->pack_start($button, TRUE, TRUE, 0);
$button->set_active(TRUE);
my $val_label = Gtk2::Label->new("");
$hbox = Gtk2::HBox->new(FALSE, 0);
$vbox->pack_start($hbox, FALSE, TRUE, 5);
$button = Gtk2::Button->new_with_label("Value as Int");
$button->set_data("user_data", $val_label);
Gtk2::GSignal->connect($button, "clicked", \&get_value, 1);
$hbox->pack_start($button, TRUE, TRUE, 5);
$button = Gtk2::Button->new_with_label("Value as Float");
$button->set_data("user_data", $val_label);
Gtk2::GSignal->connect($button, "clicked", \&get_value, 2);
$hbox->pack_start($button, TRUE, TRUE, 5);
$vbox->pack_start($val_label, TRUE, TRUE, 0);
$val_label->set_text("0");
$hbox = Gtk2::HBox->new(FALSE, 0);
$main_vbox->pack_start($hbox, FALSE, TRUE, 0);
$button = Gtk2::Button->new_with_label("Close");
Gtk2::GSignal->connect_swapped($button, "clicked", sub { shift->destroy }, $window);
$hbox->pack_start($button, TRUE, TRUE, 5);
$window->show_all;
Gtk2->main;
0;

