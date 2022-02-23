Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3566C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiBWAao (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbiBWAam (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A02855BED
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7246130F
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82981C340F6;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bG7-CV;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 01/11] libtracefs: Update main man page for all functions
Date:   Tue, 22 Feb 2022 19:30:02 -0500
Message-Id: <20220223003012.1334741-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add all the missing functions to the main man page.

Also, fix the tracefs_instance_set_affinity_raw and
tracefs_instance_get_affinity_raw as they were missing the "instance" part
in the name.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-affinity.txt |  4 ++--
 Documentation/libtracefs.txt                    | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index 385d65035ece..39dd44c1a3fb 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -3,8 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_set_affinity_raw,
-tracefs_instance_get_affinity, tracefs_instance_get_affinity_set, tracefs_get_affinity_raw
+tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_instance_set_affinity_raw,
+tracefs_instance_get_affinity, tracefs_instance_get_affinity_set, tracefs_instance_get_affinity_raw
 - Sets or retrieves the affinity for an instance or top level for what CPUs enable tracing.
 
 SYNOPSIS
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 33988007d865..12df3ce3b7af 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -19,6 +19,7 @@ Locations of tracing files and directories:
 Trace instances:
 	struct tracefs_instance pass:[*]*tracefs_instance_create*(const char pass:[*]_name_);
 	int *tracefs_instance_destroy*(struct tracefs_instance pass:[*]_instance_);
+	struct tracefs_instance pass:[*]*tracefs_instance_alloc*(const char pass:[*]_tracing_dir_, const char pass:[*]_name_);
 	void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_file_exists*(struct tracefs_instance pass:[*]_instance_, char pass:[*]_name_);
@@ -27,9 +28,12 @@ Trace instances:
 	char pass:[*]*tracefs_instance_get_dir*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_instance_file_open*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int _mode_);
 	int *tracefs_instance_file_write*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
+	int *tracefs_instance_file_append*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, const char pass:[*]_str_);
+	int *tracefs_instance_file_clear*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_);
 	char pass:[*]*tracefs_instance_file_read*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, int pass:[*]_psize_);
 	int *tracefs_instance_file_read_number*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_file_, long long int pass:[*]_res_);
 	const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
+	const char pass:[*]*tracefs_instance_get_trace_dir*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
 	bool *tracefs_instance_exists*(const char pass:[*]_name_);
 	int *tracefs_instance_set_affinity*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_cpu_str_);
@@ -42,10 +46,15 @@ Trace instances:
 Trace events:
 	char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
 	char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
+	int *tracefs_event_enable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_,
+                           const char pass:[*]_event_);
+	int *tracefs_event_disable*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_,
+                            const char pass:[*]_event_);
 	int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
 	struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
 	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
+	int *tracefs_load_cmdlines*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_);
 
 Event filters:
 	int *tracefs_filter_string_append*(struct tep_event pass:[*]_event_, char pass:[**]_filter_,
@@ -70,6 +79,11 @@ Trace helper functions:
 	int *tracefs_trace_on_fd*(int _fd_);
 	int *tracefs_trace_off_fd*(int _fd_);
 
+Trace stream:
+	ssize_t *tracefs_trace_pipe_stream*(int _fd_, struct tracefs_instance pass:[*]_instance_, int _flags_);
+	ssize_t *tracefs_trace_pipe_print*(struct tracefs_instance pass:[*]_instance_, int _flags_);
+	void *tracefs_trace_pipe_stop*(struct tracefs_instance pass:[*]_instance_);
+
 Trace options:
 	const struct tracefs_options_mask pass:[*]*tracefs_options_get_supported*(struct tracefs_instance pass:[*]_instance_);
 	bool *tracefs_option_is_supported*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
@@ -106,8 +120,10 @@ Dynamic event generic APIs:
 	int *tracefs_dynevent_destroy_all*(unsigned int _types_, bool _force_);
 	void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
 	void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
+	struct tracefs_dynevent pass:[*]*tracefs_dynevent_get*(enum tracefs_dynevent_type _type_, const char pass:[*]_system_, const char pass:[*]_event_);
 	struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned int _types_, const char pass:[*]_system_);
 	enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
+	struct tep_event pass:[*]*tracefs_dynevent_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_dynevent pass:[*]_dynevent_);
 
 Even probes (eprobes):
 	struct tracefs_dynevent pass:[*] *tracefs_eprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_target_system_, const char pass:[*]_target_event_, const char pass:[*]_fetchargs_);
@@ -173,6 +189,7 @@ Synthetic events:
 	const char pass:[*]*tracefs_synth_show_event*(struct tracefs_synth pass:[*]_synth_);
 	const char pass:[*]*tracefs_synth_show_start_hist*(struct tracefs_synth pass:[*]_synth_);
 	const char pass:[*]*tracefs_synth_show_end_hist*(struct tracefs_synth pass:[*]_synth_);
+	struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
 
 Ftrace errors reporting:
 	char pass:[*]*tracefs_error_last*(struct tracefs_instance pass:[*]_instance_);
-- 
2.34.1

