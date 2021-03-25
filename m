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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D910C433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F35C61A1E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 07:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCYHOc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 03:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhCYHOU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 03:14:20 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FAAC06175F
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:14:19 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v4so1137313wrp.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 00:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6H5X34djLj6aslcjonc1F9JN1n1EpZSApu1HPrLR3hA=;
        b=eaTjUMMjMmvr+p8or2KgfglXGAeDKcqOeZqZ4jnOKA8IiMN3l4rGuJ/uGoDyVf+xo3
         OR29Yi4E8jh/CR+SbdMoPsJLDWOG7o5/3rkFZYV6uXCvvnz+tDrAgmH02ypblClUFauf
         XbvYGZ0HFhzPWdJlf8E831Wa9wdDtsbODP4Tgqvfxeb80mrVgb6Jn/V7O/c6U3+Budtr
         wCexWGcaPOmDuwIApD5VPXYLF5anrxYrCd5xio0MD0/me8FIc7kFj/MSX9suNN1hN625
         E0lywY2M2cHP8g7ha7H2iTQok9Xv9o8HClJ6qKvR0w01ABKWwoY1w6aU8fId7Sgb++Cw
         5Lqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6H5X34djLj6aslcjonc1F9JN1n1EpZSApu1HPrLR3hA=;
        b=hLcJBfbv+L6A7Uyp5EXsZLljJsPtkNTr9j9tkIy4kX6Hus0iQ+rHH/YjnWzEHhIKyZ
         cSyhjw09X2im7tBJ61E4tFAjzgwDxtHazIQ6gGfZsxTsyK7xAQhQYrIQ2E6UVLDR8JrX
         aUZUgAriNu74tG7kWNTnoO4oaa3CEKbInIs+tDJaNFilm5ivmDvrd/9WutJ8h5nHwreb
         a35Q729BdKDQSAPJaJlBnYLqNR6eQXvfPrLiD7LPYen2bQHkL9MxSq8a4tsgxefCi94b
         zC/nAvWPEBtM8mmbglisqUmmeUJbiDWqAgblOeE20rNFw987zaN8cxnzwglM9kRcshC3
         FbLA==
X-Gm-Message-State: AOAM532sx/7fpfeRS61p6x3jZbIPUwGQpKp7lVjO/+Bt5b8qtOdrtw0o
        dP1f2szTPUqvpcN8/EVD/I0=
X-Google-Smtp-Source: ABdhPJyXlCkMsOd/O84/ptBz6kw3EFtyWcc7QgVNgExOty4VRARx4PdjyXrfFbvJfOcKvi06V+cE1w==
X-Received: by 2002:a5d:4fcb:: with SMTP id h11mr5996691wrw.53.1616656458255;
        Thu, 25 Mar 2021 00:14:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q4sm5177487wma.20.2021.03.25.00.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 00:14:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, stefano.devenuto99@gmail.com
Subject: [PATCH v33 2/5] trace-cmd: Add timestamp synchronization per vCPU
Date:   Thu, 25 Mar 2021 09:14:10 +0200
Message-Id: <20210325071413.543640-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325071413.543640-1-tz.stoyanov@gmail.com>
References: <20210325071413.543640-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Timestamp synchronization logic is changed to work per virtual CPU. Some
hypervisors maintain time offset and scaling per vCPU. The host-guest
communication protocol is changed to request time stamp offset calculation
for particular vCPU. The guest thread, responsible for running that logic
is pinned to the requested CPU. The time sync medata data, saved in the
trace.dat file is changed to an array of vCPUs. When an event time stamp
is corrected, the CPU on that the event happened is used to get the
correct offset.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   2 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  22 +-
 lib/trace-cmd/trace-input.c                   | 175 +++++++----
 lib/trace-cmd/trace-timesync.c                | 281 +++++++++++++-----
 tracecmd/trace-dump.c                         |  52 ++--
 5 files changed, 361 insertions(+), 171 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index fdca7494..899b3fef 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -455,7 +455,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 			  unsigned int cid, unsigned int port, int guest_pid,
 			  int guest_cpus, const char *proto_name, const char *clock);
 int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync);
