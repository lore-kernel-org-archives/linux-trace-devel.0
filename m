Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F08C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2763720661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfCHNoO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:14 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38506 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfCHNoN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:13 -0500
Received: by mail-wr1-f67.google.com with SMTP id g12so21415647wrm.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3uXkHmgoem1W6QSbvVaB2yCFnWFJS+wkZ5OZzrrk0Tw=;
        b=H8bf4OAodWoHZsIAUGWqQk4h4XPeM3V9ZHCjeNNy2tNDCNof9m8LQOOVxj1FWF6Emo
         mr9KSQjrG8F69/RM1IsXPuuI7MA/kgyOJ0Tq33BxPocilqkeevfaMoTyRw7HTRO6CDuS
         cwuUU7PYf/vouSUHZ3btzKRP+5GXyrcVt5BoyHAQFICBMUnBUZQvOuDzGxmX1CpBUoqb
         oenJqQAnEoI38nCCGuPx10IdSL2gZzSq4WE+aMzYdeSD3YyGnBs+/ScEqgLZdDofpfRE
         kOyjHax+YlqEkJHQJ6f9klJlFFiQQjh2eCkesX9bLw7AbnYKJjD2129dm+h+4/RkF4Sn
         03gA==
X-Gm-Message-State: APjAAAWehlLT1ilj+D2zALnjMivQjhXilQgR5/2eAvxYU+sM6WOhZtPe
        /KNS+QvoVtSiQcoiOs5y9ZaHuOg3
X-Google-Smtp-Source: APXvYqxoSR2o8M6621AjBgva4wrVSlW1jjmVnJjREzlmtpdMir6kV0vXEPp1hx9lO9yXeApLlS9Tkg==
X-Received: by 2002:adf:f80e:: with SMTP id s14mr11277650wrp.327.1552052651636;
        Fri, 08 Mar 2019 05:44:11 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t16sm5650943wmj.47.2019.03.08.05.44.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:10 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/6] trace-cmd: Reafctored add_event_pid()to utilize write_instance_file()
Date:   Fri,  8 Mar 2019 15:44:03 +0200
Message-Id: <20190308134405.21921-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308134405.21921-1-tstoyanov@vmware.com>
References: <20190308134405.21921-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch changes add_event_pid() to utilize write_instance_file() for
writing set_event_pid instance file, instead of directly opening it.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 89 +++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6972b9f..a398723 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1094,30 +1094,64 @@ static void update_sched_events(struct buffer_instance *instance, int pid)
 static int open_instance_fd(struct buffer_instance *instance,
 			    const char *file, int flags);
 
-static void add_event_pid(const char *buf, int len)
+static int write_file(const char *file, const char *str, const char *type)
 {
-	struct buffer_instance *instance;
+	char buf[BUFSIZ];
 	int fd;
+	int ret;
 
-	for_all_instances(instance) {
-		fd = open_instance_fd(instance, "set_event_pid", O_WRONLY);
-		write(fd, buf, len);
+	fd = open(file, O_WRONLY | O_TRUNC);
+	if (fd < 0)
+		die("opening to '%s'", file);
+	ret = write(fd, str, strlen(str));
+	close(fd);
+	if (ret < 0 && type) {
+		/* write failed */
+		fd = open(file, O_RDONLY);
+		if (fd < 0)
+			die("writing to '%s'", file);
+		/* the filter has the error */
+		while ((ret = read(fd, buf, BUFSIZ)) > 0)
+			fprintf(stderr, "%.*s", ret, buf);
+		die("Failed %s of %s\n", type, file);
 		close(fd);
 	}
+	return ret;
+}
+
+static int
+write_instance_file(struct buffer_instance *instance,
+		    const char *file, const char *str, const char *type)
+{
+	char *path;
+	int ret;
+
+	path = get_instance_file(instance, file);
+	ret = write_file(path, str, type);
+	tracecmd_put_tracing_file(path);
+
+	return ret;
+}
+
+static void add_event_pid(const char *buf)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		write_instance_file(instance, "set_event_pid", buf, "event_pid");
 }
 
 static void add_new_filter_pid(int pid)
 {
 	struct buffer_instance *instance;
 	char buf[100];
-	int len;
 
 	add_filter_pid(pid, 0);
-	len = sprintf(buf, "%d", pid);
+	sprintf(buf, "%d", pid);
 	update_ftrace_pid(buf, 0);
 
 	if (have_set_event_pid)
-		return add_event_pid(buf, len);
+		return add_event_pid(buf);
 
 	common_pid_filter = append_pid_filter(common_pid_filter, "common_pid", pid);
 
@@ -1596,45 +1630,6 @@ static void reset_events(void)
 		reset_events_instance(instance);
 }
 
-static int write_file(const char *file, const char *str, const char *type)
-{
-	char buf[BUFSIZ];
-	int fd;
-	int ret;
-
-	fd = open(file, O_WRONLY | O_TRUNC);
-	if (fd < 0)
-		die("opening to '%s'", file);
-	ret = write(fd, str, strlen(str));
-	close(fd);
-	if (ret < 0 && type) {
-		/* write failed */
-		fd = open(file, O_RDONLY);
-		if (fd < 0)
-			die("writing to '%s'", file);
-		/* the filter has the error */
-		while ((ret = read(fd, buf, BUFSIZ)) > 0)
-			fprintf(stderr, "%.*s", ret, buf);
-		die("Failed %s of %s\n", type, file);
-		close(fd);
-	}
-	return ret;
-}
-
-static int
-write_instance_file(struct buffer_instance *instance,
-		    const char *file, const char *str, const char *type)
-{
-	char *path;
-	int ret;
-
-	path = get_instance_file(instance, file);
-	ret = write_file(path, str, type);
-	tracecmd_put_tracing_file(path);
-
-	return ret;
-}
-
 enum {
 	STATE_NEWLINE,
 	STATE_SKIP,
-- 
2.20.1

