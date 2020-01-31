Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD30CC33CB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8236F214D8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JtThsUqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgAaMLV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:21 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39345 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbgAaMLV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:21 -0500
Received: by mail-lj1-f194.google.com with SMTP id o15so1311790ljg.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=joP5Lk8bNg5ygc+N7gp2TuU7hm2wVlHP5BTV7SmjeIM=;
        b=JtThsUqNNAN8xDO6R1i6jTnQWYikaoW/TKOVK6xJ+jJrMgAbrdhTn+efyszUH8jA/j
         CfOExPeGdTxlAVdgaJRRUQi4pgXmZUJeYumLghN6pGM5Vijj1KTAdbwzKcvU2uUUISO+
         +3Agn+bHFdXrFXU4zPrWKU3rBvNXKV7bRtx6/uuRGBmR04bkjAPVAyStQDOgH4Ila/sM
         lfciKOy65SftV7/HapZyq/Fa9/6V7e82tV/JB5s751njXAI/7t6jf8fiklEPMvHnyueW
         w2JD5sZrtnAR1ef2z3P/pABLSp2hknwhCElIeyT5mh3EOnHM/A3MA4MkBAfMYmg7bseF
         3H4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=joP5Lk8bNg5ygc+N7gp2TuU7hm2wVlHP5BTV7SmjeIM=;
        b=Tm93+Cbb1JMLKqgGVS4+U2r0dtXm9DiCB5ArMuQnHSrdwA6pXGwh26tCs1yFWXaL4k
         MRu3WK3QXssDXDiIbA+4BapqKMBBAPx68c8pSXqYfN3qd8jmTzjCI9aGoOVHNoYd0Phc
         A0q5SVIOm2p0gYzaWVR5GI9clmSjuFdab88vljgYFlR5ODxG1inKDUvzKm37lYu13+V4
         SG2/TpfNOKPNBKOxQZ+H5uc2Zx2JajNtPyPqYgTssZwnGw/st4qtCTIBi8HjaNVU3qTY
         lLc2lIKlv5LaboXfA9C8kjGiREGzZUCW3XF+TR5YzN/Vg3AooFw2Ryn2EgRoLQj2RExr
         EscQ==
X-Gm-Message-State: APjAAAVwQ8LwjU8Es18Uh/L+BhatV2ignRvONOlmv3SAekK+1n8cxJ9j
        KKFGrSBY1FzvsxC+MAe3R8OnJS/2Wg4=
X-Google-Smtp-Source: APXvYqzrXS14lQzFQVLRF7Sn7IULtbcSoOab3mvmgoOMx8H9C4IcNJj+STnDteK8LDuYaCs8xIRPmg==
X-Received: by 2002:a2e:7d01:: with SMTP id y1mr6026665ljc.100.1580472677341;
        Fri, 31 Jan 2020 04:11:17 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 02/15] trace-cmd: Add new library API for local CPU count
Date:   Fri, 31 Jan 2020 14:10:58 +0200
Message-Id: <20200131121111.130355-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
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
index 6763715..d1b4a60 100644
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
index fc2bcb2..b884139 100644
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
index 7a0804e..29f2779 100644
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
index 4a49b64..28fe31b 100644
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
index 0db3bac..3a086a6 100644
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

