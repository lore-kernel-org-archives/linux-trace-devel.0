Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9131C10F13
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DA1A21850
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbfDEODt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:03:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40041 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731140AbfDEODs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 10:03:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so8175692wre.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 07:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lVTYJQ1y/MtvQZuUhHUFotm80NUZA6HdP8CSkBLf0b0=;
        b=Gerdb69Is9+zBF8fFWPkmV+e/5CO3De1BJm3N0GeUaaIfYznWYEKOrnTv4Z/XUonkh
         E2U1E/YQXMMt4i1RytJJK5kmtJKAIXkQylNq00y0u1tfJLW+me3QDFFeCnNErRusIWOV
         pR/DSWIgDb7JDb2dET/YxanXjDT6XwP8MHB86fhLIph7c3RM2cwB+b/18r6XJ4ZOugiQ
         rjW3CP9zO6IHMSkMsLdvEw1+GOwOg5MaJTcwg6CYiba9kfKr/GNRTTHyzt7PAerHM1OY
         YomXzhQiNB0w2ITpYScoH/0sMLJMbbokLOpBU6djkeYgon6SSfpBanqFu60pBuWU3++Z
         XjTg==
X-Gm-Message-State: APjAAAX2nGPgM4a0ROidibHUSCG/MVB/sxti33KEfeG9+9nlV2zd0u7f
        QnKnaJWBvP3MKUKhC0B7axqFoN0K
X-Google-Smtp-Source: APXvYqzWP7Vf0YKSemPZGozSBuNUxKOwCGNQmgBu0AiuhjBfU+GMORCq99XUEoOJ2gvDlmd+Kfl51g==
X-Received: by 2002:a05:6000:1111:: with SMTP id z17mr5991081wrw.103.1554473022822;
        Fri, 05 Apr 2019 07:03:42 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w16sm29604647wrt.84.2019.04.05.07.03.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Apr 2019 07:03:42 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/10] tools lib traceevent: Rename input arguments of libtraceevent APIs from pevent to tep
Date:   Fri,  5 Apr 2019 17:03:29 +0300
Message-Id: <20190405140332.10949-8-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190405140332.10949-1-tstoyanov@vmware.com>
References: <20190405140332.10949-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Input arguments of libtraceevent APIs are renamed from "struct
tep_handle *pevent" to "struct tep_handle *tep". This makes the API
consistent with the chosen naming convention: tep (trace event parser),
instead of the old pevent.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flore.kernel.org%2Flinux-trace-devel%2F20190401132111.13727-2-tstoyanov%40vmware.com&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C0b8cc7f3ce614f48b67208d6b78545fe%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180399072476&amp;sdata=Fo%2FXpX3R09wlJ81bkHyS50I8DO2imvYEd6AsXU8w5iI%3D&amp;reserved=0
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flkml.kernel.org%2Fr%2F20190401164344.465573837%40goodmis.org&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C0b8cc7f3ce614f48b67208d6b78545fe%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180399072476&amp;sdata=R9OuALAoTenXMTJi8OWl4Qzu0GAT7W8I4c3qWqM4Gxo%3D&amp;reserved=0
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h   | 122 ++++----
 lib/traceevent/event-parse-api.c   | 134 ++++-----
 lib/traceevent/event-parse-local.h |   6 +-
 lib/traceevent/event-parse.c       | 452 ++++++++++++++---------------
 lib/traceevent/event-plugin.c      |   8 +-
 lib/traceevent/parse-filter.c      |   8 +-
 plugins/plugin_cfg80211.c          |   8 +-
 plugins/plugin_function.c          |   8 +-
 plugins/plugin_hrtimer.c           |  13 +-
 plugins/plugin_jbd2.c              |  12 +-
 plugins/plugin_kmem.c              |  29 +-
 plugins/plugin_kvm.c               |  45 +--
 plugins/plugin_mac80211.c          |   6 +-
 plugins/plugin_sched_switch.c      |  16 +-
 plugins/plugin_scsi.c              |   8 +-
 plugins/plugin_xen.c               |   8 +-
 16 files changed, 442 insertions(+), 441 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index f8a5461..ca18025 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -50,8 +50,8 @@ typedef int (*tep_event_handler_func)(struct trace_seq *s,
 				      struct tep_event *event,
 				      void *context);
 
-typedef int (*tep_plugin_load_func)(struct tep_handle *pevent);
-typedef int (*tep_plugin_unload_func)(struct tep_handle *pevent);
+typedef int (*tep_plugin_load_func)(struct tep_handle *tep);
+typedef int (*tep_plugin_unload_func)(struct tep_handle *tep);
 
 struct tep_plugin_option {
 	struct tep_plugin_option	*next;
@@ -71,12 +71,12 @@ struct tep_plugin_option {
  * TEP_PLUGIN_LOADER:  (required)
  *   The function name to initialized the plugin.
  *
- *   int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+ *   int TEP_PLUGIN_LOADER(struct tep_handle *tep)
  *
  * TEP_PLUGIN_UNLOADER:  (optional)
  *   The function called just before unloading
  *
- *   int TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+ *   int TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
  *
  * TEP_PLUGIN_OPTIONS:  (optional)
  *   Plugin options that can be set before loading
@@ -379,9 +379,9 @@ struct tep_plugin_list;
 
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
-struct tep_plugin_list *tep_load_plugins(struct tep_handle *pevent);
+struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
 void tep_unload_plugins(struct tep_plugin_list *plugin_list,
-			struct tep_handle *pevent);
+			struct tep_handle *tep);
 char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
@@ -416,37 +416,37 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x10,
 };
 
-int tep_set_function_resolver(struct tep_handle *pevent,
+int tep_set_function_resolver(struct tep_handle *tep,
 			      tep_func_resolver_t *func, void *priv);
-void tep_reset_function_resolver(struct tep_handle *pevent);
-int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
-int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid);
-int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
-int tep_register_function(struct tep_handle *pevent, char *name,
+void tep_reset_function_resolver(struct tep_handle *tep);
+int tep_register_comm(struct tep_handle *tep, const char *comm, int pid);
+int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
+int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock);
+int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
-int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
+int tep_register_print_string(struct tep_handle *tep, const char *fmt,
 			      unsigned long long addr);
-bool tep_is_pid_registered(struct tep_handle *pevent, int pid);
+bool tep_is_pid_registered(struct tep_handle *tep, int pid);
 
-void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record);
-void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record,
 			  bool use_trace_clock);
-void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_data(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record);
-void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock);
 
-int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
+int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 			  int long_size);
 
-enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
+enum tep_errno tep_parse_event(struct tep_handle *tep, const char *buf,
 			       unsigned long size, const char *sys);
-enum tep_errno tep_parse_format(struct tep_handle *pevent,
+enum tep_errno tep_parse_format(struct tep_handle *tep,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
@@ -466,8 +466,8 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
 			  unsigned long long *val, int err);
 
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
-			   struct tep_event *event, const char *name,
-			   struct tep_record *record, int err);
+			struct tep_event *event, const char *name,
+			struct tep_record *record, int err);
 
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_event *event, const char *name,
@@ -478,51 +478,51 @@ enum tep_reg_handler {
 	TEP_REGISTER_SUCCESS_OVERWRITE,
 };
 
-int tep_register_event_handler(struct tep_handle *pevent, int id,
+int tep_register_event_handler(struct tep_handle *tep, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context);
-int tep_unregister_event_handler(struct tep_handle *pevent, int id,
+int tep_unregister_event_handler(struct tep_handle *tep, int id,
 				 const char *sys_name, const char *event_name,
 				 tep_event_handler_func func, void *context);
-int tep_register_print_function(struct tep_handle *pevent,
+int tep_register_print_function(struct tep_handle *tep,
 				tep_func_handler func,
 				enum tep_func_arg_type ret_type,
 				char *name, ...);
-int tep_unregister_print_function(struct tep_handle *pevent,
+int tep_unregister_print_function(struct tep_handle *tep,
 				  tep_func_handler func, char *name);
 
 struct tep_format_field *tep_find_common_field(struct tep_event *event, const char *name);
 struct tep_format_field *tep_find_field(struct tep_event *event, const char *name);
 struct tep_format_field *tep_find_any_field(struct tep_event *event, const char *name);
 
-const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr);
+const char *tep_find_function(struct tep_handle *tep, unsigned long long addr);
 unsigned long long
-tep_find_function_address(struct tep_handle *pevent, unsigned long long addr);
-unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, int size);
+tep_find_function_address(struct tep_handle *tep, unsigned long long addr);
+unsigned long long tep_read_number(struct tep_handle *tep, const void *ptr, int size);
 int tep_read_number_field(struct tep_format_field *field, const void *data,
 			  unsigned long long *value);
 
 struct tep_event *tep_get_first_event(struct tep_handle *tep);
 struct tep_event *tep_get_event(struct tep_handle *tep, int index);
 int tep_get_events_count(struct tep_handle *tep);
-struct tep_event *tep_find_event(struct tep_handle *pevent, int id);
+struct tep_event *tep_find_event(struct tep_handle *tep, int id);
 
 struct tep_event *
-tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
+tep_find_event_by_name(struct tep_handle *tep, const char *sys, const char *name);
 struct tep_event *
-tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
+tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record);
 
-void tep_data_latency_format(struct tep_handle *pevent,
+void tep_data_latency_format(struct tep_handle *tep,
 			     struct trace_seq *s, struct tep_record *record);
-int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
-int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
-int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
-int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
-const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid);
+int tep_data_type(struct tep_handle *tep, struct tep_record *rec);
+int tep_data_pid(struct tep_handle *tep, struct tep_record *rec);
+int tep_data_preempt_count(struct tep_handle *tep, struct tep_record *rec);
+int tep_data_flags(struct tep_handle *tep, struct tep_record *rec);
+const char *tep_data_comm_from_pid(struct tep_handle *tep, int pid);
 struct tep_cmdline;
-struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *tep, const char *comm,
 					   struct tep_cmdline *next);
