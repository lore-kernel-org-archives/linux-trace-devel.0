Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D34AC43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41A9561158
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhDOIQA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 04:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhDOIP7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 04:15:59 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60B1C06175F
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:36 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x4so26975089edd.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lj6pVXrUQDXSOqMfuNu8o/0lq+ledSVCMAABWCJuIP8=;
        b=g1+b71pVCErF366xw5LyEEJo4po19Zl6Px8pk4NYRmxCZVV7iWfygbhn8kq4tLYdNa
         oy6UzkmIkBYnYpbS3ap86RXtyIl9smJ2sKPvTHX6N5ldYtgr6P+0dsAUfU3a8xTIHVif
         KyPizgitxEKHJ/1w1PC62Auuxg7chtagKB4ENZfxgpCTukJfO2khFKhxoTFu3A9MwL9Y
         4jBfGgvu6lYlpo4VZn04RGs5xpa69/ZIiirwvB2my+s7RxYCqHtvBaRxQswQvpPL/f6s
         vpWOJcuCjsVkg1K1rIBlrhXdx651pe5uc1DpSmlxNofyDNzl6mvmEK/4Wlf2XYGVU/ic
         eJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lj6pVXrUQDXSOqMfuNu8o/0lq+ledSVCMAABWCJuIP8=;
        b=Awa3GsFmhHICSp/TMIRIwLSFXVKir9fn2Kyqd3Q7eJTEQB47yL5NZ5nJ+A7HCcL1Yd
         8dIi0Mi2jlQsXYENnBCXly5+BiMdYgKg7fBoRNg1NKJSBQuvGa4iO300iX5SB3u5QZmt
         3VqbSR+0kByBCGLp+4Kkr7P+LnCIWw1+3f2D1HARmHui+klxjDTSRbBXLYA5oAc8R8rO
         8Qua3ARKdudcF9Xw8rM6d2Xhwa++hleXgJK/AHUuRsMl1GsOkCwHgtVadJdI1I7yu2vg
         EvdcRbj2eedFmankwu8FysDP0j7kXJOoZwLC4wBzBDU5nMX8JcG23Lc19EYpreXlP1Pz
         o8Gw==
X-Gm-Message-State: AOAM533NnuSIMAnNNE9lRkOMgM0JPgWaC31kcil9H70rtGWSSTuWLgds
        SLIFarBcaCuU1Z+kPGGLx76cWHvhuKE=
X-Google-Smtp-Source: ABdhPJzbrqFkeA/k5cmwr/rrs3gRPijkZbFktPL6/Zo3ghpiO4uMr73PPRw2rmxqAfAzyylToSQUdA==
X-Received: by 2002:a50:c004:: with SMTP id r4mr2598743edb.192.1618474535649;
        Thu, 15 Apr 2021 01:15:35 -0700 (PDT)
Received: from oberon.zico.biz ([151.251.243.123])
        by smtp.gmail.com with ESMTPSA id r19sm1312840ejr.55.2021.04.15.01.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:15:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Get the timestamp of the first recorded event as TSC offset
Date:   Thu, 15 Apr 2021 11:15:27 +0300
Message-Id: <20210415081527.3483835-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
References: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When converting TSC timestamps to nanoseconds, an offset is used. That
offset is subtracted from each TSC timestamp, before the conversion. At
the end of the trace, the lowest recorded TSC timestamp is selected as
TSC offset, that will be used for tsc2nsec conversion.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/include/trace-local.h |   1 +
 tracecmd/trace-record.c        | 146 ++++++++++++++++++++++++++-------
 2 files changed, 116 insertions(+), 31 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 1218de12..d504ea14 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -213,6 +213,7 @@ struct buffer_instance {
 	char			*name;
 	struct tracefs_instance	*tracefs;
 	unsigned long long	trace_id;
+	unsigned long long	first_ts;
 	char			*cpumask;
 	char			*output_file;
 	struct event_list	*events;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fd03a605..a7093fa2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -40,6 +40,7 @@
 #ifdef VSOCK
 #include <linux/vm_sockets.h>
 #endif
+#include <traceevent/kbuffer.h>
 
 #include "tracefs.h"
 #include "version.h"
@@ -685,34 +686,6 @@ add_tsc2nsec(struct tracecmd_output *handle, struct tsc_nsec *tsc2nsec)
 	tracecmd_add_option_v(handle, TRACECMD_OPTION_TSC2NSEC, vector, 3);
 }
 
-static void host_tsync_complete(struct common_record_context *ctx,
-				struct buffer_instance *instance)
-{
-	struct tracecmd_output *handle = NULL;
-	int fd = -1;
-	int ret;
-
-	ret = tracecmd_tsync_with_guest_stop(instance->tsync);
-	if (!ret) {
-		fd = open(instance->output_file, O_RDWR);
-		if (fd < 0)
-			die("error opening %s", instance->output_file);
-		handle = tracecmd_get_output_handle_fd(fd);
-		if (!handle)
-			die("cannot create output handle");
-
-		if (ctx->tsc2nsec.mult)
-			add_tsc2nsec(handle, &ctx->tsc2nsec);
-
-		tracecmd_write_guest_time_shift(handle, instance->tsync);
-		tracecmd_append_options(handle);
-		tracecmd_output_close(handle);
-	}
-
-	tracecmd_tsync_free(instance->tsync);
-	instance->tsync = NULL;
-}
-
 static void tell_guests_to_stop(struct common_record_context *ctx)
 {
 	struct buffer_instance *instance;
@@ -725,7 +698,7 @@ static void tell_guests_to_stop(struct common_record_context *ctx)
 
 	for_all_instances(instance) {
 		if (is_guest(instance))
-			host_tsync_complete(ctx, instance);
+			tracecmd_tsync_with_guest_stop(instance->tsync);
 	}
 
 	/* Wait for guests to acknowledge */
@@ -4183,7 +4156,100 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	free(clocks);
 }
 
