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
# $Id: typecheck.pl,v 1.3 2002/11/12 22:32:10 gthyni Exp $
#

# this file will test that the type checking is done ok

use Gtk2;

Gtk2->init;

$w1 = new Gtk2::Window('toplevel');
$s = new Gtk2::Style();
$w1->set_style($s);
$w2 = new Gtk2::Window('popup');
eval { $w1->set_style($w2) };
$@ =~ /^FATAL: variable \S+ is not of type Gtk2::Style/ or die "FAILURE: Previous call should throw an exception ($@)\n";

print "All Ok.\n";
