# $Id: _config.pm,v 1.10 2002/11/18 15:28:39 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

BEGIN {
# make automatic prefix
$_prefix =
  do { my $pf = __PACKAGE__;
       # handle special case
       $pf =~ s/^Gtk2::Gdk::GC/Gtk2::Gdk::Gc/;
       # handle library prefix
       $pf =~ s/^Gtk2:+G(Type|Signal|Object)/'gperl_' . lc $1/e ||
       $pf =~ s/^Gtk2:+Pango:+/pangoperl/ ||
       $pf =~ s/^Gtk2:+Gdk:+Event:+/gdkperl_event/ ||
       $pf =~ s/^Gtk2:+Gdk:+/gdkperl/ ||
       $pf =~ s/^Gtk2:*/gtkperl/;
       # handle special cases
       $pf =~ s/([HV])(Box|Button|Paned|Ruler|Scale|Scroll|Separator)/$1 . lc $2/e;
       $pf =~ s/(C)(Tree|List)/$1 . lc $2/e;
       # handle class prefix
       $pf =~ s/([A-Z])/'_' . lc $1/ge;
       "${pf}_" 
     };
# make automatic source file, not used yet
$_srcfile =
  do {
    my ($src, $pf) = (__PACKAGE__,__PACKAGE__);
    $pf =~ s{::G(Lib|Object|Signal|Type)::}{} ||
    $pf =~ s{::(Gdk)::(Event)::\w+}{/$1/$2} ||
    $pf =~ s{::(Gdk|Pango)::\w+}{/$1} ||
    $pf =~ s{(Gtk2)::\w+}{$1};
    $src =~ s/.+::(\w+)$/$1/;
    "${pf}/src/${src}.c";
  };
}

#printf "package %s prefix %s srcfile %s\n", __PACKAGE__, $_prefix, $_srcfile;

use Inline C => Config =>
  NAME => __PACKAGE__,
  PREFIX => $_prefix,
  BUILD_NOISY => 1,
  ENABLE => AUTOWRAP,
  CLEAN_AFTER_BUILD => 0,
  GLOBAL_LOAD => 1,
  LIBS => `pkg-config gtk+-2.0 --libs`,
  OPTIMIZE => $ENV{GTK2_PERL_CFLAGS} || '-g -Wall -Wstrict-prototypes',
  TYPEMAPS => '' . $ENV{PWD} . '/Gtk2/typemap',
  INC => '-I' . $ENV{PWD} . '/Gtk2/include ' . `pkg-config gtk+-2.0 --cflags`;
use Inline C => $_srcfile;

#print "Configuring: ",__PACKAGE__,' in ', $ENV{PWD}, "\n";
#print "PREFIX:${_prefix}\n";
#print "SOURCE:${_srcfile}\n";

