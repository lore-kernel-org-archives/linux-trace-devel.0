Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81557C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C1960FE3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhJNPOK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233302AbhJNPNM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 11:13:12 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291CEC06177F
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:13 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u18so20546929wrg.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KD93/huHiAxJ+51XhBHvbOOcPf1L2SoFfLvHc371HMs=;
        b=a1GTuGQf8ph1gQJTpe+C+opdSf/sSvQB6tsI/thuXw3/FG8XiGFROA+IqiIOu9iMIk
         aVnlGkOlwt4mwTPi9DIU1WUwhAuCQJ27Uz10hLSLV6gLUoN9U1yjuwi3rW4741shf4VV
         04q+yu0v46Lab1Y/iyV1xeU0+NHRS9CYRDn+HBd9jDD/W/t7yR4VtQOTNWtt0z0iXq0W
         TwyzV/1+KZ3uicHL9Oe1DylkaklgfWCapTFvq6IsyhHKnorPNfQ4DjNBX8eVxrgacQ3D
         Uvzz4G+HZ0Pv4DWwZca1aM+6oYg27G+xcC3YwJH80YyySC7KbkvVmjmeE1gAPbk0eSfZ
         XDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KD93/huHiAxJ+51XhBHvbOOcPf1L2SoFfLvHc371HMs=;
        b=L3QnKrUmB5LEpUmmkmhs6fzpSMf6JqMYBkZoifYZdebwe2jWV6MGXu3rGPoXiODSuS
         jD5tTn0JlBVyxD83jrN0ZcD4OKAgDPxjBWmgnWCFyLuVm8Nann2S+oqitFjn0Th0Mq/f
         WKLf1ZVaI5vUgwL6PeSbDpaRuV8p8XBw/1VMFZhxAURs0XQa5A5ZEft0zspfwGr2gxh+
         yPnZkCKQ0bgag9YDWM/HE/5XoOFAz+Of1QVQg2EA1XEw8qq6j0g3k6Gaunot3owScpH9
         HeNMXgH0lyEGcfN1MNTAR8gdr5l8Tal/4zv2Z+hQ9pbSGhtPlkPUN8zTheJ1eurxjLhz
         Skiw==
X-Gm-Message-State: AOAM5325E01XpODwJHQCPCx0H56OO0wsuxu/9sTC82cDGWcMBuXufm8r
        wL4sXnZJjplKLkicAx+LBF2qQ8FFBGwG9g==
X-Google-Smtp-Source: ABdhPJwI0w8vUZNUKxPCvRz1JNyWtnxSUUF1WIWeVRKMqkS9X/41mGFqNIprB4RgBViKkvzntuv8Wg==
X-Received: by 2002:adf:a402:: with SMTP id d2mr7353931wra.266.1634223729387;
        Thu, 14 Oct 2021 08:02:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm2738065wro.25.2021.10.14.08.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:02:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/4] trace-cmd library: Extend host-guest time sync with fraction bits
Date:   Thu, 14 Oct 2021 18:02:02 +0300
Message-Id: <20211014150204.2485499-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
References: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The formula, used in the Linux kernel for guest TSC clock is:
 guest_tsc = tsc-offset + (host_tsc * tsc-scaling-ratio) >> tsc-scaling-ratio-frac-bits

The KVM hypervisor exports these parameters in the debugfs, if clock
scaling is supported:
 /sys/kernel/debug/kvm:
	tsc-offset
	tsc-scaling-ratio
	tsc-scaling-ratio-frac-bits

Current trace-cmd implementation does not take into account fraction
bits, when calculating guest clock offset in case of a clock scaling.
The TRACECMD_OPTION_TIME_SHIFT option is extended with per-cpu array
with fraction bits. KVM and PTP algorithms are extended to get fraction:
 - in PTP, there are fixed scaling=1 and fraction=0;
 - KVM gets these from KVM debugfs, if available.
The formula from the kernel is implemented in trace-cmd library, when
calculating timestamps of the guest events.

This change is backward compatible with trace-cmd 2.9, where the
TRACECMD_OPTION_TIME_SHIFT option is introduced.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  4 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  7 ++-
 lib/trace-cmd/trace-timesync-kvm.c            | 56 ++++++++++++++-----
 lib/trace-cmd/trace-timesync-ptp.c            |  4 +-
 lib/trace-cmd/trace-timesync.c                | 55 ++++++++++++++----
 5 files changed, 96 insertions(+), 30 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c58b09e9..f40babef 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -454,8 +454,8 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 			  int guest_cpus, const char *proto_name, const char *clock);
 int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
