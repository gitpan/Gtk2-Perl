/* $Id: Calendar.c,v 1.7 2002/11/04 19:13:02 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_calendar_new(char* class)
{
    return gtk2_perl_new_object(gtk_calendar_new());
}

int gtkperl_calendar_mark_day(SV* calendar, int day)
{
    return gtk_calendar_mark_day(SvGtkCalendar(calendar), day);
}

int gtkperl_calendar_unmark_day(SV* calendar, int day)
{
    return gtk_calendar_unmark_day(SvGtkCalendar(calendar), day);
}

void gtkperl_calendar_clear_marks(SV* calendar)
{
    gtk_calendar_clear_marks(SvGtkCalendar(calendar));
}

void gtkperl_calendar_display_options(SV* calendar, int flags)
{
    gtk_calendar_display_options(SvGtkCalendar(calendar), flags);
}

SV* gtkperl_calendar__get_date(SV* calendar)
{
    guint year, month, day;
    AV* av;
    gtk_calendar_get_date(SvGtkCalendar(calendar), &year, &month, &day);
    av = newAV();
    av_push(av, newSViv(year));
    av_push(av, newSViv(month));
    av_push(av, newSViv(day));
    return newRV_noinc((SV*) av);
}

void gtkperl_calendar_select_day(SV* calendar, int day)
{
    return gtk_calendar_select_day(SvGtkCalendar(calendar), day);
}

int gtkperl_calendar_select_month(SV* calendar, int month, int year)
{
    return gtk_calendar_select_month(SvGtkCalendar(calendar), month, year);
}

void gtkperl_calendar_freeze(SV* calendar)
{
    return gtk_calendar_freeze(SvGtkCalendar(calendar));
}

void gtkperl_calendar_thaw(SV* calendar)
{
    return gtk_calendar_thaw(SvGtkCalendar(calendar));
}

