#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::ProgressBar that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/105_Gtk2_ProgressBar.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 105_Gtk2_ProgressBar.t,v 1.2 2002/11/17 12:59:16 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    $ENV{LC_ALL} = 'C'; # avoid locales that use ',' as decimal separtor
    @test_plan = (
        [$MAKE_TEST_BOX, 'Gtk2::ProgressBar'],
            ["new"],
            [$ADD_TO_TEST_BOX],
            [$GET_SET, 'text', "''", "'New value'"],
            [$GET_SET, 'fraction', 0, .25],
            [$GET_SET, 'pulse_step', 0.1, .2],
            [$GET_SET, 'orientation', "'left-to-right'", "'right-to-left'"],
            [$C_EVAL, "Gtk2->timeout_add(500, sub{\$o->pulse})"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
