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
 * $Id: _Boxed.c,v 1.2 2002/11/13 15:55:36 ggc Exp $
 */

#include "gtk2-perl.h"

void gtkperl__boxed_free(SV* perl_obj)
{
    SV* obj;
    gpointer obj_p = (gpointer) SvIV(SvRV(perl_obj));
    if (!obj_p) {
	fprintf(stderr, "WARNING: double free attempted on %s\n", SvPV_nolen(perl_obj));
	return;
    }

    g_free(obj_p);

    obj = SvRV(perl_obj);
    SvREADONLY_off(obj);
    sv_setiv(obj, (IV) 0);
    SvREADONLY_on(obj);
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
