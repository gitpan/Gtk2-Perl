#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::List that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/071_Gtk2_List.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 071_Gtk2_List.t,v 1.1 2002/11/16 03:45:08 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$MAKE_TEST_BOX, "Gtk2::List"],
            ["new()"],
            ["show"],
            [$ADD_TO_TEST_BOX],
            ["set_selection_mode('multiple')"],
        
        [$USE, "Gtk2::ListItem"],
            ["new_with_label('A list item')"],
            ["show"],
            [$C_EVAL, "\$w->{'List'}[-1]->add(\$o)"],
            
            ["new_with_label('A list item')"],
            ["show"],
            [$C_EVAL, "\$w->{'List'}[-1]->add(\$o)"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
