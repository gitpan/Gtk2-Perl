#!/usr/bin/perl
#
# Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License
# version 2, as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# $Id: test-memoryleak.pl,v 1.2 2002/11/12 22:32:10 gthyni Exp $
#

use Gtk2;

Gtk2->init;

sub cat_ { local *F; open F, $_[0] or return; my @l = <F>; wantarray ? @l : join '', @l }
sub mem { my $m; /^Vm(RSS|Data):\s+(\d+) kB/ and $m += $2 foreach cat_('/proc/self/status'); $m }
sub test_memleak {
    my ($description, $closure) = @_;
    printf "---- mem: %6d kB -- $description\n", mem();
    $closure->() foreach (1..5000);
    printf "---- mem: %6d kB \n\n", mem();
}

my $t = Gtk2::TextView->new();
$t->get_buffer()->set_text("This is just a test", -1);
($s, $e) = $t->get_buffer()->get_bounds();

test_memleak('TextView get_text',
	     sub { my $text = $t->get_buffer()->get_text($t->get_buffer()->get_bounds(), 1) });
test_memleak('TextView get_text with static bounds',
	     sub { my $text = $t->get_buffer()->get_text($s, $e, 1) });

my $b = Gtk2::Button->new("my lab");
test_memleak('Button get_label',
	     sub { my $text = $b->get_label() });
test_memleak('Button new',
	     sub { my $but = new Gtk2::Button->new() });
