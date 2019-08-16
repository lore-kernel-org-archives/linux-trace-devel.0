Return-Path: <SRS0=TmrD=WM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C355C3A59C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Aug 2019 04:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 204C52064A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Aug 2019 04:31:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RIPGqPkq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfHPEbM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 00:31:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33817 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPEbM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 00:31:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id e8so2328424wme.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Aug 2019 21:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UyjvfxK9olwoluuae8BhoovbuOY+bMeWiBASEahHXyA=;
        b=RIPGqPkqb7RtPYSAFaiZnkzLoyFY1BvZWQCsXitNy9YvB7cefPmRb2J94rIGDPnHtP
         lk+txDhtaG7o/Rmmlzck+CwjS4Q1HKhGtxui+Ivo10Y22mqYD8VEJv9Xvv8fwoXgONli
         ZGJx0zShd0KhWIM5Rw57F8wf8cNBEPF1u8tsBo+7AdFZKf0KXgpoJF8p9EMnDadJ2uEo
         6FxNlm7DWO5XuALxJOuIt6bzVre25N91uTILgDPoCnscd/0IiC0mBKz7HhpDAiWswDem
         B9alyMAVcmZHMHDcAVAhKV3EwjmQBnA1QiqBut4gZW9eoIHDlXMJHdD+RWLVcqNCbs86
         71uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UyjvfxK9olwoluuae8BhoovbuOY+bMeWiBASEahHXyA=;
        b=L4ERdWXmBjo3dPDwK9Uaxb3QpXLgW0OdgB0gX1SempvHR3KmicRmXQToU7GyIDW6nc
         DW1yIcn62RUum/bg7iqVL1NKUD/PWQ/HjleVycpiCKfLfjyJUdQpwf1md98dwtRzg6zc
         EpIP5mKdfzfi1WruN0Ss0ZKlTGOOr5zKEx5pqNe+cY8BFAqfa3ScaDVRDWl2SF8Dxn1b
         me5VV1RXKNMuGC0iCSg/TajwMe01JNlkvDNYNWLR3Vr/ziRR1zxYsk0Y5E5ayjywp5SZ
         z6+AlWP45oXwD2qKWAQbT5UXlbM+azueTtVMoyjzFgVfxJDCwDp6fhalM6vCbunck6gK
         heTQ==
X-Gm-Message-State: APjAAAUjjZllyjIZElr03m5sT2POJ1Ff3hRjBePy/GpayJOPSLxapltd
        ARRHv5K1GVTzFgjVOJdhEpU=
X-Google-Smtp-Source: APXvYqx5H0pWhf/vAfFcne7Xcj611kyimc11XC2hC+YB6mjfE8DdxZ+Vy9h3v2hjpq6JUM3bEj8G4A==
X-Received: by 2002:a1c:c584:: with SMTP id v126mr5166847wmf.27.1565929868946;
        Thu, 15 Aug 2019 21:31:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c65sm4952145wma.44.2019.08.15.21.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 21:31:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] Implemented general PTP sync algorithm
Date:   Fri, 16 Aug 2019 07:31:06 +0300
Message-Id: <20190816043106.25724-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

POC generic PTP time sync algorithm implementation.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-msg.c      |   8 +-
 tracecmd/trace-record.c   |   2 +
 tracecmd/trace-timesync.c | 175 ++++++++++++++++++++++++++++++--------
 3 files changed, 144 insertions(+), 41 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index df29e47..fd52f74 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -55,7 +55,7 @@ static inline void dprint(const char *fmt, ...)
 unsigned int page_size;
 
 /* Try a few times to get an accurate time sync */
-#define TSYNC_TRIES 300
+#define TSYNC_TRIES 2000
 
 struct tracecmd_msg_tinit {
 	be32 cpus;
@@ -1043,14 +1043,14 @@ int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
 		}
 		tracecmd_clock_synch_calc_probe(clock_context,
 						event.ts,
-						htonll(msg.ts_resp.time));
+						ntohll(msg.ts_resp.time));
 	} while (--sync_loop);
 
 	tracecmd_clock_synch_disable(clock_context);
 	tracecmd_clock_synch_calc(clock_context, offset, timestamp);
 	tracecmd_msg_init(MSG_TSYNC_STOP, &msg);
