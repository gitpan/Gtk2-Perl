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
# $Id: rc.pl,v 1.1 2002/11/27 19:46:41 ggc Exp $
#
#*****************************************************************************

use Gtk2;

Gtk2->init(\@ARGV);

sub pr { printf "RC default files: %s.\n\n", join(', ',  Gtk2::Rc->get_default_files) }

pr();

my $path = '/export/additional-theme.rc';
print "Adding `$path'.\n";
Gtk2::Rc->add_default_file($path);
pr();

my @path = qw(/tmp/a.rc /tmp/b.rc);
print "Setting to @path.\n";
Gtk2::Rc->set_default_files(@path);
pr();

my $style = q(
style "mdk"
{
bg[NORMAL] = { 0.3, 0.38, 0.67 }
bg[PRELIGHT] = { 0.45, 0.51, 0.74 }
}
style "savane"
{
bg[NORMAL] = { 1.0, 0.67, 0 }
bg[PRELIGHT] = { 1.0, 0.8, 0.2 }
}
widget "*mdk*" style "mdk"
widget "*Button*" style "savane");

Gtk2::Rc->parse_string($style);


$w = Gtk2::Window->new('toplevel');
$w->set_position('center');
$v = Gtk2::VBox->new(0, 10);

$l  = Gtk2::Label->new('Hello');

$b1 = Gtk2::Button->new('mdk');
$b1->set_name('mdk');

$b2 = Gtk2::Button->new('quit');
$b2->signal_connect(clicked => sub { Gtk2->main_quit });

$v->pack_start($l, 0, 0, 0);
$v->pack_start($b1, 0, 0, 0);
$v->pack_end  ($b2, 0, 0, 0);

$w->add($v);
$w->show_all;

Gtk2->main;


















