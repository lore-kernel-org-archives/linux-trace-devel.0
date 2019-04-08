Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89135C10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D40C20883
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbfDHPXz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44004 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbfDHPXz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id k17so16872536wrx.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8K+JfR2xbnc27/zkYNNPzRtwu54dFWEkloWq1kzkRd0=;
        b=GQ30SC+CLKiAPLQCXM02pdzoWpEHhorpMj5A9sQ6b290BD2exwl7TQm6PA95BBPNvV
         AjVeZW5sjF8qZlZOLwmHkmc92LN9J0qZRosW+VzefMaEcYrmz9PAkkNHwgVkivvJ/zNB
         imi54auLvmgPkZLINtmZz3YgmEoUCkoqLRSlwuuQzSqWHiKkVtOvmdvqznF+g10mbHvS
         sF3GcaEbVqmFq9+0PIEytDUA1uMlVk0Z+L2pSWiF0J9s2Ti38bdfUN2h5kfjm6DLmK4W
         3/zsgoSe+nm+eLyecw0RxBGc0s72IvNZmkU5ONDpWlyVT0Ba9sbXiQrYn9pp0C6w/tDa
         zULQ==
X-Gm-Message-State: APjAAAUeODnGssxYQ1vsQxEZjfM09yda+qUnDpGjy7rOL6k0hCXQNM0m
        l/IaRNvppDqeb1A4+OKJXBQ=
X-Google-Smtp-Source: APXvYqwPqTSHIhKSfEFPH0jqFvRUPPzNXchTPKo78yuHnnzVBDnuEbsylWipYCuoS67DfirUT+yYbw==
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr20034138wrj.16.1554737032169;
        Mon, 08 Apr 2019 08:23:52 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:50 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 08/10] perf tools, tools lib traceevent: Rename "pevent" member of struct tep_event to "tep"
Date:   Mon,  8 Apr 2019 18:23:38 +0300
Message-Id: <20190408152340.12450-9-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190408152340.12450-1-tstoyanov@vmware.com>
References: <20190408152340.12450-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The member "pevent" of the struct tep_event is renamed to "tep". This
makes the struct consistent with the chosen naming convention:

  tep (trace event parser), instead of the old pevent.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/linux-trace-devel/20190401132111.13727-3-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190401164344.627724996@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h |  2 +-
 lib/trace-cmd/trace-ftrace.c     | 16 ++++-----
 lib/traceevent/event-parse.c     | 60 ++++++++++++++++----------------
 lib/traceevent/parse-filter.c    |  6 ++--
 plugins/plugin_blk.c             |  8 ++---
 plugins/plugin_function.c        |  2 +-
 plugins/plugin_kmem.c            |  5 +--
 plugins/plugin_kvm.c             |  4 +--
 plugins/plugin_sched_switch.c    |  2 +-
 python/ctracecmd.i               |  4 +--
 tracecmd/trace-profile.c         |  4 +--
 11 files changed, 57 insertions(+), 56 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index ca18025..bedff0b 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -264,7 +264,7 @@ struct tep_print_fmt {
 };
 
 struct tep_event {
-	struct tep_handle	*pevent;
+	struct tep_handle	*tep;
 	char			*name;
 	int			id;
 	int			flags;
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index ba68a19..ed68099 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -65,7 +65,7 @@ static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *peve
 static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event *event, void *context)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long function;
 	const char *func;
 
@@ -192,7 +192,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 		       struct tep_record *ret_rec,
 		       struct tracecmd_ftrace *finfo)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long rettime, calltime;
 	unsigned long long duration, depth;
 	unsigned long long val;
@@ -240,7 +240,7 @@ static int print_graph_nested(struct trace_seq *s,
 			      struct tep_event *event,
 			      struct tep_record *record)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long depth;
 	unsigned long long val;
 	const char *func;
