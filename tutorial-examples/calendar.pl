#!/usr/bin/perl -w

# $Id: calendar.pl,v 1.5 2002/11/12 20:30:02 gthyni Exp $
# perl adaption
# Copyright 2002, Göran Thyni, kirra.net
#
# adapted from
# http://www.gtk.org/tutorial/sec-calendar.html
#
# Copyright (C) 1998 Cesar Miquel, Shawn T. Amundson, Mattias Grönlund
# Copyright (C) 2000 Tony Gale
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

use Gtk2;

use POSIX qw(mktime gmtime strftime);


sub TRUE  {1}
sub FALSE {0}

sub DEF_PAD {10}
sub DEF_PAD_SMALL {5}
sub TM_YEAR_BASE {1900}

#typedef struct _CalendarData {
#  GtkWidget *flag_checkboxes[5];
#  gboolean  settings[5];
#  gchar     *font;
#  GtkWidget *font_dialog;
#  GtkWidget *window;
#  GtkWidget *prev2_sig;
#  GtkWidget *prev_sig;
#  GtkWidget *last_sig;
#  GtkWidget *month;
#} CalendarData;

sub calendar_show_header  {0}
sub calendar_show_days    {1}
sub calendar_month_change {2}
sub calendar_show_week    {3}
sub calendar_monday_first {4}


sub calendar_date_to_string
{
  my ($data) = @_;
  my $time; # time_t time;
  #memset (&tm, 0, sizeof (tm));
  my ($year, $mon, $mday) = $data->{window}->get_date;
  $year -= TM_YEAR_BASE;
  $time = mktime(0,0,12,$mday,$mon,$year);
  return strftime("%x", gmtime($time));
}

sub calendar_set_signal_strings
{
  my ($sig_str, $data) = @_;
  my $prev_sig = $data->{prev_sig}->get_text;
  $data->{prev2_sig}->set_text($prev_sig);
  $prev_sig = $data->{last_sig}->get_text;
  $data->{prev_sig}->set_text($prev_sig);
  $data->{last_sig}->set_text($sig_str);
}

sub calendar_month_changed
{
  my ($widget,$data) = @_;
  my $buffer = "month_changed: " . calendar_date_to_string($data);
  calendar_set_signal_strings($buffer, $data);
}

sub calendar_day_selected
{
  my ($widget,$data) = @_;
  my $buffer = "day_selected: " . calendar_date_to_string($data);
  calendar_set_signal_strings($buffer, $data);
}

sub calendar_day_selected_double_click
  {
    my ($widget, $data) = @_;
    my $tm = {};
    my $buffer = "day_selected_double_click: " . calendar_date_to_string($data);
    calendar_set_signal_strings($buffer, $data);
    ($tm->{tm_year}, $tm->{tm_mon}, $tm->{tm_mday}) = $data->{window}->get_date;
    $tm->{tm_year} -= TM_YEAR_BASE;
    if (($data->{window}->marked_date)[$tm->{tm_mday} - 1] == 0)
      {	$data->{window}->mark_day($tm->{tm_mday}); }
    else
      { $data->{window}->unmark_day($tm->{tm_mday}); }
  }

sub calendar_prev_month
{
  my ($widget, $data) = @_;
  my $buffer = "prev_month: " . calendar_date_to_string($data);
  calendar_set_signal_strings($buffer, $data);
}

sub calendar_next_month
{
  my ($widget, $data) = @_;
  $buffer = "next_month: " . calendar_date_to_string($data);
  calendar_set_signal_strings($buffer, $data);
}

sub calendar_prev_year
{
  my ($widget,$data) = @_;
  my $buffer = "prev_year: " . calendar_date_to_string($data);
  calendar_set_signal_strings($buffer, $data);
}

sub calendar_next_year
{
  my ($widget,$data) = @_;
  my $buffer = "next_year: " . calendar_date_to_string($data);
  calendar_set_signal_strings($buffer, $data);
}


