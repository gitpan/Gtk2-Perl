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
    Gtk2::Gdk::Window->foreign_new(Gtk2::Gdk->ROOT_WINDOW);
}

sub gtkcolor {
    my ($r, $g, $b) = @_;
    my $color = Gtk2::Gdk::Color->new($r, $g, $b);
    gtkroot->get_colormap->rgb_find_color($color);
    $color;
}

sub gtkset_size_request { $_[0]->set_size_request($_[1],$_[2]); $_[0] }

sub gtksignal_connect {
    my $w = shift;
    $w->signal_connect(@_);
    $w;
}


Gtk2->init(\@ARGV);

my $w = Gtk2::Window->new('toplevel');
$w->set_position('center');
my $p = Gtk2::VBox->new(0, 10);
$p->pack_start(Gtk2::Label->new("This window has a shadow and the borders are transparent.\nRemove your WM decorations for best results."), 0, 0, 5);
my $b = Gtk2::Button->new('ok');
$b->signal_connect(clicked => sub { Gtk2->main_quit });
$p->pack_end($b, 0, 0, 5);


my $sqw = 10;

#- this makes the corner transparency
my $size_allocate;
$size_allocate = $w->signal_connect(size_allocate => sub {
					my (undef, undef, $wi, $he) = $_[1]->values;
					my $wia = int(($wi+7)/8);
					my $s = "\xFF" x ($wia*$he);
					my $wib = $wia*8;
					my $dif = $wib-$wi;
					foreach my $y (0..$sqw-1) { vec($s, $wib-1-$dif-$_+$wib*$y, 1) = 0x0 foreach (0..$sqw-1) }
					foreach my $y (0..$sqw-1) { vec($s, (($he-1)*$wib)-$wib*$y+$_, 1) = 0x0 foreach (0..$sqw-1) }
					$w->realize;
					my $b = Gtk2::Gdk::Bitmap->create_from_data($w->window, $s, $wib, $he);
					$w->window->shape_combine_mask($b, 0, 0);
					$w->signal_disconnect($size_allocate);
				    });

#- this draws the shadow
my $gc = Gtk2::Gdk::GC->new(gtkroot);
my $col = gtkcolor(5120, 10752, 22784);
$gc->set_rgb_fg_color($col);
$col->free;
$w->add(my $table = Gtk2::Table->new(2, 2, 0));
$table->attach($p, 0, 1, 0, 1, ['expand', 'fill'], ['expand', 'fill'], 0, 0);
$table->attach(gtksignal_connect(gtkset_size_request(Gtk2::DrawingArea->new, $sqw, 1), expose_event => sub {
				     $_[0]->window->draw_rectangle($_[0]->style->bg_gc('normal'), 1, 0, 0, $sqw, $sqw);
				     $_[0]->window->draw_rectangle($gc, 1, 0, $sqw, $sqw, $_[0]->allocation->height);
				 }),
	       1, 2, 0, 1, 'fill', 'fill', 0, 0);
$table->attach(gtksignal_connect(gtkset_size_request(Gtk2::DrawingArea->new, 1, $sqw), expose_event => sub {
				     $_[0]->window->draw_rectangle($_[0]->style->bg_gc('normal'), 1, 0, 0, $sqw, $sqw);
				     $_[0]->window->draw_rectangle($gc, 1, $sqw, 0, $_[0]->allocation->width, $sqw);
				 }),
	       0, 1, 1, 2, 'fill', 'fill', 0, 0);
$table->attach(gtksignal_connect(gtkset_size_request(Gtk2::DrawingArea->new, $sqw, $sqw), expose_event => sub {
				     $_[0]->window->draw_rectangle($gc, 1, 0, 0, $sqw, $sqw);
				 }),
	       1, 2, 1, 2, 'fill', 'fill', 0, 0);
$w->signal_connect(delete_event => sub { $gc->unref });


$w->show_all;
Gtk2->main;