-	msg.ts_stop.offset = htonll(*offset);
-	msg.ts_stop.timestamp = htonll(*timestamp);
+	msg.ts_stop.offset = ntohll(*offset);
+	msg.ts_stop.timestamp = ntohll(*timestamp);
 	tracecmd_msg_send(msg_handle->fd, &msg);
 
 	msg_free(&msg);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 359c094..102a327 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5770,6 +5770,8 @@ static bool has_local_instances(void)
 	return false;
 }
 
+#define TSYNC_DEBUG
+
 static void write_guest_time_shift(struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle;
diff --git a/tracecmd/trace-timesync.c b/tracecmd/trace-timesync.c
index a3f0c10..cdd7b38 100644
--- a/tracecmd/trace-timesync.c
+++ b/tracecmd/trace-timesync.c
@@ -9,6 +9,7 @@
 #include <unistd.h>
 #include <arpa/inet.h>
 #include <linux/vm_sockets.h>
+#include <time.h>
 #include "trace-local.h"
 
 static int clock_sync_x86_host_init(struct tracecmd_clock_sync *clock_context);
@@ -21,6 +22,15 @@ static int clock_sync_x86_guest_find_events(struct tracecmd_clock_sync *clock,
 					    int pid,
 					    struct tracecmd_time_sync_event *event);
 
+static int clock_gen_ptp_init(struct tracecmd_clock_sync *clock_context);
+static int clock_gen_ptp_free(struct tracecmd_clock_sync *clock_context);
+static int clock_gen_ptp_free_find_events(struct tracecmd_clock_sync *clock,
+					    int pid,
+					    struct tracecmd_time_sync_event *event);
+void clock_get_ptp_calc_offset(struct tracecmd_clock_sync *clock_context,
+					long long *ts_local, long long *ts_remote);
+
+
 struct tracecmd_event_descr {
 	char			*system;
 	char			*name;
@@ -35,6 +45,8 @@ struct tracecmd_ftrace_param {
 enum clock_sync_context {
 	CLOCK_KVM_X86_VSOCK_HOST,
 	CLOCK_KVM_X86_VSOCK_GUEST,
+	CLOCK_PTP_GENERIC_HOST,
+	CLOCK_PTP_GENERIC_GUEST,
 	CLOCK_CONTEXT_MAX,
 };
 
@@ -71,6 +83,8 @@ struct {
 	int (*clock_sync_find_events)(struct tracecmd_clock_sync *clock_context,
 				      int pid,
 				      struct tracecmd_time_sync_event *event);
+	void (*clock_sync_calc_offset)(struct tracecmd_clock_sync *clock_context,
+						long long *ts_local, long long *ts_remote);
 	int (*clock_sync_load)(struct tracecmd_clock_sync *clock_context);
 	int (*clock_sync_unload)(struct tracecmd_clock_sync *clock_context);
 } static clock_sync[CLOCK_CONTEXT_MAX] = {
@@ -108,9 +122,85 @@ struct {
 	  clock_sync_x86_guest_init,
 	  clock_sync_x86_guest_free,
 	  clock_sync_x86_guest_find_events,
+	},
+	{ /* CLOCK_PTP_GENERIC_HOST */
+	 .systems = { NULL, NULL, NULL},
+	 .ftrace_params = {
+	  {NULL, NULL, NULL},
+	  {NULL, NULL, NULL},
+	  {NULL, NULL, NULL},
+	  {NULL, NULL, NULL},
+	  {NULL, NULL, NULL},
+			  },
+			  .events = {
+			  {.system = NULL, .name = NULL},
+			  {.system = NULL, .name = NULL},
+			  {.system = NULL, .name = NULL}
+			 },
+			  clock_gen_ptp_init,
+			  clock_gen_ptp_free,
+			  clock_gen_ptp_free_find_events,
+			  clock_get_ptp_calc_offset,
+	},
+	{ /* CLOCK_PTP_GENERIC_GUEST */
+			 .systems = { NULL, NULL, NULL},
+			 .ftrace_params = {
+			  {NULL, NULL, NULL},
+			  {NULL, NULL, NULL},
+			  {NULL, NULL, NULL},
+			  {NULL, NULL, NULL},
+			  {NULL, NULL, NULL},
+					  },
+					  .events = {
+					  {.system = NULL, .name = NULL},
+					  {.system = NULL, .name = NULL},
+					  {.system = NULL, .name = NULL}
+					 },
+					  clock_gen_ptp_init,
+					  clock_gen_ptp_free,
+					  clock_gen_ptp_free_find_events,
+					  clock_get_ptp_calc_offset,
 	}
 };
 
+static int clock_gen_ptp_init(struct tracecmd_clock_sync *clock_context)
+{
+	return 1;
+}
+
+static int clock_gen_ptp_free(struct tracecmd_clock_sync *clock_context)
+{
+	return 1;
+}
+
+static int clock_gen_ptp_free_find_events(struct tracecmd_clock_sync *clock,
+					   int pid,
+					   struct tracecmd_time_sync_event *event)
+{
+	struct timespec ts;
+	event->cpu = 0;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &ts) == 0) {
+		event->ts = ts.tv_nsec + ts.tv_sec * 1000000000LL;
+		return 1;
+	}
+
+	event->ts = 0;
+	return 0;
+}
+
+void clock_get_ptp_calc_offset(struct tracecmd_clock_sync *clock_context,
+					long long *ts_local, long long *ts_remote)
+{
+	struct timespec ts;
+	long long t;
+
+	if (clock_gettime(CLOCK_MONOTONIC_RAW, &ts) != 0)
+		return;
+	t = ts.tv_nsec + ts.tv_sec * 1000000000LL;
+	*ts_local = (*ts_local + t) / 2;
+}
+
 static int clock_sync_x86_host_init(struct tracecmd_clock_sync *clock_context)
 {
 	char vsock_filter[255];
@@ -449,6 +539,8 @@ static struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance,
 	return tep;
 }
 
+#define TSYNC_DEBUG
+
 static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
 			       unsigned int *rcid, unsigned int *rport)
 {
@@ -490,6 +582,9 @@ tracecmd_clock_context_new(struct tracecmd_msg_handle *msg_handle,
 	case CLOCK_KVM_X86_VSOCK_GUEST:
 		break;
 #endif
+	case CLOCK_PTP_GENERIC_HOST:
+	case CLOCK_PTP_GENERIC_GUEST:
+		break;
 	default: /* not supported clock sync context */
 		return NULL;
 	}
@@ -589,7 +684,7 @@ void sync_time_with_host_v3(struct buffer_instance *instance)
 
 	if (instance->clock_sync == NULL)
 		instance->clock_sync = tracecmd_clock_context_new(instance->msg_handle,
-					instance->clock, CLOCK_KVM_X86_VSOCK_GUEST);
+					instance->clock, CLOCK_PTP_GENERIC_GUEST);
 
 	tracecmd_msg_snd_time_sync(instance->msg_handle, instance->clock_sync,
 				   &offset, &timestamp);
