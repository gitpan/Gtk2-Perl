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
 * $Id: BoxChild.c,v 1.1 2002/11/28 13:55:28 ggc Exp $
 */

#include "gtk2-perl.h"

SV* gtkperl_box_child__values(SV* boxchild)
{
    AV* values = newAV();
    av_push(values, gtk2_perl_new_object_from_pointer_nullok(SvGtkBoxChild(boxchild)->widget, "Gtk2::Widget"));
    av_push(values, newSVuv(SvGtkBoxChild(boxchild)->padding));
    av_push(values, newSVuv(SvGtkBoxChild(boxchild)->expand));
    av_push(values, newSVuv(SvGtkBoxChild(boxchild)->fill));
    av_push(values, newSVGtkPackType(SvGtkBoxChild(boxchild)->pack));
    av_push(values, newSVuv(SvGtkBoxChild(boxchild)->is_secondary));
    return newRV_noinc((SV*) values);
}

SV* gtkperl_box_child_widget(SV* boxchild)
{
    return gtk2_perl_new_object_from_pointer_nullok(SvGtkBoxChild(boxchild)->widget, "Gtk2::Widget");
}

int gtkperl_box_child_padding(SV* boxchild)
{
    return SvGtkBoxChild(boxchild)->padding;
}

int gtkperl_box_child_expand(SV* boxchild)
{
    return SvGtkBoxChild(boxchild)->expand;
}

int gtkperl_box_child_fill(SV* boxchild)
{
    return SvGtkBoxChild(boxchild)->fill;
}

SV* gtkperl_box_child_pack(SV* boxchild)
{
    return newSVGtkPackType(SvGtkBoxChild(boxchild)->pack);
}

int gtkperl_box_child_is_secondary(SV* boxchild)
{
    return SvGtkBoxChild(boxchild)->is_secondary;
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
