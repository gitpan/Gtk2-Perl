#!/usr/bin/perl -w

# Makefile.PL for Gtk2-Perl
# copyright 2002, Dermot Musgrove
# parts copyright 2002,  Göran Thyni, kirra.net
#
# $Id: Makefile.PL,v 1.17 2002/12/09 20:38:08 gthyni Exp $
#

require 5.000;
require ExtUtils::MakeMaker;
use strict;
use Cwd;

#$ExtUtils::MakeMaker::Verbose=2;

my $so_blib = "blib/arch/auto/Gtk2";
my $so = "$so_blib/Gtk2.so";

my $prereq_pm = { 'Inline::C' => "0.44", 'Inline::Files' => "0.60" };

do "fast-compile.pl";
my @srcs = ();
my @xss = `find _Inline -name '*.xs' -print`;
chomp @xss;
for (@xss)
{
  my ($src, $dst) = ($_,$_);
  my @dst = split '/', $_;
  $dst[-2] = '' if $dst[-2] . '.xs' eq $dst[-1]; 
  $dst = join '/',  @dst[2..$#dst];
  my $dir = join '/',  'xs', @dst[2..$#dst-1];
  $dst =~ s{//+}{/}g;
  my $cmd = "mkdir -p $dir";
  unless (-d $dir)
    {
      print STDERR "$cmd\n";
      system $cmd;
    }
  push @srcs, "xs/$dst";
}

#--------------------------------------
# generate the Makefile
my $typemap = getcwd . '/Gtk2/typemap';
ExtUtils::MakeMaker::WriteMakefile(
				   'DISTNAME'      => 'Gtk2-Perl',
				   'NAME'          => 'Gtk2',
				   'AUTHOR'        => 'the gtk2-perl team at http://sf.net/projects/gtk2-perl/',
				   'VERSION_FROM'  => 'Gtk2.pm',
				   'clean'         => { FILES => '$(EXE_FILES)' },
				   'dist'          => { COMPRESS => 'gzip', SUFFIX => 'gz' },
				   'PREREQ_PM'     => $prereq_pm,
				   'PMLIBDIRS'     => ['Gtk2'],
				   'INC' => '-I_Inline/build/Gtk2/Gtk2 -IGtk2/include `pkg-config gtk+-2.0 --cflags`',
				   'TYPEMAPS' => [$typemap],
				  );


# OVERRIDDEN MM methods

sub MY::constants
  {
    my($self) = @_;
    #print STDERR "MY::init_dirscan\n";
    my $pm = $self->{PM};
    for my $key (keys %$pm) 
      {
	if ($key =~ /blib_config.pm$/)
	  {
	    $pm->{$key} =~ s/_blib_config/_config/;
	    next;
	  }
	delete $pm->{$key} if $key =~ /_config.pm$/;
	delete $pm->{$key} unless $key =~ /\.pm$/ or $key =~ /\.xs$/;
      }
    #$self->{PM} = $pm;
    $self->{NEEDS_LINKING} = 1;
    $self->ExtUtils::MM::constants;
  }

sub MY::linkext
  {
    "linkext :: $so\n\n";
  }

sub MY::dynamic_lib {
  my @l = ();
  my $inl = "_Inline/build/";
  my $inllib = "_Inline/lib/auto/";
  my @incs = `find Gtk2 -name '*.h' -print`;
  chop @incs;
  #  my @srcs = `find Gtk2 -name '*.c' -print`;
#  my @srcs = `find xs -name '*.xs' -print`;
#  chop @srcs;
  push @l, "SRCS=\\\n " . join("\\\n ", @srcs) . "\n";
  my @objs = map { my $o = $_; $o =~ s/\.xs/\.o/; $o } @srcs;
    #map { my $o = $_; $o =~  s{src/(\w+)\.c}{$1/$1\.o}; $o =~ s{Gtk2/Gtk2}{Gtk2}; $inl . $o } @srcs;
  push @l, "OBJS=\\\n " . join("\\\n ", @objs) . "\n";
  # write rule to build so
  push @l, 
    "$so: \$(OBJS)\n" . 
      "\tmkdir -p $so_blib\n" . 
	"\tgcc -shared -g -o $so \$(OBJS) \$(XS_DEFINE_VERSION) `pkg-config gtk+-2.0 --libs`\n";
  for (my $i = 0; $i < scalar @srcs; $i++) {
    my $pm = $srcs[$i];
    $pm =~ s{src/(\w+)\.c}{$1};
    $pm =~ s{Gtk2/Gtk2}{Gtk2};
    my $inldir = $pm;
    $pm =~ s{/}{::}g;
    # rule to build .o
    push @l,
      $objs[$i] . ": " . $srcs[$i] . " " . join(' ',@incs) . "\n";
    # rule to update from _Inline
    push @l,
      $srcs[$i] . ": " . $xss[$i] . "\n\tcp " . $xss[$i] . " " . $srcs[$i] . "\n";
  }
  join("\n", @l);
}

sub MY::xs_o {	# many makes are too dumb to use xs_c then c_o
    '
.xs$(OBJ_EXT):
	$(PERLRUN) $(XSUBPP) $(XSPROTOARG) $(XSUBPPARGS) $*.xs > $*.xsc && $(MV) $*.xsc $*.c
	$(CCCMD) $(CCCDLFLAGS) "-I$(PERL_INC)" $(PASTHRU_DEFINE) $(DEFINE) $*.c -o $*.o
';
}

sub MY::c_o {	# many makes are too dumb to use xs_c then c_o
    '
.c$(OBJ_EXT):
	$(CCCMD) $(CCCDLFLAGS) "-I$(PERL_INC)" $(PASTHRU_DEFINE) $(DEFINE) $*.c -o $*.o
';
}

# I want lazy load!
sub MY::test_via_harness {
    my($self, $perl, $tests) = @_;
    return $self->ExtUtils::MM_Any::test_via_harness("$perl", $tests);
}

# Make it return 0 for shell
0;

# End of Makefile.PL


