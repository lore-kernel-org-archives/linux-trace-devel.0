Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB81C5ED33
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CE8B20801
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZ5idwr7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389335AbgB0OUJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:09 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44045 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389218AbgB0OUJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:09 -0500
Received: by mail-lf1-f67.google.com with SMTP id 7so2186040lfz.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w0c47qg0sT54NkrfJrWBkVp7ytwv30gVtL8LU5kRezM=;
        b=FZ5idwr7DoUunQWsKtf59LeIfoWTRvnKel3xIu+I8amDLDndEaDFNtCxmZHoJ/tUR5
         XOOd+kDq4JZTu/3aVwFNU5zOcC3JTlBDV/XPYO2DydqqPrZ4KkYBaFjLG748Uq0XTgam
         w5m5Ug08jWueTO+5xdhdOwXB0N0wUfbVmHOPQNGV8IaH9W47WRzV9K3KmJEirjXb4/UO
         Rci+Pu5xVhRwBnKDfXqauAN1b7pzY2zESb2G927Wd9QHMsHDWXIDSUnvlLwOVkXPy3wP
         J1j0cIwCmgvzAFIAr+Z5lK5GwZ23DEt2mtuJrSZdgCNmUI7LuNLuYJqAm+Dkf7qVetB0
         imGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0c47qg0sT54NkrfJrWBkVp7ytwv30gVtL8LU5kRezM=;
        b=SglkCr9Buj0vgbXiceMHAgYxEdDzP7Gc7HvuLmO0d0ljlDCW8HVGxEw+F1mYam99ck
         RFtT0GcfmOFkwYE2WCQMUe9RvBnh73Dx4Y+sXIAyqU0IQAXezTe77zFITQsa4h/6iAPw
         ZuSM6OG5OHajHamul4Wr6TRhbCaVMSRF4nC2c6AZpYZ0rnTsz9rTekCl3ACuIZ8SwLmQ
         j+OL1SgcgKWwhlHc3jKSYiQY9zhhr4ixY3/Ow4zPwDARMyYBTPS1UcCqE4rzDhGnm25Q
         Ihn0+jpNzdhX7fSE3K61vD/fMSarlUoLTZ2QvTlFXpdVAiLOIzq87VX9lrsFh3hO+r/3
         HZyg==
X-Gm-Message-State: ANhLgQ3xL+ZX8aQUrjSDstXQCh8PV8AtXsjCE726NzQvBCe/+iPuLcHp
        tm00oc3v/szA+bKxrxdvS6Y=
X-Google-Smtp-Source: ADFU+vuewlaG8TMJ9F6qG9mmBBYvBiAmid30MRLnju01BVmRp1tWDjaGodS9bsU1YXGlRRLfMaXjTg==
X-Received: by 2002:a05:6512:6f:: with SMTP id i15mr2279787lfo.45.1582813207072;
        Thu, 27 Feb 2020 06:20:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 02/15] trace-cmd: Add new library API for local CPU count
Date:   Thu, 27 Feb 2020 16:19:48 +0200
Message-Id: <20200227142001.61577-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
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
index 6763715f..d1b4a60f 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -409,6 +409,9 @@ void tracecmd_plog(const char *fmt, ...);
 void tracecmd_plog_error(const char *fmt, ...);
 int tracecmd_set_logfile(char *logfile);
 
+/* --- System --- */
+int tracecmd_count_cpus(void);
+
 /* --- Hack! --- */
 int tracecmd_blk_hack(struct tracecmd_input *handle);
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index fc2bcb24..b8841393 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -461,3 +461,52 @@ int tracecmd_stack_tracer_status(int *status)
 	*status = num;
 	return 1; /* full success */
 }
+
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
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 7a0804e2..29f27793 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -247,8 +247,6 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
-int count_cpus(void);
-
 /* moved from trace-cmd.h */
 void tracecmd_create_top_instance(char *name);
 void tracecmd_remove_instances(void);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 93e3edfd..1c6e0a3a 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -203,7 +203,7 @@ static void agent_serve(unsigned int port)
 
 	signal(SIGCHLD, handle_sigchld);
 
-	nr_cpus = count_cpus();
+	nr_cpus = tracecmd_count_cpus();
 	page_size = getpagesize();
 
 	sd = make_vsock(port);
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 231e3816..cfae2a22 100644
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
index 4a49b640..28fe31b7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2884,46 +2884,6 @@ static void expand_event_list(void)
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
@@ -4608,7 +4568,7 @@ static void reset_clock(void)
 static void reset_cpu_mask(void)
 {
 	struct buffer_instance *instance;
-	int cpus = count_cpus();
+	int cpus = tracecmd_count_cpus();
 	int fullwords = (cpus - 1) / 32;
 	int bits = (cpus - 1) % 32 + 1;
 	int len = (fullwords + 1) * 9;
@@ -5165,7 +5125,7 @@ void init_top_instance(void)
 {
 	if (!top_instance.tracefs)
 		top_instance.tracefs = tracefs_instance_alloc(NULL);
-	top_instance.cpu_count = count_cpus();
+	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
 	init_instance(&top_instance);
 }
@@ -5362,7 +5322,7 @@ static void init_common_record_context(struct common_record_context *ctx,
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
-	local_cpu_count = count_cpus();
+	local_cpu_count = tracecmd_count_cpus();
 	init_top_instance();
 }
 
diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 0db3baca..3a086a69 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -738,7 +738,7 @@ static void report_cpumask(struct buffer_instance *instance)
 	cont = strstrip(str);
 
 	/* check to make sure all CPUs on this machine are set */
-	cpus = count_cpus();
+	cpus = tracecmd_count_cpus();
 
 	for (i = strlen(cont) - 1; i >= 0 && cpus > 0; i--) {
 		if (cont[i] == ',')
@@ -898,7 +898,7 @@ void trace_stat (int argc, char **argv)
 			instance = create_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
-			add_instance(instance, count_cpus());
+			add_instance(instance, tracecmd_count_cpus());
 			/* top instance requires direct access */
 			if (!topt && is_top_instance(first_instance))
 				first_instance = instance;
-- 
2.24.1

