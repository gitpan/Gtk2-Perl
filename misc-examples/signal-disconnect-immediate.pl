#!/usr/bin/perl
#*****************************************************************************
# 
#  Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
# 
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2, as
#  published by the Free Software Foundation.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
# 
#*****************************************************************************

use strict;

use Gtk2;


Gtk2->init(\@ARGV);

my $w = Gtk2::Window->new('toplevel');
$w->set_position('center');
my $p = Gtk2::VBox->new(0, 10);
$p->pack_start(Gtk2::Label->new("Hello refcounting world."), 0, 0, 5);
my $b = Gtk2::Button->new('ok');
$b->signal_connect(clicked => sub { Gtk2->main_quit });
$p->pack_end($b, 0, 0, 5);
$w->add($p);

$w->add_events('pointer-motion-mask');
my $signal;  #- don't make this line part of next one, signal_disconnect won't be able to access $signal value
$signal = $w->signal_connect(motion_notify_event => sub {
				 print "motion_notify_event is run, disconnecting the signal immediately..\n";
				 $w->signal_disconnect($signal);
			     });

$w->show_all();
Gtk2->main;

print "    if you restored the SvREFCNT_dec(pc->callback) in Gtk2/src/GClosure.c,\n";
print "    you will probably see now perl complaining that we're trying to free an unreferenced scalar :(.\n";
