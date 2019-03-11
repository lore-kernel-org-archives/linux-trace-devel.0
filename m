Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E29CC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC3520643
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfCKIdt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 04:33:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33259 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbfCKIdt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 04:33:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id i8so4037862wrm.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 01:33:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mPynn1eM53ByCP+zSRSpTpmiYsR8i5WpVTZY9CcWqRg=;
        b=QtFwKrwpcFvfKzi33r08m7KqDqRldXdPIJfj26tdWqsEkbXbgtWkoyCFzZhU9CWWzY
         xB2CKGpSZcYgEL57itggj35G+Q9+dALbYAIZTezP4Sbkx/bXs1FyaI35KzRY/hzZf2Gr
         SYez2N9s7kkt8T9wcEHZP4/I63U5P7P2AFyjztPyaRvyxzKjjJPgd/Dso62ztibToRRS
         y77/K+L6/9mG4cBwtI6m5pV/wg8DF003q/KG84Njoc9KhaQXnk7qGHdBKVXO/M7dvso7
         O9HgsggCKlxBnG+cFQYQrMrXNkG+8j4PvpYfjOOhG/apaVBx1BG6bBkoXqex9NrSbZvZ
         tvrg==
X-Gm-Message-State: APjAAAWgItiRdAlYtRCVyaAwZSgZmrAPxwM/BmsOP0504bHukNHIsRl3
        U2KLTW+yKccdvjj3shrt7BXeccPU
X-Google-Smtp-Source: APXvYqyuco/yHjiA5csKAzbWw67Efh2cS5AUvamMKocf8SVqUpYdVKiwhxcS0WgTtIx8/Vg5cpdrJA==
X-Received: by 2002:adf:e988:: with SMTP id h8mr5108747wrm.260.1552293227378;
        Mon, 11 Mar 2019 01:33:47 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x17sm19683835wrd.95.2019.03.11.01.33.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 01:33:46 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 6/6] trace-cmd: Reafctored reset_max_latency() to utilize write_instance_file()
Date:   Mon, 11 Mar 2019 10:33:39 +0200
Message-Id: <20190311083339.21581-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190311083339.21581-1-tstoyanov@vmware.com>
References: <20190311083339.21581-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch changes reset_max_latency() to utilize write_instance_file() for
writing set_event_pid instance file, instead of directly opening it. It also
changes the function to work per instance.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 99 ++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 50 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bdf0c02..dfbb0cd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -814,19 +814,49 @@ static void clear_trace(void)
 	fclose(fp);
 }
 
-static void reset_max_latency(void)
+static int write_file(const char *file, const char *str, const char *type)
+{
+	char buf[BUFSIZ];
+	int fd;
+	int ret;
+
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
+		close(fd);
+	}
+	return ret;
+}
+
+static int
+write_instance_file(struct buffer_instance *instance,
+		    const char *file, const char *str, const char *type)
 {
-	FILE *fp;
 	char *path;
+	int ret;
 
-	/* reset the trace */
-	path = tracecmd_get_tracing_file("tracing_max_latency");
-	fp = fopen(path, "w");
-	if (!fp)
-		die("writing to '%s'", path);
+	path = get_instance_file(instance, file);
+	ret = write_file(path, str, type);
 	tracecmd_put_tracing_file(path);
-	fwrite("0", 1, 1, fp);
-	fclose(fp);
+
+	return ret;
+}
+
+static void reset_max_latency(struct buffer_instance *instance)
+{
+	 write_instance_file(instance,
+			     "tracing_max_latency", "0", "max_latency");
 }
 
 static void add_filter_pid(int pid, int exclude)
@@ -1094,45 +1124,6 @@ static void update_sched_events(struct buffer_instance *instance, int pid)
 static int open_instance_fd(struct buffer_instance *instance,
 			    const char *file, int flags);
 
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
 static void add_event_pid(const char *buf)
 {
 	struct buffer_instance *instance;
@@ -1931,6 +1922,14 @@ static int read_tracing_on(struct buffer_instance *instance)
 	return ret;
 }
 
+static void reset_max_latency_instance(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		reset_max_latency(instance);
+}
+
 void tracecmd_enable_tracing(void)
 {
 	struct buffer_instance *instance;
@@ -1941,7 +1940,7 @@ void tracecmd_enable_tracing(void)
 		write_tracing_on(instance, 1);
 
 	if (latency)
-		reset_max_latency();
+		reset_max_latency_instance();
 }
 
 void tracecmd_disable_tracing(void)
@@ -3801,7 +3800,6 @@ static void reset_event_pid(void)
 	add_event_pid("");
 }
 
-
 static void clear_triggers(void)
 {
 	struct buffer_instance *instance;
@@ -4506,6 +4504,7 @@ void trace_reset(int argc, char **argv)
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
+	reset_max_latency_instance();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
-- 
2.20.1

