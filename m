Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBBBC10F00
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11EE121738
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfC0OTz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:19:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33056 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbfC0OTz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 10:19:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id z6so4964007wmi.0;
        Wed, 27 Mar 2019 07:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BQbVqwfLSedAA+1iq89L/TOBJh3jo67TcOYLzlEPVtQ=;
        b=p/xpzgSgVNcF/zp54xQI/yCqc+QlKhRi2DDPIrZqTbk8gOL84KoNTeChYrrjQ1fqH/
         U8h5MMKAYO6aSHvgWrnlJLSWMCJYl2P6IfqfXy71zUSzrS43v/XxHyg2oiN3Nw4R7uWo
         yuLgsh5rsuwvhJJ9PPuTdSy7xIoplGrvH+py1frEityD9KKNfJer1n1izD+lIFA0gQR6
         WKSyMXaw+2WCH5hSQ2zWU7K/Vpr1RMwMIreAAN1CqgPqhAGt05sk3c26YNRX/hpKvu17
         JZfPSKHH4YMnkkfwxQIS5Im6I2wJictU3izswySZoEipzfEEN01rGEG19yKNQWXK5DTA
         iaFg==
X-Gm-Message-State: APjAAAU3YrnF5XLP2HfeZ+CPQvUCIelVIzO9NlxPmUikXane0T42WN/6
        X2tPIKp0a5T6OSYbyEUQH6k=
X-Google-Smtp-Source: APXvYqzGwRMyGp0uyWR7MGzJcLSun7gA8WXZuRka/rYQiOm0wJYHzhfSTyr6xMxDScfjH+tpnPQsdg==
X-Received: by 2002:a1c:cbc5:: with SMTP id b188mr1878545wmg.87.1553696392229;
        Wed, 27 Mar 2019 07:19:52 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t69sm205022wmt.16.2019.03.27.07.19.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Mar 2019 07:19:51 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] tools/perf,tools/lib/traceevent: Rename "pevent" member of struct tep_event to "tep"
Date:   Wed, 27 Mar 2019 16:19:44 +0200
Message-Id: <20190327141946.4353-4-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190327141946.4353-1-tstoyanov@vmware.com>
References: <20190327141946.4353-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch renames "pevent" member of the struct tep_event to "tep". This makes
the struct consistent with the chosen naming convention:
tep (trace event parser), instead of the old pevent.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c            | 32 +++++++++----------
 tools/lib/traceevent/event-parse.h            |  2 +-
 tools/lib/traceevent/parse-filter.c           |  6 ++--
 tools/lib/traceevent/plugin_function.c        |  2 +-
 tools/lib/traceevent/plugin_kmem.c            |  4 +--
 tools/lib/traceevent/plugin_kvm.c             |  4 +--
 tools/lib/traceevent/plugin_sched_switch.c    |  2 +-
 tools/perf/builtin-kmem.c                     |  2 +-
 tools/perf/util/data-convert-bt.c             |  4 +--
 tools/perf/util/python.c                      |  2 +-
 .../util/scripting-engines/trace-event-perl.c |  2 +-
 .../scripting-engines/trace-event-python.c    |  2 +-
 tools/perf/util/trace-event-parse.c           |  2 +-
 13 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f04cc0b68450..18fb22a89ef2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -804,7 +804,7 @@ static int add_event(struct tep_handle *pevent, struct tep_event *event)
 	pevent->events[i] = event;
 	pevent->nr_events++;
 
-	event->pevent = pevent;
+	event->tep = pevent;
 
 	return 0;
 }
@@ -1656,8 +1656,8 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 			else if (field->flags & TEP_FIELD_IS_STRING)
 				field->elementsize = 1;
 			else if (field->flags & TEP_FIELD_IS_LONG)
-				field->elementsize = event->pevent ?
-						     event->pevent->long_size :
+				field->elementsize = event->tep ?
+						     event->tep->long_size :
 						     sizeof(long);
 		} else
 			field->elementsize = field->size;
@@ -3075,7 +3075,7 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		return process_dynamic_array_len(event, arg, tok);
 	}
 
