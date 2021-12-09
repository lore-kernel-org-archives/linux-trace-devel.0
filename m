Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E347C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 10:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbhLIKtN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 05:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbhLIKtN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 05:49:13 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E8AC061746
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 02:45:39 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x15so18266672edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Dec 2021 02:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q0WMQ1fVK7/e0ILhTVCpEDBCOW1m3iGyik51SfEjlco=;
        b=WhO2hBC3XKC0ffXenWe1UR/01qZNKXOx9Rl2XrSnaznyyDcnaJ3wJPjCoxu/MFThNW
         mBxzEJQPWTV7k+33RiegX84eAvl0Pi96weFok0efYfeVhZ1ENmBFNp4BsFBWA3Gfy1vN
         s9te50EDKmE+oyCFAMLGYMeD8LG8JwcNchASug3nb5WGuq2QIbmeAMLisRWy+QO2MCVn
         8aDsW7Xgl2sDvKYQ+XYD3BekCAl3V4nT2JAiKBR5rcNlqrhiO0BE31y5jbp1hTG9W+fX
         4yNXDtiDJzwIpJWCt3AvZrMgBg+mlUfBfeaIHA0tgYjCBbO9i478KfmVELr5M+Uc4Of7
         U3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q0WMQ1fVK7/e0ILhTVCpEDBCOW1m3iGyik51SfEjlco=;
        b=Qr75gdiIYAUFPrE6HILKfRrcQfueJ8maftcDQe90FXoh0Ky9rdPosvSzerxT2U6sAc
         isnctefhd3H8nCj5fo8tUL4YQL6Wb3yoydYGeSc4QADYAR/fr5wF7by3wmedj6uGMvoO
         433r5YhBoKAox28felEm5qT4mdJy63/2XbWARhtwXiPJGMhwLgv9Njn0cYEKJq81rr5W
         XaOtYcK9rLoA5zsWZJHy2iPrfzWRHBDH5nUE1vWCy+q/AOVkGD2SjAil6WpCSVAekmTc
         Lr9dN7VDQJBLkI8EYhqfN3RoQILe3aifyjCrF2vyv3pPpHYsg17IMClkwwVaR8FpmbPw
         GhDg==
X-Gm-Message-State: AOAM532Bdib2QA5FTEsRJjCNPhBDWTR6Op1V20gtE8v0AqYSh3FzlCOr
        IooIjXsmCrFIe4WgqhYqBlA=
X-Google-Smtp-Source: ABdhPJxohtkRmLiYbrM6VzgvxdtiJT4DG/UNnqLSa3aECCjtA1MoBvF8xFdC7GMguxf5X00V/HYvTg==
X-Received: by 2002:a05:6402:2692:: with SMTP id w18mr28037159edd.220.1639046738343;
        Thu, 09 Dec 2021 02:45:38 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b7sm3778545edd.26.2021.12.09.02.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:45:38 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] libtracefs: New APIs for getting the raw format of synth event
Date:   Thu,  9 Dec 2021 12:45:24 +0200
Message-Id: <20211209104524.5354-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211209104524.5354-1-y.karadz@gmail.com>
References: <20211209104524.5354-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The following APIs are added:
int tracefs_synth_echo_fmt(struct trace_seq *, struct tracefs_synth *)
const char *tracefs_synth_show_event_row(struct tracefs_synth *)
const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *)
const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *)

The new APIs can be useful in the case whene the user wants to
check what exactly gets passed to the kernel as definition of
a synth event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h  |  5 +++
 src/tracefs-hist.c | 97 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 84 insertions(+), 18 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 967690f..0482b0a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -250,6 +250,7 @@ enum tracefs_dynevent_type {
 	TRACEFS_DYNEVENT_SYNTH		= 1 << 5,
 	TRACEFS_DYNEVENT_MAX		= 1 << 6,
 };
+
 int tracefs_dynevent_create(struct tracefs_dynevent *devent);
 int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force);
 int tracefs_dynevent_destroy_all(unsigned int types, bool force);
@@ -550,6 +551,10 @@ int tracefs_synth_create(struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_synth *synth);
 void tracefs_synth_free(struct tracefs_synth *synth);
 int tracefs_synth_echo_cmd(struct trace_seq *seq, struct tracefs_synth *synth);
