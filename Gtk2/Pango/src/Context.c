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
 * $Id: Context.c,v 1.4 2003/01/03 15:30:05 ggc Exp $
 */

#include "gtk2-perl-pango.h"

SV* pangoperl_context_get_metrics(SV* context, SV* desc, SV* language)
{
    return gtk2_perl_new_object_from_pointer(pango_context_get_metrics(SvPangoContext(context),
								       SvPangoFontDescription(desc),
								       SvPangoLanguage_nullok(language)),
					     "Gtk2::Pango::FontMetrics");
}

void pangoperl_context_set_font_description(SV* context, SV* desc)
{
    pango_context_set_font_description(SvPangoContext(context), SvPangoFontDescription(desc));
}

SV* pangoperl_context_get_font_description(SV* context)
{
    return gtk2_perl_new_object_from_pointer(pango_context_get_font_description(SvPangoContext(context)),
					     "Gtk2::Pango::FontDescription");
}

SV* pangoperl_context_get_language(SV* context)
{
    return gtk2_perl_new_object_from_pointer(pango_context_get_language(SvPangoContext(context)),
					     "Gtk2::Pango::Language");
}

void pangoperl_context_set_language(SV* context, SV* language)
{
    pango_context_set_language(SvPangoContext(context), SvPangoLanguage(language));
}

void pangoperl_context_set_base_dir(SV* context, SV* direction)
{
    pango_context_set_base_dir(SvPangoContext(context), SvPangoDirection(direction));
}

SV* pangoperl_context_get_base_dir(SV* context)
{
    return newSVPangoDirection(pango_context_get_base_dir(SvPangoContext(context)));
}
