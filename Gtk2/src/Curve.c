/* $Id: Curve.c,v 1.1 2002/11/04 19:13:00 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_curve_new(char* class)
{
    return gtk2_perl_new_object(gtk_curve_new());
}

void gtkperl_curve_set_gamma(SV* curve, float gamma)
{
    gtk_curve_set_gamma(SvGtkCurve(curve), gamma);
}

void gtkperl_curve_set_range(SV* curve, 
    double min_x, double max_x, double min_y, double max_y)
{
    gtk_curve_set_range(SvGtkCurve(curve), min_x, max_x, min_y, max_y);
}

void gtkperl_curve_set_curve_type(SV* curve, SV* type)
{
    gtk_curve_set_curve_type(SvGtkCurve(curve), SvGtkCurveType(type));
}


/*
Widget*  gtk_curve_new                   (void);
  void        gtk_curve_reset                 (GtkCurve *curve);
  void        gtk_curve_set_range             (GtkCurve *curve,
                                               gfloat min_x,
                                               gfloat max_x,
                                               gfloat min_y,
                                               gfloat max_y);
  void        gtk_curve_get_vector            (GtkCurve *curve,
                                               int veclen,
                                               gfloat vector[]);
  void        gtk_curve_set_vector            (GtkCurve *curve,
                                               int veclen,
                                               gfloat vector[]);
*/
