/* $Id: Selection.c,v 1.1 2002/11/05 15:58:05 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl-gdk.h"


/* NOT IMPLEMENTED YET
gboolean   gdk_selection_owner_set (GdkWindow	 *owner,
				    GdkAtom	  selection,
				    guint32	  time,
				    gboolean      send_event);
*/

SV* gdkperl_selection_owner_get(char* class, char* selection)
{
    return gtk2_perl_new_object(gdk_selection_owner_get(gdk_atom_intern(selection, FALSE)));
}

/*
void	   gdk_selection_convert   (GdkWindow	 *requestor,
				    GdkAtom	  selection,
				    GdkAtom	  target,
				    guint32	  time);
gboolean   gdk_selection_property_get (GdkWindow  *requestor,
				       guchar	 **data,
				       GdkAtom	  *prop_type,
				       gint	  *prop_format);
void	   gdk_selection_send_notify (guint32	    requestor,
				      GdkAtom	    selection,
				      GdkAtom	    target,
				      GdkAtom	    property,
				      guint32	    time);

*/
