/* $Id: Viewport.c,v 1.2 2002/11/05 04:34:04 glade-perl Exp $
 * Copyright 2002, Dermot Musgrove <dermot.musgrove@virgin.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV*  gtkperl_viewport__new(char* class, SV* hadj, SV* vadj)
{
    return gtk2_perl_new_object(gtk_viewport_new(SvGtkAdjustment_nullok(hadj),
							SvGtkAdjustment_nullok(vadj)));
}

SV* gtkperl_viewport_get_hadjustment(SV* viewport)
{
    return gtk2_perl_new_object(gtk_viewport_get_hadjustment(SvGtkViewport(viewport)));
}

SV* gtkperl_viewport_get_vadjustment(SV* viewport)
{
    return gtk2_perl_new_object(gtk_viewport_get_vadjustment(SvGtkViewport(viewport)));
}

void gtkperl_viewport_set_shadow_type(SV *viewport, SV *shadow_type)
{
    gtk_viewport_set_shadow_type(SvGtkViewport(viewport), SvGtkShadowType(shadow_type));
}

void gtkperl_viewport_set_hadjustment(SV *viewport, SV *hadjustment)
{
    gtk_viewport_set_hadjustment(SvGtkViewport(viewport), SvGtkAdjustment(hadjustment));
}

void gtkperl_viewport_set_vadjustment(SV *viewport, SV *hadjustment)
{
    gtk_viewport_set_vadjustment(SvGtkViewport(viewport), SvGtkAdjustment(hadjustment));
}

SV* gtkperl_viewport_get_shadow_type(SV* viewport)
{
    return newSVGtkShadowType(gtk_viewport_get_shadow_type(SvGtkViewport(viewport)));
}

