#!/usr/bin/perl
#
# Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License
# version 2, as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# $Id: convert_funcs.pl,v 1.15 2003/03/04 12:11:45 ggc Exp $
#
#
# Takes .h function definitions of gtk and convert them to .c
# Will only work for simple functions... and for not too complicated cases :)
#
# WARNING, the flags are "gint" in the headers, so I've got no mean to
# detect flags, so you have to do it by hand
#
#
#    HOW TO USE IT
#
# 1. Open a .h of gtk/gdk/pango/glib
# 2. Remove all that is struct definitions, union, define, etc, only keep the functions
# 3. Launch that script with this file in parameter
# 4. Pray
# 5. Send me a mail if it doesn't work, I'll try to fix if I can :)
#

sub cat_ { local *F; open F, $_[0] or return; my @l = <F>; wantarray ? @l : join '', @l }
sub member { my $e = shift; foreach (@_) { $e eq $_ and return 1 } 0 }
sub if_($@) {
    my $b = shift;
    $b or return ();
    wantarray || @_ <= 1 or die("if_ called in scalar context with more than one argument " . join(":", caller()));
    wantarray ? @_ : $_[0];
}

$contents = -r $ARGV[0] ? cat_($ARGV[0]) : "@ARGV";
$contents =~ s/\n/ /g;

$contents =~ s|/\*[^(\*/)]*/*||g;  # remove comments

while ($contents =~ /\s*(((?:G_CONST_RETURN)?\s*\w+\s*\**)\s*([^\(]+)\s*\(([^\)]+)\))\s*;/g) {
    my ($fullproto, $return, $funcname, $args) = ($1, $2, $3, $4);
    $fullproto =~ s/\s+/ /g;
    print "/* $fullproto */\n";
    my $const_return;
    $return =~ s/G_CONST_RETURN\s*// and $const_return = 1;
    $return =~ s/\s//g;
    $funcname =~ s/\s//g;
    my @args_orig;
    $args =~ s/\bconst\b//g;
    while ($args =~ /\s*(\w+[\*\s]+)\s*(\w+)\s*,?/g) {
	($type, $name) = ($1, $2);
	$type =~ s/\s//g;
	push @args_orig, [$type, $name];
    }
