Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4169CC3F2D7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 168422072D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pMglOGX4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728744AbgCDJMh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:12:37 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40651 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgCDJMh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:12:37 -0500
Received: by mail-lf1-f66.google.com with SMTP id p5so869984lfc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Mar 2020 01:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YR3YhDvOSSOLWTAh17APv+KA7NKLJuEKkPy8PUPu9aA=;
        b=pMglOGX4EuV29K3R65qWMZAPmYfoVWlGaWBUzL7YYr4M3uDbk2gMDRLt7Hf38wobDC
         U9PkRzhdp7aWl/E/IiFxqg5xhNOLAgVgp0Y6c7/WnCvmyG9EfCDUtMW6FcfGj6sXf0XR
         7+dhA7Z2+0651HnRkQMDXnkoVx1p7rTtYy4uHStd9P5b1vgi2uIe9MdBETTbr1gDWzz5
         0O57mKftgXm1Gd5fCPWy8mKp3abvjw9C8Omcfz08++4DYgW+yOW/bXgINBR/ZHp7KNh8
         AjwrRb9PsZQTLgenspQb0t+3fTiVEKzS0ftNkX5Onr5KikHTxPYAl2w/qB2IY3lQwGAT
         3jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YR3YhDvOSSOLWTAh17APv+KA7NKLJuEKkPy8PUPu9aA=;
        b=iq50rzRUSEFsuESmc2QjZio271DJDagjsE4dVwu/QgnWc05n2IJ/ta6YDOoK5W11aY
         PHxuC8vtNRWfhkuAcvNR2k5AjlJJ3VmN1F/BwRuKeQrFbpeAWcsijnyKhygEjhLcc45c
         rTRlkBBIO6W5gcf0qeKRJCoVjTA6UtJkv7Tcq+h/SCd941P51XjiFzv/M4mxi7ntiugy
         OuZB+tej24msaP32tLJiZvFxz3ogcOyyQLxNzA4ARAmZn+aOgMkoE6vs8gXwVK/72iHx
         3ShC8/qZO+03rnwoqRIj9ZXa9bibJva5N+wzsRHK7uvb+65Nyg8LZcBgukeS8iu6FN0P
         tlBg==
X-Gm-Message-State: ANhLgQ27P37yMMTCA7zaWJTZiI8b3MjLKl2sdiniv7mhKiDXlA6//kLO
        lsl+nfeozs79o9G+5a4wgtY=
X-Google-Smtp-Source: ADFU+vuGM/zeyUYirLC99mB8gbxhrYhtqvcPphuxtmY5pqTAA/pbYwG/OPAjbEXOAbC55DKqjRem0Q==
X-Received: by 2002:ac2:5e90:: with SMTP id b16mr1402006lfq.155.1583313155784;
        Wed, 04 Mar 2020 01:12:35 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v15sm13327462lfg.51.2020.03.04.01.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:12:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v22 10/13] trace-cmd: Refactor few trace-cmd internal functions.
Date:   Wed,  4 Mar 2020 11:12:17 +0200
Message-Id: <20200304091220.30936-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304091220.30936-1-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
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
index 2e82464d..0151b9d4 100644
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
@@ -3305,7 +3305,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 		if (instance->use_fifos)
 			fd = instance->fds[cpu];
 		else
-			fd = open_vsock(instance->cid, instance->client_ports[cpu]);
+			fd = trace_open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
@@ -3697,7 +3697,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		use_fifos = nr_fifos > 0;
 	}
 
-	sd = open_vsock(instance->cid, instance->port);
+	sd = trace_open_vsock(instance->cid, instance->port);
 	if (sd < 0)
 		die("Failed to connect to vsocket @%u:%u",
 		    instance->cid, instance->port);
@@ -3748,8 +3748,8 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = get_guest_file(output_file,
-			      tracefs_instance_get_name(instance->tracefs));
+	file = trace_get_guest_file(output_file,
+				    tracefs_instance_get_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -4085,8 +4085,8 @@ static void write_guest_file(struct buffer_instance *instance)
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

