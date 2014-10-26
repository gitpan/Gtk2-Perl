/* $Id: Alignment.c,v 1.5 2003/01/16 21:24:03 joered Exp $
 * Copyright 2002, G�ran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_alignment__new(char* class, double xalign, double yalign, double xscale, double yscale)
{
    return gtk2_perl_new_object(gtk_alignment_new(xalign, yalign, xscale, yscale));
}


void gtkperl_alignment_set(SV *align, double xalign, double yalign, double xscale, double yscale)
{
    gtk_alignment_set(SvGtkAlignment(align), xalign, yalign, xscale, yscale);
}


