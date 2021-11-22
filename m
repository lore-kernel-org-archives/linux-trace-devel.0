Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADF3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 09:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239081AbhKVJde (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:33:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239109AbhKVJdd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 04:33:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73EB9604DA;
        Mon, 22 Nov 2021 09:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637573425;
        bh=oK7+IXBNcI/tFcAHwiK9ApfSCdreFTSmcVMZdmRBmG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMIw940hjjMpe0+bhZQ6LdgXd5iwAqdSz/99JZ6+0y6BCe8+bEgw4t25o+fvQ5NZs
         LThYQiN2A5omjuFxMzu1F2KkPBMhLLbKqhTegK2+zvk+N/UgFUHcT2m3cZDOhNHPPS
         EH57KDTKI/HloWQ2pDybaSUxdNruFmP6Os86SoKDGf0z7GqlElx9I37dW+l+Kocn8Y
         F7dF9WChKmEWTZW8QhIjVUps2F7efkQvA2+5YEov/8dkFzkWT/Ec1V+4WOapciWXkJ
         beVB2a6u8XVMP/C/yVNl7XApD96YN6LPzxvUcFJBM+kYvaWG6CLqqk1L0QHwBcSpnj
         G3D+ZT49jHYAw==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/5] tracing: Add '__rel_loc' using trace event macros
Date:   Mon, 22 Nov 2021 18:30:21 +0900
Message-Id: <163757342119.510314.816029622439099016.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <163757340321.510314.9399950115238632705.stgit@devnote2>
References: <163757340321.510314.9399950115238632705.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add '__rel_loc' using trace event macros. These macros are usually
not used in the kernel, except for testing purpose.
This also add "rel_" variant of macros for dynamic_array string,
and bitmask.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v2:
  - Add bitmask macros.
---
 include/trace/bpf_probe.h    |   16 ++++++
 include/trace/perf.h         |   16 ++++++
 include/trace/trace_events.h |  120 +++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h         |    3 +
 4 files changed, 153 insertions(+), 2 deletions(-)

diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
index a23be89119aa..04939b2d2f19 100644
--- a/include/trace/bpf_probe.h
+++ b/include/trace/bpf_probe.h
@@ -21,6 +21,22 @@
 #undef __get_bitmask
 #define __get_bitmask(field) (char *)__get_dynamic_array(field)
 
