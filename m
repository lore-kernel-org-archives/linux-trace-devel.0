Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17CDC3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 09:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F0BE20856
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 09:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8QnV+Pr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfH1JJk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 05:09:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43282 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfH1JJk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 05:09:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8so1662954wrn.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 02:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+G+qF00mvkrDHMNYVoiK8aqqFhU2nROYyzOodlN8D80=;
        b=X8QnV+Pr7QCPOnTgZJlmRhYqdplEsR/zNyfQpgxJwJ/PrRGozK/k1FnntjAJkKdnda
         gi8lB1EGlzEEjqfBI+JMrOPQsrt6Wil+Yx75Xh9WIA1Avlp+QV1YOCu1Bsl8oldCn+p0
         iFXf9nXLOcPd0fk/b64VwLGuxOLyVM6Yk4N8Orsgah6dxGp28lim3UVfjVEzWxqiFcH/
         FS5PuII6ASA0nMfCbMYlYR8/svT3oQIMIri4qANOOmMZO1sWe81Fj+qwe5iT4GicHdqL
         9jg4LkVOJPdXUiRw9dOHZ9ph5/1mE3XW/O934II2zmk5UYvdm5LHumrYalWRz0pqaM6d
         0T4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+G+qF00mvkrDHMNYVoiK8aqqFhU2nROYyzOodlN8D80=;
        b=IH8IWUhTn1WnICkhz7Iu6kV25P1Mxt6BLrcslUM/XWYTXmV4gP0gmKqcMFYduVPSsF
         XrzABkkpXvHFP4Zc0NsLpswYpq6KHFBPgvXSvfHRXpveRFYf34o8Y7CKVxu+G4IXor09
         PIdXbPtreE5AkuDW+df9tEkh5/TwWyTsZxLKXVUxeZTpDrtZ+jiBeOuoCBbJjaXdEEZV
         5IgzTHbdZI/+vP8GK+C66TrGwDvEzJuY3cvzyaB+mY5Oy8zmkDCjaTunIgNGYKcyYGvJ
         vg27uogE/TFOyRuT2gtngdvQ3cPSjZtXw8Z9IsrutnRNUcxqfapVOu989uhKQaIAz4OW
         rVkA==
X-Gm-Message-State: APjAAAVSMcMG5oDvdMLm6ztzG6wVVRbxKee93f3uTizM3ZsMGs8mBPYK
        nY5fjdpqG0P9QMy4aCtgID9rdUyH
X-Google-Smtp-Source: APXvYqzDMniGpt6oTDAOvd55ZJs/zVStHxvPeRoxiBRCcoYRqnBRF2xWXBlrwmw4MiWRker1q+M62A==
X-Received: by 2002:a5d:6a12:: with SMTP id m18mr3351906wru.306.1566983376316;
        Wed, 28 Aug 2019 02:09:36 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id j15sm1803719wrn.70.2019.08.28.02.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 02:09:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] Implemented generic PTP sync algorithm
Date:   Wed, 28 Aug 2019 12:09:34 +0300
Message-Id: <20190828090934.27872-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-msg.c      |   2 +-
 tracecmd/trace-timesync.c | 173 ++++++++++++++++++++++++++++++--------
 2 files changed, 137 insertions(+), 38 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index bfe7e43..17d021f 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -55,7 +55,7 @@ static inline void dprint(const char *fmt, ...)
 unsigned int page_size;
 
 /* Try a few times to get an accurate time sync */
-#define TSYNC_TRIES 300
+#define TSYNC_TRIES 1000
 
 struct tracecmd_msg_tinit {
 	be32 cpus;
diff --git a/tracecmd/trace-timesync.c b/tracecmd/trace-timesync.c
index 37629c6..0fcc1fb 100644
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
@@ -492,6 +582,9 @@ tracecmd_clock_context_new(struct tracecmd_msg_handle *msg_handle,
 	case CLOCK_KVM_X86_VSOCK_GUEST:
 		break;
 #endif
+	case CLOCK_PTP_GENERIC_HOST:
+	case CLOCK_PTP_GENERIC_GUEST:
+		break;
 	default: /* not supported clock sync context */
 		return NULL;
 	}
@@ -591,7 +684,7 @@ void sync_time_with_host_v3(struct buffer_instance *instance)
 
 	if (instance->clock_sync == NULL)
 		instance->clock_sync = tracecmd_clock_context_new(instance->msg_handle,
-					instance->clock, CLOCK_KVM_X86_VSOCK_GUEST);
+					instance->clock, CLOCK_PTP_GENERIC_GUEST);
 
 	tracecmd_msg_snd_time_sync(instance->msg_handle, instance->clock_sync,
 				   &offset, &timestamp);
@@ -611,7 +704,7 @@ void sync_time_with_guest_v3(struct buffer_instance *instance)
 
 	if (instance->clock_sync == NULL)
 		instance->clock_sync = tracecmd_clock_context_new(instance->msg_handle,
-						top_instance.clock, CLOCK_KVM_X86_VSOCK_HOST);
+						top_instance.clock, CLOCK_PTP_GENERIC_HOST);
 
 	tracecmd_msg_rcv_time_sync(instance->msg_handle,
 				   instance->clock_sync, &offset, &timestamp);
@@ -722,9 +815,10 @@ int tracecmd_clock_synch_calc(struct tracecmd_clock_sync *clock_context,
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
@@ -748,63 +842,68 @@ void tracecmd_clock_synch_calc_reset(struct tracecmd_clock_sync *clock_context)
 
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

