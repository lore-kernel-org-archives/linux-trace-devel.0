Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA125C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 12:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9343123133
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 12:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgLVMKi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 07:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgLVMKh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 07:10:37 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4B8C0613D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 04:09:56 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id w5so14285765wrm.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 04:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AMpGp1bqQ1Tl8P/g3BR6X4xURISxpVHw1Cdv8qWqrcI=;
        b=CRBVXPYiF79yExQf0RWKb9gd3CIdMQru1AN0nVraKrJgUD+PW8+iU6ZouNpCieRfKt
         nAxTrzGtPdAYSMidTYFMyJAKjXlGLfL4SOxkWQz1AK98cRivuSBKpKaSgvfZo+BcmOee
         P0QPE7TNu9T7FvooBIusvurSX6QML63WaQEk6qYixI4VEGi/3LNeHJF84cZnTD8cstS9
         xdvQ0qxCq0djJw5OFDo7a4s7Pq3kT8vxJ0ObHIYsKRvrp8KJXBQZdOUU9Fqi4aGmuYVH
         9fNRmHPsSWUUn/YKW0Ah0e8CY+FnSL98xPzfBZVQsFeJhmeEeIOpIkWCDbrZiiu5zFfG
         2ZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AMpGp1bqQ1Tl8P/g3BR6X4xURISxpVHw1Cdv8qWqrcI=;
        b=qnv1clT5YWcaODJLWnqvJI9Vz+CrcU6qRfyYilQXnhLS967qWl/dAEInceNy0Bap4l
         //MH+cz87J1jUL/hyuW8pvW/7yf27Ts8C3np2e/B/YS6cAugKDEYPq06Yy9rklFTf1qV
         J1cFSTRALp8RQupktBsnlDLSbxd+NSNUHSKLP8PBzq/tHBeUAy1lFakUTTUCj8yxKjm7
         5QOyBDgfLwLc7uMz7QrIDF6J2CBmAYpWd5a2HnCndN7NnwUPz6ZOsV+thCPsrTH9Y8vJ
         cgG/mTqSBV17IGijVMp7W8zmnlIlk2lYoDCfjZiyVq6vr4jS3+K2ttgluqOfWMx1pGbj
         bBRw==
X-Gm-Message-State: AOAM533hoR2+uU+x3NfzdFZkheqMU5JJSFfrjeRgYNv+6zib9UNf++Yn
        erXLHfaBXhe94efzIEXlaAU2SEOoR7QkaboS
X-Google-Smtp-Source: ABdhPJzfgQxsIiVm7b3B0sGAsZL2jfpFVayiuxUPGGPu5Rceay3jplKVpqdKYBVR1THU4MsUBn31Tw==
X-Received: by 2002:adf:f10f:: with SMTP id r15mr24362607wro.302.1608638995175;
        Tue, 22 Dec 2020 04:09:55 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm28168576wma.3.2020.12.22.04.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 04:09:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Rename free_record() to tracecmd_free_record()
Date:   Tue, 22 Dec 2020 14:09:50 +0200
Message-Id: <20201222120951.492370-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201222120951.492370-1-tz.stoyanov@gmail.com>
References: <20201222120951.492370-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The free_record() function is a libtracecmd API used to free a trace
record read from a trace file. It should follow the tracecmd library
naming convention, start with a "tracecmd_ prefix.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h           |  2 +-
 kernel-shark/src/libkshark.c            | 18 +++++++++---------
 kernel-shark/src/plugins/sched_events.c |  4 ++--
 lib/trace-cmd/trace-ftrace.c            |  2 +-
 lib/trace-cmd/trace-input.c             | 16 ++++++++--------
 tracecmd/trace-hist.c                   |  2 +-
 tracecmd/trace-mem.c                    |  2 +-
 tracecmd/trace-profile.c                | 12 ++++++------
 tracecmd/trace-read.c                   | 14 +++++++-------
 tracecmd/trace-split.c                  | 16 ++++++++--------
 tracecmd/trace-stream.c                 |  2 +-
 11 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 9751ac3b..9d9a61d3 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -24,7 +24,7 @@ tracecmd_read_data(struct tracecmd_input *handle, int cpu);
 struct tep_record *
 tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
 		 int *cpu);
-void free_record(struct tep_record *record);
+void tracecmd_free_record(struct tep_record *record);
 
 struct tep_handle *tracecmd_get_pevent(struct tracecmd_input *handle);
 unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 4e625a25..9823ccc9 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -678,7 +678,7 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus,
 			temp_rec = rec_list[cpu];
 			rec_list[cpu] = temp_rec->next;
 			if (type == REC_RECORD)
