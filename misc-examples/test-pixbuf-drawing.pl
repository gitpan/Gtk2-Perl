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
# $Id: test-pixbuf-drawing.pl,v 1.13 2002/11/27 16:33:31 ggc Exp $
#*****************************************************************************

use strict;
use Gtk2;

defined($ARGV[0]) or die "Usage: $0 <image_file_name>\n";

Gtk2->init(\@ARGV);

my $w = Gtk2::Window->new('toplevel');
$w->set_position('center');
$w->set_border_width(10);

my $p = Gtk2::VBox->new(0, 10);
$p->pack_start(Gtk2::Label->new("I draw the images at normal size two times, one anchored to the left,\n".
				"the other to the right, and a scaled version to 80x80 on the bottom center.\n".
			        "I also draw two Pango Layouts, and a polygon and a cross (in DarkSlateGray)."), 0, 0, 5);

my $da = Gtk2::DrawingArea->new;
$da->set_size_request(200, 200);
$p->pack_start($da, 1, 1, 5);

my $b = Gtk2::Button->new('ok');
$b->signal_connect(clicked => sub { Gtk2->main_quit });
$p->pack_end($b, 0, 0, 5);

$w->add($p);
$w->show_all;

my $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file($ARGV[0]);
my $pixbuf_scaled = Gtk2::Gdk::Pixbuf::scale_simple($pixbuf, 80, 80, 'bilinear');

$da->modify_font(Gtk2::Pango::FontDescription->from_string('Sans Italic 24'));

sub expose_event_handler {
    my (undef, undef, $dx, $dy) = $_[1]->area->values;

    foreach ('0', $dx - $pixbuf->get_width) {
	$pixbuf->render_to_drawable($da->window, $da->style->white_gc,
				    0, 0, $_, 0, -1, -1, 'none', 0, 0);
    }

    $pixbuf_scaled->render_to_drawable($da->window, $da->style->white_gc, 0, 0,
				       ($dx - $pixbuf_scaled->get_width) / 2,
				       $dy - $pixbuf_scaled->get_height,
				       -1, -1, 'none', 0, 0);

    my $layout = $da->create_pango_layout("Pango Rendering Rulz!");
    $da->window->draw_layout($da->style->white_gc, 10, 10, $layout);
    $da->window->draw_layout($da->style->black_gc, 10, 40, $layout);
    $layout->unref;

    my $gc = Gtk2::Gdk::GC->new($da->window);
    $gc->set_rgb_fg_color(Gtk2::Gdk::Color->parse('DarkSlateGray'));

    my @polygon_coords = ([10, 2], [50, 5], [80, 20], [60, 60], [30, 20], [5, 20]);
    my @polygon = map { Gtk2::Gdk::Point->new($_->[0], $_->[1]) } @polygon_coords;
    $da->window->draw_polygon($gc, 1, @polygon);
    my @cross = (Gtk2::Gdk::Segment->new(50, 50, 100, 100), Gtk2::Gdk::Segment->new(100, 50, 50, 100));
    $da->window->draw_segments($gc, @cross);
    $_->free foreach @polygon, @cross;

    $gc->unref;
}


$da->signal_connect(expose_event => \&expose_event_handler);

Gtk2->main;
