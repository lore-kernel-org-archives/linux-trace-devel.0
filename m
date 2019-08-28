Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D823C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08E552339E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vJ4sZINh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfH1I54 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:57:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37925 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfH1I54 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:57:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id o184so1151112wme.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 01:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kMzqp+bMChPRFBScO3nEZo1UAkgmucpEFNlaVmBUOCc=;
        b=vJ4sZINh+soDfY5fclwXCIz1CVoWbBkftaq9xEeRQ7e68atvNIiHLAE+grmTrQjHlx
         sE5MJwcEgPnbQ2mf25VoBdS38xnCIk+GTNMFMrLYnZQQZtZq1gMq+8zWwmKXIZ3cL5Ye
         8pEM0ujsKbkcB3pfEdm028GSNHurmDtMthwMgUcfStrs+DhL/RY8U76JhnvCtZK2cpgv
         LHpwlXM+PhyGkdBHufCur/ySxkIysXUhjMc3h2WErtmip6uGE/0v7+K1+u4lFy87pbsP
         /JpcoE7woCsbs/rDFgQeOxOA74aQDAqxgyvuT2DuQxlR+0CphO7fKtDbON+6NudT5VeJ
         6NeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kMzqp+bMChPRFBScO3nEZo1UAkgmucpEFNlaVmBUOCc=;
        b=XpnWCQVsIV9c1UlNhY5O65LjftM+qS7hpH8hNsN6hHgSvourXOMo3GBIDBvqA297BK
         AGGee1UzlnEOsvP8fY+IR31j+oCLDewRRJTwvKTdHrfXKSQSHRQJxXvThhhmmJwzp+dt
         gtNAf6PBEzHTdAQAd+5s0epfLr8gJ+ZZyEkZT4UJBiUU66okpT1VsDXMHVi5vqrCojS2
         CCfRbinNDPakQaXrctS5ASfPw+U9x9Vc1HzniSvKd6BnE8Z8hwtG9g1yT9LsI7ZhXkqH
         MB+V2tVLveLJshagPHORk82Wd2E3pdwCPneOWEz2BuNfq7b4VHPgfdtYLWvytuouPUus
         gGPA==
X-Gm-Message-State: APjAAAU1R3loCK6rzMlUX44vJd1bIvafL4WYgk0/Vp9QotLjbpGln5ZK
        wL6mOp7pG35f6TM9QCjX2FozafLP
X-Google-Smtp-Source: APXvYqys8Wi+iBeflzi8b/Twq8OnYBlAEOHxqXYKIM3Phf1blQWi6rOwVxT6VtM71SPEQ8V09UPFFQ==
X-Received: by 2002:a1c:e710:: with SMTP id e16mr3579655wmh.38.1566982673487;
        Wed, 28 Aug 2019 01:57:53 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u186sm2579433wmu.26.2019.08.28.01.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 01:57:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 5/9] trace-cmd: Refactored few functions in trace-record.c
Date:   Wed, 28 Aug 2019 11:57:42 +0300
Message-Id: <20190828085746.26231-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828085746.26231-1-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

In order to reuse the code inside the trace-cmd application, few
functions from trace-record.c are refactored:
  - make_instances() and tracecmd_remove_instances() are splited.
New ones are created: tracecmd_make_instance() and tracecmd_remove_instance(),
which are visible outside the trace-record.c
  - Following functions are made non-static: tracecmd_init_instance()
get_instance_dir(), write_instance_file(), write_tracing_on(),
tracecmd_set_clock()
  - New function is implemented: tracecmd_local_cpu_count(), an internal
API to get local_cpu_count.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/include/trace-local.h |  9 ++++
 tracecmd/trace-record.c        | 88 +++++++++++++++++++---------------
 2 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 29d0bf8..1d305bf 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -237,6 +237,15 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
+void write_tracing_on(struct buffer_instance *instance, int on);
+char *get_instance_dir(struct buffer_instance *instance);
+int write_instance_file(struct buffer_instance *instance,
+			const char *file, const char *str, const char *type);
+void tracecmd_init_instance(struct buffer_instance *instance);
+void tracecmd_make_instance(struct buffer_instance *instance);
+int tracecmd_local_cpu_count(void);
+void tracecmd_set_clock(struct buffer_instance *instance);
+void tracecmd_remove_instance(struct buffer_instance *instance);
 
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e844029..db1d37a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -186,7 +186,7 @@ static inline int no_top_instance(void)
 	return first_instance != &top_instance;
 }
 
-static void init_instance(struct buffer_instance *instance)
+void tracecmd_init_instance(struct buffer_instance *instance)
 {
 	instance->event_next = &instance->events;
 }
