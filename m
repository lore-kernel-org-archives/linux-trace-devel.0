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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D1DC5ED42
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91C2A24690
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ui+19ehD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389828AbgB0OUX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:23 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33834 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389286AbgB0OUW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:22 -0500
Received: by mail-lf1-f67.google.com with SMTP id w27so679915lfc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=clFj0GUm3KZJiSDld7UwSf9wg4rUBmQulJxODCDRlvA=;
        b=ui+19ehDpw0k+0pZtcwfLJilTSGTPCYYKU29/xKLo+26ty+rQi7eYDXJwG4BqDvKBR
         O77HsUxtfRWX8+Ku1dOd6V/ukW1TxVsOCpf7jvIKFfK3eppiI1f3Y/XZaGomanR/8YdZ
         3hcGu07j9R3Z+iZ0xJl/hfJpMB1I+koYNOBerFUyDGA5SzYV5ImJLL/jbXr5Z5XdmSHb
         fgROV7j2jpCeUtywIHwkuaV2YnL0dM5DrTg43Q7O+zhz+LYlLBuxCLh7hf/avaCuemv/
         D/9E6z41zSv3UAjqu0fz3KBkp0z50NZoG/i93ZD9kmr3SyZ3B0QTQyrWFDM+9774tLRC
         wxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=clFj0GUm3KZJiSDld7UwSf9wg4rUBmQulJxODCDRlvA=;
        b=H6A21RNstEcIxmqPw6HbFhFyUhIqyUrwznSmZ8L2Y5rSgS/3H6oIYuzCfEJS6j1nA4
         rexs6S9Id4P/1IXlHHy+nU/gMRxabDuUlcIEjHdGGKMkX6JcyK2/IOo/YGVULpWjKPMa
         2XNT/PSsoyOqQHb1oYKa9Tbc89gi2B43kIDxrTQ5zg0vd/CL1mAmILjVUf/sa5vDxExo
         YGQ7ldFluld7Qj0JgYmRn0A+v1UOiupBstGS30OiAWtD9+LkgQqeNLlM2Fr7YIMyCM8Q
         1o1dc3k6nZBTZihSgQPlAU6W8x1VUW8jJcIFqaRDMl7RbyJZIpYt34HSDOiDBJK02kqu
         KCzg==
X-Gm-Message-State: ANhLgQ3l0JBjtDFKrN0azsoifytEMNkw/ewOksNlVlaA6q8gyMLRtvwm
        CfPzlOCtp8OqObzWqn0IEnw=
X-Google-Smtp-Source: ADFU+vtPkVXtPuAFey3FbTh0Pxye0KIZYm9N/nhu/QVuay3nNbYwmWome9YU5kTpMHKTV78Owq+fSg==
X-Received: by 2002:ac2:4246:: with SMTP id m6mr2331160lfl.165.1582813220146;
        Thu, 27 Feb 2020 06:20:20 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 12/15] trace-cmd: Refactor few trace-cmd internal functions.
Date:   Thu, 27 Feb 2020 16:19:58 +0200
Message-Id: <20200227142001.61577-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
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
index ee27cf0f..30ba5bb2 100644
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
@@ -3297,7 +3297,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 		if (instance->use_fifos)
 			fd = instance->fds[cpu];
 		else
-			fd = open_vsock(instance->cid, instance->client_ports[cpu]);
+			fd = trace_open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
@@ -3689,7 +3689,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		use_fifos = nr_fifos > 0;
 	}
 
-	sd = open_vsock(instance->cid, instance->port);
+	sd = trace_open_vsock(instance->cid, instance->port);
 	if (sd < 0)
 		die("Failed to connect to vsocket @%u:%u",
 		    instance->cid, instance->port);
@@ -3740,8 +3740,8 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = get_guest_file(output_file,
-			      tracefs_instance_get_name(instance->tracefs));
+	file = trace_get_guest_file(output_file,
+				    tracefs_instance_get_name(instance->tracefs));
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -4077,8 +4077,8 @@ static void write_guest_file(struct buffer_instance *instance)
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

