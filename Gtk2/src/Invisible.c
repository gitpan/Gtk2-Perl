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
 * $Id: Invisible.c,v 1.1 2002/11/03 22:32:27 gthyni Exp $
 */

#include "gtk2-perl.h"

SV* gtkperl_invisible_new(char* class)
{
    return gtk2_perl_new_object_from_pointer(gtk_invisible_new(), class);
}

/* NOT IMPLEMENTED YET
GtkWidget*  gtk_invisible_new_for_screen    (GdkScreen *screen);
void        gtk_invisible_set_screen        (GtkInvisible *invisible, GdkScreen *screen);
GdkScreen*  gtk_invisible_get_screen        (GtkInvisible *invisible);
*/

