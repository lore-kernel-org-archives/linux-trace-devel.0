Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACB4C43214
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A1C4610A3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhHJUsu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232739AbhHJUss (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51CB261073;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hA7-3t; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/9] libtracefs: Parse comment for hist data information
Date:   Tue, 10 Aug 2021 16:48:11 -0400
Message-Id: <20210810204818.880714-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810204818.880714-1-rostedt@goodmis.org>
References: <20210810204818.880714-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The comments at the top of a hist file for a trace event includes the
string used to create the hist file. Parse it for the key names as well as
for the key types.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-hist-data.c | 211 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 185 insertions(+), 26 deletions(-)

diff --git a/src/tracefs-hist-data.c b/src/tracefs-hist-data.c
index 497ab9ce97b4..6ec262e8b180 100644
--- a/src/tracefs-hist-data.c
+++ b/src/tracefs-hist-data.c
@@ -151,21 +151,26 @@ struct tracefs_hist_bucket {
 	struct tracefs_hist_bucket_val		**next_val;
 };
 
+struct key_types {
+	struct key_types		*next;
+	enum tracefs_hist_key_type	type;
+};
+
 struct tracefs_hist_data {
+	char				*hist_str;
 	char				**key_names;
 	char				**value_names;
+	struct key_types		*key_types;
+	struct key_types		**next_key_type;
+	struct key_types		*current_key_type;
 	struct tracefs_hist_bucket	*buckets;
 	struct tracefs_hist_bucket	**next_bucket;
 	unsigned long long		hits;
 	unsigned long long		entries;
 	unsigned long long		dropped;
+	int				current_key;
 };
 
-static int do_comment(struct tracefs_hist_data *hdata, const char *comment)
-{
-	return 0;
-}
-
 static int do_key_type(struct tracefs_hist_data *hdata, const char *key)
 {
 	char **tmp;
@@ -234,6 +239,23 @@ static int start_new_key(struct tracefs_hist_data *hdata)
 	return 0;
 }
 
+static int do_add_key_type(struct tracefs_hist_data *hdata,
+			   enum tracefs_hist_key_type type)
+{
+	struct key_types *key_type;
+
+	key_type = calloc(1, sizeof(*key_type));
+	if (!key_type)
+		return -1;
+
+	key_type->type = type;
+
+	*hdata->next_key_type = key_type;
+	hdata->next_key_type = &key_type->next;
+
+	return 0;
+}
+
 static char *chomp(char *text)
 {
 	char *p;
@@ -252,6 +274,100 @@ static char *chomp(char *text)
 	return text;
 }
 
+static int do_comment(struct tracefs_hist_data *hdata, char *comment)
+{
+	enum tracefs_hist_key_type key_type;
+	const char trigger_info[] = "trigger info: ";
+	const char hist[] = "hist:";
+	const char keys[] = "keys=";
+	char *name;
+	int ret;
+
+	comment = chomp(comment);
+	if (!comment)
+		return -1;
+
+	if (!strcmp(comment, "event histogram"))
+		return 0;
+
+	if (strncmp(comment, trigger_info, strlen(trigger_info)) != 0)
+		return 0;
+
+	comment += strlen(trigger_info);
+	comment = chomp(comment);
+
+	if (strncmp(comment, hist, strlen(hist)) != 0)
+		return -1;
+
+	hdata->hist_str = strdup(comment);
+	if (!hdata->hist_str)
+		return -1;
+
+	comment += strlen(hist);
+
+	if (strncmp(comment, keys, strlen(keys)) != 0)
+		return -1;
+	comment += strlen(keys);
+
+	name = comment;
+
+	while (*comment) {
+		bool comma = false;
+
+		if (*comment == ':')
+			break;
+		switch (*comment) {
+		case ',':
+			comma = true;
+		case '.':
+			*comment = '\0';
+			do_key_type(hdata, name);
+			comment++;
+			if (comma) {
+				name = comment;
+				ret = do_add_key_type(hdata, 0);
+				if (ret < 0)
+					return -1;
+				continue;
+			}
+			if (!strncmp(comment, "hex", 3)) {
+				key_type = TRACEFS_HIST_KEY_HEX;
+			} else if (!strncmp(comment, "sym-offset", 10)) {
+				key_type = TRACEFS_HIST_KEY_SYM_OFFSET;
+			} else if (!strncmp(comment, "sym", 3)) {
+				key_type = TRACEFS_HIST_KEY_SYM;
+			} else if (!strncmp(comment, "syscall", 3)) {
+				key_type = TRACEFS_HIST_KEY_SYSCALL;
+			} else if (!strncmp(comment, "execname", 3)) {
+				key_type = TRACEFS_HIST_KEY_EXECNAME;
+			} else if (!strncmp(comment, "log2", 3)) {
+				key_type = TRACEFS_HIST_KEY_LOG;
+			} else if (!strncmp(comment, "usecs", 3)) {
+				key_type = TRACEFS_HIST_KEY_USECS;
+			} else {
+				key_type = 0;
+			}
+
+			ret = do_add_key_type(hdata, key_type);
+			if (ret < 0)
+				return -1;
+			while (*comment) {
+				if (*comment == ',') {
+					comment++;
+					name = comment;
+					break;
+				}
+				if (*comment == ':')
+					break;
+				comment++;
+			}
+			continue;
+		}
+		comment++;
+	}
+	return 0;
+}
+
 static int __do_key_val(struct tracefs_hist_data *hdata,
 			char *text, const char *delim, const char *end)
 {
@@ -261,6 +377,9 @@ static int __do_key_val(struct tracefs_hist_data *hdata,
 	char *val;
 	int len;
 
+	if (!hdata->current_key_type)
+		return -1;
+
 	text = chomp(text);
 
 	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
@@ -294,6 +413,16 @@ static int __do_key_val(struct tracefs_hist_data *hdata,
 
 	k->sym = val;
 
+	switch (hdata->current_key_type->type) {
+	case TRACEFS_HIST_KEY_HEX:
+		k->val = strtoll(k->sym, NULL, 16);
+		break;
+	case TRACEFS_HIST_KEY_USECS:
+		k->val = strtoll(k->sym, NULL, 0);
+	default:
+		break;
+	}
+
 	return 0;
 }
 
@@ -318,6 +447,9 @@ static int do_key_raw(struct tracefs_hist_data *hdata, char *text)
 	struct tracefs_hist_bucket_key *key;
 	struct tracefs_hist_bucket_key_single *k;
 
+	if (!hdata->current_key_type)
+		return -1;
+
 	text = chomp(text);
 
 	bucket = container_of(hdata->next_bucket, struct tracefs_hist_bucket, next);
@@ -331,7 +463,15 @@ static int do_key_raw(struct tracefs_hist_data *hdata, char *text)
 	if (k->val)
 		return -1;
 
-	k->val = strtoll(text, NULL, 0);
+	switch (hdata->current_key_type->type) {
+	case TRACEFS_HIST_KEY_SYM:
+	case TRACEFS_HIST_KEY_SYM_OFFSET:
+		k->val = strtoll(text, NULL, 16);
+		break;
+	default:
+		k->val = strtoll(text, NULL, 0);
+		break;
+	}
 
 	return 0;
 }
@@ -514,6 +654,27 @@ static void update_next(const char **next_buffer, struct hist_data *data)
 	*next_buffer = find_buffer_line(data->buffer, data->line_no - 1);
 }
 