-int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
+int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
 				int *count, long long **ts,
 				long long **offsets, long long **scalings);
 int tracecmd_tsync_get_session_params(struct tracecmd_time_sync *tsync,
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 5cf4f843..b3a3bdfc 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -24,12 +24,7 @@ struct tracecmd_time_sync {
 	int				vcpu_count;
 };
 
-struct clock_sync_context {
-	void				*proto_data;	/* time sync protocol specific data */
-	bool				is_server;	/* server side time sync role */
-	bool				is_guest;	/* guest or host time sync role */
-	struct tracefs_instance		*instance;	/* ftrace buffer, used for time sync events */
-
+struct clock_sync_offsets {
 	/* Arrays with calculated time offsets at given time */
 	int				sync_size;	/* Allocated size of sync_ts,
 							 * sync_offsets and sync_scalings
@@ -40,6 +35,18 @@ struct clock_sync_context {
 	long long			*sync_ts;
 	long long			*sync_offsets;
 	long long			*sync_scalings;
+};
+
+struct clock_sync_context {
+	void				*proto_data;	/* time sync protocol specific data */
+	bool				is_server;	/* server side time sync role */
+	bool				is_guest;	/* guest or host time sync role */
+	struct tracefs_instance		*instance;	/* ftrace buffer, used for time sync events */
+
+	int				cpu_count;
+	struct clock_sync_offsets	*offsets;	/* Array of size cpu_count
+							 * calculated offsets per CPU
+							 */
 
 	/* Identifiers of local and remote time sync peers: cid and port */
 	unsigned int			local_cid;
@@ -53,7 +60,8 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
-					      long long *, long long *, long long *));
+					      long long *, long long *,
+					      long long *, unsigned int));
 int tracecmd_tsync_proto_unregister(char *proto_name);
 
 int ptp_clock_sync_register(void);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index c0b47345..2f7ba5db 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -91,12 +91,19 @@ struct guest_trace_info {
 	int			*cpu_pid;
 };
 
+struct timesync_offsets {
+	int	ts_samples_count;
+	struct ts_offset_sample	*ts_samples;
+};
+
 struct host_trace_info {
 	unsigned long long	peer_trace_id;
 	unsigned int		flags;
 	bool			sync_enable;
 	int			ts_samples_count;
 	struct ts_offset_sample	*ts_samples;
+	int			cpu_count;
+	struct timesync_offsets	*ts_offsets;
 };
 
 struct tsc2nsec {
@@ -1241,50 +1248,54 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
 	return ts + tscor;
 }
 
-static unsigned long long timestamp_host_sync(unsigned long long ts,
+static unsigned long long timestamp_host_sync(unsigned long long ts, int cpu,
 					      struct tracecmd_input *handle)
 {
-	struct host_trace_info	*host = &handle->host;
+	struct timesync_offsets *tsync;
 	int min, mid, max;
 
+	if (cpu >= handle->host.cpu_count)
+		return ts;
+	tsync = &handle->host.ts_offsets[cpu];
+
 	/* We have one sample, nothing to calc here */
-	if (host->ts_samples_count == 1)
-		return ts + host->ts_samples[0].offset;
+	if (tsync->ts_samples_count == 1)
+		return ts + tsync->ts_samples[0].offset;
 
 	/* We have two samples, nothing to search here */
-	if (host->ts_samples_count == 2)
-		return timestamp_correction_calc(ts, host->flags,
-						 &host->ts_samples[0],
-						 &host->ts_samples[1]);
+	if (tsync->ts_samples_count == 2)
+		return timestamp_correction_calc(ts, handle->host.flags,
+						 &tsync->ts_samples[0],
+						 &tsync->ts_samples[1]);
 
 	/* We have more than two samples */
-	if (ts <= host->ts_samples[0].time)
-		return timestamp_correction_calc(ts, host->flags,
-						 &host->ts_samples[0],
-						 &host->ts_samples[1]);
-	else if (ts >= host->ts_samples[host->ts_samples_count-1].time)
-		return timestamp_correction_calc(ts, host->flags,
-						 &host->ts_samples[host->ts_samples_count-2],
-						 &host->ts_samples[host->ts_samples_count-1]);
+	if (ts <= tsync->ts_samples[0].time)
+		return timestamp_correction_calc(ts, handle->host.flags,
+						 &tsync->ts_samples[0],
+						 &tsync->ts_samples[1]);
+	else if (ts >= tsync->ts_samples[tsync->ts_samples_count-1].time)
+		return timestamp_correction_calc(ts, handle->host.flags,
+						 &tsync->ts_samples[tsync->ts_samples_count-2],
+						 &tsync->ts_samples[tsync->ts_samples_count-1]);
 	min = 0;
-	max = host->ts_samples_count-1;
+	max = tsync->ts_samples_count-1;
 	mid = (min + max)/2;
 	while (min <= max) {
-		if (ts < host->ts_samples[mid].time)
+		if (ts < tsync->ts_samples[mid].time)
 			max = mid - 1;
-		else if (ts > host->ts_samples[mid].time)
+		else if (ts > tsync->ts_samples[mid].time)
 			min = mid + 1;
 		else
 			break;
 		mid = (min + max)/2;
 	}
 
-	return timestamp_correction_calc(ts, host->flags,
-					 &host->ts_samples[mid],
-					 &host->ts_samples[mid+1]);
+	return timestamp_correction_calc(ts, handle->host.flags,
+					 &tsync->ts_samples[mid],
+					 &tsync->ts_samples[mid+1]);
 }
 
-static unsigned long long timestamp_calc(unsigned long long ts,
+static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
 					 struct tracecmd_input *handle)
 {
 	/* do not modify raw timestamps */
@@ -1293,7 +1304,7 @@ static unsigned long long timestamp_calc(unsigned long long ts,
 
 	/* Guest trace file, sync with host timestamps */
 	if (handle->host.sync_enable)
-		ts = timestamp_host_sync(ts, handle);
+		ts = timestamp_host_sync(ts, cpu, handle);
 
 	if (handle->ts2secs) {
 		/* user specified clock frequency */
@@ -1333,7 +1344,7 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		return -1;
 	}
 	handle->cpu_data[cpu].timestamp = timestamp_calc(kbuffer_timestamp(kbuf),
-							 handle);
+							 cpu, handle);
 
 	return 0;
 }
@@ -1963,7 +1974,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = timestamp_calc(ts, handle);
+	handle->cpu_data[cpu].timestamp = timestamp_calc(ts, cpu, handle);
 
 	index = kbuffer_curr_offset(kbuf);
 
@@ -2293,34 +2304,79 @@ static int tsync_offset_cmp(const void *a, const void *b)
 	return 0;
 }
 