@@ -285,7 +285,7 @@ fgraph_ent_handler(struct trace_seq *s, struct tep_record *record,
 	unsigned long long val, pid;
 	int cpu;
 
-	ret_event_check(finfo, event->pevent);
+	ret_event_check(finfo, event->tep);
 
 	if (tep_get_common_field_val(s, event, "common_pid", record, &pid, 1))
 		return trace_seq_putc(s, '!');
@@ -321,7 +321,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	const char *func;
 	int i;
 
-	ret_event_check(finfo, event->pevent);
+	ret_event_check(finfo, event->tep);
 
 	if (tep_get_field_val(s, event, "rettime", record, &rettime, 1))
 		return trace_seq_putc(s, '!');
@@ -349,7 +349,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	if (fgraph_tail->set) {
 		if (tep_get_field_val(s, event, "func", record, &val, 0))
 			return 0;
-		func = tep_find_function(event->pevent, val);
+		func = tep_find_function(event->tep, val);
 		if (!func)
 			return 0;
 		trace_seq_printf(s, " /* %s */", func);
@@ -383,13 +383,13 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 
 	for (data += field->offset; data < record->data + record->size;
 	     data += finfo->long_size) {
-		addr = tep_read_number(event->pevent, data, finfo->long_size);
+		addr = tep_read_number(event->tep, data, finfo->long_size);
 
 		if ((finfo->long_size == 8 && addr == (unsigned long long)-1) ||
 		    ((int)addr == -1))
 			break;
 
-		func = tep_find_function(event->pevent, addr);
+		func = tep_find_function(event->tep, addr);
 		if (func)
 			trace_seq_printf(s, "=> %s (%llx)\n", func, addr);
 		else
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 4fa638f..c06da09 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
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
+	struct tep_handle *tep = event->tep;
 	unsigned long long val = 0;
 	unsigned long long left, right;
 	struct tep_print_arg *typearg = NULL;
@@ -3588,7 +3588,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			
 		}
 		/* must be a number */
-		val = tep_read_number(pevent, data + arg->field.field->offset,
+		val = tep_read_number(tep, data + arg->field.field->offset,
 				      arg->field.field->size);
 		break;
 	case TEP_PRINT_FLAGS:
@@ -3628,11 +3628,11 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			}
 
 			/* Default to long size */
-			field_size = pevent->long_size;
+			field_size = tep->long_size;
 
 			switch (larg->type) {
 			case TEP_PRINT_DYNAMIC_ARRAY:
-				offset = tep_read_number(pevent,
+				offset = tep_read_number(tep,
 						   data + larg->dynarray.field->offset,
 						   larg->dynarray.field->size);
 				if (larg->dynarray.field->elementsize)
@@ -3661,7 +3661,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			default:
 				goto default_op; /* oops, all bets off */
 			}
-			val = tep_read_number(pevent,
+			val = tep_read_number(tep,
 					      data + offset, field_size);
 			if (typearg)
 				val = eval_type(val, typearg, 1);
@@ -3762,7 +3762,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		}
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
-		offset = tep_read_number(pevent,
+		offset = tep_read_number(tep,
 					 data + arg->dynarray.field->offset,
 					 arg->dynarray.field->size);
 		/*
@@ -3774,7 +3774,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY:
 		/* Without [], we pass the address to the dynamic data */
-		offset = tep_read_number(pevent,
+		offset = tep_read_number(tep,
 					 data + arg->dynarray.field->offset,
 					 arg->dynarray.field->size);
 		/*
@@ -3907,7 +3907,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct tep_event *event, const char *format,
 			  int len_arg, struct tep_print_arg *arg)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *tep = event->tep;
 	struct tep_print_flag_sym *flag;
 	struct tep_format_field *field;
 	struct printk_map *printk;
@@ -3944,7 +3944,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		 * is a pointer.
 		 */
 		if (!(field->flags & TEP_FIELD_IS_ARRAY) &&
-		    field->size == pevent->long_size) {
+		    field->size == tep->long_size) {
 
 			/* Handle heterogeneous recording and processing
 			 * architectures
@@ -3959,12 +3959,12 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			 * on 32-bit devices:
 			 * In this case, 64 bits must be read.
 			 */
-			addr = (pevent->long_size == 8) ?
+			addr = (tep->long_size == 8) ?
 				*(unsigned long long *)(data + field->offset) :
 				(unsigned long long)*(unsigned int *)(data + field->offset);
 
 			/* Check if it matches a print format */
-			printk = find_printk(pevent, addr);
+			printk = find_printk(tep, addr);
 			if (printk)
 				trace_seq_puts(s, printk->printk);
 			else
@@ -4021,7 +4021,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_HEX_STR:
 		if (arg->hex.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
-			offset = tep_read_number(pevent,
+			offset = tep_read_number(tep,
 				data + arg->hex.field->dynarray.field->offset,
 				arg->hex.field->dynarray.field->size);
 			hex = data + (offset & 0xffff);
@@ -4052,7 +4052,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			unsigned long offset;
 			struct tep_format_field *field =
 				arg->int_array.field->dynarray.field;
-			offset = tep_read_number(pevent,
+			offset = tep_read_number(tep,
 						 data + field->offset,
 						 field->size);
 			num = data + (offset & 0xffff);
@@ -4103,7 +4103,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
 		}
-		str_offset = tep_data2host4(pevent, *(unsigned int *)(data + arg->string.offset));
+		str_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->string.offset));
 		str_offset &= 0xffff;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
@@ -4121,10 +4121,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
-		bitmask_offset = tep_data2host4(pevent, *(unsigned int *)(data + arg->bitmask.offset));
+		bitmask_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
 		bitmask_size = bitmask_offset >> 16;
 		bitmask_offset &= 0xffff;
-		print_bitmask_to_seq(pevent, s, format, len_arg,
+		print_bitmask_to_seq(tep, s, format, len_arg,
 				     data + bitmask_offset, bitmask_size);
 		break;
 	}
@@ -4256,7 +4256,7 @@ static void free_args(struct tep_print_arg *args)
 
 static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event *event)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	struct tep_format_field *field, *ip_field;
 	struct tep_print_arg *args, *arg, **next;
 	unsigned long long ip, val;
@@ -4434,7 +4434,7 @@ static char *
 get_bprint_format(void *data, int size __maybe_unused,
 		  struct tep_event *event)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long addr;
 	struct tep_format_field *field;
 	struct printk_map *printk;
@@ -4835,7 +4835,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 {
 	unsigned long long val;
 	unsigned int offset, len, i;
-	struct tep_handle *pevent = field->event->pevent;
+	struct tep_handle *pevent = field->event->tep;
 
 	if (field->flags & TEP_FIELD_IS_ARRAY) {
 		offset = field->offset;
@@ -4910,7 +4910,7 @@ void tep_print_fields(struct trace_seq *s, void *data,
 
 static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event *event)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	struct tep_print_fmt *print_fmt = &event->print_fmt;
 	struct tep_print_arg *arg = print_fmt->args;
 	struct tep_print_arg *args = NULL;
@@ -5424,7 +5424,7 @@ void tep_event_info(struct trace_seq *s, struct tep_event *event,
 {
 	int print_pretty = 1;
 
-	if (event->pevent->print_raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
+	if (event->tep->print_raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
 		tep_print_fields(s, record->data, record->size, event);
 	else {
 
@@ -6163,7 +6163,7 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
 	}
 
 	/* Add pevent to event so that it can be referenced */
-	event->pevent = pevent;
+	event->tep = pevent;
 
 	ret = event_read_format(event);
 	if (ret < 0) {
@@ -6357,8 +6357,8 @@ void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 
 	offset = field->offset;
 	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
-		offset = tep_read_number(event->pevent,
-					    data + offset, field->size);
+		offset = tep_read_number(event->tep,
+					 data + offset, field->size);
 		*len = offset >> 16;
 		offset &= 0xffff;
 	} else
@@ -6492,7 +6492,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_record *record, int err)
 {
 	struct tep_format_field *field = tep_find_field(event, name);
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long val;
 	struct func_map *func;
 	char tmp[128];
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 5d8f9d9..1233582 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1528,8 +1528,8 @@ get_comm(struct tep_event *event, struct tep_record *record)
 	const char *comm;
 	int pid;
 
-	pid = tep_data_pid(event->pevent, record);
-	comm = tep_data_comm_from_pid(event->pevent, pid);
+	pid = tep_data_pid(event->tep, record);
+	comm = tep_data_comm_from_pid(event->tep, pid);
 	return comm;
 }
 
@@ -1727,7 +1727,7 @@ static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *
 
 	} else {
 		event = arg->str.field->event;
-		pevent = event->pevent;
+		pevent = event->tep;
 		addr = get_value(event, arg->str.field, record);
 
 		if (arg->str.field->flags & (TEP_FIELD_IS_POINTER | TEP_FIELD_IS_LONG))
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index c75e4fc..ea3a9cf 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -191,7 +191,7 @@ static int blk_log_split(struct trace_seq *s, struct blk_data *data)
 {
 	const char *cmd;
 
-	cmd = tep_data_comm_from_pid(data->event->pevent, data->pid);
+	cmd = tep_data_comm_from_pid(data->event->tep, data->pid);
 
 	return trace_seq_printf(s, "%llu / %llu [%s]\n", data->sector,
 				get_pdu_int(data->pdu_data), cmd);
@@ -201,7 +201,7 @@ static int blk_log_plug(struct trace_seq *s, struct blk_data *data)
 {
 	const char *cmd;
 
-	cmd = tep_data_comm_from_pid(data->event->pevent, data->pid);
+	cmd = tep_data_comm_from_pid(data->event->tep, data->pid);
 
 	return trace_seq_printf(s, "[%s]\n", cmd);
 }
@@ -210,7 +210,7 @@ static int blk_log_unplug(struct trace_seq *s, struct blk_data *data)
 {
 	const char *cmd;
 
-	cmd = tep_data_comm_from_pid(data->event->pevent, data->pid);
+	cmd = tep_data_comm_from_pid(data->event->tep, data->pid);
 
 	return trace_seq_printf(s, "[%s] %llu\n", cmd, get_pdu_int(data->pdu_data));
 }
@@ -236,7 +236,7 @@ static int blk_log_generic(struct trace_seq *s, struct blk_data *data)
 {
 	const char *cmd;
 
-	cmd = tep_data_comm_from_pid(data->event->pevent, data->pid);
+	cmd = tep_data_comm_from_pid(data->event->tep, data->pid);
 
 	if (data->action & BLK_TC_ACT(BLK_TC_PC)) {
 		int ret;
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 860b7fc..007bc04 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -131,7 +131,7 @@ static void show_function(struct trace_seq *s, struct tep_handle *pevent,
 static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event *event, void *context)
 {
-	struct tep_handle *pevent = event->pevent;
+	struct tep_handle *pevent = event->tep;
 	unsigned long long function;
 	unsigned long long pfunction;
 	const char *func;
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index 464b184..1117bdd 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -24,10 +24,11 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_read_number_field(field, data, &val))
 		return 1;
 
-	func = tep_find_function(event->pevent, val);
+	func = tep_find_function(event->tep, val);
 	if (!func)
 		return 1;
-	addr = tep_find_function_address(event->pevent, val);
+
+	addr = tep_find_function_address(event->tep, val);
 
 	trace_seq_printf(s, "(%s+0x%x) ", func, (int)(val - addr));
 
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index e262aea..6c74432 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -386,8 +386,8 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianness.
 	 */
-	if (tep_is_file_bigendian(event->pevent) ==
-	    tep_is_local_bigendian(event->pevent)) {
+	if (tep_is_file_bigendian(event->tep) ==
+	    tep_is_local_bigendian(event->tep)) {
 
 		trace_seq_printf(s, "%u/%u q%u%s %s%s %spge %snxe",
 				 role.level,
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index a3cdc84..566f166 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -47,7 +47,7 @@ static void write_and_save_comm(struct tep_format_field *field,
 	comm = &s->buffer[len];
 
 	/* Help out the comm to ids. This will handle dups */
-	tep_register_comm(field->event->pevent, comm, pid);
+	tep_register_comm(field->event->tep, comm, pid);
 }
 
 static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 55fd875..65a3d51 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -102,12 +102,12 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 
 	for (data += field->offset; data < record->data + record->size;
 	     data += long_size) {
-		addr = tep_read_number(event->pevent, data, long_size);
+		addr = tep_read_number(event->tep, data, long_size);
 
 		if ((long_size == 8 && addr == (unsigned long long)-1) ||
 		    ((int)addr == -1))
 			break;
-		func = tep_find_function(event->pevent, addr);
+		func = tep_find_function(event->tep, addr);
 		if (PyList_Append(list, PyString_FromString(func))) {
 			Py_DECREF(list);
 			return NULL;
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 0a70125..231e381 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -904,7 +904,7 @@ static void func_print(struct trace_seq *s, struct event_hash *event_hash)
 {
 	const char *func;
 
-	func = tep_find_function(event_hash->event_data->event->pevent,
+	func = tep_find_function(event_hash->event_data->event->tep,
 				 event_hash->val);
 	if (func)
 		trace_seq_printf(s, "func: %s()", func);
@@ -1927,7 +1927,7 @@ static void output_stacks(struct tep_handle *pevent, struct trace_hash *stack_ha
 static void output_event(struct event_hash *event_hash)
 {
 	struct event_data *event_data = event_hash->event_data;
-	struct tep_handle *pevent = event_data->event->pevent;
+	struct tep_handle *pevent = event_data->event->tep;
 	struct trace_seq s;
 
 	trace_seq_init(&s);
-- 
2.20.1

