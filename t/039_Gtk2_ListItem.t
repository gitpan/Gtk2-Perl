#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::ListItem that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/039_Gtk2_ListItem.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 039_Gtk2_ListItem.t,v 1.1 2002/11/15 04:13:58 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$MAKE_TEST_BOX, "Gtk2::ListItem"],

        [$USE, 'Gtk2::ListItem'],
            ["new_with_label('A list item')"],
            ["select"],
            [$ADD_TO_TEST_BOX],
            ["new()"],
            [$ADD_TO_TEST_BOX],
            ["deselect"],
            ["select"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
