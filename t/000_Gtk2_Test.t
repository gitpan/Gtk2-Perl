#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::Test that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/000_Gtk2_Test.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 000_Gtk2_Test.t,v 1.10 2002/11/16 03:45:08 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$MAKE_TEST_BOX, 'Gtk2::Window'],
            ["new()", $EXPECT_ERROR, "=~ /^Usage:/"],
            ["new('toplevel')"],
            ["new('topleel')", $EXPECT_ERROR,   "=~ /FATAL: invalid enum GtkWindowType value topleel/"],
            ["set_position('xcenter')", $EXPECT_ERROR],
            ["set_position('mouse')"],
            ["set_title()", $EXPECT_ERROR, "=~ /Usage:/"],
            ["set_title('Title')"],
            ["get_resizable",                   "== $TRUE"],
            ["set_resizable($FALSE)"],
            ["get_resizable",                   "== $FALSE"],
            [$GET_SET, 'resizable', $FALSE, $TRUE],
            ["realize"],

        [$USE, 'Gtk2::HBox'],
            ["new(1, 1)"],
            [$EVAL, "\$o->isa('Gtk2::HBox')"],
            [$EVAL, "!(\$o->isa('xGtk2::HBox'))"],
            [$EVAL, "\$xo->isa('Gtk2::HBox')", 
                $EXPECT_ERROR, '=~ /Global symbol "\$xo" requires explicit package name/'],
            [$EVAL, "\$w->{'xButton'}[0]->xisa('Gtk2::Button')", 
                $EXPECT_ERROR, '=~ /Can\'t call method "xisa" on an undefined value/'],
            [$C_EVAL, "\$w->{'Window'}[-1]->add(\$w->{'HBox'}[-1])"],

        [$USE, "Gtk2::Button"],
            ["new"],
            ["set_label('Test label')"],
            [$GET_SET, 'label', "'Test label'", "'Print handler args'"],
            ["signal_connect('clicked', 'print_handler_args', 'test data')"],

            [$ADD_TO_TEST_BOX],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;