sub calendar_set_flags
{
  my $calendar = shift;
  my $options = 0;
  for (my $i = 0; $i < 5; $i++)
    {
      if ($calendar->{settings}[$i])
	{
	  $options = $options + (1 << $i);
	}
    }
  if ($calendar->{window})
    {
      $calendar->{window}->display_options($options);
    }
}

sub calendar_toggle_flag
{
  my ($toggle, $calendar) = @_;
  my $j = 0;
  for (my $i = 0; $i < 5; $i++)
    {
      $j = $i if $calendar->{flag_checkboxes}[$i] == $toggle;
    }
  $calendar->{settings}[$j] = ! $calendar->{settings}[$j];
  calendar_set_flags($calendar);
}

sub calendar_font_selection_ok
{
  my ($button, $calendar) = @_;
  $calendar->{font} = $calendar->{font_dialog}->get_font_name;
  if ($calendar->{window})
    {
      my $font_desc = Gtk2::Pango::FontDescription->from_string($calendar->{font});
      if ($font_desc)
	{
	  my $style = $calendar->{window}->get_style->copy;
	  $style->set_font_desc($font_desc);
	  $calendar->{window}->set_style($style);
	}
      $calendar->{font_dialog}->destroy;
      $calendar->{font_dialog} = undef;
    }
}

sub calendar_font_selection_cancel
{
  my ($button, $calendar) = @_;
  $calendar->{font_dialog}->destroy;
  $calendar->{font_dialog} = undef;
}

sub calendar_select_font
{
  my ($button,$calendar) = @_;
  my $window;
  if (!$calendar->{font_dialog})
    {
      $window = Gtk2::FontSelectionDialog->new("Font Selection Dialog");
      return unless ref $window;
      $calendar->{font_dialog} = $window;
      $window->set_position('mouse');
      Gtk2::GSignal->connect($window, "destroy", sub { my ($w,$d)=@_; $w->destroyed($d) }, $calendar->{font_dialog});
      Gtk2::GSignal->connect($window->ok_button, "clicked", \&calendar_font_selection_ok, $calendar);
      #Gtk2::GSignal->connect_swapped($window->cancel_button, "clicked", sub { shift->destroy }, $calendar->{font_dialog});
      Gtk2::GSignal->connect($window->cancel_button, "clicked", \&calendar_font_selection_cancel, $calendar);
    }
  $window = $calendar->{font_dialog};
  if (! $window->visible) { $window->show; }
  else { $window->destroy; }
}

my $calendar_data; # CalendarData

