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
# $Id: plug-socket.pl,v 1.1 2002/12/02 21:45:33 ggc Exp $
#
#*****************************************************************************

use Gtk2;

Gtk2->init(\@ARGV);

my $w = Gtk2::Window->new('toplevel');
my $v = Gtk2::VBox->new(0, 0);
$v->pack_start(Gtk2::Label->new("Socket/Plug example program"), 0, 0, 5);
$v->pack_start(my $f = Gtk2::Frame->new("External prog"), 1, 1, 5);
$f->add(my $socket = Gtk2::Socket->new);
$w->add($v);
$w->set_position('center');

$w->set_size_request(300, 300);
$w->show_all;
$w->realize;

$socket->signal_connect(plug_added => sub { print "<<plug added>>\n" });

unless (my $pid = fork) {
    print("cannot fork: %s", $~) unless defined $pid;
    print "id " . $socket->get_id . "\n";
    exec("perl $ARGV[0] -e '".q{
use Gtk2;
Gtk2->init(\@ARGV);
my $w = Gtk2::Plug->new(} . $socket->get_id . q{);
$w->add(Gtk2::Label->new("Plug example program\nI come to serve you"));
$w->show_all;
Gtk2->main;
}."'");

    print "FAILED TO EXEC\n";
    exit 0;
}


Gtk2->main;

