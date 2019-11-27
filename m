Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBB4C432C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B40120678
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mmGfNhEG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfK0OC7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:02:59 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46204 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfK0OC7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:02:59 -0500
Received: by mail-lf1-f65.google.com with SMTP id a17so17230642lfi.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ldCDagl9RqAknwMP7THNOte9M0qIZeza4fKWvwegzY0=;
        b=mmGfNhEGvUlrI89jMcmxYhYcSfHHvrS+yYzPXmVVw3FRuRLoVGFtC/fcergINOjayD
         H0qjFfCIvtz0hBvvSpgzcryvQbxweiHH3xaNA+Y1bh2KOzSOScwGLPLLi118RET3NX5Z
         bWAlZzab8eFQq0ck4Oq41Khf1gcSNgocda2HJWZ0J0FMOBRnm7vyOeSc4jTMlzNEkZSr
         IW55uXfk57c/X0FUV1C8Bosz9NkAlJwwhKjkDK3MYntXFtsaU4B6hmdvu/JEqxgZUX0B
         x7/zgwY6xU1/98107ecvPalwIbMtV1cb7Q9kn58Vf0a1qb2xGsIK92sEa7PFn5fbQ9Q5
         I8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ldCDagl9RqAknwMP7THNOte9M0qIZeza4fKWvwegzY0=;
        b=eJE3tmrQgCMOSQ66/+UP2aebWF9qzjXCgJBv8ig0yakXLtA4LRo//bznwIIfp2t/7i
         wanuRwQej9TnCeA12cpC/vP6BFdKxhVX+NUe2DbJ0Lxuhwcj1F/fFEuzY94mkO/Jrbvy
         R/bLpE5GWOQxo3tpGe83u9lT55UJboq3H5ePY2IhZbtFwn0/XWuErPc1e9lrwXsmwXRh
         2nhYf9ebM9XB/ZrlGQX+G69XiTvMveDJGVFX2BRQjEYQbbMqZrJAFrh9LeCBGB2GM6nP
         GlxyqDoshE9pBH+pZf0hAEyxilwcYuhMRZGJ21m0nMH8PbfM/86s8afeIN8u98YY9m/Y
         Ch7g==
X-Gm-Message-State: APjAAAU9wgRxvga4+onrE9/wSqf1JcDKOPWbtWpahdZ9RuA2O2lkcI82
        plxA4fLKCpDkqVnxBqizhG9Mfg/NMlM=
X-Google-Smtp-Source: APXvYqxk3Zege4jTqZwMOjs4rzSPXSyMosDGaJAKl68QuydbM+sOr5bM340ZVo3IaoY1gWpjnzUo6A==
X-Received: by 2002:a19:ef10:: with SMTP id n16mr23114147lfh.187.1574863375461;
        Wed, 27 Nov 2019 06:02:55 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:02:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 05/19] trace-cmd: Add new library API for local CPU count
Date:   Wed, 27 Nov 2019 16:02:33 +0200
Message-Id: <20191127140247.258766-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to reuse the code, the function detecting the
number of local CPU is moved from trace-cmd application to
libtracecmd. The following new library API is introduced:
	int tracecmd_count_cpus(void);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h  |  3 +++
 lib/trace-cmd/trace-util.c     | 40 +++++++++++++++++++++++++++++
 tracecmd/include/trace-local.h |  2 --
 tracecmd/trace-agent.c         |  2 +-
 tracecmd/trace-profile.c       |  2 +-
 tracecmd/trace-record.c        | 46 +++-------------------------------
 tracecmd/trace-stat.c          |  4 +--
 7 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5287d23..5d4292e 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -427,6 +427,9 @@ void tracecmd_plog(const char *fmt, ...);
 void tracecmd_plog_error(const char *fmt, ...);
 int tracecmd_set_logfile(char *logfile);
 
+/* --- System --- */
+int tracecmd_count_cpus(void);
+
 /* --- Hack! --- */
 int tracecmd_blk_hack(struct tracecmd_input *handle);
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 7f6a628..1d90ed6 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1109,6 +1109,46 @@ int tracecmd_stack_tracer_status(int *status)
 	return 1; /* full success */
 }
 
