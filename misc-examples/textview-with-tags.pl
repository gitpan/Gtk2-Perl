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
# $Id: textview-with-tags.pl,v 1.7 2002/12/02 14:08:59 ggc Exp $
#

use strict;
use diagnostics;

sub gtkroot {
    Gtk2::Gdk::Window->foreign_new(Gtk2::Gdk->ROOT_WINDOW);
}
sub gtkcolor {
    my ($r, $g, $b) = @_;
    my $color = Gtk2::Gdk::Color->new($r, $g, $b);
    gtkroot->get_colormap->rgb_find_color($color);
    $color;
}


use Gtk2;
Gtk2->init;

my $w = Gtk2::Window->new('toplevel');
$w->set_position('center');
my $t = Gtk2::TextView->new();
my $b = Gtk2::Button->new('ok');
$b->signal_connect(clicked => sub { Gtk2->main_quit });
my $p = Gtk2::VBox->new(0, 10);
$p->pack_start($t, 1, 1, 0);
$p->pack_end($b, 0, 0, 0);
$w->add($p);
$w->show_all();

# partly based on C code example from http://developer.gnome.org/doc/API/2.0/gtk/textwidget.html
my $fontdesc = Gtk2::Pango::FontDescription->from_string('Serif 12');
$t->modify_font($fontdesc);

$t->modify_text('normal', Gtk2::Gdk::Color->parse('purple'));
$t->modify_base('normal', Gtk2::Gdk::Color->parse('yellow'));
$t->get_buffer()->set_text("Beginning of text changing default font (Serif 15) and\ncolor purple on yellow.\n", -1);

my $buf = $t->get_buffer();
my $startoff = $buf->get_char_count();
my $istart = $buf->get_iter_at_offset($startoff);
$buf->insert($istart, "More text, I'll use tags to use Sans 12 with a gdkcolor on green and a double underline.\n", -1);
$istart->free();

$istart = $buf->get_iter_at_offset($startoff);
my $endoff = $buf->get_char_count();
my $iend = $buf->get_iter_at_offset($endoff);

my $tag = $buf->create_tag('my');
foreach my $property ($tag->list_properties()) {
    if ($property->{name} eq 'strikethrough') {
	print "(the 'strikethrough' property has type '$property->{type}' and is '$property->{desc}')\n";
    }
}
print "TextTag property font is:          ", $tag->get_property('font'), "\n";
print "TextTag property weight is:        ", $tag->get_property('weight'), "\n";
print "TextTag property direction is:     ", $tag->get_property('direction'), "\n";
print "TextTag property underline is:     ", $tag->get_property('underline'), "\n";
print "TextTag property scale is:         ", $tag->get_property('scale'), "\n";
print "TextTag property strikethrough is: ", $tag->get_property('strikethrough'), "\n";
$tag->set_property('underline', 'double');
$tag->set_property('foreground-gdk', gtkcolor(5120, 10752, 22784));
$tag->set_property('background', 'green');
$tag->set_property('font', 'Sans 12');

$buf->apply_tag($tag, $istart, $iend);

$istart->free();
$iend->free();

my $tag2 = $buf->create_tag('bold');
$tag2->set_property('weight', Gtk2::Pango->WEIGHT_BOLD);
$tag2->set_property('editable', 0);
$buf->apply_tag($tag2, $istart = $buf->get_iter_at_offset(30), $iend = $buf->get_iter_at_offset(45));
$istart->free();
$iend->free();

$buf->insert($buf->get_end_iter(), "I've also put stuff in bold in the first line (and uneditable)\n", -1);

Gtk2->main();
