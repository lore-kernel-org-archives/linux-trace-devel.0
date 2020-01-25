Return-Path: <SRS0=v841=3O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC7EC35243
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jan 2020 02:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F5E0208C4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jan 2020 02:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387709AbgAYCuf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Jan 2020 21:50:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387675AbgAYCuf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Jan 2020 21:50:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3FAF2075E
        for <linux-trace-devel@vger.kernel.org>; Sat, 25 Jan 2020 02:50:33 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1ivBWq-000tpS-LQ
        for linux-trace-devel@vger.kernel.org; Fri, 24 Jan 2020 21:50:32 -0500
Message-Id: <20200125025032.531690598@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 24 Jan 2020 21:50:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Fix the looping to clear triggers and filters
References: <20200125025008.757057369@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The resetting of filters and triggers did a loop on each trigger and filter
till it was cleared. The point being, it removed one trigger or filter at a
time. This could cause an infinite loop due to some triggers requiring an
"ordering" of removal. When histograms are used with synthetic events, one
histogram will be attached to another histogram, and the remove of the
first histogram will fail to be removed if the second histogram is still
using it.

As the code would just keep iterating on the same trigger file, and that
file would never be cleared due to the histogram dependency, it went into an
infinite loop.

Instead of a loop that would read the file and try to remove the first
trigger, read the entire file at once, then try removing the each of the
the triggers that was read one at a time. After all have been attempted to
be removed, re-read the file. If the file still has data, take note, and
continue to the other files.

After processing all the files, check to see how many files still had data,
then loop through all the files again, doing the same thing, but only do it
the number of times that there was content in the files, as that should
remove all the triggers no matter what the dependency is.

We could optimize this by only reseting the files that still had data in it,
but that would require making full copy of the event_iter then running on
that. As this doesn't happen much, doing a full scan again shoudn't be too
much of an issue. But if it becomes one, then the optimization can still
happen later.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 199 +++++++++++++++++++++++-----------------
 1 file changed, 115 insertions(+), 84 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bfe4f7976cc2..4a49b640b66b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1899,44 +1899,6 @@ enum {
 	STATE_COPY,
 };
 
-static int find_trigger(const char *file, char *buf, int size, int fields)
-{
-	FILE *fp;
-	int state = STATE_NEWLINE;
-	int ch;
-	int len = 0;
-
-	fp = fopen(file, "r");
-	if (!fp)
-		return 0;
-
-	while ((ch = fgetc(fp)) != EOF) {
-		if (ch == '\n') {
-			if (state == STATE_COPY)
-				break;
-			state = STATE_NEWLINE;
-			continue;
-		}
-		if (state == STATE_SKIP)
-			continue;
-		if (state == STATE_NEWLINE && ch == '#') {
-			state = STATE_SKIP;
-			continue;
-		}
-		if (state == STATE_COPY && ch == ':' && --fields < 1)
-			break;
-
-		state = STATE_COPY;
-		buf[len++] = ch;
-		if (len == size - 1)
-			break;
-	}
-	buf[len] = 0;
-	fclose(fp);
-
-	return len;
-}
-
 static char *read_file(const char *file)
 {
 	char stbuf[BUFSIZ];
@@ -2056,34 +2018,63 @@ static void write_trigger(const char *file, const char *trigger)
 		show_error(file, "trigger");
 }
 
