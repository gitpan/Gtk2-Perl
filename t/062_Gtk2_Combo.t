#!/usr/bin/perl
#==============================================================================
#=== This is a script to test Gtk2::Combo that will be run by 'make test'
#===
#=== To run this interactively (with a Gtk2->main event loop) call eg:
#===   t/i_test.pl t/062_Gtk2_Combo.t
#==============================================================================
require 5.000; use strict 'vars', 'refs', 'subs';

our $rcsid = '$Id: 062_Gtk2_Combo.t,v 1.3 2002/11/16 03:45:08 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { 
    use Gtk2::Test; 
    @test_plan = (
        [$MAKE_TEST_BOX, 'Gtk2::Combo'],
            ["new()"],
            [$ADD_TO_TEST_BOX],
            ["set_use_arrows($TRUE)"],
            ["set_use_arrows_always($TRUE)"],
            ["set_case_sensitive($TRUE)"],
            ["set_popdown_strings(['arga', 'argb'])"],
            ["set_value_in_list($TRUE, $FALSE)"],
            [$EVAL, "\$w->{'entry'} = \$w->{'Combo'}[0]->entry"],
            [$EVAL, "\$w->{'entry'} = \$w->{'Combo'}[0]->entry"],
            [$EVAL, "\$w->{'entry'} = \$w->{'Combo'}[0]->entry"],
            [$EVAL, "\$w->{'list'} = \$w->{'Combo'}[0]->list"],
            [$EVAL, "\$w->{'popwin'} = \$w->{'Combo'}[0]->popwin"],

            [$EVAL, "\$w->{'item'} = (\$o->list->get_children)[0]"],
            [$C_EVAL, "\$w->{'item'}->show()"],
            ["set_item_string(\$w->{'item'}, 'A display string')"],
            ["disable_activate"],
#            [$EVAL, 'print_widget_tree'],
    );
    plan tests => scalar @test_plan;
}

$DEBUG = $ARGV[0] || 0;

&do_tests;
