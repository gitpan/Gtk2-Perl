/* $Id: VBox.c,v 1.4 2003/01/16 21:24:03 joered Exp $
 * Copyright 2002, G�ran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_vbox__new(char* class, int homogeneous, int spacing)
{
    return gtk2_perl_new_object(gtk_vbox_new(homogeneous != 0, spacing));
}