-				free_record(temp_rec->rec);
+				tracecmd_free_record(temp_rec->rec);
 			free(temp_rec);
 		}
 	}
@@ -778,14 +778,14 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 				if (!kshark_show_task(kshark_ctx, entry->pid)) {
 					entry->visible &= ~kshark_ctx->filter_mask;
 				}
-				free_record(rec);
+				tracecmd_free_record(rec);
 				break;
 			} /* REC_ENTRY */
 			}
 
 			task = kshark_add_task(kshark_ctx, pid);
 			if (!task) {
-				free_record(rec);
+				tracecmd_free_record(rec);
 				goto fail;
 			}
 
@@ -906,7 +906,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
  *	  to all fields of the record.
  *
  * @param kshark_ctx: Input location for the session context pointer.
- * @param data_rows: Output location for the trace data. Use free_record()
+ * @param data_rows: Output location for the trace data. Use tracecmd_free_record()
  *	 	     to free the elements of the outputted array.
  *
  * @returns The size of the outputted data in the case of success, or a
@@ -1171,7 +1171,7 @@ int kshark_get_pid_easy(struct kshark_entry *entry)
 		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
 					NULL);
 		pid = tep_data_pid(kshark_ctx->pevent, data);
-		free_record(data);
+		tracecmd_free_record(data);
 
 		pthread_mutex_unlock(&kshark_ctx->input_mutex);
 	}
@@ -1238,7 +1238,7 @@ const char *kshark_get_latency_easy(struct kshark_entry *entry)
 
 	data = tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
 	lat = kshark_get_latency(kshark_ctx->pevent, data);
-	free_record(data);
+	tracecmd_free_record(data);
 
 	pthread_mutex_unlock(&kshark_ctx->input_mutex);
 
@@ -1283,7 +1283,7 @@ int kshark_get_event_id_easy(struct kshark_entry *entry)
 		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
 					NULL);
 		event_id = tep_data_type(kshark_ctx->pevent, data);
-		free_record(data);
+		tracecmd_free_record(data);
 
 		pthread_mutex_unlock(&kshark_ctx->input_mutex);
 	}
@@ -1382,7 +1382,7 @@ const char *kshark_get_info_easy(struct kshark_entry *entry)
 	if (event)
 		info = kshark_get_info(kshark_ctx->pevent, data, event);
 
-	free_record(data);
+	tracecmd_free_record(data);
 
 	pthread_mutex_unlock(&kshark_ctx->input_mutex);
 
@@ -1496,7 +1496,7 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 			free(temp_str);
 		}
 
