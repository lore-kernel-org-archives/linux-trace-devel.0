Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E636DC282CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 23:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1D722086D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 23:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfDLXCA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 19:02:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44127 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfDLXCA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 19:02:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id y7so13833500wrn.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 16:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ao6zWk6qYGFp5j5rhez4Bd2z0+mxECaw8ki2sBhUyRA=;
        b=bWm2aMZXJGx+jv+Mf67VFZy79q2GTYXcqZWpTH/hKyOghlG62bIX29xOUzzhNeA1Ag
         pVQeKfSaj7NyVrQSFOUl1j0lDNWnQAHrbAhBc/TgBQCDx+qXSN78Ed/yOLIniBA27dZF
         pjU1qCT9kXWADkNIttRcl7kO7EZmqvp+HrhYWRrLjCcrH8OfPYr91d5SkKZzRZsLNhCZ
         tuSpOXPw1YeuO3SgYr6poKpFsH9t9HJkGBDIc+EaKzQg/hgszLc567RPDGUXfJMjz1ei
         LzjM7lc+hMBaZbOWSXS0v7O8OJPE34cTG4PdT1sAtqbE0hcvlGg0hhEjSTQE+bGVVH68
         qinA==
X-Gm-Message-State: APjAAAV8flgYywkxhG2T/zMuYH1kO2oJfeObbXmfcPaLdkj/CVxbf3pE
        terbsA1IFYZbezemVKxqe3WY+vTGCA==
X-Google-Smtp-Source: APXvYqzAxOl9XXuAOfZ1qScr7N5yEU9luagN5lqX+tB8g5A8Cbde0crvrCS+VR2C59ewE2SLP+lI/w==
X-Received: by 2002:a5d:618b:: with SMTP id j11mr34521600wru.123.1555110118712;
        Fri, 12 Apr 2019 16:01:58 -0700 (PDT)
Received: from localhost.localdomain ([151.251.243.36])
        by smtp.gmail.com with ESMTPSA id g19sm8563686wmh.17.2019.04.12.16.01.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 16:01:58 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com
Subject: [PATCH] .
Date:   Sat, 13 Apr 2019 02:01:50 +0300
Message-Id: <20190412230150.26462-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190412111546.0c54576e@gandalf.local.home>
References: <20190412111546.0c54576e@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 110 +++++++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 36 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 76ca92d..102e5ab 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -950,6 +950,57 @@ static void update_ftrace_pids(int reset)
 static void update_event_filters(struct buffer_instance *instance);
 static void update_pid_event_filters(struct buffer_instance *instance);
 
+static void append_filter_pid_range(char **filter, int *curr_len,
+				    const char *field,
+				    int start_pid, int end_pid, bool exclude)
+{
+	char *op, *op1, *op2, *op3;
+	int len;
+
+	op = *filter && **filter ? "||" : "";
+
+	// Handle thus case explicitly so that we get `pid==3` instead of
+	// `pid>=3&&pid<=3` for singleton ranges
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
@@ -963,54 +1014,41 @@ static void update_pid_event_filters(struct buffer_instance *instance);
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
+						start_pid, last_pid,
+						last_exclude);
+
+		start_pid = last_pid = p->pid;
+		last_exclude = p->exclude;
+
 	}
+	append_filter_pid_range(&filter, &curr_len, field,
+				start_pid, last_pid, last_exclude);
 
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

