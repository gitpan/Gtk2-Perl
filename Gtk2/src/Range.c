/* $Id: Range.c,v 1.6 2002/11/06 05:01:08 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


void gtkperl_range_set_update_policy(SV *range, SV* policy)
{
    gtk_range_set_update_policy(SvGtkRange(range), SvGtkUpdateType(policy));
}

void gtkperl_range_set_inverted(SV *range, int setting)
{
    gtk_range_set_inverted(SvGtkRange(range), setting);
}

int gtkperl_range_get_inverted(SV *range)
{
    return gtk_range_get_inverted(SvGtkRange(range));
}

/*
GtkAdjustment* gtk_range_get_adjustment     (GtkRange *range);
  void        gtk_range_set_adjustment        (GtkRange *range,
                                               GtkAdjustment *adjustment);
  GtkUpdateType gtk_range_get_update_policy   (GtkRange *range);
  gdouble     gtk_range_get_value             (GtkRange *range);
  void        gtk_range_set_increments        (GtkRange *range,
                                               gdouble step,
                                               gdouble page);
  void        gtk_range_set_range             (GtkRange *range,
                                               gdouble min,
                                               gdouble max);
  void        gtk_range_set_value             (GtkRange *range,
                                               gdouble value);

*/
