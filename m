Return-Path: <SRS0=TioG=L7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50681 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbeIQT6H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Sep 2018 15:58:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id s12-v6so9902305wmc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Sep 2018 07:30:31 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark-qt: Fix all problems revealed after adding "-O2" compiler flag
Date: Mon, 17 Sep 2018 17:29:42 +0300
Message-Id: <20180917142942.7975-2-y.karadz@gmail.com>
In-Reply-To: <20180917142942.7975-1-y.karadz@gmail.com>
References: <20180917142942.7975-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes all problems detected by the compiler after adding
the "-O2" flag.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/configio.c      |  2 +-
 kernel-shark-qt/src/libkshark-configio.c | 40 +++++++++++++++---------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/kernel-shark-qt/examples/configio.c b/kernel-shark-qt/examples/configio.c
index 3b1928f..faa116a 100644
--- a/kernel-shark-qt/examples/configio.c
+++ b/kernel-shark-qt/examples/configio.c
@@ -7,7 +7,7 @@ int main(int argc, char **argv)
 {
 	struct kshark_config_doc *conf, *filter, *hello;
 	struct kshark_context *kshark_ctx;
-	int *ids, i;
+	int *ids = NULL, i;
 
 	/* Create a new kshark session. */
 	kshark_ctx = NULL;
diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src/libkshark-configio.c
index cdc8c76..22a0b70 100644
--- a/kernel-shark-qt/src/libkshark-configio.c
+++ b/kernel-shark-qt/src/libkshark-configio.c
@@ -694,6 +694,8 @@ static bool kshark_event_filter_to_json(struct tep_handle *pevent,
 	int i, evt, *ids;
 	char *temp;
 
+	jevent = jsystem = jname = NULL;
+
 	/*
 	 * If this Json document already contains a description of the filter,
 	 * delete this description.
@@ -869,7 +871,7 @@ static bool kshark_task_filter_to_json(struct tracecmd_filter_id *filter,
 				       const char *filter_name,
 				       struct json_object *jobj)
 {
-	json_object *jfilter_data, *jpid;
+	json_object *jfilter_data, *jpid = NULL;
 	int i, *ids;
 
 	/*
@@ -1013,6 +1015,8 @@ static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
 	char *str;
 	int i;
 
+	jevent = jsystem = jname = jfilter = NULL;
+
 	/*
 	 * If this Json document already contains a description of the model,
 	 * delete this description.
@@ -1105,8 +1109,8 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 {
 	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
 	json_object *jfilter, *jsystem, *jname, *jcond;
-	int i, length, ret;
-	char *filter_str;
+	int i, length, n, ret = 0;
+	char *filter_str = NULL;
 
 	/*
 	 * Use the name of the filter to find the array of events associated
@@ -1131,10 +1135,15 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 		    !json_object_object_get_ex(jfilter, "condition", &jcond))
 			goto fail;
 
-		asprintf(&filter_str, "%s/%s:%s",
-			 json_object_get_string(jsystem),
-			 json_object_get_string(jname),
-			 json_object_get_string(jcond));
+		n = asprintf(&filter_str, "%s/%s:%s",
+			     json_object_get_string(jsystem),
+			     json_object_get_string(jname),
+			     json_object_get_string(jcond));
+
+		if (n <= 0) {
+			filter_str = NULL;
+			goto fail;
+		}
 
 		ret = tep_filter_add_filter_str(adv_filter,
 						filter_str);
@@ -1146,13 +1155,16 @@ static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 
  fail:
 	fprintf(stderr, "Failed to laod Advanced filters.\n");
-	char error_str[200];
-	int error_status =
-		tep_strerror(kshark_ctx->pevent, ret, error_str,
-						      sizeof(error_str));
-
-	if (error_status == 0)
-		fprintf(stderr, "filter failed due to: %s\n", error_str);
+	if (ret < 0) {
+		char error_str[200];
+		int error_status =
+			tep_strerror(kshark_ctx->pevent, ret, error_str,
+				     sizeof(error_str));
+
+		if (error_status == 0)
+			fprintf(stderr, "filter failed due to: %s\n",
+					error_str);
+	}
 
 	free(filter_str);
 	return false;
-- 
2.17.1