@@ -311,7 +311,7 @@ static void reset_save_file_cond(const char *file, int prio,
  */
 void add_instance(struct buffer_instance *instance, int cpu_count)
 {
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 	instance->next = buffer_instances;
 	if (first_instance == buffer_instances)
 		first_instance = instance;
@@ -498,7 +498,7 @@ static void add_event(struct buffer_instance *instance, struct event_list *event
 static void reset_event_list(struct buffer_instance *instance)
 {
 	instance->events = NULL;
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 }
 
 static char *get_temp_file(struct buffer_instance *instance, int cpu)
@@ -804,8 +804,7 @@ get_instance_file(struct buffer_instance *instance, const char *file)
 	return path;
 }
 
-static char *
-get_instance_dir(struct buffer_instance *instance)
+char *get_instance_dir(struct buffer_instance *instance)
 {
 	char *buf;
 	char *path;
@@ -849,9 +848,8 @@ static int write_file(const char *file, const char *str, const char *type)
 	return ret;
 }
 
-static int
-write_instance_file(struct buffer_instance *instance,
-		    const char *file, const char *str, const char *type)
+int write_instance_file(struct buffer_instance *instance,
+			const char *file, const char *str, const char *type)
 {
 	char *path;
 	int ret;
@@ -1993,7 +1991,7 @@ static int open_tracing_on(struct buffer_instance *instance)
 	return fd;
 }
 
-static void write_tracing_on(struct buffer_instance *instance, int on)
+void write_tracing_on(struct buffer_instance *instance, int on)
 {
 	int ret;
 	int fd;
@@ -2320,7 +2318,7 @@ void tracecmd_enable_events(void)
 	enable_events(first_instance);
 }
 
-static void set_clock(struct buffer_instance *instance)
+void tracecmd_set_clock(struct buffer_instance *instance)
 {
 	char *path;
 	char *content;
@@ -4471,49 +4469,58 @@ static void clear_func_filters(void)
 	}
 }
 
-static void make_instances(void)
+void tracecmd_make_instance(struct buffer_instance *instance)
 {
-	struct buffer_instance *instance;
 	struct stat st;
 	char *path;
 	int ret;
 
+	path = get_instance_dir(instance);
+	ret = stat(path, &st);
+	if (ret < 0) {
+		ret = mkdir(path, 0777);
+		if (ret < 0)
+			die("mkdir %s", path);
+	} else
+		/* Don't delete instances that already exist */
+		instance->flags |= BUFFER_FL_KEEP;
+	tracecmd_put_tracing_file(path);
+
+}
+
+static void make_instances(void)
+{
+	struct buffer_instance *instance;
+
 	for_each_instance(instance) {
 		if (is_guest(instance))
 			continue;
+		tracecmd_make_instance(instance);
+	}
+}
 
-		path = get_instance_dir(instance);
-		ret = stat(path, &st);
-		if (ret < 0) {
-			ret = mkdir(path, 0777);
-			if (ret < 0)
-				die("mkdir %s", path);
-		} else
-			/* Don't delete instances that already exist */
-			instance->flags |= BUFFER_FL_KEEP;
-		tracecmd_put_tracing_file(path);
+void tracecmd_remove_instance(struct buffer_instance *instance)
+{
+	char *path;
+
+	if (instance->tracing_on_fd > 0) {
+		close(instance->tracing_on_fd);
+		instance->tracing_on_fd = 0;
 	}
+	path = get_instance_dir(instance);
+	rmdir(path);
+	tracecmd_put_tracing_file(path);
 }
 
 void tracecmd_remove_instances(void)
 {
 	struct buffer_instance *instance;
-	char *path;
-	int ret;
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
 		if (is_guest(instance) || (instance->flags & BUFFER_FL_KEEP))
 			continue;
-		if (instance->tracing_on_fd > 0) {
-			close(instance->tracing_on_fd);
-			instance->tracing_on_fd = 0;
-		}
-		path = get_instance_dir(instance);
-		ret = rmdir(path);
-		if (ret < 0)
-			die("rmdir %s", path);
-		tracecmd_put_tracing_file(path);
+		tracecmd_remove_instance(instance);
 	}
 }
 
@@ -5008,7 +5015,7 @@ void trace_stop(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 
 	for (;;) {
 		int c;
@@ -5049,7 +5056,7 @@ void trace_restart(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 
 	for (;;) {
 		int c;
@@ -5091,7 +5098,7 @@ void trace_reset(int argc, char **argv)
 	int topt = 0;
 	struct buffer_instance *instance = &top_instance;
 
-	init_instance(instance);
+	tracecmd_init_instance(instance);
 
 	/* if last arg is -a, then -b and -d apply to all instances */
 	int last_specified_all = 0;
@@ -5175,11 +5182,16 @@ static void init_common_record_context(struct common_record_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
-	init_instance(ctx->instance);
+	tracecmd_init_instance(ctx->instance);
 	local_cpu_count = count_cpus();
 	ctx->instance->cpu_count = local_cpu_count;
 }
 
+int tracecmd_local_cpu_count(void)
+{
+	return local_cpu_count;
+}
+
 #define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
 #define IS_START(ctx) ((ctx)->curr_cmd == CMD_start)
 #define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
@@ -5762,7 +5774,7 @@ static void record_trace(int argc, char **argv,
 	tracecmd_disable_all_tracing(1);
 
 	for_all_instances(instance)
-		set_clock(instance);
+		tracecmd_set_clock(instance);
 
 	/* Record records the date first */
 	if (ctx->date &&
-- 
2.21.0

