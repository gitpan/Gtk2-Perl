#!/bin/sh

# Compile all with NOCLEAN (to keep the .o-files around)
perl fast-compile.pl
# link a shared object
mkdir -p blib/arch/auto/Gtk2
gcc -shared -g -o blib/arch/auto/Gtk2/Gtk2.so \
  `find _Inline/build/Gtk2 -name *.o` \
  `pkg-config gtk+-2.0 --libs`
touch blib/arch/auto/Gtk2/Gtk2.bs
# copy all *.pm and kill _config.pm
mkdir -p blib/lib/Gtk2
cp -r Gtk2.pm Gtk2 blib/lib
find blib/lib -name src | xargs rm -fr
find blib/lib -name include | xargs rm -fr
find blib/lib -name '*~' | xargs rm -f
rm -f blib/lib/Gtk2/_config.pm
ln -f blib/lib/Gtk2/_blib_config.pm  blib/lib/Gtk2/_config.pm


