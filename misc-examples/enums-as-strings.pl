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
# $Id: enums-as-strings.pl,v 1.5 2002/11/12 22:32:10 gthyni Exp $
#

# this file will test the ability to use strings for enums

use Gtk2;

Gtk2->init;

print "Testing creation of a Gtk::Window with 'toplevel' as an arg.\n";
$w = new Gtk2::Window('toplevel');
$w->isa('Gtk2::Window') or die "FAILURE: Previous call should have created a Gtk::Window\n";

print "Testing creation of a Gtk::Window with 'topleel' as an arg (expecting failure).\n";
eval { $w = new Gtk2::Window('topleel') };
$@ =~ /^FATAL: invalid enum GtkWindowType value topleel/ or die "FAILURE: Previous call should throw an exception ($@)\n";

print "\nAll Ok.\n";