-		free_record(data);
+		tracecmd_free_record(data);
 		if (size < 1)
 			entry_str = NULL;
 	} else {
diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index d0fd15e0..4b671f16 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -160,7 +160,7 @@ static int find_wakeup_pid(struct kshark_context *kshark_ctx, struct kshark_entr
 
 	record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
 	ret = tep_read_number_field(pid_field, record->data, &val);
-	free_record(record);
+	tracecmd_free_record(record);
 
 	if (ret)
 		return -1;
@@ -252,7 +252,7 @@ bool plugin_switch_match_rec_pid(struct kshark_context *kshark_ctx,
 		if (ret == 0 && !(val & 0x7f))
 			switch_pid = tep_data_pid(plugin_ctx->pevent, record);
 
-		free_record(record);
+		tracecmd_free_record(record);
 	}
 
 	if (switch_pid >= 0 && switch_pid == pid)
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index df7335f0..03e60eb0 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -292,7 +292,7 @@ fgraph_ent_handler(struct trace_seq *s, struct tep_record *record,
 		 * returns the return of the function
 		 */
 		print_graph_entry_leaf(s, event, record, rec, finfo);
-		free_record(rec);
+		tracecmd_free_record(rec);
 	} else
 		print_graph_nested(s, event, record);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index af97883e..e57492e9 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1072,7 +1072,7 @@ static void __free_record(struct tep_record *record)
 	free(record);
 }
 
-void free_record(struct tep_record *record)
+void tracecmd_free_record(struct tep_record *record)
 {
 	if (!record)
 		return;
@@ -1116,7 +1116,7 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 	handle->cpu_data[cpu].next = NULL;
 
 	record->locked = 0;
-	free_record(record);
+	tracecmd_free_record(record);
 }
 
 static inline unsigned long long
@@ -1503,7 +1503,7 @@ tracecmd_read_cpu_last(struct tracecmd_input *handle, int cpu)
 	offset = page_offset;
 
 	do {
-		free_record(record);
+		tracecmd_free_record(record);
 		record = tracecmd_read_data(handle, cpu);
 		if (record)
 			offset = record->offset;
@@ -1988,7 +1988,7 @@ tracecmd_peek_next_data(struct tracecmd_input *handle, int *rec_cpu)
  * Note, this is not that fast of an algorithm, since it needs
  * to build the timestamp for the record.
  *
- * The record returned must be freed with free_record().
+ * The record returned must be freed with tracecmd_free_record().
  */
 struct tep_record *
 tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
@@ -2028,9 +2028,9 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
 		if (record->offset == offset)
 			break;
 		index = record->offset - page_offset;
-		free_record(record);
+		tracecmd_free_record(record);
 	}
-	free_record(record);
+	tracecmd_free_record(record);
 
 	if (index)
 		/* we found our record */
@@ -2054,14 +2054,14 @@ tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
 		do {
 			if (record) {
 				index = record->offset - page_offset;
-				free_record(record);
+				tracecmd_free_record(record);
 			}
 			record = tracecmd_read_data(handle, cpu);
 			/* Should not happen */
 			if (!record)
 				return NULL;
 		} while (record->offset != offset);
-		free_record(record);
+		tracecmd_free_record(record);
 
 		if (index)
 			/* we found our record */
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index c4d8b403..76e8cae2 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -985,7 +985,7 @@ static void do_trace_hist(struct tracecmd_input *handle)
 				flush_stack();
 
 			process_record(pevent, record);
-			free_record(record);
+			tracecmd_free_record(record);
 		}
 	}
 
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 76f38fa7..c6cc7dee 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -508,7 +508,7 @@ static void do_trace_mem(struct tracecmd_input *handle)
 			missed_events = 1;
 
 		process_record(pevent, record);
-		free_record(record);
+		tracecmd_free_record(record);
 	}
 
 	sort_list();
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index cfae2a22..b82110e6 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -393,7 +393,7 @@ static void free_start(struct start_data *start)
 	if (start->task->last_start == start)
 		start->task->last_start = NULL;
 	if (start->stack.record)
-		free_record(start->stack.record);
+		tracecmd_free_record(start->stack.record);
 	trace_hash_del(&start->hash);
 	list_del(&start->list);
 	free(start);
@@ -442,7 +442,7 @@ add_and_free_start(struct task_data *task, struct start_data *start,
 
 		add_event_stack(event_hash, caller, size, delta,
 				start->stack.record->ts);
-		free_record(start->stack.record);
+		tracecmd_free_record(start->stack.record);
 		start->stack.record = NULL;
 	}
 
@@ -786,7 +786,7 @@ static void trace_profile_record(struct tracecmd_input *handle,
 
 	/* If the last stack hasn't changed, free it */
 	if (stack_record && task->last_stack == stack_record) {
-		free_record(stack_record);
+		tracecmd_free_record(stack_record);
 		task->last_stack = NULL;
 	}
 }
@@ -1069,7 +1069,7 @@ static int handle_stacktrace_event(struct handle_data *h,
 		return -1;
 
 	if (task->last_stack) {
-		free_record(task->last_stack);
+		tracecmd_free_record(task->last_stack);
 		task->last_stack = NULL;
 	}
 
@@ -2138,7 +2138,7 @@ static void __free_task(struct task_data *task)
 		trace_hash_while_item(item, bucket) {
 			start = start_from_item(item);
 			if (start->stack.record)
-				free_record(start->stack.record);
+				tracecmd_free_record(start->stack.record);
 			list_del(&start->list);
 			trace_hash_del(item);
 			free(start);
@@ -2156,7 +2156,7 @@ static void __free_task(struct task_data *task)
 	trace_hash_free(&task->event_hash);
 
 	if (task->last_stack)
-		free_record(task->last_stack);
+		tracecmd_free_record(task->last_stack);
 }
 
 static void free_task(struct task_data *task)
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 0b3eb1bc..11293bc8 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -209,7 +209,7 @@ static void show_test(struct tracecmd_input *handle)
 	trace_seq_destroy(&s);
 	printf("\n");
 
-	free_record(record);
+	tracecmd_free_record(record);
 }
 
 static void test_save(struct tep_record *record, int cpu)
