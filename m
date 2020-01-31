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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA53C33CB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCC0720705
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VjhJEBYw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgAaMLe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:34 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45234 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728511AbgAaMLe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:34 -0500
Received: by mail-lj1-f196.google.com with SMTP id f25so6814231ljg.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j0NtiqTLHwxyH7YOnl84IladxvuFQyuovb5DS8uM03w=;
        b=VjhJEBYwqBWveqUrTdplv33gq2BDixzHvOZUbvNkL0yAH3gpsvyygAwG9wZ3C+0sLf
         F83VRF792iRTolQ8p1E7Sjq5k1qUxgL7HncU3KYO/9NGxYSUf3Vmh4PQDcxdIndRXE0f
         dXLBZoisosX6tJvhe4dUbvx5R+wurTngh2DuJ4MqtR4cxdjTdQE29i3SI6zNXah5eFHp
         OP8w/wqzAu/dMG3RVE5BXi6FpF6SoSi7AfNCfLWc8ir21PVZ5bs3bRg3BWH8/JyoIRyJ
         Y36XLPZbFW2j57dqW33GuQnxlD4vEJgFpeA83Z15COvg+UHEsOnfDoWrjwaYAgHPIT5w
         4yiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j0NtiqTLHwxyH7YOnl84IladxvuFQyuovb5DS8uM03w=;
        b=kp9wbJQ9aT9sygniWE1PifTW9hVOoYz9vQOvXo5K6VWfnndvdWVtREqAtI+Al8YCuh
         Ju8wj+1yVXXTOV6+X2HNG5O82XmQgxnIFFFMRYOtc6/OeW/Ytf1TskTQNEIKVTPGLbo7
         eRX7O7OgduVr8EySBgusDiRp3S2mdf1LfG1WBTPSOzyKYS6IbX7yflE/hrppRlo9zcOJ
         P0Jnph4Q9up9coQ7w1AeNNzqB2hr9av8/Vya2HSqZqIme38ryK/5Y4EFbvjbI/qghr8h
         kJBjIRb6wvTmuGNFZ72LpKnmlsYC0uARmqu2fxQZ5njJv9YVgMu39p9+CWLPiRb5FjGH
         iNnA==
X-Gm-Message-State: APjAAAWavrwlh0yqZan9+6cH28rea7c5Utc1vCPl+q+k9JGevGvbBjDx
        ZbpNQrH0vj9t84OYF63ktC4=
X-Google-Smtp-Source: APXvYqxLS+/3mOHnms/t9spv/6Pwx/sZElrNHMf61K4fw/Ieeph33FSdf1KDDFD3En/DZ1vK2NFaKA==
X-Received: by 2002:a2e:978c:: with SMTP id y12mr5620817lji.167.1580472691958;
        Fri, 31 Jan 2020 04:11:31 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 12/15] trace-cmd: Refactor few trace-cmd internal functions.
Date:   Fri, 31 Jan 2020 14:11:08 +0200
Message-Id: <20200131121111.130355-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to reuse code inside trace-cmd application context,
few functions are made non static and "trace_" is prepended
to their names:
	int trace_make_vsock(unsigned int port);
	int trace_get_vsock_port(int sd, unsigned int *port);
	int trace_open_vsock(unsigned int cid, unsigned int port);
	char *trace_get_guest_file(const char *file, const char *guest);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h |  6 ++++++
 tracecmd/trace-agent.c         | 10 +++++-----
 tracecmd/trace-record.c        | 18 +++++++++---------
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index dc934f2..95d0026 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -263,6 +263,12 @@ void tracecmd_disable_tracing(void);
 void tracecmd_enable_tracing(void);
 void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 
+int trace_make_vsock(unsigned int port);
+int trace_get_vsock_port(int sd, unsigned int *port);
+int trace_open_vsock(unsigned int cid, unsigned int port);
+
+char *trace_get_guest_file(const char *file, const char *guest);
+
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 52d2719..a8ef085 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -40,7 +40,7 @@ static int get_local_cid(unsigned int *cid)
 	return ret;
 }
 
-static int make_vsock(unsigned int port)
+int trace_make_vsock(unsigned int port)
 {
 	struct sockaddr_vm addr = {
 		.svm_family = AF_VSOCK,
@@ -64,7 +64,7 @@ static int make_vsock(unsigned int port)
 	return sd;
 }
 
-static int get_vsock_port(int sd, unsigned int *port)
+int trace_get_vsock_port(int sd, unsigned int *port)
 {
 	struct sockaddr_vm addr;
 	socklen_t addr_len = sizeof(addr);
@@ -87,11 +87,11 @@ static void make_vsocks(int nr, int *fds, unsigned int *ports)
 	int i, fd, ret;
 
 	for (i = 0; i < nr; i++) {
-		fd = make_vsock(VMADDR_PORT_ANY);
+		fd = trace_make_vsock(VMADDR_PORT_ANY);
 		if (fd < 0)
 			die("Failed to open vsocket");
 
-		ret = get_vsock_port(fd, &port);
+		ret = trace_get_vsock_port(fd, &port);
 		if (ret < 0)
 			die("Failed to get vsocket address");
 
@@ -210,7 +210,7 @@ static void agent_serve(unsigned int port)
 	nr_cpus = tracecmd_count_cpus();
 	page_size = getpagesize();
 
-	sd = make_vsock(port);
+	sd = trace_make_vsock(port);
 	if (sd < 0)
 		die("Failed to open vsocket");
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8884c0c..bf81a89 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -537,7 +537,7 @@ static char *get_temp_file(struct buffer_instance *instance, int cpu)
 	return file;
 }
 
-static char *get_guest_file(const char *file, const char *guest)
+char *trace_get_guest_file(const char *file, const char *guest)
 {
 	const char *p;
 	char *out = NULL;
@@ -2930,7 +2930,7 @@ static int connect_port(const char *host, unsigned int port)
 }
 
 #ifdef VSOCK
-static int open_vsock(unsigned int cid, unsigned int port)
+int trace_open_vsock(unsigned int cid, unsigned int port)
 {
 	struct sockaddr_vm addr = {
 		.svm_family = AF_VSOCK,
@@ -2993,7 +2993,7 @@ static bool can_splice_read_vsock(void)
 }
 
 #else
-static inline int open_vsock(unsigned int cid, unsigned int port)
+int trace_open_vsock(unsigned int cid, unsigned int port)
 {
 	die("vsock is not supported");
 	return -1;
@@ -3274,7 +3274,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 		if (instance->use_fifos)
 			fd = instance->fds[cpu];
 		else
-			fd = open_vsock(instance->cid, instance->client_ports[cpu]);
+			fd = trace_open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
@@ -3666,7 +3666,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		use_fifos = nr_fifos > 0;
 	}
 
-	sd = open_vsock(instance->cid, instance->port);
+	sd = trace_open_vsock(instance->cid, instance->port);
 	if (sd < 0)
 		die("Failed to connect to vsocket @%u:%u",
 		    instance->cid, instance->port);
@@ -3717,8 +3717,8 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = get_guest_file(output_file,
-			      tracefs_instance_get_name(instance->tracefs));
+	file = trace_get_guest_file(output_file,
+				    tracefs_instance_get_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -4054,8 +4054,8 @@ static void write_guest_file(struct buffer_instance *instance)
 	char **temp_files;
 	int i, fd;
 
-	file = get_guest_file(output_file,
-			      tracefs_instance_get_name(instance->tracefs));
+	file = trace_get_guest_file(output_file,
+				    tracefs_instance_get_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
-- 
2.24.1

