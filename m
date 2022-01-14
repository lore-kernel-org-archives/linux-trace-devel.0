Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B14FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 10:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbiANKAD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 05:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbiANJ75 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 04:59:57 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4A7C06173E
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 01:59:56 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id a18so33061797edj.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 01:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0nGqL3THSKPjOVTR06nbQKGFbFlBuI2GGW7xknzuaug=;
        b=dLJGbvc1tDBX7mahS7yM/sbroySHIrWilWU77OO6TC48OlufOZQU5v3Nrt4Z1iZ5eL
         ZHDRL4jqUVHAf2888AwOSWsvy3DNtbLDfChHeTAdKHHt9LIBxkUpVe90EKw3Z/OnxJnj
         Zuk/Sa2ykjfpe0OGPd508/IVv9qoshamaKMQYr/JuxVPvOS6n06JcA+9gCb8uvJRS8Eq
         rl1FE0YNjpcCtOBt1NYdF6UKNnt7Cv39JcAllXVMPP0STTvQTE77FJrFwE398j4w4EHG
         42LElrBZKbYp4e6t/UFHO06QHwhNRJYKeLEgPwtL4AR5UOb330kGcoCoQqIqDCsurOyx
         lXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0nGqL3THSKPjOVTR06nbQKGFbFlBuI2GGW7xknzuaug=;
        b=RI/QITk1E7Gb+slFNj9IZAsU3nKm38N4QpMyG+tQ84asSB/mqmItX1Jx/wM/HmNfhM
         PFKWIi9kEKRluuegG2W/SHHdDDHaiK2TQssPofCZfBEK4U6hM/7UWZhKqgOpoT9t5Afk
         UX5jyfnqbzfYc/J90HVR7n0uzNsRhSjEVgRZc07lvFhdBhbwfQSYOg9ibT5n5IQPRnV/
         L3Zs8WWwHxixAxxLq7tNdoKkCsR3rurD24mzfx3Ozu7N3kfLEVeuCE6YPJVAZCZNfPH0
         cwMQUkPpC7ocJhbZzPVKlfSArJJ7HWAN8mJsFg2le1g3L/IFKzRxZzUms2upihvhSAWH
         M62g==
X-Gm-Message-State: AOAM533Pu4Qdc03Je3s5M24ITFp51XahxnGSzbWH+9lhPaMobY+akM0F
        lMv/GUvtdHM38tiWH4nIix5YZ08iETM=
X-Google-Smtp-Source: ABdhPJxXyRuLIhlW6d/fmvA/xWcBqF5lJTaPbEqNQe7OAfFwRZQJQ9bn7YyFsvynKdvG7ek1QXzVqA==
X-Received: by 2002:a17:907:960d:: with SMTP id gb13mr6641197ejc.572.1642154395090;
        Fri, 14 Jan 2022 01:59:55 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 24sm1675810eje.158.2022.01.14.01.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 01:59:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: Update main man page
Date:   Fri, 14 Jan 2022 11:59:50 +0200
Message-Id: <20220114095950.41334-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114095950.41334-1-tz.stoyanov@gmail.com>
References: <20220114095950.41334-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All API functions of the library should be listed in the main man page,
"man libtracefs". Some of the newly added APIs are missing there,
updated the list.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs.txt | 138 ++++++++++++++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 9157c33..0123c0b 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -32,6 +32,9 @@ Trace instances:
 	const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
 	bool *tracefs_instance_exists*(const char pass:[*]_name_);
+	int *tracefs_instance_set_affinity*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_cpu_str_);
+	int *tracefs_instance_set_affinity_set*(struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
+	int *tracefs_instance_set_affinity_raw*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_mask_);
 
 Trace events:
 	char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
@@ -41,9 +44,21 @@ Trace events:
 	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
 
+Event filters:
+	int *tracefs_filter_string_append*(struct tep_event pass:[*]_event_, char pass:[**]_filter_,
+					 struct tracefs_filter _type_, const char pass:[*]_field_,
+					 enum tracefs_synth_compare _compare_, const char pass:[*]_val_);
+	int *tracefs_filter_string_verify*(struct tep_event pass:[*]_event_, const char pass:[*]_filter_, char pass:[**]_err_);
+	int *tracefs_event_filter_apply*(struct tracefs_instance pass:[*]_instance_, struct tep_event pass:[*]_event_, const char pass:[*]_filter_);
+	int *tracefs_event_filter_clear*(struct tracefs_instance pass:[*]_instance_, struct tep_event pass:[*]_event_);
+
+Function filters:
+	int *tracefs_function_filter*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
+	int *tracefs_function_notrace*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
+	int *tracefs_filter_functions*(const char pass:[*]_filter_, const char pass:[*]_module_, char pass:[*]pass:[*]pass:[*]_list_);
+
 Trace helper functions:
 	void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
