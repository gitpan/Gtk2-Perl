#!/usr/bin/perl -w

# $Id: label.pl,v 1.4 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/ch-miscwidgets.html


use Gtk2;

sub TRUE  {1}
sub FALSE {0}


#  /* Initialise GTK */
Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
Gtk2::GSignal->connect($window, "destroy" => sub { Gtk2->quit });
$window->set_title("Label");
my $vbox = Gtk2::VBox->new(FALSE, 5);
my $hbox = Gtk2::HBox->new(FALSE, 5);
$window->add($hbox);
$hbox->pack_start($vbox, FALSE, FALSE, 0);
$window->set_border_width(5);
my $frame = Gtk2::Frame->new("Normal Label");
my $label = Gtk2::Label->new("This is a Normal label");
$frame->add($label);
$vbox->pack_start($frame, FALSE, FALSE, 0);
$frame = Gtk2::Frame->new("Multi-line Label");
$label = Gtk2::Label->new("This is a Multi-line label.\nSecond line\nThird line");
$frame->add($label);
$vbox->pack_start($frame, FALSE, FALSE, 0);
$frame = Gtk2::Frame->new("Left Justified Label");
$label = Gtk2::Label->new("This is a Left-Justified\nMulti-line label.\nThird      line");
$label->set_justify('left');
$frame->add($label);
$vbox->pack_start($frame, FALSE, FALSE, 0);
$frame = Gtk2::Frame->new("Right Justified Label");
$label = Gtk2::Label->new("This is a Right-Justified\nMulti-line label.\nFourth line, (j/k)");
$label->set_justify('right');
$frame->add($label);
$vbox->pack_start($frame, FALSE, FALSE, 0);
$vbox = Gtk2::VBox->new(FALSE, 5);
$hbox->pack_start($vbox, FALSE, FALSE, 0);
$frame = Gtk2::Frame->new("Line wrapped label");
$label = Gtk2::Label->new("This is an example of a line-wrapped label.  It " .
			  "should not be taking up the entire             " . # /* big space to test spacing */\
			  "width allocated to it, but automatically " .
			  "wraps the words to fit.  " .
			  "The time has come, for all good men, to come to " .
			  "the aid of their party.  " .
			  "The sixth sheik's six sheep's sick.\n" .
			  "     It supports multiple paragraphs correctly, " .
			  "and  correctly   adds " .
			  "many          extra  spaces. ");
$label->set_line_wrap(TRUE);
$frame->add($label);
$vbox->pack_start($frame, FALSE, FALSE, 0);
$frame = Gtk2::Frame->new("Filled, wrapped label");
$label = Gtk2::Label->new("This is an example of a line-wrapped, filled label.  " .
			  "It should be taking ".
			  "up the entire              width allocated to it.  " .
			  "Here is a sentence to prove ".
			  "my point.  Here is another sentence. ".
			  "Here comes the sun, do de do de do.\n".
			  "    This is a new paragraph.\n".
			  "    This is another newer, longer, better " .
			  "paragraph.  It is coming to an end, ".
			  "unfortunately.");
$label->set_justify('fill');
$label->set_line_wrap(TRUE);
$frame->add ($label);
$vbox->pack_start($frame, FALSE, FALSE, 0);
$frame = Gtk2::Frame->new("Underlined label");
$label = Gtk2::Label->new("This label is underlined!\n" . "This one is underlined in quite a funky fashion");
$label->set_justify('left');
$label->set_pattern("_________________________ _ _________ _ ______     __ _______ ___");
$frame->add($label);
$vbox->pack_start($frame, FALSE, FALSE, 0);
$window->show_all;
Gtk2->main;
0;