-				int *count, long long **ts,
-				long long **offsets, long long **scalings);
+			       int *count, long long **ts,
+			       long long **offsets, long long **scalings, long long **frac);
 int tracecmd_tsync_get_session_params(struct tracecmd_time_sync *tsync,
 				      char **selected_proto,
 				      unsigned int *tsync_port);
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 7e56d187..b357662c 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -27,14 +27,15 @@ struct tracecmd_time_sync {
 struct clock_sync_offsets {
 	/* Arrays with calculated time offsets at given time */
 	int				sync_size;	/* Allocated size of sync_ts,
-							 * sync_offsets and sync_scalings
+							 * sync_offsets, sync_scalings and sync_frac
 							 */
 	int				sync_count;	/* Number of elements in sync_ts,
-							 * sync_offsets and sync_scalings
+							 * sync_offsets, sync_scalings and sync_frac
 							 */
 	long long			*sync_ts;
 	long long			*sync_offsets;
 	long long			*sync_scalings;
+	long long			*sync_frac;
 };
 
 struct clock_sync_context {
@@ -60,7 +61,7 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
-					      long long *, long long *,
+					      long long *, long long *, long long*,
 					      long long *, unsigned int));
 int tracecmd_tsync_proto_unregister(char *proto_name);
 
diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index 6f76fe1f..8d531922 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -19,6 +19,7 @@
 #define KVM_DEBUG_FS "/sys/kernel/debug/kvm"
 #define KVM_DEBUG_OFFSET_FILE	"tsc-offset"
 #define KVM_DEBUG_SCALING_FILE	"tsc-scaling-ratio"
+#define KVM_DEBUG_FRACTION_FILE	"tsc-scaling-ratio-frac-bits"
 #define KVM_DEBUG_VCPU_DIR	"vcpu"
 
 /* default KVM scaling values, taken from the Linux kernel */
@@ -37,6 +38,7 @@ struct kvm_clock_sync {
 	int vcpu_count;
 	char **vcpu_offsets;
 	char **vcpu_scalings;
+	char **vcpu_frac;
 	int marker_fd;
 	struct tep_handle *tep;
 	int raw_id;
@@ -47,6 +49,7 @@ struct kvm_clock_offset_msg {
 	s64	ts;
 	s64	offset;
 	s64	scaling;
+	s64	frac;
 };
 
 static int read_ll_from_file(char *file, long long *res)
@@ -72,21 +75,27 @@ static int read_ll_from_file(char *file, long long *res)
 
 static bool kvm_scaling_check_vm_cpu(char *vname, char *cpu)
 {
-	long long scaling;
+	long long scaling, frac;
+	bool has_scaling = false;
+	bool has_frac = false;
 	char *path;
 	int ret;
 
 	if (asprintf(&path, "%s/%s/%s", vname, cpu, KVM_DEBUG_SCALING_FILE) < 0)
-		return true;
+		return false;
 	ret = read_ll_from_file(path, &scaling);
 	free(path);
+	if (!ret)
+		has_scaling = true;
+
+	if (asprintf(&path, "%s/%s/%s", vname, cpu, KVM_DEBUG_FRACTION_FILE) < 0)
+		return false;
+	ret = read_ll_from_file(path, &frac);
+	free(path);
+	if (!ret)
+		has_frac = true;
 
-	/*
-	 * If there is a scaling, different from the default -
-	 * return false, not supported.
-	 */
-	if (!ret &&
-	    scaling != KVM_SCALING_AMD_DEFAULT && scaling != KVM_SCALING_INTEL_DEFAULT)
+	if (has_scaling != has_frac)
 		return false;
 
 	return true;
@@ -173,6 +182,11 @@ static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int cpu, char *dir_str)
 					 dir_str, entry->d_name);
 				kvm->vcpu_scalings[cpu] = strdup(path);
 			}
+			if (!strcmp(entry->d_name, KVM_DEBUG_FRACTION_FILE)) {
+				snprintf(path, sizeof(path), "%s/%s",
+					 dir_str, entry->d_name);
+				kvm->vcpu_frac[cpu] = strdup(path);
+			}
 		}
 	}
 	if (!kvm->vcpu_offsets[cpu])
@@ -187,6 +201,8 @@ error:
 	kvm->vcpu_offsets[cpu] = NULL;
 	free(kvm->vcpu_scalings[cpu]);
 	kvm->vcpu_scalings[cpu] = NULL;
+	free(kvm->vcpu_frac[cpu]);
+	kvm->vcpu_frac[cpu] = NULL;
 	return -1;
 }
 
