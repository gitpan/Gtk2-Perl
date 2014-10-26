/* $Id: SpinButton.c,v 1.5 2002/11/16 07:33:48 glade-perl Exp $
 * Copyright 2002, G�ran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_spin_button_new(char* class, SV* adj, double rate, int digits)
{
    return gtk2_perl_new_object(gtk_spin_button_new(SvGtkAdjustment(adj), rate, digits));
}


double gtkperl_spin_button_get_value(SV* spin_button)
{
    return gtk_spin_button_get_value(SvGtkSpinButton(spin_button));
}

int gtkperl_spin_button_get_value_as_int(SV* spin_button)
{
    return gtk_spin_button_get_value_as_int(SvGtkSpinButton(spin_button));
}

int gtkperl_spin_button_get_digits(SV* spin_button)
{
    return gtk_spin_button_get_digits(SvGtkSpinButton(spin_button));
}

void gtkperl_spin_button_set_digits(SV* spin_button, int digits)
{
    gtk_spin_button_set_digits(SvGtkSpinButton(spin_button), digits);
}

void gtkperl_spin_button_set_numeric(SV* spin_button, int numeric)
{
    gtk_spin_button_set_numeric(SvGtkSpinButton(spin_button), numeric);
}

void gtkperl_spin_button_set_wrap(SV* spin_button, int wrap)
{
    gtk_spin_button_set_wrap(SvGtkSpinButton(spin_button), wrap);
}

void gtkperl_spin_button_set_snap_to_ticks(SV* spin_button, int snap)
{
    gtk_spin_button_set_snap_to_ticks(SvGtkSpinButton(spin_button), snap);
}

void gtkperl_spin_button_set_update_policy(SV* spin_button, SV* policy)
{
    gtk_spin_button_set_update_policy(SvGtkSpinButton(spin_button), SvGtkSpinButtonUpdatePolicy(policy));
}


/*
void        gtk_spin_button_configure       (GtkSpinButton *spin_button,
                                             GtkAdjustment *adjustment,
                                             gdouble climb_rate,
                                             guint digits);
GtkWidget*  gtk_spin_button_new_with_range  (gdouble min,
                                             gdouble max,
                                             gdouble step);
void        gtk_spin_button_set_adjustment  (GtkSpinButton *spin_button,
                                             GtkAdjustment *adjustment);
GtkAdjustment* gtk_spin_button_get_adjustment
                                            (GtkSpinButton *spin_button);
void        gtk_spin_button_set_increments  (GtkSpinButton *spin_button,
                                             gdouble step,
                                             gdouble page);
void        gtk_spin_button_set_range       (GtkSpinButton *spin_button,
                                             gdouble min,
                                             gdouble max);
#define     gtk_spin_button_get_value_as_float
void        gtk_spin_button_set_value       (GtkSpinButton *spin_button,
                                             gdouble value);
void        gtk_spin_button_spin            (GtkSpinButton *spin_button,
                                             GtkSpinType direction,
                                             gdouble increment);
void        gtk_spin_button_update          (GtkSpinButton *spin_button);
void        gtk_spin_button_get_increments  (GtkSpinButton *spin_button,
                                             gdouble *step,
                                             gdouble *page);
gboolean    gtk_spin_button_get_numeric     (GtkSpinButton *spin_button);
void        gtk_spin_button_get_range       (GtkSpinButton *spin_button,
                                             gdouble *min,
                                             gdouble *max);
gboolean    gtk_spin_button_get_snap_to_ticks
                                            (GtkSpinButton *spin_button);
GtkSpinButtonUpdatePolicy gtk_spin_button_get_update_policy
                                            (GtkSpinButton *spin_button);
gboolean    gtk_spin_button_get_wrap        (GtkSpinButton *spin_button);

*/
