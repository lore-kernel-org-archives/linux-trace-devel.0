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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C58CC432C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DFF220678
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tLfByzw0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfK0ODL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:03:11 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36583 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfK0ODK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:03:10 -0500
Received: by mail-lj1-f196.google.com with SMTP id k15so24632900lja.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BjJ+tT+AgkBiCcWy5862LqL/Pge2Pf+XNzi+wq1cCK0=;
        b=tLfByzw0Iz+olrYDDF0N9w1WfGih0Rv4LGj8JXOmhEcwKu1AlPS/VfOh8G8mx/cIdo
         2N571ynpot2cieiLYMaRsW0mgrXkP0zWaXxjab+PmSmUYOeuhhyNDbwJC4F5UKxrwpe3
         1qDvuSNvSceq41TdBGMzZsGAAVSxnYaDv47vw75y4189VQQqfkKh7GReGVNmOU4F3tzR
         wW2EdNQczZffkj5X8QODkPhkCsXNGwxZY26AVKwkYmRjS68ePJNiVvNI8fUqCWR64T5d
         yGhuP1UFm8RcF/rr+ULsMGViAvGg+twzOGFyYJcmtYYUGK8ndGvDSM4ovgUwY6GzE9wY
         LT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BjJ+tT+AgkBiCcWy5862LqL/Pge2Pf+XNzi+wq1cCK0=;
        b=flxMeZkVfMagJMAEHjuDEdMJ82lqHQOZn/K3Hv1fIAx/Zpltzx6iBt8Uo5z2UVpdRi
         nGzWsob/1KFmdt3YYyWf1Y8AHywEraryIJwoScQT2s8NnmKM31uJVYn9jDylVVENqSlz
         G18G/eYJanq8jekHYHvAZNSlTMxfQLSpS3YdxvZGPOYv2MICbHQj/Xmufn1/PJUvw0PJ
         DZ12c6wyOsdWO8opgwXzJ7G2M0J2NuIUvwbr0v8AWoTLHk5Ko7hIaN/cyLl+qh2oqHqE
         JsfVxoBiBkifVKxNNdC1SMVDBa5JymTD2TXM61M7Pj5fDOTtjS9VGOHuKcye7BbcKjxd
         zVCA==
X-Gm-Message-State: APjAAAXN+6wcUz1dOllemygVSdhJWEMeFWcqOTzyFc/ukHOB8V7A9Dk1
        k/KSUveb5q5jL+z7ShWIUbY=
X-Google-Smtp-Source: APXvYqyyB//fGeWnRl8Yqd+WiO7OclshZw5+XOze+WgleNbypFera9yfTk5j51uTEy46jvW/GTI8Iw==
X-Received: by 2002:a2e:93d5:: with SMTP id p21mr19128488ljh.50.1574863388401;
        Wed, 27 Nov 2019 06:03:08 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:03:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 16/19] trace-cmd: Refactor few trace-cmd internal functions.
Date:   Wed, 27 Nov 2019 16:02:44 +0200
Message-Id: <20191127140247.258766-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to reuse code inside trace-cmd application context,
few functions are made non static:
	int make_vsock(unsigned int port);
	int get_vsock_port(int sd, unsigned int *port);
	int open_vsock(unsigned int cid, unsigned int port);
	char *get_guest_file(const char *file, const char *guest);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h | 8 ++++++++
 tracecmd/trace-agent.c         | 4 ++--
 tracecmd/trace-record.c        | 8 ++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a6f79c5..17ef31a 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -19,6 +19,8 @@
 #define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
 #define VIRTIO_FIFO_FMT		"/dev/virtio-ports/" GUEST_PIPE_NAME "%d"
 
+#define TRACE_FILENAME		"trace.dat"
+
 /* fix stupid glib guint64 typecasts and printf formats */
 typedef unsigned long long u64;
 
@@ -258,6 +260,12 @@ void tracecmd_disable_tracing(void);
 void tracecmd_enable_tracing(void);
 void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 
+int make_vsock(unsigned int port);
+int get_vsock_port(int sd, unsigned int *port);
+int open_vsock(unsigned int cid, unsigned int port);
+
+char *get_guest_file(const char *file, const char *guest);
+
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index cc330b7..530f972 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -40,7 +40,7 @@ static int get_local_cid(unsigned int *cid)
 	return ret;
 }
 
-static int make_vsock(unsigned int port)
+int make_vsock(unsigned int port)
 {
 	struct sockaddr_vm addr = {
 		.svm_family = AF_VSOCK,
@@ -64,7 +64,7 @@ static int make_vsock(unsigned int port)
 	return sd;
 }
 
-static int get_vsock_port(int sd, unsigned int *port)
+int get_vsock_port(int sd, unsigned int *port)
 {
 	struct sockaddr_vm addr;
 	socklen_t addr_len = sizeof(addr);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4f18283..288dbcc 100644
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
+char *get_guest_file(const char *file, const char *guest)
 {
 	const char *p;
 	char *out = NULL;
@@ -2772,7 +2772,7 @@ static int connect_port(const char *host, unsigned int port)
 }
 
 #ifdef VSOCK
-static int open_vsock(unsigned int cid, unsigned int port)
+int open_vsock(unsigned int cid, unsigned int port)
 {
 	struct sockaddr_vm addr = {
 		.svm_family = AF_VSOCK,
@@ -2835,7 +2835,7 @@ static bool can_splice_read_vsock(void)
 }
 
 #else
-static inline int open_vsock(unsigned int cid, unsigned int port)
+int open_vsock(unsigned int cid, unsigned int port)
 {
 	die("vsock is not supported");
 	return -1;
-- 
2.23.0

