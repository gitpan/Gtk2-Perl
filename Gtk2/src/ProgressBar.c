/* $Id: ProgressBar.c,v 1.8 2002/11/16 07:33:48 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

/* ALL DONE */

SV* gtkperl_progress_bar_new(char* class)
{
    return gtk2_perl_new_object(gtk_progress_bar_new());
}
void gtkperl_progress_bar_pulse(SV* pbar)
{
    gtk_progress_bar_pulse(SvGtkProgressBar(pbar));
}

gchar* gtkperl_progress_bar_get_text(SV* pbar)
{
    return gtk_progress_bar_get_text(SvGtkProgressBar(pbar));
}

void gtkperl_progress_bar_set_text(SV* pbar, gchar* text)
{
    gtk_progress_bar_set_text(SvGtkProgressBar(pbar), text);
}

double gtkperl_progress_bar_get_fraction(SV *pbar)
{
    return gtk_progress_bar_get_fraction(SvGtkProgressBar(pbar));
}

void gtkperl_progress_bar_set_fraction(SV *pbar, double fraction)
{
    gtk_progress_bar_set_fraction(SvGtkProgressBar(pbar), fraction);
}

double gtkperl_progress_bar_get_pulse_step(SV *pbar)
{
    return gtk_progress_bar_get_pulse_step(SvGtkProgressBar(pbar));
}

void gtkperl_progress_bar_set_pulse_step(SV *pbar, double fraction)
{
    gtk_progress_bar_set_pulse_step(SvGtkProgressBar(pbar), fraction);
}

SV* gtkperl_progress_bar_get_orientation(SV *pbar)
{
    return newSVGtkProgressBarOrientation(gtk_progress_bar_get_orientation(SvGtkProgressBar(pbar)));
}

void gtkperl_progress_bar_set_orientation(SV *pbar, SV* ori)
{
    return gtk_progress_bar_set_orientation(SvGtkProgressBar(pbar), SvGtkProgressBarOrientation(ori));
}

