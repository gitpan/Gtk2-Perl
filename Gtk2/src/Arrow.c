/* $Id: Arrow.c,v 1.6 2003/01/16 21:24:03 joered Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_arrow__new(char* class, SV* arrow_type, SV* shadow_type)
{
    return gtk2_perl_new_object(gtk_arrow_new(SvGtkArrowType(arrow_type), SvGtkShadowType(shadow_type)));
}



