#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::CList that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/064_Gtk2_CList.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 064_Gtk2_CList.t,v 1.1 2002/11/16 03:45:08 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$MAKE_TEST_BOX, "Gtk2::CList"],
            ["new(3)"],
            ["column_titles_show"],
            [$ADD_TO_TEST_BOX],

#            ["new_with_labels(['cola', 'colb', 'colc'])"],
#            [$ADD_TO_TEST_BOX],

        [$USE, "Gtk2::Button"],
            ["new_with_label('Column 0')"],
            ["show"],
            [$C_EVAL, "\$w->{'CList'}[0]->set_column_widget(0, \$o)"],
            ["new_with_label('Column 1')"],
            ["show"],
            [$C_EVAL, "\$w->{'CList'}[0]->set_column_widget(1, \$o)"],
            ["new_with_label('Column 2')"],
            ["show"],
            [$C_EVAL, "\$w->{'CList'}[0]->set_column_widget(2, \$o)"],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