#    print "ARGS ", (map { "<$_->[0];$_->[1]>" } @args_orig), "\n";

    ($perl_funcname = $funcname) =~ s/^([^_]+)_/$1perl_/;

    #- calculate stuff depending on return type
    my $constructor;
    if ($return ne 'void') {
	if ($return =~ /^[A-Z]/) {
	    if ($return =~ /\*/) {
		$constructor = 1;
		$funccall = "    return gtk2_perl_new_object(~~FUNCCALL~~);";
	    } else {
		$funccall = "    return newSV$return(~~FUNCCALL~~);";
	    }
	    $return = 'SV*';
	} else {
	    if ($const_return && $return ne 'gchar*' || $return eq 'gboolean' || $return =~ /^g?u?int$/) {
		$funccall = "    return ~~FUNCCALL~~;";
	    } else {
                ($newsvcall = $return) =~ s/\*//g;
		$const_return && $return eq 'gchar*' and $newsvcall .= '_nofree';
		$funccall = "    return newSV$newsvcall(~~FUNCCALL~~);";
	        $return = 'SV*';
	    }
	}
    } else {
	$funccall = "    ~~FUNCCALL~~;";
    }
    my $fixtype = sub {
	my $type = $_[0];
	@t = qw(double int long boolean);
	$type =~ s/^g$t/$t/ foreach @t; 
	$type =~ s/^u$t/$t/ foreach @t; 
	$type eq 'boolean' and $type = 'int';
	$type =~ s/int32$/int/ foreach @t;
	$type
    };
    $return = $fixtype->($return);

    #- iterate on args and calculate types for the wrapper function and wrappers in the C function call
    my @disguised_getter;
    my @args = map {
	my $n;
	$n->{perl}[1] = $_->[1];
	if ($_->[0] =~ /^[A-Z]/) {
	    $n->{perl}[0] = 'SV*';
	    $n->{c} = "Sv$_->[0]($_->[1])";
	} else {
	    $n->{perl}[0] = $fixtype->($_->[0]);
	    $n->{c} = $_->[1];
	}
	if ($n->{c} =~ s/\*//g || $_->[0] =~ /\*/) {
	    if ($_->[0] =~ /^gboolean\s*\*/ || $_->[0] =~ /^g?u?int\s*\*$/ || $_->[0] =~ /^gfloat\s*\*$/) {
		(my $type = $_->[0]) =~ s/\*//;
		push @disguised_getter, [ $type, $n->{c} ];
		$n->{c} = "&$n->{c}";
	    }
	}
	$n;
    } @args_orig;

    #- special case for "disguised getters", e.g. functions whose job is to return more than one value, we return an arrayref
    if (@disguised_getter) {
	$return = 'SV*';
	my %c2p_type = (gint => 'iv', int => 'iv', guint => 'uv', glong => 'iv', long => 'iv',
			gfloat => 'nv', float => 'nv', gdouble => 'nv', double => 'nv', gboolean => 'iv');
	$funccall = (join("\n", map { "    $_->[0] $_->[1];" } @disguised_getter))."\n".
	            "    AV* values = newAV();\n".
		    "$funccall\n".
		    (join("\n", map { "    av_push(values, newSV".($c2p_type{$_->[0]} || 'meuh')."($_->[1]));" } @disguised_getter))."\n".
		    "    return newRV_noinc((SV*) values);";
    }

    if (@args_orig >= 2) {
	#- special case for functions with a callback
	if ($args_orig[-1][0] eq 'gpointer' && $args_orig[-2][0] =~ /Func$/) {
	    $args[-1]{perl}[0] = 'SV*';
	    $funccall = "    struct callback_data cb_data = { func, data };\n".
	      "$funccall";
	    $args[-2]{c} = "marshal_$args_orig[-2][0]";
	    $args[-1]{c} = '&cb_data';
	}
    }

    if (@args_orig >= 3) {
    #- special case for functions with a callback and a GtkDestroyNotify
	if ($args_orig[-1][0] eq 'GtkDestroyNotify' && $args_orig[-2][0] eq 'gpointer' && $args_orig[-3][0] =~ /Func$/) {
	    $args[-1]{perl}[2] = 'disable';
	    $args[-2]{perl}[0] = 'SV*';
	    $funccall = "    struct callback_data * cb_data = g_malloc0(sizeof(struct callback_data));\n".
	      "    cb_data->pl_func = func;\n".
		"    cb_data->data = data;\n".
		  "    SvREFCNT_inc(cb_data->pl_func);\n".
		    "    SvREFCNT_inc(cb_data->data);\n".
		      "$funccall";
	    $args[-3]{c} = "marshal_$args_orig[-3][0]";
	    $args[-2]{c} = 'cb_data';
	    $args[-1]{c} = 'gtk2_perl_destroy_notify';
	}
    }

    $funcargs = join(', ', map { $_->{c} } @args);

    $funccall =~ s/~~FUNCCALL~~/$funcname($funcargs)/;
    $funcname =~ /_new\b/ and unshift @args, { perl => ['char*', 'class'] };    # this heuristic for guessing if we're a constructor
                                                                                # is not very good
#    print "ARGSNOW ", (map { "<$_->{perl}[0];$_->{perl}[1];$_->{c}>" } @args), "\n";
    print "$return $perl_funcname(",
      join(', ', (map { if_(!member($_->{perl}[1], map { $_->[1] } @disguised_getter) && !$_->{perl}[2],
			    "$_->{perl}[0] $_->{perl}[1]") } @args)),
      ")\n{\n$funccall\n}\n\n";
}
