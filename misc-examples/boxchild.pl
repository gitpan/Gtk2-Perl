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
# $Id: boxchild.pl,v 1.1 2002/11/28 13:55:28 ggc Exp $
#
#*****************************************************************************

use Gtk2;

Gtk2->init(\@ARGV);

$w = Gtk2::Window->new('toplevel');
$w->set_position('center');
$v = Gtk2::VBox->new(0, 10);

$l  = Gtk2::Label->new('Hello');

$b1 = Gtk2::Button->new('click me');
$b1->signal_connect(clicked => sub {
			my @children = $v->children;
			print "there are ", int(@children), " children in the vbox\n";
			printf "query child packing of first child: %s\n", join(', ', $v->query_child_packing($children[0]->widget));
			printf "first children BoxChild values: %s\n", join(', ', $children[0]->values);
			print "destroying the first of them\n";
			$children[0]->widget->destroy;
		    });
$b2 = Gtk2::Button->new('quit');
$b2->signal_connect(clicked => sub { Gtk2->main_quit });

$v->pack_start($l, 0, 0, 0);
$v->pack_start($b1, 0, 0, 5);
$v->pack_end  ($b2, 0, 0, 0);

$w->add($v);
$w->show_all;

Gtk2->main;
