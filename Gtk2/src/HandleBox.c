/* $Id: HandleBox.c,v 1.2 2002/11/05 04:34:04 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV*  gtkperl_handle_box_new(char* class)
{
    return gtk2_perl_new_object_from_pointer(gtk_handle_box_new(), class);
}

void gtkperl_handle_box_set_shadow_type(SV* handle_box, SV* type)
{
    gtk_handle_box_set_shadow_type(
        SvGtkHandleBox(handle_box), SvGtkShadowType(type));
}

SV* gtkperl_handle_box_get_shadow_type(SV* handle_box)
{
    return newSVGtkShadowType(
        gtk_handle_box_get_shadow_type(SvGtkHandleBox(handle_box)));
}

void gtkperl_handle_box_set_handle_position(SV* handle_box, SV* position)
{
    gtk_handle_box_set_handle_position(
        SvGtkHandleBox(handle_box), SvGtkPositionType(position));
}

SV* gtkperl_handle_box_get_handle_position(SV* handle_box)
{
    return newSVGtkPositionType(
        gtk_handle_box_get_handle_position(SvGtkHandleBox(handle_box)));
}

void gtkperl_handle_box_set_snap_edge(SV* handle_box, SV* edge)
{
    gtk_handle_box_set_snap_edge(
        SvGtkHandleBox(handle_box), SvGtkPositionType(edge));
}

SV* gtkperl_handle_box_get_snap_edge(SV* handle_box)
{
    return newSVGtkPositionType(
        gtk_handle_box_get_snap_edge(SvGtkHandleBox(handle_box)));
}

