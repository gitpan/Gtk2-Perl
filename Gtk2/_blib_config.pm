#this file is to overwrite _config.pm when installed
#instead of Inline:ing we bootstrap modules
# $Id: _blib_config.pm,v 1.7 2002/12/10 09:28:35 gthyni Exp $

use base qw(DynaLoader);

#use Gtk2;
use Carp;

#$DynaLoader::dl_debug=1;

#sub dl_load_flags { 0x01 }

sub xbootstrap
  {
    # use local vars to enable $module.bs script to edit values
    local(@args) = @_;
    local($module) = $args[0];
    #print STDERR "XBootstrap: $module \n";
    return DynaLoader::bootstrap(@_) if $module eq 'Gtk2';
    local(@dirs, $file);
    if(defined $Gtk2::loaded->{$module})
      {
	#print STDERR "Already bootstrapped: $module \n";
	return 1;
      }
    $Gtk2::loaded->{$module} = 1;
    #print STDERR "Bootstrap: $module \n";
    unless ($module) {
	require Carp;
	Carp::confess("Usage: DynaLoader::bootstrap(module)");
    }
    my @modparts = ('Gtk2');
    my $modfname = $modparts[-1];
    # Some systems have restrictions on files names for DLL's etc.
    # mod2fname returns appropriate file base name (typically truncated)
    # It may also edit @modparts if required.
    $modfname = &mod2fname(\@modparts) if defined &mod2fname;
    my $modpname = join('/',@modparts);
    print STDERR "${module}::bootstrap for $module ",
		       "(auto/$modpname/$modfname.${DynaLoader::dl_dlext})\n"
	if $DynaLoader::dl_debug;
    foreach (@INC) {
	my $dir;
	$dir = "$_/auto/$modpname";
	next unless -d $dir; # skip over uninteresting directories
	# check for common cases to avoid autoload of dl_findfile
	my $try = "$dir/$modfname." . $DynaLoader::dl_dlext;
	last if $file = ($do_expand) ? dl_expandspec($try) : ((-f $try) && $try);
	# no luck here, save dir for possible later dl_findfile search
	push @dirs, $dir;
    }
    # last resort, let dl_findfile have a go in all known locations
    $file = DynaLoader::dl_findfile(map("-L$_",@dirs,@INC), $modfname) unless $file;
    croak("Can't locate loadable object for module $module in \@INC (\@INC contains: @INC)")
	unless $file;	# wording similar to error from 'require'
    my $bootname = "boot_$module";
    $bootname =~ s/\W/_/g;
    @dl_require_symbols = ($bootname);
    # Execute optional '.bootstrap' perl script for this module.
    # The .bs file can be used to configure @dl_resolve_using etc to
    # match the needs of the individual module on this architecture.
    my $bs = $file;
    $bs =~ s/(\.\w+)?(;\d*)?$/\.bs/; # look for .bs 'beside' the library
    if (-s $bs) { # only read file if it's not empty
        print STDERR "BS: $bs ($^O, $dlsrc)\n" if $dl_debug;
        eval { do $bs; };
        warn "$bs: $@\n" if $@;
    }
    # Many dynamic extension loading problems will appear to come from
    # this section of code: XYZ failed at line 123 of DynaLoader.pm.
    # Often these errors are actually occurring in the initialisation
    # C code of the extension XS file. Perl reports the error as being
    # in this perl code simply because this was the last perl code
    # it executed.
    my $libref = DynaLoader::dl_load_file($file, $module->dl_load_flags) or
	croak("Can't load '$file' for module $module: ".dl_error());
    push(@dl_librefs,$libref);  # record loaded object
    my @unresolved = DynaLoader::dl_undef_symbols();
    if (@unresolved) {
	require Carp;
	Carp::carp("Undefined symbols present after loading $file: @unresolved\n");
    }
    my $boot_symbol_ref = DynaLoader::dl_find_symbol($libref, $bootname) or
         croak("Can't find '$bootname' symbol in $file\n");
    push(@dl_modules, $module); # record loaded module
  boot:
    my $xs = DynaLoader::dl_install_xsub("${module}::bootstrap", $boot_symbol_ref, $file);
    #print STDERR "BOOT: $libref, $bootname, $boot_symbol_ref, $file => $xs \n";
    # See comment block above
    &$xs(@args);
}

my $package = __PACKAGE__;
$Gtk2::VERSION = "0.01" unless defined $Gtk2::VERSION;
$package->xbootstrap($Gtk2::VERSION); # if $package ne 'Gtk2';