+int tracefs_synth_echo_fmt(struct trace_seq *seq, struct tracefs_synth *synth);
+const char *tracefs_synth_show_event_row(struct tracefs_synth *synth);
+const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *synth);
+const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *synth);
 
 struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 				  const char *sql_buffer, char **err);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 6051ecc..ad9648f 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -683,6 +683,8 @@ struct tracefs_synth {
 	struct action		*actions;
 	struct action		**next_action;
 	struct tracefs_dynevent	*dyn_event;
+	char			*start_hist;
+	char			*end_hist;
 	char			*name;
 	char			**synthetic_fields;
 	char			**synthetic_args;
@@ -737,6 +739,8 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 		return;
 
 	free(synth->name);
+	free(synth->start_hist);
+	free(synth->end_hist);
 	tracefs_list_free(synth->synthetic_fields);
 	tracefs_list_free(synth->synthetic_args);
 	tracefs_list_free(synth->start_keys);
@@ -1802,6 +1806,70 @@ static char *create_end_hist(struct tracefs_synth *synth)
 	return create_actions(end_hist, synth);
 }
 
+/*
+ * tracefs_synth_echo_fmt - show the raw format of a synthetic event
+ * @seq: A trace_seq to store the format string
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format that describes the synthetic event, including
+ * the format of the dynamic event and the start / end histograms.
+ *
+ * Returns 0 on succes -1 on error.
+ */
+int tracefs_synth_echo_fmt(struct trace_seq *seq, struct tracefs_synth *synth)
+{
+	if (!synth->dyn_event)
+		return -1;
+
+	trace_seq_printf(seq, "%s", synth->dyn_event->format);
+	trace_seq_printf(seq, "\n%s", synth->start_hist);
+	trace_seq_printf(seq, "\n%s", synth->end_hist);
+
+	return 0;
+}
+
+/*
+ * tracefs_synth_show_event_row - show the dynamic event used by a synthetic
+ *				  event
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format of the dynamic event used by the synthetic event.
+ *
+ * Returns format string owned by @synth on success, or NULL on error.
+ */
+const char *tracefs_synth_show_event_row(struct tracefs_synth *synth)
+{
+	return synth->dyn_event ? synth->dyn_event->format : NULL;
+}
+
+/*
+ * tracefs_synth_show_start_hist_row - show the start histogram used by a
+ *				       synthetic event
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format of the start histogram used by the synthetic event.
+ *
+ * Returns format string owned by @synth on success, or NULL on error.
+ */
+const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *synth)
+{
+	return synth->start_hist;
+}
+
+/*
+ * tracefs_synth_show_end_hist_row - show the end histogram used by a
+ *				       synthetic event
+ * @synth: The synthetic event to read format from
+ *
+ * This shows the raw format of the end histogram used by the synthetic event.
+ *
+ * Returns format string owned by @synth on success, or NULL on error.
+ */
+const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *synth)
+{
+	return synth->end_hist;
+}
+
 static char *append_filter(char *hist, char *filter, unsigned int parens)
 {
 	int i;
@@ -1940,8 +2008,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
  */
 int tracefs_synth_create(struct tracefs_synth *synth)
 {
-	char *start_hist = NULL;
-	char *end_hist = NULL;
 	int ret;
 
 	if (!synth) {
@@ -1962,40 +2028,35 @@ int tracefs_synth_create(struct tracefs_synth *synth)
 	if (tracefs_dynevent_create(synth->dyn_event))
 		return -1;
 
-	start_hist = create_hist(synth->start_keys, synth->start_vars);
-	start_hist = append_filter(start_hist, synth->start_filter,
-				   synth->start_parens);
-	if (!start_hist)
+	synth->start_hist = create_hist(synth->start_keys, synth->start_vars);
+	synth->start_hist = append_filter(synth->start_hist, synth->start_filter,
+					  synth->start_parens);
+	if (!synth->start_hist)
 		goto remove_synthetic;
 
-	end_hist = create_end_hist(synth);
-	end_hist = append_filter(end_hist, synth->end_filter,
-				   synth->end_parens);
-	if (!end_hist)
+	synth->end_hist = create_end_hist(synth);
+	synth->end_hist = append_filter(synth->end_hist, synth->end_filter,
+					synth->end_parens);
+	if (!synth->end_hist)
 		goto remove_synthetic;
 
 	ret = tracefs_event_file_append(synth->instance, synth->start_event->system,
 					synth->start_event->name,
-					"trigger", start_hist);
+					"trigger", synth->start_hist);
 	if (ret < 0)
 		goto remove_synthetic;
 
 	ret = tracefs_event_file_append(synth->instance, synth->end_event->system,
 					synth->end_event->name,
-					"trigger", end_hist);
+					"trigger", synth->end_hist);
 	if (ret < 0)
 		goto remove_start_hist;
 
-	free(start_hist);
-	free(end_hist);
-
 	return 0;
 
  remove_start_hist:
-	remove_hist(synth->instance, synth->start_event, start_hist);
+	remove_hist(synth->instance, synth->start_event, synth->start_hist);
  remove_synthetic:
-	free(end_hist);
-	free(start_hist);
 	tracefs_dynevent_destroy(synth->dyn_event, false);
 	return -1;
 }
-- 
2.32.0

