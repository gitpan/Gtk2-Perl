#!/usr/bin/perl -w

# $Id: scrolledwin.pl,v 1.5 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-scrolledwindows.html

use Gtk2;


sub TRUE  {1}
sub FALSE {0}

my $button;
Gtk2->init(\@ARGV);
# Create a new dialog window for the scrolled window to be packed into.
my $window = Gtk2::Dialog->new;
$window->signal_connect("destroy" => sub { Gtk2->quit });
$window->set_title("GtkScrolledWindow example");
$window->set_border_width(0);
$window->set_size_request(300, 300);
# create a new scrolled window.
my $scrolled_window = Gtk2::ScrolledWindow->new;
$scrolled_window->set_border_width(10);
# the policy is one of 'automatic', or 'always'.
# 'automatic' will automatically decide whether you need
# scrollbars, whereas 'always' will always leave the scrollbars
# there.  The first one is the horizontal scrollbar, the second, 
# the vertical.
$scrolled_window->set_policy('automatic', 'always');
# The dialog window is created with a vbox packed into it.
$window->vbox->pack_start($scrolled_window, TRUE, TRUE, 0);
$scrolled_window->show;
# create a table of 10 by 10 squares.
my $table = Gtk2::Table->new(10, 10, FALSE);
# set the spacing to 10 on x and 10 on y
$table->set_row_spacings(10);
$table->set_col_spacings(10);
# pack the table into the scrolled window
$scrolled_window->add_with_viewport($table);
$table->show;
# this simply creates a grid of toggle buttons on the table
# to demonstrate the scrolled window.
for (my $i = 0; $i < 10; $i++) {
  for (my $j = 0; $j < 10; $j++) {
    my $buffer = sprintf("button (%d,%d)\n", $i, $j);
    $button = Gtk2::ToggleButton->new($buffer);
    $table->attach_defaults($button, $i, $i + 1, $j, $j + 1);
    $button->show;
  }
} 
# Add a "close" button to the bottom of the dialog
$button = Gtk2::Button->new_with_label("close");
$button->signal_connect_swapped("clicked", sub { shift->destroy; }, $window);
# this makes it so the button is the default.
$button->SET_FLAGS('can-default');
$window->action_area->pack_start($button, TRUE, TRUE, 0);
# This grabs this button to be the default button. Simply hitting
# the "Enter" key will cause this button to activate.
$button->grab_default;
$button->show;
$window->show;
Gtk2->main;
0;
