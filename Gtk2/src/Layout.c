/* $Id: Layout.c,v 1.2 2002/11/04 20:11:12 gthyni Exp $
 * Copyright 2002, Dermot Musgrove <dermot.musgrove@virgin.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV*  gtkperl_layout__new(char* class, SV* hadj, SV* vadj)
{
    return gtk2_perl_new_object(gtk_layout_new(SvGtkAdjustment_nullok(hadj),
							SvGtkAdjustment_nullok(vadj)));
}

SV* gtkperl_layout_get_hadjustment(SV* layout)
{
    return gtk2_perl_new_object(gtk_layout_get_hadjustment(SvGtkLayout(layout)));
}

SV* gtkperl_layout_get_vadjustment(SV* layout)
{
    return gtk2_perl_new_object(gtk_layout_get_vadjustment(SvGtkLayout(layout)));
}

void gtkperl_layout_set_hadjustment(SV *layout, SV *hadjustment)
{
    gtk_layout_set_hadjustment(SvGtkLayout(layout), SvGtkAdjustment(hadjustment));
}

void gtkperl_layout_set_vadjustment(SV *layout, SV *hadjustment)
{
    gtk_layout_set_vadjustment(SvGtkLayout(layout), SvGtkAdjustment(hadjustment));
}

/* Deprecated */
void gtkperl_layout__freeze(SV* layout)
{
    gtk_layout_freeze(SvGtkLayout(layout));
}

/* Deprecated */
void gtkperl_layout__thaw(SV* layout)
{
    gtk_layout_thaw(SvGtkLayout(layout));
}

void gtkperl_layout_put(SV* layout, SV* child_widget, int x, int y)
{
    gtk_layout_put(SvGtkLayout(layout), SvGtkWidget(child_widget), x, y);
}

void gtkperl_layout_move(SV* layout, SV* child_widget, int x, int y)
{
    gtk_layout_move(SvGtkLayout(layout), SvGtkWidget(child_widget), x, y);
}

void gtkperl_layout_set_size(SV* layout, int width, int height)
{
    gtk_layout_set_size(SvGtkLayout(layout), width, height);
}

SV* gtkperl_layout__get_size(SV* layout)
{
    int w, h;
    AV* size = newAV();
    gtk_layout_get_size(SvGtkLayout(layout), &w, &h);
    av_push(size, newSViv(w));
    av_push(size, newSViv(h));
    return newRV_noinc((SV*) size);
}

