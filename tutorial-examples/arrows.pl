#!/usr/bin/perl -w

use Gtk2;

sub TRUE  {1}
sub FALSE {0}


# $Id: arrows.pl,v 1.6 2002/12/01 22:57:06 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-arrows.html

#/* Create an Arrow widget with the specified parameters
# * and pack it into a button */
sub create_arrow_button
{
  my ($arrow_type, $shadow_type) = @_;
  my $button = Gtk2::Button->new;
  $button->add(Gtk2::Arrow->new($arrow_type, $shadow_type)->show);
  return $button->show;
}

# /* Initialize the toolkit */
Gtk2->init(\@ARGV);
#  /* Create a new window */
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Arrow Buttons");
#  /* It's a good idea to do this for all windows. */
Gtk2::GSignal->connect($window, "destroy", sub { Gtk2->quit; });
#  /* Sets the border width of the window. */
$window->set_border_width(10);
#  /* Create a box to hold the arrows/buttons */
my $box = Gtk2::HBox->new(FALSE, 0);
$box->set_border_width(2);
$window->add($box);
#  /* Pack and show all our widgets */
$box->show;
my $button = create_arrow_button('up', 'in');
$box->pack_start($button, FALSE, FALSE, 3);
$button = create_arrow_button('down', 'out');
$box->pack_start($button, FALSE, FALSE, 3);
$button = create_arrow_button('left', 'etched-in');
$box->pack_start($button, FALSE, FALSE, 3);
$button = create_arrow_button ('right', 'etched-out');
$box->pack_start($button, FALSE, FALSE, 3);
$window->show;
#  /* Rest in gtk_main and wait for the fun to begin! */
Gtk2->main;
0;

