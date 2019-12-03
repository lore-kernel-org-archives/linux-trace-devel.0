Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6144C432C3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC305205ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0CoRDN1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLCKfq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:35:46 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35951 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfLCKfq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 05:35:46 -0500
Received: by mail-lj1-f195.google.com with SMTP id r19so3211469ljg.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Dec 2019 02:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bzEwug/40m8ZvyhZ632ZBE59iLeXEZb5sxMd3ibrnBs=;
        b=m0CoRDN1DfC3oRZlDc7z2PvWTc0k2mWbAKSsvLx+JPmlD4WiWFtyiTPymMFKoOT2Eu
         dVpHQvvU/FUOJc/jr+gMacLkEYHepK8jFy7Ce090UB5qCE/S6tp/7QiNZzXbC3GyY9u9
         sGoLOItON+Csyn7MEbI70RDjVXTkXz918NZGzZu9gmPyDiPp/qHKisgCBGEI0x8oyiWO
         PjqhlAp4jZwYh5Xl3UuCQeVNUBEBkpGhGPLWpVbuOGA6B0xy7WNani/JPASP3BxpGnMh
         Rr4Zt7irDzhaKqIv5qphqSsjlAInOfHVf8GvDbBRyG0kY/N9VrXcCbnRrBTTGyKLyM+6
         hJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bzEwug/40m8ZvyhZ632ZBE59iLeXEZb5sxMd3ibrnBs=;
        b=Pg3EtNaFzzioo/V1kI11GzJTYkWR5lY+oZUvSct52blXDEcUt32YJfxm7CZ02zyhmP
         xk4l1sYazX/fd9AGshG6o9gXS3UTYgQGF4bGrdQzH4C2N9EXmBBlDSeiJsT4kQHrf63D
         +K/yNbIdBOJKJbifmRRkqhyPuemHVHMNCiSY33gNLS/szTEaSYCZn5ZgBRaPmbIYZBe9
         b8IYyOeWl/MbAyjkhKevPGCqF9nbtx4ZMPj5M9SZHboOf2ErTX2CTioYesr2ij6SX/z/
         CRFICoBQSL9k7mvGEiB7iE1p24TfanzycrkMvUsBXBe2nyw5BfRmHAxQI3JNf7m2dHL/
         BWCA==
X-Gm-Message-State: APjAAAV1Vbus5RkTHqmapLIyiHYJ9eHHSlEAJUqepzvPFrhWGT3MAH/S
        mqfWFb+LlbkRkeZgWbGf1ArMEDWiwu4=
X-Google-Smtp-Source: APXvYqyDBLbJuxUsp0A48l3SeH76Yh2zJrs90nJ7jsHoHEshxt3XwEMHYumazbrVgd9FG2FwLpyVxQ==
X-Received: by 2002:a05:651c:2046:: with SMTP id t6mr1858552ljo.180.1575369344239;
        Tue, 03 Dec 2019 02:35:44 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t9sm1053023lfl.51.2019.12.03.02.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:35:43 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v17 15/18] trace-cmd: Refactor few trace-cmd internal functions.
Date:   Tue,  3 Dec 2019 12:35:19 +0200
Message-Id: <20191203103522.482684-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191203103522.482684-1-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
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
index e7fb1bd..e66f999 100644
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