-int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline);
+int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
@@ -530,7 +530,7 @@ void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
 void tep_event_info(struct trace_seq *s, struct tep_event *event,
 		    struct tep_record *record);
-int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
+int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
 		 char *buf, size_t buflen);
 
 struct tep_event **tep_list_events(struct tep_handle *tep,
@@ -544,19 +544,19 @@ enum tep_endian {
         TEP_LITTLE_ENDIAN = 0,
         TEP_BIG_ENDIAN
 };
-int tep_get_cpus(struct tep_handle *pevent);
-void tep_set_cpus(struct tep_handle *pevent, int cpus);
-int tep_get_long_size(struct tep_handle *pevent);
-void tep_set_long_size(struct tep_handle *pevent, int long_size);
-int tep_get_page_size(struct tep_handle *pevent);
-void tep_set_page_size(struct tep_handle *pevent, int _page_size);
-bool tep_is_file_bigendian(struct tep_handle *pevent);
-void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian);
-bool tep_is_local_bigendian(struct tep_handle *pevent);
-void tep_set_local_bigendian(struct tep_handle *pevent, enum tep_endian endian);
-bool tep_is_latency_format(struct tep_handle *pevent);
-void tep_set_latency_format(struct tep_handle *pevent, int lat);
-int tep_get_header_page_size(struct tep_handle *pevent);
+int tep_get_cpus(struct tep_handle *tep);
+void tep_set_cpus(struct tep_handle *tep, int cpus);
+int tep_get_long_size(struct tep_handle *tep);
+void tep_set_long_size(struct tep_handle *tep, int long_size);
+int tep_get_page_size(struct tep_handle *tep);
+void tep_set_page_size(struct tep_handle *tep, int _page_size);
+bool tep_is_file_bigendian(struct tep_handle *tep);
+void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);
+bool tep_is_local_bigendian(struct tep_handle *tep);
+void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian);
+bool tep_is_latency_format(struct tep_handle *tep);
+void tep_set_latency_format(struct tep_handle *tep, int lat);
+int tep_get_header_page_size(struct tep_handle *tep);
 void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures);
 int tep_get_parsing_failures(struct tep_handle *tep);
 int tep_get_header_timestamp_size(struct tep_handle *tep);
@@ -565,9 +565,9 @@ void tep_set_print_raw(struct tep_handle *tep, int print_raw);
 void tep_set_test_filters(struct tep_handle *tep, int test_filters);
 
 struct tep_handle *tep_alloc(void);
-void tep_free(struct tep_handle *pevent);
-void tep_ref(struct tep_handle *pevent);
-void tep_unref(struct tep_handle *pevent);
+void tep_free(struct tep_handle *tep);
+void tep_ref(struct tep_handle *tep);
+void tep_unref(struct tep_handle *tep);
 int tep_get_ref(struct tep_handle *tep);
 
 /* access to the internal parser */
@@ -579,8 +579,8 @@ const char *tep_get_input_buf(void);
 unsigned long long tep_get_input_buf_ptr(void);
 
 /* for debugging */
-void tep_print_funcs(struct tep_handle *pevent);
-void tep_print_printk(struct tep_handle *pevent);
+void tep_print_funcs(struct tep_handle *tep);
+void tep_print_printk(struct tep_handle *tep);
 
 /* ----------------------- filtering ----------------------- */
 
@@ -713,7 +713,7 @@ struct tep_event_filter {
 	char			error_buffer[TEP_FILTER_ERROR_BUFSZ];
 };
 
-struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent);
+struct tep_event_filter *tep_filter_alloc(struct tep_handle *tep);
 
 /* for backward compatibility */
 #define FILTER_NONE		TEP_ERRNO__NO_FILTER
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index 13d65a8..8ef496b 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -92,11 +92,11 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 	return false;
 }
 
-unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
+unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
 {
 	unsigned short swap;
 
-	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
 	swap = ((data & 0xffULL) << 8) |
@@ -105,11 +105,11 @@ unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
 	return swap;
 }
 
-unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data)
+unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
 {
 	unsigned int swap;
 
-	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
 	swap = ((data & 0xffULL) << 24) |
@@ -121,11 +121,11 @@ unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data)
 }
 
 unsigned long long
-tep_data2host8(struct tep_handle *pevent, unsigned long long data)
+tep_data2host8(struct tep_handle *tep, unsigned long long data)
 {
 	unsigned long long swap;
 
-	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
 	swap = ((data & 0xffULL) << 56) |
@@ -142,15 +142,15 @@ tep_data2host8(struct tep_handle *pevent, unsigned long long data)
 
 /**
  * tep_get_header_page_size - get size of the header page
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns size of the header page
- * If @pevent is NULL, 0 is returned.
+ * If @tep is NULL, 0 is returned.
  */
-int tep_get_header_page_size(struct tep_handle *pevent)
+int tep_get_header_page_size(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->header_page_size_size;
+	if (tep)
+		return tep->header_page_size_size;
 	return 0;
 }
 
@@ -170,163 +170,163 @@ int tep_get_header_timestamp_size(struct tep_handle *tep)
 
 /**
  * tep_get_cpus - get the number of CPUs
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns the number of CPUs
- * If @pevent is NULL, 0 is returned.
+ * If @tep is NULL, 0 is returned.
  */
-int tep_get_cpus(struct tep_handle *pevent)
+int tep_get_cpus(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->cpus;
+	if (tep)
+		return tep->cpus;
 	return 0;
 }
 
 /**
  * tep_set_cpus - set the number of CPUs
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This sets the number of CPUs
  */
-void tep_set_cpus(struct tep_handle *pevent, int cpus)
+void tep_set_cpus(struct tep_handle *tep, int cpus)
 {
-	if (pevent)
-		pevent->cpus = cpus;
+	if (tep)
+		tep->cpus = cpus;
 }
 
 /**
  * tep_get_long_size - get the size of a long integer on the traced machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns the size of a long integer on the traced machine
- * If @pevent is NULL, 0 is returned.
+ * If @tep is NULL, 0 is returned.
  */
-int tep_get_long_size(struct tep_handle *pevent)
+int tep_get_long_size(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->long_size;
+	if (tep)
+		return tep->long_size;
 	return 0;
 }
 
 /**
  * tep_set_long_size - set the size of a long integer on the traced machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @size: size, in bytes, of a long integer
  *
  * This sets the size of a long integer on the traced machine
  */
-void tep_set_long_size(struct tep_handle *pevent, int long_size)
+void tep_set_long_size(struct tep_handle *tep, int long_size)
 {
-	if (pevent)
-		pevent->long_size = long_size;
+	if (tep)
+		tep->long_size = long_size;
 }
 
 /**
  * tep_get_page_size - get the size of a memory page on the traced machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns the size of a memory page on the traced machine
- * If @pevent is NULL, 0 is returned.
+ * If @tep is NULL, 0 is returned.
  */
-int tep_get_page_size(struct tep_handle *pevent)
+int tep_get_page_size(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->page_size;
+	if (tep)
+		return tep->page_size;
 	return 0;
 }
 
 /**
  * tep_set_page_size - set the size of a memory page on the traced machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @_page_size: size of a memory page, in bytes
  *
  * This sets the size of a memory page on the traced machine
  */
-void tep_set_page_size(struct tep_handle *pevent, int _page_size)
+void tep_set_page_size(struct tep_handle *tep, int _page_size)
 {
-	if (pevent)
-		pevent->page_size = _page_size;
+	if (tep)
+		tep->page_size = _page_size;
 }
 
 /**
  * tep_is_file_bigendian - return the endian of the file
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns true if the file is in big endian order
- * If @pevent is NULL, false is returned.
+ * If @tep is NULL, false is returned.
  */
-bool tep_is_file_bigendian(struct tep_handle *pevent)
+bool tep_is_file_bigendian(struct tep_handle *tep)
 {
-	if (pevent)
-		return (pevent->file_bigendian == TEP_BIG_ENDIAN);
-	return 0;
+	if (tep)
+		return (tep->file_bigendian == TEP_BIG_ENDIAN);
+	return false;
 }
 
 /**
  * tep_set_file_bigendian - set if the file is in big endian order
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @endian: non zero, if the file is in big endian order
  *
  * This sets if the file is in big endian order
  */
-void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
+void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian)
 {
-	if (pevent)
-		pevent->file_bigendian = endian;
+	if (tep)
+		tep->file_bigendian = endian;
 }
 
 /**
  * tep_is_local_bigendian - return the endian of the saved local machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
- * This returns true if the saved local machine in @pevent is big endian.
- * If @pevent is NULL, false is returned.
+ * This returns true if the saved local machine in @tep is big endian.
+ * If @tep is NULL, false is returned.
  */
