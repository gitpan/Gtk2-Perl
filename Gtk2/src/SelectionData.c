/* $Id: SelectionData.c,v 1.5 2002/11/05 20:20:59 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"
#include "gtk2-perl-gdk.h"

/* this is the struct
struct _GtkSelectionData
{
  GdkAtom selection;
  GdkAtom target;
  GdkAtom type;
  gint    format;
  guchar *data;
  gint    length;
};
*/

char* gtkperl_selection_data_type(SV* sdata)
{
    return gdk_atom_name(SvGtkSelectionData(sdata)->type);
}

SV* gtkperl_selection_data_data_atom(SV* sdata, int index)
{
    GtkSelectionData* data = SvGtkSelectionData(sdata);
    GdkAtom* atom = (GdkAtom*) data->data;
    if (index * sizeof(GdkAtom) < data->length)	{
	return gdkperl_atom_new(atom[index]);
    }
    return &PL_sv_undef;
}

int gtkperl_selection_data_length(SV* sdata)
{
    return SvGtkSelectionData(sdata)->length;
}



