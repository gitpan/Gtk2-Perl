#!/usr/bin/perl -w

# $Id: tooltips.pl,v 1.4 2002/11/12 20:30:02 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# adapted from
# http://www.gtk.org/tutorial/sec-thetooltipsobject.html

use Gtk2;

my $on = 1;
my $ontxt = "Click to disable Tooltips";
my $offtxt = "Click to enable Tooltips";

sub clicked
  {
    my ($button, $tooltips) = @_;
    if ($on)
      {
	$tooltips->disable;
	$button->set_label($offtxt);
	$on = 0;
      }
    else
      {
	$tooltips->enable;
	$button->set_label($ontxt);
	$on = 1;
      }
  }

Gtk2->init(\@ARGV);
my $win = Gtk2::Window->new('toplevel');
my $tooltips = Gtk2::Tooltips->new;
my $button = Gtk2::Button->new_with_label("Click to disable Tooltips");
$tooltips->set_tip($button, "This is a button", undef);
$win->add($button);
$win->show_all;
Gtk2::GSignal->connect($button, "clicked", \&clicked, $tooltips);
Gtk2::GSignal->connect($win,"delete_event", sub { Gtk2->quit }, undef);
Gtk2->main;
0;
