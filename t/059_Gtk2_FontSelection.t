#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::FontSelection
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

# $Id: 059_Gtk2_FontSelection.t,v 1.6 2003/01/21 18:57:50 gthyni Exp $

our $rcsid = '$Id: 059_Gtk2_FontSelection.t,v 1.6 2003/01/21 18:57:50 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$MAKE_TEST_BOX, "Gtk2::FontSelection"],
            ["new()"],
            [$ADD_TO_TEST_BOX],
# don't know how to resolve this and a release is urgent!
	    #[$GET_SET, 'preview_text', "'abcdefghijk ABCDEFGHIJK'", "'New preview text'"],
            #["set_font_name('serif 12')", "== $TRUE"],
            #[$GET_SET, 'font_name', "'Serif 12'", "'Sans 12'"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
