Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AABC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BDCF61073
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 10:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhDPKem (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 06:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240007AbhDPKel (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 06:34:41 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75444C061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:34:15 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g9so10176037wrx.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 03:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o6r6K3NRWZE89fABpGKkl6juSjH9qaNs6FdwgA1CtqQ=;
        b=X9SjI2ho50GK2ABBnJudj2nksR+KzquctAeGsSuDCSFk4dtJBq9YwNYpCcKnoGZC4X
         E2hE4maHVhzCzmiYL0UOSym94bwvMvg83tlNT0NDC9xGjRXUsuUrxJ7zc37L3YnCWSvG
         IrQsLjjEU8V/vFF7MH/fIXLackhkxp/q2MBUpymGaBMnOjKgDzqxLi9JtdFx4pS3kdbn
         NoXfTXPT85CL+f/dR5HhcGKXgR+nkp0UfhJY41BWWZ5TnAMYKYp/Coas3HBLCPvMaHSU
         3GwrWrVTrVVfSw7ouiFD56k+kNwyHP3fS5gZUL+VQrwReQjsoPXBMh8euHT5nvM2TUm4
         dpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o6r6K3NRWZE89fABpGKkl6juSjH9qaNs6FdwgA1CtqQ=;
        b=E568rupl0pbfT+FlzJG5wMGmjjcggSBwacp2xDeNAh/UxwUFCZWxTQfoSjxDE0B2KR
         TS2XcD6def0cc436eLybn6s16T5qvG1eyYhYCsEaYMPBEFnmbFaE2oJOgijEKxrzQ8xr
         dlqb9UyX5x/Wp9SWVcMdikJ3uKZn379ainIIymrEuyOPwsJSHFEJdApSsoqa8ptWCfm5
         jO16zQQyh72QCgJ0+EB4wcTxWziy+UPUVD6JpKMWuEMgn2pVKPU3eWUYspz3gzwzbsKj
         W1N4mynftf24zBva/5+6qn6815juqvaED8qVYtZ/C1CxeH9SIbHZliLtQ1OTkA/yVtxV
         hU/Q==
X-Gm-Message-State: AOAM531ww1f0mL/PIy0veP3FoHVI8oMIPZNctX0U37IpQ2f4vrtdmczJ
        j+C/RqD069KWDf6rKYPYH0w=
X-Google-Smtp-Source: ABdhPJz10L8JK1rYf13d6IU1YxHFW03k7qqGuTeJze5tUVaR2/hTxI+sTV1T/Tlq8URrTo8I2sDA7Q==
X-Received: by 2002:a05:6000:1816:: with SMTP id m22mr8427919wrh.260.1618569254206;
        Fri, 16 Apr 2021 03:34:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v8sm9652139wrt.71.2021.04.16.03.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 03:34:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/3] trace-cmd: Get the timestamp of the first recorded event as TSC offset
Date:   Fri, 16 Apr 2021 13:34:09 +0300
Message-Id: <20210416103409.24597-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416103409.24597-1-tz.stoyanov@gmail.com>
References: <20210416103409.24597-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c        | 152 ++++++++++++++++++++++++++-------
 2 files changed, 122 insertions(+), 31 deletions(-)

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
index fd03a605..b78b8af9 100644
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
@@ -4183,7 +4156,105 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
 	free(clocks);
 }
 
-static void write_guest_file(struct buffer_instance *instance)
+int get_first_ts(struct kbuffer *kbuf, char *page, int psize, const char *file, unsigned long long *ts)
+{
+	int rsize;
+	int ret = -1;
+	char *data;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	rsize = read(fd, page, psize);
+	if (rsize <= 0)
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
+	close(fd);
+	return ret;
+}
+
+int get_first_ts_instance(struct buffer_instance *instance)
+{
+	struct tracecmd_ts_corrections corrections;
+	unsigned long long first_ts = 0;
+	enum kbuffer_long_size long_size;
+	enum kbuffer_endian endian;
+	struct kbuffer *kbuf = NULL;
+	unsigned long long ts;
+	unsigned int flags;
+	int first_ts_cpu;
+	bool first = true;
+	char *page;
+	char *file;
+	int psize;
+	int ret;
+	int i;
+
+	psize = getpagesize();
+	page = calloc(1, psize);
+	if (!page)
+		return -1;
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
+		goto out;
+
+	for (i = 0; i < instance->cpu_count; i++) {
+		file = get_temp_file(instance, i);
+		if (!file)
+			continue;
+		if (!get_first_ts(kbuf, page, psize, file, &ts)) {
+			if (first || ts < first_ts) {
+				first_ts = ts;
+				first_ts_cpu = i;
+				first = false;
+			}
+		}
+		put_temp_file(file);
+	}
+	if (!first) {
+		if (is_guest(instance)) {
+			ret = tracecmd_tsync_get_proto_flags(instance->tsync, &flags);
+			if (ret)
+				goto out;
+			ret =  tracecmd_tsync_get_offsets(instance->tsync, first_ts_cpu, &corrections);
+			if (ret)
+				goto out;
+			instance->first_ts = tracecmd_guest_ts_calc(first_ts, &corrections, flags);
+			free(corrections.ts_samples);
+		} else  {
+			instance->first_ts = first_ts;
+		}
+	}
+
+out:
+	kbuffer_free(kbuf);
+	free(page);
+	return first ? -1 : 0;
+}
+
+static void write_guest_file(struct common_record_context *ctx, struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle;
 	int cpu_count = instance->cpu_count;
@@ -4201,6 +4272,12 @@ static void write_guest_file(struct buffer_instance *instance)
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
@@ -4219,6 +4296,9 @@ static void write_guest_file(struct buffer_instance *instance)
 	for (i = 0; i < cpu_count; i++)
 		put_temp_file(temp_files[i]);
 	free(temp_files);
+
+	tracecmd_tsync_free(instance->tsync);
+	instance->tsync = NULL;
 }
 
 static void record_data(struct common_record_context *ctx)
@@ -4229,11 +4309,21 @@ static void record_data(struct common_record_context *ctx)
 	bool local = false;
 	int max_cpu_count = local_cpu_count;
 	char **temp_files;
+	int ret;
 	int i;
 
+	if (ctx->tsc2nsec.mult) {
+		for_all_instances(instance) {
+			ret = get_first_ts_instance(instance);
+			if (!ret &&
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