@@ -252,7 +268,8 @@ static int kvm_clock_sync_init_host(struct tracecmd_time_sync *tsync,
 	kvm->vcpu_count = tsync->vcpu_count;
 	kvm->vcpu_offsets = calloc(kvm->vcpu_count, sizeof(char *));
 	kvm->vcpu_scalings = calloc(kvm->vcpu_count, sizeof(char *));
-	if (!kvm->vcpu_offsets || !kvm->vcpu_scalings)
+	kvm->vcpu_frac = calloc(kvm->vcpu_count, sizeof(char *));
+	if (!kvm->vcpu_offsets || !kvm->vcpu_scalings || !kvm->vcpu_frac)
 		goto error;
 	if (kvm_open_debug_files(kvm, tsync->guest_pid) < 0)
 		goto error;
@@ -261,6 +278,7 @@ static int kvm_clock_sync_init_host(struct tracecmd_time_sync *tsync,
 error:
 	free(kvm->vcpu_offsets);
 	free(kvm->vcpu_scalings);
+	free(kvm->vcpu_frac);
 	return -1;
 }
 
@@ -351,6 +369,8 @@ static int kvm_clock_sync_free(struct tracecmd_time_sync *tsync)
 			kvm->vcpu_offsets[i] = NULL;
 			free(kvm->vcpu_scalings[i]);
 			kvm->vcpu_scalings[i] = NULL;
+			free(kvm->vcpu_frac[i]);
+			kvm->vcpu_frac[i] = NULL;
 		}
 		if (kvm->tep)
 			tep_free(kvm->tep);