@@ -609,7 +704,7 @@ void sync_time_with_guest_v3(struct buffer_instance *instance)
 
 	if (instance->clock_sync == NULL)
 		instance->clock_sync = tracecmd_clock_context_new(instance->msg_handle,
-						top_instance.clock, CLOCK_KVM_X86_VSOCK_HOST);
+						top_instance.clock, CLOCK_PTP_GENERIC_HOST);
 
 	tracecmd_msg_rcv_time_sync(instance->msg_handle,
 				   instance->clock_sync, &offset, &timestamp);
@@ -720,9 +815,10 @@ int tracecmd_clock_synch_calc(struct tracecmd_clock_sync *clock_context,
 	if (time_ret)
 		*time_ret = time;
 #ifdef TSYNC_DEBUG
-	printf("\n calculated offset: %lld, %d/%d probes\n\r",
+	printf("\n calculated offset: %lld, %d/%d probes, filtered out %d\n\r",
 		*offset_ret, clock_context->probes_count,
-		clock_context->probes_count + clock_context->bad_probes);
+		clock_context->probes_count + clock_context->bad_probes,
+		clock_context->probes_count-j);
 #endif
 	return 1;
 }
@@ -746,63 +842,68 @@ void tracecmd_clock_synch_calc_reset(struct tracecmd_clock_sync *clock_context)
 
 }
 
