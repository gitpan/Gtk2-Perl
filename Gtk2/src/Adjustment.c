/* $Id: Adjustment.c,v 1.4 2002/10/20 15:53:32 ggc Exp $
 * Copyright 2002, G�ran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_adjustment_new(char* class, double value, double lower, double upper,
			   double step_increment, double page_increment, double page_size)
{
    return gtk2_perl_new_object(gtk_adjustment_new(value, lower, upper,
						   step_increment, page_increment, page_size));
}

double gtkperl_adjustment_get_value(SV* adjustment)
{
    return gtk_adjustment_get_value(SvGtkAdjustment(adjustment));
}

void gtkperl_adjustment_set_value(SV *adjustment, double value)
{
    gtk_adjustment_set_value(SvGtkAdjustment(adjustment), value);
}

double gtkperl_adjustment_get_lower(SV *adjustment)
{
    return SvGtkAdjustment(adjustment)->lower;
}

void gtkperl_adjustment_set_lower(SV *adjustment, double value)
{
    SvGtkAdjustment(adjustment)->lower = value;
}

double gtkperl_adjustment_get_upper(SV *adjustment)
{
    return SvGtkAdjustment(adjustment)->upper;
}

void gtkperl_adjustment_set_upper(SV *adjustment, double value)
{
    SvGtkAdjustment(adjustment)->upper = value;
}

double gtkperl_adjustment_get_step_increment(SV *adjustment)
{
    return SvGtkAdjustment(adjustment)->step_increment;
}

void gtkperl_adjustment_set_step_increment(SV *adjustment, double value)
{
    SvGtkAdjustment(adjustment)->step_increment = value;
}

double gtkperl_adjustment_get_page_increment(SV *adjustment)
{
    return SvGtkAdjustment(adjustment)->page_increment;
}

void gtkperl_adjustment_set_page_increment(SV *adjustment, double value)
{
    SvGtkAdjustment(adjustment)->page_increment = value;
}

double gtkperl_adjustment_get_page_size(SV *adjustment)
{
    return SvGtkAdjustment(adjustment)->page_size;
}

void gtkperl_adjustment_set_page_size(SV *adjustment, double value)
{
    SvGtkAdjustment(adjustment)->page_size = value;
}