-static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
+#define safe_read(R, C)					\
+	do {						\
+		if ((C) > size)				\
+			return -EFAULT;			\
+		(R) = tep_read_number(tep, buf, (C));	\
+		buf += (C);				\
+		size -= (C);				\
+	} while (0)
+
+#define safe_read_loop(type)						\
+	do {								\
+		int i;							\
+		for (i = 0; i < ts_offsets->ts_samples_count; i++)	\
+			safe_read(ts_offsets->ts_samples[i].type, 8);	\
+	} while (0)
+
+static int tsync_offset_load(struct tep_handle	*tep,
+			     struct timesync_offsets *ts_offsets, char *buf, int size)
 {
-	struct host_trace_info *host = &handle->host;
-	long long *buf8 = (long long *)buf;
+	int start_size = size;
 	int i, j;
 
-	for (i = 0; i < host->ts_samples_count; i++) {
-		host->ts_samples[i].time = tep_read_number(handle->pevent,
-							   buf8 + i, 8);
-		host->ts_samples[i].offset = tep_read_number(handle->pevent,
-						buf8 + host->ts_samples_count + i, 8);
-		host->ts_samples[i].scaling = tep_read_number(handle->pevent,
-						buf8 + (2 * host->ts_samples_count) + i, 8);
-	}
-	qsort(host->ts_samples, host->ts_samples_count,
+	safe_read_loop(time);
+	safe_read_loop(offset);
+	safe_read_loop(scaling);
+	qsort(ts_offsets->ts_samples, ts_offsets->ts_samples_count,
 	      sizeof(struct ts_offset_sample), tsync_offset_cmp);
 	/* Filter possible samples with equal time */
-	for (i = 0, j = 0; i < host->ts_samples_count; i++) {
-		if (i == 0 || host->ts_samples[i].time != host->ts_samples[i-1].time)
-			host->ts_samples[j++] = host->ts_samples[i];
+	for (i = 0, j = 0; i < ts_offsets->ts_samples_count; i++) {
+		if (i == 0 || ts_offsets->ts_samples[i].time != ts_offsets->ts_samples[i-1].time)
+			ts_offsets->ts_samples[j++] = ts_offsets->ts_samples[i];
 	}
-	host->ts_samples_count = j;
+	ts_offsets->ts_samples_count = j;
+
+	return start_size - size;
+}
+
+static int tsync_cpu_offsets_load(struct tracecmd_input *handle, char *buf, int size)
+{
+	struct tep_handle *tep = handle->pevent;
+	int ret;
+	int i;
+
+	safe_read(handle->host.cpu_count, 4);
+	handle->host.ts_offsets = calloc(handle->host.cpu_count,
+					 sizeof(struct timesync_offsets));
+	if (!handle->host.ts_offsets)
+		return -ENOMEM;
+	for (i = 0; i < handle->host.cpu_count; i++) {
+		safe_read(handle->host.ts_offsets[i].ts_samples_count, 4);
+		handle->host.ts_offsets[i].ts_samples = calloc(handle->host.ts_offsets[i].ts_samples_count,
+							       sizeof(struct ts_offset_sample));
+		if (!handle->host.ts_offsets[i].ts_samples)
+			return -ENOMEM;
+		ret = tsync_offset_load(tep, &handle->host.ts_offsets[i], buf, size);
+		if (ret <= 0)
+			return -EFAULT;
+		size -= ret;
+		buf += ret;
+	}
+	return 0;
 }
 
 static void trace_tsync_offset_free(struct host_trace_info *host)
 {
-	free(host->ts_samples);
-	host->ts_samples = NULL;
+	int i;
+
+	if (host->ts_offsets) {
+		for (i = 0; i < host->cpu_count; i++)
+			free(host->ts_offsets[i].ts_samples);
+		free(host->ts_offsets);
+		host->ts_offsets = NULL;
+	}
 }
 
 static int trace_pid_map_cmp(const void *a, const void *b)
@@ -2574,8 +2630,8 @@ static int handle_options(struct tracecmd_input *handle)
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
-	int samples_size;
 	int cpus;
+	int ret;
 
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
@@ -2627,11 +2683,15 @@ static int handle_options(struct tracecmd_input *handle)
 			/*
 			 * long long int (8 bytes) trace session ID
 			 * int (4 bytes) protocol flags.
-			 * int (4 bytes) count of timestamp offsets.
-			 * long long array of size [count] of times,
+			 * int (4 bytes) CPU count.
+			 * array of size [CPU count]:
+			 * [
+			 *  int (4 bytes) count of timestamp offsets.
+			 *  long long array of size [count] of times,
 			 *      when the offsets were calculated.
-			 * long long array of size [count] of timestamp offsets.
-			 * long long array of size [count] of timestamp scaling ratios.*
+			 *  long long array of size [count] of timestamp offsets.
+			 *  long long array of size [count] of timestamp scaling ratios.*
+			 * ]
 			 */
 			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
@@ -2639,18 +2699,9 @@ static int handle_options(struct tracecmd_input *handle)
 								     buf, 8);
 			handle->host.flags = tep_read_number(handle->pevent,
 							     buf + 8, 4);
-			handle->host.ts_samples_count = tep_read_number(handle->pevent,
-									buf + 12, 4);
-			samples_size = (8 * handle->host.ts_samples_count);
-			if (size != (16 + (2 * samples_size))) {
-				warning("Failed to extract Time Shift information from the file: found size %d, expected is %d",
-					size, 16 + (2 * samples_size));
-				break;
-			}
-			handle->host.ts_samples = malloc(2 * samples_size);
-			if (!handle->host.ts_samples)
-				return -ENOMEM;
-			tsync_offset_load(handle, buf + 16);
+			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
+			if (ret < 0)
+				return ret;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
@@ -4057,7 +4108,7 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
 {
 	if (enable &&
-	    (!handle->host.ts_samples || !handle->host.ts_samples_count))
+	    (!handle->host.ts_offsets || !handle->host.cpu_count))
 		return -1;
 
 	handle->host.sync_enable = enable;
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 62f5dc1e..556004f1 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -36,9 +36,13 @@ struct tsync_proto {
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_calc)(struct tracecmd_time_sync *clock_context,
 			       long long *offset, long long *scaling,
-			       long long *timestamp);
+			       long long *timestamp, unsigned int cpu);
 };
 
