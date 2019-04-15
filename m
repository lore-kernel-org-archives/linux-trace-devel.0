Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A94AC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E302084B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfDOXA1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 19:00:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37020 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfDOXA0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 19:00:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id v14so22505157wmf.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 16:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CHU5lSZgpQFpIBBPX7Gv5pNWwyUFiIyTWV+HcHDTf04=;
        b=oQqPO+ApW18nbOlCqOeTObVX/90gINLjEf67vxz5sU7zHhleGjTxD8wrCQZwfLhYG4
         Rkrjf+J8ZxJI1NdRqu3xKudnPdwZsQ44yzHtW9sIipoSPxMgVP0Kly5es4F4Jud9M00m
         RFojipk7ZKV9aAwtTnlFtdXv6wSJpLtnhgm4IcyZHU2jPqN5Bo77BgFhL6iiPlDjip+K
         dkPoG6eCJf6B/nAOy6flJc7keRvi4DAIU1vAL5I5r4kE5dk33+4e7EwluMdNwwFnIR75
         RDNylrWOpPAyuKtrbRPINvEpPxsu4CYZohm6g/ZZaa/ioEfVX89QpNt2KnAzcrvrwSM+
         AMsA==
X-Gm-Message-State: APjAAAW33K48kHZRpfWbqsT0jt4LGjbv9Obymebr8uCoYpVuyp1X0yH7
        CkP3WCtB5OQkIPjglDUSNw==
X-Google-Smtp-Source: APXvYqxdFSBXJYRiksanBb6I68c1yF8clgsGvO7kmwEB7tig4RMyJxtNWlYWnxtyx8e0NQHZhB12Xw==
X-Received: by 2002:a1c:3982:: with SMTP id g124mr23659734wma.25.1555369224559;
        Mon, 15 Apr 2019 16:00:24 -0700 (PDT)
Received: from localhost.localdomain ([151.251.250.145])
        by smtp.gmail.com with ESMTPSA id v184sm36426455wma.6.2019.04.15.16.00.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 16:00:23 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: [PATCH v3 1/2] trace-cmd: Optimize how pid filters are expressed
Date:   Tue, 16 Apr 2019 02:00:15 +0300
Message-Id: <20190415230016.13932-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190415230016.13932-1-kaslevs@vmware.com>
References: <20190415230016.13932-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Express pid filters as allowed/disallowed filter ranges

  (pid>=100&&pid<=103)

instead of specifying them per pid

  (pid==100||pid==101||pid==102||pid==103)

This makes the size of the resulting filter smaller (and faster) and avoids
overflowing the filter size limit of one page which we can hit on bigger
machines (say >160 CPUs).

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
Reported-by: Phil Auld <pauld@redhat.com>
Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 117 +++++++++++++++++++++++++++-------------
 1 file changed, 80 insertions(+), 37 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 76ca92d..dae0396 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -950,10 +950,63 @@ static void update_ftrace_pids(int reset)
 static void update_event_filters(struct buffer_instance *instance);
 static void update_pid_event_filters(struct buffer_instance *instance);
 
+static void append_filter_pid_range(char **filter, int *curr_len,
+				    const char *field,
+				    int start_pid, int end_pid, bool exclude)
+{
+	const char *op = "", *op1, *op2, *op3;
+	int len;
+
+	if (*filter && **filter)
+		op = exclude ? "&&" : "||";
+
+	/* Handle thus case explicitly so that we get `pid==3` instead of
+	 * `pid>=3&&pid<=3` for singleton ranges
+	 */
+	if (start_pid == end_pid) {
+#define FMT	"%s(%s%s%d)"
+		len = snprintf(NULL, 0, FMT, op,
+			       field, exclude ? "!=" : "==", start_pid);
+		*filter = realloc(*filter, *curr_len + len + 1);
+		if (!*filter)
+			die("realloc");
+
+		len = snprintf(*filter + *curr_len, len + 1, FMT, op,
+			       field, exclude ? "!=" : "==", start_pid);
+		*curr_len += len;
+
+		return;
+#undef FMT
+	}
+
+	if (exclude) {
+		op1 = "<";
+		op2 = "||";
+		op3 = ">";
+	} else {
+		op1 = ">=";
+		op2 = "&&";
+		op3 = "<=";
+	}
+
+#define FMT	"%s(%s%s%d%s%s%s%d)"
+	len = snprintf(NULL, 0, FMT, op,
+		       field, op1, start_pid, op2,
+		       field, op3, end_pid);
+	*filter = realloc(*filter, *curr_len + len + 1);
+	if (!*filter)
+		die("realloc");
+
+	len = snprintf(*filter + *curr_len, len + 1, FMT, op,
+		       field, op1, start_pid, op2,
+		       field, op3, end_pid);
+	*curr_len += len;
+}
+
 /**
  * make_pid_filter - create a filter string to all pids against @field
  * @curr_filter: Append to a previous filter (may realloc). Can be NULL
- * @field: The fild to compare the pids against
+ * @field: The field to compare the pids against
  *
  * Creates a new string or appends to an existing one if @curr_filter
  * is not NULL. The new string will contain a filter with all pids
@@ -963,54 +1016,44 @@ static void update_pid_event_filters(struct buffer_instance *instance);
  */
 static char *make_pid_filter(char *curr_filter, const char *field)
 {
+	int curr_len = 0, last_exclude = -1;
+	int start_pid = -1, last_pid = -1;
+	char *filter = NULL, *save;
 	struct filter_pids *p;
-	char *filter;
-	char *orit;
-	char *match;
-	char *str;
-	int curr_len = 0;
-	int len;
 
 	/* Use the new method if possible */
 	if (have_set_event_pid)
 		return NULL;
 
-	len = len_filter_pids + (strlen(field) + strlen("(==)||")) * nr_filter_pids;
-
-	if (curr_filter) {
-		curr_len = strlen(curr_filter);
-		filter = realloc(curr_filter, curr_len + len + strlen("(&&())"));
-		if (!filter)
-			die("realloc");
-		memmove(filter+1, curr_filter, curr_len);
-		filter[0] = '(';
-		strcat(filter, ")&&(");
-		curr_len = strlen(filter);
-	} else
-		filter = malloc(len);
-	if (!filter)
-		die("Failed to allocate pid filter");
-
-	/* Last '||' that is not used will cover the \0 */
-	str = filter + curr_len;
+	if (!filter_pids)
+		return curr_filter;
 
 	for (p = filter_pids; p; p = p->next) {
-		if (p->exclude) {
-			match = "!=";
-			orit = "&&";
-		} else {
-			match = "==";
-			orit = "||";
+		/* PIDs are inserted in `filter_pids` from the front and that's
+		 * why we expect them in descending order here.
+		 */
+		if (p->pid == last_pid - 1 && p->exclude == last_exclude) {
+			last_pid = p->pid;
+			continue;
 		}
-		if (p == filter_pids)
-			orit = "";
 
-		len = sprintf(str, "%s(%s%s%d)", orit, field, match, p->pid);
-		str += len;
+		if (start_pid != -1)
+			append_filter_pid_range(&filter, &curr_len, field,
+						last_pid, start_pid,
+						last_exclude);
+
+		start_pid = last_pid = p->pid;
+		last_exclude = p->exclude;
+
 	}
+	append_filter_pid_range(&filter, &curr_len, field,
+				last_pid, start_pid, last_exclude);
 
-	if (curr_len)
-		sprintf(str, ")");
+	if (curr_filter) {
+		save = filter;
+		asprintf(&filter, "(%s)&&(%s)", curr_filter, filter);
+		free(save);
+	}
 
 	return filter;
 }
-- 
2.19.1

