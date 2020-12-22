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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93F3C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 12:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6662312E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 12:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgLVMKi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 07:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgLVMKi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 07:10:38 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A9BC061793
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 04:09:57 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m5so14279465wrx.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 04:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fOhc0oTL/0y+7z+VzwCQrA+h8dPpfqWXzd4rl+UI8/0=;
        b=FFlWudLBi0hc58zIJxHmbo7GzdgoNgLpFiN5zaF/tAV5MucxALNEi5yUV8dzoAw3k7
         FeWR+tze1B1bqIH/KaEZ9NOgNOj6mWya5NHPUss8hr7tnbchxQKZtaHqwEzYo/24CYwl
         NKJ4Y5rd3yrNPfI7WXmnxYY+qhZHPrhfFkC16Tbq+2++N8Va5+V2hjcTmLy6tpt0L/LG
         zDBULFrkME3nwbKfNC3rro+/kKfJPOFKKaUdILQoDfU+JEpwNtS3NOBAQ6iqyEsKk8JK
         paZcstIu/K6h2vwmFdLzLpxvXhFJrjkKtJHIrwx8IzX5UKXz0HHQMv9EMFGoHCiwXz5h
         czlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fOhc0oTL/0y+7z+VzwCQrA+h8dPpfqWXzd4rl+UI8/0=;
        b=DYTmkXiHsH3mtjDp1ZE+1XbboTcLzVwKlfNKX4pGHV2Ysb66LT2SK1k33H1fG7hh+r
         yi5TxNG9/i3xLjkCe5yq2yPwLfVP5fmnArE5tgWDNSd8+BvDMszQgDJroJ5AFuYnZn8k
         KkMbf5U/0Qd1B/AD++6BRCze6zJE6vxH/Uy1bomZnbxQKqDgTe2gpbyN6SuYgLDmu6Wz
         Uii207t3MTnlifkOUZ6xWdPYXMX+hIzzyKWEUet7gEhXTtzL/cGEbNlAwe1QtodMBT4v
         y8nzomoFRC9FZ9uJuZo45/bn4wQmi1wgVHk2Le1EZ/JTt6plQ1ICCbNt/SU6ACopeyj6
         /4fw==
X-Gm-Message-State: AOAM530yJpJxhsRqXoEJTesWpphQOCRXgpeDkhKwLzzNbdHWoYK0J7cn
        JjVZaFemZrA+6YOA13QVlNJ9p5L6tbKyZUiS
X-Google-Smtp-Source: ABdhPJyrlnOG2/m16ynD0E4rsBQmqQWTqHC/J/7/qRbuKNz0aK/fMieegOj5qAcp4aB2NKRP2em7Pg==
X-Received: by 2002:a05:6000:1152:: with SMTP id d18mr24053915wrx.6.1608638996347;
        Tue, 22 Dec 2020 04:09:56 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm28168576wma.3.2020.12.22.04.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 04:09:55 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Rename tracecmd_get_pevent() to tracecmd_get_tep()
Date:   Tue, 22 Dec 2020 14:09:51 +0200
Message-Id: <20201222120951.492370-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201222120951.492370-1-tz.stoyanov@gmail.com>
References: <20201222120951.492370-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The name of the trace event context from libtraceevent library
is tep, all APIs that work with a pointer to this context should refer
to it as "tep".

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h  |  2 +-
 kernel-shark/src/libkshark.c   |  2 +-
 lib/trace-cmd/trace-blk-hack.c |  2 +-
 lib/trace-cmd/trace-ftrace.c   |  2 +-
 lib/trace-cmd/trace-input.c    |  4 ++--
 lib/trace-cmd/trace-output.c   |  8 ++++----
 tracecmd/trace-hist.c          |  2 +-
 tracecmd/trace-mem.c           |  2 +-
 tracecmd/trace-profile.c       |  2 +-
 tracecmd/trace-read.c          | 22 +++++++++++-----------
 tracecmd/trace-split.c         |  4 ++--
 11 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 9d9a61d3..75352309 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -26,7 +26,7 @@ tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
 		 int *cpu);
 void tracecmd_free_record(struct tep_record *record);
 
-struct tep_handle *tracecmd_get_pevent(struct tracecmd_input *handle);
+struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle);
 unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
 int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 			      unsigned long long trace_id,
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 9823ccc9..8f5dcb00 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -155,7 +155,7 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 	}
 
 	kshark_ctx->handle = handle;
