/*
 * Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Library General Public License
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: Plug.c,v 1.1 2002/12/02 21:45:33 ggc Exp $
 */

#include "gtk2-perl.h"

#ifndef GDK_MULTIHEAD_SAFE

/* GtkWidget* gtk_plug_new (GdkNativeWindow  socket_id) */
SV* gtkperl_plug_new(char* class, int socket_id)
{
    return gtk2_perl_new_object(gtk_plug_new(socket_id));
}

#endif

/* GdkNativeWindow gtk_plug_get_id (GtkPlug *plug) */
int gtkperl_plug_get_id(SV* plug)
{
    return gtk_plug_get_id(SvGtkPlug(plug));
}


/** methods to access internal stuff **/

SV* gtkperl_plug_socket_window(SV* plug)
{
    return gtk2_perl_new_object_nullok(SvGtkPlug(plug)->socket_window);
}

SV* gtkperl_plug_modality_window(SV* plug)
{
    return gtk2_perl_new_object_nullok(SvGtkPlug(plug)->modality_window);
}

int gtkperl_plug_same_app(SV* plug)
{
    return SvGtkPlug(plug)->same_app;
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
