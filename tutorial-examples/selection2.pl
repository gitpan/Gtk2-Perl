#!/usr/bin/perl -w

# $Id: selection2.pl,v 1.6 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-supplyingtheselection.html

use Gtk2;

sub TRUE  {1}
sub FALSE {0}


my ($selection_button, $selection_widget);

#/* Callback when the user toggles the selection */
sub selection_toggled
{
  my ($widget, $have_selection) = @_;
  if ($widget->active)
    {
      $$have_selection = $selection_widget->selection_owner_set('PRIMARY', Gtk2::Gdk->CURRENT_TIME);
      # if claiming the selection failed, we return the button to the out state */
      $widget->set_active(FALSE) unless $$have_selection;
    }
  else
    {
      if ($$have_selection)
	{
	  print STDERR "HAVE1: ", Gtk2::Gdk::Selection->owner_get('PRIMARY'), " / ", $widget->window, "\n";
	  printf STDERR "HAVE2: %x / %x \n", 
	    ${Gtk2::Gdk::Selection->owner_get('PRIMARY')}, ${$widget->window};
	  printf STDERR "HAVE3: %x / %x \n", 
	    ${${Gtk2::Gdk::Selection->owner_get('PRIMARY')}}, ${${$widget->window}};
	  printf STDERR "ISA: %x\n", ${$widget->window};
	  # Before clearing the selection by setting the owner to undef, we check if we are the actual owner
	  Gtk2::Widget->selection_owner_set ('PRIMARY',  Gtk2::Gdk->CURRENT_TIME)
	    if Gtk2::Gdk::Selection->owner_get('PRIMARY') == $widget->window;
	  $$have_selection = FALSE;
	}
    }
}

# Called when another application claims the selection
sub selection_clear
  {
    my ($widget, $have_selection, $event) = @_;
    $have_selection = FALSE;
    $selection_button->set_active(FALSE);
    return TRUE;
  }

# Supplies the current time as the selection
sub selection_handle
  {
    my ($widget, $selection_data, $info, $time_stamp, $data) = @_;
    my $timestr = localtime;
    print STDERR "Set: $timestr\n";
    $selection_data->set('STRING', 8, $timestr);
  }

# main

my $have_selection = FALSE;

Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Event Box");
$window->set_border_width(10);
$window->signal_connect("destroy", sub{exit(0)});
# Create a toggle button to act as the selection
$selection_widget = Gtk2::Invisible->new;
$selection_button = Gtk2::ToggleButton->new_with_label("Claim Selection");
$window->add($selection_button);
$selection_button->show;
$selection_button->signal_connect("toggled", \&selection_toggled, \$have_selection);
$selection_widget->signal_connect("selection_clear_event", \&selection_clear, \$have_selection);
$selection_widget->selection_add_target('PRIMARY', 'STRING', 1);
$selection_widget->signal_connect("selection_get", \&selection_handle, \$have_selection);
$selection_button->show;
$window->show;
Gtk2->main;