-	kshark_ctx->pevent = tracecmd_get_pevent(handle);
+	kshark_ctx->pevent = tracecmd_get_tep(handle);
 
 	kshark_ctx->advanced_event_filter =
 		tep_filter_alloc(kshark_ctx->pevent);
diff --git a/lib/trace-cmd/trace-blk-hack.c b/lib/trace-cmd/trace-blk-hack.c
index 4f5953ad..2a05cf98 100644
--- a/lib/trace-cmd/trace-blk-hack.c
+++ b/lib/trace-cmd/trace-blk-hack.c
@@ -39,7 +39,7 @@ int tracecmd_blk_hack(struct tracecmd_input *handle)
 	int l;
 	int r;
 
-	pevent = tracecmd_get_pevent(handle);
+	pevent = tracecmd_get_tep(handle);
 
 	/*
 	 * Unfortunately, the TRACE_BLK has changed a bit.
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 03e60eb0..f74f7c2e 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -370,7 +370,7 @@ int tracecmd_ftrace_overrides(struct tracecmd_input *handle,
 
 	finfo->handle = handle;
 
-	pevent = tracecmd_get_pevent(handle);
+	pevent = tracecmd_get_tep(handle);
 
 	tep_register_event_handler(pevent, -1, "ftrace", "function",
 				      function_handler, NULL);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e57492e9..9dda0dd5 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3776,10 +3776,10 @@ int tracecmd_cpus(struct tracecmd_input *handle)
 }
 
 /**
- * tracecmd_get_pevent - return the pevent handle
+ * tracecmd_get_tep - return the tep handle
  * @handle: input handle for the trace.dat file
  */
