#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::Widget that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/014_Gtk2_Widget.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 014_Gtk2_Widget.t,v 1.1 2002/11/15 04:13:58 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$USE, 'Gtk2'],
            ["init()"],
        [$USE, 'Gtk2::Window'],
            ["new('toplevel')"],
#            ["size_request(40, 50)"],
#            ["size_allocate(40, 40, 60, 70)"],
            ["hide"],
            ["realize"],
            ["unrealize"],
            ["show"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