-bool tep_is_local_bigendian(struct tep_handle *pevent)
+bool tep_is_local_bigendian(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->host_bigendian;
+	if (tep)
+		return (tep->host_bigendian == TEP_BIG_ENDIAN);
 	return 0;
 }
 
 /**
  * tep_set_local_bigendian - set the stored local machine endian order
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @endian: non zero, if the local host has big endian order
  *
  * This sets the endian order for the local machine.
  */
-void tep_set_local_bigendian(struct tep_handle *pevent, enum tep_endian endian)
+void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian)
 {
-	if (pevent)
-		pevent->host_bigendian = endian;
+	if (tep)
+		tep->host_bigendian = endian;
 }
 
 /**
  * tep_is_latency_format - get if the latency output format is configured
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns true if the latency output format is configured
- * If @pevent is NULL, false is returned.
+ * If @tep is NULL, false is returned.
  */
-bool tep_is_latency_format(struct tep_handle *pevent)
+bool tep_is_latency_format(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->latency_format;
+	if (tep)
+		return (tep->latency_format);
 	return false;
 }
 
 /**
  * tep_set_latency_format - set the latency output format
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @lat: non zero for latency output format
  *
  * This sets the latency output format
   */
-void tep_set_latency_format(struct tep_handle *pevent, int lat)
+void tep_set_latency_format(struct tep_handle *tep, int lat)
 {
-	if (pevent)
-		pevent->latency_format = lat;
+	if (tep)
+		tep->latency_format = lat;
 }
 
 /**
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index c5c8eb4..6e16cdb 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -94,8 +94,8 @@ struct tep_handle {
 void tep_free_event(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
 
-unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data);
-unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
-unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long long data);
+unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
+unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
+unsigned long long tep_data2host8(struct tep_handle *tep, unsigned long long data);
 
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 969f259..4fa638f 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -200,13 +200,13 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)
 
 /**
  * tep_is_pid_registered - return if a pid has a cmdline registered
- * @pevent: a handle to the trace event parser context
+ * @tep: a handle to the trace event parser context
  * @pid: The pid to check if it has a cmdline registered with.
  *
  * Returns true if the pid has a cmdline mapped to it
  * false otherwise.
  */
-bool tep_is_pid_registered(struct tep_handle *pevent, int pid)
+bool tep_is_pid_registered(struct tep_handle *tep, int pid)
 {
 	const struct tep_cmdline *comm;
 	struct tep_cmdline key;
@@ -214,13 +214,13 @@ bool tep_is_pid_registered(struct tep_handle *pevent, int pid)
 	if (!pid)
 		return true;
 
-	if (!pevent->cmdlines && cmdline_init(pevent))
+	if (!tep->cmdlines && cmdline_init(tep))
 		return false;
 
 	key.pid = pid;
 
-	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
-		       sizeof(*pevent->cmdlines), cmdline_cmp);
+	comm = bsearch(&key, tep->cmdlines, tep->cmdline_count,
+		       sizeof(*tep->cmdlines), cmdline_cmp);
 
 	if (comm)
 		return true;
@@ -288,13 +288,13 @@ static int add_new_comm(struct tep_handle *pevent,
 	return 0;
 }
 
