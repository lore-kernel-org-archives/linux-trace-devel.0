Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C22C341BA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB0124721
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uzekvanu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfLMPal (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:41 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39959 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbfLMPak (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:40 -0500
Received: by mail-lf1-f67.google.com with SMTP id i23so2257460lfo.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wtC6p0nti5C8Stonm8ndgdbg+3m4eBgXRfvbmxTLYbg=;
        b=uzekvanuFHr/8vDmZsgxmWTiNaAW1NML44MLTGLw9tHNzgCMetWyXOrtguYDTO4VEg
         UV+p0qk1D1IhikjX4bDeyavZiuRKpxXST67MAV7WBaDm14vD9rg0zMEwnDw4uautnAp+
         8IY72qwYB8u7LArnk8LHxYx8mlNJXdEeT/N5a1sAGcfQT1+cbSOFk0t0RRiZ4O9vY63Q
         tQDMODN3MsTjkBNsYVmCmoVaIfiVO9V+18ODqKB0+nZuoNfuQ6GOY2dWomkEm+IzJCKt
         y4yRgDl8It2hGkaofspqG1oZ32cpcqrAYttQGiRN2TXi8VCJCvXbPtu+BvtEWPDOjGag
         LZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wtC6p0nti5C8Stonm8ndgdbg+3m4eBgXRfvbmxTLYbg=;
        b=QvrG9EK8bIpDpIxvYF30mpXRqC9qOzofBYcnyR4E3NUctZzrGIJ5vFP2HYr3OaiLvr
         HbR3FEIRVHe3r5aGyGyOQoCQzwsvLROXIswTOgXxmmB2XJ85uHB05QXvxtI00cp0uZ1h
         SS030/inbzhv5ROmFi/GhH0BOtJAj/CYloNL+uOZsoPtl035YWGE+rYiwxjKsb0GAGpk
         QjcjOhyTQ2wTlLG2esVnhTrBJVip8QP5Ul/VThPe+iiSuTgZn/221UtO/1gcEs++2erw
         uK3S4pqLRRs+/qx0it3r+haFKdmW/fDJ6mrNr109LgzjyFY/tVcHxW4Bzl1pI59jVSg+
         3xtg==
X-Gm-Message-State: APjAAAX8YNn1+YdqKA+2L4dUxgiVR+ePscKNPU5jWEyEdi6DbfYBWzEV
        lf86plGyFjpH2Ba0thso0w8=
X-Google-Smtp-Source: APXvYqws3qE4cpSscJNRUUrWgLqGk04uK2+O2YMQw1VwUZdO+sNDIhYU6URQEBg118lzMW/JhzImqw==
X-Received: by 2002:a19:710a:: with SMTP id m10mr9118095lfc.58.1576251038539;
        Fri, 13 Dec 2019 07:30:38 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:37 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 05/18] trace-cmd: Add new library API for local CPU count
Date:   Fri, 13 Dec 2019 17:30:16 +0200
Message-Id: <20191213153029.133570-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-util.c     | 49 ++++++++++++++++++++++++++++++++++
 tracecmd/include/trace-local.h |  2 --
 tracecmd/trace-agent.c         |  2 +-
 tracecmd/trace-profile.c       |  2 +-
 tracecmd/trace-record.c        | 46 +++----------------------------
 tracecmd/trace-stat.c          |  4 +--
 7 files changed, 59 insertions(+), 49 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 32182bc..f9ad823 100644
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
index 582709f..2a121eb 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1112,6 +1112,55 @@ int tracecmd_stack_tracer_status(int *status)
 	return 1; /* full success */
 }
 
+/**
+ * tracecmd_count_cpus - Get the number of CPUs in the system
+ *
+ * Returns the number of CPUs in the system, or 0 in case of an error
+ */
+int tracecmd_count_cpus(void)
+{
+	static int once;
+	char buf[1024];
+	int cpus = 0;
+	char *pbuf;
+	size_t *pn;
+	FILE *fp;
+	size_t n;
+	int r;
+
+	cpus = sysconf(_SC_NPROCESSORS_CONF);
+	if (cpus > 0)
+		return cpus;
+
+	if (!once) {
+		once++;
+		warning("sysconf could not determine number of CPUS");
+	}
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
index 3f4f55f..2d95d6f 100644
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
@@ -4489,7 +4449,7 @@ static void reset_clock(void)
 static void reset_cpu_mask(void)
 {
 	struct buffer_instance *instance;
-	int cpus = count_cpus();
+	int cpus = tracecmd_count_cpus();
 	int fullwords = (cpus - 1) / 32;
 	int bits = (cpus - 1) % 32 + 1;
 	int len = (fullwords + 1) * 9;
@@ -5045,7 +5005,7 @@ void init_top_instance(void)
 {
 	if (!top_instance.ftrace)
 		top_instance.ftrace = tracecmd_alloc_instance(NULL);
-	top_instance.cpu_count = count_cpus();
+	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
 	tracecmd_init_instance(&top_instance);
 }
@@ -5242,7 +5202,7 @@ static void init_common_record_context(struct common_record_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
-	local_cpu_count = count_cpus();
+	local_cpu_count = tracecmd_count_cpus();
 	init_top_instance();
 }
 
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 5cc9d28..bb6e40b 100644
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