+struct tsync_probe_request_msg {
+	unsigned short	cpu;
+} __packed;
+
 static struct tsync_proto *tsync_proto_list;
 
 static struct tsync_proto *tsync_proto_find(const char *proto_name)
@@ -68,7 +72,8 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
-					      long long *, long long *, long long *))
+					      long long *, long long *,
+					      long long *, unsigned int))
 {
 	struct tsync_proto *proto = NULL;
 
@@ -80,6 +85,7 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 	strncpy(proto->proto_name, proto_name, TRACECMD_TSYNC_PNAME_LENGTH);
 	proto->accuracy = accuracy;
 	proto->roles = roles;
+	proto->flags = flags;
 	proto->supported_clocks = supported_clocks;
 	proto->clock_sync_init = init;
 	proto->clock_sync_free = free;
@@ -122,6 +128,7 @@ bool tsync_proto_is_supported(const char *proto_name)
  * tracecmd_tsync_get_offsets - Return the calculated time offsets
  *
  * @tsync: Pointer to time sync context
+ * @cpu: CPU for which to get the calculated offsets
  * @count: Returns the number of calculated time offsets
  * @ts: Array of size @count containing timestamps of callculated offsets
  * @offsets: array of size @count, containing offsets for each timestamp
@@ -129,23 +136,25 @@ bool tsync_proto_is_supported(const char *proto_name)
  *
  * Retuns -1 in case of an error, or 0 otherwise
  */
-int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
-				int *count, long long **ts,
-				long long **offsets, long long **scalings)
+int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
+			       int *count, long long **ts,
+			       long long **offsets, long long **scalings)
 {
 	struct clock_sync_context *tsync_context;
 
 	if (!tsync || !tsync->context)
 		return -1;
 	tsync_context = (struct clock_sync_context *)tsync->context;
+	if (cpu >= tsync_context->cpu_count || !tsync_context->offsets)
+		return -1;
 	if (count)
-		*count = tsync_context->sync_count;
+		*count = tsync_context->offsets[cpu].sync_count;
 	if (ts)
-		*ts = tsync_context->sync_ts;
+		*ts = tsync_context->offsets[cpu].sync_ts;
 	if (offsets)
-		*offsets = tsync_context->sync_offsets;
+		*offsets = tsync_context->offsets[cpu].sync_offsets;
 	if (scalings)
-		*scalings = tsync_context->sync_scalings;
+		*scalings = tsync_context->offsets[cpu].sync_scalings;
 
 	return 0;
 }