-void tracecmd_clock_synch_calc_probe(struct tracecmd_clock_sync *clock_context,
+void tracecmd_clock_synch_calc_probe(struct tracecmd_clock_sync *clock,
 				     long long ts_local, long long ts_remote)
 {
 	int count;
+	int id;
 #ifdef TSYNC_DEBUG
 	char buff[256];
 #endif
 
-	if (!clock_context || !ts_local || !ts_remote)
+	if (!clock || !ts_local || !ts_remote)
 		return;
 	if (!ts_local || !ts_remote) {
-		clock_context->bad_probes++;
+		clock->bad_probes++;
 		return;
 	}
 
-	if (!clock_context->offsets && !clock_context->times) {
-		clock_context->offsets = calloc(10, sizeof(long long));
-		clock_context->times = calloc(10, sizeof(long long));
-		clock_context->probes_size = 10;
+	id = clock->clock_context_id;
+	if (clock_sync[id].clock_sync_calc_offset)
+		clock_sync[id].clock_sync_calc_offset(clock, &ts_local, &ts_remote);
+
+	if (!clock->offsets && !clock->times) {
+		clock->offsets = calloc(10, sizeof(long long));
+		clock->times = calloc(10, sizeof(long long));
+		clock->probes_size = 10;
 	}
 
-	if (clock_context->probes_size == clock_context->probes_count) {
-		clock_context->probes_size = (3*clock_context->probes_size)/2;
-		clock_context->offsets = realloc(clock_context->offsets,
-						 clock_context->probes_size *
+	if (clock->probes_size == clock->probes_count) {
+		clock->probes_size = (3*clock->probes_size)/2;
+		clock->offsets = realloc(clock->offsets,
+				clock->probes_size *
 						 sizeof(long long));
-		clock_context->times = realloc(clock_context->times,
-					       clock_context->probes_size*
+		clock->times = realloc(clock->times,
+				clock->probes_size*
 					       sizeof(long long));
 	}
 
-	if (!clock_context->offsets || !clock_context->times) {
-		clock_context->probes_size = 0;
-		tracecmd_clock_synch_calc_reset(clock_context);
+	if (!clock->offsets || !clock->times) {
+		clock->probes_size = 0;
+		tracecmd_clock_synch_calc_reset(clock);
 		return;
 	}
 #ifdef TSYNC_DEBUG
-	if (clock_context->debug_fd < 0) {
-		sprintf(buff, "s-cid%d.txt", clock_context->remote_cid);
-		clock_context->debug_fd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
+	if (clock->debug_fd < 0) {
+		sprintf(buff, "s-cid%d.txt", clock->remote_cid);
+		clock->debug_fd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
 	}
 #endif
-	count = clock_context->probes_count;
-	clock_context->probes_count++;
-	clock_context->offsets[count] = ts_remote - ts_local;
-	clock_context->times[count] = ts_local;
-	clock_context->offset_av += clock_context->offsets[count];
-
-	if (!clock_context->offset_min ||
-	    clock_context->offset_min > llabs(clock_context->offsets[count]))
-		clock_context->offset_min = llabs(clock_context->offsets[count]);
-	if (!clock_context->offset_max ||
-	    clock_context->offset_max < llabs(clock_context->offsets[count]))
-		clock_context->offset_max = llabs(clock_context->offsets[count]);
+	count = clock->probes_count;
+	clock->probes_count++;
+	clock->offsets[count] = ts_remote - ts_local;
+	clock->times[count] = ts_local;
+	clock->offset_av += clock->offsets[count];
+
+	if (!clock->offset_min ||
+			clock->offset_min > llabs(clock->offsets[count]))
+		clock->offset_min = llabs(clock->offsets[count]);
+	if (!clock->offset_max ||
+			clock->offset_max < llabs(clock->offsets[count]))
+		clock->offset_max = llabs(clock->offsets[count]);
 #ifdef TSYNC_DEBUG
-	sprintf(buff, "%lld %lld\n", ts_local, ts_remote);
-	write(clock_context->debug_fd, buff, strlen(buff));
+	sprintf(buff, "%lld %lld %lld\n", ts_local, ts_remote, ts_remote - ts_local);
+	write(clock->debug_fd, buff, strlen(buff));
 #endif
 
 }
-- 
2.21.0

