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
# $Id: castmacros-autogen.pl,v 1.23 2002/11/28 13:55:28 ggc Exp $
#

-d 'genscripts' && -d 'Gtk2' or die "This script should be run from the gtk2-perl topdir";

sub cat_ { local *F; open F, $_[0] or return; my @l = <F>; wantarray ? @l : join '', @l }

%categories = (glib =>  { class_names => '^G[A-Z]', prefix => sub { $_[0] =~ s/^G/Gtk2::G/; $_[0] } },
	       gdk =>   { class_names => '^Gdk',    prefix => sub { $_[0] =~ s/^Gdk/Gtk2::Gdk::/; $_[0] } },
	       pango => { class_names => '^Pango',  prefix => sub { $_[0] =~ s/^Pango/Gtk2::Pango::/; $_[0] } },
	       atk =>   { class_names => '^Atk',    prefix => sub { $_[0] =~ s/^Atk/Gtk2::Atk::/; $_[0] } },
	       gtk =>   { class_names => '^Gtk',    prefix => sub { $_[0] =~ s/^Gtk/Gtk2::/; $_[0] } },
	      );

sub all_includes {
    my @results;
    foreach $dir (`pkg-config gtk+-2.0 --cflags` =~ /-I(\S+)/g) {
	foreach $gen (map { "$dir/$_" } qw(glib gobject gdk gdk-pixbuf gdk-pixbuf-xlib gtk pango atk)) {
	    foreach $file (glob("$gen/*")) {
		push @results, cat_($file);
	    }
	}
    }
    @results;
}


# On demand, generate a callback function marshal
if ($ARGV[0]) {
    print "/* auto generated marshal for $ARGV[0] (using genscripts/castmacros-autogen.pl $ARGV[0]) */\n";
    my @inc = all_includes();
    foreach my $i (0 .. $#inc) {
	if ($inc[$i] =~ /^typedef (\S+) \(\*\s*(\S+)\s*\)(.*)/ && $ARGV[0] eq $2) {
	    my ($rettype, $rest) = ($1, $3);
	    while ($rest !~ /;\s*$/) {
		$rest .= $inc[++$i];
	    }
	    $rest =~ s/\s+/ /g;
	    $rest =~ s/;\s*$//;
	    $rest =~ s/^\s*//;
	    print "static $rettype marshal_$ARGV[0]$rest\n{\n";
	    $rettype ne 'void' and print "    int i;\n";
	    print "    struct callback_data * cb_data = data;\n";
	    print "    $_;\n" foreach qw(dSP ENTER SAVETMPS PUSHMARK(SP));
	    my $xpushs = sub {
		my ($type, $name) = @_;
		$type =~ s/\*|\s//g;
		foreach $cat (keys %categories) {
		    if ($type =~ /$categories{$cat}{class_names}/) {
			print "    XPUSHs(sv_2mortal(gtk2_perl_new_object_from_pointer_nullok($name, \"",
			      $categories{$cat}{prefix}->($type),
			      "\")));\n";
			return;
		    }
		}
		#- not a gtk/glib object
		my %c2p_type = (gint => 'iv', int => 'iv', guint => 'uv', glong => 'iv', long => 'iv',
				gfloat => 'nv', float => 'nv', gdouble => 'nv', double => 'nv', gboolean => 'iv');
		print "    XPUSHs(sv_2mortal(newSV", $c2p_type{$type}, "($name)));\n";
	    };
	    $rest =~ s/^\s*\(\s*//;
	    $rest =~ s/\s*\)\s*$//;
	    my @args = split /,/, $rest;
	    pop @args;
	    foreach (@args) { /\s*(.*[\s\*])(\S+)\s*$/; $xpushs->($1, $2) }
	    print "    $_;\n" foreach qw(XPUSHs(cb_data->data) PUTBACK);
	    if ($rettype eq 'void') {
		print "    $_;\n" foreach ('perl_call_sv(cb_data->pl_func, G_DISCARD)', 'FREETMPS', 'LEAVE');
	    } else {
		print "    $_;\n" foreach ('i = perl_call_sv(cb_data->pl_func, G_SCALAR)',
					   'SPAGAIN', 'if (i != 1) croak("Big trouble\n"); else i = POPi', 'PUTBACK',
					   'FREETMPS', 'LEAVE', 'return i');
	    }
	    print "}\n\n";
	}
    }
    exit 0;
}