-static void write_func_filter(const char *file, const char *trigger)
-{
-	if (write_file(file, trigger) < 0)
-		show_error(file, "function filter");
-}
-
-static void clear_trigger(const char *file)
+static int clear_trigger(const char *file)
 {
 	char trigger[BUFSIZ];
+	char *save = NULL;
+	char *line;
+	char *buf;
 	int len;
+	int ret;
+
+	buf = read_file(file);
+	if (!buf) {
+		perror(file);
+		return 0;
+	}
 
 	trigger[0] = '!';
 
+	for (line = strtok_r(buf, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
+		if (line[0] == '#')
+			continue;
+		len = strlen(line);
+		if (len > BUFSIZ - 2)
+			len = BUFSIZ - 2;
+		strncpy(trigger + 1, line, len);
+		trigger[len + 1] = '\0';
+		/* We don't want any filters or extra on the line */
+		strtok(trigger, " ");
+		write_file(file, trigger);
+	}
+
+	free(buf);
+
 	/*
-	 * To delete a trigger, we need to write a '!trigger'
-	 * to the file for each trigger.
+	 * Some triggers have an order in removing them.
+	 * They will not be removed if done in the wrong order.
 	 */
-	do {
-		len = find_trigger(file, trigger+1, BUFSIZ-1, 3);
-		if (len)
-			write_trigger(file, trigger);
-	} while (len);
+	buf = read_file(file);
+	if (!buf)
+		return 0;
+
+	ret = 0;
+	for (line = strtok(buf, "\n"); line; line = strtok(NULL, "\n")) {
+		if (line[0] == '#')
+			continue;
+		ret = 1;
+		break;
+	}
+	free(buf);
+	return ret;
 }
 
 static void clear_func_filter(const char *file)
 {
-	char trigger[BUFSIZ];
+	char filter[BUFSIZ];
 	struct stat st;
+	char *line;
+	char *buf;
 	char *p;
 	int len;
 	int ret;
@@ -2100,33 +2091,44 @@ static void clear_func_filter(const char *file)
 		die("opening to '%s'", file);
 	close(fd);
 
-	/* Now remove triggers */
-	trigger[0] = '!';
+	buf = read_file(file);
+	if (!buf) {
+		perror(file);
+		return;
+	}
+
+	/* Now remove filters */
+	filter[0] = '!';
 
 	/*
-	 * To delete a trigger, we need to write a '!trigger'
-	 * to the file for each trigger.
+	 * To delete a filter, we need to write a '!filter'
+	 * to the file for each filter.
 	 */
-	do {
-		len = find_trigger(file, trigger+1, BUFSIZ-1, 3);
-		if (len) {
-			/*
-			 * To remove "unlimited" triggers, we must remove
-			 * the ":unlimited" from what we write.
-			 */
-			if ((p = strstr(trigger, ":unlimited"))) {
-				*p = '\0';
-				len = p - trigger;
-			}
-			/*
-			 * The write to this file expects white space
-			 * at the end :-p
-			 */
-			trigger[len] = '\n';
-			trigger[len+1] = '\0';
-			write_func_filter(file, trigger);
+	for (line = strtok(buf, "\n"); line; line = strtok(NULL, "\n")) {
+		if (line[0] == '#')
+			continue;
+		len = strlen(line);
+		if (len > BUFSIZ - 2)
+			len = BUFSIZ - 2;
+
+		strncpy(filter + 1, line, len);
+		filter[len + 1] = '\0';
+		/*
+		 * To remove "unlimited" filters, we must remove
+		 * the ":unlimited" from what we write.
+		 */
+		if ((p = strstr(filter, ":unlimited"))) {
+			*p = '\0';
+			len = p - filter;
 		}
-	} while (len > 0);
+		/*
+		 * The write to this file expects white space
+		 * at the end :-p
+		 */
+		filter[len] = '\n';
+		filter[len+1] = '\0';
+		write_file(file, filter);
+	}
 }
 
 static void update_reset_triggers(void)
@@ -4435,8 +4437,8 @@ void set_buffer_size(void)
 		set_buffer_size_instance(instance);
 }
 
-static void
-process_event_trigger(char *path, struct event_iter *iter, enum event_process *processed)
+static int
+process_event_trigger(char *path, struct event_iter *iter)
 {
 	const char *system = iter->system_dent->d_name;
 	const char *event = iter->event_dent->d_name;
@@ -4459,19 +4461,21 @@ process_event_trigger(char *path, struct event_iter *iter, enum event_process *p
 	if (ret < 0)
 		goto out;
 
-	clear_trigger(trigger);
+	ret = clear_trigger(trigger);
  out:
 	free(trigger);
 	free(file);
+	return ret;
 }
 
 static void clear_instance_triggers(struct buffer_instance *instance)
 {
+	enum event_iter_type type;
 	struct event_iter *iter;
-	char *path;
 	char *system;
-	enum event_iter_type type;
-	enum event_process processed = PROCESSED_NONE;
+	char *path;
+	int retry = 0;
+	int ret;
 
 	path = tracefs_instance_get_file(instance->tracefs, "events");
 	if (!path)
@@ -4479,7 +4483,6 @@ static void clear_instance_triggers(struct buffer_instance *instance)
 
 	iter = trace_event_iter_alloc(path);
 
-	processed = PROCESSED_NONE;
 	system = NULL;
 	while ((type = trace_event_iter_next(iter, path, system))) {
 
@@ -4488,11 +4491,39 @@ static void clear_instance_triggers(struct buffer_instance *instance)
 			continue;
 		}
 
-		process_event_trigger(path, iter, &processed);
+		ret = process_event_trigger(path, iter);
+		if (ret > 0)
+			retry++;
 	}
 
 	trace_event_iter_free(iter);
 
+	if (retry) {
+		int i;
+
+		/* Order matters for some triggers */
+		for (i = 0; i < retry; i++) {
+			int tries = 0;
+
+			iter = trace_event_iter_alloc(path);
+			system = NULL;
+			while ((type = trace_event_iter_next(iter, path, system))) {
+
+				if (type == EVENT_ITER_SYSTEM) {
+					system = iter->system_dent->d_name;
+					continue;
+				}
+
+				ret = process_event_trigger(path, iter);
+				if (ret > 0)
+					tries++;
+			}
+			trace_event_iter_free(iter);
+			if (!tries)
+				break;
+		}
+	}
+
 	tracefs_put_tracing_file(path);
 }
 
-- 
2.24.1