+int tracecmd_count_cpus(void)
+{
+	FILE *fp;
+	char buf[1024];
+	int cpus = 0;
+	char *pbuf;
+	size_t *pn;
+	size_t n;
+	int r;
+
+	cpus = sysconf(_SC_NPROCESSORS_CONF);
+	if (cpus > 0)
+		return cpus;
+
+	warning("sysconf could not determine number of CPUS");
+
+	/* Do the hack to figure out # of CPUS */
+	n = 1024;
+	pn = &n;
+	pbuf = buf;
+
+	fp = fopen("/proc/cpuinfo", "r");
+	if (!fp)
+		die("Can not read cpuinfo");
+
+	while ((r = getline(&pbuf, pn, fp)) >= 0) {
+		char *p;
+
+		if (strncmp(buf, "processor", 9) != 0)
+			continue;
+		for (p = buf+9; isspace(*p); p++)
+			;
+		if (*p == ':')
+			cpus++;
+	}
+	fclose(fp);
+
+	return cpus;
+}
+
 /*
  * tracecmd_write_file - Write in trace file
  * @file: Full name of the trace file.
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 3a05e9c..a51f0d0 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -243,8 +243,6 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
-int count_cpus(void);
-
 /* moved from trace-cmd.h */
 void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 93e3edf..1c6e0a3 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -203,7 +203,7 @@ static void agent_serve(unsigned int port)
 
 	signal(SIGCHLD, handle_sigchld);
 
-	nr_cpus = count_cpus();
+	nr_cpus = tracecmd_count_cpus();
 	page_size = getpagesize();
 
 	sd = make_vsock(port);
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 231e381..cfae2a2 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -1314,7 +1314,7 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 	 * system.
 	 */
 	if (!h->cpus)
-		h->cpus = count_cpus();
+		h->cpus = tracecmd_count_cpus();
 
 	list_head_init(&h->migrate_starts);
 	h->cpu_starts = malloc(sizeof(*h->cpu_starts) * h->cpus);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 13a7cda..4459c90 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2726,46 +2726,6 @@ static void expand_event_list(void)
 		expand_event_instance(instance);
 }
 
-int count_cpus(void)
-{
-	FILE *fp;
-	char buf[1024];
-	int cpus = 0;
-	char *pbuf;
-	size_t *pn;
-	size_t n;
-	int r;
-
-	cpus = sysconf(_SC_NPROCESSORS_CONF);
-	if (cpus > 0)
-		return cpus;
-
-	warning("sysconf could not determine number of CPUS");
-
-	/* Do the hack to figure out # of CPUS */
-	n = 1024;
-	pn = &n;
-	pbuf = buf;
-
-	fp = fopen("/proc/cpuinfo", "r");
-	if (!fp)
-		die("Can not read cpuinfo");
-
-	while ((r = getline(&pbuf, pn, fp)) >= 0) {
-		char *p;
-
-		if (strncmp(buf, "processor", 9) != 0)
-			continue;
-		for (p = buf+9; isspace(*p); p++)
-			;
-		if (*p == ':')
-			cpus++;
-	}
-	fclose(fp);
-
-	return cpus;
-}
-
 static void finish(int sig)
 {
 	/* all done */
@@ -4487,7 +4447,7 @@ static void reset_clock(void)
 static void reset_cpu_mask(void)
 {
 	struct buffer_instance *instance;
-	int cpus = count_cpus();
+	int cpus = tracecmd_count_cpus();
 	int fullwords = (cpus - 1) / 32;
 	int bits = (cpus - 1) % 32 + 1;
 	int len = (fullwords + 1) * 9;
@@ -5043,7 +5003,7 @@ void init_top_instance(void)
 {
 	if (!top_instance.ftrace)
 		top_instance.ftrace = tracecmd_create_instance(NULL);
-	top_instance.cpu_count = count_cpus();
+	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
 	tracecmd_init_instance(&top_instance);
 }
@@ -5240,7 +5200,7 @@ static void init_common_record_context(struct common_record_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
-	local_cpu_count = count_cpus();
+	local_cpu_count = tracecmd_count_cpus();
 	init_top_instance();
 }
 
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 32aebc5..44ee559 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -737,7 +737,7 @@ static void report_cpumask(struct buffer_instance *instance)
 	cont = strstrip(str);
 
 	/* check to make sure all CPUs on this machine are set */
-	cpus = count_cpus();
+	cpus = tracecmd_count_cpus();
 
 	for (i = strlen(cont) - 1; i >= 0 && cpus > 0; i--) {
 		if (cont[i] == ',')
@@ -896,7 +896,7 @@ void trace_stat (int argc, char **argv)
 			instance = create_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
-			add_instance(instance, count_cpus());
+			add_instance(instance, tracecmd_count_cpus());
 			/* top instance requires direct access */
 			if (!topt && is_top_instance(first_instance))
 				first_instance = instance;
-- 
2.23.0