sub add_in_cat {
    ($gtkname, $line) = @_;
    foreach $cat (keys %categories) {
	if ($gtkname =~ /$categories{$cat}{class_names}/) {
	    push @{$categories{$cat}{autogen}}, $line;
	}
    }
}

# Generate perl objects to gtk objects casters, performing on-the-fly type checking, things like:
#   #define SvGtkWidget(o) ((GtkWidget*) SvIV(SvRV(gtk2_perl_check_type(o, "GtkWidget"))))
#   etc
sub add_object_caster_in_cat {
    ($o) = @_;
    add_in_cat($o, "#define Sv$o(o) (($o*) SvIV(SvRV(gtk2_perl_check_type(o, \"$o\"))))\n");
    add_in_cat($o, "#define Sv$o"."_nullok(o) (SvROK(o) ? (($o*) SvIV(SvRV(gtk2_perl_check_type(o, \"$o\")))) : NULL)\n");
}
# find most object in include dirs
foreach (all_includes()) {
    /^struct\s+_(\w+)Class\s*{?\s*$/ and add_object_caster_in_cat($1);
}
# enumerate the missing ones
@additional_not_objects = qw(GSList
                             GdkColor GdkWindow GdkEvent GdkCursor GdkPixbuf GdkPixmap GdkBitmap GdkRectangle GdkPoint GdkSegment GdkSpan
                             GdkEventAny GdkEventButton GdkEventClient GdkEventConfigure GdkEventCrossing GdkEventDND GdkEventExpose
                             GdkEventFocus GdkEventKey GdkEventMotion GdkEventNoExpose GdkEventProperty GdkEventProximity
                             GdkEventScroll GdkEventSelection GdkEventSetting GdkEventWindowState GdkEventVisibility
                             GdkAtom
                             PangoFontDescription PangoFontMetrics PangoContext PangoLanguage PangoLayout PangoAttrList
                             GtkRequisition GtkBoxChild
                             GtkTreeIter GtkTreeModel GtkTreePath GtkTextIter GtkSelectionData
                            );
add_object_caster_in_cat($_) foreach @additional_not_objects;


# Generate enum converters from defs file (it contains the needed mapping of the like GtkWindowType -> GTK_TYPE_WINDOW_TYPE)
sub parse_lisp
{
	local($_) = @_;
	my(@result) = ();
	my($node) = \@result;
	my(@parent) = ();
	while ( m/(\()|(\))|("(.*?)")|(;.*?$)|([^\(\)\s]+)/gm) {
		if (defined($1)) {
			my($new) = [];
			push @$node, $new;
			push @parent, $node;
			$node = $new;
		} elsif (defined($2)) {
			$node = pop @parent;
		} elsif (defined($3)) {
			push @$node, $4;
		} elsif (defined($6)) {
			push @$node, $6;
		}
	}
	@result;
}
sub add_enumflag {
    my ($name, $enumorflag, $type) = @_;
    add_in_cat($name, "#define Sv$name(o) gtk2_perl_convert_$enumorflag($type, o)\n");
    add_in_cat($name, "#define newSV$name(o) gtk2_perl_convert_back_$enumorflag($type, o)\n");
}
sub process_node {
    my (@node) = @{$_[0]};
    return if !defined($node[0]);

    if ($node[0] =~ /^define-enum|define-flags$/) {
	my ($name, $gtype);
	foreach (@node[2..$#node]) {
	    ($n, $v) = ($_->[0], $_->[1]);
	    $n eq 'c-name' and $name = $v;
	    $n eq 'gtype-id' and $gtype = $v;
	}
	$name && $gtype or next;
	add_enumflag($name, $node[0] eq 'define-enum' ? 'enum' : 'flags', $gtype);
    }
}
foreach $node (parse_lisp(cat_('genscripts/gtk-types.defs').cat_('genscripts/gdk-types.defs'))) {
    process_node($node);
}
# enumerate the missing ones
%additional_enums = (PangoDirection => PANGO_TYPE_DIRECTION, PangoWrapMode => PANGO_TYPE_WRAP_MODE, PangoAlignment => PANGO_TYPE_ALIGNMENT);
while (my ($name, $type) = each %additional_enums) { add_enumflag($name, 'enum', $type) }


# kick back to disk
foreach $cat (keys %categories) {
    open F, ">Gtk2/include/gtk2-perl-helpers-$cat-autogen.h";
    print F foreach @{$categories{$cat}{autogen}};
    close F;
    print "Generated autogen file for `$cat' category.\n";
}
