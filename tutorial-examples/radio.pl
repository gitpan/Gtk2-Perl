#!/usr/bin/perl -w

# $Id: radio.pl,v 1.5 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt
# adapted from
# http://www.gtk.org/tutorial/sec-radiobuttons.html

use Gtk2;

sub FALSE { 0 }
sub TRUE  { 1 }


sub close_application
  {
    Gtk2->quit;
    FALSE;
  }


Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
Gtk2::GSignal->connect($window, "delete_event", \&close_application, 0);
$window->set_title("radio buttons");
$window->set_border_width(0);
my $box1 = Gtk2::VBox->new(FALSE, 0);
$window->add($box1);
$box1->show;
my $box2 = Gtk2::VBox->new(FALSE, 10);
$box2->set_border_width(10);
$box1->pack_start($box2, TRUE, TRUE, 0);
$box2->show;
my $button = Gtk2::RadioButton->new_with_label(undef, "button1");
$box2->pack_start($button, TRUE, TRUE, 0);
$button->show;
my $group = $button->get_group;
$button = Gtk2::RadioButton->new_with_label($group, "button2");
$button->set_active (TRUE);
$box2->pack_start($button, TRUE, TRUE, 0);
$button->show;
$button = Gtk2::RadioButton->new_with_label_from_widget($button,"button3");
$box2->pack_start($button, TRUE, TRUE, 0);
$button->show;
my $separator = Gtk2::HSeparator->new;
$box1->pack_start($separator, FALSE, TRUE, 0);
$separator->show;
$box2 = Gtk2::VBox->new(FALSE, 10);
$box2->set_border_width(10);
$box1->pack_start($box2, FALSE, TRUE, 0);
$box2->show;
$button = Gtk2::Button->new_with_label ("close");
Gtk2::GSignal->connect_swapped($button, "clicked", \&close_application, $window);
$box2->pack_start($button, TRUE, TRUE, 0);
$button->SET_FLAGS('can-default');
$button->grab_default;
$button->new;
$window->show;
Gtk2->main;
0;

