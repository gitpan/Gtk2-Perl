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

sub gtkroot {
    Gtk2::Gdk::Window->foreign_new(Gtk2::Gdk->ROOT_WINDOW());
}

sub gtkcolor {
    my ($r, $g, $b) = @_;
    my $color = Gtk2::Gdk::Color->new($r, $g, $b);
    gtkroot()->get_colormap()->rgb_find_color($color);
    $color;
}

sub gtkset_background {
    my ($r, $g, $b) = @_;
    my $root = gtkroot();
    my $gc = Gtk2::Gdk::GC->new($root);
    my $color = gtkcolor($r, $g, $b);
    $gc->set_rgb_fg_color($color);
    $root->set_background($color);
    $color->free();
    my ($w, $h) = $root->get_size();
    $root->draw_rectangle($gc, 1, 0, 0, $w, $h);
    $gc->unref();
}

Gtk2->init;
gtkset_background(255*256, 255*256, 0);
Gtk2->update_ui();
print "Background (root window) changed to yellow.\n";
sleep 1;

gtkset_background(0, 0, 0);
Gtk2->update_ui();
print "Background (root window) back to black.\n";
