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
 * $Id: Requisition.c,v 1.1 2002/11/08 18:02:55 ggc Exp $
 */

#include "gtk2-perl.h"

SV* gtkperl_requisition_new(char* class, int width, int height)
{
    GtkRequisition* req = g_malloc0(sizeof(GtkRequisition));
    req->width = width;
    req->height = height;
    return gtk2_perl_new_object_from_pointer(req, class);
}

SV* gtkperl_requisition__values(SV* requisition)
{
    AV* values = newAV();
    av_push(values, newSViv(SvGtkRequisition(requisition)->width));
    av_push(values, newSViv(SvGtkRequisition(requisition)->height));
    return newRV_noinc((SV*) values);
}

int gtkperl_requisition_width(SV* requisition)
{
    return SvGtkRequisition(requisition)->width;
}

int gtkperl_requisition_height(SV* requisition)
{
    return SvGtkRequisition(requisition)->height;
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
