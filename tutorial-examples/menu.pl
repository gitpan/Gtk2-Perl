#!/usr/bin/perl -w

# $Id: menu.pl,v 1.6 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-manualmenuexample.html

use Gtk2;

sub TRUE  {1}
sub FALSE {0}


# Respond to a button-press by posting a menu passed in as widget.
#
# Note that the "widget" argument is the menu being posted, NOT
# the button that was pressed.

sub button_press
{
  my ($widget, $event) = @_;
  #print "EVENT: ", $event->type, " vs ", Gtk2::Gdk->BUTTON_PRESS, "\n";
  if ($event->type eq 'button-press')
    {
      $widget->popup(undef, undef, undef, undef, $event->button, $event->time);
      # Tell calling code that we have handled this event; the buck stops here.
      return TRUE;
    }
  # Tell calling code that we have not handled this event; pass it on.
  return FALSE;
}


# Print a string when a menu item is selected

sub menuitem_response
{
  my $string = shift;
  printf("%s\n", $string);
}

Gtk2->init(\@ARGV);
# create a new window
my $window = Gtk2::Window->new('toplevel');
$window->set_size_request(200, 100);
$window->set_title("GTK Menu Test");
$window->signal_connect("delete_event", sub { Gtk2->quit });
# Init the menu-widget, and remember -- never
# gtk_show_widget() the menu widget!! 
# This is the menu that holds the menu items, the one that
# will pop up when you click on the "Root Menu" in the app */
my $menu = Gtk2::Menu->new;
# Next we make a little loop that makes three menu-entries for "test-menu".
# Notice the call to gtk_menu_shell_append.  Here we are adding a list of
# menu items to our menu.  Normally, we'd also catch the "clicked"
# signal on each of the menu items and setup a callback for it,
# but it's omitted here to save space.
for (my $i = 0; $i < 3; $i++)
  {
    # Copy the names to the buf.
    my $buf = sprintf("Test-undermenu - %d", $i);
    # Create a new menu-item with a name...
    my $menu_items = Gtk2::MenuItem->new_with_label($buf);
    # ...and add it to the menu.
    $menu->append($menu_items);
    # Do something interesting when the menuitem is selected
    $menu_items->signal_connect_swapped("activate", \&menuitem_response, $buf);
    # Show the widget
    $menu_items->show;
  }
# This is the root menu, and will be the label
# displayed on the menu bar.  There won't be a signal handler attached,
# as it only pops up the rest of the menu when pressed.
my $root_menu = Gtk2::MenuItem->new_with_label ("Root Menu");
$root_menu->show;
# Now we specify that we want our newly created "menu" to be the menu
# for the "root menu"
$root_menu->set_submenu($menu);
# A vbox to put a menu and a button in: */
my $vbox = Gtk2::VBox->new(FALSE, 0);
$window->add($vbox);
$vbox->show;
# Create a menu-bar to hold the menus and add it to our main window
my $menu_bar = Gtk2::MenuBar->new;
$vbox->pack_start($menu_bar, FALSE, FALSE, 2);
$menu_bar->show;
# Create a button to which to attach menu as a popup
my $button = Gtk2::Button->new_with_label("press me");
$button->signal_connect_swapped("event", \&button_press, $menu);
$vbox->pack_end($button, TRUE, TRUE, 2);
$button->show;
# And finally we append the menu-item to the menu-bar -- this is the
# "root" menu-item I have been raving about =)
$menu_bar->append($root_menu);
# always display the window as the last step so it all splashes on the screen at once.
$window->show;
Gtk2->main;
0;