@@ -362,7 +382,7 @@ static int kvm_clock_sync_free(struct tracecmd_time_sync *tsync)
 }
 
 static int kvm_clock_host(struct tracecmd_time_sync *tsync,
-			  long long *offset, long long *scaling,
+			  long long *offset, long long *scaling, long long *frac,
 			  long long *timestamp, unsigned int cpu)
 {
 	char sync_proto[TRACECMD_TSYNC_PNAME_LENGTH];
@@ -372,6 +392,7 @@ static int kvm_clock_host(struct tracecmd_time_sync *tsync,
 	long long kvm_scaling = 1;
 	unsigned int sync_msg;
 	long long kvm_offset;
+	long long kvm_frac = 0;
 	unsigned int size;
 	char *msg;
 	int ret;
@@ -386,12 +407,16 @@ static int kvm_clock_host(struct tracecmd_time_sync *tsync,
 	ret = read_ll_from_file(kvm->vcpu_offsets[cpu], &kvm_offset);
 	if (ret < 0)
 		return -1;
+
 	if (kvm->vcpu_scalings && kvm->vcpu_scalings[cpu]) {
 		read_ll_from_file(kvm->vcpu_scalings[cpu], &kvm_scaling);
 		if (kvm_scaling == KVM_SCALING_AMD_DEFAULT ||
 		    kvm_scaling == KVM_SCALING_INTEL_DEFAULT)
 			kvm_scaling = 1;
 	}
+
+	if (kvm->vcpu_frac && kvm->vcpu_frac[cpu])
+		ret = read_ll_from_file(kvm->vcpu_frac[cpu], &kvm_frac);
 	msg = (char *)&packet;
 	size = sizeof(packet);
 	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
@@ -403,6 +428,7 @@ static int kvm_clock_host(struct tracecmd_time_sync *tsync,
 
 	packet.offset = -kvm_offset;
 	packet.scaling = kvm_scaling;
+	packet.frac = kvm_frac;
 	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, KVM_NAME,
 					  KVM_SYNC_PKT_RESPONSE, sizeof(packet),
 					  (char *)&packet);
@@ -411,6 +437,7 @@ static int kvm_clock_host(struct tracecmd_time_sync *tsync,
 
 	*scaling = packet.scaling;
 	*offset = packet.offset;
+	*frac = kvm_frac;
 	*timestamp = packet.ts;
 
 	return 0;
@@ -442,10 +469,10 @@ static int kvm_marker_find(struct tep_event *event, struct tep_record *record,
 	return 0;
 }
 
-
 static int kvm_clock_guest(struct tracecmd_time_sync *tsync,
 			   long long *offset,
 			   long long *scaling,
+			   long long *frac,
 			   long long *timestamp)
 {
 	char sync_proto[TRACECMD_TSYNC_PNAME_LENGTH];
@@ -486,12 +513,13 @@ static int kvm_clock_guest(struct tracecmd_time_sync *tsync,
 
 	*scaling = packet.scaling;
 	*offset = packet.offset;
+	*frac = packet.frac;
 	*timestamp = packet.ts;
 	return 0;
 }
 
 static int kvm_clock_sync_calc(struct tracecmd_time_sync *tsync,
-			       long long *offset, long long *scaling,
+			       long long *offset, long long *scaling, long long *frac,
 			       long long *timestamp, unsigned int cpu)
 {
 	struct clock_sync_context *clock_context;
@@ -503,9 +531,9 @@ static int kvm_clock_sync_calc(struct tracecmd_time_sync *tsync,
 	clock_context = (struct clock_sync_context *)tsync->context;
 
 	if (clock_context->is_guest)
-		ret = kvm_clock_guest(tsync, offset, scaling, timestamp);
+		ret = kvm_clock_guest(tsync, offset, scaling, frac, timestamp);
 	else
-		ret = kvm_clock_host(tsync, offset, scaling, timestamp, cpu);
+		ret = kvm_clock_host(tsync, offset, scaling, frac, timestamp, cpu);
 	return ret;
 }
 
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
index b05f1cd0..70242ee3 100644
--- a/lib/trace-cmd/trace-timesync-ptp.c
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -663,7 +663,7 @@ static int ptp_clock_server(struct tracecmd_time_sync *tsync,
 }
 
 static int ptp_clock_sync_calc(struct tracecmd_time_sync *tsync,
-			       long long *offset, long long *scaling,
+			       long long *offset, long long *scaling, long long *frac,
 			       long long *timestamp, unsigned int cpu)
 {
 	struct clock_sync_context *clock_context;
@@ -689,6 +689,8 @@ static int ptp_clock_sync_calc(struct tracecmd_time_sync *tsync,
 
 	if (scaling)
 		*scaling = 1;
+	if (frac)
+		*frac = 0;
 	if (clock_context->is_server)
 		ret = ptp_clock_server(tsync, offset, timestamp);
 	else
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 19ca19d7..f8ec15a3 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -36,7 +36,7 @@ struct tsync_proto {
 	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_calc)(struct tracecmd_time_sync *clock_context,
-			       long long *offset, long long *scaling,
+			       long long *offset, long long *scaling, long long *frac,
 			       long long *timestamp, unsigned int cpu);
 };
 
@@ -76,7 +76,7 @@ int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int role
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
-					      long long *, long long *,
+					      long long *, long long *, long long *,
 					      long long *, unsigned int))
 {
 	struct tsync_proto *proto = NULL;
@@ -137,12 +137,13 @@ bool __hidden tsync_proto_is_supported(const char *proto_name)
  * @ts: Array of size @count containing timestamps of callculated offsets
  * @offsets: array of size @count, containing offsets for each timestamp
  * @scalings: array of size @count, containing scaling ratios for each timestamp
+ * @frac: array of size @count, containing fraction bits for each timestamp
  *
  * Retuns -1 in case of an error, or 0 otherwise
  */
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
 			       int *count, long long **ts,
-			       long long **offsets, long long **scalings)
+			       long long **offsets, long long **scalings, long long **frac)
 {
 	struct clock_sync_context *tsync_context;
 
@@ -159,6 +160,8 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
 		*offsets = tsync_context->offsets[cpu].sync_offsets;
 	if (scalings)
 		*scalings = tsync_context->offsets[cpu].sync_scalings;
+	if (frac)
+		*frac = tsync_context->offsets[cpu].sync_frac;
 
 	return 0;
 }
@@ -564,9 +567,11 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 				free(tsync_context->offsets[i].sync_ts);
 				free(tsync_context->offsets[i].sync_offsets);
 				free(tsync_context->offsets[i].sync_scalings);
+				free(tsync_context->offsets[i].sync_frac);
 				tsync_context->offsets[i].sync_ts = NULL;
 				tsync_context->offsets[i].sync_offsets = NULL;
 				tsync_context->offsets[i].sync_scalings = NULL;
+				tsync_context->offsets[i].sync_frac = NULL;
 				tsync_context->offsets[i].sync_count = 0;
 				tsync_context->offsets[i].sync_size = 0;
 			}
@@ -643,10 +648,11 @@ static int tsync_send(struct tracecmd_time_sync *tsync,
 	long long timestamp = 0;
 	long long scaling = 0;
 	long long offset = 0;
+	long long frac = 0;
 	int ret;
 
 	old_set = pin_to_cpu(cpu);
-	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp, cpu);
+	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &frac, &timestamp, cpu);
 	if (old_set)
 		restore_pin_to_cpu(old_set);
 
@@ -685,10 +691,11 @@ static void tsync_with_host(struct tracecmd_time_sync *tsync)
 }
 
 static int record_sync_sample(struct clock_sync_offsets *offsets, int array_step,
-			      long long offset, long long scaling, long long ts)
+			      long long offset, long long scaling, long long frac, long long ts)
 {
 	long long *sync_scalings = NULL;
 	long long *sync_offsets = NULL;
+	long long *sync_frac = NULL;
 	long long *sync_ts = NULL;
 
 	if (offsets->sync_count >= offsets->sync_size) {
@@ -698,22 +705,27 @@ static int record_sync_sample(struct clock_sync_offsets *offsets, int array_step
 				       (offsets->sync_size + array_step) * sizeof(long long));
 		sync_scalings = realloc(offsets->sync_scalings,
 				       (offsets->sync_size + array_step) * sizeof(long long));
+		sync_frac = realloc(offsets->sync_frac,
+				    (offsets->sync_size + array_step) * sizeof(long long));
 
-		if (!sync_ts || !sync_offsets || !sync_scalings) {
+		if (!sync_ts || !sync_offsets || !sync_scalings || !sync_frac) {
 			free(sync_ts);
 			free(sync_offsets);
 			free(sync_scalings);
+			free(sync_frac);
 			return -1;
 		}
 		offsets->sync_size += array_step;
 		offsets->sync_ts = sync_ts;
 		offsets->sync_offsets = sync_offsets;
 		offsets->sync_scalings = sync_scalings;
+		offsets->sync_frac = sync_frac;
 	}
 
 	offsets->sync_ts[offsets->sync_count] = ts;
 	offsets->sync_offsets[offsets->sync_count] = offset;
 	offsets->sync_scalings[offsets->sync_count] = scaling;
+	offsets->sync_frac[offsets->sync_count] = frac;
 	offsets->sync_count++;
 
 	return 0;
@@ -726,9 +738,10 @@ static int tsync_get_sample(struct tracecmd_time_sync *tsync, unsigned int cpu,
 	long long timestamp = 0;
 	long long scaling = 0;
 	long long offset = 0;
+	long long frac = 0;
 	int ret;
 
-	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp, cpu);
+	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &frac, &timestamp, cpu);
 	if (ret) {
 		tracecmd_warning("Failed to synchronize timestamps with guest");
 		return -1;
@@ -739,7 +752,7 @@ static int tsync_get_sample(struct tracecmd_time_sync *tsync, unsigned int cpu,
 	if (!clock || cpu >= clock->cpu_count || !clock->offsets)
 		return -1;
 	return record_sync_sample(&clock->offsets[cpu], array_step,
-				  offset, scaling, timestamp);
+				  offset, scaling, frac, timestamp);
 }
 
 #define TIMER_SEC_NANO 1000000000LL
@@ -928,6 +941,7 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 	unsigned int flags;
 	long long *scalings = NULL;
 	long long *offsets = NULL;
+	long long *frac = NULL;
 	long long *ts = NULL;
 	int vcount;
 	int count;
@@ -936,7 +950,7 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 
 	if (!tsync->vcpu_count)
 		return -1;
-	vcount = 3 + (4 * tsync->vcpu_count);
+	vcount = 3 + (5 * tsync->vcpu_count);
 	vector = calloc(vcount, sizeof(struct iovec));
 	if (!vector)
 		return -1;
@@ -955,7 +969,7 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 		if (j >= vcount)
 			break;
 		ret = tracecmd_tsync_get_offsets(tsync, i, &count,
-						 &ts, &offsets, &scalings);
+						 &ts, &offsets, &scalings, NULL);
 		if (ret < 0 || !count || !ts || !offsets || !scalings)
 			break;
 		vector[j].iov_len = 4;
@@ -971,6 +985,27 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 		ret = -1;
 		goto out;
 	}
+	/*
+	 * Writing fraction bits into the option is implemented in a separate loop for
+	 * backward compatibility. In the trace-cmd 2.9 release, this option has only offset
+	 * and scaling. That legacy code must work with the new extended option.
+	 *
+	 */
+	for (i = 0; i < tsync->vcpu_count; i++) {
+		if (j >= vcount)
+			break;
+		ret = tracecmd_tsync_get_offsets(tsync, i, NULL,
+						 NULL, NULL, NULL, &frac);
+		if (ret < 0)
+			break;
+		vector[j].iov_len = 8 * count;
+		vector[j++].iov_base = frac;
+	}
+	if (i < tsync->vcpu_count) {
+		ret = -1;
+		goto out;
+	}
+
 	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, vcount);
 #ifdef TSYNC_DEBUG
 	if (count > 1)
-- 
2.31.1

