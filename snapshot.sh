#!/bin/bash

# $Id: snapshot.sh,v 1.1.1.1 2002/10/15 21:00:47 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

cd ..
TARFILE=gtk2-perl-`date +'%Y%m%d'`.tar.gz
tar cvzf $TARFILE  gtk2-perl/*.p? gtk2-perl/Gtk2/*.pm gtk2-perl/Gtk2/src/*.c gtk2-perl/Changelog gtk2-perl/*.txt
scp $TARFILE kirra.net:~/www/perl/arkiv/
rm -f $TARFILE