+static int test_key(struct tracefs_hist_data *hdata, const char *key)
+{
+	if (tracefs_list_size(hdata->key_names) <= hdata->current_key)
+		return -1;
+
+	return strcmp(key, hdata->key_names[hdata->current_key]) == 0 ? 0 : -1;
+}
+
+static void reset_key_test(struct tracefs_hist_data *hdata)
+{
+	hdata->current_key = 0;
+	hdata->current_key_type = hdata->key_types;
+}
+
+static void inc_key_test(struct tracefs_hist_data *hdata)
+{
+	hdata->current_key++;
+	if (hdata->current_key_type)
+		hdata->current_key_type = hdata->current_key_type->next;
+}
+
 /**
  * tracefs_hist_data_free - free a created hist data descriptor
  * @hdata: The tracefs_hist_data descriptor to free.
@@ -529,6 +690,7 @@ void tracefs_hist_data_free(struct tracefs_hist_data *hdata)
 	if (!hdata)
 		return;
 
+	free(hdata->hist_str);
 	tracefs_list_free(hdata->key_names);
 	tracefs_list_free(hdata->value_names);
 
@@ -605,6 +767,7 @@ tracefs_hist_data_parse(const char *buffer, const char **next_buffer, char **err
 		return NULL;
 
 	hdata->next_bucket = &hdata->buckets;
+	hdata->next_key_type = &hdata->key_types;
 
 	memset(&data, 0, sizeof(data));
 
@@ -650,21 +813,19 @@ tracefs_hist_data_parse(const char *buffer, const char **next_buffer, char **err
 			switch (type) {
 			case KEY_TYPE:
  key_type:
-				if (first) {
-					ret = do_key_type(hdata, text);
-					if (ret < 0)
-						goto error;
-				}
+				reset_key_test(hdata);
+				ret = test_key(hdata, text);
+				if (ret < 0)
+					goto error;
 				ret = start_new_row(hdata);
 				state = HIST_KEY_VALS;
 				break;
 			case STACKTRACE:
  stacktrace:
-				if (first) {
-					ret = do_key_type(hdata, "stacktrace");
-					if (ret < 0)
-						goto error;
-				}
+				reset_key_test(hdata);
+				ret = test_key(hdata, "stacktrace");
+				if (ret < 0)
+					goto error;
 				ret = start_new_row(hdata);
 				state = HIST_STACK;
 				break;
@@ -679,20 +840,18 @@ tracefs_hist_data_parse(const char *buffer, const char **next_buffer, char **err
 		case HIST_KEYS:
 			switch (type) {
 			case KEY_TYPE:
-				if (first) {
-					ret = do_key_type(hdata, text);
-					if (ret < 0)
-						goto error;
-				}
+				inc_key_test(hdata);
+				ret = test_key(hdata, text);
+				if (ret < 0)
+					goto error;
 				ret = start_new_key(hdata);
 				state = HIST_KEY_VALS;
 				break;
 			case STACKTRACE:
-				if (first) {
-					ret = do_key_type(hdata, "stacktrace");
-					if (ret < 0)
-						goto error;
-				}
+				inc_key_test(hdata);
+				ret = test_key(hdata, "stacktrace");
+				if (ret < 0)
+					goto error;
 				ret = start_new_key(hdata);
 				state = HIST_STACK;
 				break;
-- 
2.30.2

