Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D16C4320A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B09C8610FD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhHJUsv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231894AbhHJUss (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 679F7610CC;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hAE-5n; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4/9] libtracefs: Add API tracefs_hist_data_read()
Date:   Tue, 10 Aug 2021 16:48:13 -0400
Message-Id: <20210810204818.880714-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810204818.880714-1-rostedt@goodmis.org>
References: <20210810204818.880714-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Adds an API to read a "hist" file of a trace event and create a list of
tracefs_hist_data descriptors for every histogram that exists in the
"hist" file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h       |  7 ++++
 src/tracefs-hist-data.c | 74 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 6bd40d72cb25..f1e4ffa0d65f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -418,7 +418,14 @@ struct tracefs_hist_data;
 struct tracefs_hist_data *tracefs_hist_data_parse(const char *buffer,
 						  const char **next_buffer,
 						  char **err);
+
+struct tracefs_hist_data **tracefs_hist_data_read(struct tracefs_instance *instance,
+						  const char *system,
+						  const char *event,
+						  char **err);
+
 void tracefs_hist_data_free(struct tracefs_hist_data *hdata);
+void tracefs_hist_data_free_list(struct tracefs_hist_data **hdata_list);
 
 struct tracefs_synth;
 
diff --git a/src/tracefs-hist-data.c b/src/tracefs-hist-data.c
index c7e110559ee8..ab1ae824f59b 100644
--- a/src/tracefs-hist-data.c
+++ b/src/tracefs-hist-data.c
@@ -718,6 +718,24 @@ void tracefs_hist_data_free(struct tracefs_hist_data *hdata)
 	free(hdata);
 }
 
+/**
+ * tracefs_hist_data_free_list - frees a list of created hist data descriptors
+ * @hdata_list: The tracefs_hist_data descriptor list to free.
+ *
+ * Frees the data allocated by tracefs_hist_data_read().
+ */
+void tracefs_hist_data_free_list(struct tracefs_hist_data **hdata_list)
+{
+	int i;
+
+	if (!hdata_list)
+		return;
+
+	for (i = 0; hdata_list[i]; i++)
+		tracefs_hist_data_free(hdata_list[i]);
+	free(hdata_list);
+}
+
 /* Used for debugging in gdb */
 static void breakpoint(char *text)
 {
@@ -1019,3 +1037,59 @@ tracefs_hist_data_parse(const char *buffer, const char **next_buffer, char **err
 	tracefs_hist_data_free(hdata);
 	return NULL;
 }
+
+/**
+ * tracefs_hist_data_read - Reads and parses the trace event "hist" file
+ * @instance: The instance the trace event is in (NULL for top level)
+ * @system: The system of the @event (NULL to pick first event)
+ * @event: The trace event name to read the hist file from
+ * @err: On parsing errors, @err will be set to a message explaining what failed.
+ *
+ * Reads the content of a trace @event hist file and parses it.
+ *
+ * Returns an array of tracefs_hist_data descriptors, as a hist file
+ * may contain more than one histogram. Must be freed with
+ * tracefs_hist_data_free_list().
+ *
+ * Returns NULL on error, and if there was a parsing error, @err will contain
+ * a message explaining what failed.
+ */
+struct tracefs_hist_data **
+tracefs_hist_data_read(struct tracefs_instance *instance,
+		       const char *system, const char *event, char **err)
+{
+	struct tracefs_hist_data **tmp, **hdata_list = NULL;
+	const char *buffer;
+	char *content;
+	int cnt = 0;
+
+	if (err)
+		*err = NULL;
+
+	content = tracefs_event_file_read(instance, system, event, "hist", NULL);
+	if (!content)
+		return NULL;
+
+	buffer = content;
+	do {
+		tmp = realloc(hdata_list, sizeof(*tmp) * (cnt + 2));
+		if (!tmp)
+			goto error;
+		tmp[cnt + 1] = NULL;
+		tmp[cnt] = tracefs_hist_data_parse(buffer, &buffer, err);
+		if (!tmp[cnt])
+			goto error;
+		hdata_list = tmp;
+		if (buffer)
+			cnt++;
+	} while (buffer);
+
+	free(content);
+	return hdata_list;
+
+ error:
+	free(content);
+	tracefs_hist_data_free_list(hdata_list);
+	return NULL;
+}
+
-- 
2.30.2