sub create_calendar
{
  my @flags = ('Show Heading', 'Show Day Names', 'No Month Change', 'Show Week Numbers', 'Week Start Monday');
  $calendar_data = {};
  for (my $i = 0; $i < 5; $i++)
    {
      $calendar_data->{settings}[$i] = 0;
    }
  my $window = Gtk2::Window->new('toplevel');
  $window->set_title("GtkCalendar Example");
  $window->set_border_width(5);
  Gtk2::GSignal->connect($window, "destroy", sub { Gtk2->quit });
  Gtk2::GSignal->connect($window, "delete-event", sub { Gtk2->false });
  $window->set_resizable(FALSE);
  my $vbox = Gtk2::VBox->new(FALSE, DEF_PAD);
  $window->add($vbox);
  # The top part of the window, Calendar, flags and fontsel.
  my $hbox = Gtk2::HBox->new(FALSE, DEF_PAD);
  $vbox->pack_start($hbox, TRUE, TRUE, DEF_PAD);
  my $hbbox = Gtk2::HButtonBox->new;
  $hbox->pack_start($hbbox, FALSE, FALSE, DEF_PAD);
  $hbbox->set_layout('start');
  $hbbox->set_spacing(5);
  # Calendar widget
  my $frame = Gtk2::Frame->new("Calendar");
  $hbbox->pack_start($frame, FALSE, TRUE, DEF_PAD);
  my $calendar= Gtk2::Calendar->new;
  $calendar_data->{window} = $calendar;
  calendar_set_flags($calendar_data);
  $calendar->mark_day(19);
  $frame->add($calendar);
  Gtk2::GSignal->connect($calendar, "month_changed", \&calendar_month_changed, $calendar_data);
  Gtk2::GSignal->connect($calendar, "day_selected", \&calendar_day_selected, $calendar_data);
  Gtk2::GSignal->connect($calendar, "day_selected_double_click", \&calendar_day_selected_double_click, $calendar_data);
  Gtk2::GSignal->connect($calendar, "prev_month", \&calendar_prev_month, $calendar_data);
  Gtk2::GSignal->connect($calendar, "next_month", \&calendar_next_month, $calendar_data);
  Gtk2::GSignal->connect($calendar, "prev_year", \&calendar_prev_year, $calendar_data);
  Gtk2::GSignal->connect($calendar, "next_year", \&calendar_next_year, $calendar_data);
  my $separator = Gtk2::VSeparator->new;
  $hbox->pack_start($separator, FALSE, TRUE, 0);
  my $vbox2 = Gtk2::VBox->new(FALSE, DEF_PAD);
  $hbox->pack_start($vbox2, FALSE, FALSE, DEF_PAD);
  # Build the Right frame with the flags in
  $frame = Gtk2::Frame->new("Flags");
  $vbox2->pack_start($frame, TRUE, TRUE, DEF_PAD);
  my $vbox3 = Gtk2::VBox->new(TRUE, DEF_PAD_SMALL);
  $frame->add($vbox3);
  for ($i = 0; $i < 5; $i++)
    {
      my $toggle = Gtk2::CheckButton->new_with_label($flags[$i]);
      Gtk2::GSignal->connect($toggle, "toggled", \&calendar_toggle_flag, $calendar_data);
      $vbox3->pack_start($toggle, TRUE, TRUE, 0);
      $calendar_data->{flag_checkboxes}[$i] = $toggle;
    }
  # Build the right font-button
  my $button = Gtk2::Button->new_with_label("Font...");
  Gtk2::GSignal->connect($button, "clicked", \&calendar_select_font, $calendar_data);
  $vbox2->pack_start($button, FALSE, FALSE, 0);
  # Build the Signal-event part.
  $frame = Gtk2::Frame->new("Signal events");
  $vbox->pack_start($frame, TRUE, TRUE, DEF_PAD);
  $vbox2 = Gtk2::VBox->new(TRUE, DEF_PAD_SMALL);
  $frame->add($vbox2);
  $hbox = Gtk2::HBox->new(FALSE, 3);
  $vbox2->pack_start($hbox, FALSE, TRUE, 0);
  my $label = Gtk2::Label->new("Signal:");
  $hbox->pack_start($label, FALSE, TRUE, 0);
  $calendar_data->{last_sig} = Gtk2::Label->new("");
  $hbox->pack_start($calendar_data->{last_sig}, FALSE, TRUE, 0);
  $hbox = Gtk2::HBox->new(FALSE, 3);
  $vbox2->pack_start($hbox, FALSE, TRUE, 0);
  $label = Gtk2::Label->new("Previous signal:");
  $hbox->pack_start($label, FALSE, TRUE, 0);
  $calendar_data->{prev_sig} = Gtk2::Label->new("");
  $hbox->pack_start($calendar_data->{prev_sig}, FALSE, TRUE, 0);
  $hbox = Gtk2::HBox->new(FALSE, 3);
  $vbox2->pack_start($hbox, FALSE, TRUE, 0);
  $label = Gtk2::Label->new("Second previous signal:");
  $hbox->pack_start($label, FALSE, TRUE, 0);
  $calendar_data->{prev2_sig} = Gtk2::Label->new("");
  $hbox->pack_start($calendar_data->{prev2_sig}, FALSE, TRUE, 0);
  my $bbox = Gtk2::HButtonBox->new;
  $vbox->pack_start($bbox, FALSE, FALSE, 0);
  $bbox->set_layout('end');
  $button = Gtk2::Button->new_with_label("Close");
  Gtk2::GSignal->connect($button, "clicked", sub { Gtk2->quit });
  $bbox->add($button);
  $button->SET_FLAGS('can-default');
  $button->grab_default;
  $window->show_all;
}


Gtk2->init(\@ARGV);
&create_calendar;
Gtk2->main;
0;


