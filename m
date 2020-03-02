Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C507C3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648AA20870
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tVgmd50m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgCBKOY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:14:24 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42314 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbgCBKOY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 05:14:24 -0500
Received: by mail-lf1-f67.google.com with SMTP id 83so7519353lfh.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 02:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KpJnerk41m58vhJzBj+GyTr+GQi3dk7pf6r0+CAqYos=;
        b=tVgmd50m/X2DWXgFfDZo020K0ZH6GkveUzKJQnBnuTMemh/eSdYomtW5EHVE7lFasA
         I67Iqumxnk3ic8+wkSzWXIOYkqIO/Hw9Fx1Dp3EnyC9f7vbJpclHqNFlpqhfjWKXCiYX
         RZMmWD87FFhUEtX3AUhNqDWWeLf8CMZxMFRGOd3Rcl4Xt4RmpzDdwTB1o+8pmjnCgrdQ
         7VyzXRpi1Rlh9qn9LgdAmW6nStkH2cV9+SRrW1DqmYqJIvKSiNKB1O5ccxY459/0caTa
         JrH5u/cJ+Bmg5wnuZvlRZSIJOkzQjGbPG/fqshWunI59sn2E9vDZrgovRMvQhYiKKw+S
         lQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KpJnerk41m58vhJzBj+GyTr+GQi3dk7pf6r0+CAqYos=;
        b=bhVx/tmPuT/xCS9AAiSDejEm/0vufY4p15RkswS3C9feDPJyQpfW9uX01VBqPaQ9Mn
         lIESxkiq70mjRzGCx7uOEbQWwvhNDOczV7arnqdDXSdJ4RFUZzpswl2mzJdFub8wuH1J
         a6GI1wWgQR1dPvnrFtk59YuymhYbRWnnaZDe1d7k75bc1KnljIQC3vjTl/NYTsAgc9rT
         KoAy2iaxPq1blM+KIDj6mCSyXUOdzv+Gnzslfw9DlNwdySytx84zD9EdAyly+ncD5iMk
         jSZeytYsmqq6n6OaVXRWZMim06rmlss1RhotKUuMYGzZGnt9bJrKYbkHpFIySxJ7XaLH
         Rdew==
X-Gm-Message-State: ANhLgQ0FvL+SNWDkl4zqTEbY1HwZXmvtc5f0ykHQdldLWvHeSkiYDUWJ
        BjrAyHdaiTD3u7obJOJVGcxbCRed
X-Google-Smtp-Source: ADFU+vsHGGRMpif8kyWy9aED3/TyV6/2c953YeZzdqYPbYvDTO8tPFMpJZWt4Yt+dzZZ6t1ONiX2UA==
X-Received: by 2002:a05:6512:31d5:: with SMTP id j21mr3053893lfe.23.1583144059692;
        Mon, 02 Mar 2020 02:14:19 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x10sm11048236ljd.68.2020.03.02.02.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:14:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v21 10/13] trace-cmd: Refactor few trace-cmd internal functions.
Date:   Mon,  2 Mar 2020 12:14:01 +0200
Message-Id: <20200302101404.150035-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302101404.150035-1-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
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
index dc934f28..95d0026b 100644
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
index 52d27195..a8ef0852 100644
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
index e0b18044..174a9bdd 100644
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
@@ -3304,7 +3304,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 		if (instance->use_fifos)
 			fd = instance->fds[cpu];
 		else
-			fd = open_vsock(instance->cid, instance->client_ports[cpu]);
+			fd = trace_open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
@@ -3696,7 +3696,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		use_fifos = nr_fifos > 0;
 	}
 
-	sd = open_vsock(instance->cid, instance->port);
+	sd = trace_open_vsock(instance->cid, instance->port);
 	if (sd < 0)
 		die("Failed to connect to vsocket @%u:%u",
 		    instance->cid, instance->port);
@@ -3747,8 +3747,8 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = get_guest_file(output_file,
-			      tracefs_instance_get_name(instance->tracefs));
+	file = trace_get_guest_file(output_file,
+				    tracefs_instance_get_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -4084,8 +4084,8 @@ static void write_guest_file(struct buffer_instance *instance)
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

