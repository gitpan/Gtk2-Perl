#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::GObject that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/011_Gtk2_GObject.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 011_Gtk2_GObject.t,v 1.4 2002/11/16 03:45:08 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$MAKE_TEST_BOX, 'Gtk2::Window'],
            ["new('toplevel')"],
            ["signal_connect('destroy', 'quit', ['data1', 'data2'])"],
#            ["signal_block(\$prev_ret)"],

            ["get_data('MyKey')", "eq ''"],
            ["set_data('MyKey', 'New Value')"],
            ["get_data('MyKey')", "eq 'New Value'"],

            ['sink'],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
