#!/usr/bin/perl -w

# $Id: textentry.pl,v 1.7 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-textentries.html


use Gtk2;


sub TRUE  {1}
sub FALSE {0}


sub enter_callback
{
  my ($widget, $entry) = @_;
  printf "Entry contents: %s\n", $entry->get_text;
}

sub entry_toggle_editable
{
  my ($checkbutton, $entry) = @_;
  $entry->set_editable($checkbutton->active);
}

sub entry_toggle_visibility
{
  my ($checkbutton, $entry) = @_;
  $entry->set_visibility($checkbutton->active);
}

Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_size_request(200, 100);
$window->set_title("GTK Entry");
$window->signal_connect("destroy" => sub { Gtk2->quit });
$window->signal_connect_swapped("delete_event" => sub { shift->destroy }, $window);
my $vbox = Gtk2::VBox->new(FALSE, 0);
$window->add($vbox);
$vbox->show;
my $entry = Gtk2::Entry->new;
$entry->set_max_length(50);
Gtk2::GSignal->connect($entry, "activate", \&enter_callback, $entry);
$entry->set_text("hello");
$entry->insert_text(" world", -1);
$entry->select_region(0, $entry->text_length);
$vbox->pack_start($entry, TRUE, TRUE, 0);
$entry->show;
my $hbox = Gtk2::HBox->new(FALSE, 0);
$vbox->add($hbox);
$hbox->show;
my $check = Gtk2::CheckButton->new_with_label("Editable");
$hbox->pack_start($check, TRUE, TRUE, 0);
Gtk2::GSignal->connect($check, "toggled", \&entry_toggle_editable, $entry);
$check->set_active(TRUE);
$check->show;
$check = Gtk2::CheckButton->new_with_label("Visible");
$hbox->pack_start($check, TRUE, TRUE, 0);
Gtk2::GSignal->connect($check, "toggled", \&entry_toggle_visibility, $entry);
$check->set_active(TRUE);
$check->show;
my $button = Gtk2::Button->new_from_stock(Gtk2::Stock->CLOSE);
Gtk2::GSignal->connect_swapped($button, "clicked", sub { shift->destroy }, $window);
$vbox->pack_start($button, TRUE, TRUE, 0);
$button->SET_FLAGS('can-default');
$button->grab_default;
$button->show;
$window->show;
Gtk2->main;
0;
