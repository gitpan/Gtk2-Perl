#!/usr/bin/perl -w

# $Id: toolbar.pl,v 1.7 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-toolbar.html

use strict;
use diagnostics;
use Gtk2;
use IO::File;


sub TRUE  {1}
sub FALSE {0}

# Of course, to appreciate it in full you need also this nice XPM icon, so here it is:

# XPM
my $gtk_xpm = join('',
		   '32 39 5 1',
		   '.      c none',
		   '+      c black',
		   '@      c #3070E0',
		   '#      c #F05050',
		   '$      c #35E035',
		   '................+...............',
		   '..............+++++.............',
		   '............+++++@@++...........',
		   '..........+++++@@@@@@++.........',
		   '........++++@@@@@@@@@@++........',
		   '......++++@@++++++++@@@++.......',
		   '.....+++@@@+++++++++++@@@++.....',
		   '...+++@@@@+++@@@@@@++++@@@@+....',
		   '..+++@@@@+++@@@@@@@@+++@@@@@++..',
		   '.++@@@@@@+++@@@@@@@@@@@@@@@@@@++',
		   '.+#+@@@@@@++@@@@+++@@@@@@@@@@@@+',
		   '.+##++@@@@+++@@@+++++@@@@@@@@$@.',
		   '.+###++@@@@+++@@@+++@@@@@++$$$@.',
		   '.+####+++@@@+++++++@@@@@+@$$$$@.',
		   '.+#####+++@@@@+++@@@@++@$$$$$$+.',
		   '.+######++++@@@@@@@++@$$$$$$$$+.',
		   '.+#######+##+@@@@+++$$$$$$@@$$+.',
		   '.+###+++##+##+@@++@$$$$$$++$$$+.',
		   '.+###++++##+##+@@$$$$$$$@+@$$@+.',
		   '.+###++++++#+++@$$@+@$$@++$$$@+.',
		   '.+####+++++++#++$$@+@$$++$$$$+..',
		   '.++####++++++#++$$@+@$++@$$$$+..',
		   '.+#####+++++##++$$++@+++$$$$$+..',
		   '.++####+++##+#++$$+++++@$$$$$+..',
		   '.++####+++####++$$++++++@$$$@+..',
		   '.+#####++#####++$$+++@++++@$@+..',
		   '.+#####++#####++$$++@$$@+++$@@..',
		   '.++####++#####++$$++$$$$$+@$@++.',
		   '.++####++#####++$$++$$$$$$$$+++.',
		   '.+++####+#####++$$++$$$$$$$@+++.',
		   '..+++#########+@$$+@$$$$$$+++...',
		   '...+++########+@$$$$$$$$@+++....',
		   '.....+++######+@$$$$$$$+++......',
		   '......+++#####+@$$$$$@++........',
		   '.......+++####+@$$$$+++.........',
		   '.........++###+$$$@++...........',
		   '..........++##+$@+++............',
		   '...........+++++++..............',
		   '.............++++...............');


# This function is connected to the Close button or
# closing the window from the WM
sub delete_event
{
  Gtk2->quit;
  return FALSE;
}

# The above beginning seems for sure familiar to you if it's not your first GTK program. 
# There is one additional thing though, we include a nice XPM picture to serve as an icon
# for all of the buttons.

my $close_button;    # This button will emit signal to close application
my $tooltips_button; # to enable/disable tooltips
my ($text_button,$icon_button,$both_button); # radio buttons for toolbar style
my $entry; # a text entry to show packing any widget into toolbar

# In fact not all of the above widgets are needed here, 
# but to make things clearer I put them all together.

# that's easy... when one of the buttons is toggled, we just
# check which one is active and set the style of the toolbar
# accordingly
# ATTENTION: our toolbar is passed as data to callback !

sub radio_clicked
  {
    my ($widget, $data) = @_;
    if ($text_button->active) {
      $data->set_style('text');
    }
    elsif ($icon_button->active) {
      $data->set_style('icons');
    }
    elsif ($both_button->active) {
      $data->set_style('both');
    }
  }

# even easier, just check given toggle button and enable/disable tooltips

sub toggle_clicked
  {
    my ($widget, $data) = @_;
    $data->set_tooltips($widget->active);
  }

# The above are just two callback functions that will be called 
# when one of the buttons on a toolbar is pressed. You should
# already be familiar with things like this if you've already 
# used toggle buttons (and radio buttons).


