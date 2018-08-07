Return-Path: <SRS0=pUA5=KW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44670 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbeHGSPm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Aug 2018 14:15:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16-v6so16244613wrt.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Aug 2018 09:00:42 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark-qt: Add Json I/O for filter configurations.
Date: Tue,  7 Aug 2018 19:00:13 +0300
Message-Id: <20180807160013.11537-2-y.karadz@gmail.com>
In-Reply-To: <20180807160013.11537-1-y.karadz@gmail.com>
References: <20180807160013.11537-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Add to the C API of KernelShark instruments for saving/loading of
filter configuration to/from Json files.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt   |   1 +
 kernel-shark-qt/src/libkshark-json.c | 601 +++++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h      |  49 +++
 3 files changed, 651 insertions(+)
 create mode 100644 kernel-shark-qt/src/libkshark-json.c

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index ea5dbda..b3de765 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -2,6 +2,7 @@ message("\n src ...")
 
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
+                          libkshark-json.c
                           libkshark-model.c
                           libkshark-collection.c)
 
diff --git a/kernel-shark-qt/src/libkshark-json.c b/kernel-shark-qt/src/libkshark-json.c
new file mode 100644
index 0000000..d06488e
--- /dev/null
+++ b/kernel-shark-qt/src/libkshark-json.c
@@ -0,0 +1,601 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+ /**
+  *  @file    libkshark-json.c
+  *  @brief   Json Confoguration I/O.
+  */
+
+// C
+/** Use GNU C Library. */
+#define _GNU_SOURCE
+#include <stdio.h>
+
+// KernelShark
+#include "libkshark.h"
+
+/**
+ * @brief Create an empty Json document and set its type description.
+ *
+ * @param type: String describing the type of the document,
+ *		e.g. "kshark.record.config" or "kshark.filter.config".
+ *
+ * @returns json_object instance. Use json_object_put() to free the object.
+ */
+struct json_object *kshark_config_alloc(const char *type)
+{
+	json_object *jobj, *jtype;
+
+	jobj = json_object_new_object();
+	jtype = json_object_new_string(type);
+
+	if (!jobj || !jtype)
+		goto fail;
+
+	/* Set the type of this Json document. */
+	json_object_object_add(jobj, "type", jtype);
+
+	return jobj;
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory for json_object.\n");
+	json_object_put(jobj);
+	json_object_put(jtype);
+
+	return NULL;
+}
+
+/**
+ * @brief Create an empty Record Configuration document. The type description
+ *	  is set to "kshark.record.config".
+ *
+ * @returns json_object instance. Use json_object_put() to free the object.
+ */
+struct json_object *kshark_record_config_alloc()
+{
+	return kshark_config_alloc("kshark.record.config");
+}
+
+/**
+ * @brief Create an empty Filter Configuration document. The type description
+ *	  is set to "kshark.filter.config".
+ *
+ * @returns json_object instance. Use json_object_put() to free the object.
+ */
+struct json_object *kshark_filter_config_alloc()
+{
+	return kshark_config_alloc("kshark.filter.config");;
+}
+
+/**
+ * @brief Record the current configuration of an Event Id filter into a Json
+ *	  document.
+ *
+ * @param pevt: Input location for the Page event.
+ * @param filter: Input location for an Id filter.
+ * @param filter_name: The name of the filter to show up in the Json document.
+ * @param jobj: Input location for the json_object instance.
+ */
+void kshark_event_filter_to_json(struct pevent *pevt,
+				 struct tracecmd_filter_id *filter,
+				 const char *filter_name,
+				 struct json_object *jobj)
+{
+	json_object *jfilter_data, *jevent, *jsystem, *jname;
+	int i, evt, *ids;
+	char *temp;
+
+	/* Get the array of Ids to be fitered. */
+	ids = tracecmd_filter_ids(filter);
+
+	/* Create a Json array and fill the Id values into it. */
+	jfilter_data = json_object_new_array();
+	if (!jfilter_data)
+		goto fail;
+
+	for (i = 0; i < filter->count; ++i) {
+		for (evt = 0; evt < pevt->nr_events; ++evt) {
+			if (pevt->events[evt]->id == ids[i]) {
+				jevent = json_object_new_object();
+
+				temp = pevt->events[evt]->system;
+				jsystem = json_object_new_string(temp);
+
+				temp = pevt->events[evt]->name;
+				jname = json_object_new_string(temp);
+
+				if (!jevent || !jsystem || !jname)
+					goto fail;
+
+				json_object_object_add(jevent, "system",
+							       jsystem);
+
+				json_object_object_add(jevent, "name",
+							       jname);
+
+				json_object_array_add(jfilter_data, jevent);
+
+				break;
+			}
+		}
+	}
+
+	/* Add the array of Ids to the filter config document. */
+	json_object_object_add(jobj, filter_name, jfilter_data);
+
+	return;
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory for json_object.\n");
+	json_object_put(jfilter_data);
+	json_object_put(jevent);
+	json_object_put(jsystem);
+	json_object_put(jname);
+}
+
+/**
+ * @brief Load from Json document the configuration of an Event Id filter.
+ *
+ * @param pevt: Input location for the Page event.
+ * @param filter: Input location for an Id filter.
+ * @param filter_name: The name of the filter as showing up in the Json
+ *	               document.
+ * @param jobj: Input location for the json_object instance.
+ *
+ * @returns True, if a filter has been loaded. If the filter configuration
+ *	    document contains no data for this particular filter or in a case
+ *	    of an error, the function returns False.
+ */
+bool kshark_event_filter_from_json(struct pevent *pevt,
+				   struct tracecmd_filter_id *filter,
+				   const char *filter_name,
+				   struct json_object *jobj)
+{
+	json_object *jfilter, *jevent, *jsystem, *jname;
+	const char *system_str, *name_str;
+	struct event_format *event;
+	int i, length;
+
+	/*
+	 * Use the name of the filter to find the array of events associated
+	 * with this filter. Notice that the filter config document may
+	 * contain no data for this particular filter.
+	 */
+	json_object_object_get_ex(jobj, filter_name, &jfilter);
+	if (!jfilter || json_object_get_type(jfilter) != json_type_array)
+		return false;
+
+	/* Set the filter. */
+	length = json_object_array_length(jfilter);
+	for (i = 0; i < length; ++i) {
+		jevent = json_object_array_get_idx(jfilter, i);
+
+		json_object_object_get_ex(jevent, "system", &jsystem);
+		json_object_object_get_ex(jevent, "name", &jname);
+		if (!jsystem || !jname)
+			goto fail;
+
+		system_str = json_object_get_string(jsystem);
+		name_str = json_object_get_string(jname);
+
+		event = pevent_find_event_by_name(pevt, system_str, name_str);
+		if (!event)
+			goto fail;
+
+		tracecmd_filter_id_add(filter, event->id);
+	}
+
+	return true;
+
+ fail:
+	fprintf(stderr, "Failed to load event filter from json_object.\n");
+	return false;
+}
+
+static void kshark_task_filter_to_json(struct tracecmd_filter_id *filter,
+				       const char *filter_name,
+				       struct json_object *jobj)
+{
+	json_object *jfilter_data, *jpid;
+	int i, *ids;
+
+	/* Get the array of Ids to be fitered. */
+	ids = tracecmd_filter_ids(filter);
+
+	/* Create a Json array and fill the Id values into it. */
+	jfilter_data = json_object_new_array();
+	if (!jfilter_data)
+		goto fail;
+
+	for (i = 0; i < filter->count; ++i) {
+		jpid = json_object_new_int(ids[i]);
+		if (!jpid)
+			goto fail;
+
+		json_object_array_add(jfilter_data, jpid);
+	}
+
+	/* Add the array of Ids to the filter config document. */
+	json_object_object_add(jobj, filter_name, jfilter_data);
+
+	return;
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory for json_object.\n");
+	json_object_put(jfilter_data);
+	json_object_put(jpid);
+}
+
+static bool kshark_task_filter_from_json(struct tracecmd_filter_id *filter,
+					 const char *filter_name,
+					 struct json_object *jobj)
+{
+	json_object *jfilter, *jpid;
+	int i, length;
+
+	/*
+	 * Use the name of the filter to find the array of events associated
+	 * with this filter. Notice that the filter config document may
+	 * contain no data for this particular filter.
+	 */
+	json_object_object_get_ex(jobj, filter_name, &jfilter);
+	if (!jfilter || json_object_get_type(jfilter) != json_type_array)
+		return false;
+
+	/* Set the filter. */
+	length = json_object_array_length(jfilter);
+	for (i = 0; i < length; ++i) {
+		jpid = json_object_array_get_idx(jfilter, i);
+		if (!jpid)
+			goto fail;
+
+		tracecmd_filter_id_add(filter, json_object_get_int(jpid));
+	}
+
+	return true;
+
+ fail:
+	fprintf(stderr, "Failed to load task filter from json_object.\n");
+	return false;
+}
+
+/**
+ * @brief Record the current configuration of the advanced filter into a Json
+ *	  document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param jobj: Input location for the json_object instance.
+ */
+void kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
+				struct json_object *jobj)
+{
+	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
+	json_object *jfilter_data, *jevent, *jsystem, *jname, *jfilter;
+	struct event_format **events;
+	char *str;
+	int i;
+
+	if (!kshark_ctx->advanced_event_filter->filters)
+		return;
+
+	/* Create a Json array and fill the Id values into it. */
+	jfilter_data = json_object_new_array();
+	if (!jfilter_data)
+		goto fail;
+
+	events = pevent_list_events(kshark_ctx->pevent, EVENT_SORT_SYSTEM);
+
+	for (i = 0; events[i]; i++) {
+		str = pevent_filter_make_string(adv_filter,
+						events[i]->id);
+		if (!str)
+			continue;
+
+		jevent = json_object_new_object();
+		jsystem = json_object_new_string(events[i]->system);
+		jname = json_object_new_string(events[i]->name);
+		jfilter = json_object_new_string(str);
+		if (!jevent || !jsystem || !jname || !jfilter)
+			goto fail;
+
+		json_object_object_add(jevent, "system", jsystem);
+		json_object_object_add(jevent, "name", jname);
+		json_object_object_add(jevent, "condition", jfilter);
+
+		json_object_array_add(jfilter_data, jevent);
+	}
+
+	/* Add the array of advanced filters to the filter config document. */
+	json_object_object_add(jobj, "adv event filter", jfilter_data);
+
+	return;
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory for json_object.\n");
+	json_object_put(jfilter_data);
+	json_object_put(jevent);
+	json_object_put(jsystem);
+	json_object_put(jname);
+	json_object_put(jfilter);
+}
+
+/**
+ * @brief Load from Json document the configuration of the advanced filter.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param jobj: Input location for the json_object instance.
+ *
+ * @returns True, if a filter has been loaded. If the filter configuration
+ *	    document contains no data for this particular filter or in a case
+ *	    of an error, the function returns False.
+ */
+bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
+				  struct json_object *jobj)
+{
+	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
+	json_object *jfilter, *jsystem, *jname, *jcond;
+	int i, length, ret;
+	char *filter_str;
+
+	/*
+	 * Use the name of the filter to find the array of events associated
+	 * with this filter. Notice that the filter config document may
+	 * contain no data for this particular filter.
+	 */
+	json_object_object_get_ex(jobj, "adv event filter", &jfilter);
+	if (!jfilter || json_object_get_type(jfilter) != json_type_array) {
+		return false;
+	}
+
+	/* Set the filter. */
+	length = json_object_array_length(jfilter);
+	for (i = 0; i < length; ++i) {
+		jfilter = json_object_array_get_idx(jfilter, i);
+		json_object_object_get_ex(jfilter, "system", &jsystem);
+		json_object_object_get_ex(jfilter, "name", &jname);
+		json_object_object_get_ex(jfilter, "condition", &jcond);
+		if (!jsystem || !jname || !jcond)
+			goto fail;
+
+		asprintf(&filter_str, "%s/%s:%s",
+			 json_object_get_string(jsystem),
+			 json_object_get_string(jname),
+			 json_object_get_string(jcond));
+
+		ret = pevent_filter_add_filter_str(adv_filter,
+						   filter_str);
+		if (ret < 0)
+			goto fail;
+	}
+
+	return true;
+
+ fail:
+	fprintf(stderr, "Failed to laod Advanced filters.\n");
+	char error_str[200];
+	int error_status =
+		pevent_strerror(kshark_ctx->pevent, ret, error_str,
+							 sizeof(error_str));
+
+	if (error_status == 0)
+		fprintf(stderr, "filter failed due to: %s\n", error_str);
+
+	free(filter_str);
+	return false;
+}
+
+static bool filter_is_set(struct tracecmd_filter_id *filter)
+{
+	return filter && filter->count;
+}
+
+/**
+ * @brief Record the current configuration of "show task" and "hide task"
+ *	  filters into a Json document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param jobj: Input location for the json_object instance. If NULL a new
+ *		Filter Configuration document will be created.
+ */
+void kshark_all_event_filters_to_json(struct kshark_context *kshark_ctx,
+				      struct json_object **jobj)
+{
+	if (!*jobj)
+		*jobj = kshark_filter_config_alloc();
+
+	/* Save a filter only if it contains Id values. */
+	if (filter_is_set(kshark_ctx->show_event_filter))
+		kshark_event_filter_to_json(kshark_ctx->pevent,
+					    kshark_ctx->show_event_filter,
+					    "show event filter",
+					    *jobj);
+
+	if (filter_is_set(kshark_ctx->hide_event_filter))
+		kshark_event_filter_to_json(kshark_ctx->pevent,
+					    kshark_ctx->hide_event_filter,
+					    "hide event filter",
+					    *jobj);
+}
+
+/**
+ * @brief Record the current configuration of "show task" and "hide task"
+ *	  filters into a Json document.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param jobj: Input location for the json_object instance. If NULL a new
+ *		Filter Configuration document will be created.
+ */
+void kshark_all_task_filters_to_json(struct kshark_context *kshark_ctx,
+				     struct json_object **jobj)
+{
+	if (!*jobj)
+		*jobj = kshark_filter_config_alloc();
+
+	/* Save a filter only if it contains Id values. */
+	if (filter_is_set(kshark_ctx->show_task_filter))
+		kshark_task_filter_to_json(kshark_ctx->show_task_filter,
+					   "show task filter",
+					   *jobj);
+
+	if (filter_is_set(kshark_ctx->hide_task_filter))
+		kshark_task_filter_to_json(kshark_ctx->hide_task_filter,
+					   "hide task filter",
+					   *jobj);
+}
+
+/**
+ * @brief Load from Json document the configuration of "show event" and
+ *	 "hide event" filters.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param jobj: Input location for the json_object instance.
+ *
+ * @returns True, if a filter has been loaded. If the filter configuration
+ *	    document contains no data for any event filter or in a case
+ *	    of an error, the function returns False.
+ */
+bool kshark_all_event_filters_from_json(struct kshark_context *kshark_ctx,
+					struct json_object *jobj)
+{
+	bool status;
+
+	status = kshark_event_filter_from_json(kshark_ctx->pevent,
+					       kshark_ctx->hide_event_filter,
+					       "hide event filter",
+					       jobj);
+
+	status |= kshark_event_filter_from_json(kshark_ctx->pevent,
+						kshark_ctx->show_event_filter,
+						"show event filter",
+						jobj);
+
+	return status;
+}
+
+/**
+ * @brief Load from Json document the configuration of "show task" and
+ *	 "hide task" filters.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param jobj: Input location for the json_object instance.
+ *
+ * @returns True, if a filter has been loaded. If the filter configuration
+ *	    document contains no data for any task filter or in a case of an
+ *	    error, the function returns False.
+ */
+bool kshark_all_task_filters_from_json(struct kshark_context *kshark_ctx,
+				       struct json_object *jobj)
+{
+	bool status;
+
+	status = kshark_task_filter_from_json(kshark_ctx->hide_task_filter,
+					      "hide task filter",
+					      jobj);
+
+	status |= kshark_task_filter_from_json(kshark_ctx->show_task_filter,
+					       "show task filter",
+					       jobj);
+
+	return status;
+}
+
+/**
+ * @brief Create a Filter Configuration document containing the current
+ *	  configuration of all filters.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ *
+ * @returns json_object instance. Use json_object_put() to free the object.
+ */
+struct json_object *
+kshark_all_filters_to_json(struct kshark_context *kshark_ctx)
+{
+	struct json_object *jobj;
+
+	/*  Create a new Json document. */
+	jobj = kshark_filter_config_alloc();
+
+	/* Save a filter only if it contains Id values. */
+	kshark_all_event_filters_to_json(kshark_ctx, &jobj);
+	kshark_all_task_filters_to_json(kshark_ctx, &jobj);
+	kshark_adv_filters_to_json(kshark_ctx, jobj);
+
+	return jobj;
+}
+
+/**
+ * @brief Load from Json document the configuration of all filters.
+ *
+ * @param kshark_ctx: Input location for session context pointer.
+ * @param jobj: Input location for the json_object instance.
+ *
+ * @returns True, if a filter has been loaded. If the filter configuration
+ *	    document contains no data for any filter or in a case of an error,
+ *	    the function returns False.
+ */
+bool kshark_all_filters_from_json(struct kshark_context *kshark_ctx,
+				  struct json_object *jobj)
+{
+	bool status;
+	status = kshark_all_task_filters_from_json(kshark_ctx, jobj);
+	status |= kshark_all_event_filters_from_json(kshark_ctx, jobj);
+	status |= kshark_adv_filters_from_json(kshark_ctx, jobj);
+
+	return status;
+}
+
+/**
+ * @brief Save a Json Configuration document into a file.
+ *
+ * @param file_name: The name of the file.
+ * @param jobj: Input location for the json_object instance.
+ */
+void kshark_save_json_file(const char *file_name,
+			   struct json_object *jobj)
+{
+	int flags;
+
+	/* Save the file in a human-readable form. */
+	flags = JSON_C_TO_STRING_SPACED | JSON_C_TO_STRING_PRETTY;
+	json_object_to_file_ext(file_name, jobj, flags);
+}
+
+/**
+ * @brief Open a Jason file and check if it has the expected type.
+ *
+ * @param file_name: The name of the file.
+ * @param type: String describing the expected type of the document,
+ *		e.g. "kshark.record.config" or "kshark.filter.config".
+ *
+ * @returns json_object instance on success, or NULL on failure. Use
+ *	    json_object_put() to free the object.
+ */
+struct json_object *kshark_open_json_file(const char *file_name,
+					  const char *type)
+{
+	struct json_object *jobj, *var;
+	const char *type_var;
+
+	jobj = json_object_from_file(file_name);
+
+	if (!jobj)
+		return NULL;
+
+	/* Get the type of the document. */
+	json_object_object_get_ex(jobj, "type", &var);
+	type_var = json_object_get_string(var);
+
+	if (strcmp(type, type_var) != 0) {
+		/* The document has a wrong type. */
+		fprintf(stderr, "Failed to open Json file %s\n.", file_name);
+		fprintf(stderr, "The document has a wrong type.\n");
+
+		json_object_put(jobj);
+		return NULL;
+	}
+
+	return jobj;
+}
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index ff09da3..cdf6cbc 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -16,6 +16,9 @@
 #include <stdint.h>
 #include <pthread.h>
 
