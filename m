Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:2944
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728413AbeK2CSi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:38 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 15/17] kernel-shark-qt: Add the CPU filters to the Json config
 I/O
Date: Wed, 28 Nov 2018 15:16:26 +0000
Message-ID: <20181128151530.21965-16-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds "Show CPU" and "Hide CPU" filters to the Json
config I/O, making possible to import/export those filters.
Saving/loading the CPU filters reuses some of the code used
so far by the Task filters. Because of this some functions
have been renamed.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark-configio.c | 133 +++++++++++++++++------
 kernel-shark-qt/src/libkshark.h          |  28 ++++-
 2 files changed, 123 insertions(+), 38 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src=
/libkshark-configio.c
index bf2a08b..a426e48 100644
--- a/kernel-shark-qt/src/libkshark-configio.c
+++ b/kernel-shark-qt/src/libkshark-configio.c
@@ -870,20 +870,20 @@ bool kshark_import_event_filter(struct tep_handle *pe=
vent,
 	}
 }
=20
-static bool kshark_task_filter_to_json(struct tracecmd_filter_id *filter,
-				       const char *filter_name,
-				       struct json_object *jobj)
+static bool kshark_filter_array_to_json(struct tracecmd_filter_id *filter,
+					const char *filter_name,
+					struct json_object *jobj)
 {
 	json_object *jfilter_data, *jpid =3D NULL;
 	int i, *ids;
=20
 	/*
-	 * If this Json document already contains a description of the model,
+	 * If this Json document already contains a description of the filter,
 	 * delete this description.
 	 */
 	json_del_if_exist(jobj, filter_name);
=20
-	/* Get the array of Ids to be fitered. */
+	/* Get the array of Ids to be filtered. */
 	ids =3D tracecmd_filter_ids(filter);
 	if (!ids)
 		return true;
@@ -918,7 +918,7 @@ static bool kshark_task_filter_to_json(struct tracecmd_=
filter_id *filter,
 }
=20
 /**
- * @brief Record the current configuration of a Task Id filter into a
+ * @brief Record the current configuration of a simple Id filter into a
  *	  Configuration document.
  *
  * @param filter: Input location for an Id filter.
@@ -928,14 +928,14 @@ static bool kshark_task_filter_to_json(struct tracecm=
d_filter_id *filter,
  *
  * @returns True on success, otherwise False.
  */
-bool kshark_export_task_filter(struct tracecmd_filter_id *filter,
-			       const char *filter_name,
-			       struct kshark_config_doc *conf)
+bool kshark_export_filter_array(struct tracecmd_filter_id *filter,
+				const char *filter_name,
+				struct kshark_config_doc *conf)
 {
 	switch (conf->format) {
 	case KS_CONFIG_JSON:
-		return kshark_task_filter_to_json(filter, filter_name,
-						  conf->conf_doc);
+		return kshark_filter_array_to_json(filter, filter_name,
+						   conf->conf_doc);
=20
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
@@ -944,9 +944,9 @@ bool kshark_export_task_filter(struct tracecmd_filter_i=
d *filter,
 	}
 }
=20
-static bool kshark_task_filter_from_json(struct tracecmd_filter_id *filter=
,
-					 const char *filter_name,
-					 struct json_object *jobj)
+static bool kshark_filter_array_from_json(struct tracecmd_filter_id *filte=
r,
+					  const char *filter_name,
+					  struct json_object *jobj)
 {
 	json_object *jfilter, *jpid;
 	int i, length;
@@ -981,7 +981,8 @@ static bool kshark_task_filter_from_json(struct tracecm=
d_filter_id *filter,
 }
=20
 /**
- * @brief Load from Configuration document the configuration of a Task Id =
filter.
+ * @brief Load from Configuration document the configuration of a simple
+ *	  Id filter.
  *
  * @param filter: Input location for an Id filter.
  * @param filter_name: The name of the filter as showing up in the Config.
@@ -993,14 +994,14 @@ static bool kshark_task_filter_from_json(struct trace=
cmd_filter_id *filter,
  *	    document contains no data for this particular filter or in a case
  *	    of an error, the function returns False.
  */
-bool kshark_import_task_filter(struct tracecmd_filter_id *filter,
-			       const char *filter_name,
-			       struct kshark_config_doc *conf)
+bool kshark_import_filter_array(struct tracecmd_filter_id *filter,
+				const char *filter_name,
+				struct kshark_config_doc *conf)
 {
 	switch (conf->format) {
 	case KS_CONFIG_JSON:
-		return kshark_task_filter_from_json(filter, filter_name,
-						    conf->conf_doc);
+		return kshark_filter_array_from_json(filter, filter_name,
+						     conf->conf_doc);
=20
 	default:
 		fprintf(stderr, "Document format %d not supported\n",
@@ -1269,14 +1270,52 @@ bool kshark_export_all_task_filters(struct kshark_c=
ontext *kshark_ctx,
=20
 	/* Save a filter only if it contains Id values. */
 	if (filter_is_set(kshark_ctx->show_task_filter))
-		ret &=3D kshark_export_task_filter(kshark_ctx->show_task_filter,
-						 KS_SHOW_TASK_FILTER_NAME,
-						 *conf);
+		ret &=3D kshark_export_filter_array(kshark_ctx->show_task_filter,
+						  KS_SHOW_TASK_FILTER_NAME,
+						  *conf);
=20
 	if (filter_is_set(kshark_ctx->hide_task_filter))
-		ret &=3D kshark_export_task_filter(kshark_ctx->hide_task_filter,
-						 KS_HIDE_TASK_FILTER_NAME,
-						 *conf);
+		ret &=3D kshark_export_filter_array(kshark_ctx->hide_task_filter,
+						  KS_HIDE_TASK_FILTER_NAME,
+						  *conf);
+
+	return ret;
+}
+
+
+/**
+ * @brief Record the current configuration of "show cpu" and "hide cpu"
+ *	  filters into a Configuration document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Current=
ly
+ *		only Json format is supported. If NULL, a new Filter
+ *		Configuration document will be created.
+ *
+ * @returns True, if a filter has been recorded. If both filters contain
+ *	    no Id values or in a case of an error, the function returns False.
+ */
+bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
+				   struct kshark_config_doc **conf)
+{
+	bool ret =3D true;
+
+	if (!*conf)
+		*conf =3D kshark_filter_config_new(KS_CONFIG_JSON);
+
+	if (!*conf)
+		return false;
+
+	/* Save a filter only if it contains Id values. */
+	if (filter_is_set(kshark_ctx->show_task_filter))
+		ret &=3D kshark_export_filter_array(kshark_ctx->show_cpu_filter,
+						  KS_SHOW_CPU_FILTER_NAME,
+						  *conf);
+
+	if (filter_is_set(kshark_ctx->hide_task_filter))
+		ret &=3D kshark_export_filter_array(kshark_ctx->hide_cpu_filter,
+						  KS_HIDE_CPU_FILTER_NAME,
+						  *conf);
=20
 	return ret;
 }
@@ -1328,13 +1367,41 @@ bool kshark_import_all_task_filters(struct kshark_c=
ontext *kshark_ctx,
 {
 	bool ret =3D false;
=20
-	ret |=3D kshark_import_task_filter(kshark_ctx->hide_task_filter,
-					 KS_HIDE_TASK_FILTER_NAME,
-					 conf);
+	ret |=3D kshark_import_filter_array(kshark_ctx->hide_task_filter,
+					  KS_HIDE_TASK_FILTER_NAME,
+					  conf);
+
+	ret |=3D kshark_import_filter_array(kshark_ctx->show_task_filter,
+					  KS_SHOW_TASK_FILTER_NAME,
+					  conf);
+
+	return ret;
+}
+
+/**
+ * @brief Load from Configuration document the configuration of "show cpu"
+ *	  and "hide cpu" filters.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param conf: Input location for the kshark_config_doc instance. Current=
ly
+ *		only Json format is supported.
+ *
+ * @returns True, if a filter has been loaded. If the filter configuration
+ *	    document contains no data for any cpu filter or in a case of an
+ *	    error, the function returns False.
+ */
+bool kshark_import_all_cpu_filters(struct kshark_context *kshark_ctx,
+				    struct kshark_config_doc *conf)
+{
+	bool ret =3D false;
+
+	ret |=3D kshark_import_filter_array(kshark_ctx->hide_cpu_filter,
+					  KS_HIDE_CPU_FILTER_NAME,
+					  conf);
=20
-	ret |=3D kshark_import_task_filter(kshark_ctx->show_task_filter,
-					 KS_SHOW_TASK_FILTER_NAME,
-					 conf);
+	ret |=3D kshark_import_filter_array(kshark_ctx->show_cpu_filter,
+					  KS_SHOW_CPU_FILTER_NAME,
+					  conf);
=20
 	return ret;
 }
@@ -1362,6 +1429,7 @@ kshark_export_all_filters(struct kshark_context *ksha=
rk_ctx,
 	if (!conf ||
 	    !kshark_export_all_event_filters(kshark_ctx, &conf) ||
 	    !kshark_export_all_task_filters(kshark_ctx, &conf) ||
+	    !kshark_export_all_cpu_filters(kshark_ctx, &conf) ||
 	    !kshark_export_adv_filters(kshark_ctx, &conf)) {
 		kshark_free_config_doc(conf);
 		return NULL;
@@ -1386,6 +1454,7 @@ bool kshark_import_all_filters(struct kshark_context =
*kshark_ctx,
 {
 	bool ret;
 	ret =3D kshark_import_all_task_filters(kshark_ctx, conf);
+	ret |=3D kshark_import_all_cpu_filters(kshark_ctx, conf);
 	ret |=3D kshark_import_all_event_filters(kshark_ctx, conf);
 	ret |=3D kshark_import_adv_filters(kshark_ctx, conf);
=20
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index eb8c261..6a3eba6 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -488,6 +488,16 @@ enum kshark_config_formats {
  */
 #define KS_SHOW_TASK_FILTER_NAME	"show task filter"
=20
+/**
+ * Field name for the Configuration document describing the Hide Task filt=
er.
+ */
+#define KS_HIDE_CPU_FILTER_NAME		"hide cpu filter"
+
+/**
+ * Field name for the Configuration document describing the Show Task filt=
er.
+ */
+#define KS_SHOW_CPU_FILTER_NAME		"show cpu filter"
+
 /**
  * Field name for the Configuration document describing the Advanced event
  * filter.
@@ -565,13 +575,13 @@ bool kshark_import_event_filter(struct tep_handle *pe=
vent,
 				const char *filter_name,
 				struct kshark_config_doc *conf);
=20
-bool kshark_export_task_filter(struct tracecmd_filter_id *filter,
-			       const char *filter_name,
-			       struct kshark_config_doc *conf);
+bool kshark_export_filter_array(struct tracecmd_filter_id *filter,
+				const char *filter_name,
+				struct kshark_config_doc *conf);
=20
-bool kshark_import_task_filter(struct tracecmd_filter_id *filter,
-			       const char *filter_name,
-			       struct kshark_config_doc *conf);
+bool kshark_import_filter_array(struct tracecmd_filter_id *filter,
+				const char *filter_name,
+				struct kshark_config_doc *conf);
=20
 bool kshark_export_all_event_filters(struct kshark_context *kshark_ctx,
 				     struct kshark_config_doc **conf);
@@ -579,6 +589,9 @@ bool kshark_export_all_event_filters(struct kshark_cont=
ext *kshark_ctx,
 bool kshark_export_all_task_filters(struct kshark_context *kshark_ctx,
 				    struct kshark_config_doc **conf);
=20
+bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
+				   struct kshark_config_doc **conf);
+
 struct kshark_config_doc *
 kshark_export_all_filters(struct kshark_context *kshark_ctx,
 			  enum kshark_config_formats format);
@@ -589,6 +602,9 @@ bool kshark_import_all_event_filters(struct kshark_cont=
ext *kshark_ctx,
 bool kshark_import_all_task_filters(struct kshark_context *kshark_ctx,
 				    struct kshark_config_doc *conf);
=20
+bool kshark_import_all_cpu_filters(struct kshark_context *kshark_ctx,
+				   struct kshark_config_doc *conf);
+
 bool kshark_import_all_filters(struct kshark_context *kshark_ctx,
 			       struct kshark_config_doc *conf);
=20
--=20
2.17.1
