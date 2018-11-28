Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr680061.outbound.protection.outlook.com ([40.107.68.61]:18880
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728754AbeK2CSi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:38 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 17/17] kernel-shark-qt: Add the user filter mask to the Json
 config I/O
Date: Wed, 28 Nov 2018 15:16:29 +0000
Message-ID: <20181128151530.21965-18-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch updates the Json config I/O, making possible to
import/export the value of the user filter mask. When the filters
are imported, the states of the "Apply filters to Graph" and
"Apply filters to List" check-boxes are updated accordingly.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp     | 35 ++++++---
 kernel-shark-qt/src/KsMainWindow.hpp     |  6 ++
 kernel-shark-qt/src/libkshark-configio.c | 99 ++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h          | 11 +++
 4 files changed, 142 insertions(+), 9 deletions(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index 16ba8bb..7213c01 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -50,7 +50,9 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _importFilterAction("Import Filter", this),
   _exportFilterAction("Export Filter", this),
   _graphFilterSyncAction(this),
+  _graphFilterSyncCBox(nullptr),
   _listFilterSyncAction(this),
+  _listFilterSyncCBox(nullptr),
   _showEventsAction("Show events", this),
   _showTasksAction("Show tasks", this),
   _hideTasksAction("Hide tasks", this),
@@ -273,7 +275,6 @@ void KsMainWindow::_createMenus()
 {
 	QMenu *file, *sessions, *filter, *plots, *tools, *help;
 	kshark_context *kshark_ctx(nullptr);
-	QCheckBox *cbf2g, *cbf2l;
=20
 	if (!kshark_instance(&kshark_ctx))
 		return;
@@ -316,17 +317,17 @@ void KsMainWindow::_createMenus()
=20
 	kshark_ctx->filter_mask |=3D KS_EVENT_VIEW_FILTER_MASK;
=20
-	cbf2g =3D lamMakeCBAction(&_graphFilterSyncAction,
-				"Apply filters to Graph");
+	_graphFilterSyncCBox =3D lamMakeCBAction(&_graphFilterSyncAction,
+					       "Apply filters to Graph");
=20
-	connect(cbf2g,	&QCheckBox::stateChanged,
-		this,	&KsMainWindow::_graphFilterSync);
+	connect(_graphFilterSyncCBox,	&QCheckBox::stateChanged,
+		this,			&KsMainWindow::_graphFilterSync);
=20
-	cbf2l =3D lamMakeCBAction(&_listFilterSyncAction,
-				"Apply filters to List");
+	_listFilterSyncCBox =3D lamMakeCBAction(&_listFilterSyncAction,
+					      "Apply filters to List");
=20
-	connect(cbf2l,	&QCheckBox::stateChanged,
-		this,	&KsMainWindow::_listFilterSync);
+	connect(_listFilterSyncCBox,	&QCheckBox::stateChanged,
+		this,			&KsMainWindow::_listFilterSync);
=20
 	filter->addAction(&_graphFilterSyncAction);
 	filter->addAction(&_listFilterSyncAction);
@@ -431,6 +432,20 @@ void KsMainWindow::_exportSession()
 	_session.exportToFile(fileName);
 }
=20
+void KsMainWindow::_filterSyncCBoxUpdate(kshark_context *kshark_ctx)
+{
+	if (kshark_ctx->filter_mask & KS_TEXT_VIEW_FILTER_MASK)
+		_listFilterSyncCBox->setChecked(true);
+	else
+		_listFilterSyncCBox->setChecked(false);
+
+	if (kshark_ctx->filter_mask &
+	    (KS_GRAPH_VIEW_FILTER_MASK | KS_EVENT_VIEW_FILTER_MASK))
+		_graphFilterSyncCBox->setChecked(true);
+	else
+		_graphFilterSyncCBox->setChecked(false);
+}
+
 void KsMainWindow::_importFilter()
 {
 	kshark_context *kshark_ctx(nullptr);
@@ -455,6 +470,7 @@ void KsMainWindow::_importFilter()
 	kshark_free_config_doc(conf);
=20
 	kshark_filter_entries(kshark_ctx, _data.rows(), _data.size());
+	_filterSyncCBoxUpdate(kshark_ctx);
 	emit _data.updateWidgets(&_data);
 }
=20
@@ -960,6 +976,7 @@ void KsMainWindow::loadSession(const QString &fileName)
 	pb.setValue(20);
=20
 	_session.loadFilters(kshark_ctx, &_data);
+	_filterSyncCBoxUpdate(kshark_ctx);
 	pb.setValue(130);
=20
 	_session.loadSplitterSize(&_splitter);
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsM=
ainWindow.hpp
index b231b52..72f7059 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -112,8 +112,12 @@ private:
=20
 	QWidgetAction	_graphFilterSyncAction;
=20
+	QCheckBox	*_graphFilterSyncCBox;
+
 	QWidgetAction	_listFilterSyncAction;
=20
+	QCheckBox	*_listFilterSyncCBox;
+
 	QAction		_showEventsAction;
=20
 	QAction		_showTasksAction;
@@ -218,6 +222,8 @@ private:
=20
 	void _deselect();
=20
+	void _filterSyncCBoxUpdate(kshark_context *kshark_ctx);
+
 private slots:
 	void _captureFinished(int, QProcess::ExitStatus);
 };
diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src=
/libkshark-configio.c
index a426e48..4fe7de3 100644
--- a/kernel-shark-qt/src/libkshark-configio.c
+++ b/kernel-shark-qt/src/libkshark-configio.c
@@ -1201,6 +1201,103 @@ bool kshark_import_adv_filters(struct kshark_contex=
t *kshark_ctx,
 	}
 }
=20
+static bool kshark_user_mask_to_json(struct kshark_context *kshark_ctx,
+				     struct json_object *jobj)
+{
+	uint8_t mask =3D kshark_ctx->filter_mask;
+	json_object *jmask;
+
+	jmask =3D json_object_new_int((int) mask);
+	if (!jmask)
+		return false;
+
+	/* Add the mask to the filter config document. */
+	json_object_object_add(jobj, KS_USER_FILTER_MASK_NAME, jmask);
+	return true;
+}
+
+/**
+ * @brief Record the current value of the the user-specified filter mask i=
nto
+ *	  a Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Current=
ly
+ *		only Json format is supported. If NULL, a new Adv. Filter
+ *		Configuration document will be created.
+ *
+ * @returns True on success, otherwise False.
+ */
+bool kshark_export_user_mask(struct kshark_context *kshark_ctx,
+			     struct kshark_config_doc **conf)
+{
+	if (!*conf)
+		*conf =3D kshark_filter_config_new(KS_CONFIG_JSON);
+
+	if (!*conf)
+		return false;
+
+	switch ((*conf)->format) {
+	case KS_CONFIG_JSON:
+		return kshark_user_mask_to_json(kshark_ctx,
+						(*conf)->conf_doc);
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			(*conf)->format);
+		return false;
+	}
+}
+
+static bool kshark_user_mask_from_json(struct kshark_context *kshark_ctx,
+				       struct json_object *jobj)
+{
+	json_object *jmask;
+	uint8_t mask;
+
+	if (!kshark_json_type_check(jobj, "kshark.config.filter"))
+		return false;
+	/*
+	 * Use the name of the filter to find the value of the filter maks.
+	 * Notice that the filter config document may contain no data for
+	 * the mask.
+	 */
+	if (!json_object_object_get_ex(jobj, KS_USER_FILTER_MASK_NAME,
+				       &jmask))
+		return false;
+
+	mask =3D json_object_get_int(jmask);
+	kshark_ctx->filter_mask =3D mask;
+
+	return true;
+}
+
+/**
+ * @brief Load from Configuration document the value of the user-specified
+ *	  filter mask.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Current=
ly
+ *		only Json format is supported.
+ *
+ * @returns True, if a mask has been loaded. If the filter configuration
+ *	    document contains no data for the mask or in a case of an error,
+ *	    the function returns False.
+ */
+bool kshark_import_user_mask(struct kshark_context *kshark_ctx,
+			     struct kshark_config_doc *conf)
+{
+	switch (conf->format) {
+	case KS_CONFIG_JSON:
+		return kshark_user_mask_from_json(kshark_ctx,
+						  conf->conf_doc);
+
+	default:
+		fprintf(stderr, "Document format %d not supported\n",
+			conf->format);
+		return false;
+	}
+}
+
 static bool filter_is_set(struct tracecmd_filter_id *filter)
 {
 	return filter && filter->count;
@@ -1430,6 +1527,7 @@ kshark_export_all_filters(struct kshark_context *ksha=
rk_ctx,
 	    !kshark_export_all_event_filters(kshark_ctx, &conf) ||
 	    !kshark_export_all_task_filters(kshark_ctx, &conf) ||
 	    !kshark_export_all_cpu_filters(kshark_ctx, &conf) ||
+	    !kshark_export_user_mask(kshark_ctx, &conf) ||
 	    !kshark_export_adv_filters(kshark_ctx, &conf)) {
 		kshark_free_config_doc(conf);
 		return NULL;
@@ -1456,6 +1554,7 @@ bool kshark_import_all_filters(struct kshark_context =
*kshark_ctx,
 	ret =3D kshark_import_all_task_filters(kshark_ctx, conf);
 	ret |=3D kshark_import_all_cpu_filters(kshark_ctx, conf);
 	ret |=3D kshark_import_all_event_filters(kshark_ctx, conf);
+	ret |=3D kshark_import_user_mask(kshark_ctx, conf);
 	ret |=3D kshark_import_adv_filters(kshark_ctx, conf);
=20
 	return ret;
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index 6a3eba6..b3bd646 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -504,6 +504,11 @@ enum kshark_config_formats {
  */
 #define KS_ADV_EVENT_FILTER_NAME	"adv event filter"
=20
+/**
+ * Field name for the Configuration document describing user-specified fil=
ter
+ * mask.
+ */
+#define KS_USER_FILTER_MASK_NAME	"filter mask"
 /**
  * Field name for the Configuration document describing the state of the V=
is.
  * model.
@@ -575,6 +580,12 @@ bool kshark_import_event_filter(struct tep_handle *pev=
ent,
 				const char *filter_name,
 				struct kshark_config_doc *conf);
=20
+bool kshark_export_user_mask(struct kshark_context *kshark_ctx,
+			     struct kshark_config_doc **conf);
+
+bool kshark_import_user_mask(struct kshark_context *kshark_ctx,
+			     struct kshark_config_doc *conf);
+
 bool kshark_export_filter_array(struct tracecmd_filter_id *filter,
 				const char *filter_name,
 				struct kshark_config_doc *conf);
--=20
2.17.1