+#undef __get_rel_dynamic_array
+#define __get_rel_dynamic_array(field)	\
+		((void *)(&__entry->__rel_loc_##field) +	\
+		 sizeof(__entry->__rel_loc_##field) +		\
+		 (__entry->__rel_loc_##field & 0xffff))
+
+#undef __get_rel_dynamic_array_len
+#define __get_rel_dynamic_array_len(field)	\
+		((__entry->__rel_loc_##field >> 16) & 0xffff)
+
+#undef __get_rel_str
+#define __get_rel_str(field) ((char *)__get_rel_dynamic_array(field))
+
+#undef __get_rel_bitmask
+#define __get_rel_bitmask(field) (char *)__get_rel_dynamic_array(field)
+
 #undef __perf_count
 #define __perf_count(c)	(c)
 
diff --git a/include/trace/perf.h b/include/trace/perf.h
index dbc6c74defc3..ea4405de175a 100644
--- a/include/trace/perf.h
+++ b/include/trace/perf.h
@@ -21,6 +21,22 @@
 #undef __get_bitmask
 #define __get_bitmask(field) (char *)__get_dynamic_array(field)
 
+#undef __get_rel_dynamic_array
+#define __get_rel_dynamic_array(field)	\
+		((void *)(&__entry->__rel_loc_##field) +	\
+		 sizeof(__entry->__rel_loc_##field) +		\
+		 (__entry->__rel_loc_##field & 0xffff))
+
+#undef __get_rel_dynamic_array_len
+#define __get_rel_dynamic_array_len(field)	\
+		((__entry->__rel_loc_##field >> 16) & 0xffff)
+
+#undef __get_rel_str
+#define __get_rel_str(field) ((char *)__get_rel_dynamic_array(field))
+
+#undef __get_rel_bitmask
+#define __get_rel_bitmask(field) (char *)__get_rel_dynamic_array(field)
+
 #undef __perf_count
 #define __perf_count(c)	(__count = (c))
 
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index 08810a463880..8c6f7c433518 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -108,6 +108,18 @@ TRACE_MAKE_SYSTEM_STR();
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(char, item, -1)
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item, len) u32 __rel_loc_##item;
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(char, item, -1)
+
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
 
@@ -200,11 +212,23 @@ TRACE_MAKE_SYSTEM_STR();
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
+#undef __bitmask
+#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, -1)
 
-#undef __bitmask
-#define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item, len)	u32 item;
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item, -1)
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
@@ -293,6 +317,19 @@ TRACE_MAKE_SYSTEM_STR();
 #undef __get_str
 #define __get_str(field) ((char *)__get_dynamic_array(field))
 
+#undef __get_rel_dynamic_array
+#define __get_rel_dynamic_array(field)	\
+		((void *)(&__entry->__rel_loc_##field) +	\
+		 sizeof(__entry->__rel_loc_##field) +		\
+		 (__entry->__rel_loc_##field & 0xffff))
+
+#undef __get_rel_dynamic_array_len
+#define __get_rel_dynamic_array_len(field)	\
+		((__entry->__rel_loc_##field >> 16) & 0xffff)
+
+#undef __get_rel_str
+#define __get_rel_str(field) ((char *)__get_rel_dynamic_array(field))
+
 #undef __get_bitmask
 #define __get_bitmask(field)						\
 	({								\
@@ -302,6 +339,15 @@ TRACE_MAKE_SYSTEM_STR();
 		trace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
 	})
 
+#undef __get_rel_bitmask
+#define __get_rel_bitmask(field)						\
+	({								\
+		void *__bitmask = __get_rel_dynamic_array(field);		\
+		unsigned int __bitmask_size;				\
+		__bitmask_size = __get_rel_dynamic_array_len(field);	\
+		trace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
+	})
+
 #undef __print_flags
 #define __print_flags(flag, delim, flag_array...)			\
 	({								\
@@ -471,6 +517,21 @@ static struct trace_event_functions trace_event_type_funcs_##call = {	\
 #undef __bitmask
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item, -1)
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(_type, _item, _len) {			\
+	.type = "__rel_loc " #_type "[]", .name = #_item,		\
+	.size = 4, .align = 4,						\
+	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item, -1)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
 static struct trace_event_fields trace_event_fields_##call[] = {	\
@@ -519,6 +580,22 @@ static struct trace_event_fields trace_event_fields_##call[] = {	\
 #undef __string_len
 #define __string_len(item, src, len) __dynamic_array(char, item, (len) + 1)
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item, len)				\
+	__item_length = (len) * sizeof(type);				\
+	__data_offsets->item = __data_size +				\
+			       offsetof(typeof(*entry), __data) -	\
+			       offsetof(typeof(*entry), __rel_loc_##item) -	\
+			       sizeof(u32);				\
+	__data_offsets->item |= __item_length << 16;			\
+	__data_size += __item_length;
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item,			\
+		    strlen((src) ? (const char *)(src) : "(null)") + 1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, (len) + 1)
 /*
  * __bitmask_size_in_bytes_raw is the number of bytes needed to hold
  * num_possible_cpus().
@@ -542,6 +619,10 @@ static struct trace_event_fields trace_event_fields_##call[] = {	\
 #define __bitmask(item, nr_bits) __dynamic_array(unsigned long, item,	\
 					 __bitmask_size_in_longs(nr_bits))
 
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item,	\
+					 __bitmask_size_in_longs(nr_bits))
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static inline notrace int trace_event_get_offsets_##call(		\
@@ -706,6 +787,37 @@ static inline notrace int trace_event_get_offsets_##call(		\
 #define __assign_bitmask(dst, src, nr_bits)					\
 	memcpy(__get_bitmask(dst), (src), __bitmask_size_in_bytes(nr_bits))
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item, len)				\
+	__entry->__rel_loc_##item = __data_offsets.item;
+
+#undef __rel_string
+#define __rel_string(item, src) __rel_dynamic_array(char, item, -1)
+
+#undef __rel_string_len
+#define __rel_string_len(item, src, len) __rel_dynamic_array(char, item, -1)
+
+#undef __assign_rel_str
+#define __assign_rel_str(dst, src)					\
+	strcpy(__get_rel_str(dst), (src) ? (const char *)(src) : "(null)");
+
+#undef __assign_rel_str_len
+#define __assign_rel_str_len(dst, src, len)				\
+	do {								\
+		memcpy(__get_rel_str(dst), (src), (len));		\
+		__get_rel_str(dst)[len] = '\0';				\
+	} while (0)
+
+#undef __rel_bitmask
+#define __rel_bitmask(item, nr_bits) __rel_dynamic_array(unsigned long, item, -1)
+
+#undef __get_rel_bitmask
+#define __get_rel_bitmask(field) (char *)__get_rel_dynamic_array(field)
+
+#undef __assign_rel_bitmask
+#define __assign_rel_bitmask(dst, src, nr_bits)					\
+	memcpy(__get_rel_bitmask(dst), (src), __bitmask_size_in_bytes(nr_bits))
+
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
 
@@ -770,6 +882,10 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __get_dynamic_array_len
 #undef __get_str
 #undef __get_bitmask
+#undef __get_rel_dynamic_array
+#undef __get_rel_dynamic_array_len
+#undef __get_rel_str
+#undef __get_rel_bitmask
 #undef __print_array
 #undef __print_hex_dump
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4fd292c3a062..f80d5612701e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -83,6 +83,9 @@ enum trace_type {
 #undef __dynamic_array
 #define __dynamic_array(type, item)	type	item[];
 
+#undef __rel_dynamic_array
+#define __rel_dynamic_array(type, item)	type	item[];
+
 #undef F_STRUCT
 #define F_STRUCT(args...)		args
 