@@ -496,6 +505,13 @@ static int clock_context_init(struct tracecmd_time_sync *tsync,
 	if (!clock->instance)
 		goto error;
 
+	clock->cpu_count = tsync->vcpu_count;
+	if (clock->cpu_count) {
+		clock->offsets = calloc(clock->cpu_count, sizeof(struct clock_sync_offsets));
+		if (!clock->offsets)
+			goto error;
+	}
+
 	tsync->context = clock;
 	if (protocol->clock_sync_init && protocol->clock_sync_init(tsync) < 0)
 		goto error;
@@ -505,6 +521,9 @@ static int clock_context_init(struct tracecmd_time_sync *tsync,
 	return 0;
 error:
 	tsync->context = NULL;
+	if (clock->instance)
+		clock_synch_delete_instance(clock->instance);
+	free(clock->offsets);
 	free(clock);
 	return -1;
 }
@@ -520,6 +539,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 {
 	struct clock_sync_context *tsync_context;
 	struct tsync_proto *proto;
+	int i;
 
 	if (!tsync->context)
 		return;
@@ -532,14 +552,20 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	clock_synch_delete_instance(tsync_context->instance);
 	tsync_context->instance = NULL;
 
-	free(tsync_context->sync_ts);
-	free(tsync_context->sync_offsets);
-	free(tsync_context->sync_scalings);
-	tsync_context->sync_ts = NULL;
-	tsync_context->sync_offsets = NULL;
-	tsync_context->sync_scalings = NULL;
-	tsync_context->sync_count = 0;
-	tsync_context->sync_size = 0;
+	if (tsync_context->cpu_count && tsync_context->offsets) {
+		for (i = 0; i < tsync_context->cpu_count; i++) {
+			free(tsync_context->offsets[i].sync_ts);
+			free(tsync_context->offsets[i].sync_offsets);
+			free(tsync_context->offsets[i].sync_scalings);
+			tsync_context->offsets[i].sync_ts = NULL;
+			tsync_context->offsets[i].sync_offsets = NULL;
+			tsync_context->offsets[i].sync_scalings = NULL;
+			tsync_context->offsets[i].sync_count = 0;
+			tsync_context->offsets[i].sync_size = 0;
+		}
+		free(tsync_context->offsets);
+		tsync_context->offsets = NULL;
+	}
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
 	pthread_barrier_destroy(&tsync->first_sync);
@@ -548,15 +574,69 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	free(tsync);
 }
 
+static cpu_set_t *pin_to_cpu(int cpu)
+{
+	static size_t size;
+	static int cpus;
+	cpu_set_t *mask = NULL;
+	cpu_set_t *old = NULL;
+
+	if (!cpus) {
+		cpus = tracecmd_count_cpus();
+		size = CPU_ALLOC_SIZE(cpus);
+	}
+	if (cpu >= cpus)
+		goto error;
+
+	mask = CPU_ALLOC(cpus);
+	if (!mask)
+		goto error;
+	old = CPU_ALLOC(cpus);
+	if (!old)
+		goto error;
+
+	CPU_ZERO_S(size, mask);
+	CPU_SET_S(cpu, size, mask);
+	if (pthread_getaffinity_np(pthread_self(), size, old))
+		goto error;
+	if (pthread_setaffinity_np(pthread_self(), size, mask))
+		goto error;
+
+	CPU_FREE(mask);
+	return old;
+
+error:
+	if (mask)
+		CPU_FREE(mask);
+	if (old)
+		CPU_FREE(old);
+	return NULL;
+}
+
+static void restore_pin_to_cpu(cpu_set_t *mask)
+{
+	static size_t size;
+
+	if (!size)
+		size = CPU_ALLOC_SIZE(tracecmd_count_cpus());
+
+	pthread_setaffinity_np(pthread_self(), size, mask);
+	CPU_FREE(mask);
+}
+
 static int tsync_send(struct tracecmd_time_sync *tsync,
-		      struct tsync_proto *proto)
+		      struct tsync_proto *proto, unsigned int cpu)
 {
+	cpu_set_t *old_set = NULL;
 	long long timestamp = 0;
 	long long scaling = 0;
 	long long offset = 0;
 	int ret;
 
-	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp);
+	old_set = pin_to_cpu(cpu);
+	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp, cpu);
+	if (old_set)
+		restore_pin_to_cpu(old_set);
 
 	return ret;
 }