-	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
 	char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_is_on*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_on*(struct tracefs_instance pass:[*]_instance_);
@@ -52,6 +67,22 @@ Trace helper functions:
 	int *tracefs_trace_on_fd*(int _fd_);
 	int *tracefs_trace_off_fd*(int _fd_);
 
+Trace options:
+	const struct tracefs_options_mask pass:[*]*tracefs_options_get_supported*(struct tracefs_instance pass:[*]_instance_);
+	bool *tracefs_option_is_supported*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+	const struct tracefs_options_mask pass:[*]*tracefs_options_get_enabled*(struct tracefs_instance pass:[*]_instance_);
+	bool *tracefs_option_is_enabled*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+	bool *tracefs_option_mask_is_set*(const struct tracefs_options_mask *options, enum tracefs_option_id id);
+	int *tracefs_option_enable*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+	int *tracefs_option_disable*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+	const char pass:[*]*tracefs_option_name*(enum tracefs_option_id _id_);
+
+Ftrace tracers:
+	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
+	int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_);
+	int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_, const char pass:[*]_name_);
+	int *tracefs_tracer_clear*(struct tracefs_instance pass:[*]_instance_);
+
 Writing data in the trace buffer:
 	int *tracefs_print_init*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_printf*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_fmt_, _..._);
@@ -83,6 +114,111 @@ Kprobes and Kretprobes:
 	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, unsigned int _max_);
 	int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 	int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
