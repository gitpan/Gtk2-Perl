#!/usr/bin/perl

## GTK - The GIMP Toolkit
# * Copyright (C) 1995-1997 Peter Mattis, Spencer Kimball and Josh MacDonald
# *
# * This library is free software; you can redistribute it and/or
# * modify it under the terms of the GNU Lesser General Public
# * License as published by the Free Software Foundation; either
# * version 2 of the License, or (at your option) any later version.
# *
# * This library is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# * Lesser General Public License for more details.
# *
# * You should have received a copy of the GNU Lesser General Public
# * License along with this library; if not, write to the
# * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# * Boston, MA 02111-1307, USA.

# * Modified by the GTK+ Team and others 1997-2000.  See the AUTHORS
# * file for a list of people on the GTK+ Team.  See the ChangeLog
# * files for a list of changes.  These files are distributed with
# * GTK+ at ftp://ftp.gtk.org/pub/gtk/. 

# $Id: testgtk.pl,v 1.8 2002/12/02 21:51:05 gthyni Exp $
# ported to perl

#undef GTK_DISABLE_DEPRECATED
#undef	G_LOG_DOMAIN
#define GTK_ENABLE_BROKEN

#use strict;
#use warnings;

use Gtk2;

#include "prop-editor.h"

#include "circles.xbm"
#include "test.xpm"

## macro, structure and variables used by tree window demos */
use constant DEFAULT_NUMBER_OF_ITEM => 3;
use constant DEFAULT_RECURSION_LEVEL => 3;

{
  package sTreeSampleSelection;
  use Class::MethodMaker
    new_with_init => q/new/,
    get_set => [qw/single_button browse_button multiple_button draw_line_button view_line_button no_root_item_button nb_item_spinner recursion_spinner/];
    #GSList* selection_mode_group;
}
my $sTreeSampleSelection = sTreeSampleSelection->new;

{
  package sTreeButtons;
  use Class::MethodMaker
    new_with_init => q/new/,
    get_set => [qw/nb_item_add add_button remove_button subtree_button/];
}


use constant TRUE  => 1;
use constant FALSE => 0;
use constant NULL  => undef;

sub build_option_menu
{
  # (gchar *items[], int num_items, int history,
  #    void           (*func)(GtkWidget *widget, gpointer data), gpointer         data)
  my ($items, $num_items, $history, $func, $data) = @_;
  #  GtkWidget *menu; GtkWidget *menu_item; GSList *group; gint i;
  my $omenu = Gtk2::OptionMenu->new;
  $omenu->signal_connect("changed" => \&func, $data);
  my $menu = Gtk2::Menu->new;
  my $group = undef;
  for (my $i = 0; $i < $num_items; $i++)
    {
      my $menu_item = Gtk2::RadioMenuItem->new_with_label($group, $items->[$i]);
      my $group = $menu_item->get_group;
      $menu->append($menu_item);
      Gtk2::CheckMenuItem->set_active(TRUE) if $i == $history;
      $menu_item->show;
    }
  $omenu->set_menu($menu);
  $omenu->set_history($history);
  return $omenu;
}

sub destroy_tooltips
{
  my ($widget, $window) = @_;
  my $tt = $window->get_data('tooltips');
  $tt->unref;
  $window = undef;
}


# * Big windows and guffaw scrolling

sub pattern_expose
{
  my ($widget, $event, $data) = @_;
  my $window = $event->window;
  my $color = $window->get_data("pattern-color");
  if ($color)
    {
      my $tmp_gc = Gtk2::Gdk::GC->new($window);
      $tmp_gc->set_rgb_fg_color($color);
      Gtk2::Gdk->draw_rectangle($window, $tmp_gc, TRUE,
				$event->area->x, $event->area->y,
				$event->area->width, $event->area->height);
      $tmp_gc->unref;
    }
  return FALSE;
}


sub pattern_set_bg
{
  my ($widget, $child, $level) = @_;
  my $colors = [Gtk2::Gdk::Color->new(0, 0x4444, 0x4444, 0xffff),
		Gtk2::Gdk::Color->new(0, 0x8888, 0x8888, 0xffff),
		Gtk2::Gdk::Color->new(0, 0xaaaa, 0xaaaa, 0xffff)];
  $child->set_data("pattern-color", $colors->[$level]);
  $child->set_user_data($widget);
}

sub create_pattern
{
  my ($widget, $parent, $level, $width, $height) = @_;
  my $h = 1;
  my $i = 0;
  while ($h * 2 <= $height) {
    my $w = 1;
    my $j = 0;
    while ($w * 2 <= $width)
      {
	if (($i + $j) % 2 == 0) {
	  my $x = $w - 1;
	  my $y = $h - 1;
	  my $child = Gtk2::Gdk::Window->new($parent,
					     { window_type => Gtk2::Gdk::Window->CHILD,
					       x => $x, y => $y, width => $w, height => $h,
					       wclass => GDK_INPUT_OUTPUT,
					       event_mask => GDK_EXPOSURE_MASK,
					       visual => $widget->get_visual,
					       colormap => $widget->get_colormap },
					     GDK_WA_X | GDK_WA_Y | GDK_WA_VISUAL | GDK_WA_COLORMAP);
	  pattern_set_bg($widget, $child, $level);
	  create_pattern($widget, $child, $level + 1, $w, $h) if $level < 2;
	  $child->show;
	}
	$j++;
	$w *= 2;
      }
    $i++;
    $h *= 2;
  }
}

sub PATTERN_SIZE() { 1 << 18 }

sub pattern_hadj_changed
{
  my ($adj, $darea) = @_;
  my $old_value = $adj->get_data("old-value");
  my $new_value = $adj->value;
  if ($darea->REALIZED)
    {
      $darea->window->scroll($old_value - $new_value, 0);
      $old_value = $new_value; # FIXME should set in object
    }
}

sub pattern_vadj_changed
{
  my ($adj,$darea) = @_;
  my $old_value = $adj->get_data("old-value");
  my $new_value = $adj->value;
  if ($darea->REALIZED)
    {
      $darea->window->scroll(0, $old_value - $new_value);
      $old_value = $new_value;  # FIXME should set in object
    }
}

sub pattern_realize
{
  my ($widget, $data) = @_;
  pattern_set_bg($widget, $widget->window, 0);
  create_pattern($widget, $widget->window, 1, PATTERN_SIZE, PATTERN_SIZE);
}

my ($big_window, $current_x, $current_y);
sub create_big_windows
{
  my ($widget) = @_;
  unless (defined $big_window)
    {
      $current_x = 0;
      $current_y = 0;
      $big_window = Gtk2::Dialog->new_with_buttons("Big Windows", undef, 0,
						   GTK_STOCK_CLOSE, GTK_RESPONSE_NONE, undef);
      $big_window->set_screen(gtk_widget_get_screen (widget));
      $big_window->set_default_size(200, 300);
      $big_window->signal_connect("destroy" => \&Gtk2::Widget::destroyed, $big_window);
      $big_window->signal_connect("response" => \&Gtk2::Widget::destroy);
      my $table = Gtk2::Table->new(2, 2, FALSE);
      $big_window->vbox->pack_start($table, TRUE, TRUE, 0);
      my $darea = Gtk2::DrawingArea->new;
      my $hadj = Gtk2::Adjustment->new(0, 0, PATTERN_SIZE, 10, 100, 100);
      $hadj->signal_connect("value_changed" => \&pattern_hadj_changed, darea);
      g_object_set_data (hadj, "old-value", &current_x);
      my $vadj = Gtk::Adjustment->new(0, 0, PATTERN_SIZE, 10, 100, 100);
      $vadj->signal_connect("value_changed" => \&pattern_vadj_changed, $darea);
      $vadj->set_data("old-value", &current_y);
      $darea->signal_connect("realize" => \&pattern_realize);
      $darea->signal_connect("expose_event" => \&pattern_expose);
      my $eventbox = Gtk2::EventBox->new;
      $table->attach($eventbox, 0, 1, 0, 1,
		     GTK_FILL | GTK_EXPAND, GTK_FILL | GTK_EXPAND, 0, 0);
      $eventbox->add($darea);
      my $scrollbar = Gtk2::HScrollbar->new($hadj);
      $table->attach($scrollbar, 0, 1, 1, 2,
			GTK_FILL | GTK_EXPAND, GTK_FILL, 0, 0);
      $scrollbar = Gtk2::VScrollbar->new($vadj);
      $table->attach($scrollbar, 1, 2, 0, 1,
			GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
    }
  unless ($big_window->VISIBLE) { $big_window->show_all }
  else { $big_window->hide };
}

# * GtkButton

sub button_window
{
  my ($widget, $button) = @_;
  unless ($button->VISIBLE) { $button->show }
  else { $button->hide; }
}

my $butwin;
sub create_buttons
{
  my ($widget) = @_;
  unless (defined $butwin) {
      $butwin = Gtk2::Window->new('toplevel');
      $butwin->set_screen($widget->get_screen);
      $butwin->signal_connect("destroy" => sub { shift->destroyed($butwin); });
      $butwin->set_title("GtkButton");
      $butwin->set_border_width (0);
      my $box1 = Gtk2::VBox->new(FALSE, 0);
      $butwin->add($box1);
      my $table = Gtk2::Table->new(3, 3, FALSE);
      $table->set_row_spacings(5);
      $table->set_col_spacings(5);
      $table->set_border_width(10);
      $box1->pack_start($table, TRUE, TRUE, 0);
      my @button = ();
      push @button, Gtk2::Button->new("button1");
      push @button, Gtk2::Button->new_with_mnemonic("_button2");
      push @button, Gtk2::Button->new_with_mnemonic("_button3");
      push @button, Gtk2::Button->new_from_stock(Gtk2::Stock->OK);
      push @button, Gtk2::Button->new("button5");
      push @button, Gtk2::Button->new("button6");
      push @button, Gtk2::Button->new("button7");
      push @button, Gtk2::Button->new_from_stock(Gtk2::Stock->CLOSE);
      push @button, Gtk2::Button->new("button9");
      $button[0]->signal_connect("clicked" => \&button_window, $button[1]);
      $table->attach($button[0], 0, 1, 0, 1, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $button[1]->signal_connect("clicked" => \&button_window, $button[2]);
      $table->attach($button[1], 1, 2, 1, 2, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $button[2]->signal_connect("clicked" => \&button_window, $button[3]);
      $table->attach($button[2], 2, 3, 2, 3, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $button[3]->signal_connect("clicked" => \&button_window, $button[4]);
      $table->attach($button[3], 0, 1, 2, 3, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $button[4]->signal_connect("clicked" => \&button_window, $button[5]);
      $table->attach($button[4], 2, 3, 0, 1, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $button[5]->signal_connect("clicked" => \&button_window, $button[6]);
      $table->attach($button[5], 1, 2, 2, 3, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $button[6]->signal_connect("clicked" => \&button_window, $button[7]);
      $table->attach($button[6], 1, 2, 0, 1, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $button[7]->signal_connect("clicked" => \&button_window, $button[8]);
      $table->attach($button[7], 2, 3, 1, 2, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $button[8]->signal_connect("clicked" => \&button_window, $button[0]);
      $table->attach($button[8], 0, 1, 1, 2, GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      my $separator = Gtk2::HSeparator->new;
      $box1->pack_start($separator, FALSE, TRUE, 0);
      my $box2 = Gtk2::VBox->new(FALSE, 10);
      $box2->set_border_width(10);
      $box1->pack_start($box2, FALSE, TRUE, 0);
      push @button, Gtk2::Button->new("close");
      $button[9]->signal_connect_swapped("clicked" => sub { shift->destroy }, $butwin);
      $box2->pack_start($button[9], TRUE, TRUE, 0);
      $button[9]->SET_FLAGS(Gtk2->CAN_DEFAULT);
      $button[9]->grab_default;
    }
  unless ($butwin->VISIBLE) { $butwin->show_all }
  else { $butwin->destroy }
}

# * GtkToggleButton
my $tbutwin;
sub create_toggle_buttons
{
  my ($widget) = @_;
  if (!$tbutwin)
    {
      my ($button);
      $tbutwin = Gtk2::Window->new('toplevel');
      $tbutwin->set_screen($widget->get_screen);
      $tbutwin->signal_connect("destroy" => sub { shift->destroyed }, $tbutwin);
      $tbutwin->set_title("GtkToggleButton");
      $tbutwin->set_border_width(0);
      my $box1 = Gtk2::VBox->new(FALSE, 0);
      $tbutwin->add($box1);
      my $box2 = Gtk2::VBox->new(FALSE, 10);
      $box2->set_border_width(10);
      $box1->pack_start($box2, TRUE, TRUE, 0);
      for (qw(1 2 3))
	{
	  $button = Gtk2::ToggleButton->new('button' . $_);
	  $box2->pack_start($button, TRUE, TRUE, 0);
	}
      $button = Gtk2::ToggleButton->new("inconsistent");
      $button->set_inconsistent(TRUE);
      $box2->pack_start($button, TRUE, TRUE, 0);
      my $separator = Gtk2::HSeparator->new;
      $box1->pack_start($separator, FALSE, TRUE, 0);
      $box2 = Gtk2::VBox->new(FALSE, 10);
      $box->set_border_width(10);
      $box1->pack_start($box2, FALSE, TRUE, 0);
      $button = Gtk2::Button->new("close");
      $button->signal_connect_swapped("clicked" => sub { shift->destroy }, $tbutwin);
      $box2->pack_start($button, TRUE, TRUE, 0);
      $button->SET_FLAGS(Gtk2->CAN_DEFAULT);
      $button->grab_default;
    }
  unless ($tbutwin->VISIBLE) { $tbutwin->show_all }
  else { $tbutwin->destroy }
}

sub create_widget_grid
{
  my  ($widget_type) = @_;
  my $group_widget;
  my $table = Gtk2::Table->new(FALSE, 3, 3);
  for (my $i = 0; $i < 5; $i++) {
    for (my $j = 0; $j < 5; $j++) {
      my $widget;
      if ($i == 0 && $j == 0)  { $widget = undef; }
      elsif ($i == 0) { $widget = Gtk2::Label->new($j); }
      elsif ($j == 0) { $widget = Gtk2::Label->new('A' + $i - 1); }
      else {
	$widget = Gtk2::GObject->new($widget_type);
	if (g_type_is_a (widget_type, GTK_TYPE_RADIO_BUTTON))
	  {
	    unless (defined $group_widget) { $group_widget = $widget; }
	    else { $widget->set("group", $group_widget); }
	  }
	if (defined $widget) {
	  $table->attach($widget, $i, $i + 1, $j, $j + 1, 0, 0, 0, 0);
	}
      }
    }
  }
  return $table;
}

# * GtkCheckButton
my $cbutwin;
sub create_check_buttons
{
  my ($widget) = @_;
  unless ( defined $cbutwin) {
    $cbutwin = 
      Gtk2::Dialog->new_with_buttons("Check Buttons", undef, 0, GTK_STOCK_CLOSE, GTK_RESPONSE_NONE);
    $cbutwin->set_screen($widget->get_screen);
    $cbutwin->signal_connect("destroy" => sub { shift->destroyed }, $cbutwin);
    $cbutwin->signal_connect("response" => sub { shift->destroy });
    my $box1 = $cbutwin->vbox;
    my $box2 = Gtk2::VBox->new(FALSE, 10);
    $box2->set_border_width(10);
    $box1->pack_start($box2, TRUE, TRUE, 0);
    my $button = Gtk2::CheckButton->new_with_mnemonic("_button1");
    $box2->pack_start($button, TRUE, TRUE, 0);
    $button = Gtk2::CheckButton->new("button2");
    $box2->pack_start($button, TRUE, TRUE, 0);
    $button = Gtk2::CheckButton->new("button3");
    $box2->pack_start($button, TRUE, TRUE, 0);
    $button = Gtk2::CheckButton->new("inconsistent");
    $button->set_inconsistent(TRUE);
    $box2->pack_start($button, TRUE, TRUE, 0);
    my $separator = Gtk2::HSeparator->new;
    $box1->pack_start($separator, FALSE, TRUE, 0);
    my $table = create_widget_grid(GTK_TYPE_CHECK_BUTTON);
    $table->set_border_width(10);
    $box1->pack_start($table, TRUE, TRUE, 0);
  }
  unless ($cutwin->VISIBLE) { $cbutwin->showall }
  else { $cbutwin->destroy }
}

# * GtkRadioButton
my $rbutwin;
sub create_radio_buttons
{
  my ($widget) = @_;
  unless (defined $rbutwin)
    {
      $rbutwin = 
	Gtk2::Dialog->new_with_buttons("Radio Buttons",
				       NULL, 0, GTK_STOCK_CLOSE, GTK_RESPONSE_NONE);
      $rbutwin->set_screen($widget->get_screen);
      $rbutwin->signal_connect("destroy" => sub { $shift->destroyed }, $rbutwin);
      $rbutwin->signal_connect("response" => sub { shift->destroy });
      my $box1 = $rbutwin->vbox;
      my $box2 = Gtk2::VBox->new(FALSE, 10);
      $box2->set_border_width(10);
      $box1->pack_start($box2, TRUE, TRUE, 0);
      my $button = Gtk2::RadioButton->new(undef, "button1");
      $box2->pack_start($button, TRUE, TRUE, 0);
      $button = Gtk2::RadioButton->new($button->get_group, "button2");
      $button->set_active(TRUE);
      $box2->pack_start($button, TRUE, TRUE, 0);
      $button = Gtk2::RadioButton->new($button->get_group, "button3");
      $box2->pack_start($button, TRUE, TRUE, 0);
      $button = Gtk2::RadioButton->new($button->get_group, "inconsistent");
      $button->set_inconsistent(TRUE);
      $box2->pack_start($button, TRUE, TRUE, 0);
      $box1->pack_start(Gtk2::HSeparator->new, FALSE, TRUE, 0);
      $box2 = Gtk2::VBox->new(FALSE, 10);
      $box2->set_border_width(10);
      $box1->pack_start($box2, TRUE, TRUE, 0);
      $button = Gtk2::RadioButton->new(undef, "button4");
      $button->set_mode(FALSE);
      $box2->pack_start($button, TRUE, TRUE, 0);
      $button = Gtk2::RadioButton->new($button->get_group, "button5");
      $button->set_active;
      $button->set_mode(FALSE);
      $box->pack_start($button, TRUE, TRUE, 0);
      $button = Gtk2::RadioButton->new($button->get_group, "button6");
      $button->set_mode(FALSE);
      $box2->pack_start($button, TRUE, TRUE, 0);
      $box1->pack_start(Gtk2::HSeparator->new, FALSE, TRUE, 0);
      my $table = create_widget_grid(GTK_TYPE_RADIO_BUTTON);
      $table->set_border_width(10);
      $box1->pack_start($table, TRUE, TRUE, 0);
    }
  unless ($rbutwin->VISIBLE) { $rbutwin->show_all }
  else { $rbutwin->destroy }
}

# GtkButtonBox

sub create_bbox
{
  my ($horizontal, $title, $spacing, $child_w, $child_h, $layout) = @_;
  my $frame = Gtk2::Frame->new($title);
  my $bbox = $horizontal ? Gtk2::HButtonBox->new : Gtk2::VButtonBox->new;
  $bbox->set_border_width(5);
  $frame->add($bbox);
  $bbox->set_layout($layout);
  $bbox->set_spacing($spacing);
  $bbox->set_child_size($child_w, $child_h);
  $bbox->add(Gtk2::Button->new("OK"));
  $bbox->add(Gtk2::Button->new("Cancel"));
  $bbox->add(Gtk2::Button->new("Help"));
  return $frame;
}

my $bbwin;
sub create_button_box
{
  my ($widget)  = @_;
  unless (defined $bbwin)
  {
    $bbwin = Gtk2::Window->new('toplevel');
    $bbwin->set_screen($widget->get_screen);
    $bbwin->set_title("Button Boxes");
    $bbwin->signal_connect("destroy" => sub { shift->destroyed }, $bbwin);
    $bbwin->set_border_width(10);
    my $main_vbox = Gtk2::VBox->new(FALSE, 0);
    $bbwin->add($main_vbox);
    my $frame_horz = Gtk2::Frame->new("Horizontal Button Boxes");
    $main_vbox->pack_start($frame_horz, TRUE, TRUE, 10);
    my $vbox = Gtk2::VBox->new(FALSE, 0);
    vbox->set_border_width(10);
    $frame_horz->add($vbox);
    $vbox->pack_start(create_bbox(TRUE, "Spread", 40, 85, 20, GTK_BUTTONBOX_SPREAD), TRUE, TRUE, 0);
    $vbox->pack_start(create_bbox(TRUE, "Edge", 40, 85, 20, GTK_BUTTONBOX_EDGE), TRUE, TRUE, 5);
    $vbox->pack_start(create_bbox(TRUE, "Start", 40, 85, 20, GTK_BUTTONBOX_START), TRUE, TRUE, 5);
    $vbox->pack_start(create_bbox (TRUE, "End", 40, 85, 20, GTK_BUTTONBOX_END),	TRUE, TRUE, 5);
    my $frame_vert = Gtk2::Frame->new("Vertical Button Boxes");
    $main_vbox->pack_start($frame_vert, TRUE, TRUE, 10);
    my $hbox = Gtk2::HBox->new(FALSE, 0);
    $hbox->set_border_width(10);
    $frame_vert->add($hbox);
    $hbox->pack_start(create_bbox (FALSE, "Spread", 30, 85, 20, GTK_BUTTONBOX_SPREAD), TRUE, TRUE, 0);
    $hbox->pack_start(create_bbox (FALSE, "Edge", 30, 85, 20, GTK_BUTTONBOX_EDGE), TRUE, TRUE, 5);
    $hbox->pack_start(create_bbox (FALSE, "Start", 30, 85, 20, GTK_BUTTONBOX_START), TRUE, TRUE, 5);
    $hbox->pack_start(create_bbox (FALSE, "End", 30, 85, 20, GTK_BUTTONBOX_END), TRUE, TRUE, 5);
  }
  unless ($bbwin->VISIBLE) { $bbwin->show_all }
  else { $bbwin->destroy }
}

# GtkToolBar

sub new_pixmap
{
  my ($filename, $window, $background) = @_;
  my ($pixmap, $mask) = ($filename eq "test.xpm" || ! -e $filename) ?
    Gtk2::Gdk::Pixmap->create_from_xpm_d($window, $background, $openfile) :
	Gtk2::Gdk::Pixmap->create_from_xpm($window, $background, $filename);
  return Gtk2::Image->new_from_pixmap($pixmap, $mask);
}


sub set_toolbar_small_stock
{
  my ($widget, $data) = @_;
  $data->set_icon_size(GTK_ICON_SIZE_SMALL_TOOLBAR);
}

sub set_toolbar_large_stock
{
  my ($widget,$data) = @_;
  $data->set_icon_size(GTK_ICON_SIZE_LARGE_TOOLBAR);
}

sub set_toolbar_horizontal
{
  my ($widget,$data) = @_;
  $data->set_orientation(GTK_ORIENTATION_HORIZONTAL);
}

sub set_toolbar_vertical
{
  my ($widget,$data) = @_;
  $data->set_orientation(GTK_ORIENTATION_VERTICAL);
}

sub set_toolbar_icons
{
  my ($widget,$data) = @_;
  $data->set_style(GTK_TOOLBAR_ICONS);
}

sub set_toolbar_text
{
  my ($widget,$data) = @_;
  $data->set_style(GTK_TOOLBAR_TEXT);
}

sub set_toolbar_both
{
  my ($widget,$data) = @_;
  $data->set_style(GTK_TOOLBAR_BOTH);
}

sub set_toolbar_both_horiz
{
  my ($widget,$data) = @_;
  $data->set_style(GTK_TOOLBAR_BOTH_HORIZ);
}

sub set_toolbar_enable
{
  my ($widget,$data) = @_;
  $data->set_tooltips(TRUE);
}

sub set_toolbar_disable
{
  my ($widget,$data) = @_;
  $data->set_tooltips(FALSE);
}

my $tbwin;
sub create_toolbar
{
  my ($widget) = @_;
  unless (defined $tbwin)
    {
      $tbwin = Gtk2::Window->new('toplevel');
      $tbwin->set_screen($widget->get_screen);
      $tbwin->set_title("Toolbar test");
      $tbwin->set_resizable(FALSE);
      $tbwin->signal_connect("destroy" => sub { shift->destroyed }, $tbwin);
      $tbwin->set_border_width(0);
      $tbwin->realize;
      my $toolbar = Gtk2::Toolbar->new;
      $toolbar->insert_stock(Gtk2::Stock->NEW, "Stock icon: New", "Toolbar/New",
			     \&set_toolbar_small_stock, $toolbar, -1);
      $toolbar->insert_stock(Gtk2::Stock->OPEN, "Stock icon: Open", "Toolbar/Open",
			     \&set_toolbar_large_stock, $toolbar, -1);
      $toolbar->append_item("Horizontal", "Horizontal toolbar layout", "Toolbar/Horizontal",
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    \&set_toolbar_horizontal, $toolbar);
      $toolbar->append_item("Vertical", "Vertical toolbar layout", "Toolbar/Vertical",
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    \&set_toolbar_vertical, $toolbar);
      $toolbar->append_space;
      $toolbar->append_item("Icons", "Only show toolbar icons", "Toolbar/IconsOnly",
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    \&set_toolbar_icons, toolbar);
      $toolbar->append_item("Text", "Only show toolbar text", "Toolbar/TextOnly",
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    \&set_toolbar_text, $toolbar);
      $toolbar->append_item("Both", "Show toolbar icons and text", "Toolbar/Both",
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    \&set_toolbar_both, $toolbar);
      $toolbar->append_item("Both (horizontal)", "Show toolbar icons and text in a horizontal fashion",
			    "Toolbar/BothHoriz",
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    \&set_toolbar_both_horiz, $toolbar);
      $toolbar->append_space;
      my $entry = Gtk2::Entry->new;
      $toolbar->append_widget($entry, "This is an unusable GtkEntry ;)", "Hey don't click me!!!");
      $toolbar->append_space;
      $toolbar->append_space;
      $toolbar->append_item("Enable", "Enable tooltips", NULL,
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    \&set_toolbar_enable, $toolbar);
      $toolbar->append_item("Disable", "Disable tooltips", NULL,
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    \&set_toolbar_disable, $toolbar);
      $toolbar->append_space;

      $toolbar->append_item("Frobate", "Frobate tooltip", NULL,
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    NULL, $toolbar);
      $toolbar->append_item("Baz", "Baz tooltip", NULL,
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    NULL, $toolbar);
      $toolbar->append_space;
      $toolbar->append_item("Blah", "Blah tooltip", NULL,
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    NULL, $toolbar);
      $toolbar->append_item("Bar", "Bar tooltip", NULL,
			    new_pixmap ("test.xpm", $tbwin->window, $tbwin->style->bg->[GTK_STATE_NORMAL]),
			    NULL, $toolbar);
      $tbwin->add($toolbar);
    }
  unless ($tbwin->VISIBLE) { $tbwin->show_all }
  else { $tbwin->destroy }
}


sub make_toolbar
{
  my ($window) = @_;
  $window->realize unless $window->REALIZED;
  my $toolbar = Gtk2::Toolbar->new;
  $toolbar->append_item("Horizontal", "Horizontal toolbar layout", undef,
			new_pixmap ("test.xpm", $window->window, $window->style->bg->[Gtk2->STATE_NORMAL]),
			\&set_toolbar_horizontal, $toolbar);
  $toolbar->append_item("Vertical", "Vertical toolbar layout", NULL,
			new_pixmap ("test.xpm", window->window, &window->style->bg->[GTK_STATE_NORMAL]),
			\&set_toolbar_vertical, $toolbar);
  $toolbar->append_space;
  $toolbar->append_item("Icons", "Only show toolbar icons", NULL,
			new_pixmap ("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			\&set_toolbar_icons, $toolbar);
  $toolbar->append_item("Text", "Only show toolbar text", NULL,
			new_pixmap ("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			\&set_toolbar_text, $toolbar);
  $toolbar->append_item("Both", "Show toolbar icons and text", NULL,
			new_pixmap ("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			\&set_toolbar_both, $toolbar);
  $toolbar->append_space;
  $toolbar->append_item("Woot", "Woot woot woot", NULL,
			new_pixmap ("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			NULL, $toolbar);
  $toolbar->append_item("Blah", "Blah blah blah", "Toolbar/Big",
			new_pixmap ("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			NULL, $toolbar);
  $toolbar->append_space;
  $toolbar->append_item ("Enable", "Enable tooltips", NULL,
			 new_pixmap ("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			 \&set_toolbar_enable, $toolbar);
  $toolbar->append_item("Disable", "Disable tooltips", NULL,
			new_pixmap("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			\&set_toolbar_disable, $toolbar);
  $toolbar->append_space;
  $toolbar->append_item("Hoo", "Hoo tooltip", NULL,
			new_pixmap ("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			NULL, $toolbar);
  $toolbar->append_item("Woo", "Woo tooltip", NULL,
			new_pixmap ("test.xpm", $window->window, $window->style->bg->[GTK_STATE_NORMAL]),
			NULL, $toolbar);
  return $toolbar;
}

# GtkStatusBar
my $statusbar_counter = 1;

sub statusbar_push
{
  my ($button,$statusbar) = @_;
  $statusbar->push(1, sprintf("something %d", $statusbar_counter++));
}

sub statusbar_pop
{
  my ($button,$statusbar) = @_;
  $statusbar->pop(1);
}

sub statusbar_steal
{
  my ($button,$statusbar) = @_;
  $statusbar->remove(1, 4);
}

sub statusbar_popped
{
  my ($statusbar, $context_id, $text) = @_;
  $statusbar_counter = 1 unless $statusbar->messages;
}

sub statusbar_contexts
{
  my ($statusbar) = @_;
  my $string = "any context";
  printf("GtkStatusBar: context=\"%s\", context_id=%d\n",
	  $string, $statusbar->get_context_id($string));
  $string = "idle messages";
  printf("GtkStatusBar: context=\"%s\", context_id=%d\n",
	 $string, $statusbar->get_context_id($string));
  $string = "some text";
  print("GtkStatusBar: context=\"%s\", context_id=%d\n",
	$string, $statusbar->get_context_id($string));
  $string = "hit the mouse";
  printf("GtkStatusBar: context=\"%s\", context_id=%d\n",
	 $string, $statusbar->get_context_id($string));
  $string = "hit the mouse2";
  printf("GtkStatusBar: context=\"%s\", context_id=%d\n",
	 $string, $statusbar->get_context_id($string));
}

my $sbwin;
sub create_statusbar
{
  my ($widget) = @_;
  unless (defined $sbwin)
    {
      $sbwin = Gtk2::Window->new('toplevel');
      $sbwin->set_screen($widget->get_screen);
      $sbwin->signal_connect("destroy" => sub { shift->destroyed(@_) },	$sbwin);
      $sbwin->set_title("statusbar");
      $sbwin->set_border_width(0);
      my $box1 = Gtk2::VBox->new(FALSE, 0);
      $sbwin->add($box1);
      my $box2 = Gtk2::VBox->new(FALSE, 10);
      $box2->set_border_width(10);
      $box1->pack_start($box2, TRUE, TRUE, 0);
      my $statusbar = Gtk2::Statusbar->new;
      $box1->pack_end($statusbar, TRUE, TRUE, 0);
      $statusbar->signal_connect('text_popped' => \&statusbar_popped);
      Gtk2::Widget->new(Gtk2::Button->get_type,
			"label" => "push something",
			"visible" => TRUE,
			"parent" => $box2)->connect("signal::clicked" => \&statusbar_push, $statusbar);
      Gtk2::Widget->new(Gtk2::Button->get_type,
			"label" => "pop",
			"visible" => TRUE,
			"parent" => $box2)->connect("signal_after::clicked" => statusbar_pop, $statusbar);
      Gtk2::Widget->new(Gtk2::Button->get_type,
			"label" => "steal #4",
			"visible" => TRUE,
			"parent" => $box2)->connect("signal_after::clicked" => statusbar_steal, $statusbar);
      Gtk2::Widget->new(Gtk2::Button->get_type,
			"label" => "test context",
			"visible" => TRUE,
			"parent" => $box2)->connect("signal_after::clicked" => statusbar_contexts, $statusbar);
      $box1->pack_start(Gtk2::Separator->new, FALSE, TRUE, 0);
      $box2 = Gtk2::VBox->new(FALSE, 10);
      $box2->set_border_width(10);
      $box1->pack_start($box2, FALSE, TRUE, 0);
      $button = Gtk2::Button->new("close");
      $button->signal_connect_swapped("clicked" => sub { shift->destroy }, $sbwin);
      $box2->pack_start($button, TRUE, TRUE, 0);
      $button->SET_FLAGS(Gtk2->CAN_DEFAULT);
      $button->grab_default;
    }
  unless ($sbwin->VISIBLE) { $sbwin->show_all }
  else { $sbwin->destroy }
}

# GtkTree

sub cb_tree_destroy_event
{
  my ($w) = @_;
  # free buttons structure associate at this tree
  my $tree_buttons = $w->get_data("user_data");
}

sub cb_add_new_item
{
  my ($w, $tree) = @_;
  my ($subtree);
  my $tree_buttons = $tree->get_data("user_data");
  my $selected_list = $tree->SELECTION_OLD;
  unless (defined $selected_list)
    {
      ## there is no item in tree */
      $subtree = $tree;
    }
  else
    {
      ## list can have only one element */
      my $selected_item = $selected_list->data;
      $subtree = $selected_item->SUBTREE;
      unless (defined $subtree)
	{
	  ## current selected item have not subtree ... create it */
	  $selected_item->set_subtree(Gtk2::Tree->new);
	}
    }

  ## at this point, we know which subtree will be used to add new item */
  ## create a new item */
  my $item_new = Gtk2::TreeItem->new(sprintf("item add %d", $tree_buttons->nb_item_add));
  $subtree->append($item_new);
  $item_new->show;
  $tree_buttons->nb_item_add++;
}

sub cb_remove_item
{
  my ($w, $tree) = @_;
  #GList* clear_list;
  my $selected_list = $tree->SELECTION_OLD;
  my $clear_list = undef;
  while ($selected_list)
    {
      $clear_list = g_list_prepend ($clear_list, $selected_list->data);
      $selected_list = selected_list->next;
    }
  $clear_list = g_list_reverse($clear_list);
  gtk_tree_remove_items(tree, $clear_list);
  g_list_free($clear_list);
}

sub cb_remove_subtree
{
  my ($w, $tree) = @_;
  my $selected_list = $tree->SELECTION_OLD;
  if ($selected_list)
    {
      my $item = $selected_list->data;
      $item->remove_subtree if $item->subtree;
    }
}

sub cb_tree_changed
{
  my ($tree) = @_;
  my $tree_buttons = $tree->get_data("user_data");
  my $selected_list = $tree->SELECTION_OLD;
  my $nb_selected = $selected_list->length;
  unless ($nb_selected)
    {
      $tree_buttons->add_button->set_sensitive($tree->children ? FALSE : TRUE);
      $tree_buttons->remove_button->set_sensitive(FALSE);
      $tree_buttons->subtree_button->set_sensitive(FALSE);
    }
  else
    {
      $tree_buttons->add_button->set_sensitive($nb_selected == 1);
      $tree_buttons->remove_button->set_sensitive(TRUE);
      $tree_buttons->subtree_button->set_sensitive($nb_selected == 1);
    }
}

sub create_subtree
{
  my ($item, $level, $nb_item_max, $recursion_level_max) = @_;
  return if $level == $recursion_level_max;
  my $item_subtree = $item;
  my $no_root_item = 0;
  if ($level == -1)
    {
      ## query with no root item */
      $level = 0;
      $no_root_item = 1;
    }
  else
    {
      ## query with no root item */
      ## create subtree and associate it with current item */
      $item_subtree = Gtk2::Tree->new;
    }
  for(my $nb_item = 0; $nb_item < $nb_item_max; $nb_item++)
    {
      my $item_new = Gtk2::TreeItem->new(sprintf("item %d-%d", $level, $nb_item));
      $item_subtree->append($item_new);
      create_subtree($item_new, $level + 1, $nb_item_max, $recursion_level_max);
      $item_new->show;
    }
  $item->set_subtree($item_subtree) unless $no_root_item;
}


sub create_tree_sample
{
  my ($screen, $selection_mode, $draw_line, $view_line, $no_root_item, $nb_item_max, $recursion_level_max) = @_;
  my $root_item;
  ## create tree buttons struct */
  my $tree_buttons = sTreeButtons->new;
  $tree_buttons->nb_item_add(0);
  ## create top level window */
  my $window = Gtk2::Window->new('toplevel');
  $window->set_screen($screen);
  $window->set_title("Tree Sample");
  $window->signal_connect("destroy" => \&cb_tree_destroy_event);
  $window->set_data("user_data" => $tree_buttons);
  my $box1 = Gtk2::VBox->new(FALSE, 0);
  $window->add($box1);
  $box1->show;

  ## create tree box */
  my $box2 = Gtk2::VBox->new(FALSE, 0);
  $box1->pack_start($box2, TRUE, TRUE, 0);
  gtk_container_set_border_width($box2, 5);
  $box2->show;

  ## create scrolled window */
  my $scrolled_win = Gtk2::ScrolledWindow->new;
  $scrolled_window->set_policy(GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
  $box2->pack_start ($scrolled_win, TRUE, TRUE, 0);
  gtk_widget_set_size_request (scrolled_win, 200, 200);
  $scrolled_win->show;
  
  ## create root tree widget */
  my $root_tree = Gtk2::Tree->new;
  $root_tree->signal_connect("selection_changed" => \&cb_tree_changed);
  g_object_set_data (root_tree, "user_data", tree_buttons);
  gtk_scrolled_window_add_with_viewport (GTK_SCROLLED_WINDOW (scrolled_win), root_tree);
  gtk_tree_set_selection_mode(root_tree, selection_mode);
  gtk_tree_set_view_lines(root_tree, draw_line);
  gtk_tree_set_view_mode(root_tree, !view_line);
  $root_tree->show;

  if ( $no_root_item )
    {
      ## set root tree to subtree function with root item variable */
      $root_item = $root_tree;
    }
  else
    {
      ## create root tree item widget */
      $root_item = Gtk2::TreeItem->new("root item");
      $root_tree->append($root_item);
      $root_item->show;
     }
  create_subtree($root_item, -$no_root_item, $nb_item_max, $recursion_level_max);
  $box2 = Gtk2::VBox->new(FALSE, 0);
  $box1->pack_start($box2, FALSE, FALSE, 0);
  gtk_container_set_border_width($box2, 5);
  $box2->show;
  my $button = Gtk2::Button->new("Add Item");
  $button->set_sensitive(FALSE);
  $button->signal_connect("clicked" => \&cb_add_new_item, $root_tree);
  $box2->pack_start($button, TRUE, TRUE, 0);
  $button->show;
  $tree_buttons->add_button($button);
  $button = Gtk2::Button->new("Remove Item(s)");
  gtk_widget_set_sensitive(button, FALSE);
  $button->signal_connect("clicked" => \&cb_remove_item, $root_tree);
  $box2->pack_start($button, TRUE, TRUE, 0);
  $button->show;
  $tree_buttons->remove_button($button);
  $button = Gtk2::Button->new("Remove Subtree");
  $button->set_sensitive(FALSE);
  $button->signal_connect("clicked" => \&cb_remove_subtree, $root_tree);
  $box2->pack_start($button, TRUE, TRUE, 0);
  $button->show;
  $tree_buttons->subtree_button($button);
  ## create separator */
  my $separator = Gtk2::HSeparator->new;
  $box1->pack_start($separator, FALSE, FALSE, 0);
  $separator->show;
  ## create button box */
  $box2 = Gtk2::VBox->new(FALSE, 0);
  $box1->pack_start($box2, FALSE, FALSE, 0);
  $box2->set_border_width($box2, 5);
  $box2->show;
  $button = Gtk2::Button->new("Close");
  $box2->pack_start($button, TRUE, TRUE, 0);
  $button->signal_connect_swapped("clicked" => \&Gtk2::Widget::destroy, $window);
  $button->show;
  $window->show;
}

sub cb_create_tree
{
  my ($w) = @_;
  my $selection_mode = GTK_SELECTION_SINGLE;
  guint recursion_level;
  ## get selection mode choice */
  if ($sTreeSampleSelection->single_button->active)    { $selection_mode = GTK_SELECTION_SINGLE; }
  elsif ($sTreeSampleSelection->browse_button->active) { $selection_mode = GTK_SELECTION_BROWSE; }
  else { $selection_mode = GTK_SELECTION_MULTIPLE; }
  ## get options choice */
  my $draw_line = $sTreeSampleSelection->draw_line_button->active;
  my $view_line = $sTreeSampleSelection->view_line_button->active;
  my $no_root_item = $sTreeSampleSelection->no_root_item_button->active;
  ## get levels */
  my $nb_item = $sTreeSampleSelection->nb_item_spinner->get_value_as_int;
  my $recursion_level = $sTreeSampleSelection->recursion_spinner->get_value_as_int;
  if (pow($nb_item, $recursion_level) > 10000) {
    printf "%g total items? That will take a very long time. Try less\n", pow($nb_item, $recursion_level);
  }
  else {
    create_tree_sample($w->get_screen, $selection_mode, $draw_line, $view_line,
		       $no_root_item, $nb_item, $recursion_level);
  }
}

my $tmwin;
sub create_tree_mode_window
{
  my ($widget) = @_;
  unless (defined $tmwin)
    {
      ## create toplevel window  */
      $tmwin = Gtk2::Window->new('toplevel');
      $tmwin->set_screen($widget->get_screen);
      $tmwin->set_title("Set Tree Parameters");
      $tmwin->signal_connect("destroy" => \&Gtk2::Widget::destroyed, $tmwin);
      my $box1 = Gtk2::VBox->new(FALSE, 0);
      $tmwin->add($box1);
      ## create upper box - selection box */
      my $box2 = Gtk2::VBox->new(FALSE, 5);
      $box1->pack_start($box2, TRUE, TRUE, 0);
      $box2->set_border_width(5);
      my $box3 = Gtk2::HBox->new(FALSE, 5);
      $box2->pack_start($box3, TRUE, TRUE, 0);
      ## create selection mode frame */
      my $frame = Gtk2::Frame->new("Selection Mode");
      $box3->pack_start($frame, TRUE, TRUE, 0);
      my $box4 = Gtk2::VBox->new(FALSE, 0);
      $frame->add($box4);
      $box4->set_border_width(5);
      ## create radio button */  
      my $button = Gtk2::RadioButton->new(undef, "SINGLE");
      $box4->pack_start($button, TRUE, TRUE, 0);
      $sTreeSampleSelection->single_button($button);
      $button = Gtk2::RadioButton->new($button->get_group, "BROWSE");
      $box4->pack_start($button, TRUE, TRUE, 0);
      $sTreeSampleSelection->browse_button($button);
      $button = Gtk2::RadioButton->new($button->get_group, "MULTIPLE");
      $box4->pack_start($button, TRUE, TRUE, 0);
      $sTreeSampleSelection->multiple_button($button);
      $sTreeSampleSelection->selection_mode_group($button->get_group);
      ## create option mode frame */
      $frame = Gtk2::Frame->new("Options");
      $box3->pack_start($frame, TRUE, TRUE, 0);
      $box4 = Gtk2::VBox->new(FALSE, 0);
      $frame->add($box4);
      $box4->set_border_width(5);
      ## create check button */
      $button = Gtk2::CheckButton->new("Draw line");
      $box4->pack_start($button, TRUE, TRUE, 0);
      $button->set_active(TRUE);
      $sTreeSampleSelection->draw_line_button($button);
      $button = Gtk2::CheckButton->new("View Line mode");
      $box4->pack_start($button, TRUE, TRUE, 0);
      $button->set_active(TRUE);
      $sTreeSampleSelection->view_line_button($button);
      $button = Gtk2::CheckButton->new("Without Root item");
      $box4->pack_start($button, TRUE, TRUE, 0);
      $sTreeSampleSelection->no_root_item_button($button);
      ## create recursion parameter */
      $frame = Gtk2::Frame->new("Size Parameters");
      $box2->pack_start($frame, TRUE, TRUE, 0);
      $box4 = Gtk2::HBox->new(FALSE, 5);
      $frame->add($box4);
      $box4->set_border_width(5);
      ## create number of item spin button */
      my $box5 = Gtk2::HBox->new(FALSE, 5);
      $box4->pack_start($box5, FALSE, FALSE, 0);
      my $label = Gtk2::Label->new("Number of items : ");
      $label->set_alignment(0, 0.5);
      $box5->pack_start($label, FALSE, TRUE, 0);
      my $adj = Gtk2::Adjustment->new(DEFAULT_NUMBER_OF_ITEM, 1.0, 255.0, 1.0, 5.0, 0.0);
      my $spinner = Gtk2::SpinButton->new($adj, 0, 0);
      $box5->pack_start($spinner, FALSE, TRUE, 0);
      $sTreeSampleSelection->nb_item_spinner(spinner);
      ## create recursion level spin button */
      $box5 = Gtk2::HBox->new(FALSE, 5);
      $box4->pack_start($box5, FALSE, FALSE, 0);
      $label = Gtk2::Label->new("Depth : ");
      $label->set_alignment(0, 0.5);
      $box5->pack_start($label, FALSE, TRUE, 0);
      $adj = Gtk2::Adjustment->new(DEFAULT_RECURSION_LEVEL, 0.0, 255.0, 1.0, 5.0, 0.0);
      $spinner = Gtk2::SpinButton->new($adj, 0, 0);
      $box5->pack_start($spinner, FALSE, TRUE, 0);
      $sTreeSampleSelection->recursion_spinner($spinner);
      ## create horizontal separator */
      $box1->pack_start(Gtk2::HSeparator->new, FALSE, FALSE, 0);
      ## create bottom button box */
      $box2 = Gtk2::HBox->new(TRUE, 10);
      $box1->pack_start($box2, FALSE, FALSE, 0);
      $box2->set_border_width(5);
      $button = Gtk2::Button->new("Create Tree");
      $box2->pack_start($button, TRUE, TRUE, 0);
      $button->signal_connect("clicked" => \&cb_create_tree);
      $button = Gtk2::Button->new("Close");
      $box2->pack_start($button, TRUE, TRUE, 0);
      $button->signal_connect_swapped("clicked" => sub { shift->destroy }, $tmwin);
    }
  unless ($tmwin->VISIBLE) { $tmwin->show_all }
  else { $tmwin->destroy }
}

# * Gridded geometry

use constant GRID_SIZE => 20;
use constant DEFAULT_GEOMETRY => "10x10";

sub gridded_geometry_expose
{
  my ($widget, $event) = @_;
  my ($i, $j);
  $widget->window->gdk_draw_rectangle ($widget->style->base_gc->[$widget->state], TRUE,
				       0, 0, $widget->allocation->width, widget->allocation->height);
  for ($i = 0 ; $i * GRID_SIZE < widget->allocation.width; $i++) {
    for ($j = 0 ; $j * GRID_SIZE < widget->allocation.height; $j++) {
      gdk_draw_rectangle($widget->window, $widget->style->text_gc->[$widget->state], TRUE,
			 $i * GRID_SIZE, $j * GRID_SIZE, GRID_SIZE, GRID_SIZE)
	unless ($i + $j) % 2;
    }
  }
  return FALSE;
}

sub gridded_geometry_subresponse
{
  my ($dialog, $response_id, $geometry_string) = @_;
  if (response_id == GTK_RESPONSE_NONE)
    {
      gtk_widget_destroy (GTK_WIDGET (dialog));
    }
  else
    {
      if (!gtk_window_parse_geometry (dialog, geometry_string))
	{
	  g_print ("Can't parse geometry string %s\n", geometry_string);
	  gtk_window_parse_geometry (dialog, DEFAULT_GEOMETRY);
	}
    }
}

sub gridded_geometry_response
{
  my ($dialog, $response_id, $entry) = @_;
  if (response_id == GTK_RESPONSE_NONE)
    {
      gtk_widget_destroy (GTK_WIDGET (dialog));
    }
  else
    {
      my $geometry_string = $entry->get_text;
      my $title = sprintf("Gridded window at: %s", $geometry_string);
      GdkGeometry geometry;
      my $window = Gtk2::Dialog->new_with_buttons($title, undef, 0, "Reset", 1,
						  GTK_STOCK_CLOSE, GTK_RESPONSE_NONE);
      $window->set_screen($dialog->get_screen);
      $window->signal_connect("response" => \&gridded_geometry_subresponse, geometry_string);
      my $box = Gtk2::VBox->new(FALSE, 0);
      $window->vbox->pack_start($box, TRUE, TRUE, 0);
      $box->set_border_width(7);
      my $drawing_area = Gtk2::DrawingArea->new;
      $drawing_area->signal_connect("expose_event" => \&gridded_geometry_expose);
      $box->pack_start($drawing_area, TRUE, TRUE, 0);
      ## Gross hack to work around bug 68668... if we set the size request
      # * large enough, then  the current
      # *
      # *   request_of_window - request_of_geometry_widget
      # *
      # * method of getting the base size works more or less works.
      $drawing_area->set_size_request (2000, 2000);
      my $geometry;
      $geometry->base_width = 0;
      $geometry->base_height = 0;
      $geometry->min_width = 2 * GRID_SIZE;
      $geometry->min_height = 2 * GRID_SIZE;
      $geometry->width_inc = GRID_SIZE;
      $geometry->height_inc = GRID_SIZE;

      gtk_window_set_geometry_hints (window, drawing_area,
				     &geometry,
				     GDK_HINT_BASE_SIZE | GDK_HINT_MIN_SIZE | GDK_HINT_RESIZE_INC);

      if (!gtk_window_parse_geometry (window, geometry_string))
	{
	  g_print ("Can't parse geometry string %s\n", geometry_string);
	  gtk_window_parse_geometry (window, DEFAULT_GEOMETRY);
	}

      $window>show_all;
    }
}

my $ggwin;
sub create_gridded_geometry
{
  my ($widget) = @_;
  unless (defined $ggwin) {
    $ggwin = Gtk2::Dialog->new_with_buttons("Gridded Geometry", NULL, 0, "Create", 1,
					    Gtk2::Stock->CLOSE, GTK_RESPONSE_NONE);
    $ggwin->set_screen($widget->get_screen);
    my $label = Gtk2::Label->new("Geometry string:");
    $ggwin->vbox->pack_start($label, FALSE, FALSE, 0);
    my $entry = Gtk2::Entry->new;
    $entry->set_text(DEFAULT_GEOMETRY);
    $ggwin->vbox->pack_start($entry, FALSE, FALSE, 0);
    $ggwin->signal_connect("response" => \&gridded_geometry_response, $entry);
    $ggwin->add_weak_pointer($ggwin);
    $ggqin->show_all;
    }
  else { $ggwin->destroy }
}

# * GtkHandleBox

sub handle_box_child_signal
{
  my ($hb, $child, $action) = @_;
  printf ("%s: child <%s> %sed\n",
	  g_type_name (G_OBJECT_TYPE (hb)),
	  g_type_name (G_OBJECT_TYPE (child)),
	  action);
}

my $hbwin;
sub create_handle_box
{
  my ($widget) = @_;
  unless (defined $hbwin)
  {
    $hbwin = Gtk2::Window->new('toplevel');
    $hbwin->set_screen($widget->get_screen);
    $hbwin->set_title ("Handle Box Test");
    $hbwin->set_resizable(FALSE);
    $hbwin->signal_connect ("destroy" => sub { shift->destroyed(@_) }, $hbwin);
    $hbwin->set_border_width(20);
    my $vbox = Gtk2::VBox->new(FALSE, 0);
    $hbwin->add($vbox);
    $vbox->show;
    my $label = Gtk2::Label->new("Above");
    $vbox->add($label);
    $label->show;
    $vbox->add(Gtk2::HSeparator->new->show);
    my $hbox = Gtk2::HBox->new(FALSE, 10);
    $vbox->add($hbox);
    $hbox->show;
    $vbox->add(Gtk2::HSeparator->new->show);
    $label = Gtk2::Label->new("Below");
    $vbox->add($label);
    $label->show;
    my $handle_box = Gtk2::HandleBox->new;
    $hbox->pack_start ($handle_box, FALSE, FALSE, 0);
    g_signal_connect (handle_box,
		      "child_attached",
		      \&handle_box_child_signal,
		      "attached");
    g_signal_connect (handle_box,
		      "child_detached",
		      \&handle_box_child_signal,
		      "detached");
    $handle_box->show;
    my $toolbar = make_toolbar ($hbwin);
    $handle_box->add($toolbar);
    $toolbar->show;
    $handle_box = Gtk2::HandleBox->new;
    $hbox->pack_start ($handle_box, FALSE, FALSE, 0);
    g_signal_connect (handle_box,
		      "child_attached",
		      \&handle_box_child_signal,
		      "attached");
    g_signal_connect (handle_box,
		      "child_detached",
		      \&handle_box_child_signal,
		      "detached");
    $handle_box->show;
    my $handle_box2 = Gtk2::HandleBox->new;
    $handle_box->add($handle_box2);
    g_signal_connect (handle_box2,
		      "child_attached",
		      \&handle_box_child_signal,
		      "attached");
    g_signal_connect (handle_box2,
		      "child_detached",
		      \&handle_box_child_signal,
		      "detached");
    $handle_box2->show;

    $label = Gtk2::Label->new("Fooo!");
    $handle_box2->add($label);
    $label->show;
  }
  unless ($hbwin->VISIBLE) { $hbwin->show }
  else { $hbwin->destroy }
}


# * Test for getting an image from a drawable

{
  package GetImageData;
#  use base 
#  new_with_init
#  GtkWidget *src;
#  GtkWidget *snap;
#  GtkWidget *sw;
}

sub take_snapshot
{
  my ($button, $data) = @_;
  #struct GetImageData *gid = data;
  my $gid = $data;
  my $color = Gtk2::Gdk::Color->new(0, 30000, 0, 0);
#  # Do some begin_paint_rect on some random rects, draw some
#   * distinctive stuff into those rects, then take the snapshot.
#   * figure out whether any rects were overlapped and report to
#   * user.
  my $visible = gid->sw->allocation;
  visible->x = gtk_scrolled_window_get_hadjustment (GTK_SCROLLED_WINDOW (gid->sw))->value;
  visible->y = gtk_scrolled_window_get_vadjustment (GTK_SCROLLED_WINDOW (gid->sw))->value;
  my $width_fraction = visible->width / 4;
  my $height_fraction = visible->height / 4;
  my $gc = gdk_gc_new (gid->src->window);
  my $black_gc = gid->src->style->black_gc;
  gdk_gc_set_rgb_fg_color (gc, &color);
  my $target = Gtk2::Gdk::Rectangle->new;
  target->x = visible->x + width_fraction;
  target->y = visible->y + height_fraction * 3;
  target->width = width_fraction;
  target->height = height_fraction / 2;
  gdk_window_begin_paint_rect (gid->src->window,
                               &target);
  gdk_draw_rectangle (gid->src->window,
                      gc,
                      TRUE,
                      target->x, target->y,
                      target->width, target->height);
  gdk_draw_rectangle (gid->src->window,
                      black_gc,
                      FALSE,
                      target->x + 10, target->y + 10,
                      target->width - 20, target->height - 20);
  target->x = visible->x + width_fraction;
  target->y = visible->y + height_fraction;
  target->width = width_fraction;
  target->height = height_fraction;
  gdk_window_begin_paint_rect (gid->src->window,
                               &target);
  gdk_draw_rectangle (gid->src->window,
                      gc,
                      TRUE,
                      target->x, target->y,
                      target->width, target->height);
  gdk_draw_rectangle (gid->src->window,
                      black_gc,
                      FALSE,
                      target->x + 10, target->y + 10,
                      target->width - 20, target->height - 20);
  target->x = visible->x + width_fraction * 3;
  target->y = visible->y + height_fraction;
  target->width = width_fraction / 2;
  target->height = height_fraction;
  gdk_window_begin_paint_rect (gid->src->window, $target);
  gdk_draw_rectangle(gid->src->window,
		     gc,
		     TRUE,
		     target->x, target->y,
		     target->width, target->height);
  gdk_draw_rectangle(gid->src->window,
		     black_gc,
		     FALSE,
		     target->x + 10, target->y + 10,
                      target->width - 20, target->height - 20);
  target->x = visible->x + width_fraction * 2;
  target->y = visible->y + height_fraction * 2;
  target->width = width_fraction / 4;
  target->height = height_fraction / 4;
  gdk_window_begin_paint_rect (gid->src->window,
			       &target);
  gdk_draw_rectangle(gid->src->window,
		     gc,
		     TRUE,
		     target->x, target->y,
		     target->width, target->height);
  gdk_draw_rectangle(gid->src->window,
		     black_gc,
		     FALSE,
		     target->x + 10, target->y + 10,
		     target->width - 20, target->height - 20);  
  target->x += target->width / 2;
  target->y += target->width / 2;
  gdk_window_begin_paint_rect (gid->src->window,
                               &target);
  gdk_draw_rectangle (gid->src->window,
                      gc,
                      TRUE,
                      target->x, target->y,
                      target->width, target->height);
  gdk_draw_rectangle (gid->src->window,
                      black_gc,
                      FALSE,
                      target->x + 10, target->y + 10,
                      target->width - 20, target->height - 20);
  ## Screen shot area */
  target->x = visible->x + width_fraction * 1.5;
  target->y = visible->y + height_fraction * 1.5;
  target->width = width_fraction * 2;
  target->height = height_fraction * 2;  
  my $shot = gdk_drawable_get_image(gid->src->window,
				target->x, target->y,
				target->width, target->height);
  gtk_image_set_from_image (GTK_IMAGE (gid->snap),
			    shot, NULL);
  g_object_unref (shot);
  gdk_window_end_paint (gid->src->window);
  gdk_window_end_paint (gid->src->window);
  gdk_window_end_paint (gid->src->window);
  gdk_window_end_paint (gid->src->window);
  gdk_window_end_paint (gid->src->window);
  gdk_draw_rectangle(gid->src->window,
		     gid->src->style->black_gc,
		     FALSE,
		     target->x, target->y,
		     target->width, target->height);
  $gc->unref;
}

sub image_source_expose
{
  my ($da, $event, $data) = @_;
  my $x = $event->area->x;
  my $red = { 0, 65535, 0, 0 };
  my $green = { 0, 0, 65535, 0 };
  my $blue = { 0, 0, 0, 65535 };
  my $gc = Gtk2::Gdk::GC->new($event->window);
  while ($x < ($event->area->x + $event->area->width))
    {
      my $lowbits = $x % 7;
      if ($lowbits >= 0 and $lowbits <= 2) { $gc->set_rgb_fg_color($red) }
      elsif ($lowbits >= 3 and $lowbits <= 5) { $gc->set_rgb_fg_color($green) }
      elsif ($lowbits >= 6 and $lowbits <= 8) { $gc->set_rgb_fg_color($blue) }
      $event->window->draw_line($gc, $x, $event->area->y,
				$x, $event->area->y + $event->area->height);
      ++$x;
    }
  $gc->unref;
  return TRUE;
}

my $getimwin;
sub create_get_image (GtkWidget *widget)
{
  if ($getimwin) { $getimwin->destroy; }
  else {
    #struct GetImageData *gid;
    my $gid = g_new (struct GetImageData, 1);
    $getimwin = Gtk2::Window->new('toplevel');
    $getimwin->set_screen($widget->get_screen);
    $getimwin->signal_connect("destroy" => \&gtk_widget_destroyed, $getimwin);
    $getimwin->object_set_data_full("testgtk-get-image-data" => $gid);
    my $vbox = Gtk2::VBox->new(FALSE, 0);
    $getimwin->add($vbox);
    my $sw = Gtk2::Scrolled$Getimwin->new;
    $sw->set_policy(GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
    $gid->sw = $sw;
    $sw->set_size_request(400, 400);
    my $src = Gtk2::DrawingArea->new;
    $src->set_size_request(10000, 10000);
    $src->signal_connect("expose_event" => \&image_source_expose, $gid);
    $gid->src = $src;
    $sw->add_with_viewport($src);
    $vbox->pack_start ($sw, TRUE, TRUE, 0);
    my $hbox = Gtk2::HBox->new(FALSE, 3);
    my $snap = Gtk2::Widget->new(GTK_TYPE_IMAGE, NULL);
    $gid->snap = $snap;
    $sw = Gtk2::Scrolled$Getimwin->new;
    $sw->set_policy(GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
    $sw->set_size_request(300, 300);
    $sw->add_with_viewport($snap);
    $hbox->pack_end($sw, FALSE, FALSE, 5);
    my $button = Gtk2::Button->new("Get image from drawable");
    $button->signal_connect("clicked" => \&take_snapshot, $gid);
    $hbox->pack_start($button, FALSE, FALSE, 0);
    $vbox->pack_end($hbox, FALSE, FALSE, 0);
    $getimwin->show_all;
  }
}

## Label Demo

sub sensitivity_toggled
{
  my ($toggle, $widget) = @_;
  $widget->set_sensitive($toggle->active);
}

sub create_sensitivity_control
{
  my ($widget) = @_;
  my $button = Gtk2::ToggleButton->new_with_label("Sensitive");
  $button->set_active($widget->IS_SENSITIVE);
  $button->signal_connect("toggled" => \&sensitivity_toggled, $widget);
  $button->show_all;
  return $button;
}

sub set_selectable_recursive
{
  my ($widget, $setting) = @_;
  if ($widget->isa('Gtk2::Container'))
    {
      my $children = $widget->get_children;
      for my $tmp (@$children)
        {
          set_selectable_recursive($tmp->data, $setting);
        }
    }
  elsif ($widget->isa('Gtk2::Label'))
    {
      $widget->set_selectable($setting);
    }
}

sub selectable_toggled
{
  my ($toggle, $widget) = @_;
  set_selectable_recursive($widget, $toggle->active);
}

sub create_selectable_control
{
  my ($widget) = @_;
  my $button = gtk_toggle_button_new_with_label ("Selectable");  
  $button->set_active(FALSE);
  $button->signal_connect("toggled" => \&selectable_toggled, $widget);
  $button->show;
  return $button;
}

my $labwin;
sub create_labels
{
  my ($widget) = @_;
  static GtkWidget *window = NULL;
  unless (defined $labwin)
    {
      $labwin = Gtk2::Window->new('toplevel');
      gtk_window_set_screen ($labwin,
			     gtk_widget_get_screen (widget));
      g_signal_connect ($labwin, "destroy",
			\&gtk_widget_destroyed,
			$labwin);
      gtk_window_set_title ($labwin, "Label");
      my $vbox = Gtk2::VBox->new(FALSE, 5);
      my $hbox = Gtk2::HBox->new(FALSE, 5);
      $labwin->add($vbox);
      $vbox->pack_end($hbox, FALSE, FALSE, 0);
      my $button = create_sensitivity_control (hbox);
      $vbox->pack_start ($button, FALSE, FALSE, 0);
      $button = create_selectable_control (hbox);
      $vbox->pack_start ($button, FALSE, FALSE, 0);
      $vbox = Gtk2::VBox->new(FALSE, 5);
      $hbox->pack_start ($vbox, FALSE, FALSE, 0);
      gtk_container_set_border_width ($$labwin, 5);
      my $frame = Gtk2::Frame->new ("Normal Label");
      $frame->add(Gtk2::Label->new("This is a Normal label"));
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Multi-line Label");
      $frame->add(Gtk2::Label->new("This is a Multi-line label.\nSecond line\nThird line"));
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Left Justified Label");
      my $label = Gtk2::Label->new("This is a Left-Justified\nMulti-line label.\nThird      line");
      gtk_label_set_justify ($label, GTK_JUSTIFY_LEFT);
      $frame->add($label);
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Right Justified Label");
      $label = Gtk2::Label->new("This is a Right-Justified\nMulti-line label.\nFourth line, (j/k)");
      gtk_label_set_justify ($label, GTK_JUSTIFY_RIGHT);
      $frame->add($label);
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Internationalized Label");
      $label = Gtk2::Label->new;
      gtk_label_set_markup (GTK_LABEL (label),
			    "French (Français) Bonjour, Salut\n" .
			    "Korean (한글)   안녕하세요, 안녕하십니까\n" .
			    "Russian (Русский) Здравствуйте!\n" .
			    "Chinese (Simplified) <span lang=\"zh-cn\">元气	开发</span>\n" .
			    "Chinese (Traditional) <span lang=\"zh-tw\">元氣	開發</span>\n" .
			    "Japanese <span lang=\"ja\">元気	開発</span>");
      gtk_label_set_justify (GTK_LABEL (label), GTK_JUSTIFY_LEFT);
      $frame->add($label);
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Bidirection Label");
      $label = Gtk2::Label->new("Arabic	السلام عليكم\n" .
				"Hebrew	שלום");
      gtk_widget_set_direction ($label, GTK_TEXT_DIR_RTL);
      gtk_label_set_justify (GTK_LABEL (label), GTK_JUSTIFY_RIGHT);
      $frame->add($label);
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $vbox = Gtk2::VBox->new(FALSE, 5);
      $hbox->pack_start ($vbox, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Line wrapped label");
      $label = Gtk2::Label->new("This is an example of a line-wrapped label.  It should not be taking " .
			     "up the entire             " . # # big space to test spacing */
			     "width allocated to it, but automatically wraps the words to fit.  " .
			     "The time has come, for all good men, to come to the aid of their party.  " .
			     "The sixth sheik's six sheep's sick.\n" .
			     "     It supports multiple paragraphs correctly, and  correctly   adds " .
			     "many          extra  spaces. ");
      gtk_label_set_line_wrap (GTK_LABEL (label), TRUE);
      $frame->add($label);
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Filled, wrapped label");
      $label = Gtk2::Label->new("This is an example of a line-wrapped, filled label.  It should be taking " .
			      "up the entire              width allocated to it.  Here is a seneance to prove " .
			      "my point.  Here is another sentence. " .
			      "Here comes the sun, do de do de do.\n" .
			      "    This is a new paragraph.\n" .
			      "    This is another newer, longer, better paragraph.  It is coming to an end, " .
			      "unfortunately.");
      gtk_label_set_justify (GTK_LABEL (label), GTK_JUSTIFY_FILL);
      gtk_label_set_line_wrap (GTK_LABEL (label), TRUE);
      $frame->add($label);
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Underlined label");
      $label = Gtk2::Label->new("This label is underlined!\n" .
			     "This one is underlined (こんにちは) in quite a funky fashion");
      gtk_label_set_justify (GTK_LABEL (label), GTK_JUSTIFY_LEFT);
      $label->set_pattern("_________________________ _ _________ _ _____ _ __ __  ___ ____ _____");
      $frame->add($label);
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
      $frame = Gtk2::Frame->new ("Markup label");
      $label = Gtk2::Label->new;
      # There's also a gtk_label_set_markup() without accel if you
      # don't have an accelerator key
      gtk_label_set_markup_with_mnemonic (GTK_LABEL (label),
					  "This <span foreground=\"blue\" background=\"orange\">label</span> has " .
					  "<b>markup</b> _such as " .
					  "<big><i>Big Italics</i></big>\n" .
					  "<tt>Monospace font</tt>\n" .
					  "<u>Underline!</u>\n" .
					  "foo\n" .
					  "<span foreground=\"green\" background=\"red\">Ugly colors</span>\n" .
					  "and nothing on this line,\n" .
					  "or this.\n" .
					  "or this either\n" .
					  "or even on this one\n" .
					  "la <big>la <big>la <big>la <big>la</big></big></big></big>\n" .
					  "but this _word is <span foreground=\"purple\"><big>purple</big></span>\n" .
					  "<span underline=\"double\">We like <sup>superscript</sup> and <sub>subscript</sub> too</span>");
      g_assert (gtk_label_get_mnemonic_keyval (GTK_LABEL (label)) == GDK_s);
      $frame->add($label);
      $vbox->pack_start ($frame, FALSE, FALSE, 0);
    }
  unless ($labwin->VISIBLE) { $labwin->show_all }
  else { $labwin->destroy }
}

# Reparent demo

sub reparent_label
{
  my ($widget, $new_parent) = @_;
  my $label = $widget->get_data("user_data");
  $label->reparent($new_parent);
}

sub set_parent_signal
{
  my ($child, $old_parent, $func_data) = @_;
  g_print ("set_parent for \"%s\": new parent: \"%s\", old parent: \"%s\", data: %d\n",
	   g_type_name (G_OBJECT_TYPE (child)),
	   child->parent ? g_type_name (G_OBJECT_TYPE (child->parent)) : "NULL",
	   old_parent ? g_type_name (G_OBJECT_TYPE (old_parent)) : "NULL",
	   GPOINTER_TO_INT (func_data));
}

sub create_reparent
{
  my ($widget) = @_;
  static GtkWidget *window = NULL;
  unless (defined window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);
      gtk_window_set_title (window, "reparent");
      gtk_container_set_border_width ($window, 0);
      my $box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);
      my $box2 = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, TRUE, TRUE, 0);
      my $label = Gtk2::Label->new("Hello World");
      my $frame = Gtk2::Frame->new ("Frame 1");
      $box2->pack_start ($frame, TRUE, TRUE, 0);
      my $box3 = Gtk2::VBox->new(FALSE, 5);
      gtk_container_set_border_width ($box3, 5);
      $frame->add($box3);
      my $button = Gtk2::Button->new("switch");
      g_object_set_data (button, "user_data", label);
      $box3->pack_start ($button, FALSE, TRUE, 0);
      my $event_box = gtk_event_box_new ();
      $box3->pack_start ($event_box, FALSE, TRUE, 0);
      $event_box->add($label);
      g_signal_connect (button, "clicked",
			\&reparent_label,
			event_box);
      g_signal_connect (label, "parent_set",
			\&set_parent_signal,
			GINT_TO_POINTER (42));
      $frame = Gtk2::Frame->new ("Frame 2");
      $box2->pack_start ($frame, TRUE, TRUE, 0);
      $box3 = Gtk2::VBox->new(FALSE, 5);
      gtk_container_set_border_width ($box3, 5);
      $frame->add($box3);
      $button = Gtk2::Button->new("switch");
      g_object_set_data (button, "user_data", label);
      $box3->pack_start ($button, FALSE, TRUE, 0);
      my $event_box = gtk_event_box_new ();
      $box3->pack_start ($event_box, FALSE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&reparent_label,
			event_box);
      $box1->pack_start (Gtk2::HSeparator->new, FALSE, TRUE, 0);
      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);
      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy, window);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
    }
  unless ($window->VISIBLE) { $window->show_all }
  else { $window->destroy }
}

# * Resize Grips

sub grippy_button_press
{
  my  ($area, $event, $edge) = @_;
  if ($event->type == GDK_BUTTON_PRESS) 
    {
      if ($event->button == 1) {
	$area->get_toplevel->begin_resize_drag($edge,
					       $event->button, $event->x_root, $event->y_root,
					       $event->time);
      }
      elsif (event->button == 2) {
	$area->get_toplevel->begin_move_drag($event->button, $event->x_root,
					     $event->y_root, $event->time);
      }
    }
  return TRUE;
}

sub grippy_expose
{
  my ($area, $event, $edge) = @_;
  $area->style->paint_resize_grip($area->window, $area->STATE, $event->area, $area,
				  "statusbar", $edge, 0, 0,
				  $area->allocation->width, $area->allocation->height);
  return TRUE;
}

sub create_resize_grips
{
  my ($widget) = @_;
  static GtkWidget *window = NULL;
  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));
      gtk_window_set_title (window, "resize grips");
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      my $vbox = Gtk2::VBox->new(FALSE, 0);
      $window->add($vbox);
      my $hbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($hbox, TRUE, TRUE, 0);
      ## North west */
      my $area = gtk_drawing_area_new ();
      gtk_widget_add_events (area, GDK_BUTTON_PRESS_MASK);
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      g_signal_connect (area, "expose_event", \&grippy_expose,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_NORTH_WEST));
      g_signal_connect (area, "button_press_event", \&grippy_button_press,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_NORTH_WEST));
      ## North */
      $area = gtk_drawing_area_new ();
      gtk_widget_add_events (area, GDK_BUTTON_PRESS_MASK);
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      g_signal_connect (area, "expose_event", \&grippy_expose,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_NORTH));
      g_signal_connect (area, "button_press_event", \&grippy_button_press,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_NORTH));
      ## North east */
      $area = gtk_drawing_area_new ();
      gtk_widget_add_events (area, GDK_BUTTON_PRESS_MASK);
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      g_signal_connect (area, "expose_event", \&grippy_expose,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_NORTH_EAST));
      g_signal_connect (area, "button_press_event", \&grippy_button_press,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_NORTH_EAST));
      $hbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($hbox, TRUE, TRUE, 0);
      ## West */
      $area = gtk_drawing_area_new ();
      gtk_widget_add_events (area, GDK_BUTTON_PRESS_MASK);
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      g_signal_connect (area, "expose_event", \&grippy_expose,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_WEST));
      g_signal_connect (area, "button_press_event", \&grippy_button_press,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_WEST));
      ## Middle */
      $area = gtk_drawing_area_new ();
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      ## East */
      $area = gtk_drawing_area_new ();
      gtk_widget_add_events (area, GDK_BUTTON_PRESS_MASK);
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      g_signal_connect (area, "expose_event", \&grippy_expose,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_EAST));
      g_signal_connect (area, "button_press_event", \&grippy_button_press,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_EAST));
      $hbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($hbox, TRUE, TRUE, 0);
      ## South west */
      $area = gtk_drawing_area_new ();
      gtk_widget_add_events (area, GDK_BUTTON_PRESS_MASK);
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      g_signal_connect (area, "expose_event", \&grippy_expose,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_SOUTH_WEST));
      g_signal_connect (area, "button_press_event", \&grippy_button_press,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_SOUTH_WEST));
      ## South */
      $area = gtk_drawing_area_new ();
      gtk_widget_add_events (area, GDK_BUTTON_PRESS_MASK);
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      g_signal_connect (area, "expose_event", \&grippy_expose,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_SOUTH));
      g_signal_connect (area, "button_press_event", \&grippy_button_press,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_SOUTH));
      ## South east */
      $area = gtk_drawing_area_new ();
      gtk_widget_add_events (area, GDK_BUTTON_PRESS_MASK);
      $hbox->pack_start ($area, TRUE, TRUE, 0);
      g_signal_connect (area, "expose_event", \&grippy_expose,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_SOUTH_EAST));
      g_signal_connect (area, "button_press_event", \&grippy_button_press,
			GINT_TO_POINTER (GDK_WINDOW_EDGE_SOUTH_EAST));
    }
  if (!GTK_WIDGET_VISIBLE (window)) { $window->show_all }
  else { gtk_widget_destroy (window) }
}

# * Saved Position

my ($upositionx, $upositiony) = (0,0);

sub uposition_configure
{
  my ($window) = @_;
  my $lx = g_object_get_data (window, "x");
  my $ly = g_object_get_data (window, "y");
  $window->window->get_root_origin($upositionx, $upositiony);
  $lx->set_text(sprintf "%d", $upositionx);
  $ly->set_text(sprintf "%d", upositiony);
  return FALSE;
}

sub uposition_stop_configure
{
  my  ($toggle, $window) = @_;
  if ($toggle->active) {
    $window->signal_handlers_block_by_func(\&uposition_configure);
  } else {
    $window->signal_handlers_unblock_by_func(\&uposition_configure);
  }
}

sub create_saved_position (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  unless (defined window)
    {
      window = g_object_connect (gtk_widget_new (GTK_TYPE_WINDOW,
						 "type", GTK_WINDOW_TOPLEVEL,
						 "x", upositionx,
						 "y", upositiony,
						 "title", "Saved Position",
						 NULL),
				 "signal::configure_event", uposition_configure, NULL,
				 NULL);
      gtk_window_set_screen (window, gtk_widget_get_screen (widget));
      g_signal_connect (window, "destroy" => \&gtk_widget_destroyed, &window);
      my $main_vbox = Gtk2::VBox->new(FALSE, 5);
      gtk_container_set_border_width ($main_vbox, 0);
      $window->add($main_vbox);
      my $vbox =
	gtk_widget_new (gtk_vbox_get_type (),
			"GtkBox::homogeneous", FALSE,
			"GtkBox::spacing", 5,
			"GtkContainer::border_width", 10,
			"GtkWidget::parent", main_vbox,
			"GtkWidget::visible", TRUE,
			"child", g_object_connect (gtk_widget_new (GTK_TYPE_TOGGLE_BUTTON,
								   "label", "Stop Events",
								   "active", FALSE,
								   "visible", TRUE,
								   NULL),
						   "signal::clicked", uposition_stop_configure, window,
						   NULL),
			NULL);
      my $hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox, 5);
      $vbox->pack_start ($hbox, FALSE, TRUE, 0);
      my $label = Gtk2::Label->new("X Origin : ");
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);
      $hbox->pack_start ($label, FALSE, TRUE, 0);
      my $x_label = Gtk2::Label->new("");
      $hbox->pack_start ($x_label, TRUE, TRUE, 0);
      g_object_set_data (window, "x", x_label);
      $hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox, 5);
      $vbox->pack_start ($hbox, FALSE, TRUE, 0);
      $label = Gtk2::Label->new("Y Origin : ");
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);
      $hbox->pack_start ($label, FALSE, TRUE, 0);
      my $y_label = Gtk2::Label->new("");
      $hbox->pack_start ($y_label, TRUE, TRUE, 0);
      g_object_set_data (window, "y", y_label);
      my $any = gtk_widget_new (gtk_hseparator_get_type (), "GtkWidget::visible", TRUE);
      $main_vbox->pack_start ($any, FALSE, TRUE, 0);
      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox, 10);
      $main_vbox->pack_start ($hbox, FALSE, TRUE, 0);
      my $button = Gtk2::Button->new("Close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $hbox->pack_start ($button, TRUE, TRUE, 5);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
      $window->show_all;
    }
  else { gtk_widget_destroy (window); }
}

# * GtkPixmap

sub create_pixmap (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  unless (defined window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window, gtk_widget_get_screen (widget));
      g_signal_connect (window, "destroy" => \&gtk_widget_destroyed, $window);
      gtk_window_set_title (window, "GtkPixmap");
      gtk_container_set_border_width ($window, 0);
      gtk_widget_realize(window);
      my $box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);
      my $box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, TRUE, TRUE, 0);
      my $button = gtk_button_new ();
      $box2->pack_start ($button, FALSE, FALSE, 0);
      my $pixmapwid = new_pixmap ("test.xpm", window->window, NULL);
      my $label = Gtk2::Label->new("Pixmap\ntest");
      my $box3 = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($box3, 2);
      $box3->add($pixmapwid);
      $box3->add($label);
      $button->add($box3);
      $button = gtk_button_new ();
      $box2->pack_start ($button, FALSE, FALSE, 0);
      $pixmapwid = new_pixmap ("test.xpm", window->window, NULL);
      $label = Gtk2::Label->new("Pixmap\ntest");
      $box3 = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($box3, 2);
      $box3->add($pixmapwid);
      $box3->add($label);
      $button->add($box3);
      gtk_widget_set_sensitive (button, FALSE);
      my $separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 0);
      $box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);
      $button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
    }
  unless(GTK_WIDGET_VISIBLE (window)){    $window->show_all; }
  else { gtk_widget_destroy (window); }
}

sub tips_query_widget_entered (GtkTipsQuery   *tips_query,
			   GtkWidget      *widget,
			   const gchar    *tip_text,
			   const gchar    *tip_private,
			   GtkWidget	  *toggle)
{
  if (GTK_TOGGLE_BUTTON (toggle)->active)
    {
      gtk_label_set_text (GTK_LABEL (tips_query), tip_text ? "There is a Tip!" : "There is no Tip!");
      ## don't let GtkTipsQuery reset its label */
      g_signal_stop_emission_by_name (tips_query, "widget_entered");
    }
}

sub tips_query_widget_selected
{
  my ($tips_query, $widget, $tip_text, $tip_private, $event, $func_data) = @_;
  if ($widget) {
    printf(qq/Help "%s" requested for <%s>\n/, $tip_private ? $tip_private : "None",
	   g_type_name (G_OBJECT_TYPE (widget)));
  }
  return TRUE;
}

my $ttwin;
sub create_tooltips
{
  my ($widget) = @_;
  unless (defined $ttwin)
    {
      $ttwin =
	Gtk2::Widget->new(Gtk2::Window->get_type,
			"GtkWindow::type" => 'toplevel',
			"GtkContainer::border_width" => 0,
			"GtkWindow::title" => "Tooltips",
			"GtkWindow::allow_shrink" => TRUE,
			"GtkWindow::allow_grow" => FALSE);
      $ttwin->set_screen($widget->get_screen);
      $ttwin->signal_connect("destroy" => \&destroy_tooltips, $ttwin);
      my $tooltips=gtk_tooltips_new();
      $tooltips->ref;
      $tooltips->sink;
      $ttwin->set_data("tooltips" => tooltips);
      my $box1 = Gtk2::VBox->new(FALSE, 0);
      $ttwin->add($box1);
      my $box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, TRUE, TRUE, 0);
      my $button = gtk_toggle_button_new_with_label ("button1");
      $box2->pack_start ($button, TRUE, TRUE, 0);
      $tooltips->set_tip($button, "This is button 1", "ContextHelp/buttons/1");
      $button = gtk_toggle_button_new_with_label ("button2");
      $box2->pack_start ($button, TRUE, TRUE, 0);
      $tooltips->set_tip($button,
			 "This is button 2. This is also a really long tooltip which probably won't fit on a single line and will therefore need to be wrapped. Hopefully the wrapping will work correctly.",
			 "ContextHelp/buttons/2_long");
      my $toggle = gtk_toggle_button_new_with_label ("Override TipsQuery Label");
      $box2->pack_start ($toggle, TRUE, TRUE, 0);
      gtk_tooltips_set_tip (tooltips,
			    toggle,
			    "Toggle TipsQuery view.",
			    "Hi msw! ;)");
      my $box3 = gtk_widget_new (gtk_vbox_get_type (),
				 "homogeneous", FALSE,
				 "spacing", 5,
				 "border_width", 5,
				 "visible", TRUE,
				 NULL);
      my $tips_query = gtk_tips_query_new ();
      $button =	gtk_widget_new (gtk_button_get_type (),
			"label", "[?]",
			"visible", TRUE,
			"parent", box3,
			NULL);
      $button->object_connect ("swapped_signal::clicked" => \&gtk_tips_query_start_query, tips_query);
      gtk_box_set_child_packing (box3, button, FALSE, FALSE, 0, GTK_PACK_START);
      gtk_tooltips_set_tip (tooltips,
			    button,
			    "Start the Tooltips Inspector",
			    "ContextHelp/buttons/?");
      g_object_set (g_object_connect (tips_query,
				      "signal::widget_entered", tips_query_widget_entered, toggle,
				      "signal::widget_selected", tips_query_widget_selected, NULL,
				      NULL),
		    "visible", TRUE,
		    "parent", box3,
		    "caller", button,
		    NULL);
      my $frame = Gtk2::Widget->new(Gtk2::Frame->get_type,
				    "label" => "ToolTips Inspector",
				    "label_xalign" => 0.5,
				    "border_width" => 0,
				    "visible" => TRUE,
				    "parent" => $box2,
				    "child" => $box3);
      gtk_box_set_child_packing (box2, frame, TRUE, TRUE, 10, GTK_PACK_START);

      my $separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 0);

      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);

      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				$ttwin);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);

      gtk_tooltips_set_tip (tooltips, button, "Push this button to close window", "ContextHelp/buttons/Close");
    }
  if (!GTK_WIDGET_VISIBLE ($ttwin)) { $ttwin->show_all }
  else { $ttwin->destroy }
}

# GtkImage

sub pack_image
{
  my ($box,$text,$image) = @_;
  $box->pack_start(Gtk2::Label->new($text), FALSE, FALSE, 0);
  $box->pack_start ($image, TRUE, TRUE, 0);
}

my $imwin;
sub create_image
{
  my ($widget) = @_;
  unless (defined $imwin)
    {
      my $mask;
      $imwin = Gtk2::Window->new('toplevel');
      $imwin->set_screen($widget->get_screen);
      ## this is bogus for testing drawing when allocation < request,
      # * don't copy into real code
      # */
      $imwin->set("allow_shrink" => TRUE, "allow_grow" => TRUE);
      $imwin->signal_connect("destroy" => \&gtk_widget_destroyed, $window);
      my $vbox = Gtk2::VBox->new(FALSE, 5);
      $window->add($vbox);
      pack_image ($vbox, "Stock Warning Dialog",
                  Gtk2::Image->new_from_stock(Gtk2::Stock->DIALOG_WARNING, GTK_ICON_SIZE_DIALOG));
      my $pixmap = Gtk2::Gdk::Pixmap->colormap_create_from_xpm_d(undef,
								 $imwin->get_colormap,
								 \$mask, undef, \&openfile);
      pack_image ($vbox, "Pixmap", Gtk2::Image->new_from_pixmap($pixmap, $mask));
    }
  unless ($imwin->VISIBLE) { $imwin->show_all; }
  else { $imwin->destroy }
}
     
# * Menu demo

sub create_menu (GdkScreen *screen, gint depth, gint length, gboolean tearoff)
{
  GtkWidget *menu;
  GtkWidget *menuitem;
  GtkWidget *image;
  GSList *group;
  char buf[32];
  int i, j;

  if (depth < 1)
    return NULL;

  menu = Gtk2::Menu->new;
  gtk_menu_set_screen (GTK_MENU (menu), screen);

  group = NULL;

  if (tearoff)
    {
      menuitem = gtk_tearoff_menu_item_new ();
      gtk_menu_shell_append (GTK_MENU_SHELL (menu), menuitem);
      $menuitem->show;
    }

  image = gtk_image_new_from_stock (GTK_STOCK_OPEN,
                                    GTK_ICON_SIZE_MENU);
  $image->show;
  menuitem = gtk_image_menu_item_new_with_label ("Image item");
  gtk_image_menu_item_set_image (GTK_IMAGE_MENU_ITEM (menuitem), image);
  gtk_menu_shell_append (GTK_MENU_SHELL (menu), menuitem);
  $menuitem->show;
  
  for (i = 0, j = 1; i < length; i++, j++)
    {
      sprintf (buf, "item %2d - %d", depth, j);

      menuitem = gtk_radio_menu_item_new_with_label (group, buf);
      group = gtk_radio_menu_item_get_group (GTK_RADIO_MENU_ITEM (menuitem));

#if 0
#      if (depth % 2)
#	gtk_check_menu_item_set_show_toggle (GTK_CHECK_MENU_ITEM (menuitem), TRUE);
#endif

      gtk_menu_shell_append (GTK_MENU_SHELL (menu), menuitem);
      $menuitem->show;
      if (i == 3)
	gtk_widget_set_sensitive (menuitem, FALSE);

      if (i == 5)
        gtk_check_menu_item_set_inconsistent (GTK_CHECK_MENU_ITEM (menuitem),
                                              TRUE);

      if (i < 5)
	gtk_menu_item_set_submenu (GTK_MENU_ITEM (menuitem), 
				   create_menu (screen, depth - 1, 5,  TRUE));
    }

  return menu;
}

sub create_menus (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *box1;
  GtkWidget *box2;
  GtkWidget *button;
  GtkWidget *optionmenu;
  
  if (!window)
    {
      GtkWidget *menubar;
      GtkWidget *menu;
      GtkWidget *menuitem;
      GtkAccelGroup *accel_group;
      GtkWidget *image;
      GdkScreen *screen = gtk_widget_get_screen (widget);
      
      window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (window, screen);
      
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);
      g_signal_connect (window, "delete-event",
			\&gtk_true,
			NULL);
      
      accel_group = gtk_accel_group_new ();
      gtk_window_add_accel_group (window, accel_group);

      gtk_window_set_title (window, "menus");
      gtk_container_set_border_width ($window, 0);
      
      
      box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);
      $box1->show;
      
      menubar = gtk_menu_bar_new ();
      $box1->pack_start ($menubar, FALSE, TRUE, 0);
      $menubar->show;
      
      menu = create_menu (screen, 2, 50, TRUE);
      
      menuitem = gtk_menu_item_new_with_label ("test\nline2");
      gtk_menu_item_set_submenu (GTK_MENU_ITEM (menuitem), menu);
      gtk_menu_shell_append (GTK_MENU_SHELL (menubar), menuitem);
      $menuitem->show;
      
      menuitem = gtk_menu_item_new_with_label ("foo");
      gtk_menu_item_set_submenu (GTK_MENU_ITEM (menuitem), create_menu (screen, 3, 5, TRUE));
      gtk_menu_shell_append (GTK_MENU_SHELL (menubar), menuitem);
      $menuitem->show;

      image = gtk_image_new_from_stock (GTK_STOCK_HELP,
                                        GTK_ICON_SIZE_MENU);
      $image->show;
      menuitem = gtk_image_menu_item_new_with_label ("Help");
      gtk_image_menu_item_set_image (GTK_IMAGE_MENU_ITEM (menuitem), image);
      gtk_menu_item_set_submenu (GTK_MENU_ITEM (menuitem), create_menu (screen, 4, 5, TRUE));
      gtk_menu_item_set_right_justified (GTK_MENU_ITEM (menuitem), TRUE);
      gtk_menu_shell_append (GTK_MENU_SHELL (menubar), menuitem);
      $menuitem->show;
      
      menubar = gtk_menu_bar_new ();
      $box1->pack_start ($menubar, FALSE, TRUE, 0);
      $menubar->show;
      
      menu = create_menu (screen, 2, 10, TRUE);
      
      menuitem = gtk_menu_item_new_with_label ("Second menu bar");
      gtk_menu_item_set_submenu (GTK_MENU_ITEM (menuitem), menu);
      gtk_menu_shell_append (GTK_MENU_SHELL (menubar), menuitem);
      $menuitem->show;
      
      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, TRUE, TRUE, 0);
      $box2->show;
      
      menu = create_menu (screen, 1, 5, FALSE);
      gtk_menu_set_accel_group (GTK_MENU (menu), accel_group);

      menuitem = gtk_image_menu_item_new_from_stock (GTK_STOCK_NEW, accel_group);
      gtk_menu_shell_append (GTK_MENU_SHELL (menu), menuitem);
      $menuitem->show;
      
      menuitem = gtk_check_menu_item_new_with_label ("Accelerate Me");
      gtk_menu_shell_append (GTK_MENU_SHELL (menu), menuitem);
      $menuitem->show;
      gtk_widget_add_accelerator (menuitem,
				  "activate",
				  accel_group,
				  GDK_F1,
				  0,
				  GTK_ACCEL_VISIBLE);
      menuitem = gtk_check_menu_item_new_with_label ("Accelerator Locked");
      gtk_menu_shell_append (GTK_MENU_SHELL (menu), menuitem);
      $menuitem->show;
      gtk_widget_add_accelerator (menuitem,
				  "activate",
				  accel_group,
				  GDK_F2,
				  0,
				  GTK_ACCEL_VISIBLE | GTK_ACCEL_LOCKED);
      menuitem = gtk_check_menu_item_new_with_label ("Accelerators Frozen");
      gtk_menu_shell_append (GTK_MENU_SHELL (menu), menuitem);
      $menuitem->show;
      gtk_widget_add_accelerator (menuitem,
				  "activate",
				  accel_group,
				  GDK_F2,
				  0,
				  GTK_ACCEL_VISIBLE);
      gtk_widget_add_accelerator (menuitem,
				  "activate",
				  accel_group,
				  GDK_F3,
				  0,
				  GTK_ACCEL_VISIBLE);
      
      optionmenu = Gtk2::OptionMenu->new;
      gtk_option_menu_set_menu (GTK_OPTION_MENU (optionmenu), menu);
      gtk_option_menu_set_history (GTK_OPTION_MENU (optionmenu), 3);
      $box2->pack_start ($optionmenu, TRUE, TRUE, 0);
      $optionmenu->show;

      my $separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 0);
      $separator->show;

      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);
      $box2->show;

      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
      $button->show;
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

sub gtk_ifactory_cb (gpointer             callback_data,
		 guint                callback_action,
		 GtkWidget           *widget)
{
  g_message ("ItemFactory: activated \"%s\"", gtk_item_factory_path_from_widget (widget));
}

## GdkPixbuf RGBA C-Source image dump */

my $apple =
[ "",
  ## Pixbuf magic (0x47646b50) */
  "GdkP",
  ## length: header (24) + pixel_data (2304) */
  "\0\0\11\30",
  ## pixdata_type (0x1010002) */
  "\1\1\0\2",
  ## rowstride (96) */
  "\0\0\0`",
  ## width (24) */
  "\0\0\0\30",
  ## height (24) */
  "\0\0\0\30",
  ## pixel_data: */
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\26\24",
  "\17\11\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`m",
  "[pn{a\344hv_\345_k[`\0\0\0\0\0\0\0\0\0\0\0\0D>/\305\0\0\0_\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0`l[Blza\373s\202d\354w\206g\372p~c",
  "\374`l[y\0\0\0\0[S\77/\27\25\17\335\0\0\0\20\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0`l\\\20iw_\356y\211h\373x\207g\364~\216i\364u\204e\366gt",
  "_\374^jX\241A;-_\0\0\0~\0\0\0\0SM4)SM21B9&\22\320\270\204\1\320\270\204",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0eq",
  "]\212r\200c\366v\205f\371jx_\323_kY\232_kZH^jY\26]iW\211\@G9\272:6\%j\220",
  "\211]\320\221\211`\377\212\203Z\377~xP\377mkE\331]^;|/0\37\21\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0ly`\40p~b\360lz`\353^kY\246[",
  "eT<\216\200Z\203\227\211_\354\234\217c\377\232\217b\362\232\220c\337",
  "\243\233k\377\252\241p\377\250\236p\377\241\225h\377\231\214_\377\210",
  "\202U\377srI\377[]:\355KO0U\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0i",
  "v^\200`lY\211^jY\"\0\0\0\0\221\204\\\273\250\233r\377\302\267\224\377",
  "\311\300\237\377\272\256\204\377\271\256\177\377\271\257\200\377\267",
  "\260\177\377\260\251x\377\250\236l\377\242\225e\377\226\213]\377~zP\377",
  "ff@\377QT5\377LR2d\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0]iW(\0\0\0\0\0\0\0",
  "\0\213\203[v\253\240t\377\334\326\301\377\344\340\317\377\321\312\253",
  "\377\303\271\217\377\300\270\213\377\277\267\210\377\272\264\203\377",
  "\261\255z\377\250\242n\377\243\232h\377\232\220`\377\210\202V\377nnE",
  "\377SW6\377RX6\364Za<\34\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0b]@\20",
  "\234\222e\362\304\274\232\377\337\333\306\377\332\325\273\377\311\302",
  "\232\377\312\303\236\377\301\273\216\377\300\271\212\377\270\264\200",
  "\377\256\253v\377\246\243n\377\236\232h\377\230\220`\377\213\203V\377",
  "wvL\377X]:\377KR0\377NU5v\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\212",
  "\203Zl\242\234l\377\321\315\260\377\331\324\271\377\320\313\251\377\307",
  "\301\232\377\303\276\224\377\300\272\214\377\274\267\206\377\264\260",
  "|\377\253\251s\377\244\243n\377\232\230e\377\223\216^\377\207\200U\377",
  "ttJ\377[_<\377HO/\377GN0\200\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\210\204Y\240\245\237o\377\316\310\253\377\310\303\237\377\304\300\230",
  "\377\303\277\225\377\277\272\216\377\274\270\210\377\266\263\200\377",
  "\256\254v\377\247\246p\377\237\236j\377\227\226d\377\215\212[\377\203",
  "\177T\377qsH\377X]8\377FN.\377DK-\200\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\207\204X\257\244\240o\377\300\275\231\377\301\275\226\377\274",
  "\270\213\377\274\270\214\377\267\264\205\377\264\262\200\377\260\256",
  "z\377\251\251s\377\243\244n\377\231\232g\377\220\222`\377\210\211Y\377",
  "|}Q\377hlC\377PU3\377CK,\377DL/Y\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\205\204X\220\232\230h\377\261\260\204\377\266\264\212\377\261\260",
  "\201\377\263\260\200\377\260\257}\377\256\256x\377\253\254t\377\244\246",
  "o\377\233\236i\377\221\224b\377\211\214\\\377\202\204V\377txM\377]b>",
  "\377HP0\377\@H+\373CJ-\25\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0xxO>",
  "\215\215_\377\237\237r\377\247\247x\377\247\247t\377\252\252w\377\252",
  "\252u\377\252\253t\377\243\246o\377\235\240j\377\223\230c\377\213\217",
  "]\377\201\206V\377x}P\377gkD\377RY5\377BI,\377AI,\262\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\202\205W\312\216\220`\377\230",
  "\232g\377\234\236i\377\236\241l\377\241\244n\377\240\244m\377\232\237",
  "i\377\223\230c\377\212\221]\377\200\210W\377v|P\377jnG\377Za>\377HP2",
  "\377=D)\377HQ1:\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0wzQ6\177\201U\371\206\211Z\377\216\222`\377\220\225a\377\220\225b\377",
  "\220\226a\377\213\221_\377\204\213Z\377{\203R\377ryN\377iqH\377^fA\377",
  "R[;\377BJ-\3778@'\317\0\0\0>\0\0\0\36\0\0\0\7\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0ptJTw|Q\371z\177R\377}\202T\377|\203T\377z\200",
  "R\377v|O\377pwL\377jpF\377dlB\377`hB\377Yb@\377LT6\377<C*\377\11\12\6",
  "\376\0\0\0\347\0\0\0\262\0\0\0Y\0\0\0\32\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\\`=UgnE\370hnG\377gmE\377djB\377]d>\377[c<\377Y",
  "b<\377Zc>\377V_>\377OW8\377BK/\377\16\20\12\377\0\0\0\377\0\0\0\377\0",
  "\0\0\374\0\0\0\320\0\0\0I\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\1\0\0\0\40\22\24\15\260\@D+\377W`;\377OV5\377.3\36\377.3\37\377IP0",
  "\377RZ7\377PZ8\3776=&\377\14\15\10\377\0\0\0\377\0\0\0\377\0\0\0\377",
  "\0\0\0\347\0\0\0\217\0\0\0""4\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\20\0\0\0P\0\0\0\252\7\10\5\346\7\7\5\375\0\0\0\377\0\0",
  "\0\377\0\0\0\377\0\0\0\377\0\0\0\377\0\0\0\377\0\0\0\377\0\0\0\374\0",
  "\0\0\336\0\0\0\254\0\0\0i\0\0\0""2\0\0\0\10\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\11\0\0\0\40\0\0\0D\0\0\0m\0\0\0",
  "\226\0\0\0\234\0\0\0\234\0\0\0\244\0\0\0\246\0\0\0\232\0\0\0\202\0\0",
  "\0i\0\0\0T\0\0\0,\0\0\0\15\0\0\0\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0",
  "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\2\0\0\0\6\0\0\0",
  "\16\0\0\0\22\0\0\0\24\0\0\0\23\0\0\0\17\0\0\0\14\0\0\0\13\0\0\0\10\0",
  "\0\0\5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"];


sub dump_accels
{
  my ($callback_data, $callback_action, $widget) = @_;
  Gtk2->AccelMap->save_fd(1); # # stdout */
}
    
my $menu_items =
[
  [ "/_File",                  NULL,         0,                     0, "<Branch>" ],
  [ "/File/tearoff1",          NULL,         gtk_ifactory_cb,       0, "<Tearoff>" ],
  [ "/File/_New",              NULL,         gtk_ifactory_cb,       0, "<StockItem>", GTK_STOCK_NEW ],
  [ "/File/_Open",             NULL,         gtk_ifactory_cb,       0, "<StockItem>", GTK_STOCK_OPEN ],
  [ "/File/_Save",             NULL,         gtk_ifactory_cb,       0, "<StockItem>", GTK_STOCK_SAVE ],
  [ "/File/Save _As...",       "<control>A", gtk_ifactory_cb,       0, "<StockItem>", GTK_STOCK_SAVE ],
  [ "/File/_Dump \"_Accels\"",  NULL,        dump_accels,           0 ],
  [ "/File/\\/Test__Escaping/And\\/\n\tWei\\\\rdly", NULL,        gtk_ifactory_cb,       0 ],
  [ "/File/sep1",        NULL,               gtk_ifactory_cb,       0, "<Separator>" ],
  [ "/File/_Quit",       NULL,               gtk_ifactory_cb,       0, "<StockItem>", GTK_STOCK_QUIT ],
  [ "/_Preferences",     		NULL, 0,               0, "<Branch>" ],
  [ "/_Preferences/_Color", 		NULL, 0,               0, "<Branch>" ],
  [ "/_Preferences/Color/_Red",      	NULL, gtk_ifactory_cb, 0, "<RadioItem>" ],
  [ "/_Preferences/Color/_Green",   	NULL, gtk_ifactory_cb, 0, "/Preferences/Color/Red" ],
  [ "/_Preferences/Color/_Blue",        NULL, gtk_ifactory_cb, 0, "/Preferences/Color/Red" ],
  [ "/_Preferences/_Shape", 		NULL, 0,               0, "<Branch>" ],
  [ "/_Preferences/Shape/_Square",      NULL, gtk_ifactory_cb, 0, "<RadioItem>" ],
  [ "/_Preferences/Shape/_Rectangle",   NULL, gtk_ifactory_cb, 0, "/Preferences/Shape/Square" ],
  [ "/_Preferences/Shape/_Oval",        NULL, gtk_ifactory_cb, 0, "/Preferences/Shape/Rectangle" ],
  [ "/_Preferences/Shape/_Rectangle",   NULL, gtk_ifactory_cb, 0, "/Preferences/Shape/Square" ],
  [ "/_Preferences/Shape/_Oval",        NULL, gtk_ifactory_cb, 0, "/Preferences/Shape/Rectangle" ],
  [ "/_Preferences/Shape/_Image",       NULL, gtk_ifactory_cb, 0, "<ImageItem>", apple ],
  [ "/_Preferences/Coffee",                  NULL, gtk_ifactory_cb, 0, "<CheckItem>" ],
  [ "/_Preferences/Toast",                   NULL, gtk_ifactory_cb, 0, "<CheckItem>" ],
  [ "/_Preferences/Marshmallow Froot Loops", NULL, gtk_ifactory_cb, 0, "<CheckItem>" ],
  ## For testing deletion of menus */
  [ "/_Preferences/Should_NotAppear",          NULL, 0,               0, "<Branch>" ],
  [ "/Preferences/ShouldNotAppear/SubItem1",   NULL, gtk_ifactory_cb, 0 ],
  [ "/Preferences/ShouldNotAppear/SubItem2",   NULL, gtk_ifactory_cb, 0 ],
  [ "/_Help",            NULL,         0,                     0, "<LastBranch>" ],
  [ "/Help/_Help",       NULL,         gtk_ifactory_cb,       0, "<StockItem>", GTK_STOCK_HELP],
  [ "/Help/_About",      NULL,         gtk_ifactory_cb,       0 ],
];
my $nmenu_items = scalar @$menu_items;

sub create_item_factory (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  
  if (!window)
    {
      GtkWidget *box1;
      GtkWidget *box2;
      GtkWidget *separator;
      GtkWidget *label;
      GtkWidget *button;
      GtkAccelGroup *accel_group;
      GtkItemFactory *item_factory;
      GtkTooltips *tooltips;
      
      window = Gtk2::Window->new('toplevel');
      
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));
      
      $window->signal_connect("destroy" => \&Gtk2::Widget::estroyed, $window);
      $window->signal_connect("delete-event" => sub { Gtk2->true });
      accel_group = gtk_accel_group_new ();
      item_factory = gtk_item_factory_new (GTK_TYPE_MENU_BAR, "<main>", accel_group);
      g_object_set_data_full (window,
			      "<main>",
			      item_factory,
			      g_object_unref);
      gtk_window_add_accel_group (window, accel_group);
      gtk_window_set_title (window, "Item Factory");
      gtk_container_set_border_width ($window, 0);
      gtk_item_factory_create_items (item_factory, nmenu_items, menu_items, NULL);

      # preselect /Preferences/Shape/Oval over the other radios
      gtk_check_menu_item_set_active (GTK_CHECK_MENU_ITEM (gtk_item_factory_get_item (item_factory,
										      "/Preferences/Shape/Oval")),
				      TRUE);

      ## preselect /Preferences/Coffee
      gtk_check_menu_item_set_active (GTK_CHECK_MENU_ITEM (gtk_item_factory_get_item (item_factory,
										      "/Preferences/Coffee")),
				      TRUE);
      ## preselect /Preferences/Marshmallow Froot Loops and set it insensitive
      gtk_check_menu_item_set_active (GTK_CHECK_MENU_ITEM (gtk_item_factory_get_item (item_factory,
										      "/Preferences/Marshmallow Froot Loops")),
				      TRUE);
      gtk_widget_set_sensitive (GTK_WIDGET (gtk_item_factory_get_item (item_factory,
								       "/Preferences/Marshmallow Froot Loops")),
				FALSE);
       
      # Test how tooltips (ugh) work on menu items
      tooltips = gtk_tooltips_new ();
      g_object_ref (tooltips);
      gtk_object_sink (GTK_OBJECT (tooltips));
      g_object_set_data_full (window, "testgtk-tooltips",
			      tooltips, (GDestroyNotify)g_object_unref);
      
      gtk_tooltips_set_tip (tooltips, gtk_item_factory_get_item (item_factory, "/File/New"),
			    "Create a new file", NULL);
      gtk_tooltips_set_tip (tooltips, gtk_item_factory_get_item (item_factory, "/File/Open"),
			    "Open a file", NULL);
      gtk_tooltips_set_tip (tooltips, gtk_item_factory_get_item (item_factory, "/File/Save"),
			    "Safe file", NULL);
      gtk_tooltips_set_tip (tooltips, gtk_item_factory_get_item (item_factory, "/Preferences/Color"),
			    "Modify color", NULL);

      box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);
      
      $box1->pack_start ($			  gtk_item_factory_get_widget (item_factory, "<main>"),
			  FALSE, FALSE, 0);

      label = Gtk2::Label->new("Type\n<alt>\nto start");
      gtk_widget_set_size_request (label, 200, 200);
      gtk_misc_set_alignment (GTK_MISC (label), 0.5, 0.5);
      $box1->pack_start ($label, TRUE, TRUE, 0);


      separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 0);


      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);

      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);

      gtk_item_factory_delete_item (item_factory, "/Preferences/ShouldNotAppear");
      
      $window->show_all;
    }
  else
    gtk_widget_destroy (window);
}

sub accel_button_new (GtkAccelGroup *accel_group,
		  const gchar   *text,
		  const gchar   *accel)
{
  guint keyval;
  GdkModifierType modifiers;
  GtkWidget *button;
  GtkWidget *label;

  gtk_accelerator_parse (accel, &keyval, &modifiers);
  g_assert (keyval);

  button = gtk_button_new ();
  gtk_widget_add_accelerator (button, "activate", accel_group,
			      keyval, modifiers, GTK_ACCEL_VISIBLE | GTK_ACCEL_LOCKED);

  label = gtk_accel_label_new (text);
  gtk_accel_label_set_accel_widget (GTK_ACCEL_LABEL (label), button);
  $label->show;
  
  $button->add($label);

  return button;
}

sub create_key_lookup (GtkWidget *widget)
{
  static GtkWidget *window = NULL;

  if (!window)
    {
      GtkAccelGroup *accel_group = gtk_accel_group_new ();
      GtkWidget *button;
      
      window = gtk_dialog_new_with_buttons ("Key Lookup", NULL, 0,
					    GTK_STOCK_CLOSE, GTK_RESPONSE_CLOSE,
					    NULL);

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      ## We have to expand it so the accel labels will draw their labels
      gtk_window_set_default_size (window, 300, -1);
      
      gtk_window_add_accel_group (window, accel_group);
      
      button = gtk_button_new_with_mnemonic ("Button 1 (_a)");
      $window->vbox->pack_start($button, FALSE, FALSE, 0);
      button = gtk_button_new_with_mnemonic ("Button 2 (_A)");
      $window->vbox->pack_start($button, FALSE, FALSE, 0);
      button = gtk_button_new_with_mnemonic ("Button 3 (_ф)");
      gtk_box_pack_start ( (window->vbox), button, FALSE, FALSE, 0);
      button = gtk_button_new_with_mnemonic ("Button 4 (_Ф)");
      gtk_box_pack_start ( (window->vbox), button, FALSE, FALSE, 0);
      button = gtk_button_new_with_mnemonic ("Button 6 (_b)");
      gtk_box_pack_start ( (window->vbox), button, FALSE, FALSE, 0);
      button = accel_button_new (accel_group, "Button 7", "<Alt><Shift>b");
      gtk_box_pack_start ( (window->vbox), button, FALSE, FALSE, 0);
      button = accel_button_new (accel_group, "Button 8", "<Alt>d");
      gtk_box_pack_start ( (window->vbox), button, FALSE, FALSE, 0);
      button = accel_button_new (accel_group, "Button 9", "<Alt>Cyrillic_ve");
      gtk_box_pack_start ( (window->vbox), button, FALSE, FALSE, 0);
      button = gtk_button_new_with_mnemonic ("Button 10 (_1)");
      gtk_box_pack_start ( (window->vbox), button, FALSE, FALSE, 0);
      button = gtk_button_new_with_mnemonic ("Button 11 (_!)");
      gtk_box_pack_start ( (window->vbox), button, FALSE, FALSE, 0);
      
      g_object_add_weak_pointer (window, (gpointer *)&window);
      g_signal_connect (window, "response", \&gtk_object_destroy, NULL);

      $window->show_all;
    }
  else
    gtk_widget_destroy (window);
}


# create_modal_window

sub cmw_destroy_cb
{
  Gtk2->quit; 
  return FALSE;
}

sub cmw_color (GtkWidget *widget, GtkWidget *parent)
{
    GtkWidget *csd;

    csd = gtk_color_selection_dialog_new ("This is a modal color selection dialog");

    gtk_window_set_screen (csd, gtk_widget_get_screen (parent));

    gtk_color_selection_set_has_palette (GTK_COLOR_SELECTION (GTK_COLOR_SELECTION_DIALOG (csd)->colorsel),
                                         TRUE);
    
    ## Set as modal */
    gtk_window_set_modal (GTK_WINDOW(csd),TRUE);

    ## And mark it as a transient dialog */
    gtk_window_set_transient_for (csd, parent);
    
    g_signal_connect (csd, "destroy",
		      \&cmw_destroy_cb, NULL);

    g_signal_connect_swapped (GTK_COLOR_SELECTION_DIALOG (csd)->ok_button,
			     "clicked", \&gtk_widget_destroy, csd);
    g_signal_connect_swapped (GTK_COLOR_SELECTION_DIALOG (csd)->cancel_button,
			     "clicked", \&gtk_widget_destroy, csd);
    
    ## wait until destroy calls gtk_main_quit */
    $csd->show;    
    gtk_main ();
}

sub cmw_file (GtkWidget *widget, GtkWidget *parent)
{
    GtkWidget *fs;

    fs = gtk_file_selection_new("This is a modal file selection dialog");

    gtk_window_set_screen (fs, gtk_widget_get_screen (parent));

    ## Set as modal */
    gtk_window_set_modal (GTK_WINDOW(fs),TRUE);

    ## And mark it as a transient dialog */
    gtk_window_set_transient_for (fs, parent);

    g_signal_connect (fs, "destroy",
                      \&cmw_destroy_cb, NULL);

    g_signal_connect_swapped (GTK_FILE_SELECTION (fs)->ok_button,
			      "clicked", \&gtk_widget_destroy, fs);
    g_signal_connect_swapped (GTK_FILE_SELECTION (fs)->cancel_button,
			      "clicked", \&gtk_widget_destroy, fs);
    
    ## wait until destroy calls gtk_main_quit */
    $fs->show;
    
    gtk_main();
}


sub create_modal_window (GtkWidget *widget)
{
  GtkWidget *window = NULL;
  GtkWidget *box1,*box2;
  GtkWidget *frame1;
  GtkWidget *btnColor,*btnFile,*btnClose;

  ## Create modal window (Here you can use any window descendent )*/
  window = Gtk2::Window->new('toplevel');
  gtk_window_set_screen (window,
			 gtk_widget_get_screen (widget));

  gtk_window_set_title (GTK_WINDOW(window),"This window is modal");

  ## Set window as modal */
  gtk_window_set_modal (GTK_WINDOW(window),TRUE);

  ## Create widgets */
  box1 = Gtk2::VBox->new(FALSE,5);
  frame1 = Gtk2::Frame->new ("Standard dialogs in modal form");
  box2 = Gtk2::VBox->new(TRUE,5);
  btnColor = Gtk2::Button->new("Color");
  btnFile = Gtk2::Button->new("File Selection");
  btnClose = Gtk2::Button->new("Close");

  ## Init widgets */
  gtk_container_set_border_width ($box1, 3);
  gtk_container_set_border_width ($box2, 3);
    
  ## Pack widgets */
  $window->add($box1);
  $box1->pack_start ($frame1, TRUE, TRUE, 4);
  $frame1->add($box2);
  $box2->pack_start ($btnColor, FALSE, FALSE, 4);
  $box2->pack_start ($btnFile, FALSE, FALSE, 4);
  $box1->pack_start (Gtk2::HSeparator->new, FALSE, FALSE, 4);
  $box1->pack_start ($btnClose, FALSE, FALSE, 4);
   
  ## connect signals */
  g_signal_connect_swapped (btnClose, "clicked",
			    \&gtk_widget_destroy, window);

  g_signal_connect (window, "destroy",
                    \&cmw_destroy_cb, NULL);
  
  g_signal_connect (btnColor, "clicked",
                    \&cmw_color, window);
  g_signal_connect (btnFile, "clicked",
                    \&cmw_file, window);
  ## Show widgets */
  $window->show_all;
  ## wait until dialog get destroyed */
  gtk_main();
}

# * GtkMessageDialog

sub make_message_dialog (GdkScreen *screen,
		     GtkWidget **dialog,
                     GtkMessageType  type,
                     GtkButtonsType  buttons,
		     guint           default_response)
{
  if (*dialog)
    {
      gtk_widget_destroy (*dialog);

      return;
    }

  *dialog = gtk_message_dialog_new (NULL, 0, type, buttons,
                                    "This is a message dialog; it can wrap long lines. This is a long line. La la la. Look this line is wrapped. Blah blah blah blah blah blah. (Note: testgtk has a nonstandard gtkrc that changes some of the message dialog icons.)");

  gtk_window_set_screen (*dialog, screen);

  g_signal_connect_swapped (*dialog,
			    "response",
			    \&gtk_widget_destroy,
			    *dialog);
  $dialog->signal_connect("destroy" => \&gtk_widget_destroyed, $dialog);
  gtk_dialog_set_default_response ( (*dialog), default_response);
  $*dialog->show;
}

sub create_message_dialog (GtkWidget *widget)
{
  static GtkWidget *info = NULL;
  static GtkWidget *warning = NULL;
  static GtkWidget *error = NULL;
  static GtkWidget *question = NULL;
  GdkScreen *screen = gtk_widget_get_screen (widget);

  make_message_dialog (screen, &info, GTK_MESSAGE_INFO, GTK_BUTTONS_OK, GTK_RESPONSE_OK);
  make_message_dialog (screen, &warning, GTK_MESSAGE_WARNING, GTK_BUTTONS_CLOSE, GTK_RESPONSE_OK);
  make_message_dialog (screen, &error, GTK_MESSAGE_ERROR, GTK_BUTTONS_OK_CANCEL, GTK_RESPONSE_OK);
  make_message_dialog (screen, &question, GTK_MESSAGE_QUESTION, GTK_BUTTONS_YES_NO, GTK_RESPONSE_YES);
}

# * GtkScrolledWindow

static GtkWidget *sw_parent = NULL;
static GtkWidget *sw_float_parent;
static guint sw_destroyed_handler = 0;

sub scrolled_windows_delete_cb (GtkWidget *widget, GdkEventAny *event, GtkWidget *scrollwin)
{
  gtk_widget_reparent (scrollwin, sw_parent);
  g_signal_handler_disconnect (sw_parent, sw_destroyed_handler);
  sw_float_parent = NULL;
  sw_parent = NULL;
  sw_destroyed_handler = 0;
  return FALSE;
}

sub scrolled_windows_destroy_cb (GtkWidget *widget, GtkWidget *scrollwin)
{
  gtk_widget_destroy (sw_float_parent);

  sw_float_parent = NULL;
  sw_parent = NULL;
  sw_destroyed_handler = 0;
}

sub scrolled_windows_remove (GtkWidget *widget, GtkWidget *scrollwin)
{
  if (sw_parent)
    {
      gtk_widget_reparent (scrollwin, sw_parent);
      gtk_widget_destroy (sw_float_parent);

      g_signal_handler_disconnect (sw_parent, sw_destroyed_handler);
      sw_float_parent = NULL;
      sw_parent = NULL;
      sw_destroyed_handler = 0;
    }
  else
    {
      sw_parent = scrollwin->parent;
      sw_float_parent = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (sw_float_parent,
			     gtk_widget_get_screen (widget));
      
      gtk_window_set_default_size (sw_float_parent, 200, 200);
      
      gtk_widget_reparent (scrollwin, sw_float_parent);
      $sw_float_parent->show;

      sw_destroyed_handler =
	g_signal_connect (sw_parent, "destroy",
			  \&scrolled_windows_destroy_cb, scrollwin);
      g_signal_connect (sw_float_parent, "delete_event",
			\&scrolled_windows_delete_cb, scrollwin);
    }
}

sub create_scrolled_windows (GtkWidget *widget)
{
  static GtkWidget *window;
  GtkWidget *scrolled_window;
  GtkWidget *table;
  GtkWidget *button;
  char buffer[32];
  int i, j;

  if (!window)
    {
      window = Gtk2::Dialog->new;

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "dialog");
      gtk_container_set_border_width ($window, 0);


      scrolled_window = Gtk2::ScrolledWindow->new;
      gtk_container_set_border_width ($scrolled_window, 10);
      gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scrolled_window),
				      GTK_POLICY_AUTOMATIC,
				      GTK_POLICY_AUTOMATIC);
      $window->vbox->pack_start($scrolled_window, TRUE, TRUE, 0);
      $scrolled_window->show;

      table = gtk_table_new (20, 20, FALSE);
      gtk_table_set_row_spacings (GTK_TABLE (table), 10);
      gtk_table_set_col_spacings (GTK_TABLE (table), 10);
      gtk_scrolled_window_add_with_viewport (GTK_SCROLLED_WINDOW (scrolled_window), table);
      gtk_container_set_focus_hadjustment ($table,
					   gtk_scrolled_window_get_hadjustment (GTK_SCROLLED_WINDOW (scrolled_window)));
      gtk_container_set_focus_vadjustment ($table,
					   gtk_scrolled_window_get_vadjustment (GTK_SCROLLED_WINDOW (scrolled_window)));
      $table->show;

      for (i = 0; i < 20; i++)
	for (j = 0; j < 20; j++)
	  {
	    sprintf (buffer, "button (%d,%d)\n", i, j);
	    button = gtk_toggle_button_new_with_label (buffer);
	    gtk_table_attach_defaults (GTK_TABLE (table), button,
				       i, i+1, j, j+1);
	    $button->show;
	  }


      button = Gtk2::Button->new("Close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      $window->action_area->pack_start($button, TRUE, TRUE, 0);
      gtk_widget_grab_default (button);
      $button->show;

      button = Gtk2::Button->new("Reparent Out");
      g_signal_connect (button, "clicked",
			\&scrolled_windows_remove,
			scrolled_window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      $window->action_area->pack_start ($button, TRUE, TRUE, 0);
      gtk_widget_grab_default (button);
      $button->show;

      gtk_window_set_default_size (window, 300, 300);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

# GtkEntry

sub entry_toggle_frame
{
  my ($checkbutton, $entry) = @_;
  $entry->set_has_frame($checkbutton->active);
}

sub entry_toggle_sensitive
{
  my ($checkbutton, $entry) = @_;
  $entry->set_sensitive($checkbutton->active);
}

sub entry_props_clicked
{
  my ($button, $entry) = @_;
  create_prop_editor($entry, 0)->set_title("Entry Properties");
}

sub create_entry (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *box1;
  GtkWidget *box2;
  GtkWidget *hbox;
  GtkWidget *has_frame_check;
  GtkWidget *sensitive_check;
  GtkWidget *entry, *cb;
  GtkWidget *button;
  GtkWidget *separator;
  GList *cbitems = NULL;

  if (!window)
    {
      cbitems = g_list_append(cbitems, "item0");
      cbitems = g_list_append(cbitems, "item1 item1");
      cbitems = g_list_append(cbitems, "item2 item2 item2");
      cbitems = g_list_append(cbitems, "item3 item3 item3 item3");
      cbitems = g_list_append(cbitems, "item4 item4 item4 item4 item4");
      cbitems = g_list_append(cbitems, "item5 item5 item5 item5 item5 item5");
      cbitems = g_list_append(cbitems, "item6 item6 item6 item6 item6");
      cbitems = g_list_append(cbitems, "item7 item7 item7 item7");
      cbitems = g_list_append(cbitems, "item8 item8 item8");
      cbitems = g_list_append(cbitems, "item9 item9");

      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "entry");
      gtk_container_set_border_width ($window, 0);


      box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);


      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, TRUE, TRUE, 0);

      hbox = Gtk2::HBox->new(FALSE, 5);
      $box2->pack_start ($hbox, TRUE, TRUE, 0);
      
      entry = Gtk2::Entry->new;
      gtk_entry_set_text (GTK_ENTRY (entry), "hello world السلام عليكم");
      gtk_editable_select_region (GTK_EDITABLE (entry), 0, 5);
      $hbox->pack_start ($entry, TRUE, TRUE, 0);

      button = gtk_button_new_with_mnemonic ("_Props");
      $hbox->pack_start ($button, FALSE, FALSE, 0);
      g_signal_connect (button, "clicked",
			\&entry_props_clicked,
			entry);

      cb = gtk_combo_new ();
      gtk_combo_set_popdown_strings (GTK_COMBO (cb), cbitems);
      gtk_entry_set_text (GTK_ENTRY (GTK_COMBO(cb)->entry), "hello world \n\n\n foo");
      gtk_editable_select_region (GTK_EDITABLE (GTK_COMBO(cb)->entry),
				  0, -1);
      $box2->pack_start ($cb, TRUE, TRUE, 0);

      sensitive_check = gtk_check_button_new_with_label("Sensitive");
      $box2->pack_start ($sensitive_check, FALSE, TRUE, 0);
      g_signal_connect (sensitive_check, "toggled",
			\&entry_toggle_sensitive, entry);
      gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (sensitive_check), TRUE);

      has_frame_check = gtk_check_button_new_with_label("Has Frame");
      $box2->pack_start ($has_frame_check, FALSE, TRUE, 0);
      g_signal_connect (has_frame_check, "toggled",
			\&entry_toggle_frame, entry);
      gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (has_frame_check), TRUE);
      
      separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 0);

      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);

      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# * GtkSizeGroup

use constant SIZE_GROUP_INITIAL_SIZE => 50;

sub size_group_hsize_changed
{
  my ($spin_button, $button) = @_;
  $button->child->set_size_request ($spin_button->get_value_as_int, -1);
}

sub size_group_vsize_changed
{
  my ($spin_button, $button) = @_;
  $button->child->set_size_request(-1, $spin_button->get_value_as_int);
}

sub create_size_group_window (GdkScreen    *screen, GtkSizeGroup *master_size_group)
{
  GtkWidget *window;
  GtkWidget *table;
  GtkWidget *main_button;
  GtkWidget *button;
  GtkWidget *spin_button;
  GtkWidget *hbox;
  GtkSizeGroup *hgroup1;
  GtkSizeGroup *hgroup2;
  GtkSizeGroup *vgroup1;
  GtkSizeGroup *vgroup2;

  window = gtk_dialog_new_with_buttons ("GtkSizeGroup",
					NULL, 0,
					GTK_STOCK_CLOSE,
					GTK_RESPONSE_NONE,
					NULL);

  gtk_window_set_screen (window, screen);

  gtk_window_set_resizable (window, FALSE);

  g_signal_connect (window, "response",
		    \&gtk_widget_destroy,
		    NULL);

  table = gtk_table_new (2, 2, FALSE);
  $window->vbox->pack_start($table, TRUE, TRUE, 0);

  gtk_table_set_row_spacings (GTK_TABLE (table), 5);
  gtk_table_set_col_spacings (GTK_TABLE (table), 5);
  gtk_container_set_border_width ($table, 5);
  gtk_widget_set_size_request (table, 250, 250);

  hgroup1 = gtk_size_group_new (GTK_SIZE_GROUP_HORIZONTAL);
  hgroup2 = gtk_size_group_new (GTK_SIZE_GROUP_HORIZONTAL);
  vgroup1 = gtk_size_group_new (GTK_SIZE_GROUP_VERTICAL);
  vgroup2 = gtk_size_group_new (GTK_SIZE_GROUP_VERTICAL);

  main_button = Gtk2::Button->new("X");
  
  gtk_table_attach (GTK_TABLE (table), main_button,
		    0, 1,       0, 1,
		    GTK_EXPAND, GTK_EXPAND,
		    0,          0);
  gtk_size_group_add_widget (master_size_group, main_button);
  gtk_size_group_add_widget (hgroup1, main_button);
  gtk_size_group_add_widget (vgroup1, main_button);
  gtk_widget_set_size_request (GTK_BIN (main_button)->child,
			       SIZE_GROUP_INITIAL_SIZE,
			       SIZE_GROUP_INITIAL_SIZE);

  button = gtk_button_new ();
  gtk_table_attach (GTK_TABLE (table), button,
		    1, 2,       0, 1,
		    GTK_EXPAND, GTK_EXPAND,
		    0,          0);
  gtk_size_group_add_widget (vgroup1, button);
  gtk_size_group_add_widget (vgroup2, button);

  button = gtk_button_new ();
  gtk_table_attach (GTK_TABLE (table), button,
		    0, 1,       1, 2,
		    GTK_EXPAND, GTK_EXPAND,
		    0,          0);
  gtk_size_group_add_widget (hgroup1, button);
  gtk_size_group_add_widget (hgroup2, button);

  button = gtk_button_new ();
  gtk_table_attach (GTK_TABLE (table), button,
		    1, 2,       1, 2,
		    GTK_EXPAND, GTK_EXPAND,
		    0,          0);
  gtk_size_group_add_widget (hgroup2, button);
  gtk_size_group_add_widget (vgroup2, button);

  g_object_unref (hgroup1);
  g_object_unref (hgroup2);
  g_object_unref (vgroup1);
  g_object_unref (vgroup2);
  
  hbox = Gtk2::HBox->new(FALSE, 5);
  $window->vbox->pack_start($hbox, FALSE, FALSE, 0);
  
  spin_button = gtk_spin_button_new_with_range (1, 100, 1);
  gtk_spin_button_set_value (GTK_SPIN_BUTTON (spin_button), SIZE_GROUP_INITIAL_SIZE);
  $hbox->pack_start ($spin_button, TRUE, TRUE, 0);
  g_signal_connect (spin_button, "value_changed",
		    \&size_group_hsize_changed, main_button);

  spin_button = gtk_spin_button_new_with_range (1, 100, 1);
  gtk_spin_button_set_value (GTK_SPIN_BUTTON (spin_button), SIZE_GROUP_INITIAL_SIZE);
  $hbox->pack_start ($spin_button, TRUE, TRUE, 0);
  g_signal_connect (spin_button, "value_changed",
		    \&size_group_vsize_changed, main_button);

  return window;
}

sub create_size_groups (GtkWidget *widget)
{
  static GtkWidget *window1 = NULL;
  static GtkWidget *window2 = NULL;
  static GtkSizeGroup *master_size_group;

  if (!master_size_group)
    master_size_group = gtk_size_group_new (GTK_SIZE_GROUP_BOTH);

  if (!window1)
    {
      window1 = create_size_group_window (gtk_widget_get_screen (widget),
					  master_size_group);

      g_signal_connect (window1, "destroy",
			\&gtk_widget_destroyed,
			&window1);
    }

  if (!window2)
    {
      window2 = create_size_group_window (gtk_widget_get_screen (widget),
					  master_size_group);

      g_signal_connect (window2, "destroy",
			\&gtk_widget_destroyed,
			&window2);
    }

  if (GTK_WIDGET_VISIBLE (window1) && GTK_WIDGET_VISIBLE (window2))
    {
      gtk_widget_destroy (window1);
      gtk_widget_destroy (window2);
    }
  else
    {
      if (!GTK_WIDGET_VISIBLE (window1))
	$window1->show_all;
      if (!GTK_WIDGET_VISIBLE (window2))
	$window2->show_all;
    }
}

##
# * GtkSpinButton
# */

my $spinner1;

sub toggle_snap (GtkWidget *widget, GtkSpinButton *spin)
{
  gtk_spin_button_set_snap_to_ticks (spin, GTK_TOGGLE_BUTTON (widget)->active);
}

sub toggle_numeric (GtkWidget *widget, GtkSpinButton *spin)
{
  gtk_spin_button_set_numeric (spin, GTK_TOGGLE_BUTTON (widget)->active);
}

sub change_digits (GtkWidget *widget, GtkSpinButton *spin)
{
  gtk_spin_button_set_digits (GTK_SPIN_BUTTON (spinner1),
			      gtk_spin_button_get_value_as_int (spin));
}

sub get_value (GtkWidget *widget, gpointer data)
{
  gchar buf[32];
  GtkLabel *label;
  GtkSpinButton *spin;

  spin = GTK_SPIN_BUTTON (spinner1);
  label = GTK_LABEL (g_object_get_data (widget, "user_data"));
  if (GPOINTER_TO_INT (data) == 1)
    sprintf (buf, "%d", gtk_spin_button_get_value_as_int (spin));
  else
    sprintf (buf, "%0.*f", spin->digits, gtk_spin_button_get_value (spin));
  gtk_label_set_text (label, buf);
}

sub get_spin_value (GtkWidget *widget, gpointer data)
{
  gchar *buffer;
  GtkLabel *label;
  GtkSpinButton *spin;

  spin = GTK_SPIN_BUTTON (widget);
  label = GTK_LABEL (data);

  buffer = g_strdup_printf ("%0.*f", spin->digits,
			    gtk_spin_button_get_value (spin));
  gtk_label_set_text (label, buffer);

  g_free (buffer);
}

sub spin_button_time_output_func (GtkSpinButton *spin_button)
{
  static gchar buf[6];
  gdouble hours;
  gdouble minutes;

  hours = spin_button->adjustment->value / 60.0;
  minutes = (fabs(floor (hours) - hours) < 1e-5) ? 0.0 : 30;
  sprintf (buf, "%02.0f:%02.0f", floor (hours), minutes);
  if (strcmp (buf, gtk_entry_get_text (GTK_ENTRY (spin_button))))
    gtk_entry_set_text (GTK_ENTRY (spin_button), buf);
  return TRUE;
}

sub spin_button_month_input_func (GtkSpinButton *spin_button,
			      gdouble       *new_val)
{
  gint i;
  static gchar *month[12] = { "January", "February", "March", "April",
			      "May", "June", "July", "August",
			      "September", "October", "November", "December" };
  gchar *tmp1, *tmp2;
  gboolean found = FALSE;

  for (i = 1; i <= 12; i++)
    {
      tmp1 = g_ascii_strup (month[i - 1], -1);
      tmp2 = g_ascii_strup (gtk_entry_get_text (GTK_ENTRY (spin_button)), -1);
      if (strstr (tmp1, tmp2) == tmp1)
	found = TRUE;
      g_free (tmp1);
      g_free (tmp2);
      if (found)
	break;
    }
  if (!found)
    {
      *new_val = 0.0;
      return GTK_INPUT_ERROR;
    }
  *new_val = (gdouble) i;
  return TRUE;
}

sub spin_button_month_output_func (GtkSpinButton *spin_button)
{
  gint i;
  static gchar *month[12] = { "January", "February", "March", "April",
			      "May", "June", "July", "August", "September",
			      "October", "November", "December" };

  for (i = 1; i <= 12; i++)
    if (fabs (spin_button->adjustment->value - (double)i) < 1e-5)
      {
	if (strcmp (month[i-1], gtk_entry_get_text (GTK_ENTRY (spin_button))))
	  gtk_entry_set_text (GTK_ENTRY (spin_button), month[i-1]);
      }
  return TRUE;
}

sub spin_button_hex_input_func
{
  my ($spin_button, $new_val) = @_;
  gchar *err;
  gdouble res;

  my $buf = gtk_entry_get_text (GTK_ENTRY (spin_button));
  my $res = strtol(buf, &err, 16);
  *new_val = res;
  if (*err)
    return GTK_INPUT_ERROR;
  else
    return TRUE;
}

sub spin_button_hex_output_func (GtkSpinButton *spin_button)
{
  static gchar buf[7];
  gint val;

  val = (gint) spin_button->adjustment->value;
  if (fabs (val) < 1e-5)
    sprintf (buf, "0x00");
  else
    sprintf (buf, "0x%.2X", val);
  if (strcmp (buf, gtk_entry_get_text (GTK_ENTRY (spin_button))))
    gtk_entry_set_text (GTK_ENTRY (spin_button), buf);
  return TRUE;
}

sub create_spins (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *frame;
  GtkWidget *hbox;
  GtkWidget *main_vbox;
  GtkWidget *vbox;
  GtkWidget *vbox2;
  GtkWidget *spinner2;
  GtkWidget *spinner;
  GtkWidget *button;
  GtkWidget *label;
  GtkWidget *val_label;
  GtkAdjustment *adj;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));
      
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);
      
      gtk_window_set_title (window, "GtkSpinButton");
      
      main_vbox = Gtk2::VBox->new(FALSE, 5);
      gtk_container_set_border_width ($main_vbox, 10);
      $window->add($main_vbox);
      
      frame = Gtk2::Frame->new ("Not accelerated");
      $main_vbox->pack_start ($frame, TRUE, TRUE, 0);
      
      vbox = Gtk2::VBox->new(FALSE, 0);
      gtk_container_set_border_width ($vbox, 5);
      $frame->add($vbox);
      
      # Time, month, hex spinners */
      
      hbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($hbox, TRUE, TRUE, 5);
      
      vbox2 = Gtk2::VBox->new(FALSE, 0);
      $hbox->pack_start ($vbox2, TRUE, TRUE, 5);
      
      label = Gtk2::Label->new("Time :");
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);
      $vbox2->pack_start ($label, FALSE, TRUE, 0);
      
      adj = (GtkAdjustment *) gtk_adjustment_new (0, 0, 1410, 30, 60, 0);
      spinner = gtk_spin_button_new (adj, 0, 0);
      gtk_editable_set_editable (GTK_EDITABLE (spinner), FALSE);
      g_signal_connect (spinner,
			"output",
			\&spin_button_time_output_func,
			NULL);
      gtk_spin_button_set_wrap (GTK_SPIN_BUTTON (spinner), TRUE);
      gtk_widget_set_size_request (spinner, 55, -1);
      $vbox2->pack_start ($spinner, FALSE, TRUE, 0);

      vbox2 = Gtk2::VBox->new(FALSE, 0);
      $hbox->pack_start ($vbox2, TRUE, TRUE, 5);
      
      label = Gtk2::Label->new("Month :");
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);
      $vbox2->pack_start ($label, FALSE, TRUE, 0);
      
      adj = (GtkAdjustment *) gtk_adjustment_new (1.0, 1.0, 12.0, 1.0,
						  5.0, 0.0);
      spinner = gtk_spin_button_new (adj, 0, 0);
      gtk_spin_button_set_update_policy (GTK_SPIN_BUTTON (spinner),
					 GTK_UPDATE_IF_VALID);
      g_signal_connect (spinner,
			"input",
			\&spin_button_month_input_func,
			NULL);
      g_signal_connect (spinner,
			"output",
			\&spin_button_month_output_func,
			NULL);
      gtk_spin_button_set_wrap (GTK_SPIN_BUTTON (spinner), TRUE);
      gtk_widget_set_size_request (spinner, 85, -1);
      $vbox2->pack_start ($spinner, FALSE, TRUE, 0);
      
      vbox2 = Gtk2::VBox->new(FALSE, 0);
      $hbox->pack_start ($vbox2, TRUE, TRUE, 5);

      label = Gtk2::Label->new("Hex :");
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);
      $vbox2->pack_start ($label, FALSE, TRUE, 0);

      adj = (GtkAdjustment *) gtk_adjustment_new (0, 0, 255, 1, 16, 0);
      spinner = gtk_spin_button_new (adj, 0, 0);
      gtk_editable_set_editable (GTK_EDITABLE (spinner), TRUE);
      g_signal_connect (spinner,
			"input",
			\&spin_button_hex_input_func,
			NULL);
      g_signal_connect (spinner,
			"output",
			\&spin_button_hex_output_func,
			NULL);
      gtk_spin_button_set_wrap (GTK_SPIN_BUTTON (spinner), TRUE);
      gtk_widget_set_size_request (spinner, 55, -1);
      $vbox2->pack_start ($spinner, FALSE, TRUE, 0);

      frame = Gtk2::Frame->new ("Accelerated");
      $main_vbox->pack_start ($frame, TRUE, TRUE, 0);
  
      vbox = Gtk2::VBox->new(FALSE, 0);
      gtk_container_set_border_width ($vbox, 5);
      $frame->add($vbox);
      
      hbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($hbox, FALSE, TRUE, 5);
      
      vbox2 = Gtk2::VBox->new(FALSE, 0);
      $hbox->pack_start ($vbox2, FALSE, FALSE, 5);
      
      label = Gtk2::Label->new("Value :");
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);
      $vbox2->pack_start ($label, FALSE, TRUE, 0);

      adj = (GtkAdjustment *) gtk_adjustment_new (0.0, -10000.0, 10000.0,
						  0.5, 100.0, 0.0);
      spinner1 = gtk_spin_button_new (adj, 1.0, 2);
      gtk_spin_button_set_wrap (GTK_SPIN_BUTTON (spinner1), TRUE);
      $vbox2->pack_start ($spinner1, FALSE, TRUE, 0);

      vbox2 = Gtk2::VBox->new(FALSE, 0);
      $hbox->pack_start ($vbox2, FALSE, FALSE, 5);

      label = Gtk2::Label->new("Digits :");
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);
      $vbox2->pack_start ($label, FALSE, TRUE, 0);

      adj = (GtkAdjustment *) gtk_adjustment_new (2, 1, 15, 1, 1, 0);
      spinner2 = gtk_spin_button_new (adj, 0.0, 0);
      g_signal_connect (adj, "value_changed",
			\&change_digits,
			spinner2);
      $vbox2->pack_start ($spinner2, FALSE, TRUE, 0);

      hbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($hbox, FALSE, FALSE, 5);

      button = gtk_check_button_new_with_label ("Snap to 0.5-ticks");
      g_signal_connect (button, "clicked",
			\&toggle_snap,
			spinner1);
      $vbox->pack_start ($button, TRUE, TRUE, 0);
      gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (button), TRUE);

      button = gtk_check_button_new_with_label ("Numeric only input mode");
      g_signal_connect (button, "clicked",
			\&toggle_numeric,
			spinner1);
      $vbox->pack_start ($button, TRUE, TRUE, 0);
      gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (button), TRUE);

      val_label = Gtk2::Label->new("");

      hbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($hbox, FALSE, TRUE, 5);

      button = Gtk2::Button->new("Value as Int");
      g_object_set_data (button, "user_data", val_label);
      g_signal_connect (button, "clicked",
			\&get_value,
			GINT_TO_POINTER (1));
      $hbox->pack_start ($button, TRUE, TRUE, 5);

      button = Gtk2::Button->new("Value as Float");
      g_object_set_data (button, "user_data", val_label);
      g_signal_connect (button, "clicked",
			\&get_value,
			GINT_TO_POINTER (2));
      $hbox->pack_start ($button, TRUE, TRUE, 5);

      $vbox->pack_start ($val_label, TRUE, TRUE, 0);
      gtk_label_set_text (GTK_LABEL (val_label), "0");

      frame = Gtk2::Frame->new ("Using Convenience Constructor");
      $main_vbox->pack_start ($frame, TRUE, TRUE, 0);
  
      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox, 5);
      $frame->add($hbox);
      
      val_label = Gtk2::Label->new("0.0");

      spinner = gtk_spin_button_new_with_range (0.0, 10.0, 0.009);
      gtk_spin_button_set_value (GTK_SPIN_BUTTON (spinner), 0.0);
      g_signal_connect (spinner, "value_changed",
			\&get_spin_value, val_label);
      $hbox->pack_start ($spinner, TRUE, TRUE, 5);
      $hbox->pack_start ($val_label, TRUE, TRUE, 5);

      hbox = Gtk2::HBox->new(FALSE, 0);
      $main_vbox->pack_start ($hbox, FALSE, TRUE, 0);
  
      button = Gtk2::Button->new("Close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $hbox->pack_start ($button, TRUE, TRUE, 5);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}


# * Cursors

sub cursor_expose_event (GtkWidget *widget,
		     GdkEvent  *event,
		     gpointer   user_data)
{
  GtkDrawingArea *darea;
  GdkDrawable *drawable;
  GdkGC *black_gc;
  GdkGC *gray_gc;
  GdkGC *white_gc;
  guint max_width;
  guint max_height;

  g_return_val_if_fail (widget != NULL, TRUE);
  g_return_val_if_fail (GTK_IS_DRAWING_AREA (widget), TRUE);

  darea = GTK_DRAWING_AREA (widget);
  drawable = widget->window;
  white_gc = widget->style->white_gc;
  gray_gc = widget->style->bg_gc[GTK_STATE_NORMAL];
  black_gc = widget->style->black_gc;
  max_width = widget->allocation.width;
  max_height = widget->allocation.height;

  gdk_draw_rectangle (drawable, white_gc,
		      TRUE,
		      0,
		      0,
		      max_width,
		      max_height / 2);

  gdk_draw_rectangle (drawable, black_gc,
		      TRUE,
		      0,
		      max_height / 2,
		      max_width,
		      max_height / 2);

  gdk_draw_rectangle (drawable, gray_gc,
		      TRUE,
		      max_width / 3,
		      max_height / 3,
		      max_width / 3,
		      max_height / 3);

  return TRUE;
}

sub set_cursor (GtkWidget *spinner,
	    GtkWidget *widget)
{
  guint c;
  GdkCursor *cursor;
  GtkWidget *label;
  GEnumClass *class;
  GEnumValue *vals;

  c = CLAMP (gtk_spin_button_get_value_as_int (GTK_SPIN_BUTTON (spinner)), 0, 152);
  c &= 0xfe;

  label = g_object_get_data (spinner, "user_data");
  
  class = gtk_type_class (GDK_TYPE_CURSOR_TYPE);
  vals = class->values;

  while (vals && vals->value != c)
    vals++;
  if (vals)
    gtk_label_set_text (GTK_LABEL (label), vals->value_nick);
  else
    gtk_label_set_text (GTK_LABEL (label), "<unknown>");

  cursor = gdk_cursor_new_for_display (gtk_widget_get_display (widget), c);
  gdk_window_set_cursor (widget->window, cursor);
  gdk_cursor_unref (cursor);
}

sub cursor_event (GtkWidget          *widget,
	      GdkEvent           *event,
	      GtkSpinButton	 *spinner)
{
  if ((event->type == GDK_BUTTON_PRESS) &&
      ((event->button.button == 1) ||
       (event->button.button == 3)))
    {
      gtk_spin_button_spin (spinner, event->button.button == 1 ?
			    GTK_SPIN_STEP_FORWARD : GTK_SPIN_STEP_BACKWARD, 0);
      return TRUE;
    }

  return FALSE;
}

sub create_cursors (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *frame;
  GtkWidget *hbox;
  GtkWidget *main_vbox;
  GtkWidget *vbox;
  GtkWidget *darea;
  GtkWidget *spinner;
  GtkWidget *button;
  GtkWidget *label;
  GtkWidget *any;
  GtkAdjustment *adj;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window, 
			     gtk_widget_get_screen (widget));
      
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);
      
      gtk_window_set_title (window, "Cursors");
      
      main_vbox = Gtk2::VBox->new(FALSE, 5);
      gtk_container_set_border_width ($main_vbox, 0);
      $window->add($main_vbox);

      vbox =
	gtk_widget_new (gtk_vbox_get_type (),
			"GtkBox::homogeneous", FALSE,
			"GtkBox::spacing", 5,
			"GtkContainer::border_width", 10,
			"GtkWidget::parent", main_vbox,
			"GtkWidget::visible", TRUE,
			NULL);

      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox, 5);
      $vbox->pack_start ($hbox, FALSE, TRUE, 0);
      
      label = Gtk2::Label->new("Cursor Value : ");
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);
      $hbox->pack_start ($label, FALSE, TRUE, 0);
      
      adj = (GtkAdjustment *) gtk_adjustment_new (0,
						  0, 152,
						  2,
						  10, 0);
      spinner = gtk_spin_button_new (adj, 0, 0);
      $hbox->pack_start ($spinner, TRUE, TRUE, 0);

      frame =
	gtk_widget_new (gtk_frame_get_type (),
			"GtkFrame::shadow", GTK_SHADOW_ETCHED_IN,
			"GtkFrame::label_xalign", 0.5,
			"GtkFrame::label", "Cursor Area",
			"GtkContainer::border_width", 10,
			"GtkWidget::parent", vbox,
			"GtkWidget::visible", TRUE,
			NULL);

      darea = gtk_drawing_area_new ();
      gtk_widget_set_size_request (darea, 80, 80);
      $frame->add($darea);
      g_signal_connect (darea,
			"expose_event",
			\&cursor_expose_event,
			NULL);
      gtk_widget_set_events (darea, GDK_EXPOSURE_MASK | GDK_BUTTON_PRESS_MASK);
      g_signal_connect (darea,
			"button_press_event",
			\&cursor_event,
			spinner);
      $darea->show;

      g_signal_connect (spinner, "changed",
			\&set_cursor,
			darea);

      label = gtk_widget_new (GTK_TYPE_LABEL,
			      "visible", TRUE,
			      "label", "XXX",
			      "parent", vbox,
			      NULL);
      gtk_container_child_set ($vbox, label,
			       "expand", FALSE,
			       NULL);
      g_object_set_data (spinner, "user_data", label);

      any =
	gtk_widget_new (gtk_hseparator_get_type (),
			"GtkWidget::visible", TRUE,
			NULL);
      $main_vbox->pack_start ($any, FALSE, TRUE, 0);
  
      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox, 10);
      $main_vbox->pack_start ($hbox, FALSE, TRUE, 0);

      button = Gtk2::Button->new("Close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $hbox->pack_start ($button, TRUE, TRUE, 5);

      $window->show_all;

      set_cursor (spinner, darea);
    }
  else
    gtk_widget_destroy (window);
}

# GtkList

sub list_add (GtkWidget *widget,	  GtkWidget *list)
{
  static int i = 1;
  gchar buffer[64];
  GtkWidget *list_item;
  GtkContainer *container;

  container = $list;

  sprintf (buffer, "added item %d", i++);
  list_item = gtk_list_item_new_with_label (buffer);
  $list_item->show;

  container->add($list_item);
}

sub list_remove (GtkWidget *widget, GtkList   *list)
{
  GList *clear_list = NULL;
  GList *sel_row = NULL;
  GList *work = NULL;

  if (list->selection_mode == GTK_SELECTION_EXTENDED)
    {
      GtkWidget *item;

      item = $list->focus_child;
      if (!item && list->selection)
	item = list->selection->data;

      if (item)
	{
	  work = g_list_find (list->children, item);
	  for (sel_row = work; sel_row; sel_row = sel_row->next)
	    if (GTK_WIDGET (sel_row->data)->state != GTK_STATE_SELECTED)
	      break;

	  if (!sel_row)
	    {
	      for (sel_row = work; sel_row; sel_row = sel_row->prev)
		if (GTK_WIDGET (sel_row->data)->state != GTK_STATE_SELECTED)
		  break;
	    }
	}
    }

  for (work = list->selection; work; work = work->next)
    clear_list = g_list_prepend (clear_list, work->data);

  clear_list = g_list_reverse (clear_list);
  gtk_list_remove_items (GTK_LIST (list), clear_list);
  g_list_free (clear_list);

  if (list->selection_mode == GTK_SELECTION_EXTENDED && sel_row)
    gtk_list_select_child (list, GTK_WIDGET(sel_row->data));
}

sub list_clear (GtkWidget *widget,
	    GtkWidget *list)
{
  gtk_list_clear_items (GTK_LIST (list), 0, -1);
}

static gchar *selection_mode_items[] =
{
  "Single",
  "Browse",
  "Multiple",
};

static const GtkSelectionMode selection_modes[] = {
  GTK_SELECTION_SINGLE,
  GTK_SELECTION_BROWSE,
  GTK_SELECTION_MULTIPLE
};

static GtkWidget *list_omenu;

sub list_toggle_sel_mode (GtkWidget *widget, gpointer data)
{
  GtkList *list;
  gint i;

  list = GTK_LIST (data);

  if (!GTK_WIDGET_MAPPED (widget))
    return;

  i = gtk_option_menu_get_history (GTK_OPTION_MENU (widget));

  gtk_list_set_selection_mode (list, selection_modes[i]);
}

sub create_list (GtkWidget *widget)
{
  static GtkWidget *window = NULL;

  if (!window)
    {
      GtkWidget *cbox;
      GtkWidget *vbox;
      GtkWidget *hbox;
      GtkWidget *label;
      GtkWidget *scrolled_win;
      GtkWidget *list;
      GtkWidget *button;
      GtkWidget *separator;
      FILE *infile;

      window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "list");
      gtk_container_set_border_width ($window, 0);

      vbox = Gtk2::VBox->new(FALSE, 0);
      $window->add($vbox);

      scrolled_win = Gtk2::ScrolledWindow->new;
      gtk_container_set_border_width ($scrolled_win, 5);
      gtk_widget_set_size_request (scrolled_win, -1, 300);
      $vbox->pack_start ($scrolled_win, TRUE, TRUE, 0);
      gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scrolled_win),
				      GTK_POLICY_AUTOMATIC,
				      GTK_POLICY_AUTOMATIC);

      list = gtk_list_new ();
      gtk_list_set_selection_mode (GTK_LIST (list), GTK_SELECTION_SINGLE);
      gtk_scrolled_window_add_with_viewport
	(GTK_SCROLLED_WINDOW (scrolled_win), list);
      gtk_container_set_focus_vadjustment
	($list,
	 gtk_scrolled_window_get_vadjustment
	 (GTK_SCROLLED_WINDOW (scrolled_win)));
      gtk_container_set_focus_hadjustment
	($list,
	 gtk_scrolled_window_get_hadjustment
	 (GTK_SCROLLED_WINDOW (scrolled_win)));

      if ((infile = fopen("../gtk/gtkenums.h", "r")))
	{
	  char buffer[256];
	  char *pos;
	  GtkWidget *item;

	  while (fgets (buffer, 256, infile))
	    {
	      if ((pos = strchr (buffer, '\n')))
		*pos = 0;
	      item = gtk_list_item_new_with_label (buffer);
	      $list->add($item);
	    }
	  
	  fclose (infile);
	}


      hbox = Gtk2::HBox->new(TRUE, 5);
      gtk_container_set_border_width ($hbox, 5);
      $vbox->pack_start ($hbox, FALSE, TRUE, 0);

      button = Gtk2::Button->new("Insert Row");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&list_add,
			list);

      button = Gtk2::Button->new("Clear List");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&list_clear,
			list);

      button = Gtk2::Button->new("Remove Selection");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&list_remove,
			list);

      cbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($cbox, FALSE, TRUE, 0);

      hbox = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($hbox, 5);
      $cbox->pack_start ($hbox, TRUE, FALSE, 0);

      label = Gtk2::Label->new("Selection Mode :");
      $hbox->pack_start ($label, FALSE, TRUE, 0);

      list_omenu = build_option_menu (selection_mode_items, 3, 3, 
				      list_toggle_sel_mode,
				      list);
      $hbox->pack_start ($list_omenu, FALSE, TRUE, 0);

      separator = Gtk2::HSeparator->new;
      $vbox->pack_start ($separator, FALSE, TRUE, 0);

      cbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($cbox, FALSE, TRUE, 0);

      button = Gtk2::Button->new("close");
      gtk_container_set_border_width ($button, 10);
      $cbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);

      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# GtkCList

my $book_open_xpm = [
"16 16 4 1",
"       c None s None",
".      c black",
"X      c #808080",
"o      c white",
"                ",
"  ..            ",
" .Xo.    ...    ",
" .Xoo. ..oo.    ",
" .Xooo.Xooo...  ",
" .Xooo.oooo.X.  ",
" .Xooo.Xooo.X.  ",
" .Xooo.oooo.X.  ",
" .Xooo.Xooo.X.  ",
" .Xooo.oooo.X.  ",
"  .Xoo.Xoo..X.  ",
"   .Xo.o..ooX.  ",
"    .X..XXXXX.  ",
"    ..X.......  ",
"     ..         ",
"                " ];

my $book_closed_xpm = [
"16 16 6 1",
"       c None s None",
".      c black",
"X      c red",
"o      c yellow",
"O      c #808080",
"#      c white",
"                ",
"       ..       ",
"     ..XX.      ",
"   ..XXXXX.     ",
" ..XXXXXXXX.    ",
".ooXXXXXXXXX.   ",
"..ooXXXXXXXXX.  ",
".X.ooXXXXXXXXX. ",
".XX.ooXXXXXX..  ",
" .XX.ooXXX..#O  ",
"  .XX.oo..##OO. ",
"   .XX..##OO..  ",
"    .X.#OO..    ",
"     ..O..      ",
"      ..        ",
"                "];

my $mini_page_xpm = [
"16 16 4 1",
"       c None s None",
".      c black",
"X      c white",
"o      c #808080",
"                ",
"   .......      ",
"   .XXXXX..     ",
"   .XoooX.X.    ",
"   .XXXXX....   ",
"   .XooooXoo.o  ",
"   .XXXXXXXX.o  ",
"   .XooooooX.o  ",
"   .XXXXXXXX.o  ",
"   .XooooooX.o  ",
"   .XXXXXXXX.o  ",
"   .XooooooX.o  ",
"   .XXXXXXXX.o  ",
"   ..........o  ",
"    oooooooooo  ",
"                "];

my $gtk_mini_xpm = [
"15 20 17 1",
"       c None",
".      c #14121F",
"+      c #278828",
"@      c #9B3334",
"#      c #284C72",
"$      c #24692A",
"%      c #69282E",
"&      c #37C539",
"*      c #1D2F4D",
"=      c #6D7076",
"-      c #7D8482",
";      c #E24A49",
">      c #515357",
",      c #9B9C9B",
"'      c #2FA232",
")      c #3CE23D",
"!      c #3B6CCB",
"               ",
"      ***>     ",
"    >.*!!!*    ",
"   ***....#*=  ",
"  *!*.!!!**!!# ",
" .!!#*!#*!!!!# ",
" @%#!.##.*!!$& ",
" @;%*!*.#!#')) ",
" @;;@%!!*$&)'' ",
" @%.%@%$'&)$+' ",
" @;...@$'*'*)+ ",
" @;%..@$+*.')$ ",
" @;%%;;$+..$)# ",
" @;%%;@$$$'.$# ",
" %;@@;;$$+))&* ",
"  %;;;@+$&)&*  ",
"   %;;@'))+>   ",
"    %;@'&#     ",
"     >%$$      ",
"      >=       "];

use constant TESTGTK_CLIST_COLUMNS => 12;

static gint clist_rows = 0;
static GtkWidget *clist_omenu;

sub add1000_clist (GtkWidget *widget, gpointer data)
{
  gint i, row;
  char text[TESTGTK_CLIST_COLUMNS][50];
  char *texts[TESTGTK_CLIST_COLUMNS];
  GdkBitmap *mask;
  GdkPixmap *pixmap;
  GtkCList  *clist;

  clist = GTK_CLIST (data);

  pixmap = gdk_pixmap_create_from_xpm_d (clist->clist_window,
					 &mask, 
					 &GTK_WIDGET (data)->style->white,
					 gtk_mini_xpm);

  for (i = 0; i < TESTGTK_CLIST_COLUMNS; i++)
    {
      texts[i] = text[i];
      sprintf (text[i], "Column %d", i);
    }
  
  texts[3] = NULL;
  sprintf (text[1], "Right");
  sprintf (text[2], "Center");
  
  gtk_clist_freeze (GTK_CLIST (data));
  for (i = 0; i < 1000; i++)
    {
      sprintf (text[0], "CListRow %d", rand() % 10000);
      row = gtk_clist_append (clist, texts);
      gtk_clist_set_pixtext (clist, row, 3, "gtk+", 5, pixmap, mask);
    }

  gtk_clist_thaw (GTK_CLIST (data));

  g_object_unref (pixmap);
  g_object_unref (mask);
}

sub add10000_clist (GtkWidget *widget, gpointer data)
{
  gint i;
  char text[TESTGTK_CLIST_COLUMNS][50];
  char *texts[TESTGTK_CLIST_COLUMNS];

  for (i = 0; i < TESTGTK_CLIST_COLUMNS; i++)
    {
      texts[i] = text[i];
      sprintf (text[i], "Column %d", i);
    }
  
  sprintf (text[1], "Right");
  sprintf (text[2], "Center");
  
  gtk_clist_freeze (GTK_CLIST (data));
  for (i = 0; i < 10000; i++)
    {
      sprintf (text[0], "CListRow %d", rand() % 10000);
      gtk_clist_append (GTK_CLIST (data), texts);
    }
  gtk_clist_thaw (GTK_CLIST (data));
}

sub clear_clist (GtkWidget *widget, gpointer data)
{
  gtk_clist_clear (GTK_CLIST (data));
  clist_rows = 0;
}

sub clist_remove_selection (GtkWidget *widget, GtkCList *clist)
{
  gtk_clist_freeze (clist);

  while (clist->selection)
    {
      gint row;

      clist_rows--;
      row = GPOINTER_TO_INT (clist->selection->data);

      gtk_clist_remove (clist, row);

      if (clist->selection_mode == GTK_SELECTION_BROWSE)
	break;
    }

  if (clist->selection_mode == GTK_SELECTION_EXTENDED && !clist->selection &&
      clist->focus_row >= 0)
    gtk_clist_select_row (clist, clist->focus_row, -1);

  gtk_clist_thaw (clist);
}

sub toggle_title_buttons (GtkWidget *widget, GtkCList *clist)
{
  if (GTK_TOGGLE_BUTTON (widget)->active)
    gtk_clist_column_titles_show (clist);
  else
    gtk_clist_column_titles_hide (clist);
}

sub toggle_reorderable (GtkWidget *widget, GtkCList *clist)
{
  gtk_clist_set_reorderable (clist, GTK_TOGGLE_BUTTON (widget)->active);
}

sub insert_row_clist (GtkWidget *widget, gpointer data)
{
  static char *text[] =
  {
    "This", "is an", "inserted", "row.",
    "This", "is an", "inserted", "row.",
    "This", "is an", "inserted", "row."
  };

  static GtkStyle *style1 = NULL;
  static GtkStyle *style2 = NULL;
  static GtkStyle *style3 = NULL;
  gint row;
  
  if (GTK_CLIST (data)->focus_row >= 0)
    row = gtk_clist_insert (GTK_CLIST (data), GTK_CLIST (data)->focus_row,
			    text);
  else
    row = gtk_clist_prepend (GTK_CLIST (data), text);

  if (!style1)
    {
      GdkColor col1;
      GdkColor col2;

      col1.red   = 0;
      col1.green = 56000;
      col1.blue  = 0;
      col2.red   = 32000;
      col2.green = 0;
      col2.blue  = 56000;

      style1 = gtk_style_copy (GTK_WIDGET (data)->style);
      style1->base[GTK_STATE_NORMAL] = col1;
      style1->base[GTK_STATE_SELECTED] = col2;

      style2 = gtk_style_copy (GTK_WIDGET (data)->style);
      style2->fg[GTK_STATE_NORMAL] = col1;
      style2->fg[GTK_STATE_SELECTED] = col2;

      style3 = gtk_style_copy (GTK_WIDGET (data)->style);
      style3->fg[GTK_STATE_NORMAL] = col1;
      style3->base[GTK_STATE_NORMAL] = col2;
      pango_font_description_free (style3->font_desc);
      style3->font_desc = pango_font_description_from_string ("courier 12");
    }

  gtk_clist_set_cell_style (GTK_CLIST (data), row, 3, style1);
  gtk_clist_set_cell_style (GTK_CLIST (data), row, 4, style2);
  gtk_clist_set_cell_style (GTK_CLIST (data), row, 0, style3);

  clist_rows++;
}

sub clist_warning_test (GtkWidget *button, GtkWidget *clist)
{
  GtkWidget *child;
  static gboolean add_remove = FALSE;

  add_remove = !add_remove;

  child = Gtk2::Label->new("Test");
  g_object_ref (child);
  gtk_object_sink (GTK_OBJECT (child));

  if (add_remove)
    $clist->add($child);
  else
    {
      child->parent = clist;
      gtk_container_remove ($clist, child);
      child->parent = NULL;
    }

  gtk_widget_destroy (child);
  gtk_widget_unref (child);
}

sub undo_selection (GtkWidget *button, GtkCList *clist)
{
  gtk_clist_undo_selection (clist);
}

sub clist_toggle_sel_mode (GtkWidget *widget, gpointer data)
{
  GtkCList *clist;
  gint i;

  clist = GTK_CLIST (data);

  if (!GTK_WIDGET_MAPPED (widget))
    return;

  i = gtk_option_menu_get_history (GTK_OPTION_MENU (widget));

  gtk_clist_set_selection_mode (clist, selection_modes[i]);
}

sub clist_click_column (GtkCList *clist, gint column, gpointer data)
{
  if (column == 4)
    gtk_clist_set_column_visibility (clist, column, FALSE);
  else if (column == clist->sort_column)
    {
      if (clist->sort_type == GTK_SORT_ASCENDING)
	clist->sort_type = GTK_SORT_DESCENDING;
      else
	clist->sort_type = GTK_SORT_ASCENDING;
    }
  else
    gtk_clist_set_sort_column (clist, column);

  gtk_clist_sort (clist);
}

sub create_clist (GtkWidget *widget)
{
  gint i;
  static GtkWidget *window = NULL;

  static char *titles[] =
  {
    "auto resize", "not resizeable", "max width 100", "min width 50",
    "hide column", "Title 5", "Title 6", "Title 7",
    "Title 8",  "Title 9",  "Title 10", "Title 11"
  };

  char text[TESTGTK_CLIST_COLUMNS][50];
  char *texts[TESTGTK_CLIST_COLUMNS];

  GtkWidget *vbox;
  GtkWidget *hbox;
  GtkWidget *clist;
  GtkWidget *button;
  GtkWidget *separator;
  GtkWidget *scrolled_win;
  GtkWidget *check;

  GtkWidget *undo_button;
  GtkWidget *label;

  GtkStyle *style;
  GdkColor col1;
  GdkColor col2;

  if (!window)
    {
      clist_rows = 0;
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window, 
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed, &window);

      gtk_window_set_title (window, "clist");
      gtk_container_set_border_width ($window, 0);

      vbox = Gtk2::VBox->new(FALSE, 0);
      $window->add($vbox);

      scrolled_win = Gtk2::ScrolledWindow->new;
      gtk_container_set_border_width ($scrolled_win, 5);
      gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scrolled_win),
				      GTK_POLICY_AUTOMATIC, 
				      GTK_POLICY_AUTOMATIC);

      ## create GtkCList here so we have a pointer to throw at the 
      # * button callbacks -- more is done with it later */
      clist = gtk_clist_new_with_titles (TESTGTK_CLIST_COLUMNS, titles);
      $scrolled_win->add($clist);
      g_signal_connect (clist, "click_column",
			\&clist_click_column, NULL);

      ## control buttons */
      hbox = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($hbox, 5);
      $vbox->pack_start ($hbox, FALSE, FALSE, 0);

      button = Gtk2::Button->new("Insert Row");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&insert_row_clist, clist);

      button = Gtk2::Button->new("Add 1,000 Rows With Pixmaps");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&add1000_clist, clist);

      button = Gtk2::Button->new("Add 10,000 Rows");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&add10000_clist, clist);

      ## second layer of buttons */
      hbox = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($hbox, 5);
      $vbox->pack_start ($hbox, FALSE, FALSE, 0);

      button = Gtk2::Button->new("Clear List");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&clear_clist, clist);

      button = Gtk2::Button->new("Remove Selection");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&clist_remove_selection, clist);

      undo_button = Gtk2::Button->new("Undo Selection");
      $hbox->pack_start ($undo_button, TRUE, TRUE, 0);
      g_signal_connect (undo_button, "clicked",
			\&undo_selection, clist);

      button = Gtk2::Button->new("Warning Test");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&clist_warning_test, clist);

      ## third layer of buttons */
      hbox = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($hbox, 5);
      $vbox->pack_start ($hbox, FALSE, FALSE, 0);

      check = gtk_check_button_new_with_label ("Show Title Buttons");
      $hbox->pack_start ($check, FALSE, TRUE, 0);
      g_signal_connect (check, "clicked",
			\&toggle_title_buttons, clist);
      gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (check), TRUE);

      check = gtk_check_button_new_with_label ("Reorderable");
      $hbox->pack_start ($check, FALSE, TRUE, 0);
      g_signal_connect (check, "clicked",
			\&toggle_reorderable, clist);
      gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (check), TRUE);

      label = Gtk2::Label->new("Selection Mode :");
      $hbox->pack_start ($label, FALSE, TRUE, 0);

      clist_omenu = build_option_menu (selection_mode_items, 3, 3, 
				       clist_toggle_sel_mode,
				       clist);
      $hbox->pack_start ($clist_omenu, FALSE, TRUE, 0);

      ## 
      # * the rest of the clist configuration
      # */

      $vbox->pack_start ($scrolled_win, TRUE, TRUE, 0);
      gtk_clist_set_row_height (GTK_CLIST (clist), 18);
      gtk_widget_set_size_request (clist, -1, 300);

      for (i = 1; i < TESTGTK_CLIST_COLUMNS; i++)
	gtk_clist_set_column_width (GTK_CLIST (clist), i, 80);

      gtk_clist_set_column_auto_resize (GTK_CLIST (clist), 0, TRUE);
      gtk_clist_set_column_resizeable (GTK_CLIST (clist), 1, FALSE);
      gtk_clist_set_column_max_width (GTK_CLIST (clist), 2, 100);
      gtk_clist_set_column_min_width (GTK_CLIST (clist), 3, 50);
      gtk_clist_set_selection_mode (GTK_CLIST (clist), GTK_SELECTION_EXTENDED);
      gtk_clist_set_column_justification (GTK_CLIST (clist), 1,
					  GTK_JUSTIFY_RIGHT);
      gtk_clist_set_column_justification (GTK_CLIST (clist), 2,
					  GTK_JUSTIFY_CENTER);
      
      for (i = 0; i < TESTGTK_CLIST_COLUMNS; i++)
	{
	  texts[i] = text[i];
	  sprintf (text[i], "Column %d", i);
	}

      sprintf (text[1], "Right");
      sprintf (text[2], "Center");

      col1.red   = 56000;
      col1.green = 0;
      col1.blue  = 0;
      col2.red   = 0;
      col2.green = 56000;
      col2.blue  = 32000;

      style = gtk_style_new ();
      style->fg[GTK_STATE_NORMAL] = col1;
      style->base[GTK_STATE_NORMAL] = col2;

      pango_font_description_set_size (style->font_desc, 14 * PANGO_SCALE);
      pango_font_description_set_weight (style->font_desc, PANGO_WEIGHT_BOLD);

      for (i = 0; i < 10; i++)
	{
	  sprintf (text[0], "CListRow %d", clist_rows++);
	  gtk_clist_append (GTK_CLIST (clist), texts);

	  switch (i % 4)
	    {
	    case 2:
	      gtk_clist_set_row_style (GTK_CLIST (clist), i, style);
	      break;
	    default:
	      gtk_clist_set_cell_style (GTK_CLIST (clist), i, i % 4, style);
	      break;
	    }
	}

      gtk_style_unref (style);
      
      separator = Gtk2::HSeparator->new;
      $vbox->pack_start ($separator, FALSE, TRUE, 0);

      hbox = Gtk2::HBox->new(FALSE, 0);
      $vbox->pack_start ($hbox, FALSE, TRUE, 0);

      button = Gtk2::Button->new("close");
      gtk_container_set_border_width ($button, 10);
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);

      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    {
      clist_rows = 0;
      gtk_widget_destroy (window);
    }
}

# * GtkCTree

typedef struct 
{
  GdkPixmap *pixmap1;
  GdkPixmap *pixmap2;
  GdkPixmap *pixmap3;
  GdkBitmap *mask1;
  GdkBitmap *mask2;
  GdkBitmap *mask3;
} CTreePixmaps;

static gint books = 0;
static gint pages = 0;

static GtkWidget *book_label;
static GtkWidget *page_label;
static GtkWidget *sel_label;
static GtkWidget *vis_label;
static GtkWidget *omenu1;
static GtkWidget *omenu2;
static GtkWidget *omenu3;
static GtkWidget *omenu4;
static GtkWidget *spin1;
static GtkWidget *spin2;
static GtkWidget *spin3;
static gint line_style;


sub get_ctree_pixmaps (GtkCTree *ctree)
{
  GdkScreen *screen = gtk_widget_get_screen (GTK_WIDGET (ctree));
  CTreePixmaps *pixmaps = g_object_get_data (screen, "ctree-pixmaps");

  if (!pixmaps)
    {
      GdkColormap *colormap = gdk_screen_get_rgb_colormap (screen);
      pixmaps = g_new (CTreePixmaps, 1);
      
      pixmaps->pixmap1 = gdk_pixmap_colormap_create_from_xpm_d (NULL, colormap,
								&pixmaps->mask1, 
								NULL, book_closed_xpm);
      pixmaps->pixmap2 = gdk_pixmap_colormap_create_from_xpm_d (NULL, colormap,
								&pixmaps->mask2, 
								NULL, book_open_xpm);
      pixmaps->pixmap3 = gdk_pixmap_colormap_create_from_xpm_d (NULL, colormap,
								&pixmaps->mask3,
								NULL, mini_page_xpm);
      
      g_object_set_data (screen, "ctree-pixmaps", pixmaps);
    }

  return pixmaps;
}

sub after_press (GtkCTree *ctree, gpointer data)
{
  char buf[80];

  sprintf (buf, "%d", g_list_length (GTK_CLIST (ctree)->selection));
  gtk_label_set_text (GTK_LABEL (sel_label), buf);

  sprintf (buf, "%d", g_list_length (GTK_CLIST (ctree)->row_list));
  gtk_label_set_text (GTK_LABEL (vis_label), buf);

  sprintf (buf, "%d", books);
  gtk_label_set_text (GTK_LABEL (book_label), buf);

  sprintf (buf, "%d", pages);
  gtk_label_set_text (GTK_LABEL (page_label), buf);
}

sub after_move (GtkCTree *ctree, GtkCTreeNode *child, GtkCTreeNode *parent, 
		 GtkCTreeNode *sibling, gpointer data)
{
  char *source;
  char *target1;
  char *target2;

  gtk_ctree_get_node_info (ctree, child, &source, 
			   NULL, NULL, NULL, NULL, NULL, NULL, NULL);
  if (parent)
    gtk_ctree_get_node_info (ctree, parent, &target1, 
			     NULL, NULL, NULL, NULL, NULL, NULL, NULL);
  if (sibling)
    gtk_ctree_get_node_info (ctree, sibling, &target2, 
			     NULL, NULL, NULL, NULL, NULL, NULL, NULL);

  g_print ("Moving \"%s\" to \"%s\" with sibling \"%s\".\n", source,
	   (parent) ? target1 : "nil", (sibling) ? target2 : "nil");
}

sub count_items (GtkCTree *ctree, GtkCTreeNode *list)
{
  if (GTK_CTREE_ROW (list)->is_leaf)
    pages--;
  else
    books--;
}

sub expand_all (GtkWidget *widget, GtkCTree *ctree)
{
  gtk_ctree_expand_recursive (ctree, NULL);
  after_press (ctree, NULL);
}

sub collapse_all (GtkWidget *widget, GtkCTree *ctree)
{
  gtk_ctree_collapse_recursive (ctree, NULL);
  after_press (ctree, NULL);
}

sub select_all (GtkWidget *widget, GtkCTree *ctree)
{
  gtk_ctree_select_recursive (ctree, NULL);
  after_press (ctree, NULL);
}

sub change_style (GtkWidget *widget, GtkCTree *ctree)
{
  static GtkStyle *style1 = NULL;
  static GtkStyle *style2 = NULL;

  GtkCTreeNode *node;
  GdkColor col1;
  GdkColor col2;

  if (GTK_CLIST (ctree)->focus_row >= 0)
    node = GTK_CTREE_NODE
      (g_list_nth (GTK_CLIST (ctree)->row_list,GTK_CLIST (ctree)->focus_row));
  else
    node = GTK_CTREE_NODE (GTK_CLIST (ctree)->row_list);

  if (!node)
    return;

  if (!style1)
    {
      col1.red   = 0;
      col1.green = 56000;
      col1.blue  = 0;
      col2.red   = 32000;
      col2.green = 0;
      col2.blue  = 56000;

      style1 = gtk_style_new ();
      style1->base[GTK_STATE_NORMAL] = col1;
      style1->fg[GTK_STATE_SELECTED] = col2;

      style2 = gtk_style_new ();
      style2->base[GTK_STATE_SELECTED] = col2;
      style2->fg[GTK_STATE_NORMAL] = col1;
      style2->base[GTK_STATE_NORMAL] = col2;
      pango_font_description_free (style2->font_desc);
      style2->font_desc = pango_font_description_from_string ("courier 30");
    }

  gtk_ctree_node_set_cell_style (ctree, node, 1, style1);
  gtk_ctree_node_set_cell_style (ctree, node, 0, style2);

  if (GTK_CTREE_ROW (node)->children)
    gtk_ctree_node_set_row_style (ctree, GTK_CTREE_ROW (node)->children,
				  style2);
}

sub unselect_all (GtkWidget *widget, GtkCTree *ctree)
{
  gtk_ctree_unselect_recursive (ctree, NULL);
  after_press (ctree, NULL);
}

sub remove_selection (GtkWidget *widget, GtkCTree *ctree)
{
  GtkCList *clist;
  GtkCTreeNode *node;

  clist = GTK_CLIST (ctree);

  gtk_clist_freeze (clist);

  while (clist->selection)
    {
      node = clist->selection->data;

      if (GTK_CTREE_ROW (node)->is_leaf)
	pages--;
      else
	gtk_ctree_post_recursive (ctree, node,
				  (GtkCTreeFunc) count_items, NULL);

      gtk_ctree_remove_node (ctree, node);

      if (clist->selection_mode == GTK_SELECTION_BROWSE)
	break;
    }

  if (clist->selection_mode == GTK_SELECTION_EXTENDED && !clist->selection &&
      clist->focus_row >= 0)
    {
      node = gtk_ctree_node_nth (ctree, clist->focus_row);

      if (node)
	gtk_ctree_select (ctree, node);
    }
    
  gtk_clist_thaw (clist);
  after_press (ctree, NULL);
}

struct _ExportStruct {
  gchar *tree;
  gchar *info;
  gboolean is_leaf;
};

typedef struct _ExportStruct ExportStruct;

sub gnode2ctree (GtkCTree   *ctree,
	     guint       depth,
	     GNode        *gnode,
	     GtkCTreeNode *cnode,
	     gpointer    data)
{
  ExportStruct *es;
  GdkPixmap *pixmap_closed;
  GdkBitmap *mask_closed;
  GdkPixmap *pixmap_opened;
  GdkBitmap *mask_opened;
  CTreePixmaps *pixmaps;

  if (!cnode || !gnode || (!(es = gnode->data)))
    return FALSE;

  pixmaps = get_ctree_pixmaps (ctree);

  if (es->is_leaf)
    {
      pixmap_closed = pixmaps->pixmap3;
      mask_closed = pixmaps->mask3;
      pixmap_opened = NULL;
      mask_opened = NULL;
    }
  else
    {
      pixmap_closed = pixmaps->pixmap1;
      mask_closed = pixmaps->mask1;
      pixmap_opened = pixmaps->pixmap2;
      mask_opened = pixmaps->mask2;
    }

  gtk_ctree_set_node_info (ctree, cnode, es->tree, 2, pixmap_closed,
			   mask_closed, pixmap_opened, mask_opened,
			   es->is_leaf, (depth < 3));
  gtk_ctree_node_set_text (ctree, cnode, 1, es->info);
  g_free (es);
  gnode->data = NULL;

  return TRUE;
}

sub ctree2gnode (GtkCTree   *ctree,
	     guint       depth,
	     GNode        *gnode,
	     GtkCTreeNode *cnode,
	     gpointer    data)
{
  ExportStruct *es;

  if (!cnode || !gnode)
    return FALSE;
  
  es = g_new (ExportStruct, 1);
  gnode->data = es;
  es->is_leaf = GTK_CTREE_ROW (cnode)->is_leaf;
  es->tree = GTK_CELL_PIXTEXT (GTK_CTREE_ROW (cnode)->row.cell[0])->text;
  es->info = GTK_CELL_PIXTEXT (GTK_CTREE_ROW (cnode)->row.cell[1])->text;
  return TRUE;
}

sub export_ctree (GtkWidget *widget, GtkCTree *ctree)
{
  char *title[] = { "Tree" , "Info" };
  static GtkWidget *export_window = NULL;
  static GtkCTree *export_ctree;
  GtkWidget *vbox;
  GtkWidget *scrolled_win;
  GtkWidget *button;
  GtkWidget *sep;
  GNode *gnode;
  GtkCTreeNode *node;

  if (!export_window)
    {
      export_window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (export_window,
			     gtk_widget_get_screen (widget));
  
      g_signal_connect (export_window, "destroy",
			\&gtk_widget_destroyed,
			&export_window);

      gtk_window_set_title (export_window, "exported ctree");
      gtk_container_set_border_width ($export_window, 5);

      vbox = Gtk2::VBox->new(FALSE, 0);
      $export_window->add($vbox);
      
      button = Gtk2::Button->new("Close");
      gtk_box_pack_end (vbox, button, FALSE, TRUE, 0);

      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				export_window);

      sep = Gtk2::HSeparator->new;
      gtk_box_pack_end (vbox, sep, FALSE, TRUE, 10);

      export_ctree = GTK_CTREE (gtk_ctree_new_with_titles (2, 0, title));
      gtk_ctree_set_line_style (export_ctree, GTK_CTREE_LINES_DOTTED);

      scrolled_win = Gtk2::ScrolledWindow->new;
      $scrolled_win->add($			 GTK_WIDGET (export_ctree));
      gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scrolled_win),
				      GTK_POLICY_AUTOMATIC,
				      GTK_POLICY_AUTOMATIC);
      $vbox->pack_start ($scrolled_win, TRUE, TRUE, 0);
      gtk_clist_set_selection_mode (GTK_CLIST (export_ctree),
				    GTK_SELECTION_EXTENDED);
      gtk_clist_set_column_width (GTK_CLIST (export_ctree), 0, 200);
      gtk_clist_set_column_width (GTK_CLIST (export_ctree), 1, 200);
      gtk_widget_set_size_request (GTK_WIDGET (export_ctree), 300, 200);
    }

  if (!GTK_WIDGET_VISIBLE (export_window))
    $export_window->show_all;
      
  gtk_clist_clear (GTK_CLIST (export_ctree));

  node = GTK_CTREE_NODE (g_list_nth (GTK_CLIST (ctree)->row_list,
				     GTK_CLIST (ctree)->focus_row));
  if (!node)
    return;

  gnode = gtk_ctree_export_to_gnode (ctree, NULL, NULL, node,
				     ctree2gnode, NULL);
  if (gnode)
    {
      gtk_ctree_insert_gnode (export_ctree, NULL, NULL, gnode,
			      gnode2ctree, NULL);
      g_node_destroy (gnode);
    }
}

sub change_indent (GtkWidget *widget, GtkCTree *ctree)
{
  gtk_ctree_set_indent (ctree, GTK_ADJUSTMENT (widget)->value);
}

sub change_spacing (GtkWidget *widget, GtkCTree *ctree)
{
  gtk_ctree_set_spacing (ctree, GTK_ADJUSTMENT (widget)->value);
}

sub change_row_height (GtkWidget *widget, GtkCList *clist)
{
  gtk_clist_set_row_height (clist, GTK_ADJUSTMENT (widget)->value);
}

sub set_background (GtkCTree *ctree, GtkCTreeNode *node, gpointer data)
{
  GtkStyle *style = NULL;
  
  if (!node)
    return;
  
  if (ctree->line_style != GTK_CTREE_LINES_TABBED)
    {
      if (!GTK_CTREE_ROW (node)->is_leaf)
	style = GTK_CTREE_ROW (node)->row.data;
      else if (GTK_CTREE_ROW (node)->parent)
	style = GTK_CTREE_ROW (GTK_CTREE_ROW (node)->parent)->row.data;
    }

  gtk_ctree_node_set_row_style (ctree, node, style);
}

sub ctree_toggle_line_style (GtkWidget *widget, gpointer data)
{
  GtkCTree *ctree;
  gint i;

  ctree = GTK_CTREE (data);

  if (!GTK_WIDGET_MAPPED (widget))
    return;

  i = gtk_option_menu_get_history (GTK_OPTION_MENU (widget));

  if ((ctree->line_style == GTK_CTREE_LINES_TABBED && 
       ((GtkCTreeLineStyle) i) != GTK_CTREE_LINES_TABBED) ||
      (ctree->line_style != GTK_CTREE_LINES_TABBED && 
       ((GtkCTreeLineStyle) i) == GTK_CTREE_LINES_TABBED))
    gtk_ctree_pre_recursive (ctree, NULL, set_background, NULL);
  gtk_ctree_set_line_style (ctree, i);
  line_style = i;
}

sub ctree_toggle_expander_style (GtkWidget *widget, gpointer data)
{
  GtkCTree *ctree;
  gint i;

  ctree = GTK_CTREE (data);

  if (!GTK_WIDGET_MAPPED (widget))
    return;
  
  i = gtk_option_menu_get_history (GTK_OPTION_MENU (widget));
  
  gtk_ctree_set_expander_style (ctree, (GtkCTreeExpanderStyle) i);
}

sub ctree_toggle_justify (GtkWidget *widget, gpointer data)
{
  GtkCTree *ctree;
  gint i;

  ctree = GTK_CTREE (data);

  if (!GTK_WIDGET_MAPPED (widget))
    return;

  i = gtk_option_menu_get_history (GTK_OPTION_MENU (widget));

  gtk_clist_set_column_justification (GTK_CLIST (ctree), ctree->tree_column, 
				      (GtkJustification) i);
}

sub ctree_toggle_sel_mode (GtkWidget *widget, gpointer data)
{
  GtkCTree *ctree;
  gint i;

  ctree = GTK_CTREE (data);

  if (!GTK_WIDGET_MAPPED (widget))
    return;

  i = gtk_option_menu_get_history (GTK_OPTION_MENU (widget));

  gtk_clist_set_selection_mode (GTK_CLIST (ctree), selection_modes[i]);
  after_press (ctree, NULL);
}
    
sub build_recursive (GtkCTree *ctree, gint cur_depth, gint depth, 
		      gint num_books, gint num_pages, GtkCTreeNode *parent)
{
  gchar *text[2];
  gchar buf1[60];
  gchar buf2[60];
  GtkCTreeNode *sibling;
  CTreePixmaps *pixmaps;
  gint i;

  text[0] = buf1;
  text[1] = buf2;
  sibling = NULL;

  pixmaps = get_ctree_pixmaps (ctree);

  for (i = num_pages + num_books; i > num_books; i--)
    {
      pages++;
      sprintf (buf1, "Page %02d", (gint) rand() % 100);
      sprintf (buf2, "Item %d-%d", cur_depth, i);
      sibling = gtk_ctree_insert_node (ctree, parent, sibling, text, 5,
				       pixmaps->pixmap3, pixmaps->mask3, NULL, NULL,
				       TRUE, FALSE);

      if (parent && ctree->line_style == GTK_CTREE_LINES_TABBED)
	gtk_ctree_node_set_row_style (ctree, sibling,
				      GTK_CTREE_ROW (parent)->row.style);
    }

  if (cur_depth == depth)
    return;

  for (i = num_books; i > 0; i--)
    {
      GtkStyle *style;

      books++;
      sprintf (buf1, "Book %02d", (gint) rand() % 100);
      sprintf (buf2, "Item %d-%d", cur_depth, i);
      sibling = gtk_ctree_insert_node (ctree, parent, sibling, text, 5,
				       pixmaps->pixmap1, pixmaps->mask1, pixmaps->pixmap2, pixmaps->mask2,
				       FALSE, FALSE);

      style = gtk_style_new ();
      switch (cur_depth % 3)
	{
	case 0:
	  style->base[GTK_STATE_NORMAL].red   = 10000 * (cur_depth % 6);
	  style->base[GTK_STATE_NORMAL].green = 0;
	  style->base[GTK_STATE_NORMAL].blue  = 65535 - ((i * 10000) % 65535);
	  break;
	case 1:
	  style->base[GTK_STATE_NORMAL].red   = 10000 * (cur_depth % 6);
	  style->base[GTK_STATE_NORMAL].green = 65535 - ((i * 10000) % 65535);
	  style->base[GTK_STATE_NORMAL].blue  = 0;
	  break;
	default:
	  style->base[GTK_STATE_NORMAL].red   = 65535 - ((i * 10000) % 65535);
	  style->base[GTK_STATE_NORMAL].green = 0;
	  style->base[GTK_STATE_NORMAL].blue  = 10000 * (cur_depth % 6);
	  break;
	}
      gtk_ctree_node_set_row_data_full (ctree, sibling, style,
					(GtkDestroyNotify) gtk_style_unref);

      if (ctree->line_style == GTK_CTREE_LINES_TABBED)
	gtk_ctree_node_set_row_style (ctree, sibling, style);

      build_recursive (ctree, cur_depth + 1, depth, num_books, num_pages,
		       sibling);
    }
}

sub rebuild_tree (GtkWidget *widget, GtkCTree *ctree)
{
  gchar *text [2];
  gchar label1[] = "Root";
  gchar label2[] = "";
  GtkCTreeNode *parent;
  GtkStyle *style;
  guint b, d, p, n;
  CTreePixmaps *pixmaps;

  pixmaps = get_ctree_pixmaps (ctree);

  text[0] = label1;
  text[1] = label2;
  
  d = gtk_spin_button_get_value_as_int (GTK_SPIN_BUTTON (spin1)); 
  b = gtk_spin_button_get_value_as_int (GTK_SPIN_BUTTON (spin2));
  p = gtk_spin_button_get_value_as_int (GTK_SPIN_BUTTON (spin3));

  n = ((pow (b, d) - 1) / (b - 1)) * (p + 1);

  if (n > 100000)
    {
      g_print ("%d total items? Try less\n",n);
      return;
    }

  gtk_clist_freeze (GTK_CLIST (ctree));
  gtk_clist_clear (GTK_CLIST (ctree));

  books = 1;
  pages = 0;

  parent = gtk_ctree_insert_node (ctree, NULL, NULL, text, 5, pixmaps->pixmap1,
				  pixmaps->mask1, pixmaps->pixmap2, pixmaps->mask2, FALSE, TRUE);

  style = gtk_style_new ();
  style->base[GTK_STATE_NORMAL].red   = 0;
  style->base[GTK_STATE_NORMAL].green = 45000;
  style->base[GTK_STATE_NORMAL].blue  = 55000;
  gtk_ctree_node_set_row_data_full (ctree, parent, style,
				    (GtkDestroyNotify) gtk_style_unref);

  if (ctree->line_style == GTK_CTREE_LINES_TABBED)
    gtk_ctree_node_set_row_style (ctree, parent, style);

  build_recursive (ctree, 1, d, b, p, parent);
  gtk_clist_thaw (GTK_CLIST (ctree));
  after_press (ctree, NULL);
}

sub ctree_click_column (GtkCTree *ctree, gint column, gpointer data)
{
  GtkCList *clist;

  clist = GTK_CLIST (ctree);

  if (column == clist->sort_column)
    {
      if (clist->sort_type == GTK_SORT_ASCENDING)
	clist->sort_type = GTK_SORT_DESCENDING;
      else
	clist->sort_type = GTK_SORT_ASCENDING;
    }
  else
    gtk_clist_set_sort_column (clist, column);

  gtk_ctree_sort_recursive (ctree, NULL);
}

sub create_ctree (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkTooltips *tooltips;
  GtkCTree *ctree;
  GtkWidget *scrolled_win;
  GtkWidget *vbox;
  GtkWidget *bbox;
  GtkWidget *mbox;
  GtkWidget *hbox;
  GtkWidget *hbox2;
  GtkWidget *frame;
  GtkWidget *label;
  GtkWidget *button;
  GtkWidget *check;
  GtkAdjustment *adj;
  GtkWidget *spinner;

  char *title[] = { "Tree" , "Info" };
  char buf[80];

  static gchar *items1[] =
  {
    "No lines",
    "Solid",
    "Dotted",
    "Tabbed"
  };

  static gchar *items2[] =
  {
    "None",
    "Square",
    "Triangle",
    "Circular"
  };

  static gchar *items3[] =
  {
    "Left",
    "Right"
  };
  
  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window, 
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "GtkCTree");
      gtk_container_set_border_width ($window, 0);

      tooltips = gtk_tooltips_new ();
      g_object_ref (tooltips);
      gtk_object_sink (GTK_OBJECT (tooltips));

      g_object_set_data_full (window, "tooltips", tooltips,
			      g_object_unref);

      vbox = Gtk2::VBox->new(FALSE, 0);
      $window->add($vbox);

      hbox = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($hbox, 5);
      $vbox->pack_start ($hbox, FALSE, TRUE, 0);
      
      label = Gtk2::Label->new("Depth :");
      $hbox->pack_start ($label, FALSE, TRUE, 0);
      
      adj = (GtkAdjustment *) gtk_adjustment_new (4, 1, 10, 1, 5, 0);
      spin1 = gtk_spin_button_new (adj, 0, 0);
      $hbox->pack_start ($spin1, FALSE, TRUE, 5);
  
      label = Gtk2::Label->new("Books :");
      $hbox->pack_start ($label, FALSE, TRUE, 0);
      
      adj = (GtkAdjustment *) gtk_adjustment_new (3, 1, 20, 1, 5, 0);
      spin2 = gtk_spin_button_new (adj, 0, 0);
      $hbox->pack_start ($spin2, FALSE, TRUE, 5);

      label = Gtk2::Label->new("Pages :");
      $hbox->pack_start ($label, FALSE, TRUE, 0);
      
      adj = (GtkAdjustment *) gtk_adjustment_new (5, 1, 20, 1, 5, 0);
      spin3 = gtk_spin_button_new (adj, 0, 0);
      $hbox->pack_start ($spin3, FALSE, TRUE, 5);

      button = Gtk2::Button->new("Close");
      gtk_box_pack_end (hbox, button, TRUE, TRUE, 0);

      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);

      button = Gtk2::Button->new("Rebuild Tree");
      $hbox->pack_start ($button, TRUE, TRUE, 0);

      scrolled_win = Gtk2::ScrolledWindow->new;
      gtk_container_set_border_width ($scrolled_win, 5);
      gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scrolled_win),
				      GTK_POLICY_AUTOMATIC,
				      GTK_POLICY_ALWAYS);
      $vbox->pack_start ($scrolled_win, TRUE, TRUE, 0);

      ctree = GTK_CTREE (gtk_ctree_new_with_titles (2, 0, title));
      $scrolled_win->add($GTK_WIDGET (ctree));

      gtk_clist_set_column_auto_resize (GTK_CLIST (ctree), 0, TRUE);
      gtk_clist_set_column_width (GTK_CLIST (ctree), 1, 200);
      gtk_clist_set_selection_mode (GTK_CLIST (ctree), GTK_SELECTION_EXTENDED);
      gtk_ctree_set_line_style (ctree, GTK_CTREE_LINES_DOTTED);
      line_style = GTK_CTREE_LINES_DOTTED;

      g_signal_connect (button, "clicked",
			\&rebuild_tree, ctree);
      g_signal_connect (ctree, "click_column",
			\&ctree_click_column, NULL);

      g_signal_connect_after (ctree, "button_press_event",
			      \&after_press, NULL);
      g_signal_connect_after (ctree, "button_release_event",
			      \&after_press, NULL);
      g_signal_connect_after (ctree, "tree_move",
			      \&after_move, NULL);
      g_signal_connect_after (ctree, "end_selection",
			      \&after_press, NULL);
      g_signal_connect_after (ctree, "toggle_focus_row",
			      \&after_press, NULL);
      g_signal_connect_after (ctree, "select_all",
			      \&after_press, NULL);
      g_signal_connect_after (ctree, "unselect_all",
			      \&after_press, NULL);
      g_signal_connect_after (ctree, "scroll_vertical",
			      \&after_press, NULL);

      bbox = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($bbox, 5);
      $vbox->pack_start ($bbox, FALSE, TRUE, 0);

      mbox = Gtk2::VBox->new(TRUE, 5);
      $bbox->pack_start ($mbox, FALSE, TRUE, 0);

      label = Gtk2::Label->new("Row Height :");
      $mbox->pack_start ($label, FALSE, FALSE, 0);

      label = Gtk2::Label->new("Indent :");
      $mbox->pack_start ($label, FALSE, FALSE, 0);

      label = Gtk2::Label->new("Spacing :");
      $mbox->pack_start ($label, FALSE, FALSE, 0);

      mbox = Gtk2::VBox->new(TRUE, 5);
      $bbox->pack_start ($mbox, FALSE, TRUE, 0);

      adj = (GtkAdjustment *) gtk_adjustment_new (20, 12, 100, 1, 10, 0);
      spinner = gtk_spin_button_new (adj, 0, 0);
      $mbox->pack_start ($spinner, FALSE, FALSE, 5);
      gtk_tooltips_set_tip (tooltips, spinner,
			    "Row height of list items", NULL);
      g_signal_connect (adj, "value_changed",
			\&change_row_height, ctree);
      gtk_clist_set_row_height ( GTK_CLIST (ctree), adj->value);

      adj = (GtkAdjustment *) gtk_adjustment_new (20, 0, 60, 1, 10, 0);
      spinner = gtk_spin_button_new (adj, 0, 0);
      $mbox->pack_start ($spinner, FALSE, FALSE, 5);
      gtk_tooltips_set_tip (tooltips, spinner, "Tree Indentation.", NULL);
      g_signal_connect (adj, "value_changed",
			\&change_indent, ctree);

      adj = (GtkAdjustment *) gtk_adjustment_new (5, 0, 60, 1, 10, 0);
      spinner = gtk_spin_button_new (adj, 0, 0);
      $mbox->pack_start ($spinner, FALSE, FALSE, 5);
      gtk_tooltips_set_tip (tooltips, spinner, "Tree Spacing.", NULL);
      g_signal_connect (adj, "value_changed",
			\&change_spacing, ctree);

      mbox = Gtk2::VBox->new(TRUE, 5);
      $bbox->pack_start ($mbox, FALSE, TRUE, 0);

      hbox = Gtk2::HBox->new(FALSE, 5);
      $mbox->pack_start ($hbox, FALSE, FALSE, 0);

      button = Gtk2::Button->new("Expand All");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&expand_all, ctree);

      button = Gtk2::Button->new("Collapse All");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&collapse_all, ctree);

      button = Gtk2::Button->new("Change Style");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&change_style, ctree);

      button = Gtk2::Button->new("Export Tree");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&export_ctree, ctree);

      hbox = Gtk2::HBox->new(FALSE, 5);
      $mbox->pack_start ($hbox, FALSE, FALSE, 0);

      button = Gtk2::Button->new("Select All");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&select_all, ctree);

      button = Gtk2::Button->new("Unselect All");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&unselect_all, ctree);

      button = Gtk2::Button->new("Remove Selection");
      $hbox->pack_start ($button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&remove_selection, ctree);

      check = gtk_check_button_new_with_label ("Reorderable");
      $hbox->pack_start ($check, FALSE, TRUE, 0);
      gtk_tooltips_set_tip (tooltips, check,
			    "Tree items can be reordered by dragging.", NULL);
      g_signal_connect (check, "clicked",
			\&toggle_reorderable, ctree);
      gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (check), TRUE);

      hbox = Gtk2::HBox->new(TRUE, 5);
      $mbox->pack_start ($hbox, FALSE, FALSE, 0);

      omenu1 = build_option_menu (items1, 4, 2, 
				  ctree_toggle_line_style,
				  ctree);
      $hbox->pack_start ($omenu1, FALSE, TRUE, 0);
      gtk_tooltips_set_tip (tooltips, omenu1, "The tree's line style.", NULL);

      omenu2 = build_option_menu (items2, 4, 1, 
				  ctree_toggle_expander_style,
				  ctree);
      $hbox->pack_start ($omenu2, FALSE, TRUE, 0);
      gtk_tooltips_set_tip (tooltips, omenu2, "The tree's expander style.",
			    NULL);

      omenu3 = build_option_menu (items3, 2, 0, 
				  ctree_toggle_justify, ctree);
      $hbox->pack_start ($omenu3, FALSE, TRUE, 0);
      gtk_tooltips_set_tip (tooltips, omenu3, "The tree's justification.",
			    NULL);

      omenu4 = build_option_menu (selection_mode_items, 3, 3, 
				  ctree_toggle_sel_mode, ctree);
      $hbox->pack_start ($omenu4, FALSE, TRUE, 0);
      gtk_tooltips_set_tip (tooltips, omenu4, "The list's selection mode.",
			    NULL);

      gtk_widget_realize (window);
      
      gtk_widget_set_size_request (GTK_WIDGET (ctree), -1, 300);

      frame = Gtk2::Frame->new ;
      gtk_container_set_border_width ($frame, 0);
      gtk_frame_set_shadow_type (GTK_FRAME (frame), GTK_SHADOW_OUT);
      $vbox->pack_start ($frame, FALSE, TRUE, 0);

      hbox = Gtk2::HBox->new(TRUE, 2);
      gtk_container_set_border_width ($hbox, 2);
      $frame->add($hbox);

      frame = Gtk2::Frame->new ;
      gtk_frame_set_shadow_type (GTK_FRAME (frame), GTK_SHADOW_IN);
      $hbox->pack_start ($frame, FALSE, TRUE, 0);

      hbox2 = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox2, 2);
      $frame->add($hbox2);

      label = Gtk2::Label->new("Books :");
      $hbox2->pack_start ($label, FALSE, TRUE, 0);

      sprintf (buf, "%d", books);
      book_label = Gtk2::Label->new(buf);
      gtk_box_pack_end (hbox2, book_label, FALSE, TRUE, 5);

      frame = Gtk2::Frame->new ;
      gtk_frame_set_shadow_type (GTK_FRAME (frame), GTK_SHADOW_IN);
      $hbox->pack_start ($frame, FALSE, TRUE, 0);

      hbox2 = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox2, 2);
      $frame->add($hbox2);

      label = Gtk2::Label->new("Pages :");
      $hbox2->pack_start ($label, FALSE, TRUE, 0);

      sprintf (buf, "%d", pages);
      page_label = Gtk2::Label->new(buf);
      gtk_box_pack_end (hbox2, page_label, FALSE, TRUE, 5);

      frame = Gtk2::Frame->new ;
      gtk_frame_set_shadow_type (GTK_FRAME (frame), GTK_SHADOW_IN);
      $hbox->pack_start ($frame, FALSE, TRUE, 0);

      hbox2 = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox2, 2);
      $frame->add($hbox2);

      label = Gtk2::Label->new("Selected :");
      $hbox2->pack_start ($label, FALSE, TRUE, 0);

      sprintf (buf, "%d", g_list_length (GTK_CLIST (ctree)->selection));
      sel_label = Gtk2::Label->new(buf);
      gtk_box_pack_end (hbox2, sel_label, FALSE, TRUE, 5);

      frame = Gtk2::Frame->new ;
      gtk_frame_set_shadow_type (GTK_FRAME (frame), GTK_SHADOW_IN);
      $hbox->pack_start ($frame, FALSE, TRUE, 0);

      hbox2 = Gtk2::HBox->new(FALSE, 0);
      gtk_container_set_border_width ($hbox2, 2);
      $frame->add($hbox2);

      label = Gtk2::Label->new("Visible :");
      $hbox2->pack_start ($label, FALSE, TRUE, 0);

      sprintf (buf, "%d", g_list_length (GTK_CLIST (ctree)->row_list));
      vis_label = Gtk2::Label->new(buf);
      gtk_box_pack_end (hbox2, vis_label, FALSE, TRUE, 5);

      rebuild_tree (NULL, ctree);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# * GtkColorSelection

sub color_selection_ok (GtkWidget* w, GtkColorSelectionDialog *cs)
{
  GtkColorSelection *colorsel;
  gdouble color[4];

  colorsel=GTK_COLOR_SELECTION(cs->colorsel);

  gtk_color_selection_get_color(colorsel,color);
  gtk_color_selection_set_color(colorsel,color);
}

sub color_selection_changed (GtkWidget *w,
                         GtkColorSelectionDialog *cs)
{
  GtkColorSelection *colorsel;
  gdouble color[4];

  colorsel=GTK_COLOR_SELECTION(cs->colorsel);
  gtk_color_selection_get_color(colorsel,color);
}

sub opacity_toggled_cb (GtkWidget *w,
		    GtkColorSelectionDialog *cs)
{
  GtkColorSelection *colorsel;

  colorsel = GTK_COLOR_SELECTION (cs->colorsel);
  gtk_color_selection_set_has_opacity_control (colorsel,
					       gtk_toggle_button_get_active (GTK_TOGGLE_BUTTON (w)));
}

sub palette_toggled_cb (GtkWidget *w,
		    GtkColorSelectionDialog *cs)
{
  GtkColorSelection *colorsel;

  colorsel = GTK_COLOR_SELECTION (cs->colorsel);
  gtk_color_selection_set_has_palette (colorsel,
				       gtk_toggle_button_get_active (GTK_TOGGLE_BUTTON (w)));
}

my $colwin;
sub create_color_selection (GtkWidget *widget)
{
  static GtkWidget *window = NULL;

  if (!window)
    {
      GtkWidget *options_hbox;
      GtkWidget *check_button;
      
      window = gtk_color_selection_dialog_new ("color selection dialog");
      gtk_window_set_screen (window, 
			     gtk_widget_get_screen (widget));
			     
      $colwin->help_button->show;

      gtk_window_set_position (window, GTK_WIN_POS_MOUSE);

      g_signal_connect (window, "destroy",
                        \&(gtk_widget_destroyed),
                        &window);

      options_hbox = Gtk2::HBox->new(FALSE, 0);
      $$window->pack_start ($vbox, options_hbox, FALSE, FALSE, 0);
      gtk_container_set_border_width ($options_hbox, 10);
      
      check_button = gtk_check_button_new_with_label ("Show Opacity");
      $options_hbox->pack_start ($check_button, FALSE, FALSE, 0);
      g_signal_connect (check_button, "toggled",
			\&opacity_toggled_cb, window);

      check_button = gtk_check_button_new_with_label ("Show Palette");
      gtk_box_pack_end (options_hbox, check_button, FALSE, FALSE, 0);
      g_signal_connect (check_button, "toggled",
			\&palette_toggled_cb, window);

      g_signal_connect (GTK_COLOR_SELECTION_DIALOG (window)->colorsel,
			"color_changed",
			\&color_selection_changed,
			window);

      g_signal_connect (GTK_COLOR_SELECTION_DIALOG (window)->ok_button,
			"clicked",
			\&color_selection_ok,
			window);

      g_signal_connect_swapped (GTK_COLOR_SELECTION_DIALOG (window)->cancel_button,
				"clicked",
				\&gtk_widget_destroy,
				window);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# * GtkFileSelection

sub show_fileops (GtkWidget        *widget, GtkFileSelection *fs)
{
  gboolean show_ops;

  show_ops = gtk_toggle_button_get_active (GTK_TOGGLE_BUTTON (widget));

  if (show_ops)
    gtk_file_selection_show_fileop_buttons (fs);
  else
    gtk_file_selection_hide_fileop_buttons (fs);
}

sub select_multiple (GtkWidget        *widget,
		 GtkFileSelection *fs)
{
  gboolean select_multiple;

  select_multiple = gtk_toggle_button_get_active (GTK_TOGGLE_BUTTON (widget));
  gtk_file_selection_set_select_multiple (fs, select_multiple);
}

sub file_selection_ok (GtkFileSelection *fs)
{
  int i;
  gchar **selections;

  selections = gtk_file_selection_get_selections (fs);

  for (i = 0; selections[i] != NULL; i++)
    g_print ("%s\n", selections[i]);

  g_strfreev (selections);

  gtk_widget_destroy (GTK_WIDGET (fs));
}

sub create_file_selection (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *button;

  if (!window)
    {
      window = gtk_file_selection_new ("file selection dialog");
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      gtk_file_selection_hide_fileop_buttons (GTK_FILE_SELECTION (window));

      gtk_window_set_position (window, GTK_WIN_POS_MOUSE);

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      g_signal_connect_swapped (GTK_FILE_SELECTION (window)->ok_button,
				"clicked",
				\&file_selection_ok,
				window);
      g_signal_connect_swapped (GTK_FILE_SELECTION (window)->cancel_button,
			        "clicked",
				\&gtk_widget_destroy,
				window);
      
      button = gtk_check_button_new_with_label ("Show Fileops");
      g_signal_connect (button, "toggled",
			\&show_fileops,
			window);
      $window->action_area->pack_start($button, FALSE, FALSE, 0);
      $button->show;
      $button = gtk_check_button_new_with_label ("Select Multiple");
      g_signal_connect (button, "clicked",
			\&select_multiple,
			window);
      $window->action_area->pack_start($button, FALSE, FALSE, 0);
      $button->show;
    }
  
  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

sub flipping_toggled_cb (GtkWidget *widget, gpointer data)
{
  int state = gtk_toggle_button_get_active (GTK_TOGGLE_BUTTON (widget));
  int new_direction = state ? GTK_TEXT_DIR_RTL : GTK_TEXT_DIR_LTR;

  gtk_widget_set_default_direction (new_direction);
}

sub set_direction_recurse (GtkWidget *widget,
		       gpointer   data)
{
  GtkTextDirection *dir = data;
  
  gtk_widget_set_direction (widget, *dir);
  if (GTK_IS_CONTAINER (widget))
    gtk_container_foreach ($widget,
			   set_direction_recurse,
			   data);
}

sub create_forward_back (const char       *title,
		     GtkTextDirection  text_dir)
{
  GtkWidget *frame = Gtk2::Frame->new (title);
  GtkWidget *bbox = gtk_hbutton_box_new ();
  GtkWidget *back_button = gtk_button_new_from_stock (GTK_STOCK_GO_BACK);
  GtkWidget *forward_button = gtk_button_new_from_stock (GTK_STOCK_GO_FORWARD);

  gtk_container_set_border_width ($bbox, 5);
  
  $frame->add($bbox);
  $bbox->add($back_button);
  $bbox->add($forward_button);

  set_direction_recurse (frame, &text_dir);

  return frame;
}

sub create_flipping (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *check_button, *button;

  if (!window)
    {
      window = Gtk2::Dialog->new;

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "Bidirectional Flipping");

      check_button = gtk_check_button_new_with_label ("Right-to-left global direction");
      $window->vbox->pack_start($check_button, TRUE, TRUE, 0);

      $window->vbox->pack_start ( create_forward_back ("Default", GTK_TEXT_DIR_NONE), TRUE, TRUE, 0);

      $window->vbox->pack_start (create_forward_back ("Left-to-Right", GTK_TEXT_DIR_LTR),
			  TRUE, TRUE, 0);

      $window->vbox->pack_start(create_forward_back("Right-to-Left", GTK_TEXT_DIR_RTL),
				TRUE, TRUE, 0);

      if (gtk_widget_get_default_direction () == GTK_TEXT_DIR_RTL)
	gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (check_button), TRUE);

      g_signal_connect (check_button, "toggled",
			\&flipping_toggled_cb, FALSE);

      gtk_container_set_border_width ($check_button, 10);
      
      button = Gtk2::Button->new("Close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy, window);
      $window->action_area->pack_start($button, TRUE, TRUE, 0);
    }
  
  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# * Focus test
sub make_focus_table (GList **list)
{
  GtkWidget *table;
  gint i, j;
  
  table = gtk_table_new (5, 5, FALSE);

  i = 0;
  j = 0;

  while (i < 5)
    {
      j = 0;
      while (j < 5)
        {
          GtkWidget *widget;
          
          if ((i + j) % 2)
            widget = Gtk2::Entry->new;
          else
            widget = Gtk2::Button->new("Foo");

          *list = g_list_prepend (*list, widget);
          
          gtk_table_attach (GTK_TABLE (table),
                            widget,
                            i, i + 1,
                            j, j + 1,
                            GTK_EXPAND | GTK_FILL,
                            GTK_EXPAND | GTK_FILL,
                            5, 5);
          
          ++j;
        }

      ++i;
    }

  *list = g_list_reverse (*list);
  
  return table;
}

sub create_focus (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  
  if (!window)
    {
      GtkWidget *table;
      GtkWidget *frame;
      GList *list = NULL;
      
      window = gtk_dialog_new_with_buttons ("Keyboard focus navigation",
                                            NULL, 0,
                                            GTK_STOCK_CLOSE,
                                            GTK_RESPONSE_NONE,
                                            NULL);

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      g_signal_connect (window, "response",
                        \&gtk_widget_destroy,
                        NULL);
      
      gtk_window_set_title (window, "Keyboard Focus Navigation");

      frame = Gtk2::Frame->new ("Weird tab focus chain");

      $$window->pack_start ($vbox, 
			  frame, TRUE, TRUE, 0);
      
      table = make_focus_table (&list);

      $frame->add($table);

      gtk_container_set_focus_chain ($table,
                                     list);

      g_list_free (list);
      
      frame = Gtk2::Frame->new ("Default tab focus chain");

      $$window->pack_start ($vbox, 
			  frame, TRUE, TRUE, 0);

      list = NULL;
      table = make_focus_table (&list);

      g_list_free (list);
      
      $frame->add($table);      
    }
  
  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# * GtkFontSelection

sub font_selection_ok (GtkWidget              *w,
		   GtkFontSelectionDialog *fs)
{
  gchar *s = gtk_font_selection_dialog_get_font_name (fs);

  g_print ("%s\n", s);
  g_free (s);
  gtk_widget_destroy (GTK_WIDGET (fs));
}

sub create_font_selection (GtkWidget *widget)
{
  static GtkWidget *window = NULL;

  if (!window)
    {
      window = gtk_font_selection_dialog_new ("Font Selection Dialog");
      
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      gtk_window_set_position (window, GTK_WIN_POS_MOUSE);

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      g_signal_connect (GTK_FONT_SELECTION_DIALOG (window)->ok_button,
			"clicked", \&font_selection_ok,
			GTK_FONT_SELECTION_DIALOG (window));
      g_signal_connect_swapped (GTK_FONT_SELECTION_DIALOG (window)->cancel_button,
			        "clicked", \&gtk_widget_destroy,
			        window);
    }
  
  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

# * GtkDialog

static GtkWidget *dialog_window = NULL;

sub label_toggle
{
  my ($widget, $label) = @_;
  unless ($label)
    {
      $label = Gtk2::Label->new("Dialog Test");
      $label->signal_connect("destroy" => \&gtk_widget_destroyed, $label);
      $label->set_padding(10, 10);
      $dialog_window->vbox->pack_start($label, TRUE, TRUE, 0);
      $label->show;
    }
  else { $lable->destroy }
  $label;
}

use constant RESPONSE_TOGGLE_SEPARATOR => 1;

sub print_response (GtkWidget *dialog,
                gint       response_id,
                gpointer   data)
{
  g_print ("response signal received (%d)\n", response_id);

  if (response_id == RESPONSE_TOGGLE_SEPARATOR)
    {
      gtk_dialog_set_has_separator (GTK_DIALOG (dialog),
                                    !gtk_dialog_get_has_separator (GTK_DIALOG (dialog)));
    }
}

sub create_dialog (GtkWidget *widget)
{
  static GtkWidget *label;
  if (!dialog_window)
    {
      ## This is a terrible example; it's much simpler to create
      # * dialogs than this. Don't use testgtk for example code,
      # * use gtk-demo ;-)
      dialog_window = Gtk2::Dialog->new;
      gtk_window_set_screen (dialog_window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (dialog_window,
                        "response",
                        \&print_response,
                        NULL);
      
      g_signal_connect (dialog_window, "destroy",
			\&gtk_widget_destroyed,
			&dialog_window);

      gtk_window_set_title (dialog_window, "GtkDialog");
      gtk_container_set_border_width ($dialog_window, 0);

      my $button = Gtk2::Button->new("OK");
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      $dialog_window->action_area->pack_start ($button, TRUE, TRUE, 0);
      gtk_widget_grab_default (button);
      $button->show;
      $button = Gtk2::Button->new("Toggle");
      $button->g_signal_connect ("clicked" =>  \&label_toggle, $label);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      $dialog_window->action_area->pack_start($button, TRUE, TRUE, 0);
      $button->show;
      $label = undef;
      $button = Gtk2::Button->new("Separator");
      $button->SET_FLAGS(Gtk2->CAN_DEFAULT);
      $dialog_window->add_action_widget($button, RESPONSE_TOGGLE_SEPARATOR);
      $button->show;
    }

  if (!GTK_WIDGET_VISIBLE (dialog_window))
    $dialog_window->show;
  else
    gtk_widget_destroy (dialog_window);
}

# Display & Screen test 

typedef struct 
{ 
  GtkEntry *entry;
  GtkWidget *radio_dpy;
  GtkWidget *toplevel; 
  GtkWidget *dialog_window;
  GList *valid_display_list;
} ScreenDisplaySelection;

sub display_name_cmp (gconstpointer a,
		  gconstpointer b)
{
  return g_ascii_strcasecmp (a,b);
}

sub screen_display_check (GtkWidget *widget, ScreenDisplaySelection *data)
{
  char *display_name;
  GdkDisplay *display = gtk_widget_get_display (widget);
  GtkWidget *dialog;
  GdkScreen *new_screen = NULL;
  GdkScreen *current_screen = gtk_widget_get_screen (widget);
  
  if (gtk_toggle_button_get_active (GTK_TOGGLE_BUTTON (data->radio_dpy)))
    {
      display_name = g_strdup (gtk_entry_get_text (data->entry));
      display = gdk_display_open (display_name);
      
      if (!display)
	{
	  dialog = gtk_message_dialog_new (gtk_widget_get_toplevel (widget),
					   GTK_DIALOG_DESTROY_WITH_PARENT,
					   GTK_MESSAGE_ERROR,
					   GTK_BUTTONS_OK,
					   "The display :\n%s\ncannot be opened",
					   display_name);
	  gtk_window_set_screen (dialog, current_screen);
	  $dialog->show;
	  g_signal_connect (dialog, "response",
			    \&gtk_widget_destroy,
			    NULL);
	}
      else
	{
	  if (!g_list_find_custom (data->valid_display_list, 
				   display_name,
				   display_name_cmp))
	    data->valid_display_list = g_list_append (data->valid_display_list,
						      display_name);
	  
	  new_screen = gdk_display_get_default_screen (display);
	}
    }
  else
    {
      gint number_of_screens = gdk_display_get_n_screens (display);
      gint screen_num = gdk_screen_get_number (current_screen);
      if ((screen_num +1) < number_of_screens)
	new_screen = gdk_display_get_screen (display, screen_num + 1);
      else
	new_screen = gdk_display_get_screen (display, 0);
    }
  
  if (new_screen) 
    {
      gtk_window_set_screen (data->toplevel, new_screen);
      gtk_widget_destroy (data->dialog_window);
    }
}

sub screen_display_destroy_diag (GtkWidget *widget, GtkWidget *data)
{
  gtk_widget_destroy (data);
}

sub create_display_screen (GtkWidget *widget)
{
  GtkWidget *table, *frame, *window, *combo_dpy, *vbox;
  GtkWidget *radio_dpy, *radio_scr, *applyb, *cancelb;
  GtkWidget *bbox;
  ScreenDisplaySelection *scr_dpy_data;
  GdkScreen *screen = gtk_widget_get_screen (widget);
  static GList *valid_display_list = NULL;
  
  GdkDisplay *display = gdk_screen_get_display (screen);

  window = gtk_widget_new (gtk_window_get_type (),
			   "screen", screen,
			   "user_data", NULL,
			   "type", GTK_WINDOW_TOPLEVEL,
			   "title",
			   "Screen or Display selection",
			   "border_width", 10, NULL);
  g_signal_connect (window, "destroy", 
		    \&gtk_widget_destroy, NULL);

  vbox = Gtk2::VBox->new(FALSE, 3);
  $window->add($vbox);
  
  frame = Gtk2::Frame->new ("Select screen or display");
  $vbox->add($frame);
  
  table = gtk_table_new (2, 2, TRUE);
  gtk_table_set_row_spacings (GTK_TABLE (table), 3);
  gtk_table_set_col_spacings (GTK_TABLE (table), 3);

  $frame->add($table);

  radio_dpy = gtk_radio_button_new_with_label (NULL, "move to another X display");
  if (gdk_display_get_n_screens(display) > 1)
    radio_scr = gtk_radio_button_new_with_label 
    (gtk_radio_button_get_group (GTK_RADIO_BUTTON (radio_dpy)), "move to next screen");
  else
    {    
      radio_scr = gtk_radio_button_new_with_label 
	(gtk_radio_button_get_group (GTK_RADIO_BUTTON (radio_dpy)), 
	 "only one screen on the current display");
      gtk_widget_set_sensitive (radio_scr, FALSE);
    }
  combo_dpy = gtk_combo_new ();
  if (!valid_display_list)
    valid_display_list = g_list_append (valid_display_list, "diabolo:0.0");
    
  gtk_combo_set_popdown_strings (GTK_COMBO (combo_dpy), valid_display_list);
    
  gtk_entry_set_text (GTK_ENTRY (GTK_COMBO (combo_dpy)->entry), 
		      "<hostname>:<X Server Num>.<Screen Num>");

  gtk_table_attach_defaults (GTK_TABLE (table), radio_dpy, 0, 1, 0, 1);
  gtk_table_attach_defaults (GTK_TABLE (table), radio_scr, 0, 1, 1, 2);
  gtk_table_attach_defaults (GTK_TABLE (table), combo_dpy, 1, 2, 0, 1);

  bbox = gtk_hbutton_box_new ();
  applyb = gtk_button_new_from_stock (GTK_STOCK_APPLY);
  cancelb = gtk_button_new_from_stock (GTK_STOCK_CANCEL);
  
  $vbox->add($bbox);

  $bbox->add($applyb);
  $bbox->add($cancelb);

  scr_dpy_data = g_new0 (ScreenDisplaySelection, 1);

  scr_dpy_data->entry = GTK_ENTRY (GTK_COMBO (combo_dpy)->entry);
  scr_dpy_data->radio_dpy = radio_dpy;
  scr_dpy_data->toplevel = gtk_widget_get_toplevel (widget);
  scr_dpy_data->dialog_window = window;
  scr_dpy_data->valid_display_list = valid_display_list;

  g_signal_connect (cancelb, "clicked", 
		    \&screen_display_destroy_diag, window);
  g_signal_connect (applyb, "clicked", 
		    \&screen_display_check, scr_dpy_data);
  $window->show_all;
}

## Event Watcher

static gboolean event_watcher_enter_id = 0;
static gboolean event_watcher_leave_id = 0;

sub event_watcher (GSignalInvocationHint *ihint,
	       guint                  n_param_values,
	       const GValue          *param_values,
	       gpointer               data)
{
  g_print ("Watch: \"%s\" emitted for %s\n",
	   g_signal_name (ihint->signal_id),
	   G_OBJECT_TYPE_NAME (g_value_get_object (param_values + 0)));

  return TRUE;
}

sub event_watcher_down (void)
{
  if (event_watcher_enter_id)
    {
      guint signal_id;

      signal_id = g_signal_lookup ("enter_notify_event", GTK_TYPE_WIDGET);
      g_signal_remove_emission_hook (signal_id, event_watcher_enter_id);
      event_watcher_enter_id = 0;
      signal_id = g_signal_lookup ("leave_notify_event", GTK_TYPE_WIDGET);
      g_signal_remove_emission_hook (signal_id, event_watcher_leave_id);
      event_watcher_leave_id = 0;
    }
}

sub event_watcher_toggle (void)
{
  if (event_watcher_enter_id)
    event_watcher_down ();
  else
    {
      guint signal_id;

      signal_id = g_signal_lookup ("enter_notify_event", GTK_TYPE_WIDGET);
      event_watcher_enter_id = g_signal_add_emission_hook (signal_id, 0, event_watcher, NULL, NULL);
      signal_id = g_signal_lookup ("leave_notify_event", GTK_TYPE_WIDGET);
      event_watcher_leave_id = g_signal_add_emission_hook (signal_id, 0, event_watcher, NULL, NULL);
    }
}

sub create_event_watcher (GtkWidget *widget)
{
  GtkWidget *button;

  if (!dialog_window)
    {
      dialog_window = Gtk2::Dialog->new;
      gtk_window_set_screen (dialog_window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (dialog_window, "destroy",
			\&gtk_widget_destroyed,
			&dialog_window);
      g_signal_connect (dialog_window, "destroy",
			\&event_watcher_down,
			NULL);

      gtk_window_set_title (dialog_window, "Event Watcher");
      gtk_container_set_border_width ($dialog_window, 0);
      gtk_widget_set_size_request (dialog_window, 200, 110);

      button = gtk_toggle_button_new_with_label ("Activate Watch");
      g_signal_connect (button, "clicked",
			\&event_watcher_toggle,
			NULL);
      gtk_container_set_border_width ($button, 10);
      $dialog_window->vbox->pack_start($button, TRUE, TRUE, 0);
      $button->show;

      button = Gtk2::Button->new("Close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				dialog_window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      $dialog_window->action_area->gtk_box_pack_start ($button, TRUE, TRUE, 0);
      gtk_widget_grab_default (button);
      $button->show;
    }

  if (!GTK_WIDGET_VISIBLE (dialog_window))
    $dialog_window->show;
  else
    gtk_widget_destroy (dialog_window);
}

# * GtkRange

sub reformat_value
{
  my ($scale, $value) = @_;
  return sprintf ("-->%0.*g<--", $scale->get_digits, $value);
}

sub create_range_controls (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *box1;
  GtkWidget *box2;
  GtkWidget *button;
  GtkWidget *scrollbar;
  GtkWidget *scale;
  GtkWidget *separator;
  GtkObject *adjustment;
  GtkWidget *hbox;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "range controls");
      gtk_container_set_border_width ($window, 0);


      box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);
      $box1->show;


      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, TRUE, TRUE, 0);
      $box2->show;


      adjustment = gtk_adjustment_new (0.0, 0.0, 101.0, 0.1, 1.0, 1.0);

      scale = gtk_hscale_new (GTK_ADJUSTMENT (adjustment));
      gtk_widget_set_size_request (GTK_WIDGET (scale), 150, -1);
      gtk_range_set_update_policy (GTK_RANGE (scale), GTK_UPDATE_DELAYED);
      gtk_scale_set_digits (GTK_SCALE (scale), 1);
      gtk_scale_set_draw_value (GTK_SCALE (scale), TRUE);
      $box2->pack_start ($scale, TRUE, TRUE, 0);
      $scale->show;

      scrollbar = gtk_hscrollbar_new (GTK_ADJUSTMENT (adjustment));
      gtk_range_set_update_policy (GTK_RANGE (scrollbar), 
				   GTK_UPDATE_CONTINUOUS);
      $box2->pack_start ($scrollbar, TRUE, TRUE, 0);
      $scrollbar->show;

      scale = gtk_hscale_new (GTK_ADJUSTMENT (adjustment));
      gtk_scale_set_draw_value (GTK_SCALE (scale), TRUE);
      g_signal_connect (scale,
                        "format_value",
                        \&reformat_value,
                        NULL);
      $box2->pack_start ($scale, TRUE, TRUE, 0);
      $scale->show;
      
      hbox = Gtk2::HBox->new(FALSE, 0);

      scale = gtk_vscale_new (GTK_ADJUSTMENT (adjustment));
      gtk_widget_set_size_request (scale, -1, 200);
      gtk_scale_set_digits (GTK_SCALE (scale), 2);
      gtk_scale_set_draw_value (GTK_SCALE (scale), TRUE);
      $hbox->pack_start ($scale, TRUE, TRUE, 0);
      $scale->show;

      scale = gtk_vscale_new (GTK_ADJUSTMENT (adjustment));
      gtk_widget_set_size_request (scale, -1, 200);
      gtk_scale_set_digits (GTK_SCALE (scale), 2);
      gtk_scale_set_draw_value (GTK_SCALE (scale), TRUE);
      gtk_range_set_inverted (GTK_RANGE (scale), TRUE);
      $hbox->pack_start ($scale, TRUE, TRUE, 0);
      $scale->show;

      scale = gtk_vscale_new (GTK_ADJUSTMENT (adjustment));
      gtk_scale_set_draw_value (GTK_SCALE (scale), TRUE);
      g_signal_connect (scale,
                        "format_value",
                        \&reformat_value,
                        NULL);
      $hbox->pack_start ($scale, TRUE, TRUE, 0);
      $scale->show;

      
      $box2->pack_start ($hbox, TRUE, TRUE, 0);
      $hbox->show;
      
      separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 0);
      $separator->show;


      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);
      $box2->show;


      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
      $button->show;
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

# * GtkRulers

sub create_rulers (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *table;
  GtkWidget *ruler;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_object_set (window, "allow_shrink", TRUE, "allow_grow", TRUE, NULL);

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "rulers");
      gtk_widget_set_size_request (window, 300, 300);
      gtk_widget_set_events (window, 
			     GDK_POINTER_MOTION_MASK 
			     | GDK_POINTER_MOTION_HINT_MASK);
      gtk_container_set_border_width ($window, 0);

      table = gtk_table_new (2, 2, FALSE);
      $window->add($table);
      $table->show;

      ruler = gtk_hruler_new ();
      gtk_ruler_set_metric (GTK_RULER (ruler), GTK_CENTIMETERS);
      gtk_ruler_set_range (GTK_RULER (ruler), 100, 0, 0, 20);

      g_signal_connect_swapped (window, 
			        "motion_notify_event",
				\&GTK_WIDGET_GET_CLASS (ruler->motion_notify_event),
			        ruler);
      
      gtk_table_attach (GTK_TABLE (table), ruler, 1, 2, 0, 1,
			GTK_EXPAND | GTK_FILL, GTK_FILL, 0, 0);
      $ruler->show;


      ruler = gtk_vruler_new ();
      gtk_ruler_set_range (GTK_RULER (ruler), 5, 15, 0, 20);

      g_signal_connect_swapped (window, 
			        "motion_notify_event",
			        \&GTK_WIDGET_GET_CLASS (ruler->motion_notify_event),
			        ruler);
      
      gtk_table_attach (GTK_TABLE (table), ruler, 0, 1, 1, 2,
			GTK_FILL, GTK_EXPAND | GTK_FILL, 0, 0);
      $ruler->show;
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

sub text_toggle_editable (GtkWidget *checkbutton,
		       GtkWidget *text)
{
   gtk_text_set_editable(GTK_TEXT(text),
			  GTK_TOGGLE_BUTTON(checkbutton)->active);
}

sub text_toggle_word_wrap (GtkWidget *checkbutton,
		       GtkWidget *text)
{
   gtk_text_set_word_wrap(GTK_TEXT(text),
			  GTK_TOGGLE_BUTTON(checkbutton)->active);
}

struct {
  GdkColor color;
  gchar *name;
} text_colors[] = {
 { { 0, 0x0000, 0x0000, 0x0000 }, "black" },
 { { 0, 0xFFFF, 0xFFFF, 0xFFFF }, "white" },
 { { 0, 0xFFFF, 0x0000, 0x0000 }, "red" },
 { { 0, 0x0000, 0xFFFF, 0x0000 }, "green" },
 { { 0, 0x0000, 0x0000, 0xFFFF }, "blue" }, 
 { { 0, 0x0000, 0xFFFF, 0xFFFF }, "cyan" },
 { { 0, 0xFFFF, 0x0000, 0xFFFF }, "magenta" },
 { { 0, 0xFFFF, 0xFFFF, 0x0000 }, "yellow" }
};

int ntext_colors = sizeof(text_colors) / sizeof(text_colors[0]);

# GtkText

sub text_insert_random (GtkWidget *w, GtkText *text)
{
  int i;
  char c;
   for (i=0; i<10; i++)
    {
      c = 'A' + rand() % ('Z' - 'A');
      gtk_text_set_point (text, rand() % gtk_text_get_length (text));
      gtk_text_insert (text, NULL, NULL, NULL, &c, 1);
    }
}

sub create_text (GtkWidget *widget)
{
  int i, j;

  static GtkWidget *window = NULL;
  GtkWidget *box1;
  GtkWidget *box2;
  GtkWidget *hbox;
  GtkWidget *button;
  GtkWidget *check;
  GtkWidget *separator;
  GtkWidget *scrolled_window;
  GtkWidget *text;

  FILE *infile;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      gtk_widget_set_name (window, "text window");
      g_object_set (window, "allow_shrink", TRUE, "allow_grow", TRUE, NULL);
      gtk_widget_set_size_request (window, 500, 500);

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "test");
      gtk_container_set_border_width ($window, 0);


      box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);
      $box1->show;


      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, TRUE, TRUE, 0);
      $box2->show;


      scrolled_window = Gtk2::ScrolledWindow->new;
      $box2->pack_start ($scrolled_window, TRUE, TRUE, 0);
      gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scrolled_window),
				      GTK_POLICY_NEVER,
				      GTK_POLICY_ALWAYS);
      $scrolled_window->show;

      text = gtk_text_new ;
      gtk_text_set_editable (GTK_TEXT (text), TRUE);
      $scrolled_window->add($text);
      gtk_widget_grab_focus (text);
      $text->show;


      gtk_text_freeze (GTK_TEXT (text));

      for (i=0; i<ntext_colors; i++)
	{
	  gtk_text_insert (GTK_TEXT (text), NULL, NULL, NULL, 
			   text_colors[i].name, -1);
	  gtk_text_insert (GTK_TEXT (text), NULL, NULL, NULL, "\t", -1);

	  for (j=0; j<ntext_colors; j++)
	    {
	      gtk_text_insert (GTK_TEXT (text), NULL,
			       &text_colors[j].color, &text_colors[i].color,
			       "XYZ", -1);
	    }
	  gtk_text_insert (GTK_TEXT (text), NULL, NULL, NULL, "\n", -1);
	}

      infile = fopen("testgtk.c", "r");
      
      if (infile)
	{
	  char *buffer;
	  int nbytes_read, nbytes_alloc;
	  
	  nbytes_read = 0;
	  nbytes_alloc = 1024;
	  buffer = g_new (char, nbytes_alloc);
	  while (1)
	    {
	      int len;
	      if (nbytes_alloc < nbytes_read + 1024)
		{
		  nbytes_alloc *= 2;
		  buffer = g_realloc (buffer, nbytes_alloc);
		}
	      len = fread (buffer + nbytes_read, 1, 1024, infile);
	      nbytes_read += len;
	      if (len < 1024)
		break;
	    }
	  
	  gtk_text_insert (GTK_TEXT (text), NULL, NULL,
			   NULL, buffer, nbytes_read);
	  g_free(buffer);
	  fclose (infile);
	}
      
      gtk_text_thaw (GTK_TEXT (text));

      hbox = gtk_hbutton_box_new ();
      $box2->pack_start ($hbox, FALSE, FALSE, 0);
      $hbox->show;

      check = gtk_check_button_new_with_label("Editable");
      $hbox->pack_start ($check, FALSE, FALSE, 0);
      g_signal_connect (check, "toggled",
			\&text_toggle_editable, text);
      gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(check), TRUE);
      $check->show;

      check = gtk_check_button_new_with_label("Wrap Words");
      $hbox->pack_start ($check, FALSE, TRUE, 0);
      g_signal_connect (check, "toggled",
			\&text_toggle_word_wrap, text);
      gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(check), FALSE);
      $check->show;

      separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 0);
      $separator->show;


      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);
      $box2->show;


      button = Gtk2::Button->new("insert random");
      g_signal_connect (button, "clicked",
			\&text_insert_random,
			text);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      $button->show;

      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
      $button->show;
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

# * GtkNotebook

GdkPixbuf *book_open;
GdkPixbuf *book_closed;
GtkWidget *sample_notebook;

sub set_page_image (GtkNotebook *notebook, gint page_num, GdkPixbuf *pixbuf)
{
  GtkWidget *page_widget;
  GtkWidget *pixwid;

  page_widget = gtk_notebook_get_nth_page (notebook, page_num);

  pixwid = g_object_get_data (page_widget, "tab_pixmap");
  gtk_image_set_from_pixbuf (GTK_IMAGE (pixwid), pixbuf);
  
  pixwid = g_object_get_data (page_widget, "menu_pixmap");
  gtk_image_set_from_pixbuf (GTK_IMAGE (pixwid), pixbuf);
}

sub page_switch (GtkWidget *widget, GtkNotebookPage *page, gint page_num)
{
  GtkNotebook *notebook = GTK_NOTEBOOK (widget);
  gint old_page_num = gtk_notebook_get_current_page (notebook);
 
  if (page_num == old_page_num)
    return;

  set_page_image (notebook, page_num, book_open);

  if (old_page_num != -1)
    set_page_image (notebook, old_page_num, book_closed);
}

sub tab_fill (GtkToggleButton *button, GtkWidget *child)
{
  gboolean expand;
  GtkPackType pack_type;

  gtk_notebook_query_tab_label_packing (GTK_NOTEBOOK (sample_notebook), child,
					&expand, NULL, &pack_type);
  gtk_notebook_set_tab_label_packing (GTK_NOTEBOOK (sample_notebook), child,
				      expand, button->active, pack_type);
}

sub tab_expand (GtkToggleButton *button, GtkWidget *child)
{
  gboolean fill;
  GtkPackType pack_type;

  gtk_notebook_query_tab_label_packing (GTK_NOTEBOOK (sample_notebook), child,
					NULL, &fill, &pack_type);
  gtk_notebook_set_tab_label_packing (GTK_NOTEBOOK (sample_notebook), child,
				      button->active, fill, pack_type);
}

sub tab_pack (GtkToggleButton *button, GtkWidget *child)
	  
{ 
  gboolean expand;
  gboolean fill;

  gtk_notebook_query_tab_label_packing (GTK_NOTEBOOK (sample_notebook), child,
					&expand, &fill, NULL);
  gtk_notebook_set_tab_label_packing (GTK_NOTEBOOK (sample_notebook), child,
				      expand, fill, button->active);
}

sub create_pages (GtkNotebook *notebook, gint start, gint end)
{
  GtkWidget *child = NULL;
  GtkWidget *button;
  GtkWidget *label;
  GtkWidget *hbox;
  GtkWidget *vbox;
  GtkWidget *label_box;
  GtkWidget *menu_box;
  GtkWidget *pixwid;
  gint i;
  char buffer[32];
  char accel_buffer[32];

  for (i = start; i <= end; i++)
    {
      sprintf (buffer, "Page %d", i);
      sprintf (accel_buffer, "Page _%d", i);

      child = Gtk2::Frame->new (buffer);
      gtk_container_set_border_width ($child, 10);

      vbox = Gtk2::VBox->new(TRUE,0);
      gtk_container_set_border_width ($vbox, 10);
      $child->add($vbox);

      hbox = Gtk2::HBox->new(TRUE,0);
      $vbox->pack_start ($hbox, FALSE, TRUE, 5);

      button = gtk_check_button_new_with_label ("Fill Tab");
      $hbox->pack_start ($button, TRUE, TRUE, 5);
      gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (button), TRUE);
      g_signal_connect (button, "toggled",
			\&tab_fill, child);

      button = gtk_check_button_new_with_label ("Expand Tab");
      $hbox->pack_start ($button, TRUE, TRUE, 5);
      g_signal_connect (button, "toggled",
			\&tab_expand, child);

      button = gtk_check_button_new_with_label ("Pack end");
      $hbox->pack_start ($button, TRUE, TRUE, 5);
      g_signal_connect (button, "toggled",
			\&tab_pack, child);

      button = Gtk2::Button->new("Hide Page");
      gtk_box_pack_end (vbox, button, FALSE, FALSE, 5);
      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_hide,
				child);

      $child->show_all;

      label_box = Gtk2::HBox->new(FALSE, 0);
      pixwid = gtk_image_new_from_pixbuf (book_closed);
      g_object_set_data (child, "tab_pixmap", pixwid);
			   
      $label_box->pack_start ($pixwid, FALSE, TRUE, 0);
      gtk_misc_set_padding (GTK_MISC (pixwid), 3, 1);
      label = gtk_label_new_with_mnemonic (accel_buffer);
      $label_box->pack_start ($label, FALSE, TRUE, 0);
      $label_box->show_all;
      
				       
      menu_box = Gtk2::HBox->new(FALSE, 0);
      pixwid = gtk_image_new_from_pixbuf (book_closed);
      g_object_set_data (child, "menu_pixmap", pixwid);
      
      $menu_box->pack_start ($pixwid, FALSE, TRUE, 0);
      gtk_misc_set_padding (GTK_MISC (pixwid), 3, 1);
      label = Gtk2::Label->new(buffer);
      $menu_box->pack_start ($label, FALSE, TRUE, 0);
      $menu_box->show_all;

      gtk_notebook_append_page_menu (notebook, child, label_box, menu_box);
    }
}

sub rotate_notebook (GtkButton   *button,
		 GtkNotebook *notebook)
{
  gtk_notebook_set_tab_pos (notebook, (notebook->tab_pos + 1) % 4);
}

sub show_all_pages
{
  my ($button, $notebook) = @_;
  gtk_container_foreach ($notebook, sub { shift->show });
}

sub notebook_type_changed (GtkWidget *optionmenu,
		       gpointer   data)
{
  GtkNotebook *notebook;
  gint i, c;

  enum {
    STANDARD,
    NOTABS,
    BORDERLESS,
    SCROLLABLE
  };

  notebook = GTK_NOTEBOOK (data);

  c = gtk_option_menu_get_history (GTK_OPTION_MENU (optionmenu));

  switch (c)
    {
    case STANDARD:
    ## standard notebook */
      gtk_notebook_set_show_tabs (notebook, TRUE);
      gtk_notebook_set_show_border (notebook, TRUE);
      gtk_notebook_set_scrollable (notebook, FALSE);
      break;

    case NOTABS:
    ## notabs notebook */
      gtk_notebook_set_show_tabs (notebook, FALSE);
      gtk_notebook_set_show_border (notebook, TRUE);
      break;

    case BORDERLESS:
    # # borderless */
      gtk_notebook_set_show_tabs (notebook, FALSE);
      gtk_notebook_set_show_border (notebook, FALSE);
      break;

    case SCROLLABLE:  
      ## scrollable */
      gtk_notebook_set_show_tabs (notebook, TRUE);
      gtk_notebook_set_show_border (notebook, TRUE);
      gtk_notebook_set_scrollable (notebook, TRUE);
      if (g_list_length (notebook->children) == 5)
	create_pages (notebook, 6, 15);
      
      return;
      break;
    }
  
  if (g_list_length (notebook->children) == 15)
    for (i = 0; i < 10; i++)
      gtk_notebook_remove_page (notebook, 5);
}

sub notebook_popup (GtkToggleButton *button,
		GtkNotebook     *notebook)
{
  if (button->active)
    gtk_notebook_popup_enable (notebook);
  else
    gtk_notebook_popup_disable (notebook);
}

sub notebook_homogeneous (GtkToggleButton *button,
		      GtkNotebook     *notebook)
{
  g_object_set (notebook, "homogeneous", button->active, NULL);
}

sub create_notebook (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *box1;
  GtkWidget *box2;
  GtkWidget *button;
  GtkWidget *separator;
  GtkWidget *omenu;
  GtkWidget *label;

  static gchar *items[] =
  {
    "Standard",
    "No tabs",
    "Borderless",
    "Scrollable"
  };
  
  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "notebook");
      gtk_container_set_border_width ($window, 0);

      box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);

      sample_notebook = gtk_notebook_new ();
      g_signal_connect (sample_notebook, "switch_page",
			\&page_switch, NULL);
      gtk_notebook_set_tab_pos (GTK_NOTEBOOK (sample_notebook), GTK_POS_TOP);
      $box1->pack_start ($sample_notebook, TRUE, TRUE, 0);
      gtk_container_set_border_width ($sample_notebook, 10);

      gtk_widget_realize (sample_notebook);

      if (!book_open)
	book_open = gdk_pixbuf_new_from_xpm_data ((const char **)book_open_xpm);
						  
      if (!book_closed)
	book_closed = gdk_pixbuf_new_from_xpm_data ((const char **)book_closed_xpm);

      create_pages (GTK_NOTEBOOK (sample_notebook), 1, 5);

      separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 10);
      
      box2 = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);

      button = gtk_check_button_new_with_label ("popup menu");
      $box2->pack_start ($button, TRUE, FALSE, 0);
      g_signal_connect (button, "clicked",
			\&notebook_popup,
			sample_notebook);

      button = gtk_check_button_new_with_label ("homogeneous tabs");
      $box2->pack_start ($button, TRUE, FALSE, 0);
      g_signal_connect (button, "clicked",
			\&notebook_homogeneous,
			sample_notebook);

      box2 = Gtk2::HBox->new(FALSE, 5);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);

      label = Gtk2::Label->new("Notebook Style :");
      $box2->pack_start ($label, FALSE, TRUE, 0);

      omenu = build_option_menu (items, G_N_ELEMENTS (items), 0,
				 notebook_type_changed,
				 sample_notebook);
      $box2->pack_start ($omenu, FALSE, TRUE, 0);

      button = Gtk2::Button->new("Show all Pages");
      $box2->pack_start ($button, FALSE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&show_all_pages, sample_notebook);

      box2 = Gtk2::HBox->new(TRUE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);

      button = Gtk2::Button->new("prev");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_notebook_prev_page,
				sample_notebook);
      $box2->pack_start ($button, TRUE, TRUE, 0);

      button = Gtk2::Button->new("next");
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_notebook_next_page,
				sample_notebook);
      $box2->pack_start ($button, TRUE, TRUE, 0);

      button = Gtk2::Button->new("rotate");
      g_signal_connect (button, "clicked",
			\&rotate_notebook, sample_notebook);
      $box2->pack_start ($button, TRUE, TRUE, 0);

      separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 5);

      button = Gtk2::Button->new("close");
      gtk_container_set_border_width ($button, 5);
      g_signal_connect_swapped (button, "clicked",
			        \&gtk_widget_destroy,
				window);
      $box1->pack_start ($button, FALSE, FALSE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

## GtkPanes

sub toggle_resize (GtkWidget *widget, GtkWidget *child)
{
  GtkPaned *paned = GTK_PANED (child->parent);
  gboolean is_child1 = (child == paned->child1);
  gboolean resize, shrink;

  resize = is_child1 ? paned->child1_resize : paned->child2_resize;
  shrink = is_child1 ? paned->child1_shrink : paned->child2_shrink;

  gtk_widget_ref (child);
  gtk_container_remove ($child>parent), child);
  if (is_child1)
    gtk_paned_pack1 (paned, child, !resize, shrink);
  else
    gtk_paned_pack2 (paned, child, !resize, shrink);
  gtk_widget_unref (child);
}

sub toggle_shrink (GtkWidget *widget, GtkWidget *child)
{
  GtkPaned *paned = GTK_PANED (child->parent);
  gboolean is_child1 = (child == paned->child1);
  gboolean resize, shrink;

  resize = is_child1 ? paned->child1_resize : paned->child2_resize;
  shrink = is_child1 ? paned->child1_shrink : paned->child2_shrink;

  gtk_widget_ref (child);
  gtk_container_remove ($child>parent), child);
  if (is_child1)
    gtk_paned_pack1 (paned, child, resize, !shrink);
  else
    gtk_paned_pack2 (paned, child, resize, !shrink);
  gtk_widget_unref (child);
}

sub paned_props_clicked (GtkWidget *button,
		     GObject   *paned)
{
  GtkWidget *window = create_prop_editor (paned, GTK_TYPE_PANED);
  
  gtk_window_set_title (window, "Paned Properties");
}

GtkWidget *
create_pane_options (GtkPaned    *paned,
		     const gchar *frame_label,
		     const gchar *label1,
		     const gchar *label2)
{
  GtkWidget *frame;
  GtkWidget *table;
  GtkWidget *label;
  GtkWidget *button;
  GtkWidget *check_button;
  
  frame = Gtk2::Frame->new (frame_label);
  gtk_container_set_border_width ($frame, 4);
  
  table = gtk_table_new (4, 2, 4);
  $frame->add($table);
  
  label = Gtk2::Label->new(label1);
  gtk_table_attach_defaults (GTK_TABLE (table), label,
			     0, 1, 0, 1);
  
  check_button = gtk_check_button_new_with_label ("Resize");
  gtk_table_attach_defaults (GTK_TABLE (table), check_button,
			     0, 1, 1, 2);
  g_signal_connect (check_button, "toggled",
		    \&toggle_resize,
		    paned->child1);
  
  check_button = gtk_check_button_new_with_label ("Shrink");
  gtk_table_attach_defaults (GTK_TABLE (table), check_button,
			     0, 1, 2, 3);
  gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (check_button),
			       TRUE);
  g_signal_connect (check_button, "toggled",
		    \&toggle_shrink,
		    paned->child1);
  
  label = Gtk2::Label->new(label2);
  gtk_table_attach_defaults (GTK_TABLE (table), label,
			     1, 2, 0, 1);
  
  check_button = gtk_check_button_new_with_label ("Resize");
  gtk_table_attach_defaults (GTK_TABLE (table), check_button,
			     1, 2, 1, 2);
  gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (check_button),
			       TRUE);
  g_signal_connect (check_button, "toggled",
		    \&toggle_resize,
		    paned->child2);
  
  check_button = gtk_check_button_new_with_label ("Shrink");
  gtk_table_attach_defaults (GTK_TABLE (table), check_button,
			     1, 2, 2, 3);
  gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (check_button),
			       TRUE);
  g_signal_connect (check_button, "toggled",
		    \&toggle_shrink,
		    paned->child2);

  button = gtk_button_new_with_mnemonic ("_Properties");
  gtk_table_attach_defaults (GTK_TABLE (table), button,
			     0, 2, 3, 4);
  g_signal_connect (button, "clicked",
		    \&paned_props_clicked,
		    paned);

  return frame;
}

sub create_panes (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *frame;
  GtkWidget *hpaned;
  GtkWidget *vpaned;
  GtkWidget *button;
  GtkWidget *vbox;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));
      
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "Panes");
      gtk_container_set_border_width ($window, 0);

      vbox = Gtk2::VBox->new(FALSE, 0);
      $window->add($vbox);
      
      vpaned = Gtk2::VPaned->new ();
      $vbox->pack_start ($vpaned, TRUE, TRUE, 0);
      gtk_container_set_border_width ($vpaned, 5);

      hpaned = Gtk2::HPaned->new ();
      gtk_paned_add1 (GTK_PANED (vpaned), hpaned);

      frame = Gtk2::Frame->new ;
      gtk_frame_set_shadow_type (GTK_FRAME(frame), GTK_SHADOW_IN);
      gtk_widget_set_size_request (frame, 60, 60);
      gtk_paned_add1 (GTK_PANED (hpaned), frame);
      
      button = Gtk2::Button->new("Hi there");
      $frame->add($button);

      frame = Gtk2::Frame->new ;
      gtk_frame_set_shadow_type (GTK_FRAME(frame), GTK_SHADOW_IN);
      gtk_widget_set_size_request (frame, 80, 60);
      gtk_paned_add2 (GTK_PANED (hpaned), frame);

      frame = Gtk2::Frame->new ;
      gtk_frame_set_shadow_type (GTK_FRAME(frame), GTK_SHADOW_IN);
      gtk_widget_set_size_request (frame, 60, 80);
      gtk_paned_add2 (GTK_PANED (vpaned), frame);

      ## Now create toggle buttons to control sizing */

	$vbox->pack_start ($			  create_pane_options (GTK_PANED (hpaned),
					       "Horizontal",
					       "Left",
					       "Right"),
			  FALSE, FALSE, 0);

      $vbox->pack_start ($			  create_pane_options (GTK_PANED (vpaned),
					       "Vertical",
					       "Top",
					       "Bottom"),
			  FALSE, FALSE, 0);

      $vbox->show_all;
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

# Paned keyboard navigation

static GtkWidget*
paned_keyboard_window1 (GtkWidget *widget)
{
  GtkWidget *window1;
  GtkWidget *hpaned1;
  GtkWidget *frame1;
  GtkWidget *vbox1;
  GtkWidget *button7;
  GtkWidget *button8;
  GtkWidget *button9;
  GtkWidget *vpaned1;
  GtkWidget *frame2;
  GtkWidget *frame5;
  GtkWidget *hbox1;
  GtkWidget *button5;
  GtkWidget *button6;
  GtkWidget *frame3;
  GtkWidget *frame4;
  GtkWidget *table1;
  GtkWidget *button1;
  GtkWidget *button2;
  GtkWidget *button3;
  GtkWidget *button4;

  window1 = Gtk2::Window->new('toplevel');
  gtk_window_set_title (window1, "Basic paned navigation");
  gtk_window_set_screen (window1, 
			 gtk_widget_get_screen (widget));

  hpaned1 = Gtk2::HPaned->new ();
  $window1->add($hpaned1);

  frame1 = Gtk2::Frame->new ;
  gtk_paned_pack1 (GTK_PANED (hpaned1), frame1, FALSE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame1), GTK_SHADOW_IN);

  vbox1 = Gtk2::VBox->new(FALSE, 0);
  $frame1->add($vbox1);

  button7 = Gtk2::Button->new("button7");
  $vbox1->pack_start ($button7, FALSE, FALSE, 0);

  button8 = Gtk2::Button->new("button8");
  $vbox1->pack_start ($button8, FALSE, FALSE, 0);

  button9 = Gtk2::Button->new("button9");
  $vbox1->pack_start ($button9, FALSE, FALSE, 0);

  vpaned1 = Gtk2::VPaned->new ();
  gtk_paned_pack2 (GTK_PANED (hpaned1), vpaned1, TRUE, TRUE);

  frame2 = Gtk2::Frame->new ;
  gtk_paned_pack1 (GTK_PANED (vpaned1), frame2, FALSE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame2), GTK_SHADOW_IN);

  frame5 = Gtk2::Frame->new ;
  $frame2->add($frame5);

  hbox1 = Gtk2::HBox->new(FALSE, 0);
  $frame5->add($hbox1);

  button5 = Gtk2::Button->new("button5");
  $hbox1->pack_start ($button5, FALSE, FALSE, 0);

  button6 = Gtk2::Button->new("button6");
  $hbox1->pack_start ($button6, FALSE, FALSE, 0);

  frame3 = Gtk2::Frame->new ;
  gtk_paned_pack2 (GTK_PANED (vpaned1), frame3, TRUE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame3), GTK_SHADOW_IN);

  frame4 = Gtk2::Frame->new ("Buttons");
  $frame3->add($frame4);
  gtk_container_set_border_width ($frame4, 15);

  table1 = gtk_table_new (2, 2, FALSE);
  $frame4->add($table1);
  gtk_container_set_border_width ($table1, 11);

  button1 = Gtk2::Button->new("button1");
  gtk_table_attach (GTK_TABLE (table1), button1, 0, 1, 0, 1,
                    (GtkAttachOptions) (GTK_FILL),
                    (GtkAttachOptions) (0), 0, 0);

  button2 = Gtk2::Button->new("button2");
  gtk_table_attach (GTK_TABLE (table1), button2, 1, 2, 0, 1,
                    (GtkAttachOptions) (GTK_FILL),
                    (GtkAttachOptions) (0), 0, 0);

  button3 = Gtk2::Button->new("button3");
  gtk_table_attach (GTK_TABLE (table1), button3, 0, 1, 1, 2,
                    (GtkAttachOptions) (GTK_FILL),
                    (GtkAttachOptions) (0), 0, 0);

  button4 = Gtk2::Button->new("button4");
  gtk_table_attach (GTK_TABLE (table1), button4, 1, 2, 1, 2,
                    (GtkAttachOptions) (GTK_FILL),
                    (GtkAttachOptions) (0), 0, 0);

  return window1;
}

static GtkWidget*
paned_keyboard_window2 (GtkWidget *widget)
{
  GtkWidget *window2;
  GtkWidget *hpaned2;
  GtkWidget *frame6;
  GtkWidget *button13;
  GtkWidget *hbox2;
  GtkWidget *vpaned2;
  GtkWidget *frame7;
  GtkWidget *button12;
  GtkWidget *frame8;
  GtkWidget *button11;
  GtkWidget *button10;

  window2 = Gtk2::Window->new('toplevel');
  gtk_window_set_title (window2, "\"button 10\" is not inside the horisontal pane");

  gtk_window_set_screen (window2, 
			 gtk_widget_get_screen (widget));

  hpaned2 = Gtk2::HPaned->new ();
  $window2->add($hpaned2);

  frame6 = Gtk2::Frame->new ;
  gtk_paned_pack1 (GTK_PANED (hpaned2), frame6, FALSE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame6), GTK_SHADOW_IN);

  button13 = Gtk2::Button->new("button13");
  $frame6->add($button13);

  hbox2 = Gtk2::HBox->new(FALSE, 0);
  gtk_paned_pack2 (GTK_PANED (hpaned2), hbox2, TRUE, TRUE);

  vpaned2 = Gtk2::VPaned->new ();
  $hbox2->pack_start ($vpaned2, TRUE, TRUE, 0);

  frame7 = Gtk2::Frame->new ;
  gtk_paned_pack1 (GTK_PANED (vpaned2), frame7, FALSE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame7), GTK_SHADOW_IN);

  button12 = Gtk2::Button->new("button12");
  $frame7->add($button12);

  frame8 = Gtk2::Frame->new ;
  gtk_paned_pack2 (GTK_PANED (vpaned2), frame8, TRUE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame8), GTK_SHADOW_IN);

  button11 = Gtk2::Button->new("button11");
  $frame8->add($button11);

  button10 = Gtk2::Button->new("button10");
  $hbox2->pack_start ($button10, FALSE, FALSE, 0);

  return window2;
}

sub paned_keyboard_window3
{
  my ($widget) = @_;
  my $window3 = Gtk2::Window->new('toplevel');
  $window3->set_data("window3" => window3);
  $window3->set_title("Nested panes");
  $window3->set_screen($widget->get_screen);
  my $vbox2 = Gtk2::VBox->new(FALSE, 0);
  $window3->add($vbox2);
  my $label1 = Gtk2::Label->new("Three panes nested inside each other");
  $vbox2->pack_start($label1, FALSE, FALSE, 0);
  my $hpaned3 = Gtk2::HPaned->new;
  $vbox2->pack_start ($hpaned3, TRUE, TRUE, 0);
  my $frame9 = Gtk2::Frame->new ;
  $hpaned3->pack1($frame9, FALSE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame9), GTK_SHADOW_IN);
  my $button14 = Gtk2::Button->new("button14");
  $frame9->add($button14);
  my $hpaned4 = Gtk2::HPaned->new;
  gtk_paned_pack2 (GTK_PANED (hpaned3), hpaned4, TRUE, TRUE);
  my $frame10 = Gtk2::Frame->new ;
  gtk_paned_pack1 (GTK_PANED (hpaned4), frame10, FALSE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame10), GTK_SHADOW_IN);
  my $button15 = Gtk2::Button->new("button15");
  $frame10->add($button15);
  my $hpaned5 = Gtk2::HPaned->new;
  gtk_paned_pack2 (GTK_PANED (hpaned4), hpaned5, TRUE, TRUE);
  my $frame11 = Gtk2::Frame->new ;
  gtk_paned_pack1 (GTK_PANED (hpaned5), frame11, FALSE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame11), GTK_SHADOW_IN);
  my $button16 = Gtk2::Button->new("button16");
  $frame11->add($button16);
  my $frame12 = Gtk2::Frame->new ;
  gtk_paned_pack2 (GTK_PANED (hpaned5), frame12, TRUE, TRUE);
  gtk_frame_set_shadow_type (GTK_FRAME (frame12), GTK_SHADOW_IN);
  my $button17 = Gtk2::Button->new("button17");
  $frame12->add($button17);
  return $window3;
}

sub paned_keyboard_window4
{
  my ($widget) = @_;
  GtkWidget *vbox3;
  GtkWidget *label2;
  GtkWidget *hpaned6;
  GtkWidget *vpaned3;
  GtkWidget *button19;
  GtkWidget *button18;
  GtkWidget *hbox3;
  GtkWidget *vpaned4;
  GtkWidget *button21;
  GtkWidget *button20;
  GtkWidget *vpaned5;
  GtkWidget *button23;
  GtkWidget *button22;
  GtkWidget *vpaned6;
  GtkWidget *button25;
  GtkWidget *button24;

  my $window4 = Gtk2::Window->new('toplevel');
  $window4->set_data("window4" => $window4);
  gtk_window_set_title (window4, "window4");

  gtk_window_set_screen (window4, 
			 gtk_widget_get_screen (widget));

  vbox3 = Gtk2::VBox->new(FALSE, 0);
  $window4->add($vbox3);

  label2 = Gtk2::Label->new("Widget tree:\n\nhpaned \n - vpaned\n - hbox\n    - vpaned\n    - vpaned\n    - vpaned\n");
  $vbox3->pack_start ($label2, FALSE, FALSE, 0);
  gtk_label_set_justify (GTK_LABEL (label2), GTK_JUSTIFY_LEFT);

  hpaned6 = Gtk2::HPaned->new;
  $vbox3->pack_start ($hpaned6, TRUE, TRUE, 0);

  vpaned3 = Gtk2::VPaned->new;
  gtk_paned_pack1 (GTK_PANED (hpaned6), vpaned3, FALSE, TRUE);

  button19 = Gtk2::Button->new("button19");
  gtk_paned_pack1 (GTK_PANED (vpaned3), button19, FALSE, TRUE);

  button18 = Gtk2::Button->new("button18");
  gtk_paned_pack2 (GTK_PANED (vpaned3), button18, TRUE, TRUE);

  hbox3 = Gtk2::HBox->new(FALSE, 0);
  gtk_paned_pack2 (GTK_PANED (hpaned6), hbox3, TRUE, TRUE);

  vpaned4 = Gtk2::VPaned->new;
  $hbox3->pack_start ($vpaned4, TRUE, TRUE, 0);

  button21 = Gtk2::Button->new("button21");
  gtk_paned_pack1 (GTK_PANED (vpaned4), button21, FALSE, TRUE);

  button20 = Gtk2::Button->new("button20");
  gtk_paned_pack2 (GTK_PANED (vpaned4), button20, TRUE, TRUE);

  vpaned5 = Gtk2::VPaned->new;
  $hbox3->pack_start ($vpaned5, TRUE, TRUE, 0);

  button23 = Gtk2::Button->new("button23");
  gtk_paned_pack1 (GTK_PANED (vpaned5), button23, FALSE, TRUE);

  button22 = Gtk2::Button->new("button22");
  gtk_paned_pack2 (GTK_PANED (vpaned5), button22, TRUE, TRUE);

  vpaned6 = Gtk2::VPaned->new;
  $hbox3->pack_start ($vpaned6, TRUE, TRUE, 0);

  button25 = Gtk2::Button->new("button25");
  gtk_paned_pack1 (GTK_PANED (vpaned6), button25, FALSE, TRUE);

  button24 = Gtk2::Button->new("button24");
  gtk_paned_pack2 (GTK_PANED (vpaned6), button24, TRUE, TRUE);

  return window4;
}

sub create_paned_keyboard_navigation (GtkWidget *widget)
{
  static GtkWidget *window1 = NULL;
  static GtkWidget *window2 = NULL;
  static GtkWidget *window3 = NULL;
  static GtkWidget *window4 = NULL;

  if (window1 && 
     (gtk_widget_get_screen (window1) != gtk_widget_get_screen (widget)))
    {
      gtk_widget_destroy (window1);
      gtk_widget_destroy (window2);
      gtk_widget_destroy (window3);
      gtk_widget_destroy (window4);
    }
  
  if (!window1)
    {
      window1 = paned_keyboard_window1 (widget);
      g_signal_connect (window1, "destroy",
			\&gtk_widget_destroyed,
			&window1);
    }

  if (!window2)
    {
      window2 = paned_keyboard_window2 (widget);
      g_signal_connect (window2, "destroy",
			\&gtk_widget_destroyed,
			&window2);
    }

  if (!window3)
    {
      window3 = paned_keyboard_window3 (widget);
      g_signal_connect (window3, "destroy",
			\&gtk_widget_destroyed,
			&window3);
    }

  if (!window4)
    {
      window4 = paned_keyboard_window4 (widget);
      g_signal_connect (window4, "destroy",
			\&gtk_widget_destroyed,
			&window4);
    }

  if (GTK_WIDGET_VISIBLE (window1))
    gtk_widget_destroy (GTK_WIDGET (window1));
  else
    $window->show_all;

  if (GTK_WIDGET_VISIBLE (window2))
    gtk_widget_destroy (GTK_WIDGET (window2));
  else
    $window2->show_all;

  if (GTK_WIDGET_VISIBLE (window3))
    gtk_widget_destroy (window3);
  else
    $window3->show_all;

  if (GTK_WIDGET_VISIBLE (window4))
    gtk_widget_destroy (window4);
  else
    $window4->show_all;
}


## Shaped Windows

typedef struct _cursoroffset {gint x,y;} CursorOffset;

sub shape_pressed (GtkWidget *widget, GdkEventButton *event)
{
  CursorOffset *p;

  ## ignore double and triple click */
  if (event->type != GDK_BUTTON_PRESS)
    return;

  p = g_object_get_data (widget, "cursor_offset");
  p->x = (int) event->x;
  p->y = (int) event->y;

  gtk_grab_add (widget);
  gdk_pointer_grab (widget->window, TRUE,
		    GDK_BUTTON_RELEASE_MASK |
		    GDK_BUTTON_MOTION_MASK |
		    GDK_POINTER_MOTION_HINT_MASK,
		    NULL, NULL, 0);
}

sub shape_released (GtkWidget *widget)
{
  gtk_grab_remove (widget);
  gdk_display_pointer_ungrab (gtk_widget_get_display (widget),
			      GDK_CURRENT_TIME);
}

sub shape_motion (GtkWidget      *widget, 
	      GdkEventMotion *event)
{
  gint xp, yp;
  #CursorOffset * p;
  GdkModifierType mask;
  my $p = g_object_get_data (widget, "cursor_offset");
  # Can't use event->x / event->y here  because I need absolute coordinates.
  gdk_window_get_pointer (NULL, &xp, &yp, &mask);
  gtk_widget_set_uposition (widget, xp  - p->x, yp  - p->y);
}

sub shape_create_icon(GdkScreen *screen,
		      char      *xpm_file,
		      gint       x,
		      gint       y,
		   gint       px,
		   gint       py,
		      gint       window_type)
  {
  GtkWidget *window;
  GtkWidget *pixmap;
  GtkWidget *fixed;
  CursorOffset* icon_pos;
  GdkGC* gc;
  GdkBitmap *gdk_pixmap_mask;
  GdkPixmap *gdk_pixmap;
  GtkStyle *style;

  style = gtk_widget_get_default_style;
  gc = style->black_gc;	
  #   * GDK_WINDOW_TOPLEVEL works also, giving you a title border
  window = gtk_window_new (window_type);
  gtk_window_set_screen (window, screen);
  
  fixed = gtk_fixed_new;
  gtk_widget_set_size_request (fixed, 100, 100);
  $window->add($fixed);
  $fixed->show;
  
  gtk_widget_set_events (window, 
			 gtk_widget_get_events (window) |
			 GDK_BUTTON_MOTION_MASK |
			 GDK_POINTER_MOTION_HINT_MASK |
			 GDK_BUTTON_PRESS_MASK);

  gtk_widget_realize (window);
  gdk_pixmap = gdk_pixmap_create_from_xpm (window->window, &gdk_pixmap_mask, 
					   &style->bg->[GTK_STATE_NORMAL],
					   xpm_file);

  pixmap = gtk_image_new_from_pixmap (gdk_pixmap, gdk_pixmap_mask);
  gtk_fixed_put (GTK_FIXED (fixed), pixmap, px,py);
  $pixmap->show;
  
  gtk_widget_shape_combine_mask (window, gdk_pixmap_mask, px, py);
  
  g_object_unref (gdk_pixmap_mask);
  g_object_unref (gdk_pixmap);

  g_signal_connect (window, "button_press_event",
		    \&shape_pressed, NULL);
  g_signal_connect (window, "button_release_event",
		    \&shape_released, NULL);
  g_signal_connect (window, "motion_notify_event",
		    \&shape_motion, NULL);

  icon_pos = g_new (CursorOffset, 1);
  g_object_set_data (window, "cursor_offset", icon_pos);

  gtk_widget_set_uposition (window, x, y);
  $window->show;
  
  return window;
}


sub create_shapes
{
  my ($widget) = @_;
  ## Variables used by the Drag/Drop and Shape Window demos */
  static GtkWidget *modeller = NULL;
  static GtkWidget *sheets = NULL;
  static GtkWidget *rings = NULL;
  static GtkWidget *with_region = NULL;
  GdkScreen *screen = gtk_widget_get_screen (widget);
  
  return if (! -e "Modeller.xpm" && -e "FilesQueue.xpm" && -e "3DRings.xpm")
  

  if (!modeller)
    {
      modeller = shape_create_icon (screen, "Modeller.xpm",
				    440, 140, 0,0, GTK_WINDOW_POPUP);

      g_signal_connect (modeller, "destroy",
			\&gtk_widget_destroyed,
			&modeller);
    }
  else
    gtk_widget_destroy (modeller);

  if (!sheets)
    {
      sheets = shape_create_icon (screen, "FilesQueue.xpm",
				  580, 170, 0,0, GTK_WINDOW_POPUP);

      g_signal_connect (sheets, "destroy",
			\&gtk_widget_destroyed,
			&sheets);

    }
  else
    gtk_widget_destroy (sheets);

  if (!rings)
    {
      rings = shape_create_icon (screen, "3DRings.xpm",
				 460, 270, 25,25, GTK_WINDOW_TOPLEVEL);

      g_signal_connect (rings, "destroy",
			\&gtk_widget_destroyed,
			&rings);
    }
  else
    gtk_widget_destroy (rings);

  if (!with_region)
    {
      GdkRegion *region;
      gint x, y;
      with_region = shape_create_icon (screen, "3DRings.xpm",
                                       460, 270, 25,25, GTK_WINDOW_TOPLEVEL);
      gtk_window_set_decorated (with_region, FALSE);
      g_signal_connect (with_region, "destroy",
			\&gtk_widget_destroyed,
			&with_region);

      ## reset shape from mask to a region */
      x = 0;
      y = 0;
      region = gdk_region_new;

      while (x < 460)
        {
          while (y < 270)
            {
              GdkRectangle rect;
              rect.x = x;
              rect.y = y;
              rect.width = 10;
              rect.height = 10;

              gdk_region_union_with_rect (region, &rect);
              
              y += 20;
            }
          y = 0;
          x += 20;
        }

      gdk_window_shape_combine_region (with_region->window,
                                       region,
                                       0, 0);
    }
  else
    gtk_widget_destroy (with_region);
}

# WM Hints demo

sub create_wmhints (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *label;
  GtkWidget *separator;
  GtkWidget *button;
  GtkWidget *box1;
  GtkWidget *box2;

  GdkBitmap *circles;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));
      
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "WM Hints");
      gtk_container_set_border_width ($window, 0);

      gtk_widget_realize (window);
      
      circles = gdk_bitmap_create_from_data (window->window,
					     circles_bits,
					     circles_width,
					     circles_height);
      gdk_window_set_icon (window->window, NULL,
			   circles, circles);
      
      gdk_window_set_icon_name (window->window, "WMHints Test Icon");
  
      gdk_window_set_decorations (window->window, GDK_DECOR_ALL | GDK_DECOR_MENU);
      gdk_window_set_functions (window->window, GDK_FUNC_ALL | GDK_FUNC_RESIZE);
      
      box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);
      $box1->show;

      label = Gtk2::Label->new("Try iconizing me!");
      gtk_widget_set_size_request (label, 150, 50);
      $box1->pack_start ($label, TRUE, TRUE, 0);
      $label->show;


      separator = Gtk2::HSeparator->new;
      $box1->pack_start ($separator, FALSE, TRUE, 0);
      $separator->show;


      box2 = Gtk2::VBox->new(FALSE, 10);
      gtk_container_set_border_width ($box2, 10);
      $box1->pack_start ($box2, FALSE, TRUE, 0);
      $box2->show;


      button = Gtk2::Button->new("close");

      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				window);

      $box2->pack_start ($button, TRUE, TRUE, 0);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
      $button->show;
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}


# * Window state tracking

sub window_state_callback (GtkWidget *widget,
                       GdkEventWindowState *event,
                       gpointer data)
{
  GtkWidget *label = data;
  gchar *msg;

  msg = g_strconcat (widget->title, ": ",
                     (event->new_window_state & GDK_WINDOW_STATE_WITHDRAWN) ?
                     "withdrawn" : "not withdrawn", ", ",
                     (event->new_window_state & GDK_WINDOW_STATE_ICONIFIED) ?
                     "iconified" : "not iconified", ", ",
                     (event->new_window_state & GDK_WINDOW_STATE_STICKY) ?
                     "sticky" : "not sticky", ", ",
                     (event->new_window_state & GDK_WINDOW_STATE_MAXIMIZED) ?
                     "maximized" : "not maximized", ", ",
                     (event->new_window_state & GDK_WINDOW_STATE_FULLSCREEN) ?
                     "fullscreen" : "not fullscreen",
                     NULL);
  
  gtk_label_set_text (GTK_LABEL (label), msg);

  g_free (msg);

  return FALSE;
}

sub tracking_label (GtkWidget *window)
{
  GtkWidget *label;
  GtkWidget *hbox;
  GtkWidget *button;

  hbox = Gtk2::HBox->new(FALSE, 5);

  g_signal_connect_object (hbox,
			   "destroy",
			   \&gtk_widget_destroy,
			   window,
			   G_CONNECT_SWAPPED);
  
  label = Gtk2::Label->new("<no window state events received>");
  gtk_label_set_line_wrap (GTK_LABEL (label), TRUE);
  $hbox->pack_start ($label, FALSE, FALSE, 0);
  
  g_signal_connect (window,
		    "window_state_event",
		    \&window_state_callback,
		    label);

  button = Gtk2::Button->new("Deiconify");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_deiconify,
                           window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (hbox, button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Iconify");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_iconify,
                           window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (hbox, button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Fullscreen");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_fullscreen,
                           window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (hbox, button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Unfullscreen");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_unfullscreen,
                           window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (hbox, button, FALSE, FALSE, 0);
  
  button = Gtk2::Button->new("Present");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_present,
                           window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (hbox, button, FALSE, FALSE, 0);

  $button = Gtk2::Button->new("Show");
  $button->signal_connect_object("clicked" => \&Gtk2::Widget::show, $window, G_CONNECT_SWAPPED);
  gtk_box_pack_end (hbox, button, FALSE, FALSE, 0);
  $hbox->show_all;
  return $hbox;
}

static GtkWidget*
get_state_controls (GtkWidget *window)
{
  GtkWidget *vbox;
  GtkWidget *button;

  vbox = Gtk2::VBox->new(FALSE, 0);
  
  button = Gtk2::Button->new("Stick");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_stick,
			   window,
			   G_CONNECT_SWAPPED);
  $vbox->pack_start ($button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Unstick");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_unstick,
			   window,
			   G_CONNECT_SWAPPED);
  $vbox->pack_start ($button, FALSE, FALSE, 0);
  
  button = Gtk2::Button->new("Maximize");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_maximize,
			   window,
			   G_CONNECT_SWAPPED);
  $vbox->pack_start ($button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Unmaximize");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_unmaximize,
			   window,
			   G_CONNECT_SWAPPED);
  $vbox->pack_start ($button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Iconify");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_iconify,
			   window,
			   G_CONNECT_SWAPPED);
  $vbox->pack_start ($button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Fullscreen");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_fullscreen,
                           window,
			   G_CONNECT_SWAPPED);
  $vbox->pack_start ($button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Unfullscreen");
  g_signal_connect_object (button,
			   "clicked",
                           \&gtk_window_unfullscreen,
			   window,
			   G_CONNECT_SWAPPED);
  $vbox->pack_start ($button, FALSE, FALSE, 0);
  
  button = Gtk2::Button->new("Hide (withdraw)");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_widget_hide,
			   window,
			   G_CONNECT_SWAPPED);
  $vbox->pack_start ($button, FALSE, FALSE, 0);
  
$vbox->show_all;

  return vbox;
}

sub create_window_states (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *label;
  GtkWidget *box1;
  GtkWidget *iconified;
  GtkWidget *normal;
  GtkWidget *controls;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "Window states");
      
      box1 = Gtk2::VBox->new(FALSE, 0);
      $window->add($box1);

      iconified = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (iconified,
			     gtk_widget_get_screen (widget));
      
      g_signal_connect_object (iconified, "destroy",
			       \&gtk_widget_destroy,
			       window,
			       G_CONNECT_SWAPPED);
      gtk_window_iconify (iconified);
      gtk_window_set_title (iconified, "Iconified initially");
      controls = get_state_controls (iconified);
      $iconified->add($controls);
      
      normal = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (normal,
			     gtk_widget_get_screen (widget));
      
      g_signal_connect_object (normal, "destroy",
			       \&gtk_widget_destroy,
			       window,
			       G_CONNECT_SWAPPED);
      
      gtk_window_set_title (normal, "Deiconified initially");
      controls = get_state_controls (normal);
      $normal->add($controls);
      
      label = tracking_label (iconified);
      $box1->add($label);

      label = tracking_label (normal);
      $box1->add($label);

      $iconified->show_all;
      $normal->show_all;
      $box1->show_all;
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show;
  else
    gtk_widget_destroy (window);
}

# * Window sizing

sub configure_event_callback (GtkWidget *widget,
			      GdkEventConfigure *event,
			      gpointer data)
{
  GtkWidget *label = data;
  gchar *msg;
  gint x, y;
  
  gtk_window_get_position (widget, &x, &y);
  
  msg = g_strdup_printf ("event: %d,%d  %d x %d\n"
                         "position: %d, %d",
                         event->x, event->y, event->width, event->height,
                         x, y);
  
  gtk_label_set_text (GTK_LABEL (label), msg);

  g_free (msg);

  return FALSE;
}

sub get_ints (GtkWidget *window,
          gint      *a,
          gint      *b)
{
  GtkWidget *spin1;
  GtkWidget *spin2;

  spin1 = g_object_get_data (window, "spin1");
  spin2 = g_object_get_data (window, "spin2");

  *a = gtk_spin_button_get_value_as_int (GTK_SPIN_BUTTON (spin1));
  *b = gtk_spin_button_get_value_as_int (GTK_SPIN_BUTTON (spin2));
}

sub set_size_callback (GtkWidget *widget,
                   gpointer   data)
{
  gint w, h;
  
  get_ints (data, &w, &h);

  gtk_window_resize (g_object_get_data (data, "target"), w, h);
}

sub unset_default_size_callback (GtkWidget *widget,
                             gpointer   data)
{
  gtk_window_set_default_size (g_object_get_data (data, "target"),
                               -1, -1);
}

sub set_default_size_callback (GtkWidget *widget,
                           gpointer   data)
{
  gint w, h;
  
  get_ints (data, &w, &h);

  gtk_window_set_default_size (g_object_get_data (data, "target"),
                               w, h);
}

sub unset_size_request_callback (GtkWidget *widget,
			     gpointer   data)
{
  gtk_widget_set_size_request (g_object_get_data (data, "target"),
                               -1, -1);
}

sub set_size_request_callback (GtkWidget *widget,
			   gpointer   data)
{
  gint w, h;
  
  get_ints (data, &w, &h);

  gtk_widget_set_size_request (g_object_get_data (data, "target"),
                               w, h);
}

sub set_location_callback (GtkWidget *widget,
                       gpointer   data)
{
  gint x, y;
  
  get_ints (data, &x, &y);

  gtk_window_move (g_object_get_data (data, "target"), x, y);
}

sub move_to_position_callback (GtkWidget *widget,
                           gpointer   data)
{
  gint x, y;
  GtkWindow *window;

  window = g_object_get_data (data, "target");
  
  gtk_window_get_position (window, &x, &y);

  gtk_window_move (window, x, y);
}

sub set_geometry_callback (GtkWidget *entry,
                       gpointer   data)
{
  gchar *text;
  GtkWindow *target;

  target = g_object_get_data (data, "target");
  
  text = gtk_editable_get_chars (GTK_EDITABLE (entry), 0, -1);

  if (!gtk_window_parse_geometry (target, text))
    g_print ("Bad geometry string '%s'\n", text);

  g_free (text);
}

sub allow_shrink_callback (GtkWidget *widget,
                       gpointer   data)
{
  g_object_set (g_object_get_data (data, "target"),
                "allow_shrink",
                GTK_TOGGLE_BUTTON (widget)->active,
                NULL);
}

sub allow_grow_callback (GtkWidget *widget,
                     gpointer   data)
{
  g_object_set (g_object_get_data (data, "target"),
                "allow_grow",
                GTK_TOGGLE_BUTTON (widget)->active,
                NULL);
}

sub gravity_selected (GtkWidget *widget,
                  gpointer   data)
{
  gtk_window_set_gravity (g_object_get_data (data, "target"),
                          gtk_option_menu_get_history (GTK_OPTION_MENU (widget)) + GDK_GRAVITY_NORTH_WEST);
}

sub pos_selected (GtkWidget *widget,
              gpointer   data)
{
  gtk_window_set_position (g_object_get_data (data, "target"),
                           gtk_option_menu_get_history (GTK_OPTION_MENU (widget)) + GTK_WIN_POS_NONE);
}

sub move_gravity_window_to_current_position
{
  my ($widget, $data) = @_;
  my ($x, $y) = $data->get_position;
  $window->move($x, $y);
}

sub get_screen_corner {
  my ($window, $x, $y) = @_;
  my $screen = $window->get_screen;
  my ($w, $h) = $window->get_size;
  my $grav = $window->get_gravity; 
  return ($screen->get_width - $w, $screen->get_height - $h) if $grav == GDK_GRAVITY_SOUTH_EAST;
  return ($screen->get_width - $w, 0) if $grav == GDK_GRAVITY_NORTH_EAST;
  return (0, $screen->get_height - $h) if $grav == GDK_GRAVITY_SOUTH_WEST;
  return (0, 0) if $grav == GDK_GRAVITY_NORTH_WEST;
  return (($screen->get_width - $w) / 2, $screen->get_height - $h) if $grav == GDK_GRAVITY_SOUTH;
  return (($screen->get_width - $w) / 2, 0) if $grav == GDK_GRAVITY_NORTH;
  return (0, ($screen->get_height - $h) / 2) if $grav == GDK_GRAVITY_WEST;
  return ($screen->get_width - $w, ($screen->get_height - $h) / 2) if $grav == GDK_GRAVITY_EAST;
  return (($screen->get_width - $w) / 2, ($screen->get_height - $h) / 2) if $grav == GDK_GRAVITY_CENTER;
  return (350, 350) if $grav == GDK_GRAVITY_STATIC;
  die ("Should not be reached!");
}

sub move_gravity_window_to_starting_position 
{
  my ($widget,$data) = @_;
  my $window = data;    
  my ($x,$y) = get_screen_corner($window);
  $window->move($x, $y);
}

sub make_gravity_window 
{
  my ($destroy_with,$gravity,$title) = @_;
  my $window = Gtk2::Window->new('toplevel');
  $window->set_screen($destroy_with->get_screen);
  my $vbox = Gtk2::VBox->new(FALSE, 0);
  $vbox->show;
  $window->add($vbox);
  $window->set_title($title);
  $window->set_gravity($gravity);
  $destroy_with->signal_connect_object("destroy" => \&gtk_widget_destroy,
				       $window, G_CONNECT_SWAPPED);
  my $button = Gtk2::Button->new_with_mnemonic("_Move to current position");
  $button->signal_connect("clicked" => \&move_gravity_window_to_current_position, $window);
  $vbox->add($button);
  $button->show;
  $button = Gtk2::Button->new_with_mnemonic("Move to _starting position");
  $button->signal_connect("clicked" => \&move_gravity_window_to_starting_position, $window);
  $vbox->add($button);
  $button->show;
  # Pretend this is the result of --geometry.
  # DO NOT COPY THIS CODE unless you are setting --geometry results,
  #* and in that case you probably should just use gtk_window_parse_geometry().
  #* AGAIN, DO NOT SET GDK_HINT_USER_POS! It violates the ICCCM unless
  #* you are parsing --geometry or equivalent.
  $window->set_geometry_hints(undef, undef, GDK_HINT_USER_POS);
  $window->set_default_size(200, 200);
  my ($x,$y) = get_screen_corner($window);
  $window->move($x, $y);
  return $window;
}

sub do_gravity_test (GtkWidget *widget,
                 gpointer   data)
{
  GtkWidget *destroy_with = data;
  GtkWidget *window;
  
  # We put a window at each gravity point on the screen. */
  window = make_gravity_window (destroy_with, GDK_GRAVITY_NORTH_WEST,
                                "NorthWest");
  $window->show;
  
  window = make_gravity_window (destroy_with, GDK_GRAVITY_SOUTH_EAST,
                                "SouthEast");
  $window->show;

  window = make_gravity_window (destroy_with, GDK_GRAVITY_NORTH_EAST,
                                "NorthEast");
  $window->show;

  window = make_gravity_window (destroy_with, GDK_GRAVITY_SOUTH_WEST,
                                "SouthWest");
  $window->show;

  window = make_gravity_window (destroy_with, GDK_GRAVITY_SOUTH,
                                "South");
  $window->show;

  window = make_gravity_window (destroy_with, GDK_GRAVITY_NORTH,
                                "North");
  $window->show;

  
  window = make_gravity_window (destroy_with, GDK_GRAVITY_WEST,
                                "West");
  $window->show;

    
  window = make_gravity_window (destroy_with, GDK_GRAVITY_EAST,
                                "East");
  $window->show;

  window = make_gravity_window (destroy_with, GDK_GRAVITY_CENTER,
                                "Center");
  $window->show;

  window = make_gravity_window (destroy_with, GDK_GRAVITY_STATIC,
                                "Static");
  $window->show;
}

sub window_controls
{
  my $window = shift;
  GtkWidget *label;
  GtkWidget *button;
  GtkWidget *spin;
  GtkAdjustment *adj;
  GtkWidget *entry;
  GtkWidget *menu;
  my $control_window = Gtk2::Window->new('toplevel');
  $control_window->set_screen($window->get_screen);
  $control_window->set_title("Size controls");
  $control_window->set_data("target" => $window);
  $control_window->signal_connect_object("destroy" => \&Gtk2::Widget::destroy, $window, G_CONNECT_SWAPPED);
  my $vbox = Gtk2::VBox->new(FALSE, 5);
  
  $control_window->add($vbox);
  
  label = Gtk2::Label->new("<no configure events>");
  $vbox->pack_start ($label, FALSE, FALSE, 0);
  
  g_signal_connect (window,
		    "configure_event",
		    \&configure_event_callback,
		    label);

  adj = (GtkAdjustment *) gtk_adjustment_new (10.0, -2000.0, 2000.0, 1.0,
                                              5.0, 0.0);
  spin = gtk_spin_button_new (adj, 0, 0);

  $vbox->pack_start ($spin, FALSE, FALSE, 0);

  g_object_set_data (control_window, "spin1", spin);

  adj = (GtkAdjustment *) gtk_adjustment_new (10.0, -2000.0, 2000.0, 1.0,
                                              5.0, 0.0);
  spin = gtk_spin_button_new (adj, 0, 0);

  $vbox->pack_start ($spin, FALSE, FALSE, 0);

  g_object_set_data (control_window, "spin2", spin);

  entry = Gtk2::Entry->new;
  $vbox->pack_start ($entry, FALSE, FALSE, 0);

  g_signal_connect (entry, "changed",
		    \&set_geometry_callback,
		    control_window);

  button = Gtk2::Button->new("Show gravity test windows");
  g_signal_connect_swapped (button,
			    "clicked",
			    \&do_gravity_test,
			    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Reshow with initial size");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_window_reshow_with_initial_size,
			   window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);
  
  button = Gtk2::Button->new("Queue resize");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_widget_queue_resize,
			   window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);
  
  button = Gtk2::Button->new("Resize");
  g_signal_connect (button,
		    "clicked",
		    \&set_size_callback,
		    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Set default size");
  g_signal_connect (button,
		    "clicked",
		    \&set_default_size_callback,
		    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Unset default size");
  g_signal_connect (button,
		    "clicked",
		    \&unset_default_size_callback,
                    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);
  
  button = Gtk2::Button->new("Set size request");
  g_signal_connect (button,
		    "clicked",
		    \&set_size_request_callback,
		    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Unset size request");
  g_signal_connect (button,
		    "clicked",
		    \&unset_size_request_callback,
                    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);
  
  button = Gtk2::Button->new("Move");
  g_signal_connect (button,
		    "clicked",
		    \&set_location_callback,
		    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);

  button = Gtk2::Button->new("Move to current position");
  g_signal_connect (button,
		    "clicked",
		    \&move_to_position_callback,
		    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);
  
  button = gtk_check_button_new_with_label ("Allow shrink");
  gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (button), FALSE);
  g_signal_connect (button,
		    "toggled",
		    \&allow_shrink_callback,
		    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);

  button = gtk_check_button_new_with_label ("Allow grow");
  gtk_toggle_button_set_active (GTK_TOGGLE_BUTTON (button), TRUE);
  g_signal_connect (button,
		    "toggled",
		    \&allow_grow_callback,
                    control_window);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);
  
  button = gtk_button_new_with_mnemonic ("_Show");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_widget_show,
			   window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);

  button = gtk_button_new_with_mnemonic ("_Hide");
  g_signal_connect_object (button,
			   "clicked",
			   \&gtk_widget_hide,
                           window,
			   G_CONNECT_SWAPPED);
  gtk_box_pack_end (vbox, button, FALSE, FALSE, 0);
  
  menu = Gtk2::Menu->new;
  
  i = 0;
  while (i < 10)
    {
      GtkWidget *mi;
      static gchar *names[] = {
        "GDK_GRAVITY_NORTH_WEST",
        "GDK_GRAVITY_NORTH",
        "GDK_GRAVITY_NORTH_EAST",
        "GDK_GRAVITY_WEST",
        "GDK_GRAVITY_CENTER",
        "GDK_GRAVITY_EAST",
        "GDK_GRAVITY_SOUTH_WEST",
        "GDK_GRAVITY_SOUTH",
        "GDK_GRAVITY_SOUTH_EAST",
        "GDK_GRAVITY_STATIC",
        NULL
      };

      g_assert (names[i]);
      
      mi = gtk_menu_item_new_with_label (names[i]);

      gtk_menu_shell_append (GTK_MENU_SHELL (menu), mi);

      ++i;
    }
  
  $menu->show_all;
  
  my $om = Gtk2::OptionMenu->new;
  gtk_option_menu_set_menu (GTK_OPTION_MENU (om), menu);
  

  g_signal_connect (om,
		    "changed",
		    \&gravity_selected,
		    control_window);

  gtk_box_pack_end (vbox, om, FALSE, FALSE, 0);


  $menu = Gtk2::Menu->new;
  for ($i = 0; $i < 5; $i++)
    {
      my $names = ["GTK_WIN_POS_NONE",
		   "GTK_WIN_POS_CENTER",
		   "GTK_WIN_POS_MOUSE",
		   "GTK_WIN_POS_CENTER_ALWAYS",
		   "GTK_WIN_POS_CENTER_ON_PARENT"
		  ];
      g_assert (names[i]);
      my $mi = Gtk2::MenuItem->new($names[i]);
      $menu->append($mi);
    }
  $menu->show_all;
  $om = Gtk2::OptionMenu->new;
  gtk_option_menu_set_menu (GTK_OPTION_MENU (om), menu);
  

  g_signal_connect (om,
		    "changed",
		    \&pos_selected,
		    control_window);

  gtk_box_pack_end (vbox, om, FALSE, FALSE, 0);
  
  $vbox->show_all;
  
  return control_window;
}

sub create_window_sizing (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  static GtkWidget *target_window = NULL;

  if (!target_window)
    {
      GtkWidget *label;
      
      target_window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (target_window,
			     gtk_widget_get_screen (widget));
      label = Gtk2::Label->new;
      gtk_label_set_markup (GTK_LABEL (label), "<span foreground=\"purple\"><big>Window being resized</big></span>\nBlah blah blah blah\nblah blah blah\nblah blah blah blah blah");
      $target_window->add($label);
      gtk_widget_show (label);
      
      g_signal_connect (target_window, "destroy",
			\&gtk_widget_destroyed,
			&target_window);

      window = window_controls (target_window);
      
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);
      
      gtk_window_set_title (target_window, "Window to size");
    }

  # don't show target window by default, we want to allow testing of behavior on first show.
  if (!GTK_WIDGET_VISIBLE (window))
    gtk_widget_show (window);
  else
    gtk_widget_destroy (window);
}


# * GtkProgressBar

typedef struct _ProgressData {
  GtkWidget *window;
  GtkWidget *pbar;
  GtkWidget *block_spin;
  GtkWidget *x_align_spin;
  GtkWidget *y_align_spin;
  GtkWidget *step_spin;
  GtkWidget *act_blocks_spin;
  GtkWidget *label;
  GtkWidget *omenu1;
  GtkWidget *omenu2;
  GtkWidget *entry;
  int timer;
} ProgressData;

gint
progress_timeout (gpointer data)
{
  gdouble new_val;
  GtkAdjustment *adj;

  adj = GTK_PROGRESS (data)->adjustment;

  new_val = adj->value + 1;
  if (new_val > adj->upper)
    new_val = adj->lower;

  gtk_progress_set_value (GTK_PROGRESS (data), new_val);

  return TRUE;
}

sub destroy_progress (GtkWidget     *widget,
		  ProgressData **pdata)
{
  gtk_timeout_remove ((*pdata)->timer);
  (*pdata)->timer = 0;
  (*pdata)->window = NULL;
  g_free (*pdata);
  *pdata = NULL;
}

sub progressbar_toggle_orientation (GtkWidget *widget, gpointer data)
{
  ProgressData *pdata;
  gint i;

  pdata = (ProgressData *) data;

  if (!GTK_WIDGET_MAPPED (widget))
    return;

  i = gtk_option_menu_get_history (GTK_OPTION_MENU (widget));

  gtk_progress_bar_set_orientation (GTK_PROGRESS_BAR (pdata->pbar),
				    (GtkProgressBarOrientation) i);
}

sub toggle_show_text (GtkWidget *widget, ProgressData *pdata)
{
  gtk_progress_set_show_text (GTK_PROGRESS (pdata->pbar),
			      GTK_TOGGLE_BUTTON (widget)->active);
  gtk_widget_set_sensitive (pdata->entry, GTK_TOGGLE_BUTTON (widget)->active);
  gtk_widget_set_sensitive (pdata->x_align_spin,
			    GTK_TOGGLE_BUTTON (widget)->active);
  gtk_widget_set_sensitive (pdata->y_align_spin,
			    GTK_TOGGLE_BUTTON (widget)->active);
}

sub progressbar_toggle_bar_style (GtkWidget *widget, gpointer data)
{
  ProgressData *pdata;
  gint i;

  pdata = (ProgressData *) data;

  if (!GTK_WIDGET_MAPPED (widget))
    return;

  i = gtk_option_menu_get_history (GTK_OPTION_MENU (widget));

  if (i == 1)
    gtk_widget_set_sensitive (pdata->block_spin, TRUE);
  else
    gtk_widget_set_sensitive (pdata->block_spin, FALSE);
  
  gtk_progress_bar_set_bar_style (GTK_PROGRESS_BAR (pdata->pbar),
				  (GtkProgressBarStyle) i);
}

sub progress_value_changed (GtkAdjustment *adj, ProgressData *pdata)
{
  char buf[20];

  if (GTK_PROGRESS (pdata->pbar)->activity_mode)
    sprintf (buf, "???");
  else
    sprintf (buf, "%.0f%%", 100 *
	     gtk_progress_get_current_percentage (GTK_PROGRESS (pdata->pbar)));
  gtk_label_set_text (GTK_LABEL (pdata->label), buf);
}

sub adjust_blocks (GtkAdjustment *adj, ProgressData *pdata)
{
  gtk_progress_set_percentage (GTK_PROGRESS (pdata->pbar), 0);
  gtk_progress_bar_set_discrete_blocks (GTK_PROGRESS_BAR (pdata->pbar),
     gtk_spin_button_get_value_as_int (GTK_SPIN_BUTTON (pdata->block_spin)));
}

sub adjust_step (GtkAdjustment *adj, ProgressData *pdata)
{
  gtk_progress_bar_set_activity_step (GTK_PROGRESS_BAR (pdata->pbar),
     gtk_spin_button_get_value_as_int (GTK_SPIN_BUTTON (pdata->step_spin)));
}

sub adjust_act_blocks (GtkAdjustment *adj, ProgressData *pdata)
{
  gtk_progress_bar_set_activity_blocks (GTK_PROGRESS_BAR (pdata->pbar),
               gtk_spin_button_get_value_as_int 
		      (GTK_SPIN_BUTTON (pdata->act_blocks_spin)));
}

sub adjust_align (GtkAdjustment *adj, ProgressData *pdata)
{
  gtk_progress_set_text_alignment (GTK_PROGRESS (pdata->pbar),
	 gtk_spin_button_get_value (GTK_SPIN_BUTTON (pdata->x_align_spin)),
	 gtk_spin_button_get_value (GTK_SPIN_BUTTON (pdata->y_align_spin)));
}

sub toggle_activity_mode (GtkWidget *widget, ProgressData *pdata)
{
  gtk_progress_set_activity_mode (GTK_PROGRESS (pdata->pbar),
				  GTK_TOGGLE_BUTTON (widget)->active);
  gtk_widget_set_sensitive (pdata->step_spin, 
			    GTK_TOGGLE_BUTTON (widget)->active);
  gtk_widget_set_sensitive (pdata->act_blocks_spin, 
			    GTK_TOGGLE_BUTTON (widget)->active);
}

sub entry_changed (GtkWidget *widget, ProgressData *pdata)
{
  gtk_progress_set_format_string (GTK_PROGRESS (pdata->pbar),
			  gtk_entry_get_text (GTK_ENTRY (pdata->entry)));
}

sub create_progress_bar (GtkWidget *widget)
{
  GtkWidget *button;
  GtkWidget *vbox;
  GtkWidget *vbox2;
  GtkWidget *hbox;
  GtkWidget *check;
  GtkWidget *frame;
  GtkWidget *tab;
  GtkWidget *label;
  GtkWidget *align;
  GtkAdjustment *adj;
  static ProgressData *pdata = NULL;

  static gchar *items1[] =
  {
    "Left-Right",
    "Right-Left",
    "Bottom-Top",
    "Top-Bottom"
  };

  static gchar *items2[] =
  {
    "Continuous",
    "Discrete"
  };
  
  if (!pdata)
    pdata = g_new0 (ProgressData, 1);

  if (!pdata->window)
    {
      pdata->window = Gtk2::Dialog->new;

      gtk_window_set_screen (pdata->window,
			     gtk_widget_get_screen (widget));

      gtk_window_set_resizable (pdata->window, FALSE);

      g_signal_connect (pdata->window, "destroy",
			\&destroy_progress,
			&pdata);

      pdata->timer = 0;

      gtk_window_set_title (pdata->window, "GtkProgressBar");
      gtk_container_set_border_width ($pdata>window), 0);

      vbox = Gtk2::VBox->new(FALSE, 5);
  gtk_container_set_border_width ($vbox, 10);
  $pdata->window->vbox->pack_start ($vbox, FALSE, TRUE, 0);

      frame = Gtk2::Frame->new ("Progress");
      gtk_box_pack_start (vbox, frame, FALSE, TRUE, 0);

      vbox2 = Gtk2::VBox->new(FALSE, 5);
      $frame->add($vbox2);

      align = gtk_alignment_new (0.5, 0.5, 0, 0);
      gtk_box_pack_start (vbox2, align, FALSE, FALSE, 5);

      adj = (GtkAdjustment *) gtk_adjustment_new (0, 1, 300, 0, 0, 0);
      g_signal_connect (adj, "value_changed",
			\&progress_value_changed, pdata);

      pdata->pbar = gtk_widget_new (GTK_TYPE_PROGRESS_BAR,
				    "adjustment", adj,
				    NULL);
      gtk_progress_set_format_string (GTK_PROGRESS (pdata->pbar),
				      "%v from [%l,%u] (=%p%%)");
      $align->add($pdata->pbar);
      pdata->timer = gtk_timeout_add (100, progress_timeout, pdata->pbar);

      align = gtk_alignment_new (0.5, 0.5, 0, 0);
      gtk_box_pack_start (vbox2, align, FALSE, FALSE, 5);

      hbox = Gtk2::HBox->new(FALSE, 5);
      $align->add($hbox);
      label = Gtk2::Label->new("Label updated by user :"); 
      gtk_box_pack_start (hbox, label, FALSE, TRUE, 0);
      pdata->label = Gtk2::Label->new("");
      gtk_box_pack_start (hbox, pdata->label, FALSE, TRUE, 0);

      frame = Gtk2::Frame->new("Options");
      gtk_box_pack_start (vbox, frame, FALSE, TRUE, 0);

      vbox2 = Gtk2::VBox->new(FALSE, 5);
      $frame->add($vbox2);

      tab = gtk_table_new (7, 2, FALSE);
      gtk_box_pack_start (vbox2, tab, FALSE, TRUE, 0);

      label = Gtk2::Label->new("Orientation :");
      gtk_table_attach (GTK_TABLE (tab), label, 0, 1, 0, 1,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);

      pdata->omenu1 = build_option_menu (items1, 4, 0,
					 progressbar_toggle_orientation,
					 pdata);
      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_table_attach (GTK_TABLE (tab), hbox, 1, 2, 0, 1,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      gtk_box_pack_start (hbox, pdata->omenu1, TRUE, TRUE, 0);
      
      check = gtk_check_button_new_with_label ("Show text");
      g_signal_connect (check, "clicked",
			\&toggle_show_text,
			pdata);
      gtk_table_attach (GTK_TABLE (tab), check, 0, 1, 1, 2,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);

      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_table_attach (GTK_TABLE (tab), hbox, 1, 2, 1, 2,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);

      label = Gtk2::Label->new("Format : ");
      gtk_box_pack_start (hbox, label, FALSE, TRUE, 0);

      pdata->entry = Gtk2::Entry->new;
      g_signal_connect (pdata->entry, "changed",
			\&entry_changed,
			pdata);
      gtk_box_pack_start (hbox, pdata->entry, TRUE, TRUE, 0);
      gtk_entry_set_text (GTK_ENTRY (pdata->entry), "%v from [%l,%u] (=%p%%)");
      gtk_widget_set_size_request (pdata->entry, 100, -1);
      gtk_widget_set_sensitive (pdata->entry, FALSE);

      label = Gtk2::Label->new("Text align :");
      gtk_table_attach (GTK_TABLE (tab), label, 0, 1, 2, 3,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);

      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_table_attach (GTK_TABLE (tab), hbox, 1, 2, 2, 3,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);

      label = Gtk2::Label->new("x :");
      gtk_box_pack_start (hbox, label, FALSE, TRUE, 5);
      
      adj = (GtkAdjustment *) gtk_adjustment_new (0.5, 0, 1, 0.1, 0.1, 0);
      pdata->x_align_spin = gtk_spin_button_new (adj, 0, 1);
      g_signal_connect (adj, "value_changed",
			\&adjust_align, pdata);
      gtk_box_pack_start (hbox, pdata->x_align_spin, FALSE, TRUE, 0);
      gtk_widget_set_sensitive (pdata->x_align_spin, FALSE);

      label = Gtk2::Label->new("y :");
      gtk_box_pack_start (hbox, label, FALSE, TRUE, 5);

      adj = (GtkAdjustment *) gtk_adjustment_new (0.5, 0, 1, 0.1, 0.1, 0);
      pdata->y_align_spin = gtk_spin_button_new (adj, 0, 1);
      g_signal_connect (adj, "value_changed",
			\&adjust_align, pdata);
      gtk_box_pack_start (hbox, pdata->y_align_spin, FALSE, TRUE, 0);
      gtk_widget_set_sensitive (pdata->y_align_spin, FALSE);

      label = Gtk2::Label->new("Bar Style :");
      gtk_table_attach (GTK_TABLE (tab), label, 0, 1, 3, 4,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);

      pdata->omenu2 = build_option_menu	(items2, 2, 0,
					 progressbar_toggle_bar_style,
					 pdata);
      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_table_attach (GTK_TABLE (tab), hbox, 1, 2, 3, 4,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      gtk_box_pack_start (hbox, pdata->omenu2, TRUE, TRUE, 0);

      label = Gtk2::Label->new("Block count :");
      gtk_table_attach (GTK_TABLE (tab), label, 0, 1, 4, 5,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      gtk_misc_set_alignment (GTK_MISC (label), 0, 0.5);

      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_table_attach (GTK_TABLE (tab), hbox, 1, 2, 4, 5,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      adj = (GtkAdjustment *) gtk_adjustment_new (10, 2, 20, 1, 5, 0);
      pdata->block_spin = gtk_spin_button_new (adj, 0, 0);
      g_signal_connect (adj, "value_changed",
			\&adjust_blocks, pdata);
      gtk_box_pack_start (hbox, pdata->block_spin, FALSE, TRUE, 0);
      gtk_widget_set_sensitive (pdata->block_spin, FALSE);

      check = gtk_check_button_new_with_label ("Activity mode");
      g_signal_connect (check, "clicked",
			\&toggle_activity_mode, pdata);
      gtk_table_attach (GTK_TABLE (tab), check, 0, 1, 5, 6,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);

      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_table_attach (GTK_TABLE (tab), hbox, 1, 2, 5, 6,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      label = Gtk2::Label->new("Step size : ");
      gtk_box_pack_start (hbox, label, FALSE, TRUE, 0);
      adj = (GtkAdjustment *) gtk_adjustment_new (3, 1, 20, 1, 5, 0);
      pdata->step_spin = gtk_spin_button_new (adj, 0, 0);
      g_signal_connect (adj, "value_changed",
			\&adjust_step, pdata);
      gtk_box_pack_start (hbox, pdata->step_spin, FALSE, TRUE, 0);
      gtk_widget_set_sensitive (pdata->step_spin, FALSE);

      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_table_attach (GTK_TABLE (tab), hbox, 1, 2, 6, 7,
			GTK_EXPAND | GTK_FILL, GTK_EXPAND | GTK_FILL,
			5, 5);
      label = Gtk2::Label->new("Blocks :     ");
      gtk_box_pack_start (hbox, label, FALSE, TRUE, 0);
      adj = (GtkAdjustment *) gtk_adjustment_new (5, 2, 10, 1, 5, 0);
      pdata->act_blocks_spin = gtk_spin_button_new (adj, 0, 0);
      g_signal_connect (adj, "value_changed",
			\&adjust_act_blocks, pdata);
      gtk_box_pack_start (hbox, pdata->act_blocks_spin, FALSE, TRUE,
			  0);
      gtk_widget_set_sensitive (pdata->act_blocks_spin, FALSE);

      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				pdata->window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start (GTK_DIALOG (pdata->window->action_area), 
			  button, TRUE, TRUE, 0);
      gtk_widget_grab_default (button);
    }

  if (!GTK_WIDGET_VISIBLE (pdata->window))
    $pdata->window->show_all;
  else
    gtk_widget_destroy (pdata->window);
}

# * Properties

typedef struct {
  int x;
  int y;
  gboolean found;
  gboolean first;
  GtkWidget *res_widget;
} FindWidgetData;

sub find_widget (GtkWidget *widget, FindWidgetData *data)
{
  GtkAllocation new_allocation;
  gint x_offset = 0;
  gint y_offset = 0;

  new_allocation = widget->allocation;

  if (data->found || !GTK_WIDGET_MAPPED (widget))
    return;

#  * Note that in the following code, we only count the
#   * position as being inside a WINDOW widget if it is inside
#   * widget->window; points that are outside of widget->window
#   * but within the allocation are not counted. This is consistent
#   * with the way we highlight drag targets.
  if (!GTK_WIDGET_NO_WINDOW (widget))
    {
      new_allocation.x = 0;
      new_allocation.y = 0;
    }
  
  if (widget->parent && !data->first)
    {
      GdkWindow *window = widget->window;
      while (window != widget->parent->window)
	{
	  gint tx, ty, twidth, theight;
	  gdk_drawable_get_size (window, &twidth, &theight);

	  if (new_allocation.x < 0)
	    {
	      new_allocation.width += new_allocation.x;
	      new_allocation.x = 0;
	    }
	  if (new_allocation.y < 0)
	    {
	      new_allocation.height += new_allocation.y;
	      new_allocation.y = 0;
	    }
	  if (new_allocation.x + new_allocation.width > twidth)
	    new_allocation.width = twidth - new_allocation.x;
	  if (new_allocation.y + new_allocation.height > theight)
	    new_allocation.height = theight - new_allocation.y;

	  gdk_window_get_position (window, &tx, &ty);
	  new_allocation.x += tx;
	  x_offset += tx;
	  new_allocation.y += ty;
	  y_offset += ty;
	  
	  window = gdk_window_get_parent (window);
	}
    }

  if ((data->x >= new_allocation.x) && (data->y >= new_allocation.y) &&
      (data->x < new_allocation.x + new_allocation.width) && 
      (data->y < new_allocation.y + new_allocation.height))
    {
      # First, check if the drag is in a valid drop site in one of our children 
      if (GTK_IS_CONTAINER (widget))
	{
	  FindWidgetData new_data = *data;
	  
	  new_data.x -= x_offset;
	  new_data.y -= y_offset;
	  new_data.found = FALSE;
	  new_data.first = FALSE;
	  
	  gtk_container_forall ($widget,
				(GtkCallback)find_widget,
				&new_data);
	  
	  data->found = new_data.found;
	  if (data->found)
	    data->res_widget = new_data.res_widget;
	}

      # If not, and this widget is registered as a drop site, check to
       #* emit "drag_motion" to check if we are actually in
       #* a drop site.
      if (!data->found)
	{
	  data->found = TRUE;
	  data->res_widget = widget;
	}
    }
}

static GtkWidget *
find_widget_at_pointer (GdkDisplay *display)
{
  GtkWidget *widget = NULL;
  GdkWindow *pointer_window;
  gint x, y;
  FindWidgetData data;
 
 pointer_window = gdk_display_get_window_at_pointer (display, NULL, NULL);
 
 if (pointer_window)
   gdk_window_get_user_data (pointer_window, (gpointer*) &widget);

 if (widget)
   {
     gdk_window_get_pointer (widget->window,
			     &x, &y, NULL);
     
     data.x = x;
     data.y = y;
     data.found = FALSE;
     data.first = TRUE;

     find_widget (widget, &data);
     if (data.found)
       return data.res_widget;
     return widget;
   }
 return NULL;
}

struct PropertiesData {
  GtkWidget **window;
  GdkCursor *cursor;
  gboolean in_query;
  gint handler;
};

sub destroy_properties (GtkWidget             *widget,
		    struct PropertiesData *data)
{
  if (data->window)
    {
      *data->window = NULL;
      data->window = NULL;
    }

  if (data->cursor)
    {
      gdk_cursor_unref (data->cursor);
      data->cursor = NULL;
    }

  if (data->handler)
    {
      g_signal_handler_disconnect (widget, data->handler);
      data->handler = 0;
    }

  g_free (data);
}

static gint
property_query_event (GtkWidget	       *widget,
		      GdkEvent	       *event,
		      struct PropertiesData *data)
{
  GtkWidget *res_widget = NULL;

  if (!data->in_query)
    return FALSE;
  
  if (event->type == GDK_BUTTON_RELEASE)
    {
      gtk_grab_remove (widget);
      gdk_display_pointer_ungrab (gtk_widget_get_display (widget),
				  GDK_CURRENT_TIME);
      
      res_widget = find_widget_at_pointer (gtk_widget_get_display (widget));
      if (res_widget)
	{
	  g_object_set_data (res_widget, "prop-editor-screen",
			     gtk_widget_get_screen (widget));
	  create_prop_editor (res_widget, 0);
	}

      data->in_query = FALSE;
    }
  return FALSE;
}


sub query_properties (GtkButton *button,
		  struct PropertiesData *data)
{
  gint failure;

  g_signal_connect (button, "event",
		    \&property_query_event, data);


  if (!data->cursor)
    data->cursor = gdk_cursor_new_for_display (gtk_widget_get_display (GTK_WIDGET (button)),
					       GDK_TARGET);
  
  failure = gdk_pointer_grab (GTK_WIDGET (button)->window,
			      TRUE,
			      GDK_BUTTON_RELEASE_MASK,
			      NULL,
			      data->cursor,
			      GDK_CURRENT_TIME);

  gtk_grab_add (GTK_WIDGET (button));

  data->in_query = TRUE;
}

sub create_properties (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *button;
  GtkWidget *vbox;
  GtkWidget *label;
  struct PropertiesData *data;

  data = g_new (struct PropertiesData, 1);
  data->window = &window;
  data->in_query = FALSE;
  data->cursor = NULL;
  data->handler = 0;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));      

      data->handler = g_signal_connect (window, "destroy",
					\&destroy_properties,
					data);

      gtk_window_set_title (window, "test properties");
      gtk_container_set_border_width ($window, 10);

      vbox = Gtk2::VBox->new(FALSE, 1);
      $window->add($vbox);
            
      label = Gtk2::Label->new("This is just a dumb test to test properties.\nIf you need a generic module, get GLE.");
      gtk_box_pack_start (vbox, label, TRUE, TRUE, 0);
      
      button = Gtk2::Button->new("Query properties");
      gtk_box_pack_start (vbox, button, TRUE, TRUE, 0);
      g_signal_connect (button, "clicked",
			\&query_properties,
			data);
    }

  if (!GTK_WIDGET_VISIBLE (window))
  $window->show_all;
  else
    gtk_widget_destroy (window);
  
}


# Color Preview

static int color_idle = 0;

sub color_idle_func (GtkWidget *preview)
{
  static int count = 1;
  guchar buf[768];
  int i, j, k;

  for (i = 0; i < 256; i++)
    {
      for (j = 0, k = 0; j < 256; j++)
	{
	  buf[k+0] = i + count;
	  buf[k+1] = 0;
	  buf[k+2] = j + count;
	  k += 3;
	}

      gtk_preview_draw_row (GTK_PREVIEW (preview), buf, 0, i, 256);
    }

  count += 1;

  gtk_widget_queue_draw (preview);
  gdk_window_process_updates (preview->window, TRUE);

  return TRUE;
}

sub color_preview_destroy (GtkWidget  *widget,
		       GtkWidget **window)
{
  gtk_idle_remove (color_idle);
  color_idle = 0;

  *window = NULL;
}

sub create_color_preview (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *preview;
  guchar buf[768];
  int i, j, k;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&color_preview_destroy,
			&window);

      gtk_window_set_title (window, "test");
      gtk_container_set_border_width ($window, 10);

      preview = gtk_preview_new (GTK_PREVIEW_COLOR);
      gtk_preview_size (GTK_PREVIEW (preview), 256, 256);
      $window->add($preview);

      for (i = 0; i < 256; i++)
	{
	  for (j = 0, k = 0; j < 256; j++)
	    {
	      buf[k+0] = i;
	      buf[k+1] = 0;
	      buf[k+2] = j;
	      k += 3;
	    }

	  gtk_preview_draw_row (GTK_PREVIEW (preview), buf, 0, i, 256);
	}

      color_idle = gtk_idle_add ((GtkFunction) color_idle_func, preview);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# Gray Preview

static int gray_idle = 0;

gint
gray_idle_func (GtkWidget *preview)
{
  static int count = 1;
  guchar buf[256];
  int i, j;

  for (i = 0; i < 256; i++)
    {
      for (j = 0; j < 256; j++)
	buf[j] = i + j + count;

      gtk_preview_draw_row (GTK_PREVIEW (preview), buf, 0, i, 256);
    }

  count += 1;

  gtk_widget_draw (preview, NULL);

  return TRUE;
}

sub gray_preview_destroy (GtkWidget  *widget,
		      GtkWidget **window)
{
  gtk_idle_remove (gray_idle);
  gray_idle = 0;

  *window = NULL;
}

sub create_gray_preview (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *preview;
  guchar buf[256];
  int i, j;

  if (!window)
    {
      window = Gtk2::Window->new('toplevel');

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gray_preview_destroy,
			&window);

      gtk_window_set_title (window, "test");
      gtk_container_set_border_width ($window, 10);

      preview = gtk_preview_new (GTK_PREVIEW_GRAYSCALE);
      gtk_preview_size (GTK_PREVIEW (preview), 256, 256);
      $window->add($preview);

      for (i = 0; i < 256; i++)
	{
	  for (j = 0; j < 256; j++)
	    buf[j] = i + j;

	  gtk_preview_draw_row (GTK_PREVIEW (preview), buf, 0, i, 256);
	}

      gray_idle = gtk_idle_add ((GtkFunction) gray_idle_func, preview);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}


# * Selection Test

sub selection_test_received (GtkWidget *list, GtkSelectionData *data)
{
  GdkAtom *atoms;
  GtkWidget *list_item;
  GList *item_list;
  int i, l;

  if (data->length < 0)
    {
      g_print ("Selection retrieval failed\n");
      return;
    }
  if (data->type != GDK_SELECTION_TYPE_ATOM)
    {
      g_print ("Selection \"TARGETS\" was not returned as atoms!\n");
      return;
    }

  # Clear out any current list items */

  gtk_list_clear_items (GTK_LIST(list), 0, -1);

  # Add new items to list */

  atoms = (GdkAtom *)data->data;

  item_list = NULL;
  l = data->length / sizeof (GdkAtom);
  for (i = 0; i < l; i++)
    {
      char *name;
      name = gdk_atom_name (atoms[i]);
      if (name != NULL)
	{
	  list_item = gtk_list_item_new_with_label (name);
	  g_free (name);
	}
      else
	list_item = gtk_list_item_new_with_label ("(bad atom)");

      gtk_widget_show (list_item);
      item_list = g_list_append (item_list, list_item);
    }

  gtk_list_append_items (GTK_LIST (list), item_list);

  return;
}

sub selection_test_get_targets (GtkWidget *widget, GtkWidget *list)
{
  static GdkAtom targets_atom = GDK_NONE;

  if (targets_atom == GDK_NONE)
    targets_atom = gdk_atom_intern ("TARGETS", FALSE);

  gtk_selection_convert (list, GDK_SELECTION_PRIMARY, targets_atom,
			 GDK_CURRENT_TIME);
}

sub create_selection_test (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *button;
  GtkWidget *vbox;
  GtkWidget *scrolled_win;
  GtkWidget *list;
  GtkWidget *label;

  if (!window)
    {
      window = Gtk2::Dialog->new;
      
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "Selection Test");
      gtk_container_set_border_width ($window, 0);

      # Create the list */

      vbox = Gtk2::VBox->new(FALSE, 5);
      gtk_container_set_border_width ($vbox, 10);
      gtk_box_pack_start ($window->vbox, vbox,
			  TRUE, TRUE, 0);

      label = Gtk2::Label->new("Gets available targets for current selection");
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      scrolled_win = Gtk2::ScrolledWindow->new;
      gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scrolled_win),
				      GTK_POLICY_AUTOMATIC, 
				      GTK_POLICY_AUTOMATIC);
      gtk_box_pack_start (vbox, scrolled_win, TRUE, TRUE, 0);
      gtk_widget_set_size_request (scrolled_win, 100, 200);

      list = gtk_list_new;
      gtk_scrolled_window_add_with_viewport (GTK_SCROLLED_WINDOW (scrolled_win), list);

      g_signal_connect (list, "selection_received",
			\&selection_test_received, NULL);

      # .. And create some buttons */
      button = Gtk2::Button->new("Get Targets");
      gtk_box_pack_start ($window->action_area,
			  button, TRUE, TRUE, 0);

      g_signal_connect (button, "clicked",
			\&selection_test_get_targets, list);

      button = Gtk2::Button->new("Quit");
      gtk_box_pack_start ($window->action_area,
			  button, TRUE, TRUE, 0);

      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				window);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

#* Gamma Curve

sub create_gamma_curve (GtkWidget *widget)
{
  static GtkWidget *window = NULL, *curve;
  static int count = 0;
  gfloat vec[256];
  gint max;
  gint i;
  
  if (!window)
    {
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      gtk_window_set_title (window, "test");
      gtk_container_set_border_width ($window, 10);

      g_signal_connect (window, "destroy",
			\&(gtk_widget_destroyed),
			&window);

      curve = gtk_gamma_curve_new;
      $window->add($curve);
      gtk_widget_show (curve);
    }

  max = 127 + (count % 2)*128;
  gtk_curve_set_range (GTK_CURVE (GTK_GAMMA_CURVE (curve)->curve),
		       0, max, 0, max);
  for (i = 0; i < max; ++i)
    vec[i] = (127 / sqrt (max)) * sqrt (i);
  gtk_curve_set_vector (GTK_CURVE (GTK_GAMMA_CURVE (curve)->curve),
			max, vec);

  if (!GTK_WIDGET_VISIBLE (window))
    gtk_widget_show (window);
  else if (count % 4 == 3)
    {
      gtk_widget_destroy (window);
      window = NULL;
    }

  ++count;
}

# * Test scrolling

static int scroll_test_pos = 0.0;

static gint
scroll_test_expose (GtkWidget *widget, GdkEventExpose *event,
		    GtkAdjustment *adj)
{
  gint i,j;
  gint imin, imax, jmin, jmax;
  
  imin = (event->area.x) / 10;
  imax = (event->area.x + event->area.width + 9) / 10;

  jmin = ((int)adj->value + event->area.y) / 10;
  jmax = ((int)adj->value + event->area.y + event->area.height + 9) / 10;

  gdk_window_clear_area (widget->window,
			 event->area.x, event->area.y,
			 event->area.width, event->area.height);

  for (i=imin; i<imax; i++)
    for (j=jmin; j<jmax; j++)
      if ((i+j) % 2)
	gdk_draw_rectangle (widget->window, 
			    widget->style->black_gc,
			    TRUE,
			    10*i, 10*j - (int)adj->value, 1+i%10, 1+j%10);

  return TRUE;
}

static gint
scroll_test_scroll (GtkWidget *widget, GdkEventScroll *event,
		    GtkAdjustment *adj)
{
  gdouble new_value = adj->value + ((event->direction == GDK_SCROLL_UP) ?
				    -adj->page_increment / 2:
				    adj->page_increment / 2);
  new_value = CLAMP (new_value, adj->lower, adj->upper - adj->page_size);
  gtk_adjustment_set_value (adj, new_value);  
  
  return TRUE;
}

sub scroll_test_configure (GtkWidget *widget, GdkEventConfigure *event,
		       GtkAdjustment *adj)
{
  adj->page_increment = 0.9 * widget->allocation.height;
  adj->page_size = widget->allocation.height;

  g_signal_emit_by_name (adj, "changed");
}

sub scroll_test_adjustment_changed (GtkAdjustment *adj, GtkWidget *widget)
{
  # gint source_min = (int)adj->value - scroll_test_pos; */
  gint dy;

  dy = scroll_test_pos - (int)adj->value;
  scroll_test_pos = adj->value;

  if (!GTK_WIDGET_DRAWABLE (widget))
    return;
  gdk_window_scroll (widget->window, 0, dy);
  gdk_window_process_updates (widget->window, FALSE);
}


sub create_scroll_test (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *hbox;
  GtkWidget *drawing_area;
  GtkWidget *scrollbar;
  GtkWidget *button;
  GtkAdjustment *adj;
  GdkGeometry geometry;
  GdkWindowHints geometry_mask;

  if (!window)
    {
      window = Gtk2::Dialog->new;

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "Scroll Test");
      gtk_container_set_border_width ($window, 0);

      hbox = Gtk2::HBox->new(FALSE, 0);
      gtk_box_pack_start ($window->vbox, hbox,
			  TRUE, TRUE, 0);
      gtk_widget_show (hbox);

      drawing_area = gtk_drawing_area_new;
      gtk_widget_set_size_request (drawing_area, 200, 200);
      gtk_box_pack_start (hbox, drawing_area, TRUE, TRUE, 0);
      gtk_widget_show (drawing_area);

      gtk_widget_set_events (drawing_area, GDK_EXPOSURE_MASK | GDK_SCROLL_MASK);

      adj = GTK_ADJUSTMENT (gtk_adjustment_new (0.0, 0.0, 1000.0, 1.0, 180.0, 200.0));
      scroll_test_pos = 0.0;

      scrollbar = gtk_vscrollbar_new (adj);
      gtk_box_pack_start (hbox, scrollbar, FALSE, FALSE, 0);
      gtk_widget_show (scrollbar);

      g_signal_connect (drawing_area, "expose_event",
			\&scroll_test_expose, adj);
      g_signal_connect (drawing_area, "configure_event",
			\&scroll_test_configure, adj);
      g_signal_connect (drawing_area, "scroll_event",
			\&scroll_test_scroll, adj);
      g_signal_connect (adj, "value_changed",
			\&scroll_test_adjustment_changed,
			drawing_area);
      # .. And create some buttons */
      button = Gtk2::Button->new("Quit");
      gtk_box_pack_start ($window->action_area,
			  button, TRUE, TRUE, 0);
      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				window);
      gtk_widget_show (button);
      # Set up gridded geometry
      geometry_mask = GDK_HINT_MIN_SIZE | 
	               GDK_HINT_BASE_SIZE | 
	               GDK_HINT_RESIZE_INC;
      geometry->min_width = 20;
      geometry->min_height = 20;
      geometry->base_width = 0;
      geometry->base_height = 0;
      geometry->width_inc = 10;
      geometry->height_inc = 10;
      gtk_window_set_geometry_hints (window,
			       drawing_area, &geometry, geometry_mask);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    gtk_widget_show (window);
  else
    gtk_widget_destroy (window);
}

# * Timeout Test



my $timeout_tests = 0;
sub timeout_test
{
  my ($label) = @_;
  $label->set_text(sprintf "count: %d", ++$timeout_tests);
  return TRUE;
}

my $timer;
sub start_timeout_test
{
  my ($widget,$label) = @_;
  $timer = Gtk2::Timeout->add(100, \&timeout_test, $label) unless defined $timer;
}

sub stop_timeout_test
{
  $timer->remove if defined $timer;
  $timer = undef;
}

sub destroy_timeout_test 
{
  my ($widget,$window) = @_;
  stop_timeout_test();
  $window = NULL;
}

sub create_timeout_test (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *button;
  GtkWidget *label;

  if (!window)
    {
      window = Gtk2::Dialog->new;

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&destroy_timeout_test,
			&window);

      gtk_window_set_title (window, "Timeout Test");
      gtk_container_set_border_width ($window, 0);

      label = Gtk2::Label->new("count: 0");
      gtk_misc_set_padding (GTK_MISC (label), 10, 10);
      gtk_box_pack_start ($window->vbox, 
			  label, TRUE, TRUE, 0);
      gtk_widget_show (label);

      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);
      gtk_widget_grab_default (button);
      gtk_widget_show (button);

      button = Gtk2::Button->new("start");
      g_signal_connect (button, "clicked",
			\&(start_timeout_test),
			label);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);
      gtk_widget_show (button);

      button = Gtk2::Button->new("stop");
      g_signal_connect (button, "clicked",
			\&stop_timeout_test,
			NULL);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);
      gtk_widget_show (button);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    gtk_widget_show (window);
  else
    gtk_widget_destroy (window);
}

# * Idle Test

my $idle_id;
my $idle_tests = 0;
sub idle_test
{
  my ($label) = @_;
  $label->set_text(sprintf ("count: %d", ++$idle_tests));
  return TRUE;
}

sub start_idle_test
{
  my ($widget,$label) = @_;
  $idle_id = Gtk2::Idle->add(\&idle_test, $label) unless defined $idle_id;
}

sub stop_idle_test
{
  my ($widget,$data) = @_;
  idle_id->remove if defined $idle_id;
  undef $idle_id;
}

sub destroy_idle_test($\$)
{
  my ($widget, $winref) = @_;
  stop_idle_test();
  undef $$winref;
}

sub toggle_idle_container
{
  my ($button, $container) = @_;
  $container->set_resize_mode($button->get_data("user_data"));
}

sub create_idle_test
{
  my ($widget) = @_;
  static GtkWidget *window = NULL;
  unless (defined window)
    {
      window = Gtk2::Dialog->new;
      gtk_window_set_screen (window, gtk_widget_get_screen (widget));
      g_signal_connect (window, "destroy",
			\&destroy_idle_test,
			&window);
      gtk_window_set_title (window, "Idle Test");
      gtk_container_set_border_width ($window, 0);
      my $label = Gtk2::Label->new("count: 0");
      gtk_misc_set_padding (GTK_MISC (label), 10, 10);
      gtk_widget_show (label);
      my $container =
	gtk_widget_new (GTK_TYPE_HBOX,
			"visible" => TRUE,
			# "GtkContainer::child", gtk_widget_new (GTK_TYPE_HBOX,
			# "GtkWidget::visible", TRUE,
			"child" => $label);
      $window->vbox->pack_start($container, TRUE, TRUE, 0);
      my $frame = 
	gtk_widget_new (GTK_TYPE_FRAME,
			"border_width", 5,
			"label", "Label Container",
			"visible", TRUE,
			"parent", $window->vbox,
			NULL);
      my $box =
	gtk_widget_new (GTK_TYPE_VBOX,
			"visible", TRUE,
			"parent", frame,
			NULL);
      my $button =
	g_object_connect (gtk_widget_new (GTK_TYPE_RADIO_BUTTON,
					  "label", "Resize-Parent",
					  "user_data", (void*)GTK_RESIZE_PARENT,
					  "visible", TRUE,
					  "parent", box,
					  NULL),
			  "signal::clicked", toggle_idle_container, container,
			  NULL);
      $button = gtk_widget_new (GTK_TYPE_RADIO_BUTTON,
			       "label", "Resize-Queue",
			       "user_data", (void*)GTK_RESIZE_QUEUE,
			       "group", button,
			       "visible", TRUE,
			       "parent", box,
			       NULL);
      g_object_connect (button,
			"signal::clicked", toggle_idle_container, container,
			NULL);
      my $button2 = gtk_widget_new (GTK_TYPE_RADIO_BUTTON,
				"label", "Resize-Immediate",
				"user_data", (void*)GTK_RESIZE_IMMEDIATE,
				NULL);
      g_object_connect (button2,
			"signal::clicked", toggle_idle_container, container,
			NULL);
      g_object_set (button2,
		    "group", button,
		    "visible", TRUE,
		    "parent", box,
		    NULL);

      button = Gtk2::Button->new("close");
      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);
      gtk_widget_grab_default (button);
      gtk_widget_show (button);

      button = Gtk2::Button->new("start");
      g_signal_connect (button, "clicked",
			\&start_idle_test,
			label);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);
      gtk_widget_show (button);

      button = Gtk2::Button->new("stop");
      g_signal_connect (button, "clicked",
			\&stop_idle_test,
			NULL);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);
      gtk_widget_show (button);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    gtk_widget_show (window);
  else
    gtk_widget_destroy (window);
}

# rc file test

sub reload_all_rc_files (void)
{
  static GdkAtom atom_rcfiles = GDK_NONE;

  GdkEvent *send_event = gdk_event_new (GDK_CLIENT_EVENT);
  int i;
  
  if (!atom_rcfiles)
    atom_rcfiles = gdk_atom_intern("_GTK_READ_RCFILES", FALSE);

  for(i = 0; i < 5; i++)
    send_event->client.data.l[i] = 0;
  send_event->client.data_format = 32;
  send_event->client.message_type = atom_rcfiles;
  gdk_event_send_clientmessage_toall (send_event);

  gdk_event_free (send_event);
}

sub create_rc_file (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *button;
  GtkWidget *frame;
  GtkWidget *vbox;
  GtkWidget *label;

  if (!window)
    {
      window = Gtk2::Dialog->new;

      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      frame = gtk_aspect_frame_new ("Testing RC file prioritization", 0.5, 0.5, 0.0, TRUE);
      gtk_box_pack_start ($window->vbox, frame, FALSE, FALSE, 0);

      vbox = Gtk2::VBox->new(FALSE, 0);
      $frame->add($vbox);
      
      label = Gtk2::Label->new("This label should be red");
      gtk_widget_set_name (label, "testgtk-red-label");
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      label = Gtk2::Label->new("This label should be green");
      gtk_widget_set_name (label, "testgtk-green-label");
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      label = Gtk2::Label->new("This label should be blue");
      gtk_widget_set_name (label, "testgtk-blue-label");
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      gtk_window_set_title (window, "Reload Rc file");
      gtk_container_set_border_width ($window, 0);

      button = Gtk2::Button->new("Reload");
      g_signal_connect (button, "clicked",
			\&gtk_rc_reparse_all, NULL);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);
      gtk_widget_grab_default (button);

      button = Gtk2::Button->new("Reload All");
      g_signal_connect (button, "clicked",
			\&reload_all_rc_files, NULL);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);

      button = Gtk2::Button->new("Close");
      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, 
			  button, TRUE, TRUE, 0);
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# Test of recursive mainloop

sub mainloop_destroyed
{
  #my (GtkWidget *w, GtkWidget **window) = @_;
 #  *window = NULL;
  Gtk2->quit;
}

sub create_mainloop
{
  my ($widget) = @_;
  static GtkWidget *window = NULL;
  GtkWidget *label;
  GtkWidget *button;
  if (!window)
    {
      window = Gtk2::Dialog->new;
      gtk_window_set_screen (window, gtk_widget_get_screen (widget));
      gtk_window_set_title (window, "Test Main Loop");
      g_signal_connect (window, "destroy",
			\&mainloop_destroyed,
			&window);
      label = Gtk2::Label->new("In recursive main loop...");
      gtk_misc_set_padding (GTK_MISC(label), 20, 20);
      gtk_box_pack_start ($window->vbox, label, TRUE, TRUE, 0);
      gtk_widget_show (label);
      button = Gtk2::Button->new("Leave");
      gtk_box_pack_start ($window->action_area, button, FALSE, TRUE, 0);
      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_widget_grab_default (button);
      gtk_widget_show (button);
    }
  if (!GTK_WIDGET_VISIBLE (window))
    {
      $window->show;
      print "create_mainloop: start\n";
      Gtk2->main;
      print "create_mainloop: done\n";
    }
  else { gtk_widget_destroy (window); }
}

sub layout_expose_handler
{
  my ($widget, $event) = @_;
  my $layout = $widget;
  return FALSE if $event->window != $layout->bin_window;
  my $imin = (event->area->x) / 10;
  my $imax = (event->area->x + event->area->width + 9) / 10;
  my $jmin = (event->area->y) / 10;
  my $jmax = (event->area->y + event->area->height + 9) / 10;
  for (my $i = $imin; $i < $imax; $i++) {
    for (my $j = $jmin; $j < $jmax; $j++) {
      gdk_draw_rectangle($layout->bin_window,
			 $widget->style->black_gc,
			 TRUE, 10*$i, 10*$j, 1+$i%10, 1+$j%10) 
	if ($i + $j) % 2;
    }
  }
  return FALSE;
}

sub create_layout (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *scrolledwindow;
  GtkWidget *button;
  if (!window)
    {
      gchar buf[16];

      gint i, j;
      
      window = Gtk2::Window->new('toplevel');
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));

      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      gtk_window_set_title (window, "Layout");
      gtk_widget_set_size_request (window, 200, 200);

      scrolledwindow = Gtk2::ScrolledWindow->new;
      gtk_scrolled_window_set_shadow_type (GTK_SCROLLED_WINDOW (scrolledwindow),
					   GTK_SHADOW_IN);
      gtk_scrolled_window_set_placement (GTK_SCROLLED_WINDOW (scrolledwindow),
					 GTK_CORNER_TOP_RIGHT);

      $window->add($scrolledwindow);
      
      my $layout = Gtk2::Layout->new;
      $scrolledwindow->add($layout);

      # We set step sizes here since GtkLayout does not set
      # them itself.
      GTK_LAYOUT (layout)->hadjustment->step_increment = 10.0;
      GTK_LAYOUT (layout)->vadjustment->step_increment = 10.0;
      
      gtk_widget_set_events (layout, GDK_EXPOSURE_MASK);
      g_signal_connect (layout, "expose_event",
			\&layout_expose_handler, NULL);
      
      gtk_layout_set_size (GTK_LAYOUT (layout), 1600, 128000);
      
      for (i=0 ; i < 16 ; i++)
	for (j=0 ; j < 16 ; j++)
	  {
	    sprintf(buf, "Button %d, %d", i, j);
	    if ((i + j) % 2)
	      button = Gtk2::Button->new(buf);
	    else
	      button = Gtk2::Label->new(buf);

	    gtk_layout_put (GTK_LAYOUT (layout), button,
			    j*100, i*100);
	  }

      for (i=16; i < 1280; i++)
	{
	  sprintf(buf, "Button %d, %d", i, 0);
	  if (i % 2)
	    button = Gtk2::Button->new(buf);
	  else
	    button = Gtk2::Label->new(buf);

	  gtk_layout_put (GTK_LAYOUT (layout), button,
			  0, i*100);
	}
    }

  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

sub create_styles (GtkWidget *widget)
{
  static GtkWidget *window = NULL;
  GtkWidget *label;
  GtkWidget *button;
  GtkWidget *entry;
  GtkWidget *vbox;
  static GdkColor red =    { 0, 0xffff, 0,      0      };
  static GdkColor green =  { 0, 0,      0xffff, 0      };
  static GdkColor blue =   { 0, 0,      0,      0xffff };
  static GdkColor yellow = { 0, 0xffff, 0xffff, 0      };
  static GdkColor cyan =   { 0, 0     , 0xffff, 0xffff };
  PangoFontDescription *font_desc;

  GtkRcStyle *rc_style;

  if (!window)
    {
      window = Gtk2::Dialog->new;
      gtk_window_set_screen (window,
			     gtk_widget_get_screen (widget));
     
      g_signal_connect (window, "destroy",
			\&gtk_widget_destroyed,
			&window);

      
      button = Gtk2::Button->new("Close");
      g_signal_connect_swapped (button, "clicked",
				\&gtk_widget_destroy,
				window);
      GTK_WIDGET_SET_FLAGS (button, GTK_CAN_DEFAULT);
      gtk_box_pack_start ($window->action_area, $button, TRUE, TRUE, 0);
      gtk_widget_show (button);

      vbox = Gtk2::VBox->new(FALSE, 5);
      gtk_container_set_border_width ($vbox, 10);
      gtk_box_pack_start ($window->vbox, vbox, FALSE, FALSE, 0);
      
      label = Gtk2::Label->new("Font:");
      gtk_misc_set_alignment (GTK_MISC (label), 0.0, 0.5);
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      font_desc = pango_font_description_from_string ("Helvetica,Sans Oblique 18");

      button = Gtk2::Button->new("Some Text");
      gtk_widget_modify_font (GTK_BIN (button)->child, font_desc);
      gtk_box_pack_start (vbox, button, FALSE, FALSE, 0);

      label = Gtk2::Label->new("Foreground:");
      gtk_misc_set_alignment (GTK_MISC (label), 0.0, 0.5);
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      button = Gtk2::Button->new("Some Text");
      gtk_widget_modify_fg (GTK_BIN (button)->child, GTK_STATE_NORMAL, &red);
      gtk_box_pack_start (vbox, button, FALSE, FALSE, 0);

      label = Gtk2::Label->new("Background:");
      gtk_misc_set_alignment (GTK_MISC (label), 0.0, 0.5);
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      button = Gtk2::Button->new("Some Text");
      gtk_widget_modify_bg (button, GTK_STATE_NORMAL, &green);
      gtk_box_pack_start (vbox, button, FALSE, FALSE, 0);

      label = Gtk2::Label->new("Text:");
      gtk_misc_set_alignment (GTK_MISC (label), 0.0, 0.5);
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      entry = Gtk2::Entry->new;
      gtk_entry_set_text (GTK_ENTRY (entry), "Some Text");
      gtk_widget_modify_text (entry, GTK_STATE_NORMAL, &blue);
      gtk_box_pack_start (vbox, entry, FALSE, FALSE, 0);

      label = Gtk2::Label->new("Base:");
      gtk_misc_set_alignment (GTK_MISC (label), 0.0, 0.5);
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      entry = Gtk2::Entry->new;
      gtk_entry_set_text (GTK_ENTRY (entry), "Some Text");
      gtk_widget_modify_base (entry, GTK_STATE_NORMAL, &yellow);
      gtk_box_pack_start (vbox, entry, FALSE, FALSE, 0);

      label = Gtk2::Label->new("Multiple:");
      gtk_misc_set_alignment (GTK_MISC (label), 0.0, 0.5);
      gtk_box_pack_start (vbox, label, FALSE, FALSE, 0);

      button = Gtk2::Button->new("Some Text");

      rc_style = Gtk2::RC::Style->new;

      rc_style->font_desc = pango_font_description_copy (font_desc);
      rc_style->color_flags[GTK_STATE_NORMAL] = GTK_RC_FG | GTK_RC_BG;
      rc_style->color_flags[GTK_STATE_PRELIGHT] = GTK_RC_FG | GTK_RC_BG;
      rc_style->color_flags[GTK_STATE_ACTIVE] = GTK_RC_FG | GTK_RC_BG;
      rc_style->fg[GTK_STATE_NORMAL] = yellow;
      rc_style->bg->[GTK_STATE_NORMAL] = blue;
      rc_style->fg[GTK_STATE_PRELIGHT] = blue;
      rc_style->bg->[GTK_STATE_PRELIGHT] = yellow;
      rc_style->fg[GTK_STATE_ACTIVE] = red;
      rc_style->bg->[GTK_STATE_ACTIVE] = cyan;
      rc_style->xthickness = 5;
      rc_style->ythickness = 5;

      gtk_widget_modify_style (button, rc_style);
      gtk_widget_modify_style (GTK_BIN (button)->child, rc_style);

      g_object_unref (rc_style);
      
      $vbox->pack_start($button, FALSE, FALSE, 0);
    }
  
  if (!GTK_WIDGET_VISIBLE (window))
    $window->show_all;
  else
    gtk_widget_destroy (window);
}

# Main Window and Exit

sub do_exit
{
  my ($widget, $window) = @_;
  $window->destroy;
  Gtk2->quit;
}

use constant LABEL => 0;
use constant FUNC => 1;
use constant DO_NOT_BENCHMARK => 2;

my $buttons =
[
  [ "big windows", \&create_big_windows ],
  [ "button box", \&create_button_box ],
  [ "buttons", \&create_buttons ],
  [ "check buttons", \&create_check_buttons ],
  [ "clist", \&create_clist],
  [ "color selection", \&create_color_selection ],
  [ "ctree", \&create_ctree ],
  [ "cursors", \&create_cursors ],
  [ "dialog", \&create_dialog ],
  [ "display & screen", \&create_display_screen ],
  [ "entry", \&create_entry ],
  [ "event watcher", \&create_event_watcher ],
  [ "file selection", \&create_file_selection ],
  [ "flipping", \&create_flipping ],
  [ "focus", \&create_focus ],
  [ "font selection", \&create_font_selection ],
  [ "gamma curve", \&create_gamma_curve, TRUE ],
  [ "gridded geometry", \&create_gridded_geometry, TRUE ],
  [ "handle box", \&create_handle_box ],
  [ "image from drawable", \&create_get_image ],
  [ "image", \&create_image ],
  [ "item factory", \&create_item_factory ],
  [ "key lookup", \&create_key_lookup ],
  [ "labels", \&create_labels ],
  [ "layout", \&create_layout ],
  [ "list", \&create_list ],
  [ "menus", \&create_menus ],
  [ "message dialog", \&create_message_dialog ],
  [ "modal window", \&create_modal_window, TRUE ],
  [ "notebook", \&create_notebook ],
  [ "panes", \&create_panes ],
  [ "paned keyboard", \&create_paned_keyboard_navigation ],
  [ "pixmap", \&create_pixmap ],
  [ "preview color", \&create_color_preview, TRUE ],
  [ "preview gray", \&create_gray_preview, TRUE ],
  [ "progress bar", \&create_progress_bar ],
  [ "properties", \&create_properties ],
  [ "radio buttons", \&create_radio_buttons ],
  [ "range controls", \&create_range_controls ],
  [ "rc file", \&create_rc_file ],
  [ "reparent", \&create_reparent ],
  [ "resize grips", \&create_resize_grips ],
  [ "rulers", \&create_rulers ],
  [ "saved position", \&create_saved_position ],
  [ "scrolled windows", \&create_scrolled_windows ],
  [ "shapes", \&create_shapes ],
  [ "size groups", \&create_size_groups ],
  [ "spinbutton", \&create_spins ],
  [ "statusbar", \&create_statusbar ],
  [ "styles", \&create_styles ],
  [ "test idle", \&create_idle_test ],
  [ "test mainloop", \&create_mainloop, TRUE ],
  [ "test scrolling", \&create_scroll_test ],
  [ "test selection", \&create_selection_test ],
  [ "test timeout", \&create_timeout_test ],
  [ "text", \&create_text ],
  [ "toggle buttons", \&create_toggle_buttons ],
  [ "toolbar", \&create_toolbar ],
  [ "tooltips", \&create_tooltips ],
  [ "tree", \&create_tree_mode_window],
  [ "WM hints", \&create_wmhints ],
  [ "window sizing", \&create_window_sizing ],
  [ "window states", \&create_window_states ],
];

sub create_main_window (void)
{
  my ($button);
  my $window = Gtk2::Window->new('toplevel');
  $window->set_name("main window");
  $window->set_uposition(20, 20);
  $window->set_default_size(-1, 400);
  my $geometry;
  $geometry->min_width(-1);
  $geometry->min_height(-1);
  $geometry->max_width(-1);
  $geometry->max_height(G_MAXSHORT);
  $window->set_geometry_hints(NULL, $geometry, GDK_HINT_MIN_SIZE | GDK_HINT_MAX_SIZE);
  $window->signal_connect("destroy" => sub { Gtk2->quit });
  $window->signal_connect("delete-event" => sub { Gtk2->false });
  my $box1 = Gtk2::VBox->new(FALSE, 0);
  $window->add($box1);
  my $buffer = sprintf("Gtk+ v%d.%d.%d",
		       gtk_major_version, gtk_minor_version, gtk_micro_version);
  my $label = Gtk2::Label->new($buffer);
  $box1->pack_start($label, FALSE, FALSE, 0);
  $label->set_name("testgtk-version-label");
  my $scrolled_window = Gtk2::ScrolledWindow->new;
  $scrolled_window->set_border_width(10);
  $scrolled_window->set_policy(GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC);
  $box1->pack_start($scrolled_window, TRUE, TRUE, 0);
  my $box2 = Gtk2::VBox->new(FALSE, 0);
  $box2->set_border_width(10);
  $scrolled_window->add_with_viewport($box2);
  $box2->set_focus_vadjustment($scrolled_window->get_vadjustment);
  $box->show;
  for (my $i = 0; $i < scalar @$buttons; $i++)
    {
      $button = Gtk2::Button->new($buttons->[$i]->[LABEL]);
      if (defined $buttons->[$i]->[FUNC])
	{
	  $button->signal_connect ("clicked" => $buttons->[$i]->[FUNC]);
	}
      else
	{
	  $button->set_sensitive(FALSE);
	}
      $box2->pack_start($button, TRUE, TRUE, 0);
    }
  my $separator = Gtk2::HSeparator->new;
  $box1->pack_start($separator, FALSE, TRUE, 0);
  $box2 = Gtk2::VBox->new(FALSE, 10);
  $box2->set_border_width(10);
  $box1->pack_start($box2, FALSE, TRUE, 0);
  $button = Gtk2::Button->new_with_mnemonic("_Close");
  $button->signal_connect("clicked" => \&do_exit, $window);
  $box2->pack_start($button, TRUE, TRUE, 0);
  $button->SET_FLAGS(Gtk2->CAN_DEFAULT);
  $button->grab_default;
  $window->show_all;
}

sub test_init ()
{
  if (g_file_test ("../gdk-pixbuf/libpixbufloader-pnm.la",
		   G_FILE_TEST_EXISTS))
    {
      putenv ("GDK_PIXBUF_MODULE_FILE=../gdk-pixbuf/gdk-pixbuf.loaders");
      putenv ("GTK_IM_MODULE_FILE=../modules/input/gtk.immodules");
    }
}

sub pad
{
  my ($str, $to) = @_;
  $str . ' ' x ($to - length $str);
}

sub bench_iteration
{
  my ($widget, $fn) = @_;
  $fn->($widget); # on
  while (g_main_context_iteration (NULL, FALSE));
  $fn->($widget); # off
  while (g_main_context_iteration (NULL, FALSE));
}

sub do_real_bench (GtkWidget *widget, void (* fn) (GtkWidget *widget), char *name, int num)
{
  GTimeVal tv0, tv1;
  double dt_first;
  double dt;
  int n;
  static gboolean printed_headers = FALSE;

  unless ($printed_headers) {
    print "Test                 Iters      First      Other\n";
    print "-------------------- ----- ---------- ----------\n";
    $printed_headers = TRUE;
  }

  g_get_current_time (&tv0);
  bench_iteration (widget, fn); 
  g_get_current_time (&tv1);

  dt_first = ((double)tv1.tv_sec - tv0.tv_sec) * 1000.0
	+ (tv1.tv_usec - tv0.tv_usec) / 1000.0;

  g_get_current_time (&tv0);
  for (n = 0; n < num - 1; n++)
    bench_iteration (widget, fn); 
  g_get_current_time (&tv1);
  dt = ((double)tv1.tv_sec - tv0.tv_sec) * 1000.0
	+ (tv1.tv_usec - tv0.tv_usec) / 1000.0;

  g_print ("%s %5d ", pad (name, 20), num);
  if (num > 1)
    g_print ("%10.1f %10.1f\n", dt_first, dt/(num-1));
  else
    g_print ("%10.1f\n", dt_first);
}

sub do_bench
{
  my ($what, $num) = @_;
  my $widget = Gtk2::Window->new('toplevel');
  if ($what eq "ALL")
    {
      for (my $i = 0; $i < scalar @$buttons; $i++)
	{
	  do_real_bench($widget, $buttons->[$i]->[FUNC], $buttons->[$i]->[LABEL], $num)
	    unless defined $buttons->[$i]->[DO_NOT_BENCHMARK];
	}
    }
  else
    {
      my $fn;
      for (my $i = 0; $i < scalar @$buttons; $i++)
	{
	  if ($buttons->[$i]->[LABEL] eq $what)
	    {
	      $fn = $buttons->[$i]->[FUNC];
	      last;
	    }
	}
      unless (defined $fn) { printf ("Can't bench: \"%s\" not found.\n", $what); }
      else { do_real_bench ($widget, $fn, $buttons->[$i]->[LABEL], $num); }
    }
}

sub usage()
{
  printf STDERR "Usage: testgtk [--bench ALL|<bench>[:<count>]]\n";
  exit(1);
}

my $done_benchmarks = FALSE;
srand(time());
test_init();
# Check to see if we are being run from the correct directory.
Gtk2::RC->add_default_file("testgtkrc") if -e "testgtkrc";
Gtk2::GLib->set_application_name("GTK+ Test Program");
Gtk2->init(\@ARGV);
# benchmarking
#for (my $i = 1; $i < scalar @ARGV; $i++)
my $dobench = 0;
for (@ARGV)
  {
    if (/^--bench$/)
      {
	$dobench++;
	next;
      }
    usage() unless $dobench;
    my ($what, $num) = ($1,$2) if /(\w+)\:?(\d*)/;
    $num = 1 unless $num;
    do_bench (what, num ? num : 1);
    $done_benchmarks = TRUE;
  }
exit 0 if $done_benchmarks;
# bindings test
#GtkBindingSet *binding_set;
my $binding_set = Gtk2::Binding->set_by_class(gtk_type_class(GTK_TYPE_WIDGET));
gtk_binding_entry_add_signal (binding_set,'9', GDK_CONTROL_MASK | GDK_RELEASE_MASK,
			      "debug_msg", 1,
			      G_TYPE_STRING, "GtkWidgetClass <ctrl><release>9 test");
# We use gtk_rc_parse_string() here so we can make sure it works across theme changes
Gtk2::RC->parse_string("style \"testgtk-version-label\" { fg[NORMAL] = \"#ff0000\"\n font = \"Sans 18\"\n }\n widget \"*.testgtk-version-label\" style \"testgtk-version-label\"");
create_main_window();
Gtk2->main;
g_main_context_iteration (NULL, FALSE) while (g_main_context_pending);
0;

