#!/usr/bin/perl -w

# $Id: pack2.pl,v 1.4 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt


use Gtk2;

sub FALSE { 0 }
sub TRUE { 1 }

#/* Our callback.
# * The data passed to this function is printed to stdout */
sub callback
{
  my ($widget,$data)=@_;
  printf "Hello again - %s was pressed\n", $data;
}

#/* This callback quits the program */
sub delete_event
{
  Gtk2->quit;
  FALSE;
}

Gtk2->init(\@ARGV);
#    /* Create a new window */
my $window = Gtk2::Window->new('toplevel');
#/* Set the window title */
$window->set_title("Table");
#    /* Set a handler for delete_event that immediately exits GTK. */
Gtk2::GSignal->connect($window, "delete_event", \&delete_event, 0);
#    /* Sets the border width of the window. */
$window->set_border_width(20);
#    /* Create a 2x2 table */
my $table = Gtk2::Table->new(2,2,TRUE);
#    /* Put the table in the main window */
$window->add($table);
#    /* Create first button */
my $button = Gtk2::Button->new_with_label ("button 1");
#    /* When the button is clicked, we call the "callback" function
#     * with a pointer to "button 1" as its argument */
Gtk2::GSignal->connect($button, "clicked", \&callback, "button 1");
#    /* Insert button 1 into the upper left quadrant of the table */
$table->attach_defaults($button, 0, 1, 0, 1);
$button->show;
#    /* Create second button */
$button = Gtk2::Button->new_with_label ("button 2");
#    /* When the button is clicked, we call the "callback" function
#     * with a pointer to "button 2" as its argument */
Gtk2::GSignal->connect($button, "clicked", \&callback, "button 2");
#    /* Insert button 2 into the upper right quadrant of the table */
$table->attach_defaults($button, 1, 2, 0, 1);
$button->show;
#    /* Create "Quit" button */
$button = Gtk2::Button->new_with_label ("Quit");
#    /* When the button is clicked, we call the "delete_event" function
#     * and the program exits */
Gtk2::GSignal->connect($button, "clicked", \&delete_event, 0);
#    /* Insert the quit button into the both 
#     * lower quadrants of the table */
$table->attach_defaults($button, 0, 2, 1, 2);
$button->show;
$table->show;
$window->show;
Gtk2->main;
0;