+
+Synthetic events:
+	struct tracefs_synth pass:[*]*tracefs_sql*(struct tep_handle pass:[*]_tep_, const char pass:[*]_name_,
+					const char pass:[*]_sql_buffer_, char pass:[**]_err_);
+	struct tracefs_synth pass:[*]*tracefs_synth_alloc*(struct tep_handle pass:[*]_tep_,
+						 const char pass:[*]_name_,
+						 const char pass:[*]_start_system_,
+						 const char pass:[*]_start_event_,
+						 const char pass:[*]_end_system_,
+						 const char pass:[*]_end_event_,
+						 const char pass:[*]_start_match_field_,
+						 const char pass:[*]_end_match_field_,
+						 const char pass:[*]_match_name_);
+	int *tracefs_synth_add_match_field*(struct tracefs_synth pass:[*]_synth_,
+					  const char pass:[*]_start_match_field_,
+					  const char pass:[*]_end_match_field_,
+					  const char pass:[*]_name_);
+	int *tracefs_synth_add_compare_field*(struct tracefs_synth pass:[*]_synth_,
+					    const char pass:[*]_start_compare_field_,
+					    const char pass:[*]_end_compare_field_,
+					    enum tracefs_synth_calc _calc_,
+					    const char pass:[*]_name_);
+	int *tracefs_synth_add_start_field*(struct tracefs_synth pass:[*]_synth_,
+					  const char pass:[*]_start_field_,
+					  const char pass:[*]_name_);
+	int *tracefs_synth_add_end_field*(struct tracefs_synth pass:[*]_synth_,
+					const char pass:[*]_end_field_,
+					const char pass:[*]_name_);
+	int *tracefs_synth_append_start_filter*(struct tracefs_synth pass:[*]_synth_,
+					      struct tracefs_filter _type_,
+					      const char pass:[*]_field_,
+					      enum tracefs_synth_compare _compare_,
+					      const char pass:[*]_val_);
+	int *tracefs_synth_append_end_filter*(struct tracefs_synth pass:[*]_synth_,
+					    struct tracefs_filter _type_,
+					    const char pass:[*]_field_,
+					    enum tracefs_synth_compare _compare_,
+					    const char pass:[*]_val_);
+	void *tracefs_synth_free*(struct tracefs_synth pass:[*]_synth_);
+	int *tracefs_synth_create*(struct tracefs_synth pass:[*]_synth_);
+	int *tracefs_synth_destroy*(struct tracefs_synth pass:[*]_synth_);
+	int *tracefs_synth_echo_cmd*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
+	bool *tracefs_synth_complete*(struct tracefs_synth pass:[*]_synth_);
+	struct tracefs_hist pass:[*]*tracefs_synth_get_start_hist*(struct tracefs_synth pass:[*]_synth_);
+	int *tracefs_synth_trace*(struct tracefs_synth pass:[*]_synth_,
+				enum tracefs_synth_handler _type_, const char pass:[*]_var_);
+	int *tracefs_synth_snapshot*(struct tracefs_synth pass:[*]_synth_,
+				   enum tracefs_synth_handler _type_, const char pass:[*]_var_);
+	int *tracefs_synth_save*(struct tracefs_synth pass:[*]_synth_,
+			       enum tracefs_synth_handler _type_, const char pass:[*]_var_,
+			       char pass:[**]_save_fields_);
+	const char pass:[*]*tracefs_synth_get_name*(struct tracefs_synth pass:[*]_synth_);
+	int *tracefs_synth_raw_fmt*(struct trace_seq pass:[*]_seq_, struct tracefs_synth pass:[*]_synth_);
+	const char pass:[*]*tracefs_synth_show_event*(struct tracefs_synth pass:[*]_synth_);
+	const char pass:[*]*tracefs_synth_show_start_hist*(struct tracefs_synth pass:[*]_synth_);
+	const char pass:[*]*tracefs_synth_show_end_hist*(struct tracefs_synth pass:[*]_synth_);
+
+Ftrace errors reporting:
+	char pass:[*]*tracefs_error_last*(struct tracefs_instance pass:[*]_instance_);
+	char pass:[*]*tracefs_error_all*(struct tracefs_instance pass:[*]_instance_);
+	int *tracefs_error_clear*(struct tracefs_instance pass:[*]_instance_);
+
+Histograms:
+	struct tracefs_hist pass:[*]*tracefs_hist_alloc*(struct tracefs_tep pass:[*] _tep_,
+				const char pass:[*]_system_, const char pass:[*]_event_,
+				const char pass:[*]_key_, enum tracefs_hist_key_type _type_);
+	struct tracefs_hist pass:[*]*tracefs_hist_alloc_2d*(struct tracefs_tep pass:[*] _tep_,
+				const char pass:[*]_system_, const char pass:[*]_event_,
+				const char pass:[*]_key1_, enum tracefs_hist_key_type _type1_,
+				const char pass:[*]_key2_, enum tracefs_hist_key_type _type2_));
+	struct tracefs_hist pass:[*]*tracefs_hist_alloc_nd*(struct tracefs_tep pass:[*] _tep_,
+				const char pass:[*]_system_, const char pass:[*]_event_,
+				struct tracefs_hist_axis pass:[*]_axes_);
+	void *tracefs_hist_free*(struct tracefs_hist pass:[*]_hist_);
+	int *tracefs_hist_add_key*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_key_,
+				 enum tracefs_hist_key_type _type_);
+	int *tracefs_hist_add_value*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_value_);
+	int *tracefs_hist_add_sort_key*(struct tracefs_hist pass:[*]_hist_,
+				      const char pass:[*]_sort_key_);
+	int *tracefs_hist_set_sort_key*(struct tracefs_hist pass:[*]_hist_,
+				      const char pass:[*]_sort_key_, _..._);
+	int *tracefs_hist_sort_key_direction*(struct tracefs_hist pass:[*]_hist_,
+					    const char pass:[*]_sort_key_,
+					    enum tracefs_hist_sort_direction _dir_);
+	int *tracefs_hist_add_name*(struct tracefs_hist pass:[*]_hist_, const char pass:[*]_name_);
+	int *tracefs_hist_append_filter*(struct tracefs_hist pass:[*]_hist_,
+				       enum tracefs_filter _type_,
+				       const char pass:[*]_field_,
+				       enum tracefs_compare _compare_,
+				       const char pass:[*]_val_);
+	int *tracefs_hist_echo_cmd*(struct trace_seq pass:[*]_s_, struct tracefs_instance pass:[*]_instance_,
+				  struct tracefs_hist pass:[*]_hist_,
+				  enum tracefs_hist_command _command_);
+	int *tracefs_hist_command*(struct tracefs_instance pass:[*]_instance_,
+				 struct tracefs_hist pass:[*]_hist_,
+				 enum tracefs_hist_command _command_);
+	const char pass:[*]*tracefs_hist_get_name*(struct tracefs_hist pass:[*]_hist_);
+	const char pass:[*]*tracefs_hist_get_event*(struct tracefs_hist pass:[*]_hist_);
+	const char pass:[*]*tracefs_hist_get_system*(struct tracefs_hist pass:[*]_hist_);
+	int *tracefs_hist_start*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+	int *tracefs_hist_destroy*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+	int *tracefs_hist_pause*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+	int *tracefs_hist_continue*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+	int *tracefs_hist_reset*(struct tracefs_instance pass:[*]_instance_, struct tracefs_hist pass:[*]_hist_);
+
 --
 
 DESCRIPTION
-- 
2.34.1

