#!/usr/bin/perl -w

# $Id: pack1.pl,v 1.4 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt


use Gtk2;


sub FALSE { 0 }
sub TRUE { 1 }

sub delete_event
{
  Gtk2->quit;
  return FALSE;
}

sub quit
  {
    Gtk2->quit;
  }

#/* Make a new hbox filled with button-labels. Arguments for the 
# * variables we're interested are passed in to this function. 
# * We do not show the box, but do show everything inside. */

#GtkWidget *
sub make_box
  {
    my ($homogeneous, $spacing, $expand, $fill, $padding) = @_;
    #    /* Create a new hbox with the appropriate homogeneous
    #     * and spacing settings */
    my $box = Gtk2::HBox->new($homogeneous, $spacing);
    # Create a series of buttons with the appropriate settings */
    my $button = Gtk2::Button->new_with_label("gtk_box_pack");
    $box->pack_start($button, $expand, $fill, $padding);
    $button->show;
    $button = Gtk2::Button->new_with_label("(box,");
    $box->pack_start($button, $expand, $fill, $padding);
    $button->show;
    $button = Gtk2::Button->new_with_label("button,");
    $box->pack_start($button, $expand, $fill, $padding);
    $button->show;
    # /* Create a button with the label depending on the value of
    #  * expand. */
    $button = Gtk2::Button->new_with_label($expand ? "TRUE," : "FALSE,");
    $box->pack_start($button, $expand, $fill, $padding);
    $button->show;
    #/* This is the same as the button creation for "expand"
    #* above, but uses the shorthand form. */
    $button = Gtk2::Button->new_with_label($fill ? "TRUE," : "FALSE,");
    $box->pack_start($button, $expand, $fill, $padding);
    $button->show;
    $padstr = sprintf "%d);", $padding;
    $button = Gtk2::Button->new_with_label($padstr);
    $box->pack_start($button, $expand, $fill, $padding);
    $button->show;
    return $box;
}


#    /* Our init, don't forget this! :) */
Gtk2->init(\@ARGV);
if (@ARGV != 1) {
  print STDERR  "usage: packbox num, where num is 1, 2, or 3. (", scalar @ARGV, ")\n";
  #/* This just does cleanup in GTK and exits with an exit status of 1. */
  exit 1;
}
my $which = shift @ARGV;
#/* Create our window */
my $window = Gtk2::Window->new('toplevel');
#/* You should always remember to connect the delete_event signal
#     * to the main window. This is very important for proper intuitive
#     * behavior */
Gtk2::GSignal->connect($window, "delete_event", \&delete_event, 0);
$window->set_border_width(10);
#    /* We create a vertical box (vbox) to pack the horizontal boxes into.
#     * This allows us to stack the horizontal boxes filled with buttons one
#     * on top of the other in this vbox. */
my $box1 = Gtk2::VBox->new(FALSE, 0);
my ($box2, $label, $separator);
#    /* which example to show. These correspond to the pictures above. */
if ($which == 1)
  {
    #/* create a new label. */
    $label = Gtk2::Label->new("gtk_hbox_new (FALSE, 0);");
    #/* Align the label to the left side.  We'll discuss this function and 
    # * others in the section on Widget Attributes. */
    $label->set_alignment(0,0); # gtk_misc_set_alignment (GTK_MISC (label), 0, 0);
    #/* Pack the label into the vertical box (vbox box1).  Remember that 
    # * widgets added to a vbox will be packed one on top of the other in
    # * order. */
    $box1->pack_start($label, FALSE, FALSE, 0);
    # /* Show the label */
    $label->show;
    # /* Call our make box function - homogeneous = FALSE, spacing = 0,
    #  * expand = FALSE, fill = FALSE, padding = 0 */
    $box2 = make_box(FALSE, 0, FALSE, FALSE, 0);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    #/* Call our make box function - homogeneous = FALSE, spacing = 0,
    # * expand = TRUE, fill = FALSE, padding = 0 */
    $box2 = make_box(FALSE, 0, TRUE, FALSE, 0);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    #/* Args are: homogeneous, spacing, expand, fill, padding */
    $box2 = make_box(FALSE, 0, TRUE, TRUE, 0);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    #/* Creates a separator, we'll learn more about these later, 
    # * but they are quite simple. */
    $separator = Gtk2::HSeparator->new;
    # /* Pack the separator into the vbox. Remember each of these
    # * widgets is being packed into a vbox, so they'll be stacked
    # * vertically. */
    $box1->pack_start($separator, FALSE, TRUE, 5);
    $separator->show;
    # /* Create another new label, and show it. */
    $label = Gtk2::Label->new("gtk_hbox_new (TRUE, 0);");
    $label->set_alignment(0, 0);
    $box1->pack_start($label, FALSE, FALSE, 0);
    $label->show;
    #/* Args are: homogeneous, spacing, expand, fill, padding */
    $box2 = make_box(TRUE, 0, TRUE, FALSE, 0);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    #/* Args are: homogeneous, spacing, expand, fill, padding */
    $box2 = make_box(TRUE, 0, TRUE, TRUE, 0);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    #/* Another new separator. */
    $separator = Gtk2::HSeparator->new;
    #/* The last 3 arguments to gtk_box_pack_start are:
    # * expand, fill, padding. */
    $box1->pack_start($separator, FALSE, TRUE, 5);
    $separator->show;
  }
