/* $Id: Object.c,v 1.1 2002/11/11 19:56:59 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */



/* NOT IMPLEMENTED YET
struct      AtkObject;
enum        AtkRole;
AtkRole     atk_role_register               (const gchar *name);
enum        AtkLayer;
struct      AtkImplementor;
struct      AtkPropertyValues;
gboolean    (*AtkFunction)                  (gpointer data);
void        (*AtkPropertyChangeHandler)     (AtkObject*,
                                             AtkPropertyValues*);
AtkObject*  atk_implementor_ref_accessible  (AtkImplementor *implementor);
G_CONST_RETURN gchar* atk_object_get_name   (AtkObject *accessible);
G_CONST_RETURN gchar* atk_object_get_description
                                            (AtkObject *accessible);
AtkObject*  atk_object_get_parent           (AtkObject *accessible);
gint        atk_object_get_n_accessible_children
                                            (AtkObject *accessible);
AtkObject*  atk_object_ref_accessible_child (AtkObject *accessible,
                                             gint i);
AtkRelationSet* atk_object_ref_relation_set (AtkObject *accessible);
AtkLayer    atk_object_get_layer            (AtkObject *accessible);
gint        atk_object_get_mdi_zorder       (AtkObject *accessible);
AtkRole     atk_object_get_role             (AtkObject *accessible);
AtkStateSet* atk_object_ref_state_set       (AtkObject *accessible);
gint        atk_object_get_index_in_parent  (AtkObject *accessible);
void        atk_object_set_name             (AtkObject *accessible,
                                             const gchar *name);
void        atk_object_set_description      (AtkObject *accessible,
                                             const gchar *description);
void        atk_object_set_parent           (AtkObject *accessible,
                                             AtkObject *parent);
void        atk_object_set_role             (AtkObject *accessible,
                                             AtkRole role);
guint       atk_object_connect_property_change_handler
                                            (AtkObject *accessible,
                                             AtkPropertyChangeHandler *handler);
void        atk_object_remove_property_change_handler
                                            (AtkObject *accessible,
                                             guint handler_id);
void        atk_object_notify_state_change  (AtkObject *accessible,
                                             AtkState state,
                                             gboolean value);
void        atk_object_initialize           (AtkObject *accessible,
                                             gpointer data);
G_CONST_RETURN gchar* atk_role_get_name     (AtkRole role);
AtkRole     atk_role_for_name               (const gchar *name);

*/
