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
 * $Id: Socket.c,v 1.2 2002/12/02 22:07:51 gthyni Exp $
 */

#include "gtk2-perl.h"

/* GtkWidget* gtk_socket_new (void) */
SV* gtkperl_socket_new(char* class)
{
    return gtk2_perl_new_object(gtk_socket_new());
}

/* void gtk_socket_add_id (GtkSocket *socket, GdkNativeWindow window_id) */
void gtkperl_socket_add_id(SV* socket, int window_id)
{
    gtk_socket_add_id(SvGtkSocket(socket), window_id);
}

/* GdkNativeWindow gtk_socket_get_id (GtkSocket *socket) */
int gtkperl_socket_get_id(SV* socket)
{
    return gtk_socket_get_id(SvGtkSocket(socket));
}

/* void gtk_socket_steal (GtkSocket *socket, GdkNativeWindow wid) */
void gtkperl_socket_steal(SV* socket, int wid)
{
    gtk_socket_steal(SvGtkSocket(socket), wid);
}


/** methods to access internal stuff **/

int gtkperl_socket_request_width(SV* socket)
{
    return SvGtkSocket(socket)->request_width;
}

int gtkperl_socket_request_height(SV* socket)
{
    return SvGtkSocket(socket)->request_height;
}

int gtkperl_socket_current_width(SV* socket)
{
    return SvGtkSocket(socket)->current_width;
}

int gtkperl_socket_current_height(SV* socket)
{
    return SvGtkSocket(socket)->current_height;
}

SV* gtkperl_socket_plug_window(SV* socket)
{
    return gtk2_perl_new_object_nullok(SvGtkSocket(socket)->plug_window);
}

SV* gtkperl_socket_plug_widget(SV* socket)
{
    return gtk2_perl_new_object_nullok(SvGtkSocket(socket)->plug_widget);
}

int gtkperl_socket_xembed_version(SV* socket)
{
    return SvGtkSocket(socket)->xembed_version;
}

int gtkperl_socket_same_app(SV* socket)
{
    return SvGtkSocket(socket)->same_app;
}

int gtkperl_socket_focus_in(SV* socket)
{
    return SvGtkSocket(socket)->focus_in;
}

int gtkperl_socket_have_size(SV* socket)
{
    return SvGtkSocket(socket)->have_size;
}

int gtkperl_socket_need_map(SV* socket)
{
    return SvGtkSocket(socket)->need_map;
}

int gtkperl_socket_is_mapped(SV* socket)
{
    return SvGtkSocket(socket)->is_mapped;
}

#if GTK_CHECK_VERSION(2,1,0)
int gtkperl_socket_active(SV* socket)
{
    return SvGtkSocket(socket)->active;
}
#endif

SV* gtkperl_socket_accel_group(SV* socket)
{
    return gtk2_perl_new_object_nullok(SvGtkSocket(socket)->accel_group);
}

SV* gtkperl_socket_toplevel(SV* socket)
{
    return gtk2_perl_new_object(SvGtkSocket(socket)->toplevel);
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
