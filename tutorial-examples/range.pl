#!/usr/bin/perl -w

# $Id: range.pl,v 1.6 2002/11/20 18:02:43 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

use Gtk2;

sub TRUE  {1}
sub FALSE {0}

my ($hscale, $vscale) = ();

sub cb_pos_menu_select
{
  my ($item,$pos) = @_;
  #/* Set the value position on both scale widgets */
  $hscale->set_value_pos($pos);
  $vscale->set_value_pos($pos);
}

sub cb_update_menu_select
{
  my ($item,$policy) = @_;
  #/* Set the update policy for both scale widgets */
  $hscale->set_update_policy($policy);
  $vscale->set_update_policy($policy);
}

sub cb_digits_scale
{
  my ($adj) = @_;
  # /* Set the number of decimal places to which adj->value is rounded */
  $hscale->set_digits($adj->value);
  $vscale->set_digits($adj->value);
}

sub cb_page_size
{
  my ($get,$set) = @_;
  # /* Set the page size and page increment size of the sample
  #  * adjustment to the value specified by the "Page Size" scale */
  #print "GET: $get, SET: $set\n";
  $set->page_size($get->value);
  $set->page_increment($get->value);
  #/* This sets the adjustment and makes it emit the "changed" signal to 
  #   reconfigure all the widgets that are attached to this signal.  */
  $set->value(Gtk2::GLib->CLAMP($set->value, $set->lower, ($set->upper - $set->page_size)));
}

sub cb_draw_value
{
  my $button = shift;
  #/* Turn the value display on the scale widgets off or on depending
  # *  on the state of the checkbutton */
  $hscale->set_draw_value($button->active);
  $vscale->set_draw_value($button->active);
}

#/* Convenience functions */

sub make_menu_item
{
  my ($name, $callback, $data) = @_;
  my $item = Gtk2::MenuItem->new_with_label($name);
  Gtk2::GSignal->connect($item, "activate", $callback, $data);
  $item->show;
  return $item;
}

sub scale_set_default_values
{
  my $scale = shift;
  $scale->set_update_policy('continuous');
  $scale->set_digits(1);
  $scale->set_value_pos('top');
  $scale->set_draw_value(TRUE);
}

#/* makes the sample window */

sub quit { Gtk2->quit; }

