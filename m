Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284B9C7EE2F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Jun 2023 22:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239978AbjFFWpd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbjFFWpb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 18:45:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B0910FD
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 15:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AFF6638A5
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 22:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4A2C433EF
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 22:45:28 +0000 (UTC)
Date:   Tue, 6 Jun 2023 18:45:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Add tracecmd_get_tsc2nsec() API
Message-ID: <20230606184526.7d7a48e4@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracecmd_get_tsc2nsec() to be able to extract the multiplier, shift
and offset used to calculate the nanoseconds from the raw timestamp.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracecmd/libtracecmd-timestamp.txt     | 24 ++++++++++++++++-
 Documentation/libtracecmd/libtracecmd.txt     |  1 +
 include/trace-cmd/trace-cmd.h                 |  2 ++
 lib/trace-cmd/trace-input.c                   | 27 +++++++++++++++++++
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracecmd/libtracecmd-timestamp.txt b/Documentation/libtracecmd/libtracecmd-timestamp.txt
index 8695d003965b..88a84e534f2c 100644
--- a/Documentation/libtracecmd/libtracecmd-timestamp.txt
+++ b/Documentation/libtracecmd/libtracecmd-timestamp.txt
@@ -3,7 +3,7 @@ libtracecmd(3)
 
 NAME
 ----
-tracecmd_get_first_ts, tracecmd_add_ts_offset - Handle time stamps from a trace file.
+tracecmd_get_first_ts, tracecmd_add_ts_offset, tracecmd_get_tsc2nsec - Handle time stamps from a trace file.
 
 SYNOPSIS
 --------
@@ -13,6 +13,7 @@ SYNOPSIS
 
 unsigned long long *tracecmd_get_first_ts*(struct tracecmd_input pass:[*]_handle_);
 void *tracecmd_add_ts_offset*(struct tracecmd_input pass:[*]_handle_, long long _offset_);
+int *tracecmd_get_tsc2nsec*(struct tracecmd_input pass:[*]_handle_, int pass:[*]_mult_, int pass[*]_shift_, unsigned long long pass:[*]_offset_);
 --
 
 DESCRIPTION
@@ -28,11 +29,23 @@ in the _handle_ that represents a trace file. This is useful for associating two
 different tracing files by their offset (for example a trace file from a host
 and a trace file from a guest that were not synchronized when created).
 
+The *tracecmd_get_tsc2nsec* returns the calculation values that convert the
+raw timestamp into nanoseconds. The parameters are pointers to the storage to save
+the values, or NULL to ignore them. The multiplier will be saved in _mult_, the
+shift value will be saved in _shift_, and the offset value will be saved in
+_offset_, if the corresponding parameters are not NULL.
+
 RETURN VALUE
 ------------
 The *tracecmd_get_first_ts()* function returns the timestamp of the first
 record in a trace file for the given _handle_.
 
+The *tracecmd_get_tsc2nsec*() returns 0 if the tracing clock supports the
+shift values and -1 otherwise. Note, that if the trace file has the TSC2NSEC
+option, the values returned in the parameters may still be valid even if the
+function itself returns -1. The return value only notes if the values will
+be used in the calculations of the given clock.
+
 EXAMPLE
 -------
 [source,c]
@@ -63,7 +76,11 @@ int main(int argc, char **argv)
 {
 	struct tracecmd_input **handles = NULL;
 	unsigned long long ts, first_ts = 0;
+	unsigned long long offset;
+	int multi;
+	int shift;
 	int nr_handles = 0;
+	int ret;
 	int i;
 
 	if (argc < 2) {
@@ -78,6 +95,11 @@ int main(int argc, char **argv)
 		handles[nr_handles] = tracecmd_open(argv[i], 0);
 		if (!handles[nr_handles])
 			exit(-1);
+
+		ret = tracecmd_get_tsc2nsec(handles[nr_handles], &multi, &shift, &offset);
+		if (!ret)
+			printf(" %s has tsc2nsec calculations of mult:%d shift:%d offset:%lld\n",
+				argv[i], multi, shift, offset);
 		tracecmd_set_private(handles[nr_handles], argv[i]);
 		ts = tracecmd_get_first_ts(handles[nr_handles]);
 		if (!first_ts || ts < first_ts)
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index a820ed323089..6f1494fe57d3 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -64,6 +64,7 @@ Read tracing instances from a trace file:
 Handle time stamps from a trace file:
 	unsigned long long *tracecmd_get_first_ts*(struct tracecmd_input pass:[*]_handle_);
 	void *tracecmd_add_ts_offset*(struct tracecmd_input pass:[*]_handle_, long long _offset_);
+	int *tracecmd_get_tsc2nsec*(struct tracecmd_input pass:[*]_handle_, int pass:[*]_mult_, int pass[*]_shift_, unsigned long long pass:[*]_offset_);
 
 Get traceing peer information from a trace file:
 	unsigned long long *tracecmd_get_traceid*(struct tracecmd_input pass:[*]_handle_);
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 61ab4f035fec..8b467fe514a9 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -48,6 +48,8 @@ int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 			      int *vcpu_count, const int **cpu_pid);
 unsigned long long tracecmd_get_first_ts(struct tracecmd_input *handle);
 void tracecmd_add_ts_offset(struct tracecmd_input *handle, long long offset);
+int tracecmd_get_tsc2nsec(struct tracecmd_input *handle,
+			  int *mult, int *shift, unsigned long long *offset);
 int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ced016a221ca..865721ae50b6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -6135,6 +6135,33 @@ const char *tracecmd_get_trace_clock(struct tracecmd_input *handle)
 	return handle->trace_clock;
 }
 
+/**
+ * tracecmd_get_tsc2nsec - get the calculation numbers to convert to nsecs
+ * @mult: If not NULL, points to where to save the multiplier
+ * @shift: If not NULL, points to where to save the shift.
+ * @offset: If not NULL, points to where to save the offset.
+ *
+ * This only returns a value if the clock is of a raw type.
+ * (currently just x86-tsc is supported).
+ *
+ * Returns 0 on success, or -1 on not supported clock (but may still fill
+ * in the values).
+ */
+int tracecmd_get_tsc2nsec(struct tracecmd_input *handle,
+			  int *mult, int *shift, unsigned long long *offset)
+{
+	if (mult)
+		*mult = handle->tsc_calc.mult;
+	if (shift)
+		*shift = handle->tsc_calc.shift;
+	if (offset)
+		*offset = handle->tsc_calc.offset;
+
+	return handle->top_buffer.clock &&
+		(strcmp(handle->top_buffer.clock, "x86-tsc") == 0 ||
+		 strcmp(handle->top_buffer.clock, "tsc2nsec") == 0) ? 0 : -1;
+}
+
 /**
  * tracecmd_get_cpustats - return the saved cpu stats
  * @handle: input handle for the trace.dat file
-- 
2.39.2

