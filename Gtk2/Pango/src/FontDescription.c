/* $Id: FontDescription.c,v 1.5 2002/11/13 11:38:01 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-pango.h"

SV* pangoperl_font_description_from_string(char* class, char* str)
{
    return gtk2_perl_new_object_from_pointer(pango_font_description_from_string(str),
					     "Gtk2::Pango::FontDescription");
}