-static int _tep_register_comm(struct tep_handle *pevent,
+static int _tep_register_comm(struct tep_handle *tep,
 			      const char *comm, int pid, bool override)
 {
 	struct cmdline_list *item;
 
-	if (pevent->cmdlines)
-		return add_new_comm(pevent, comm, pid, override);
+	if (tep->cmdlines)
+		return add_new_comm(tep, comm, pid, override);
 
 	item = malloc(sizeof(*item));
 	if (!item)
@@ -309,17 +309,17 @@ static int _tep_register_comm(struct tep_handle *pevent,
 		return -1;
 	}
 	item->pid = pid;
-	item->next = pevent->cmdlist;
+	item->next = tep->cmdlist;
 
-	pevent->cmdlist = item;
-	pevent->cmdline_count++;
+	tep->cmdlist = item;
+	tep->cmdline_count++;
 
 	return 0;
 }
 
 /**
  * tep_register_comm - register a pid / comm mapping
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @comm: the command line to register
  * @pid: the pid to map the command line to
  *
@@ -327,14 +327,14 @@ static int _tep_register_comm(struct tep_handle *pevent,
  * a given pid. The comm is duplicated. If a command with the same pid
  * already exist, -1 is returned and errno is set to EEXIST
  */
-int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
+int tep_register_comm(struct tep_handle *tep, const char *comm, int pid)
 {
-	return _tep_register_comm(pevent, comm, pid, false);
+	return _tep_register_comm(tep, comm, pid, false);
 }
 
 /**
  * tep_override_comm - register a pid / comm mapping
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @comm: the command line to register
  * @pid: the pid to map the command line to
  *
@@ -342,19 +342,19 @@ int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
  * a given pid. The comm is duplicated. If a command with the same pid
  * already exist, the command string is udapted with the new one
  */
-int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid)
+int tep_override_comm(struct tep_handle *tep, const char *comm, int pid)
 {
-	if (!pevent->cmdlines && cmdline_init(pevent)) {
+	if (!tep->cmdlines && cmdline_init(tep)) {
 		errno = ENOMEM;
 		return -1;
 	}
-	return _tep_register_comm(pevent, comm, pid, true);
+	return _tep_register_comm(tep, comm, pid, true);
 }
 
-int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
+int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock)
 {
-	pevent->trace_clock = strdup(trace_clock);
-	if (!pevent->trace_clock) {
+	tep->trace_clock = strdup(trace_clock);
+	if (!tep->trace_clock) {
 		errno = ENOMEM;
 		return -1;
 	}
@@ -472,15 +472,14 @@ struct func_resolver {
 
 /**
  * tep_set_function_resolver - set an alternative function resolver
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @resolver: function to be used
  * @priv: resolver function private state.
  *
  * Some tools may have already a way to resolve kernel functions, allow them to
- * keep using it instead of duplicating all the entries inside
- * pevent->funclist.
+ * keep using it instead of duplicating all the entries inside tep->funclist.
  */
-int tep_set_function_resolver(struct tep_handle *pevent,
+int tep_set_function_resolver(struct tep_handle *tep,
 			      tep_func_resolver_t *func, void *priv)
 {
 	struct func_resolver *resolver = malloc(sizeof(*resolver));
@@ -491,23 +490,23 @@ int tep_set_function_resolver(struct tep_handle *pevent,
 	resolver->func = func;
 	resolver->priv = priv;
 
-	free(pevent->func_resolver);
-	pevent->func_resolver = resolver;
+	free(tep->func_resolver);
+	tep->func_resolver = resolver;
 
 	return 0;
 }
 
 /**
  * tep_reset_function_resolver - reset alternative function resolver
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  *
  * Stop using whatever alternative resolver was set, use the default
  * one instead.
  */
-void tep_reset_function_resolver(struct tep_handle *pevent)
+void tep_reset_function_resolver(struct tep_handle *tep)
 {
-	free(pevent->func_resolver);
-	pevent->func_resolver = NULL;
+	free(tep->func_resolver);
+	tep->func_resolver = NULL;
 }
 
 static struct func_map *
@@ -531,18 +530,18 @@ find_func(struct tep_handle *pevent, unsigned long long addr)
 
 /**
  * tep_find_function - find a function by a given address
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @addr: the address to find the function with
  *
  * Returns a pointer to the function stored that has the given
  * address. Note, the address does not have to be exact, it
  * will select the function that would contain the address.
  */
-const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr)
+const char *tep_find_function(struct tep_handle *tep, unsigned long long addr)
 {
 	struct func_map *map;
 
-	map = find_func(pevent, addr);
+	map = find_func(tep, addr);
 	if (!map)
 		return NULL;
 
@@ -551,7 +550,7 @@ const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr
 
 /**
  * tep_find_function_address - find a function address by a given address
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @addr: the address to find the function with
  *
  * Returns the address the function starts at. This can be used in
@@ -559,11 +558,11 @@ const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr
  * name and the function offset.
  */
 unsigned long long
-tep_find_function_address(struct tep_handle *pevent, unsigned long long addr)
+tep_find_function_address(struct tep_handle *tep, unsigned long long addr)
 {
 	struct func_map *map;
 
-	map = find_func(pevent, addr);
+	map = find_func(tep, addr);
 	if (!map)
 		return 0;
 
@@ -572,7 +571,7 @@ tep_find_function_address(struct tep_handle *pevent, unsigned long long addr)
 
 /**
  * tep_register_function - register a function with a given address
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @function: the function name to register
  * @addr: the address the function starts at
  * @mod: the kernel module the function may be in (NULL for none)
@@ -580,7 +579,7 @@ tep_find_function_address(struct tep_handle *pevent, unsigned long long addr)
  * This registers a function name with an address and module.
  * The @func passed in is duplicated.
  */
-int tep_register_function(struct tep_handle *pevent, char *func,
+int tep_register_function(struct tep_handle *tep, char *func,
 			  unsigned long long addr, char *mod)
 {
 	struct func_list *item = malloc(sizeof(*item));
@@ -588,7 +587,7 @@ int tep_register_function(struct tep_handle *pevent, char *func,
 	if (!item)
 		return -1;
 
-	item->next = pevent->funclist;
+	item->next = tep->funclist;
 	item->func = strdup(func);
 	if (!item->func)
 		goto out_free;
@@ -601,8 +600,8 @@ int tep_register_function(struct tep_handle *pevent, char *func,
 		item->mod = NULL;
 	item->addr = addr;
 
-	pevent->funclist = item;
-	pevent->func_count++;
+	tep->funclist = item;
+	tep->func_count++;
 
 	return 0;
 
@@ -617,23 +616,23 @@ out_free:
 
 /**
  * tep_print_funcs - print out the stored functions
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  *
  * This prints out the stored functions.
  */
-void tep_print_funcs(struct tep_handle *pevent)
+void tep_print_funcs(struct tep_handle *tep)
 {
 	int i;
 
-	if (!pevent->func_map)
-		func_map_init(pevent);
+	if (!tep->func_map)
+		func_map_init(tep);
 
-	for (i = 0; i < (int)pevent->func_count; i++) {
+	for (i = 0; i < (int)tep->func_count; i++) {
 		printf("%016llx %s",
-		       pevent->func_map[i].addr,
-		       pevent->func_map[i].func);
-		if (pevent->func_map[i].mod)
-			printf(" [%s]\n", pevent->func_map[i].mod);
+		       tep->func_map[i].addr,
+		       tep->func_map[i].func);
+		if (tep->func_map[i].mod)
+			printf(" [%s]\n", tep->func_map[i].mod);
 		else
 			printf("\n");
 	}
@@ -713,14 +712,14 @@ find_printk(struct tep_handle *pevent, unsigned long long addr)
 
 /**
  * tep_register_print_string - register a string by its address
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @fmt: the string format to register
  * @addr: the address the string was located at
  *
  * This registers a string by the address it was stored in the kernel.
  * The @fmt passed in is duplicated.
  */
-int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
+int tep_register_print_string(struct tep_handle *tep, const char *fmt,
 			      unsigned long long addr)
 {
 	struct printk_list *item = malloc(sizeof(*item));
@@ -729,7 +728,7 @@ int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 	if (!item)
 		return -1;
 
-	item->next = pevent->printklist;
+	item->next = tep->printklist;
 	item->addr = addr;
 
 	/* Strip off quotes and '\n' from the end */
@@ -747,8 +746,8 @@ int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 	if (strcmp(p, "\\n") == 0)
 		*p = 0;
 
-	pevent->printklist = item;
-	pevent->printk_count++;
+	tep->printklist = item;
+	tep->printk_count++;
 
 	return 0;
 
@@ -760,21 +759,21 @@ out_free:
 
 /**
  * tep_print_printk - print out the stored strings
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  *
  * This prints the string formats that were stored.
  */
-void tep_print_printk(struct tep_handle *pevent)
+void tep_print_printk(struct tep_handle *tep)
 {
 	int i;
 
-	if (!pevent->printk_map)
-		printk_map_init(pevent);
+	if (!tep->printk_map)
+		printk_map_init(tep);
 
-	for (i = 0; i < (int)pevent->printk_count; i++) {
+	for (i = 0; i < (int)tep->printk_count; i++) {
 		printf("%016llx %s\n",
-		       pevent->printk_map[i].addr,
-		       pevent->printk_map[i].printk);
+		       tep->printk_map[i].addr,
+		       tep->printk_map[i].printk);
 	}
 }
 
@@ -1184,7 +1183,7 @@ static enum tep_event_type read_token(char **tok)
 }
 
 /**
- * tep_read_token - access to utilities to use the pevent parser
+ * tep_read_token - access to utilities to use the tep parser
  * @tok: The token to return
  *
  * This will parse tokens from the string given by
@@ -3357,14 +3356,14 @@ tep_find_any_field(struct tep_event *event, const char *name)
 
 /**
  * tep_read_number - read a number from data
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @ptr: the raw data
  * @size: the size of the data that holds the number
  *
  * Returns the number (converted to host) from the
  * raw data.
  */
-unsigned long long tep_read_number(struct tep_handle *pevent,
+unsigned long long tep_read_number(struct tep_handle *tep,
 				   const void *ptr, int size)
 {
 	unsigned long long val;
@@ -3373,12 +3372,12 @@ unsigned long long tep_read_number(struct tep_handle *pevent,
 	case 1:
 		return *(unsigned char *)ptr;
 	case 2:
-		return tep_data2host2(pevent, *(unsigned short *)ptr);
+		return tep_data2host2(tep, *(unsigned short *)ptr);
 	case 4:
-		return tep_data2host4(pevent, *(unsigned int *)ptr);
+		return tep_data2host4(tep, *(unsigned int *)ptr);
 	case 8:
 		memcpy(&val, (ptr), sizeof(unsigned long long));
-		return tep_data2host8(pevent, val);
+		return tep_data2host8(tep, val);
 	default:
 		/* BUG! */
 		return 0;
@@ -3499,28 +3498,28 @@ static int events_id_cmp(const void *a, const void *b);
 
 /**
  * tep_find_event - find an event by given id
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @id: the id of the event
  *
  * Returns an event that has a given @id.
  */
-struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
+struct tep_event *tep_find_event(struct tep_handle *tep, int id)
 {
 	struct tep_event **eventptr;
 	struct tep_event key;
 	struct tep_event *pkey = &key;
 
 	/* Check cache first */
-	if (pevent->last_event && pevent->last_event->id == id)
-		return pevent->last_event;
+	if (tep->last_event && tep->last_event->id == id)
+		return tep->last_event;
 
 	key.id = id;
 
-	eventptr = bsearch(&pkey, pevent->events, pevent->nr_events,
-			   sizeof(*pevent->events), events_id_cmp);
+	eventptr = bsearch(&pkey, tep->events, tep->nr_events,
+			   sizeof(*tep->events), events_id_cmp);
 
 	if (eventptr) {
-		pevent->last_event = *eventptr;
+		tep->last_event = *eventptr;
 		return *eventptr;
 	}
 
@@ -3529,7 +3528,7 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
 
 /**
  * tep_find_event_by_name - find an event by given name
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @sys: the system name to search for
  * @name: the name of the event to search for
  *
@@ -3537,19 +3536,19 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
  * @sys. If @sys is NULL the first event with @name is returned.
  */
 struct tep_event *
-tep_find_event_by_name(struct tep_handle *pevent,
+tep_find_event_by_name(struct tep_handle *tep,
 		       const char *sys, const char *name)
 {
 	struct tep_event *event = NULL;
 	int i;
 
-	if (pevent->last_event &&
-	    strcmp(pevent->last_event->name, name) == 0 &&
-	    (!sys || strcmp(pevent->last_event->system, sys) == 0))
-		return pevent->last_event;
+	if (tep->last_event &&
+	    strcmp(tep->last_event->name, name) == 0 &&
+	    (!sys || strcmp(tep->last_event->system, sys) == 0))
+		return tep->last_event;
 
-	for (i = 0; i < pevent->nr_events; i++) {
-		event = pevent->events[i];
+	for (i = 0; i < tep->nr_events; i++) {
+		event = tep->events[i];
 		if (strcmp(event->name, name) == 0) {
 			if (!sys)
 				break;
@@ -3557,10 +3556,10 @@ tep_find_event_by_name(struct tep_handle *pevent,
 				break;
 		}
 	}
-	if (i == pevent->nr_events)
+	if (i == tep->nr_events)
 		event = NULL;
 
-	pevent->last_event = event;
+	tep->last_event = event;
 	return event;
 }
 
@@ -5173,7 +5172,7 @@ out_failed:
 
 /**
  * tep_data_latency_format - parse the data for the latency format
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
  * @record: the record to read from
  *
@@ -5181,7 +5180,7 @@ out_failed:
  * need rescheduling, in hard/soft interrupt, preempt count
  * and lock depth) and places it into the trace_seq.
  */
-void tep_data_latency_format(struct tep_handle *pevent,
+void tep_data_latency_format(struct tep_handle *tep,
 			     struct trace_seq *s, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
@@ -5196,13 +5195,13 @@ void tep_data_latency_format(struct tep_handle *pevent,
 	int softirq;
 	void *data = record->data;
 
-	lat_flags = parse_common_flags(pevent, data);
-	pc = parse_common_pc(pevent, data);
+	lat_flags = parse_common_flags(tep, data);
+	pc = parse_common_pc(tep, data);
 	/* lock_depth may not always exist */
 	if (lock_depth_exists)
-		lock_depth = parse_common_lock_depth(pevent, data);
+		lock_depth = parse_common_lock_depth(tep, data);
 	else if (check_lock_depth) {
-		lock_depth = parse_common_lock_depth(pevent, data);
+		lock_depth = parse_common_lock_depth(tep, data);
 		if (lock_depth < 0)
 			check_lock_depth = 0;
 		else
@@ -5211,9 +5210,9 @@ void tep_data_latency_format(struct tep_handle *pevent,
 
 	/* migrate_disable may not always exist */
 	if (migrate_disable_exists)
-		migrate_disable = parse_common_migrate_disable(pevent, data);
+		migrate_disable = parse_common_migrate_disable(tep, data);
 	else if (check_migrate_disable) {
-		migrate_disable = parse_common_migrate_disable(pevent, data);
+		migrate_disable = parse_common_migrate_disable(tep, data);
 		if (migrate_disable < 0)
 			check_migrate_disable = 0;
 		else
@@ -5256,67 +5255,67 @@ void tep_data_latency_format(struct tep_handle *pevent,
 
 /**
  * tep_data_type - parse out the given event type
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @rec: the record to read from
  *
  * This returns the event id from the @rec.
  */
-int tep_data_type(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_type(struct tep_handle *tep, struct tep_record *rec)
 {
-	return trace_parse_common_type(pevent, rec->data);
+	return trace_parse_common_type(tep, rec->data);
 }
 
 /**
  * tep_data_pid - parse the PID from record
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @rec: the record to parse
  *
  * This returns the PID from a record.
  */
-int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_pid(struct tep_handle *tep, struct tep_record *rec)
 {
-	return parse_common_pid(pevent, rec->data);
+	return parse_common_pid(tep, rec->data);
 }
 
 /**
  * tep_data_preempt_count - parse the preempt count from the record
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @rec: the record to parse
  *
  * This returns the preempt count from a record.
  */
-int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_preempt_count(struct tep_handle *tep, struct tep_record *rec)
 {
-	return parse_common_pc(pevent, rec->data);
+	return parse_common_pc(tep, rec->data);
 }
 
 /**
  * tep_data_flags - parse the latency flags from the record
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @rec: the record to parse
  *
  * This returns the latency flags from a record.
  *
  *  Use trace_flag_type enum for the flags (see event-parse.h).
  */
-int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_flags(struct tep_handle *tep, struct tep_record *rec)
 {
-	return parse_common_flags(pevent, rec->data);
+	return parse_common_flags(tep, rec->data);
 }
 
 /**
  * tep_data_comm_from_pid - return the command line from PID
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @pid: the PID of the task to search for
  *
  * This returns a pointer to the command line that has the given
  * @pid.
  */
-const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid)
+const char *tep_data_comm_from_pid(struct tep_handle *tep, int pid)
 {
 	const char *comm;
 
-	comm = find_cmdline(pevent, pid);
+	comm = find_cmdline(tep, pid);
 	return comm;
 }
 
@@ -5338,7 +5337,7 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct tep_cmdline
 
 /**
  * tep_data_pid_from_comm - return the pid from a given comm
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @comm: the cmdline to find the pid from
  * @next: the cmdline structure to find the next comm
  *
@@ -5349,7 +5348,7 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct tep_cmdline
  * next pid.
  * Also, it does a linear search, so it may be slow.
  */
-struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *tep, const char *comm,
 					   struct tep_cmdline *next)
 {
 	struct tep_cmdline *cmdline;
@@ -5358,25 +5357,25 @@ struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char
 	 * If the cmdlines have not been converted yet, then use
 	 * the list.
 	 */
-	if (!pevent->cmdlines)
-		return pid_from_cmdlist(pevent, comm, next);
+	if (!tep->cmdlines)
+		return pid_from_cmdlist(tep, comm, next);
 
 	if (next) {
 		/*
 		 * The next pointer could have been still from
 		 * a previous call before cmdlines were created
 		 */
-		if (next < pevent->cmdlines ||
-		    next >= pevent->cmdlines + pevent->cmdline_count)
+		if (next < tep->cmdlines ||
+		    next >= tep->cmdlines + tep->cmdline_count)
 			next = NULL;
 		else
 			cmdline  = next++;
 	}
 
 	if (!next)
-		cmdline = pevent->cmdlines;
+		cmdline = tep->cmdlines;
 
-	while (cmdline < pevent->cmdlines + pevent->cmdline_count) {
+	while (cmdline < tep->cmdlines + tep->cmdline_count) {
 		if (strcmp(cmdline->comm, comm) == 0)
 			return cmdline;
 		cmdline++;
@@ -5386,12 +5385,13 @@ struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char
 
 /**
  * tep_cmdline_pid - return the pid associated to a given cmdline
+ * @tep: a handle to the trace event parser context
  * @cmdline: The cmdline structure to get the pid from
  *
  * Returns the pid for a give cmdline. If @cmdline is NULL, then
  * -1 is returned.
  */
-int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline)
+int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)cmdline;
 
@@ -5402,9 +5402,9 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline)
 	 * If cmdlines have not been created yet, or cmdline is
 	 * not part of the array, then treat it as a cmdlist instead.
 	 */
-	if (!pevent->cmdlines ||
-	    cmdline < pevent->cmdlines ||
-	    cmdline >= pevent->cmdlines + pevent->cmdline_count)
+	if (!tep->cmdlines ||
+	    cmdline < tep->cmdlines ||
+	    cmdline >= tep->cmdlines + tep->cmdline_count)
 		return cmdlist->pid;
 
 	return cmdline->pid;
@@ -5455,14 +5455,14 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
 
 /**
  * tep_find_event_by_record - return the event from a given record
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @record: The record to get the event from
  *
  * Returns the associated event for a given record, or NULL if non is
  * is found.
  */
 struct tep_event *
-tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
+tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record)
 {
 	int type;
 
@@ -5471,21 +5471,21 @@ tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
 		return NULL;
 	}
 
-	type = trace_parse_common_type(pevent, record->data);
+	type = trace_parse_common_type(tep, record->data);
 
-	return tep_find_event(pevent, type);
+	return tep_find_event(tep, type);
 }
 
 /**
  * tep_print_event_task - Write the event task comm, pid and CPU
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
  * @record: The record to get the event from
  *
  * Writes the tasks comm, pid and CPU to @s.
  */
-void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record)
 {
@@ -5493,27 +5493,26 @@ void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 	const char *comm;
 	int pid;
 
-	pid = parse_common_pid(pevent, data);
-	comm = find_cmdline(pevent, pid);
+	pid = parse_common_pid(tep, data);
+	comm = find_cmdline(tep, pid);
 
-	if (pevent->latency_format) {
-		trace_seq_printf(s, "%8.8s-%-5d %3d",
-		       comm, pid, record->cpu);
-	} else
+	if (tep->latency_format)
+		trace_seq_printf(s, "%8.8s-%-5d %3d", comm, pid, record->cpu);
+	else
 		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
 }
 
 /**
  * tep_print_event_time - Write the event timestamp
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
  * @record: The record to get the event from
- * @use_trace_clock: Set to parse according to the @pevent->trace_clock
+ * @use_trace_clock: Set to parse according to the @tep->trace_clock
  *
  * Writes the timestamp of the record into @s.
  */
-void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record,
 			  bool use_trace_clock)
@@ -5524,19 +5523,18 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 	int p;
 	bool use_usec_format;
 
-	use_usec_format = is_timestamp_in_us(pevent->trace_clock,
-							use_trace_clock);
+	use_usec_format = is_timestamp_in_us(tep->trace_clock, use_trace_clock);
 	if (use_usec_format) {
 		secs = record->ts / NSEC_PER_SEC;
 		nsecs = record->ts - secs * NSEC_PER_SEC;
 	}
 
-	if (pevent->latency_format) {
-		tep_data_latency_format(pevent, s, record);
+	if (tep->latency_format) {
+		tep_data_latency_format(tep, s, record);
 	}
 
 	if (use_usec_format) {
-		if (pevent->flags & TEP_NSEC_OUTPUT) {
+		if (tep->flags & TEP_NSEC_OUTPUT) {
 			usecs = nsecs;
 			p = 9;
 		} else {
@@ -5556,14 +5554,14 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 
 /**
  * tep_print_event_data - Write the event data section
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
  * @record: The record to get the event from
  *
  * Writes the parsing of the record's data to @s.
  */
-void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_data(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record)
 {
@@ -5580,15 +5578,15 @@ void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 	tep_event_info(s, event, record);
 }
 
-void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock)
 {
 	struct tep_event *event;
 
-	event = tep_find_event_by_record(pevent, record);
+	event = tep_find_event_by_record(tep, record);
 	if (!event) {
 		int i;
-		int type = trace_parse_common_type(pevent, record->data);
+		int type = trace_parse_common_type(tep, record->data);
 
 		do_warning("ug! no event found for type %d", type);
 		trace_seq_printf(s, "[UNKNOWN TYPE %d]", type);
@@ -5598,9 +5596,9 @@ void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		return;
 	}
 
-	tep_print_event_task(pevent, s, event, record);
-	tep_print_event_time(pevent, s, event, record, use_trace_clock);
-	tep_print_event_data(pevent, s, event, record);
+	tep_print_event_task(tep, s, event, record);
+	tep_print_event_time(tep, s, event, record, use_trace_clock);
+	tep_print_event_data(tep, s, event, record);
 }
 
 static int events_id_cmp(const void *a, const void *b)
@@ -6017,7 +6015,7 @@ static void parse_header_field(const char *field,
 
 /**
  * tep_parse_header_page - parse the data stored in the header page
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @buf: the buffer storing the header page format string
  * @size: the size of @buf
  * @long_size: the long size to use if there is no header
@@ -6027,7 +6025,7 @@ static void parse_header_field(const char *field,
  *
  * /sys/kernel/debug/tracing/events/header_page
  */
-int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
+int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 			  int long_size)
 {
 	int ignore;
@@ -6037,22 +6035,22 @@ int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long si
 		 * Old kernels did not have header page info.
 		 * Sorry but we just use what we find here in user space.
 		 */
-		pevent->header_page_ts_size = sizeof(long long);
-		pevent->header_page_size_size = long_size;
-		pevent->header_page_data_offset = sizeof(long long) + long_size;
-		pevent->old_format = 1;
+		tep->header_page_ts_size = sizeof(long long);
+		tep->header_page_size_size = long_size;
+		tep->header_page_data_offset = sizeof(long long) + long_size;
+		tep->old_format = 1;
 		return -1;
 	}
 	init_input_buf(buf, size);
 
-	parse_header_field("timestamp", &pevent->header_page_ts_offset,
-			   &pevent->header_page_ts_size, 1);
-	parse_header_field("commit", &pevent->header_page_size_offset,
-			   &pevent->header_page_size_size, 1);
-	parse_header_field("overwrite", &pevent->header_page_overwrite,
+	parse_header_field("timestamp", &tep->header_page_ts_offset,
+			   &tep->header_page_ts_size, 1);
+	parse_header_field("commit", &tep->header_page_size_offset,
+			   &tep->header_page_size_size, 1);
+	parse_header_field("overwrite", &tep->header_page_overwrite,
 			   &ignore, 0);
-	parse_header_field("data", &pevent->header_page_data_offset,
-			   &pevent->header_page_data_size, 1);
+	parse_header_field("data", &tep->header_page_data_offset,
+			   &tep->header_page_data_size, 1);
 
 	return 0;
 }
@@ -6258,7 +6256,7 @@ event_add_failed:
 
 /**
  * tep_parse_format - parse the event format
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @eventp: returned format
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
@@ -6271,17 +6269,17 @@ event_add_failed:
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno tep_parse_format(struct tep_handle *pevent,
+enum tep_errno tep_parse_format(struct tep_handle *tep,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys)
 {
-	return __parse_event(pevent, eventp, buf, size, sys);
+	return __parse_event(tep, eventp, buf, size, sys);
 }
 
 /**
  * tep_parse_event - parse the event format
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
  * @sys: the system the event belongs to
@@ -6293,11 +6291,11 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
+enum tep_errno tep_parse_event(struct tep_handle *tep, const char *buf,
 			       unsigned long size, const char *sys)
 {
 	struct tep_event *event = NULL;
-	return __parse_event(pevent, &event, buf, size, sys);
+	return __parse_event(tep, &event, buf, size, sys);
 }
 
 int get_field_val(struct trace_seq *s, struct tep_format_field *field,
@@ -6537,7 +6535,7 @@ static void free_func_handle(struct tep_function_handler *func)
 
 /**
  * tep_register_print_function - register a helper function
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @func: the function to process the helper function
  * @ret_type: the return type of the helper function
  * @name: the name of the helper function
@@ -6550,7 +6548,7 @@ static void free_func_handle(struct tep_function_handler *func)
  * The @parameters is a variable list of tep_func_arg_type enums that
  * must end with TEP_FUNC_ARG_VOID.
  */
-int tep_register_print_function(struct tep_handle *pevent,
+int tep_register_print_function(struct tep_handle *tep,
 				tep_func_handler func,
 				enum tep_func_arg_type ret_type,
 				char *name, ...)
@@ -6562,7 +6560,7 @@ int tep_register_print_function(struct tep_handle *pevent,
 	va_list ap;
 	int ret;
 
-	func_handle = find_func_handler(pevent, name);
+	func_handle = find_func_handler(tep, name);
 	if (func_handle) {
 		/*
 		 * This is most like caused by the users own
@@ -6570,7 +6568,7 @@ int tep_register_print_function(struct tep_handle *pevent,
 		 * system defaults.
 		 */
 		pr_stat("override of function helper '%s'", name);
-		remove_func_handler(pevent, name);
+		remove_func_handler(tep, name);
 	}
 
 	func_handle = calloc(1, sizeof(*func_handle));
@@ -6617,8 +6615,8 @@ int tep_register_print_function(struct tep_handle *pevent,
 	}
 	va_end(ap);
 
-	func_handle->next = pevent->func_handlers;
-	pevent->func_handlers = func_handle;
+	func_handle->next = tep->func_handlers;
+	tep->func_handlers = func_handle;
 
 	return 0;
  out_free:
@@ -6629,7 +6627,7 @@ int tep_register_print_function(struct tep_handle *pevent,
 
 /**
  * tep_unregister_print_function - unregister a helper function
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @func: the function to process the helper function
  * @name: the name of the helper function
  *
@@ -6637,14 +6635,14 @@ int tep_register_print_function(struct tep_handle *pevent,
  *
  * Returns 0 if the handler was removed successully, -1 otherwise.
  */
-int tep_unregister_print_function(struct tep_handle *pevent,
+int tep_unregister_print_function(struct tep_handle *tep,
 				  tep_func_handler func, char *name)
 {
 	struct tep_function_handler *func_handle;
 
-	func_handle = find_func_handler(pevent, name);
+	func_handle = find_func_handler(tep, name);
 	if (func_handle && func_handle->func == func) {
-		remove_func_handler(pevent, name);
+		remove_func_handler(tep, name);
 		return 0;
 	}
 	return -1;
@@ -6675,7 +6673,7 @@ static struct tep_event *search_event(struct tep_handle *pevent, int id,
 
 /**
  * tep_register_event_handler - register a way to parse an event
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @id: the id of the event to register
  * @sys_name: the system name the event belongs to
  * @event_name: the name of the event
@@ -6696,14 +6694,14 @@ static struct tep_event *search_event(struct tep_handle *pevent, int id,
  *  negative TEP_ERRNO_... in case of an error
  *
  */
-int tep_register_event_handler(struct tep_handle *pevent, int id,
+int tep_register_event_handler(struct tep_handle *tep, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context)
 {
 	struct tep_event *event;
 	struct event_handler *handle;
 
-	event = search_event(pevent, id, sys_name, event_name);
+	event = search_event(tep, id, sys_name, event_name);
 	if (event == NULL)
 		goto not_found;
 
@@ -6738,8 +6736,8 @@ int tep_register_event_handler(struct tep_handle *pevent, int id,
 	}
 
 	handle->func = func;
-	handle->next = pevent->handlers;
-	pevent->handlers = handle;
+	handle->next = tep->handlers;
+	tep->handlers = handle;
 	handle->context = context;
 
 	return TEP_REGISTER_SUCCESS;
@@ -6766,7 +6764,7 @@ static int handle_matches(struct event_handler *handler, int id,
 
 /**
  * tep_unregister_event_handler - unregister an existing event handler
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @id: the id of the event to unregister
  * @sys_name: the system name the handler belongs to
  * @event_name: the name of the event handler
@@ -6780,7 +6778,7 @@ static int handle_matches(struct event_handler *handler, int id,
  *
  * Returns 0 if handler was removed successfully, -1 if event was not found.
  */
-int tep_unregister_event_handler(struct tep_handle *pevent, int id,
+int tep_unregister_event_handler(struct tep_handle *tep, int id,
 				 const char *sys_name, const char *event_name,
 				 tep_event_handler_func func, void *context)
 {
@@ -6788,7 +6786,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 	struct event_handler *handle;
 	struct event_handler **next;
 
-	event = search_event(pevent, id, sys_name, event_name);
+	event = search_event(tep, id, sys_name, event_name);
 	if (event == NULL)
 		goto not_found;
 
@@ -6802,7 +6800,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 	}
 
 not_found:
-	for (next = &pevent->handlers; *next; next = &(*next)->next) {
+	for (next = &tep->handlers; *next; next = &(*next)->next) {
 		handle = *next;
 		if (handle_matches(handle, id, sys_name, event_name,
 				   func, context))
@@ -6819,7 +6817,7 @@ not_found:
 }
 
 /**
- * tep_alloc - create a pevent handle
+ * tep_alloc - create a tep handle
  */
 struct tep_handle *tep_alloc(void)
 {
@@ -6833,9 +6831,9 @@ struct tep_handle *tep_alloc(void)
 	return pevent;
 }
 
-void tep_ref(struct tep_handle *pevent)
+void tep_ref(struct tep_handle *tep)
 {
-	pevent->ref_count++;
+	tep->ref_count++;
 }
 
 int tep_get_ref(struct tep_handle *tep)
@@ -6885,10 +6883,10 @@ void tep_free_event(struct tep_event *event)
 }
 
 /**
- * tep_free - free a pevent handle
- * @pevent: the pevent handle to free
+ * tep_free - free a tep handle
+ * @tep: the tep handle to free
  */
-void tep_free(struct tep_handle *pevent)
+void tep_free(struct tep_handle *tep)
 {
 	struct cmdline_list *cmdlist, *cmdnext;
 	struct func_list *funclist, *funcnext;
@@ -6897,21 +6895,21 @@ void tep_free(struct tep_handle *pevent)
 	struct event_handler *handle;
 	int i;
 
-	if (!pevent)
+	if (!tep)
 		return;
 
-	cmdlist = pevent->cmdlist;
-	funclist = pevent->funclist;
-	printklist = pevent->printklist;
+	cmdlist = tep->cmdlist;
+	funclist = tep->funclist;
+	printklist = tep->printklist;
 
-	pevent->ref_count--;
-	if (pevent->ref_count)
+	tep->ref_count--;
+	if (tep->ref_count)
 		return;
 
-	if (pevent->cmdlines) {
-		for (i = 0; i < pevent->cmdline_count; i++)
-			free(pevent->cmdlines[i].comm);
-		free(pevent->cmdlines);
+	if (tep->cmdlines) {
+		for (i = 0; i < tep->cmdline_count; i++)
+			free(tep->cmdlines[i].comm);
+		free(tep->cmdlines);
 	}
 
 	while (cmdlist) {
@@ -6921,12 +6919,12 @@ void tep_free(struct tep_handle *pevent)
 		cmdlist = cmdnext;
 	}
 
-	if (pevent->func_map) {
-		for (i = 0; i < (int)pevent->func_count; i++) {
-			free(pevent->func_map[i].func);
-			free(pevent->func_map[i].mod);
+	if (tep->func_map) {
+		for (i = 0; i < (int)tep->func_count; i++) {
+			free(tep->func_map[i].func);
+			free(tep->func_map[i].mod);
 		}
-		free(pevent->func_map);
+		free(tep->func_map);
 	}
 
 	while (funclist) {
@@ -6937,16 +6935,16 @@ void tep_free(struct tep_handle *pevent)
 		funclist = funcnext;
 	}
 
-	while (pevent->func_handlers) {
-		func_handler = pevent->func_handlers;
-		pevent->func_handlers = func_handler->next;
+	while (tep->func_handlers) {
+		func_handler = tep->func_handlers;
+		tep->func_handlers = func_handler->next;
 		free_func_handle(func_handler);
 	}
 
-	if (pevent->printk_map) {
-		for (i = 0; i < (int)pevent->printk_count; i++)
-			free(pevent->printk_map[i].printk);
-		free(pevent->printk_map);
+	if (tep->printk_map) {
+		for (i = 0; i < (int)tep->printk_count; i++)
+			free(tep->printk_map[i].printk);
+		free(tep->printk_map);
 	}
 
 	while (printklist) {
@@ -6956,24 +6954,24 @@ void tep_free(struct tep_handle *pevent)
 		printklist = printknext;
 	}
 
-	for (i = 0; i < pevent->nr_events; i++)
-		tep_free_event(pevent->events[i]);
+	for (i = 0; i < tep->nr_events; i++)
+		tep_free_event(tep->events[i]);
 
-	while (pevent->handlers) {
-		handle = pevent->handlers;
-		pevent->handlers = handle->next;
+	while (tep->handlers) {
+		handle = tep->handlers;
+		tep->handlers = handle->next;
 		free_handler(handle);
 	}
 
-	free(pevent->trace_clock);
-	free(pevent->events);
-	free(pevent->sort_events);
-	free(pevent->func_resolver);
+	free(tep->trace_clock);
+	free(tep->events);
+	free(tep->sort_events);
+	free(tep->func_resolver);
 
-	free(pevent);
+	free(tep);
 }
 
-void tep_unref(struct tep_handle *pevent)
+void tep_unref(struct tep_handle *tep)
 {
-	tep_free(pevent);
+	tep_free(tep);
 }
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index e74f16c..d0488de 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -419,16 +419,16 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 }
 
 struct tep_plugin_list*
-tep_load_plugins(struct tep_handle *pevent)
+tep_load_plugins(struct tep_handle *tep)
 {
 	struct tep_plugin_list *list = NULL;
 
-	load_plugins(pevent, ".so", load_plugin, &list);
+	load_plugins(tep, ".so", load_plugin, &list);
 	return list;
 }
 
 void
-tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *pevent)
+tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *tep)
 {
 	tep_plugin_unload_func func;
 	struct tep_plugin_list *list;
@@ -438,7 +438,7 @@ tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *peven
 		plugin_list = list->next;
 		func = dlsym(list->handle, TEP_PLUGIN_UNLOADER_NAME);
 		if (func)
-			func(pevent);
+			func(tep);
 		dlclose(list->handle);
 		free(list->name);
 		free(list);
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 3320c0a..5d8f9d9 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -164,9 +164,9 @@ add_filter_type(struct tep_event_filter *filter, int id)
 
 /**
  * tep_filter_alloc - create a new event filter
- * @pevent: The pevent that this filter is associated with
+ * @tep: The tep that this filter is associated with
  */
-struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent)
+struct tep_event_filter *tep_filter_alloc(struct tep_handle *tep)
 {
 	struct tep_event_filter *filter;
 
@@ -175,8 +175,8 @@ struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent)
 		return NULL;
 
 	memset(filter, 0, sizeof(*filter));
-	filter->pevent = pevent;
-	tep_ref(pevent);
+	filter->pevent = tep;
+	tep_ref(tep);
 
 	return filter;
 }
diff --git a/plugins/plugin_cfg80211.c b/plugins/plugin_cfg80211.c
index a51b366..3d43b56 100644
--- a/plugins/plugin_cfg80211.c
+++ b/plugins/plugin_cfg80211.c
@@ -25,9 +25,9 @@ process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
 	return val ? (long long) le16toh(*val) : 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process___le16_to_cpup,
 				    TEP_FUNC_ARG_INT,
 				    "__le16_to_cpup",
@@ -36,8 +36,8 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_print_function(pevent, process___le16_to_cpup,
+	tep_unregister_print_function(tep, process___le16_to_cpup,
 				      "__le16_to_cpup");
 }
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 434a33a..860b7fc 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -169,9 +169,9 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "ftrace", "function",
+	tep_register_event_handler(tep, -1, "ftrace", "function",
 				   function_handler, NULL);
 
 	trace_util_add_options("ftrace", plugin_options);
@@ -179,11 +179,11 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
 	int i, x;
 
-	tep_unregister_event_handler(pevent, -1, "ftrace", "function",
+	tep_unregister_event_handler(tep, -1, "ftrace", "function",
 				     function_handler, NULL);
 
 	for (i = 0; i <= cpus; i++) {
diff --git a/plugins/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
index 67846dc..8d2a421 100644
--- a/plugins/plugin_hrtimer.c
+++ b/plugins/plugin_hrtimer.c
@@ -47,23 +47,24 @@ static int timer_start_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "timer", "hrtimer_expire_entry",
+	tep_register_event_handler(tep, -1,
+				   "timer", "hrtimer_expire_entry",
 				   timer_expire_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "timer", "hrtimer_start",
+	tep_register_event_handler(tep, -1, "timer", "hrtimer_start",
 				   timer_start_handler, NULL);
 
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1,
+	tep_unregister_event_handler(tep, -1,
 				     "timer", "hrtimer_expire_entry",
 				     timer_expire_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "timer", "hrtimer_start",
+	tep_unregister_event_handler(tep, -1, "timer", "hrtimer_start",
 				     timer_start_handler, NULL);
 }
diff --git a/plugins/plugin_jbd2.c b/plugins/plugin_jbd2.c
index 4b230ad..b82bbd8 100644
--- a/plugins/plugin_jbd2.c
+++ b/plugins/plugin_jbd2.c
@@ -35,16 +35,16 @@ process_jiffies_to_msecs(struct trace_seq *s,
 	return jiffies;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_jbd2_dev_to_name,
 				    TEP_FUNC_ARG_STRING,
 				    "jbd2_dev_to_name",
 				    TEP_FUNC_ARG_INT,
 				    TEP_FUNC_ARG_VOID);
 
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_jiffies_to_msecs,
 				    TEP_FUNC_ARG_LONG,
 				    "jiffies_to_msecs",
@@ -53,11 +53,11 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_print_function(pevent, process_jbd2_dev_to_name,
+	tep_unregister_print_function(tep, process_jbd2_dev_to_name,
 				      "jbd2_dev_to_name");
 
-	tep_unregister_print_function(pevent, process_jiffies_to_msecs,
+	tep_unregister_print_function(tep, process_jiffies_to_msecs,
 				      "jiffies_to_msecs");
 }
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index 87c3463..464b184 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -34,47 +34,48 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	return 1;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "kmem", "kfree",
+	tep_register_event_handler(tep, -1, "kmem", "kfree",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmalloc",
+	tep_register_event_handler(tep, -1, "kmem", "kmalloc",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmalloc_node",
+	tep_register_event_handler(tep, -1, "kmem", "kmalloc_node",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+	tep_register_event_handler(tep, -1, "kmem", "kmem_cache_alloc",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc_node",
+	tep_register_event_handler(tep, -1, "kmem",
+				   "kmem_cache_alloc_node",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+	tep_register_event_handler(tep, -1, "kmem", "kmem_cache_free",
 				   call_site_handler, NULL);
 
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1, "kmem", "kfree",
+	tep_unregister_event_handler(tep, -1, "kmem", "kfree",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem", "kmalloc",
+	tep_unregister_event_handler(tep, -1, "kmem", "kmalloc",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem", "kmalloc_node",
+	tep_unregister_event_handler(tep, -1, "kmem", "kmalloc_node",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+	tep_unregister_event_handler(tep, -1, "kmem", "kmem_cache_alloc",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem",
+	tep_unregister_event_handler(tep, -1, "kmem",
 				     "kmem_cache_alloc_node",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+	tep_unregister_event_handler(tep, -1, "kmem", "kmem_cache_free",
 				     call_site_handler, NULL);
 }
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index e23b513..e262aea 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -439,39 +439,40 @@ process_is_writable_pte(struct trace_seq *s, unsigned long long *args)
 	return pte & PT_WRITABLE_MASK;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
 	init_disassembler();
 
-	tep_register_event_handler(pevent, -1, "kvm", "kvm_exit",
+	tep_register_event_handler(tep, -1, "kvm", "kvm_exit",
 				   kvm_exit_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+	tep_register_event_handler(tep, -1, "kvm", "kvm_emulate_insn",
 				   kvm_emulate_insn_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+	tep_register_event_handler(tep, -1, "kvm", "kvm_nested_vmexit",
 				   kvm_nested_vmexit_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+	tep_register_event_handler(tep, -1, "kvm", "kvm_nested_vmexit_inject",
 				   kvm_nested_vmexit_inject_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+	tep_register_event_handler(tep, -1, "kvmmmu", "kvm_mmu_get_page",
 				   kvm_mmu_get_page_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+	tep_register_event_handler(tep, -1, "kvmmmu", "kvm_mmu_sync_page",
 				   kvm_mmu_print_role, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_unsync_page",
+	tep_register_event_handler(tep, -1,
+				   "kvmmmu", "kvm_mmu_unsync_page",
 				   kvm_mmu_print_role, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+	tep_register_event_handler(tep, -1, "kvmmmu", "kvm_mmu_zap_page",
 				   kvm_mmu_print_role, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu",
+	tep_register_event_handler(tep, -1, "kvmmmu",
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_is_writable_pte,
 				    TEP_FUNC_ARG_INT,
 				    "is_writable_pte",
@@ -480,37 +481,37 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_exit",
 				     kvm_exit_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_emulate_insn",
 				     kvm_emulate_insn_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_nested_vmexit",
 				     kvm_nested_vmexit_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_nested_vmexit_inject",
 				     kvm_nested_vmexit_inject_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+	tep_unregister_event_handler(tep, -1, "kvmmmu", "kvm_mmu_get_page",
 				     kvm_mmu_get_page_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+	tep_unregister_event_handler(tep, -1, "kvmmmu", "kvm_mmu_sync_page",
 				     kvm_mmu_print_role, NULL);
 
-	tep_unregister_event_handler(pevent, -1,
+	tep_unregister_event_handler(tep, -1,
 				     "kvmmmu", "kvm_mmu_unsync_page",
 				     kvm_mmu_print_role, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+	tep_unregister_event_handler(tep, -1, "kvmmmu", "kvm_mmu_zap_page",
 				     kvm_mmu_print_role, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvmmmu",
+	tep_unregister_event_handler(tep, -1, "kvmmmu",
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
-	tep_unregister_print_function(pevent, process_is_writable_pte,
+	tep_unregister_print_function(tep, process_is_writable_pte,
 				      "is_writable_pte");
 }
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index 274566e..e270236 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -177,11 +177,11 @@ static int drv_config(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "mac80211", "drv_bss_info_changed",
+	tep_register_event_handler(tep, -1, "mac80211", "drv_bss_info_changed",
 				   drv_bss_info_changed, NULL);
-	tep_register_event_handler(pevent, -1, "mac80211", "drv_config",
+	tep_register_event_handler(tep, -1, "mac80211", "drv_config",
 				   drv_config, NULL);
 
 	return 0;
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 3f85bd5..a3cdc84 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -118,28 +118,28 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "sched", "sched_switch",
+	tep_register_event_handler(tep, -1, "sched", "sched_switch",
 				   sched_switch_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "sched", "sched_wakeup",
+	tep_register_event_handler(tep, -1, "sched", "sched_wakeup",
 				   sched_wakeup_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+	tep_register_event_handler(tep, -1, "sched", "sched_wakeup_new",
 				   sched_wakeup_handler, NULL);
 
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1, "sched", "sched_switch",
+	tep_unregister_event_handler(tep, -1, "sched", "sched_switch",
 				     sched_switch_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "sched", "sched_wakeup",
+	tep_unregister_event_handler(tep, -1, "sched", "sched_wakeup",
 				     sched_wakeup_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+	tep_unregister_event_handler(tep, -1, "sched", "sched_wakeup_new",
 				     sched_wakeup_handler, NULL);
 }
diff --git a/plugins/plugin_scsi.c b/plugins/plugin_scsi.c
index 4eba25c..5d0387a 100644
--- a/plugins/plugin_scsi.c
+++ b/plugins/plugin_scsi.c
@@ -414,9 +414,9 @@ unsigned long long process_scsi_trace_parse_cdb(struct trace_seq *s,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_scsi_trace_parse_cdb,
 				    TEP_FUNC_ARG_STRING,
 				    "scsi_trace_parse_cdb",
@@ -427,8 +427,8 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_print_function(pevent, process_scsi_trace_parse_cdb,
+	tep_unregister_print_function(tep, process_scsi_trace_parse_cdb,
 				      "scsi_trace_parse_cdb");
 }
diff --git a/plugins/plugin_xen.c b/plugins/plugin_xen.c
index bc0496e..993b208 100644
--- a/plugins/plugin_xen.c
+++ b/plugins/plugin_xen.c
@@ -120,9 +120,9 @@ unsigned long long process_xen_hypercall_name(struct trace_seq *s,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_xen_hypercall_name,
 				    TEP_FUNC_ARG_STRING,
 				    "xen_hypercall_name",
@@ -131,8 +131,8 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_print_function(pevent, process_xen_hypercall_name,
+	tep_unregister_print_function(tep, process_xen_hypercall_name,
 				      "xen_hypercall_name");
 }
-- 
2.20.1