sub create_range_controls
{
  # /* Standard window-creating stuff */
  my $window = Gtk2::Window->new('toplevel');
  Gtk2::GSignal->connect($window, "destroy", \&quit, 0);
  $window->set_title("range controls");
  my $box1 = Gtk2::VBox->new(FALSE, 0);
  $window->add($box1);
  $box1->show;
  my $box2 = Gtk2::HBox->new(FALSE, 10);
  $box2->set_border_width(10);
  $box1->pack_start($box2, TRUE, TRUE, 0);
  $box2->show;
  #/* value, lower, upper, step_increment, page_increment, page_size */
  #/* Note that the page_size value only makes a difference for
  # * scrollbar widgets, and the highest value you'll get is actually
  # * (upper - page_size). */
  my $adj1 = Gtk2::Adjustment->new(0.0, 0.0, 101.0, 0.1, 1.0, 1.0);
  $vscale = Gtk2::VScale->new($adj1);
  scale_set_default_values($vscale);
  $box2->pack_start($vscale, TRUE, TRUE, 0);
  $vscale->show;
  my $box3 = Gtk2::VBox->new(FALSE, 10);
  $box2->pack_start($box3, TRUE, TRUE, 0);
  $box3->show;
  #/* Reuse the same adjustment */
  $hscale = Gtk2::HScale->new($adj1);
  $hscale->set_size_request(200, -1);
  scale_set_default_values($hscale);
  $box3->pack_start($hscale, TRUE, TRUE, 0);
  $hscale->show;
  #/* Reuse the same adjustment again */
  my $scrollbar = Gtk2::HScrollbar->new($adj1);
  #/* Notice how this causes the scales to always be updated
  # * continuously when the scrollbar is moved */
  $scrollbar->set_update_policy('continuous');
  $box3->pack_start($scrollbar, TRUE, TRUE, 0);
  $scrollbar->show;
  $box2 = Gtk2::HBox->new(FALSE, 10);
  $box2->set_border_width(10);
  $box1->pack_start($box2, TRUE, TRUE, 0);
  $box2->show;
  #/* A checkbutton to control whether the value is displayed or not */
  my $button = Gtk2::CheckButton->new_with_label("Display value on scale widgets");
  #print STDERR "B1: $button \n";
  $button->set_active(TRUE);
  Gtk2::GSignal->connect($button, "toggled", \&cb_draw_value);
  $box2->pack_start($button, TRUE, TRUE, 0);
  $button->show;
  $box2 = Gtk2::HBox->new(FALSE, 10);
  $box2->set_border_width(10);
  #/* An option menu to change the position of the value */
  my $label = Gtk2::Label->new("Scale Value Position:");
  $box2->pack_start($label, FALSE, FALSE, 0);
  $label->show;
  my $opt = Gtk2::OptionMenu->new;
  my $menu = Gtk2::Menu->new;
  my $item = make_menu_item("Top", \&cb_pos_menu_select, 'top');
  $menu->append($item);
  $item = make_menu_item ("Bottom", \&cb_pos_menu_select, 'bottom');
  $menu->append($item);
  $item = make_menu_item("Left", \&cb_pos_menu_select, 'left');
  $menu->append($item);
  $item = make_menu_item("Right", \&cb_pos_menu_select, 'right');
  $menu->append($item);
  $opt->set_menu($menu);
  $box2->pack_start($opt, TRUE, TRUE, 0);
  $opt->show;
  $box1->pack_start($box2, TRUE, TRUE, 0);
  $box2->show;
  $box2 = Gtk2::HBox->new(FALSE, 10);
  $box2->set_border_width(10);
  #/* Yet another option menu, this time for the update policy of the
  # * scale widgets */
  $label = Gtk2::Label->new("Scale Update Policy:");
  $box2->pack_start($label, FALSE, FALSE, 0);
  $label->show;
  $opt = Gtk2::OptionMenu->new;
  $menu = Gtk2::Menu->new;
  $item = make_menu_item("Continuous", \&cb_update_menu_select, 'continuous');
  $menu->append($item);
  $item = make_menu_item ("Discontinuous", \&cb_update_menu_select, 'discontinuous');
  $menu->append($item);
  $item = make_menu_item ("Delayed", \&cb_update_menu_select, 'delayed');
  $menu->append($item);
  $opt->set_menu($menu);
  $box2->pack_start($opt, TRUE, TRUE, 0);
  $opt->show;
  $box1->pack_start($box2, TRUE, TRUE, 0);
  $box2->show;
  $box2 = Gtk2::HBox->new(FALSE,10);
  $box2->set_border_width(10);
  #/* An HScale widget for adjusting the number of digits on the
  # * sample scales. */
  $label = Gtk2::Label->new("Scale Digits:");
  $box2->pack_start($label, FALSE, FALSE, 0);
  $label->show;
  my $adj2 = Gtk2::Adjustment->new(1.0, 0.0, 5.0, 1.0, 1.0, 0.0);
  $adj2->signal_connect("value_changed" => \&cb_digits_scale);
  my $scale = Gtk2::HScale->new($adj2);
  $scale->set_digits(0);
  $box2->pack_start($scale, TRUE, TRUE, 0);
  $scale->show;
  $box1->pack_start($box2, TRUE, TRUE, 0);
  $box2->show;
  $box2 = Gtk2::HBox->new(FALSE, 10);
  $box2->set_border_width(10);
  #/* And, one last HScale widget for adjusting the page size of the
  # * scrollbar. */
  $label = Gtk2::Label->new("Scrollbar Page Size:");
  $box2->pack_start($label, FALSE, FALSE, 0);
  $label->show;
  $adj2 = Gtk2::Adjustment->new(1.0, 1.0, 101.0, 1.0, 1.0, 0.0);
  Gtk2::GSignal->connect($adj2, "value_changed", \&cb_page_size, $adj1);
  $scale = Gtk2::HScale->new($adj2);
  $scale->set_digits(0);
  $box2->pack_start($scale, TRUE, TRUE, 0);
  $scale->show;
  $box1->pack_start($box2, TRUE, TRUE, 0);
  $box2->show;
  my $separator = Gtk2::HSeparator->new;
  $box1->pack_start($separator, FALSE, TRUE, 0);
  $separator->show;
  $box2 = Gtk2::VBox->new(FALSE, 10);
  $box2->set_border_width(10);
  $box1->pack_start($box2, FALSE, TRUE, 0);
  $box2->show;
  $button = Gtk2::Button->new_with_label("Quit");
  Gtk2::GSignal->connect_swapped($button, "clicked", \&quit);
  $box2->pack_start($button, TRUE, TRUE, 0);
  $button->SET_FLAGS('can-default');
  $button->grab_default;
  $button->show;
  $window->show;
}

Gtk2->init(\@ARGV);
create_range_controls();
Gtk2->main;
0;

