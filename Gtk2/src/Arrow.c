/* $Id: Arrow.c,v 1.5 2002/10/21 11:41:23 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_arrow_new(char* class, SV* arrow_type, SV* shadow_type)
{
    return gtk2_perl_new_object(gtk_arrow_new(SvGtkArrowType(arrow_type), SvGtkShadowType(shadow_type)));
}



