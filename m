Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C007C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 15:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346697AbhLFPWE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 10:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349342AbhLFPTz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 10:19:55 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD58C0698E1
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 07:14:06 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id i5so23179833wrb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Dec 2021 07:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rLZLY2TyIEtkh27UH4llP5NY16EmZN7G2tK2+QJwG2M=;
        b=cQVT4w6NCh92mxp/Yqm3jS3sruC2JugLBXIk2cgeaQX+iLx3U2VQKNmRRqaNMIGnfE
         D6e6lRJK8zDkOZopiZvm/7s7gSJLVY7kSrD6WpU7zQJkEVtOSiNpKofBuQ3xW7a76Cxz
         mOHVQ3PZSOCinfja5LxxeXmLZeNoLzKQ9NBtEDobgH16HoYLDenn+MrqkzQEQStyuUED
         SXG2SgoBaG12JVd0PfldBDcX7GtiWF5wEGB+rFJzyWu7dhoxCAflsZR6jx1zLTazM04P
         4MQbizTSeRHcyyp17i6nt0G7r5sj69CyWSghorlcDqXJJbOK+FHm2/EimTo6+y1FHAZ4
         6hPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rLZLY2TyIEtkh27UH4llP5NY16EmZN7G2tK2+QJwG2M=;
        b=eiVk0OGlsq4Big5brjHpgC8muewC1Bu7Pi1BAzasT4jnR6Rk5QYPQxgGabJgJslWzT
         GZ9+4biPPcDw2pYfQ60/HZdhgyPz/Pir/WqVhCfhTY0jUOWlaHDp2eXPj0dmNfxMa6P7
         5aQa3AYeUvd/QLIjL4cub8tBgwIMIGVAgrwQo1L3hcodMy3nrl9lTXbsbMngNeqkBMAx
         yFsnznGiOE2i8T54Rns0r4iKzRgX9DrgHRQ9dOG8k2wgR4H7m6sycaj8MspISDtbgDUE
         6AyxzIZ6U/nkqh0/kHnSKNmxdgv/ltsDJ53ZGvo/SZyMn8p1bRseDdHOwbEVcRz/GTr3
         BwRA==
X-Gm-Message-State: AOAM530KWVLJtdlt4cevVevmq5MeNkCXD/ml30v2rkBKAmpLtJU2EMpA
        oxl67p+FhKn4A5DNZfLppBij20gnIrM=
X-Google-Smtp-Source: ABdhPJxnj5/fTEQTCYhxgIjC8AWdyZJna+OLNFyow6HjO7ANyMvRfVmbnlk80UkMComqGAy14hFTvg==
X-Received: by 2002:adf:ef84:: with SMTP id d4mr42585910wro.175.1638803644872;
        Mon, 06 Dec 2021 07:14:04 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b6sm14749872wmq.45.2021.12.06.07.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 07:14:04 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH] libtracefs: New APIs for getting the raw format of synth event
Date:   Mon,  6 Dec 2021 17:13:52 +0200
Message-Id: <20211206151352.361507-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new APIs can be useful in the case whene the user wants to
check what exactly gets passed to the kernel as definition of
a synth event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h  |   4 ++
 src/tracefs-hist.c | 102 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 88 insertions(+), 18 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 804d738..9ad036c 100644
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
@@ -553,6 +554,9 @@ int tracefs_synth_create(struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_synth *synth);
 void tracefs_synth_free(struct tracefs_synth *synth);
 int tracefs_synth_echo_cmd(struct trace_seq *seq, struct tracefs_synth *synth);
+const char *tracefs_synth_show_event_row(struct tracefs_synth *synth);
+const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *synth);
+const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *synth);
 
 struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 				  const char *sql_buffer, char **err);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 41c88d1..338249d 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -717,6 +717,8 @@ struct tracefs_synth {
 	struct action		*actions;
 	struct action		**next_action;
 	struct tracefs_dynevent	*dyn_event;
+	char			*start_hist;
+	char			*end_hist;
 	char			*name;
 	char			**synthetic_fields;
 	char			**synthetic_args;
@@ -771,6 +773,8 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 		return;
 
 	free(synth->name);
+	free(synth->start_hist);
+	free(synth->end_hist);
 	tracefs_list_free(synth->synthetic_fields);
 	tracefs_list_free(synth->synthetic_args);
 	tracefs_list_free(synth->start_keys);
@@ -1067,6 +1071,9 @@ struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
 		synth = NULL;
 	}
 
+	synth->start_hist = NULL;
+	synth->end_hist = NULL;
+
 	return synth;
 }
 
@@ -1836,6 +1843,72 @@ static char *create_end_hist(struct tracefs_synth *synth)
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
+int tracefs_synth_echo_fmt(struct trace_seq *seq,
+			   struct tracefs_instance *instance,
+			   struct tracefs_synth *synth)
+{
+	if (!synth->dyn_event)
+		return -1;
+
+	trace_seq_printf(seq, "%s\n", synth->dyn_event->format);
+	trace_seq_printf(seq, "%s\n", synth->start_hist);
+	trace_seq_printf(seq, "%s\n", synth->end_hist);
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
+ * Returns format string on succes or NULL on error.
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
+ * Returns format string on succes or NULL on error.
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
+ * Returns format string on succes or NULL on error.
+ */
+const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *synth)
+{
+	return synth->end_hist;
+}
+
 static char *append_filter(char *hist, char *filter, unsigned int parens)
 {
 	int i;
@@ -1974,8 +2047,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
  */
 int tracefs_synth_create(struct tracefs_synth *synth)
 {
-	char *start_hist = NULL;
-	char *end_hist = NULL;
 	int ret;
 
 	if (!synth) {
@@ -1996,40 +2067,35 @@ int tracefs_synth_create(struct tracefs_synth *synth)
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

