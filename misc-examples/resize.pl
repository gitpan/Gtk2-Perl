#!/usr/bin/perl 

use warnings;
use Gtk2;

sub set_label {
  my ($button, $win) = @_;
  my $label = $win->resizable ? "Set Fixed" : "Set Resizable";
  $button->set_label($label);
}
    
sub click {
  my ($button,$win) = @_;
  my $old = $win->resizable;
  #print STDERR "old is $old\n";
  if ($old) { $win->resizable(0); }
  else { $win->resizable(1); }
  set_label($button,$win);
}

my $win = Gtk2->main_window;
my $button = Gtk2::Button->new;
$win->add($button);
$button->signal_connect('clicked' => \&click, $win);
set_label($button,$win);
click($button,$win);
$win->show_all;
Gtk2->main;
0;


