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
 * $Id: Point.c,v 1.1 2002/11/08 18:02:50 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_point_new(char* class, int x, int y)
{
    GdkPoint* point = g_malloc0(sizeof(GdkPoint));
    point->x = x;
    point->y = y;
    return gtk2_perl_new_object_from_pointer(point, class);
}

SV* gdkperl_point__values(SV* point)
{
    AV* values = newAV();
    av_push(values, newSViv(SvGdkPoint(point)->x));
    av_push(values, newSViv(SvGdkPoint(point)->y));
    return newRV_noinc((SV*) values);
}

int gdkperl_point_x(SV* point)
{
    return SvGdkPoint(point)->x;
}

int gdkperl_point_y(SV* point)
{
    return SvGdkPoint(point)->y;
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
