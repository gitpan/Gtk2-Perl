#!/usr/bin/perl -w

use Gtk2;

my $count = 0;
my $idle_id;

sub idlefunc
{
  $count++;
  printf "$count: Heipä hei %s\n", shift;
  if ($count > 9)
    {
      Gtk2->idle_remove($idle_id);
      return 0;
    }
  1;
}

Gtk2->init(\@ARGV);
$idle_id = Gtk2->idle_add(\&idlefunc, "Olle");
Gtk2->main;
#void gtk_idle_remove( gint tag );