+// Json-C
+#include <json.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -367,6 +370,52 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
 				 const struct kshark_entry_collection *col,
 				 ssize_t *index);
 
+struct json_object *kshark_config_alloc(const char *type);
+
+struct json_object *kshark_record_config_alloc();
+
+struct json_object *kshark_filter_config_alloc();
+
+void kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
+				struct json_object *jobj);
+
+bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
+				  struct json_object *jobj);
+
+void kshark_event_filter_to_json(struct pevent *pevt,
+				 struct tracecmd_filter_id *filter,
+				 const char *filter_name,
+				 struct json_object *jobj);
+
+bool kshark_event_filter_from_json(struct pevent *pevt,
+				   struct tracecmd_filter_id *filter,
+				   const char *filter_name,
+				   struct json_object *jobj);
+
+void kshark_all_event_filters_to_json(struct kshark_context *kshark_ctx,
+				      struct json_object **jobj);
+
+void kshark_all_task_filters_to_json(struct kshark_context *kshark_ctx,
+				     struct json_object **jobj);
+
+struct json_object *
+kshark_all_filters_to_json(struct kshark_context *kshark_ctx);
+
+bool kshark_all_event_filters_from_json(struct kshark_context *kshark_ctx,
+					struct json_object *jobj);
+
+bool kshark_all_task_filters_from_json(struct kshark_context *kshark_ctx,
+					struct json_object *jobj);
+
+bool kshark_all_filters_from_json(struct kshark_context *kshark_ctx,
+				  struct json_object *jobj);
+
+void kshark_save_json_file(const char *filter_name,
+			   struct json_object *jobj);
+
+struct json_object *kshark_open_json_file(const char *filter_name,
+					  const char *type);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.17.1
