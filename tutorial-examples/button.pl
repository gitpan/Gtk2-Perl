#!/usr/bin/perl -w

# $Id: button.pl,v 1.3 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/ch-buttonwidget.html

use Gtk2;

sub FALSE { 0 }
sub TRUE  { 1 }

#/* Create a new hbox with an image and a label packed into it and return the box. */

sub xpm_label_box
{
  my ($xpm_filename, $label_text) = @_;
  #/* Create box for image and label */
  my $box = Gtk2::HBox->new(FALSE, 0);
  $box->set_border_width(2);
  #/* Now on to the image stuff */
  my $image = Gtk2::Image->new_from_file($xpm_filename);
  #/* Create a label for the button */
  my $label = Gtk2::Label->new($label_text);
  #/* Pack the image and label into the box */
  $box->pack_start($image, FALSE, FALSE, 3);
  $box->pack_start($label, FALSE, FALSE, 3);
  $image->show;
  $label->show;
  return $box;
}

#/* Our usual callback function */
sub callback
{
  my ($widget,$data) = @_;
  printf "Hello again - %s was pressed\n", $data;
}

# GtkWidget is the storage type for widgets 
Gtk2->init(\@ARGV);
#    /* Create a new window */
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Pixmap'd Buttons!");
#    /* It's a good idea to do this for all windows. */
Gtk2::GSignal->connect($window, "destroy", sub { Gtk2->quit; }, 0);
Gtk2::GSignal->connect($window, "delete_event", sub { Gtk2->quit; }, 0);
#    /* Sets the border width of the window. */
$window->set_border_width(10);
#    /* Create a new button */
my $button = Gtk2::Button->new;
#    /* Connect the "clicked" signal of the button to our callback */
Gtk2::GSignal->connect($button, "clicked", \&callback, "cool button");
#    /* This calls our box creating function */
my $box = xpm_label_box ("info.xpm", "cool button");
#    /* Pack and show all our widgets */
$box->show;
$button->add($box);
$button->show;
$window->add($button);
$window->show;
#    /* Rest in gtk_main and wait for the fun to begin! */
Gtk2->main;
0;