elsif ($which == 2)
  {
    #/* Create a new label, remember box1 is a vbox as created 
    # * near the beginning of main() */
    $label = Gtk2::Label->new("gtk_hbox_new (FALSE, 10);");
    $label->set_alignment(0, 0);
    $box1->pack_start($label, FALSE, FALSE, 0);
    $label->show;
    #/* Args are: homogeneous, spacing, expand, fill, padding */
    $box2 = make_box (FALSE, 10, TRUE, FALSE, 0);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    #/* Args are: homogeneous, spacing, expand, fill, padding */
    $box2 = make_box(FALSE, 10, TRUE, TRUE, 0);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    $separator = Gtk2::HSeparator->new;
    #/* The last 3 arguments to gtk_box_pack_start are:
    # * expand, fill, padding. */
    $box1->pack_start($separator, FALSE, TRUE, 5);
    $separator->show;
    $label = Gtk2::Label->new("gtk_hbox_new (FALSE, 0);");
    $label->set_alignment(0, 0);
    $box1->pack_start($label, FALSE, FALSE, 0);
    $label->show;
    #/* Args are: homogeneous, spacing, expand, fill, padding */
    $box2 = make_box(FALSE, 0, TRUE, FALSE, 10);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    #/* Args are: homogeneous, spacing, expand, fill, padding */
    $box2 = make_box(FALSE, 0, TRUE, TRUE, 10);
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    $separator = Gtk2::HSeparator->new;
    #/* The last 3 arguments to gtk_box_pack_start are: expand, fill, padding. */
    $box1->pack_start($separator, FALSE, TRUE, 5);
    $separator->show;
  }
elsif ($which == 3)
  {
    #/* This demonstrates the ability to use gtk_box_pack_end() to
    # * right justify widgets. First, we create a new box as before. */
    $box2 = make_box(FALSE, 0, FALSE, FALSE, 0);
    #/* Create the label that will be put at the end. */
    $label = Gtk2::Label->new("end");
    #/* Pack it using gtk_box_pack_end(), so it is put on the right
    # * side of the hbox created in the make_box() call. */
    $box2->pack_end($label, FALSE, FALSE, 0);
    # /* Show the label. */
    $label->show;
    #/* Pack box2 into box1 (the vbox remember ? :) */
    $box1->pack_start($box2, FALSE, FALSE, 0);
    $box2->show;
    #/* A separator for the bottom. */
    $separator = Gtk2::HSeparator->new;
    #/* This explicitly sets the separator to 400 pixels wide by 5 pixels
    # * high. This is so the hbox we created will also be 400 pixels wide,
    # * and the "end" label will be separated from the other labels in the
    # * hbox. Otherwise, all the widgets in the hbox would be packed as
    # * close together as possible. */
    $separator->set_size_request(400,5); # gtk_widget_set_size_request (separator, 400, 5);
    #/* pack the separator into the vbox (box1) created near the start of main() */
    $box1->pack_start($separator, FALSE, TRUE, 5);
    $separator->show;
  }
#/* Create another new hbox.. remember we can use as many as we need! */
my $quitbox = Gtk2::HBox->new(FALSE, 0);
#/* Our quit button. */
my $button = Gtk2::Button->new_with_label("Quit");
#/* Setup the signal to terminate the program when the button is clicked */
Gtk2::GSignal->connect_swapped ($button, "clicked", \&quit, $window);
#/* Pack the button into the quitbox.
# * The last 3 arguments to gtk_box_pack_start are:
# * expand, fill, padding. */
$quitbox->pack_start($button, TRUE, FALSE, 0);
#/* pack the quitbox into the vbox (box1) */
$box1->pack_start($quitbox, FALSE, FALSE, 0);
#/* Pack the vbox (box1) which now contains all our widgets, into the
# * main window. */
$window->add($box1);
#/* And show everything left */
$button->show;
$quitbox->show;
$box1->show;
#/* Showing the window last so everything pops up at once. */
$window->show;
#/* And of course, our main function. */
Gtk2->main;
#/* Control returns here when gtk_main_quit() is called, but not when 
# * exit() is used. */
0;