-	func = find_func_handler(event->pevent, token);
+	func = find_func_handler(event->tep, token);
 	if (func) {
 		free_token(token);
 		return process_func_handler(event, func, arg, tok);
@@ -3405,7 +3405,7 @@ int tep_read_number_field(struct tep_format_field *field, const void *data,
 	case 2:
 	case 4:
 	case 8:
-		*value = tep_read_number(field->event->pevent,
+		*value = tep_read_number(field->event->tep,
 					 data + field->offset, field->size);
 		return 0;
 	default:
@@ -3566,7 +3566,7 @@ tep_find_event_by_name(struct tep_handle *tep,
 static unsigned long long
 eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg *arg)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long val = 0;
 	unsigned long long left, right;
 	struct tep_print_arg *typearg = NULL;
@@ -3907,7 +3907,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct tep_event *event, const char *format,
 			  int len_arg, struct tep_print_arg *arg)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	struct tep_print_flag_sym *flag;
 	struct tep_format_field *field;
 	struct printk_map *printk;
@@ -4256,7 +4256,7 @@ static void free_args(struct tep_print_arg *args)
 
 static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event *event)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	struct tep_format_field *field, *ip_field;
 	struct tep_print_arg *args, *arg, **next;
 	unsigned long long ip, val;
@@ -4433,7 +4433,7 @@ static char *
 get_bprint_format(void *data, int size __maybe_unused,
 		  struct tep_event *event)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long addr;
 	struct tep_format_field *field;
 	struct printk_map *printk;
@@ -4834,7 +4834,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 {
 	unsigned long long val;
 	unsigned int offset, len, i;
-	struct tep_handle *pevent = field->event->pevent;
+	struct tep_handle *pevent = field->event->tep;
 
 	if (field->flags & TEP_FIELD_IS_ARRAY) {
 		offset = field->offset;
@@ -4909,7 +4909,7 @@ void tep_print_fields(struct trace_seq *s, void *data,
 
 static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event *event)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	struct tep_print_fmt *print_fmt = &event->print_fmt;
 	struct tep_print_arg *arg = print_fmt->args;
 	struct tep_print_arg *args = NULL;
@@ -5423,7 +5423,7 @@ void tep_event_info(struct trace_seq *s, struct tep_event *event,
 {
 	int print_pretty = 1;
 
-	if (event->pevent->print_raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
+	if (event->tep->print_raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
 		tep_print_fields(s, record->data, record->size, event);
 	else {
 
@@ -6097,7 +6097,7 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
 	}
 
 	/* Add pevent to event so that it can be referenced */
-	event->pevent = pevent;
+	event->tep = pevent;
 
 	ret = event_read_format(event);
 	if (ret < 0) {
@@ -6291,8 +6291,8 @@ void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 
 	offset = field->offset;
 	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
-		offset = tep_read_number(event->pevent,
-					    data + offset, field->size);
+		offset = tep_read_number(event->tep,
+					 data + offset, field->size);
 		*len = offset >> 16;
 		offset &= 0xffff;
 	} else
@@ -6426,7 +6426,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_record *record, int err)
 {
 	struct tep_format_field *field = tep_find_field(event, name);
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long val;
 	struct func_map *func;
 	char tmp[128];
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 6438f9b55fbe..594f9c52ebf1 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -278,7 +278,7 @@ struct tep_print_fmt {
 };
 
 struct tep_event {
-	struct tep_handle	*pevent;
+	struct tep_handle	*tep;
 	char			*name;
 	int			id;
 	int			flags;
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index ce437ac286e9..231e9cae5729 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1531,8 +1531,8 @@ get_comm(struct tep_event *event, struct tep_record *record)
 	const char *comm;
 	int pid;
 
-	pid = tep_data_pid(event->pevent, record);
-	comm = tep_data_comm_from_pid(event->pevent, pid);
+	pid = tep_data_pid(event->tep, record);
+	comm = tep_data_comm_from_pid(event->tep, pid);
 	return comm;
 }
 
@@ -1730,7 +1730,7 @@ static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *
 
 	} else {
 		event = arg->str.field->event;
-		pevent = event->pevent;
+		pevent = event->tep;
 		addr = get_value(event, arg->str.field, record);
 
 		if (arg->str.field->flags & (TEP_FIELD_IS_POINTER | TEP_FIELD_IS_LONG))
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index e93f33bd705f..d6a8df060614 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -126,7 +126,7 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event *event, void *context)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long function;
 	unsigned long long pfunction;
 	const char *func;
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index c09bafdd8377..edaec5d962c3 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -39,11 +39,11 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_read_number_field(field, data, &val))
 		return 1;
 
-	func = tep_find_function(event->pevent, val);
+	func = tep_find_function(event->tep, val);
 	if (!func)
 		return 1;
 
-	addr = tep_find_function_address(event->pevent, val);
+	addr = tep_find_function_address(event->tep, val);
 
 	trace_seq_printf(s, "(%s+0x%x) ", func, (int)(val - addr));
 	return 1;
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 472298c2b531..c8e623065a7e 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -389,8 +389,8 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianness.
 	 */
-	if (tep_is_file_bigendian(event->pevent) ==
-	    tep_is_local_bigendian(event->pevent)) {
+	if (tep_is_file_bigendian(event->tep) ==
+	    tep_is_local_bigendian(event->tep)) {
 
 		trace_seq_printf(s, "%u q%u%s %s%s %spae %snxe %swp%s%s%s",
 				 role.level,
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index 701c22913cf8..957389a0ff7a 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -62,7 +62,7 @@ static void write_and_save_comm(struct tep_format_field *field,
 	comm = &s->buffer[len];
 
 	/* Help out the comm to ids. This will handle dups */
-	tep_register_comm(field->event->pevent, comm, pid);
+	tep_register_comm(field->event->tep, comm, pid);
 }
 
 static int sched_wakeup_handler(struct trace_seq *s,
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index fa520f4b8095..b80eee455111 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1975,7 +1975,7 @@ int cmd_kmem(int argc, const char **argv)
 			goto out_delete;
 		}
 
-		kmem_page_size = tep_get_page_size(evsel->tp_format->pevent);
+		kmem_page_size = tep_get_page_size(evsel->tp_format->tep);
 		symbol_conf.use_callchain = true;
 	}
 
diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 26af43ad9ddd..e0311c9750ad 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -310,7 +310,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 	if (flags & TEP_FIELD_IS_DYNAMIC) {
 		unsigned long long tmp_val;
 
-		tmp_val = tep_read_number(fmtf->event->pevent,
+		tmp_val = tep_read_number(fmtf->event->tep,
 					  data + offset, len);
 		offset = tmp_val;
 		len = offset >> 16;
@@ -354,7 +354,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 			unsigned long long value_int;
 
 			value_int = tep_read_number(
-					fmtf->event->pevent,
+					fmtf->event->tep,
 					data + offset + i * len, len);
 
 			if (!(flags & TEP_FIELD_IS_SIGNED))
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index dda0ac978b1e..6aa7e2352e16 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -342,7 +342,7 @@ static bool is_tracepoint(struct pyrf_event *pevent)
 static PyObject*
 tracepoint_field(struct pyrf_event *pe, struct tep_format_field *field)
 {
-	struct tep_handle *pevent = field->event->pevent;
+	struct tep_handle *pevent = field->event->tep;
 	void *data = pe->sample.raw_data;
 	PyObject *ret = NULL;
 	unsigned long long val;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 5f06378a482b..61aa7f3df915 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -372,7 +372,7 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 	ns = nsecs - s * NSEC_PER_SEC;
 
 	scripting_context->event_data = data;
-	scripting_context->pevent = evsel->tp_format->pevent;
+	scripting_context->pevent = evsel->tp_format->tep;
 
 	ENTER;
 	SAVETMPS;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 09604c6508f0..22f52b669871 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -837,7 +837,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	ns = nsecs - s * NSEC_PER_SEC;
 
 	scripting_context->event_data = data;
-	scripting_context->pevent = evsel->tp_format->pevent;
+	scripting_context->pevent = evsel->tp_format->tep;
 
 	context = _PyCapsule_New(scripting_context, NULL, NULL);
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index ad74be1f0e42..863955e4094e 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -111,7 +111,7 @@ raw_field_value(struct tep_event *event, const char *name, void *data)
 
 unsigned long long read_size(struct tep_event *event, void *ptr, int size)
 {
-	return tep_read_number(event->pevent, ptr, size);
+	return tep_read_number(event->tep, ptr, size);
 }
 
 void event_format__fprintf(struct tep_event *event,
-- 
2.20.1