# Here is our main window (a dialog) and a handle for the handlebox
my $dialog;
my $handlebox;
# Ok, we need a toolbar, an icon with a mask (one for all of
# the buttons) and an icon widget to put this icon in 
# (but we'll create a separate widget for each button)
my $toolbar;
my $iconw;
# this is called in all GTK application.
Gtk2->init(\@ARGV);
# create a new window with a given title, and nice size
$dialog = Gtk2::Dialog->new;
$dialog->set_title('GTKToolbar Tutorial');
$dialog->set_size_request(600, 300);
$dialog->allow_shrink(TRUE);
# typically we quit if someone tries to close us */
$dialog->signal_connect('delete_event', \&delete_event);
# we need to realize the window because we use pixmaps for 
# items on the toolbar in the context of it */
$dialog->realize;
# to make it nice we'll put the toolbar into the handle box, 
# so that it can be detached from the main window */
$handlebox = Gtk2::HandleBox->new;
$dialog->vbox->pack_start($handlebox, FALSE, FALSE, 5);
# The above should be similar to any other GTK application.
# Just initialization of GTK, creating the window, etc. 
# There is only one thing that probably needs some explanation: a handle box.
# A handle box is just another box that can be used to pack widgets in to.
#  The difference between it and typical boxes is that it can be detached 
# from a parent window (or, in fact, the handle box remains in the parent,
# but it is reduced to a very small rectangle, while all of its contents are
# reparented to a new freely floating window).
# It is usually nice to have a detachable toolbar,
# so these two widgets occur together quite often.
#
# toolbar will be horizontal, with both icons and text, and
# with 5pxl spaces between items and finally, 
# we'll also put it into our handlebox */
$toolbar = Gtk2::Toolbar->new;
$toolbar->set_orientation('horizontal');
$toolbar->set_style('both');
$toolbar->set_border_width(5);
#$toolbar->set_space_size(5); # Huh? function does not exist!
$handlebox->add($toolbar);
# Well, what we do above is just a straightforward initialization of the toolbar widget.
#
# our first item is <close> button */

# write the file on the fly
# FIXME but we want to use loading from memory
#like:
#$iconw = Gtk2::Image->new_from_pixmap(Gtk2::Gdk::Pixmap->create_from_d($gtk_xpm), undef);
my $xpmfile = 'gtk.xpm';
my $xpm = IO::File->new("> $xpmfile"); print $xpm $gtk_xpm; $xpm->close;
$iconw = Gtk2::Image->new_from_file($xpmfile); # icon widget
$close_button =
  $toolbar->append_item('Close',           # button label
			'Closes this app', # this button's tooltip
			'Private',         # tooltip private info
			$iconw,             # icon widget
			\&delete_event);    # a signal
$toolbar->append_space; # space after item
# In the above code you see the simplest case: adding a button to toolbar.
# Just before appending a new item, we have to construct an image widget to
# serve as an icon for this item; this step will have to be repeated for each
# new item.
# Just after the item we also add a space, so the following items will not touch each other.
# As you see gtk_toolbar_append_item() returns a pointer to our newly created button widget,
# so that we can work with it in the normal way.
#
# now, let's make our radio buttons group...
$iconw = Gtk2::Image->new_from_file($xpmfile);
$icon_button = 
  $toolbar->append_element ('radiobutton', # a type of element */
			    undef,                          # pointer to widget */
			    'Icon',                        # label */
			    'Only icons in toolbar',       # tooltip */
			    'Private',                     # tooltip private string */
			    $iconw,                         # icon */
			    \&radio_clicked,                # signal */
			    $toolbar);                      # data for signal */
$toolbar->append_space;
# Here we begin creating a radio buttons group.
# To do this we use gtk_toolbar_append_element.
# In fact, using this function one can also +add simple items 
# or even spaces (type = GTK_TOOLBAR_CHILD_SPACE or +GTK_TOOLBAR_CHILD_BUTTON).
# In the above case we start creating a radio group.
# In creating other radio buttons for this group a pointer 
# to the previous button in the group is required,
# so that a list of buttons can be easily constructed
# (see the section on Radio Buttons earlier in this tutorial).
#
# following radio buttons refer to previous ones
$iconw = Gtk2::Image->new_from_file($xpmfile);
$text_button = 
  $toolbar->append_element('radiobutton',
			   $icon_button,
			   'Text',
			   'Only texts in toolbar',
			   'Private',
			   $iconw,
			   \&radio_clicked,
			   $toolbar);
$toolbar->append_space;
$iconw = Gtk2::Image->new_from_file($xpmfile);
$both_button = 
  $toolbar->append_element('radiobutton',
			   $text_button,
			   'Both',
			   'Icons and text in toolbar',
			   'Private',
			   $iconw,
			   \&radio_clicked,
			   $toolbar);
$toolbar->append_space;
$both_button->set_active(TRUE);
# In the end we have to set the state of one of the buttons manually
# (otherwise they all stay in active state, preventing us from switching between them).
#
# here we have just a simple toggle button
$iconw = Gtk2::Image->new_from_file($xpmfile);
$tooltips_button = 
  $toolbar->append_element('togglebutton',
			   undef,
			   'Tooltips',
			   'Toolbar with or without tips',
			   'Private',
			   $iconw,
			   \&toggle_clicked,
			   $toolbar);
$toolbar->append_space;
$tooltips_button->set_active(TRUE);
# A toggle button can be created in the obvious way 
# (if one knows how to create radio buttons already).
#
# to pack a widget into toolbar, we only have to 
# create it and append it with an appropriate tooltip
$entry = Gtk2::Entry->new;
$toolbar->append_widget($entry, 'This is just an entry', 'Private');
# well, it isn't created within the toolbar, so we must still show it */
$entry->show;
# As you see, adding any kind of widget to a toolbar is simple.
# The one thing you have to remember is that this widget must be shown manually
# (contrary to other items which will be shown together with the toolbar).
#
# that's it ! let's show everything.
$toolbar->show;
$handlebox->show;
$dialog->show;
# rest in gtk_main and wait for the fun to begin!
unlink $xpmfile;
Gtk2->main;
0;