-static void write_guest_file(struct buffer_instance *instance)
+int get_first_ts(char *file, unsigned long long *ts)
+{
+	enum kbuffer_long_size long_size;
+	enum kbuffer_endian endian;
+	struct kbuffer *kbuf = NULL;
+	int psize, rsize;
+	char *page = NULL;
+	int ret = -1;
+	char *data;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	psize = getpagesize();
+	page = calloc(1, psize);
+	if (!page)
+		goto error;
+
+	rsize = read(fd, page, psize);
+	if (rsize <= 0)
+		goto error;
+
+	if (tracecmd_host_bigendian())
+		endian = KBUFFER_ENDIAN_BIG;
+	else
+		endian = KBUFFER_ENDIAN_LITTLE;
+	if (sizeof(long) == 8)
+		long_size = KBUFFER_LSIZE_8;
+	else
+		long_size = KBUFFER_LSIZE_4;
+
+	kbuf = kbuffer_alloc(long_size, endian);
+	if (!kbuf)
+		goto error;
+
+	kbuffer_load_subbuffer(kbuf, page);
+	if (kbuffer_subbuffer_size(kbuf) > rsize)
+		goto error;
+
+	data = kbuffer_read_event(kbuf, ts);
+	if (!data)
+		goto error;
+
+	ret = 0;
+error:
+	if (kbuf)
+		kbuffer_free(kbuf);
+	free(page);
+	close(fd);
+	return ret;
+}
+
+void get_first_ts_instance(struct buffer_instance *instance)
+{
+	struct tracecmd_ts_corrections corrections;
+	unsigned long long first_ts = 0;
+	unsigned long long ts;
+	unsigned int flags;
+	int first_ts_cpu;
+	char *file;
+	int ret;
+	int i;
+
+	for (i = 0; i < instance->cpu_count; i++) {
+		file = get_temp_file(instance, i);
+		if (!file)
+			continue;
+		if (!get_first_ts(file, &ts)) {
+			if (!first_ts || ts < first_ts) {
+				first_ts = ts;
+				first_ts_cpu = i;
+			}
+		}
+		put_temp_file(file);
+	}
+	if (first_ts) {
+		if (is_guest(instance)) {
+			ret = tracecmd_tsync_get_proto_flags(instance->tsync, &flags);
+			if (ret)
+				return;
+			ret =  tracecmd_tsync_get_offsets(instance->tsync, first_ts_cpu, &corrections);
+			if (ret)
+				return;
+			instance->first_ts = tracecmd_guest_ts_calc(first_ts, &corrections, flags);
+			free(corrections.ts_samples);
+		} else  {
+			instance->first_ts = first_ts;
+		}
+	}
+}
+
+static void write_guest_file(struct common_record_context *ctx, struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle;
 	int cpu_count = instance->cpu_count;
@@ -4201,6 +4267,12 @@ static void write_guest_file(struct buffer_instance *instance)
 		die("error writing to %s", file);
 	if (instance->flags & BUFFER_FL_TSC2NSEC)
 		tracecmd_set_out_clock(handle, TSCNSEC_CLOCK);
+
+	if (ctx->tsc2nsec.mult)
+		add_tsc2nsec(handle, &ctx->tsc2nsec);
+	tracecmd_write_guest_time_shift(handle, instance->tsync);
+	tracecmd_append_options(handle);
+
 	temp_files = malloc(sizeof(*temp_files) * cpu_count);
 	if (!temp_files)
 		die("failed to allocate temp_files for %d cpus",
@@ -4219,6 +4291,9 @@ static void write_guest_file(struct buffer_instance *instance)
 	for (i = 0; i < cpu_count; i++)
 		put_temp_file(temp_files[i]);
 	free(temp_files);
+
+	tracecmd_tsync_free(instance->tsync);
+	instance->tsync = NULL;
 }
 
 static void record_data(struct common_record_context *ctx)
@@ -4231,9 +4306,18 @@ static void record_data(struct common_record_context *ctx)
 	char **temp_files;
 	int i;
 
+	if (ctx->tsc2nsec.mult) {
+		for_all_instances(instance) {
+			get_first_ts_instance(instance);
+			if (instance->first_ts &&
+			    (!ctx->tsc2nsec.offset || ctx->tsc2nsec.offset > instance->first_ts))
+				ctx->tsc2nsec.offset = instance->first_ts;
+		}
+	}
+
 	for_all_instances(instance) {
 		if (is_guest(instance))
-			write_guest_file(instance);
+			write_guest_file(ctx, instance);
 		else if (host && instance->msg_handle)
 			finish_network(instance->msg_handle);
 		else
-- 
2.30.2

