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
 * $Id: Segment.c,v 1.2 2002/11/09 16:53:11 ggc Exp $
 */

#include "gtk2-perl-gdk.h"

SV* gdkperl_segment_new(char* class, int x1, int y1, int x2, int y2)
{
    GdkSegment* segment = g_malloc0(sizeof(GdkSegment));
    segment->x1 = x1;
    segment->y1 = y1;
    segment->x2 = x2;
    segment->y2 = y2;
    return gtk2_perl_new_object_from_pointer(segment, class);
}

SV* gdkperl_segment__values(SV* segment)
{
    AV* values = newAV();
    av_push(values, newSViv(SvGdkSegment(segment)->x1));
    av_push(values, newSViv(SvGdkSegment(segment)->y1));
    av_push(values, newSViv(SvGdkSegment(segment)->x2));
    av_push(values, newSViv(SvGdkSegment(segment)->y2));
    return newRV_noinc((SV*) values);
}

int gdkperl_segment_x1(SV* segment)
{
    return SvGdkSegment(segment)->x1;
}

int gdkperl_segment_y1(SV* segment)
{
    return SvGdkSegment(segment)->y1;
}

int gdkperl_segment_x2(SV* segment)
{
    return SvGdkSegment(segment)->x2;
}

int gdkperl_segment_y2(SV* segment)
{
    return SvGdkSegment(segment)->y2;
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