@@ -564,55 +644,48 @@ static int tsync_send(struct tracecmd_time_sync *tsync,
 static void tsync_with_host(struct tracecmd_time_sync *tsync)
 {
 	char protocol[TRACECMD_TSYNC_PNAME_LENGTH];
+	struct tsync_probe_request_msg probe;
 	struct tsync_proto *proto;
 	unsigned int command;
+	unsigned int size;
+	char *msg;
 	int ret;
 
 	clock_context_init(tsync, &proto, true);
 	if (!tsync->context)
 		return;
 
+	msg = (char *)&probe;
+	size = sizeof(probe);
 	while (true) {
+		memset(&probe, 0, size);
 		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
 						  protocol, &command,
-						  NULL, NULL);
+						  &size, &msg);
 
 		if (ret || strncmp(protocol, TRACECMD_TSYNC_PROTO_NONE, TRACECMD_TSYNC_PNAME_LENGTH) ||
 		    command != TRACECMD_TIME_SYNC_CMD_PROBE)
 			break;
-		ret = tsync_send(tsync, proto);
+		ret = tsync_send(tsync, proto, probe.cpu);
 		if (ret)
 			break;
 	}
 }
 
-static int tsync_get_sample(struct tracecmd_time_sync *tsync,
-			    struct tsync_proto *proto, int array_step)
+static int record_sync_sample(struct clock_sync_offsets *offsets, int array_step,
+			      long long offset, long long scaling, long long ts)
 {
-	struct clock_sync_context *clock;
 	long long *sync_scalings = NULL;
 	long long *sync_offsets = NULL;
 	long long *sync_ts = NULL;
-	long long timestamp = 0;
-	long long scaling = 0;
-	long long offset = 0;
-	int ret;
 
-	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp);
-	if (ret) {
-		warning("Failed to synchronize timestamps with guest");
-		return -1;
-	}
-	if (!offset || !timestamp || !scaling)
-		return 0;
-	clock = tsync->context;
-	if (clock->sync_count >= clock->sync_size) {
-		sync_ts = realloc(clock->sync_ts,
-				  (clock->sync_size + array_step) * sizeof(long long));
-		sync_offsets = realloc(clock->sync_offsets,
-				       (clock->sync_size + array_step) * sizeof(long long));
-		sync_scalings = realloc(clock->sync_scalings,
-				       (clock->sync_size + array_step) * sizeof(long long));
+	if (offsets->sync_count >= offsets->sync_size) {
+		sync_ts = realloc(offsets->sync_ts,
+				  (offsets->sync_size + array_step) * sizeof(long long));
+		sync_offsets = realloc(offsets->sync_offsets,
+				       (offsets->sync_size + array_step) * sizeof(long long));
+		sync_scalings = realloc(offsets->sync_scalings,
+				       (offsets->sync_size + array_step) * sizeof(long long));
 
 		if (!sync_ts || !sync_offsets || !sync_scalings) {
 			free(sync_ts);
@@ -620,20 +693,43 @@ static int tsync_get_sample(struct tracecmd_time_sync *tsync,
 			free(sync_scalings);
 			return -1;
 		}
-		clock->sync_size += array_step;
-		clock->sync_ts = sync_ts;
-		clock->sync_offsets = sync_offsets;
-		clock->sync_scalings = sync_scalings;
+		offsets->sync_size += array_step;
+		offsets->sync_ts = sync_ts;
+		offsets->sync_offsets = sync_offsets;
+		offsets->sync_scalings = sync_scalings;
 	}
 
-	clock->sync_ts[clock->sync_count] = timestamp;
-	clock->sync_offsets[clock->sync_count] = offset;
-	clock->sync_scalings[clock->sync_count] = scaling;
-	clock->sync_count++;
+	offsets->sync_ts[offsets->sync_count] = ts;
+	offsets->sync_offsets[offsets->sync_count] = offset;
+	offsets->sync_scalings[offsets->sync_count] = scaling;
+	offsets->sync_count++;
 
 	return 0;
 }
 
+static int tsync_get_sample(struct tracecmd_time_sync *tsync, unsigned int cpu,
+			    struct tsync_proto *proto, int array_step)
+{
+	struct clock_sync_context *clock;
+	long long timestamp = 0;
+	long long scaling = 0;
+	long long offset = 0;
+	int ret;
+
+	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp, cpu);
+	if (ret) {
+		warning("Failed to synchronize timestamps with guest");
+		return -1;
+	}
+	if (!offset || !timestamp || !scaling)
+		return 0;
+	clock = tsync->context;
+	if (!clock || cpu >= clock->cpu_count || !clock->offsets)
+		return -1;
+	return record_sync_sample(&clock->offsets[cpu], array_step,
+				  offset, scaling, timestamp);
+}
+
 #define TIMER_SEC_NANO 1000000000LL
 static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
 {
@@ -651,12 +747,14 @@ static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
 #define CLOCK_TS_ARRAY 5
 static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 {
+	struct tsync_probe_request_msg probe;
 	int ts_array_size = CLOCK_TS_ARRAY;
 	struct tsync_proto *proto;
 	struct timespec timeout;
 	bool first = true;
 	bool end = false;
 	int ret;
+	int i;
 
 	clock_context_init(tsync, &proto, false);
 	if (!tsync->context) {
@@ -670,16 +768,21 @@ static int tsync_with_guest(struct tracecmd_time_sync *tsync)
 
 	while (true) {
 		pthread_mutex_lock(&tsync->lock);
-		ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
-						  TRACECMD_TSYNC_PROTO_NONE,
-						  TRACECMD_TIME_SYNC_CMD_PROBE,
-						  0, NULL);
-		ret = tsync_get_sample(tsync, proto, ts_array_size);
+		for (i = 0; i < tsync->vcpu_count; i++) {
+			probe.cpu = i;
+			ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+							  TRACECMD_TSYNC_PROTO_NONE,
+							  TRACECMD_TIME_SYNC_CMD_PROBE,
+							  sizeof(probe), (char *)&probe);
+			ret = tsync_get_sample(tsync, i, proto, ts_array_size);
+			if (ret)
+				break;
+		}
 		if (first) {
 			first = false;
 			pthread_barrier_wait(&tsync->first_sync);
 		}
-		if (ret || end)
+		if (end || i < tsync->vcpu_count)
 			break;
 		if (tsync->loop_interval > 0) {
 			get_ts_loop_delay(&timeout, tsync->loop_interval);
@@ -813,41 +916,63 @@ error:
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync)
 {
-	struct iovec vector[6];
+	struct iovec *vector = NULL;
 	unsigned int flags;
 	long long *scalings = NULL;
 	long long *offsets = NULL;
 	long long *ts = NULL;
+	int vcount;
 	int count;
-	int ret;
+	int i, j;
+	int ret = -1;
 
-	ret = tracecmd_tsync_get_offsets(tsync, &count,
-					 &ts, &offsets, &scalings);
-	if (ret < 0 || !count || !ts || !offsets || !scalings)
+	if (!tsync->vcpu_count)
+		return -1;
+	vcount = 3 + (4 * tsync->vcpu_count);
+	vector = calloc(vcount, sizeof(struct iovec));
+	if (!vector)
 		return -1;
 	ret = tsync_get_proto_flags(tsync, &flags);
 	if (ret < 0)
-		return -1;
-
-	vector[0].iov_len = 8;
-	vector[0].iov_base =  &(tsync->trace_id);
-	vector[1].iov_len = 4;
-	vector[1].iov_base = &flags;
-	vector[2].iov_len = 4;
-	vector[2].iov_base = &count;
-	vector[3].iov_len = 8 * count;
-	vector[3].iov_base = ts;
-	vector[4].iov_len = 8 * count;
-	vector[4].iov_base = offsets;
-	vector[5].iov_len = 8 * count;
-	vector[5].iov_base = scalings;
-	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 6);
+		goto out;
+
+	j = 0;
+	vector[j].iov_len = 8;
+	vector[j++].iov_base = &tsync->trace_id;
+	vector[j].iov_len = 4;
+	vector[j++].iov_base = &flags;
+	vector[j].iov_len = 4;
+	vector[j++].iov_base = &tsync->vcpu_count;
+	for (i = 0; i < tsync->vcpu_count; i++) {
+		if (j >= vcount)
+			break;
+		ret = tracecmd_tsync_get_offsets(tsync, i, &count,
+						 &ts, &offsets, &scalings);
+		if (ret < 0 || !count || !ts || !offsets || !scalings)
+			break;
+		vector[j].iov_len = 4;
+		vector[j++].iov_base = &count;
+		vector[j].iov_len = 8 * count;
+		vector[j++].iov_base = ts;
+		vector[j].iov_len = 8 * count;
+		vector[j++].iov_base = offsets;
+		vector[j].iov_len = 8 * count;
+		vector[j++].iov_base = scalings;
+	}
+	if (i < tsync->vcpu_count) {
+		ret = -1;
+		goto out;
+	}
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, vcount);
 #ifdef TSYNC_DEBUG
 	if (count > 1)
 		printf("Got %d timestamp synch samples in %lld ns trace\n\r",
 			count, ts[count - 1] - ts[0]);
 #endif
-	return 0;
+	ret = 0;
+out:
+	free(vector);
+	return ret;
 }
 
 /**
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index b6ae5638..3f56f65a 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -377,7 +377,8 @@ static void dump_option_timeshift(int fd, int size)
 	long long trace_id;
 	unsigned int count;
 	unsigned int flags;
-	int i;
+	unsigned int cpus;
+	int i, j;
 
 	/*
 	 * long long int (8 bytes) trace session ID
@@ -395,29 +396,34 @@ static void dump_option_timeshift(int fd, int size)
 	do_print(OPTIONS, "0x%llX [peer's trace id]\n", trace_id);
 	read_file_number(fd, &flags, 4);
 	do_print(OPTIONS, "0x%llX [peer's protocol flags]\n", flags);
-	read_file_number(fd, &count, 4);
-	do_print(OPTIONS, "%lld [samples count]\n", count);
-	times = calloc(count, sizeof(long long));
-	if (!times)
-		goto out;
-	offsets = calloc(count, sizeof(long long));
-	if (!offsets)
-		goto out;
-	scalings = calloc(count, sizeof(long long));
-	if (!scalings)
-		goto out;
-
-	for (i = 0; i < count; i++)
-		read_file_number(fd, times + i, 8);
-	for (i = 0; i < count; i++)
-		read_file_number(fd, offsets + i, 8);
-	for (i = 0; i < count; i++)
-		read_file_number(fd, scalings + i, 8);
-
-	for (i = 0; i < count; i++)
-		do_print(OPTIONS, "\t%lld * %lld %llu [offset * scaling @ time]\n",
-			 offsets[i], scalings[1], times[i]);
+	read_file_number(fd, &cpus, 4);
+	do_print(OPTIONS, "0x%llX [peer's CPU count]\n", cpus);
+	for (j = 0; j < cpus; j++) {
+		read_file_number(fd, &count, 4);
+		do_print(OPTIONS, "%lld [samples count for CPU %d]\n", count, j);
+		times = calloc(count, sizeof(long long));
+		offsets = calloc(count, sizeof(long long));
+		scalings = calloc(count, sizeof(long long));
+		if (!times || !offsets || !scalings)
+			goto out;
+		for (i = 0; i < count; i++)
+			read_file_number(fd, times + i, 8);
+		for (i = 0; i < count; i++)
+			read_file_number(fd, offsets + i, 8);
+		for (i = 0; i < count; i++)
+			read_file_number(fd, scalings + i, 8);
+
+		for (i = 0; i < count; i++)
+			do_print(OPTIONS, "\t%lld %lld %llu [offset * scaling @ time]\n",
+				 offsets[i], scalings[1], times[i]);
+		free(times);
+		free(offsets);
+		free(scalings);
+		times = NULL;
+		offsets = NULL;
+		scalings = NULL;
 
+	}
 out:
 	free(times);
 	free(offsets);
-- 
2.30.2