@@ -253,7 +253,7 @@ static void show_test(struct tracecmd_input *handle)
 	trace_seq_destroy(&s);
 	printf("\n");
 
-	free_record(record);
+	tracecmd_free_record(record);
 }
 
 static void test_save(struct tep_record *record, int cpu)
@@ -291,7 +291,7 @@ static void show_test(struct tracecmd_input *handle)
 	trace_seq_destroy(&s);
 	printf("\n");
 
-	free_record(record);
+	tracecmd_free_record(record);
 
 	record = tracecmd_read_cpu_last(handle, cpu);
 	if (!record) {
@@ -307,7 +307,7 @@ static void show_test(struct tracecmd_input *handle)
 	trace_seq_destroy(&s);
 	printf("\n");
 
-	free_record(record);
+	tracecmd_free_record(record);
 }
 static void test_save(struct tep_record *record, int cpu)
 {
@@ -1122,7 +1122,7 @@ static struct tep_record *get_next_record(struct handle_list *handles)
 				    test_stacktrace(handles, record, 0))
 					found = 1;
 				else
-					free_record(record);
+					tracecmd_free_record(record);
 				break;
 			case FILTER_NONE:
 			case FILTER_MATCH:
@@ -1135,7 +1135,7 @@ static struct tep_record *get_next_record(struct handle_list *handles)
 				}
 				/* fall through */
 			default:
-				free_record(record);
+				tracecmd_free_record(record);
 			}
 		}
 	} while (record && !found);
@@ -1155,7 +1155,7 @@ static void free_handle_record(struct handle_list *handles)
 	if (!handles->record)
 		return;
 
-	free_record(handles->record);
+	tracecmd_free_record(handles->record);
 	handles->record = NULL;
 }
 
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index bb2c3d53..f6ab970b 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -214,7 +214,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 	if (start) {
 		set_cpu_time(handle, percpu, start, cpu, cpus);
 		while (record && record->ts < start) {
-			free_record(record);
+			tracecmd_free_record(record);
 			record = read_record(handle, percpu, &cpu);
 		}
 	} else if (record)
@@ -249,7 +249,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 		cpu_data[cpu].offset = record->offset;
 
 		if (write_record(handle, record, &cpu_data[cpu], type)) {
-			free_record(record);
+			tracecmd_free_record(record);
 			record = read_record(handle, percpu, &cpu);
 
 			/* if we hit the end of the cpu, clear the offset */
@@ -268,7 +268,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 				if (record &&
 				    record->ts >
 				    (start + (unsigned long long)count_limit * 1000000000ULL)) {
-					free_record(record);
+					tracecmd_free_record(record);
 					record = NULL;
 				}
 				break;
@@ -276,7 +276,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 				if (record &&
 				    record->ts >
 				    (start + (unsigned long long)count_limit * 1000000ULL)) {
-					free_record(record);
+					tracecmd_free_record(record);
 					record = NULL;
 				}
 				break;
@@ -284,13 +284,13 @@ static int parse_cpu(struct tracecmd_input *handle,
 				if (record &&
 				    record->ts >
 				    (start + (unsigned long long)count_limit * 1000ULL)) {
-					free_record(record);
+					tracecmd_free_record(record);
 					record = NULL;
 				}
 				break;
 			case SPLIT_EVENTS:
 				if (++count >= count_limit) {
-					free_record(record);
+					tracecmd_free_record(record);
 					record = NULL;
 				}
 				break;
@@ -301,7 +301,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 	}
 
 	if (record)
-		free_record(record);
+		tracecmd_free_record(record);
 
 	if (percpu) {
 		if (cpu_data[cpu].page) {
@@ -393,7 +393,7 @@ static double parse_file(struct tracecmd_input *handle,
 			record = tracecmd_read_at(handle, cpu_data[cpu].offset, NULL);
 			if (record && (!current || record->ts > current))
 				current = record->ts + 1;
-			free_record(record);
+			tracecmd_free_record(record);
 		}
 		unlink(cpu_data[cpu].file);
 		free(cpu_data[cpu].file);
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index 3814a357..54c21c78 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -115,7 +115,7 @@ int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval
 	}
 	if (last_pid) {
 		trace_show_data(last_pid->instance->handle, last_pid->record);
-		free_record(last_pid->record);
+		tracecmd_free_record(last_pid->record);
 		last_pid->record = NULL;
 		return 1;
 	}
-- 
2.28.0

