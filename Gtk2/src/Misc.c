/* $Id: Misc.c,v 1.6 2002/11/15 06:26:20 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

void gtkperl_misc_set_alignment(SV* misc, int xalign, int yalign)
{
    gtk_misc_set_alignment(SvGtkMisc(misc), xalign, yalign);
}

void gtkperl_misc_set_padding(SV* misc, int xpad, int ypad)
{
    gtk_misc_set_padding(SvGtkMisc(misc), xpad, ypad);
}

/* void gtk_misc_get_alignment (GtkMisc *misc, gfloat *xalign, gfloat *yalign); */
SV* gtkperl_misc_get_alignment(SV* misc)
{
    gfloat xalign;
    gfloat yalign;
    AV* values = newAV();
    gtk_misc_get_alignment(SvGtkMisc(misc), &xalign, &yalign);
    av_push(values, newSVnv(xalign));
    av_push(values, newSVnv(yalign));
    return newRV_noinc((SV*) values);
}

/* void gtk_misc_get_padding (GtkMisc *misc, gint *xpad, gint *ypad); */
SV* gtkperl_misc_get_padding(SV* misc)
{
    gint xpad;
    gint ypad;
    AV* values = newAV();
    gtk_misc_get_padding(SvGtkMisc(misc), &xpad, &ypad);
    av_push(values, newSVnv(xpad));
    av_push(values, newSVnv(ypad));
    return newRV_noinc((SV*) values);
}
