/* $Id: Range.c,v 1.7 2003/02/11 11:42:44 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* void gtk_range_set_update_policy (GtkRange *range, GtkUpdateType policy) */
void gtkperl_range_set_update_policy(SV* range, SV* policy)
{
    gtk_range_set_update_policy(SvGtkRange(range), SvGtkUpdateType(policy));
}

/* GtkUpdateType gtk_range_get_update_policy (GtkRange *range) */
SV* gtkperl_range_get_update_policy(SV* range)
{
    return newSVGtkUpdateType(gtk_range_get_update_policy(SvGtkRange(range)));
}

/* void gtk_range_set_adjustment (GtkRange *range, GtkAdjustment *adjustment) */
void gtkperl_range_set_adjustment(SV* range, SV* adjustment)
{
    gtk_range_set_adjustment(SvGtkRange(range), SvGtkAdjustment(adjustment));
}

/* GtkAdjustment* gtk_range_get_adjustment (GtkRange *range) */
SV* gtkperl_range_get_adjustment(SV* range)
{
    return gtk2_perl_new_object(gtk_range_get_adjustment(SvGtkRange(range)));
}

/* void gtk_range_set_inverted (GtkRange *range, gboolean setting) */
void gtkperl_range_set_inverted(SV* range, int setting)
{
    gtk_range_set_inverted(SvGtkRange(range), setting);
}

/* gboolean gtk_range_get_inverted (GtkRange *range) */
int gtkperl_range_get_inverted(SV* range)
{
    return gtk_range_get_inverted(SvGtkRange(range));
}

/* void gtk_range_set_increments (GtkRange *range, gdouble step, gdouble page) */
void gtkperl_range_set_increments(SV* range, double step, double page)
{
    gtk_range_set_increments(SvGtkRange(range), step, page);
}

/* void gtk_range_set_range (GtkRange *range, gdouble min, gdouble max) */
void gtkperl_range_set_range(SV* range, double min, double max)
{
    gtk_range_set_range(SvGtkRange(range), min, max);
}

/* void gtk_range_set_value (GtkRange *range, gdouble value) */
void gtkperl_range_set_value(SV* range, double value)
{
    gtk_range_set_value(SvGtkRange(range), value);
}

/* gdouble gtk_range_get_value (GtkRange *range) */
double gtkperl_range_get_value(SV* range)
{
    return gtk_range_get_value(SvGtkRange(range));
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