-struct tep_handle *tracecmd_get_pevent(struct tracecmd_input *handle)
+struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle)
 {
 	return handle->pevent;
 }
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index de76e3e7..032c8ff4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -877,9 +877,9 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 
 	/* get endian and page size */
 	if (ihandle) {
-		pevent = tracecmd_get_pevent(ihandle);
+		pevent = tracecmd_get_tep(ihandle);
 		/* Use the pevent of the ihandle for later writes */
-		handle->pevent = tracecmd_get_pevent(ihandle);
+		handle->pevent = tracecmd_get_tep(ihandle);
 		tep_ref(pevent);
 		if (tep_is_file_bigendian(pevent))
 			buf[0] = 1;
@@ -1433,9 +1433,9 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->fd = fd;
 
 	/* get endian and page size */
-	pevent = tracecmd_get_pevent(ihandle);
+	pevent = tracecmd_get_tep(ihandle);
 	/* Use the pevent of the ihandle for later writes */
-	handle->pevent = tracecmd_get_pevent(ihandle);
+	handle->pevent = tracecmd_get_tep(ihandle);
 	tep_ref(pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	list_head_init(&handle->options);
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 76e8cae2..ea9b2bef 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -933,7 +933,7 @@ static void print_chains(struct tep_handle *pevent)
 
 static void do_trace_hist(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = tracecmd_get_pevent(handle);
+	struct tep_handle *pevent = tracecmd_get_tep(handle);
 	struct tep_record *record;
 	struct tep_event *event;
 	int cpus;
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index c6cc7dee..2eb75a00 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -461,7 +461,7 @@ static void print_list(void)
 
 static void do_trace_mem(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = tracecmd_get_pevent(handle);
+	struct tep_handle *pevent = tracecmd_get_tep(handle);
 	struct tep_record *record;
 	struct tep_event *event;
 	int missed_events = 0;
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index b82110e6..e3a75143 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -1267,7 +1267,7 @@ static int handle_sched_wakeup_event(struct handle_data *h,
 void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 			int global)
 {
-	struct tep_handle *pevent = tracecmd_get_pevent(handle);
+	struct tep_handle *pevent = tracecmd_get_tep(handle);
 	struct tep_format_field **fields;
 	struct handle_data *h;
 	struct event_data *event_data;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 11293bc8..d07f4efe 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -150,7 +150,7 @@ enum time_fmt {
 
 static const char *time_format(struct tracecmd_input *handle, enum time_fmt tf)
 {
-	struct tep_handle *tep = tracecmd_get_pevent(handle);
+	struct tep_handle *tep = tracecmd_get_tep(handle);
 
 	switch (tf) {
 	case TIME_FMT_LAT:
@@ -171,7 +171,7 @@ static const char *time_format(struct tracecmd_input *handle, enum time_fmt tf)
 static void print_event(struct trace_seq *s, struct tracecmd_input *handle,
 			struct tep_record *record)
 {
-	struct tep_handle *tep = tracecmd_get_pevent(handle);
+	struct tep_handle *tep = tracecmd_get_tep(handle);
 	struct tep_event *event;
 	const char *lfmt = time_format(handle, TIME_FMT_LAT);
 	const char *tfmt = time_format(handle, TIME_FMT_NORMAL);
@@ -481,7 +481,7 @@ static void convert_comm_filter(struct tracecmd_input *handle)
 	if (!comm_list)
 		return;
 
-	pevent = tracecmd_get_pevent(handle);
+	pevent = tracecmd_get_tep(handle);
 
 	/* Seach for comm names and get their pids */
 	for (list = comm_list; list; list = list->next) {
@@ -545,7 +545,7 @@ static void process_filters(struct handle_list *handles)
 	int filters = 0;
 	int ret;
 
-	pevent = tracecmd_get_pevent(handles->handle);
+	pevent = tracecmd_get_tep(handles->handle);
 
 	make_pid_filter(handles->handle);
 
@@ -592,7 +592,7 @@ static void init_wakeup(struct tracecmd_input *handle)
 	if (!show_wakeup)
 		return;
 
-	pevent = tracecmd_get_pevent(handle);
+	pevent = tracecmd_get_tep(handle);
 
 	trace_hash_init(&wakeup_hash, WAKEUP_HASH_SIZE);
 
@@ -829,7 +829,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		return;
 	}
 
-	pevent = tracecmd_get_pevent(handle);
+	pevent = tracecmd_get_tep(handle);
 	event = tep_find_event_by_record(pevent, record);
 	use_trace_clock = tracecmd_get_use_trace_clock(handle);
 
@@ -1028,7 +1028,7 @@ test_stacktrace(struct handle_list *handles, struct tep_record *record,
 				die("Failed to allocate for %d cpus", info->nr_cpus);
 			memset(info->cpus, 0, sizeof(*info->cpus));
 
-			pevent = tracecmd_get_pevent(h->handle);
+			pevent = tracecmd_get_tep(h->handle);
 			event = tep_find_event_by_name(pevent, "ftrace",
 						       "kernel_stack");
 			if (event)
@@ -1044,7 +1044,7 @@ test_stacktrace(struct handle_list *handles, struct tep_record *record,
 	}
 
 	handle = handles->handle;
-	pevent = tracecmd_get_pevent(handle);
+	pevent = tracecmd_get_tep(handle);
 
 	for (info = infos; info; info = info->next)
 		if (info->handles == handles)
@@ -1087,7 +1087,7 @@ static struct tep_record *get_next_record(struct handle_list *handles)
 	if (handles->done)
 		return NULL;
 
-	pevent = tracecmd_get_pevent(handles->handle);
+	pevent = tracecmd_get_tep(handles->handle);
 
 	do {
 		if (filter_cpus) {
@@ -1247,7 +1247,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		}
 
 		/* Find the kernel_stacktrace if available */
-		pevent = tracecmd_get_pevent(handles->handle);
+		pevent = tracecmd_get_tep(handles->handle);
 		event = tep_find_event_by_name(pevent, "ftrace", "kernel_stack");
 		if (event)
 			stacktrace_id = event->id;
@@ -1795,7 +1795,7 @@ void trace_report (int argc, char **argv)
 		else if (ts2secs)
 			tracecmd_set_ts2secs(handle, ts2secs);
 
-		pevent = tracecmd_get_pevent(handle);
+		pevent = tracecmd_get_tep(handle);
 
 		if (nanosec)
 			tep_set_flag(pevent, TEP_NSEC_OUTPUT);
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index f6ab970b..9d347b36 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -87,7 +87,7 @@ static int write_record(struct tracecmd_input *handle,
 
 	page = cpu_data->page;
 
-	pevent = tracecmd_get_pevent(handle);
+	pevent = tracecmd_get_tep(handle);
 
 	ptr = page + cpu_data->index;
 
@@ -191,7 +191,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 
 	long_size = tracecmd_long_size(handle);
 	page_size = tracecmd_page_size(handle);
-	pevent = tracecmd_get_pevent(handle);
+	pevent = tracecmd_get_tep(handle);
 
 	/* Force new creation of first page */
 	if (percpu) {
-- 
2.28.0

