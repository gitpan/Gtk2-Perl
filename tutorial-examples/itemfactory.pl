#!/usr/bin/perl

# $Id: itemfactory.pl,v 1.9 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-itemfactoryexample.html

use Gtk2;

sub TRUE  {1}
sub FALSE {0}

# Obligatory basic callback
sub print_hello
{
  print "Hello, World!\n";
}

# For the check button
sub print_toggle
  {
    my ($callback_data, $callback_action, $menu_item) = @_;
    printf "Check button state: %d\n", $menu_item->active;
  }

#/* For the radio buttons */
sub print_selected
  {
    my ($callback_data, $callback_action, $menu_item) = @_;
    printf("Radio button %d selected\n", $callback_action) if $menu_item->active;
  }

#/* Our menu, an array of GtkItemFactoryEntry structures that defines each menu item */
my $menu_items =
  [
   [ '/_File',         undef,        undef,              0, '<Branch>' ],
   [ '/File/_New',     '<control>N', \&print_hello,      0, '<Item>' ],
   [ '/File/_Open',    '<control>O', \&print_hello,      0, '<Item>' ],
   [ '/File/_Save',    '<control>S', \&print_hello,      0, '<Item>' ],
   [ '/File/Save _As', undef,        undef,              0, '<Item>' ],
   [ '/File/sep1',     undef,        undef,              0, '<Separator>' ],
   [ '/File/Quit',     '<control>Q', sub { Gtk2->quit }, 0, '<Item>' ],
   [ '/_Options',      undef,        undef,              0, '<Branch>' ],
   [ '/Options/tear',  undef,        undef,              0, '<Tearoff>' ],
   [ '/Options/Check', undef,        \&print_toggle,     1, '<CheckItem>' ],
   [ '/Options/sep',   undef,        undef,              0, '<Separator>' ],
   [ '/Options/Rad1',  undef,        \&print_selected,   1, '<RadioItem>' ],
   [ '/Options/Rad2',  undef,        \&print_selected,   2, '/Options/Rad1' ],
   [ '/Options/Rad3',  undef,        \&print_selected,   3, '/Options/Rad1' ],
   [ '/_Help',         undef,        undef,              0, '<LastBranch>' ],
   [ '/_Help/About',   undef,        undef,              0, '<Item>' ],
  ];


#/* Returns a menubar widget made from the above menu */
sub get_menubar_menu
{
  my $window = shift;
  #/* Make an accelerator group (shortcut keys) */
  my $accel_group = Gtk2::AccelGroup->new;
  #/* Make an ItemFactory (that makes a menubar) */
  my $item_factory = Gtk2::ItemFactory->new(Gtk2::MenuBar->get_type, '<main>', $accel_group);
  # This function generates the menu items. Pass the item factory,
  # the number of items in the array, the array itself, and any
  # callback data for the the menu items.
  $item_factory->create_items($menu_items);
  # Attach the new accelerator group to the window.
  $window->add_accel_group($accel_group);
  # Finally, return the actual menu bar created by the item factory.
  return $item_factory->get_widget('<main>');
}

# Popup the menu when the popup button is pressed
sub popup_cb
{
  my ($widget, $event, $menu) = @_;
  # Only take button presses
  return FALSE if $event->type ne 'button-press';
  # Show the menu
  $menu->popup(undef, undef, undef, undef, $event->button, $event->time);
  return TRUE;
}

# Same as with get_menubar_menu() but just return a button with a signal to
# call a popup menu
sub get_popup_menu
{
   # Same as before but don't bother with the accelerators */
   my $item_factory = Gtk2::ItemFactory->new(Gtk2::Menu->get_type, '<main>');
   $item_factory->create_items($menu_items);
   my $menu = $item_factory->get_widget('<main>');
   #/* Make a button to activate the popup menu */
   $button = Gtk2::Button->new('Popup');
   # Make the menu popup when clicked 
   $button->signal_connect('event', \&popup_cb, $menu);
   return $button;
}

#/* Same again but return an option menu */
sub get_option_menu
{
  #/* Same again, not bothering with the accelerators */
  my $item_factory = Gtk2::ItemFactory->new(Gtk2::OptionMenu->get_type, '<main>');
  $item_factory->create_items($menu_items);
  return $item_factory->get_widget('<main>');
}

#/* You have to start somewhere */
Gtk2->init(\@ARGV);
#/* Make a window */
my $window = Gtk2::Window->new('toplevel');
$window->signal_connect('destroy', sub { Gtk2->quit });
$window->set_title('Item Factory');
$window->set_size_request(300, 200);
#/* Make a vbox to put the three menus in */
my $main_vbox = Gtk2::VBox->new(FALSE, 1);
$main_vbox->set_border_width(1);
$window->add($main_vbox);
#/* Get the three types of menu */
#/* Note: all three menus are separately created, so they are not the same menu */
my $menubar = get_menubar_menu($window);
my $popup_button = get_popup_menu();
my $option_menu = get_option_menu();
#/* Pack it all together */
$main_vbox->pack_start($menubar, FALSE, TRUE, 0);
$main_vbox->pack_end($popup_button, FALSE, TRUE, 0);
$main_vbox->pack_end($option_menu, FALSE, TRUE, 0);
#/* Show the widgets */
$window->show_all;
#/* Finished! */
Gtk2->main;
0;


