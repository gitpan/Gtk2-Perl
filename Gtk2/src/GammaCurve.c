/* $Id: GammaCurve.c,v 1.1 2002/11/04 19:13:01 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_gamma_curve_new(char* class)
{
    return gtk2_perl_new_object(gtk_gamma_curve_new());
}

/*
SV* gtkperl_gamma_curve_curve(SV* gamma_curve)
{
    return gtk2_perl_new_object(gamma_curve->curve);
}
*/
