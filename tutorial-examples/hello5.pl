#!/usr/bin/perl

# $Id: hello5.pl,v 1.6 2002/11/26 16:38:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

use Gtk2;

Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
my $button = Gtk2::Button->new();
my $label = Gtk2::Label->new("Hello world!");
$button->add($label);
$window->add($button);
$window->set_title("Hello");
$button->set_border_width(10);
#print "Add delete_event to $window\n";
Gtk2::GSignal->connect($window,"delete_event", \&delete_event_cb, undef);
#print "Add clicked to $button with $label\n";
Gtk2::GSignal->connect($button,"clicked", \&button_click_cb, $label);
$window->show_all();
#print "Main in ", __PACKAGE__, "\n" ;
Gtk2->main();
exit 0;

sub delete_event_cb
  {
    Gtk2->quit();
    return 0;
  }

sub button_click_cb
  {
    my ($widget, $mylabel) = @_;
#    print "xlabel: $mylabel in ", __PACKAGE__, "\n";
    my $text = $mylabel->get_text;
#    print "$mylabel is $text\n";
    my $tmp = reverse $text;
    $mylabel->set_text($tmp);
#    print "$mylabel became $tmp\n";
  }

