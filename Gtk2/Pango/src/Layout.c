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
 * $Id: Layout.c,v 1.3 2002/11/14 21:31:56 gthyni Exp $
 */

#include "gtk2-perl-pango.h"

SV* pangoperl_layout_get_context(SV* layout)
{
    return gtk2_perl_new_object_from_pointer(pango_layout_get_context(SvPangoLayout(layout)),
					     "Gtk2::Pango::Context");
}

void pangoperl_layout_set_text(SV* layout, char* text, int length)
{
    pango_layout_set_text(SvPangoLayout(layout), text, length);
}

SV* pangoperl_layout_get_text(SV* layout)
{
    return newSVpv(pango_layout_get_text(SvPangoLayout(layout)), 0);
}

void pangoperl_layout_set_font_description(SV* layout, SV* desc)
{
    pango_layout_set_font_description(SvPangoLayout(layout), SvPangoFontDescription(desc));
}

void pangoperl_layout_set_width(SV* layout, int width)
{
    pango_layout_set_width(SvPangoLayout(layout), width);
}

int pangoperl_layout_get_width(SV* layout)
{
    return pango_layout_get_width(SvPangoLayout(layout));
}

void pangoperl_layout_set_wrap(SV* layout, SV* wrap)
{
    pango_layout_set_wrap(SvPangoLayout(layout), SvPangoWrapMode(wrap));
}

SV* pangoperl_layout_get_wrap(SV* layout)
{
    return newSVPangoWrapMode(pango_layout_get_wrap(SvPangoLayout(layout)));
}

void pangoperl_layout_set_indent(SV* layout, int indent)
{
    pango_layout_set_indent(SvPangoLayout(layout), indent);
}

int pangoperl_layout_get_indent(SV* layout)
{
    return pango_layout_get_indent(SvPangoLayout(layout));
}

int pangoperl_layout_get_spacing(SV* layout)
{
    return pango_layout_get_spacing(SvPangoLayout(layout));
}

void pangoperl_layout_set_spacing(SV* layout, int spacing)
{
    pango_layout_set_spacing(SvPangoLayout(layout), spacing);
}

void pangoperl_layout_set_justify(SV* layout, int justify)
{
    pango_layout_set_justify(SvPangoLayout(layout), justify);
}

int pangoperl_layout_get_justify(SV* layout)
{
    return pango_layout_get_justify(SvPangoLayout(layout));
}

void pangoperl_layout_set_alignment(SV* layout, SV* alignment)
{
    pango_layout_set_alignment(SvPangoLayout(layout), SvPangoAlignment(alignment));
}

SV* pangoperl_layout_get_alignment(SV* layout)
{
    return newSVPangoAlignment(pango_layout_get_alignment(SvPangoLayout(layout)));
}

void pangoperl_layout_set_single_paragraph_mode(SV* layout, int setting)
{
    pango_layout_set_single_paragraph_mode(SvPangoLayout(layout), setting);
}

int pangoperl_layout_get_single_paragraph_mode(SV* layout)
{
    return pango_layout_get_single_paragraph_mode(SvPangoLayout(layout));
}

SV* pangoperl_layout__get_size(SV* layout)
{
    int w, h;
    AV* size = newAV();
    pango_layout_get_size(SvPangoLayout(layout), &w, &h);
    av_push(size, newSViv(w));
    av_push(size, newSViv(h));
    return newRV_noinc((SV*) size);
}

SV* pangoperl_layout__get_pixel_size(SV* layout)
{
    int w, h;
    AV* size = newAV();
    pango_layout_get_pixel_size(SvPangoLayout(layout), &w, &h);
    av_push(size, newSViv(w));
    av_push(size, newSViv(h));
    return newRV_noinc((SV*) size);
}

int pangoperl_layout_get_line_count(SV* layout)
{
    return pango_layout_get_line_count(SvPangoLayout(layout));
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
