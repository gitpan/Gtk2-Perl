#!/usr/bin/perl -w

#use Unicode::String qw(latin1 utf8);
use Gtk2;

Gtk2->init(\@ARGV);
my $str = shift; #latin1(shift)->utf8;
my $window = Gtk2::Window->new('toplevel');
my $button = Gtk2::Button->new($str);
$button->signal_connect('clicked', \&handler, undef);
$window->add($button);
$window->show_all;
Gtk2->main;

sub handler { Gtk2->quit; }

