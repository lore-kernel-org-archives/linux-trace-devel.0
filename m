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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AADC3B197
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23D5A246C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVhHJnYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbfLMPax (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:53 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43853 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbfLMPax (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:53 -0500
Received: by mail-lf1-f68.google.com with SMTP id 9so2241049lfq.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7X7t7tNI2lKkX7Fq57pGXG0O8izcgpYuth/AA4ZudJU=;
        b=nVhHJnYzk+VeCprqG6mDUrrRgQHFj9fdkXML+LSB+vSAr3lfqw4qaco0OASVOzlLqv
         Z0YlITF/7hDAgqTkv/1+hAGX+Ujjyg+f+2bMX7DWMB7RcqWCMb1EKpL5QAunsm9PHRpK
         +pz+4ww54Q8SuTUjcFzWqnqCagh6Kfr+ZSnQwuCDfrTXIFU77oA4gkeb6NB5kqfTBQF2
         2DBvsEAxWj9Vr1eaWtpD+q53Po6QgC3KkhTVj5Fwib6xz80zDUid8idbepeW+t76lPhw
         S0WILiENGk4N39/NZY4SbM1h2LnqoSlot7+68roTh/m0cb/UCTBbiM0EMrmBDIczn5Ke
         te9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7X7t7tNI2lKkX7Fq57pGXG0O8izcgpYuth/AA4ZudJU=;
        b=H4MQpj/dyq4Np2sTp9n5S7xe3TAL5TxrGWnv/4wPevekNhSpkM8UTifSoIzZ6FwBY6
         LU0819MQopJ1QrAhTJ9fC1UzRBH6uKQhNk3zJht/nu7oOv44UbtmhSP47c7uCGjh66Q9
         6lp/wCVeqUu+0+weMm0tXqjM/bhd4/PoncEd3k0Qt53EWbx0VsKKucJjJgk3lhKrk93t
         C53HqLcQ9xXVxT2gaubTDOq3dBuIk0j3EAYXrZbajH+L97tlTRLVjnTC291G2we9RjVP
         PzZ+QA+AbeInkPftZhQPjowPX3+5Ul/oXXJgmmSipU5i2AwxEUDLMZoYhJPrSXh7II5o
         g/xA==
X-Gm-Message-State: APjAAAX0oPH34xtgNjHsj5g+1qzQv3mk3kOB2oCFIuR4GtxsiQbEkIVw
        sd8boKTaFIEQU0wVQ4HFMBs=
X-Google-Smtp-Source: APXvYqwxiisp2rrJTvX505bH46KopP/MsyzddIAXfvPPY9qWT8LZLYp0pSaghmQM9S+M8CKTZ8J5qA==
X-Received: by 2002:ac2:4add:: with SMTP id m29mr9182320lfp.190.1576251050648;
        Fri, 13 Dec 2019 07:30:50 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 15/18] trace-cmd: Refactor few trace-cmd internal functions.
Date:   Fri, 13 Dec 2019 17:30:26 +0200
Message-Id: <20191213153029.133570-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
 tracecmd/include/trace-local.h |  8 ++++++++
 tracecmd/trace-agent.c         | 10 +++++-----
 tracecmd/trace-record.c        | 16 ++++++++--------
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4c8d6cb..d3e96c2 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -19,6 +19,8 @@
 #define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
 #define VIRTIO_FIFO_FMT		"/dev/virtio-ports/" GUEST_PIPE_NAME "%d"
 
+#define TRACE_FILENAME		"trace.dat"
+
 /* fix stupid glib guint64 typecasts and printf formats */
 typedef unsigned long long u64;
 
@@ -260,6 +262,12 @@ void tracecmd_disable_tracing(void);
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
index cc330b7..db58064 100644
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
 
@@ -208,7 +208,7 @@ static void agent_serve(unsigned int port)
 	nr_cpus = tracecmd_count_cpus();
 	page_size = getpagesize();
 
-	sd = make_vsock(port);
+	sd = trace_make_vsock(port);
 	if (sd < 0)
 		die("Failed to open vsocket");
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 51b40ff..e84b714 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -68,7 +68,7 @@ static int rt_prio;
 
 static int keep;
 
-static const char *output_file = "trace.dat";
+static const char *output_file = TRACE_FILENAME;
 
 static int latency;
 static int sleep_time = 1000;
@@ -536,7 +536,7 @@ static char *get_temp_file(struct buffer_instance *instance, int cpu)
 	return file;
 }
 
-static char *get_guest_file(const char *file, const char *guest)
+char *trace_get_guest_file(const char *file, const char *guest)
 {
 	const char *p;
 	char *out = NULL;
@@ -2772,7 +2772,7 @@ static int connect_port(const char *host, unsigned int port)
 }
 
 #ifdef VSOCK
-static int open_vsock(unsigned int cid, unsigned int port)
+int trace_open_vsock(unsigned int cid, unsigned int port)
 {
 	struct sockaddr_vm addr = {
 		.svm_family = AF_VSOCK,
@@ -2835,7 +2835,7 @@ static bool can_splice_read_vsock(void)
 }
 
 #else
-static inline int open_vsock(unsigned int cid, unsigned int port)
+int trace_open_vsock(unsigned int cid, unsigned int port)
 {
 	die("vsock is not supported");
 	return -1;
@@ -3117,7 +3117,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 		if (instance->use_fifos)
 			fd = instance->fds[cpu];
 		else
-			fd = open_vsock(instance->cid, instance->client_ports[cpu]);
+			fd = trace_open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
@@ -3508,7 +3508,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		use_fifos = nr_fifos > 0;
 	}
 
-	sd = open_vsock(instance->cid, instance->port);
+	sd = trace_open_vsock(instance->cid, instance->port);
 	if (sd < 0)
 		die("Failed to connect to vsocket @%u:%u",
 		    instance->cid, instance->port);
@@ -3562,7 +3562,7 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = get_guest_file(output_file, tracecmd_get_instance_name(instance->ftrace));
+	file = trace_get_guest_file(output_file, tracecmd_get_instance_name(instance->ftrace));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -3887,7 +3887,7 @@ static void write_guest_file(struct buffer_instance *instance)
 	char **temp_files;
 	int i, fd;
 
-	file = get_guest_file(output_file, tracecmd_get_instance_name(instance->ftrace));
+	file = trace_get_guest_file(output_file, tracecmd_get_instance_name(instance->ftrace));
 	if (!file)
 		die("Failed to allocate memory");
 
-- 
2.23.0

