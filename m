Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B504CC19F36
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97F25610FD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhHJUsw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232453AbhHJUss (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5494161078;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hAN-8L; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 7/9] libtracefs: Add API tracefs_hist_data_keys/values() and next_bucket()
Date:   Tue, 10 Aug 2021 16:48:16 -0400
Message-Id: <20210810204818.880714-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810204818.880714-1-rostedt@goodmis.org>
References: <20210810204818.880714-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add APIs:

	tracefs_hist_data_keys()
	tracefs_hist_data_values()
	tracefs_hist_data_next_bucket()
	tracefs_hist_data_first_bucket()

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h       |  36 ++++++++++++++
 src/tracefs-hist-data.c | 107 +++++++++++++++++++++++++++++-----------
 2 files changed, 113 insertions(+), 30 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 7aa6a3e5673a..db0a1d73f091 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -431,6 +431,42 @@ void tracefs_hist_data_free_list(struct tracefs_hist_data **hdata_list);
 char **tracefs_hist_data_key_names(struct tracefs_hist_data *hdata);
 char **tracefs_hist_data_value_names(struct tracefs_hist_data *hdata);
 
+enum tracefs_bucket_key_flags {
+	TRACEFS_BUCKET_KEY_FL_UNDEF	= (1 << 29),
+	TRACEFS_BUCKET_KEY_FL_SINGLE	= (1 << 30),
+	TRACEFS_BUCKET_KEY_FL_RANGE	= (1 << 31),
+};
+
+struct tracefs_hist_bucket_key_single {
+	long long		val;
+	char			*sym;
+};
+
+struct tracefs_hist_bucket_key_range {
+	long long		start;
+	long long		end;
+};
+
+struct tracefs_hist_bucket_key {
+	struct tracefs_hist_bucket_key	*next;
+	unsigned int			flags;
+	union {
+		struct tracefs_hist_bucket_key_single	single;
+		struct tracefs_hist_bucket_key_range	range;
+	};
+};
+
+struct tracefs_hist_bucket_val {
+	struct tracefs_hist_bucket_val		*next;
+	long long				val;
+};
+
+const struct tracefs_hist_bucket_key *tracefs_hist_data_keys(struct tracefs_hist_data *hdata);
+const struct tracefs_hist_bucket_val *tracefs_hist_data_values(struct tracefs_hist_data *hdata);
+
+int tracefs_hist_data_next_bucket(struct tracefs_hist_data *hdata);
+int tracefs_hist_data_first_bucket(struct tracefs_hist_data *hdata);
+
 struct tracefs_synth;
 
 /*
diff --git a/src/tracefs-hist-data.c b/src/tracefs-hist-data.c
index c93c27453255..0f811d6e3154 100644
--- a/src/tracefs-hist-data.c
+++ b/src/tracefs-hist-data.c
@@ -113,36 +113,6 @@ static char *name_token(enum yytokentype type)
 	return NULL;
 }
 
-enum tracefs_bucket_key_flags {
-	TRACEFS_BUCKET_KEY_FL_UNDEF	= (1 << 29),
-	TRACEFS_BUCKET_KEY_FL_SINGLE	= (1 << 30),
-	TRACEFS_BUCKET_KEY_FL_RANGE	= (1 << 31),
-};
-
-struct tracefs_hist_bucket_key_single {
-	long long		val;
-	char			*sym;
-};
-
-struct tracefs_hist_bucket_key_range {
-	long long		start;
-	long long		end;
-};
-
-struct tracefs_hist_bucket_key {
-	struct tracefs_hist_bucket_key	*next;
-	unsigned int			flags;
-	union {
-		struct tracefs_hist_bucket_key_single	single;
-		struct tracefs_hist_bucket_key_range	range;
-	};
-};
-
-struct tracefs_hist_bucket_val {
-	struct tracefs_hist_bucket_val		*next;
-	long long				val;
-};
-
 struct tracefs_hist_bucket {
 	struct tracefs_hist_bucket		*next;
 	struct tracefs_hist_bucket_key		*keys;
@@ -165,6 +135,7 @@ struct tracefs_hist_data {
 	struct key_types		*current_key_type;
 	struct tracefs_hist_bucket	*buckets;
 	struct tracefs_hist_bucket	**next_bucket;
+	struct tracefs_hist_bucket	*current_bucket;
 	unsigned long long		hits;
 	unsigned long long		entries;
 	unsigned long long		dropped;
@@ -1029,6 +1000,9 @@ tracefs_hist_data_parse(const char *buffer, const char **next_buffer, char **err
 	hist_lex_destroy(data.scanner);
 	free(data.text);
 
+	/* Set to read the first bucket after creation */
+	tracefs_hist_data_first_bucket(hdata);
+
 	return hdata;
  error:
 	print_error(&data, err, state, type);
@@ -1123,3 +1097,76 @@ char **tracefs_hist_data_value_names(struct tracefs_hist_data *hdata)
 	return tracefs_list_dup(hdata->value_names);
 }
 
+/**
+ * tracefs_hist_data_keys - Return the content of the keys
+ * @hdata: The hist data descriptor of the keys
+ *
+ * Returns the actual pointer to the key data list in the @hdata descriptor.
+ * It must not be modified or freed.
+ */
+const struct tracefs_hist_bucket_key *
+tracefs_hist_data_keys(struct tracefs_hist_data *hdata)
+{
+	if (!hdata || !hdata->current_bucket)
+		return NULL;
+
+	return hdata->current_bucket->keys;
+}
+
+/**
+ * tracefs_hist_data_values - Return the content of the values
+ * @hdata: The hist data descriptor of the values
+ *
+ * Returns the actual pointer to the value data list in the @hdata descriptor.
+ * It must not be modified or freed.
+ */
+const struct tracefs_hist_bucket_val *
+tracefs_hist_data_values(struct tracefs_hist_data *hdata)
+{
+	if (!hdata || !hdata->current_bucket)
+		return NULL;
+
+	return hdata->current_bucket->vals;
+}
+
+/**
+ * tracefs_hist_data_next_bucket - Move to the next bucket with content
+ * @hdata: The hist data desrciptor
+ *
+ * Move the "cursor" of the bucket that tracefs_hist_data_keys()
+ * and tracefs_hist_data_values() will return their data from.
+ *
+ * Returns -1 if @hdata is NULL or already hit the last bucket.
+ * Returns 0 if there's still data after going to the next bucket
+ * Returns 1 if there's no more data left.
+ */
+int tracefs_hist_data_next_bucket(struct tracefs_hist_data *hdata)
+{
+	if (!hdata || !hdata->current_bucket)
+		return -1;
+
+	hdata->current_bucket = hdata->current_bucket->next;
+
+	return !hdata->current_bucket;
+}
+
+/**
+ * tracefs_hist_data_first_bucket - Reset to the first bucket
+ * @hdata: The hist data desrciptor
+ *
+ * Move the "cursor" of the bucket that tracefs_hist_data_keys()
+ * and tracefs_hist_data_values() will return their data from
+ * to the first bucket in the @hlist.
+ *
+ * Returns -1 if @hdata is NULL or already hit the last bucket.
+ * Returns 0 if there's still data after going to the next bucket
+ * Returns 1 if there's no more data left.
+ */
+int tracefs_hist_data_first_bucket(struct tracefs_hist_data *hdata)
+{
+	if (!hdata || !hdata->buckets)
+		return -1;
+
+	hdata->current_bucket = hdata->buckets;
+	return !hdata->current_bucket;
+}
-- 
2.30.2

