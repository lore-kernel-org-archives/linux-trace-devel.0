Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76A4C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9034B2085A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfCHObe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:31:34 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52667 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfCHObe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:31:34 -0500
Received: by mail-wm1-f68.google.com with SMTP id f65so12741711wma.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 06:31:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3uXkHmgoem1W6QSbvVaB2yCFnWFJS+wkZ5OZzrrk0Tw=;
        b=eZqt5v+BMVbAQZDbI7pasEEJq6cca5Y4zLgq8iFtlEQNMKJvv0dAK0cA7/lKn7MGve
         hUi1A1unQH4WPDtR7Rw4ICiRGtMMsuD6kEh/zWwJ2jWwQYuTr9kPiJcOEDtDiwRTNqvT
         qCRvHsKZsevMm19vP5vlN5mCgyM5gkbXzVn6N0lPThmG3a0e4B4MDZFWOhcyVZFVcrYf
         LToWq1ypQ1+LIW448Yfz8RJqIZ644u1UE2e7OZDpm1VgZMuPJXpxcooh+QlNFqRTSW9a
         iP8dF/cipxhNEvDLCn5pmTDqL/vvhEIlMe7n/5E0En05d+bcFfHC58SET0D2jDdaceXX
         E56Q==
X-Gm-Message-State: APjAAAVqyaegnqYnPLok5ubY/nRD7QwGyeOfb8gS5DOUe+kr+mC79abU
        RgzNUkvZ/vkG17yFdjqENgZ63qpU
X-Google-Smtp-Source: APXvYqz5PDVSBymv/EGQYOvGLiaKgbAtMPXZQjbuNnmJhISLlSnWZzc+ekxmw5NS4G3tyUh2BzqWDQ==
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr9568154wmh.53.1552055492081;
        Fri, 08 Mar 2019 06:31:32 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t3sm13495654wmc.20.2019.03.08.06.31.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 06:31:31 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 5/7] trace-cmd: Reafctored add_event_pid()to utilize write_instance_file()
Date:   Fri,  8 Mar 2019 16:31:23 +0200
Message-Id: <20190308143125.31168-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308143125.31168-1-tstoyanov@vmware.com>
References: <20190308143125.31168-1-tstoyanov@vmware.com>
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

