#!/usr/bin/perl -w

# $Id: buttonbox.pl,v 1.3 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-buttonboxes.html

use Gtk2;

sub TRUE  {1}
sub FALSE {0}

# Create a Button Box with the specified parameters
sub create_bbox
{
  my ($horizontal, $title, $spacing, $child_w, $child_h, $layout) = @_;
  my $frame = Gtk2::Frame->new($title);
  my $bbox = $horizontal ? Gtk2::HButtonBox->new : Gtk2::VButtonBox->new;
  $bbox->set_border_width(5);
  $frame->add($bbox);
  # Set the appearance of the Button Box
  $bbox->set_layout($layout);
  $bbox->set_spacing($spacing);
  # gtk_button_box_set_child_size (GTK_BUTTON_BOX (bbox), child_w, child_h);
  my $button = Gtk2::Button->new_from_stock(Gtk2::Stock->OK);
  $bbox->add($button);
  $button = Gtk2::Button->new_from_stock(Gtk2::Stock->CANCEL);
  $bbox->add($button);
  $button = Gtk2::Button->new_from_stock(Gtk2::Stock->HELP);
  $bbox->add($button);
  return $frame;
}


Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_title("Button Boxes");
$window->signal_connect("destroy", sub { Gtk2->quit });
$window->set_border_width(10);
my $main_vbox = Gtk2::VBox->new(FALSE, 0);
$window->add($main_vbox);
my $frame_horz = Gtk2::Frame->new("Horizontal Button Boxes");
$main_vbox->pack_start($frame_horz, TRUE, TRUE, 10);
my $vbox = Gtk2::VBox->new(FALSE, 0);
$vbox->set_border_width(10);
$frame_horz->add($vbox);
$vbox->pack_start(create_bbox(TRUE, "Spread (spacing 40)", 40, 85, 20, 'spread'), TRUE, TRUE, 0);
$vbox->pack_start(create_bbox (TRUE, "Edge (spacing 30)", 30, 85, 20, 'edge'), TRUE, TRUE, 5);
$vbox->pack_start(create_bbox (TRUE, "Start (spacing 20)", 20, 85, 20, 'start'), TRUE, TRUE, 5);
$vbox->pack_start(create_bbox (TRUE, "End (spacing 10)", 10, 85, 20, 'end'), TRUE, TRUE, 5);
my $frame_vert = Gtk2::Frame->new("Vertical Button Boxes");
$main_vbox->pack_start($frame_vert, TRUE, TRUE, 10);
my $hbox = Gtk2::HBox->new(FALSE, 0);
$hbox->set_border_width(10);
$frame_vert->add($hbox);
$hbox->pack_start(create_bbox (FALSE, "Spread (spacing 5)", 5, 85, 20, 'spread'), TRUE, TRUE, 0);
$hbox->pack_start(create_bbox (FALSE, "Edge (spacing 30)", 30, 85, 20, 'edge'), TRUE, TRUE, 5);
$hbox->pack_start(create_bbox (FALSE, "Start (spacing 20)", 20, 85, 20, 'start'), TRUE, TRUE, 5);
$hbox->pack_start(create_bbox (FALSE, "End (spacing 20)", 20, 85, 20, 'end'), TRUE, TRUE, 5);
$window->show_all;
# Enter the event loop */
Gtk2->main;
0;


