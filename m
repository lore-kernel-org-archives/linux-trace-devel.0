Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E33C43217
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 948BD61246
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhKDRHT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:07:19 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54238 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbhKDRHR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 13:07:17 -0400
Received: from localhost.localdomain (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 356D420B409D;
        Thu,  4 Nov 2021 10:04:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 356D420B409D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636045479;
        bh=tXyT38KvRKJIVWT57weFXmxW9dhBXkt99sP/2nKn7jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ogj5Y1apXItDWjeycMGswby/bkQqDl2esmszzXrh6Vxe7V8XtYX+Eg2cFei6eKHB7
         i32q5R4d4jAc0V1bKB/OS5dB9e7EkhRzgbwsWj9Yi0W63VpBRIR8ZYOhcmFpQ/n81/
         CSBHVBl4hKxYZYmLtljycDnCwJ8KCyKeNu75+dwM=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        beaub@linux.microsoft.com
Subject: [PATCH v4 09/10] user_events: Optimize writing events by only copying data once
Date:   Thu,  4 Nov 2021 10:04:32 -0700
Message-Id: <20211104170433.2206-10-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211104170433.2206-1-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Pass iterator through to probes to allow copying data directly to the
probe buffers instead of taking multiple copies. Enables eBPF user and
raw iterator types out to programs for no-copy scenarios.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_user.c | 97 +++++++++++++++++++++++---------
 1 file changed, 69 insertions(+), 28 deletions(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index b5fe0550b489..d50118b9630a 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -39,6 +39,10 @@
 #define MAX_EVENT_DESC 512
 #define EVENT_NAME(user_event) ((user_event)->tracepoint.name)
 
+#define MAX_BPF_COPY_SIZE PAGE_SIZE
+#define MAX_STACK_BPF_DATA 512
+#define copy_nofault copy_from_iter_nocache
+
 static char *register_page_data;
 
 static DEFINE_MUTEX(reg_mutex);
@@ -63,8 +67,7 @@ struct user_event_refs {
 	struct user_event *events[];
 };
 
-typedef void (*user_event_func_t) (struct user_event *user,
-				   void *data, u32 datalen,
+typedef void (*user_event_func_t) (struct user_event *user, struct iov_iter *i,
 				   void *tpdata);
 
 static int user_event_parse(char *name, char *args, char *flags,
@@ -491,7 +494,7 @@ static struct user_event *find_user_event(char *name, u32 *outkey)
 /*
  * Writes the user supplied payload out to a trace file.
  */
-static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
+static void user_event_ftrace(struct user_event *user, struct iov_iter *i,
 			      void *tpdata)
 {
 	struct trace_event_file *file;
@@ -506,41 +509,82 @@ static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
 		return;
 
 	entry = trace_event_buffer_reserve(&event_buffer, file,
-					   sizeof(*entry) + datalen);
+					   sizeof(*entry) + i->count);
 
 	if (unlikely(!entry))
 		return;
 
-	memcpy(entry + 1, data, datalen);
+	if (unlikely(!copy_nofault(entry + 1, i->count, i)))
+		return;
 
 	trace_event_buffer_commit(&event_buffer);
 }
 
 #ifdef CONFIG_PERF_EVENTS
+static void user_event_bpf(struct user_event *user, struct iov_iter *i)
+{
+	struct user_bpf_context context;
+	struct user_bpf_iter bpf_i;
+	char fast_data[MAX_STACK_BPF_DATA];
+	void *temp = NULL;
+
+	if ((user->flags & FLAG_BPF_ITER) && iter_is_iovec(i)) {
+		/* Raw iterator */
+		context.data_type = USER_BPF_DATA_ITER;
+		context.data_len = i->count;
+		context.iter = &bpf_i;
+
+		bpf_i.iov_offset = i->iov_offset;
+		bpf_i.iov = i->iov;
+		bpf_i.nr_segs = i->nr_segs;
+	} else if (i->nr_segs == 1 && iter_is_iovec(i)) {
+		/* Single buffer from user */
+		context.data_type = USER_BPF_DATA_USER;
+		context.data_len = i->count;
+		context.udata = i->iov->iov_base + i->iov_offset;
+	} else {
+		/* Multi buffer from user */
+		struct iov_iter copy = *i;
+		size_t copy_size = min(i->count, MAX_BPF_COPY_SIZE);
+
+		context.data_type = USER_BPF_DATA_KERNEL;
+		context.kdata = fast_data;
+
+		if (unlikely(copy_size > sizeof(fast_data))) {
+			temp = kmalloc(copy_size, GFP_NOWAIT);
+
+			if (temp)
+				context.kdata = temp;
+			else
+				copy_size = sizeof(fast_data);
+		}
+
+		context.data_len = copy_nofault(context.kdata,
+						copy_size, &copy);
+	}
+
+	trace_call_bpf(&user->call, &context);
+
+	kfree(temp);
+}
+
 /*
  * Writes the user supplied payload out to perf ring buffer or eBPF program.
  */
-static void user_event_perf(struct user_event *user, void *data, u32 datalen,
+static void user_event_perf(struct user_event *user, struct iov_iter *i,
 			    void *tpdata)
 {
 	struct hlist_head *perf_head;
 
-	if (bpf_prog_array_valid(&user->call)) {
-		struct user_bpf_context context = {0};
-
-		context.data_len = datalen;
-		context.data_type = USER_BPF_DATA_KERNEL;
-		context.kdata = data;
-
-		trace_call_bpf(&user->call, &context);
-	}
+	if (bpf_prog_array_valid(&user->call))
+		user_event_bpf(user, i);
 
 	perf_head = this_cpu_ptr(user->call.perf_events);
 
 	if (perf_head && !hlist_empty(perf_head)) {
 		struct trace_entry *perf_entry;
 		struct pt_regs *regs;
-		size_t size = sizeof(*perf_entry) + datalen;
+		size_t size = sizeof(*perf_entry) + i->count;
 		int context;
 
 		perf_entry = perf_trace_buf_alloc(ALIGN(size, 8),
@@ -551,7 +595,8 @@ static void user_event_perf(struct user_event *user, void *data, u32 datalen,
 
 		perf_fetch_caller_regs(regs);
 
-		memcpy(perf_entry + 1, data, datalen);
+		if (unlikely(!copy_nofault(perf_entry + 1, i->count, i)))
+			return;
 
 		perf_trace_buf_submit(perf_entry, size, context,
 				      user->call.event.type, 1, regs,
@@ -961,32 +1006,28 @@ static ssize_t user_events_write_core(struct file *file, struct iov_iter *i)
 	if (likely(atomic_read(&tp->key.enabled) > 0)) {
 		struct tracepoint_func *probe_func_ptr;
 		user_event_func_t probe_func;
+		struct iov_iter copy;
 		void *tpdata;
-		void *kdata;
-		u32 datalen;
-
-		kdata = kmalloc(i->count, GFP_KERNEL);
 
-		if (unlikely(!kdata))
-			return -ENOMEM;
-
-		datalen = copy_from_iter(kdata, i->count, i);
+		if (unlikely(iov_iter_fault_in_readable(i, i->count)))
+			return -EFAULT;
 
 		rcu_read_lock_sched();
+		pagefault_disable();
 
 		probe_func_ptr = rcu_dereference_sched(tp->funcs);
 
 		if (probe_func_ptr) {
 			do {
+				copy = *i;
 				probe_func = probe_func_ptr->func;
 				tpdata = probe_func_ptr->data;
-				probe_func(user, kdata, datalen, tpdata);
+				probe_func(user, &copy, tpdata);
 			} while ((++probe_func_ptr)->func);
 		}
 
+		pagefault_enable();
 		rcu_read_unlock_sched();
-
-		kfree(kdata);
 	}
 
 	return ret;
-- 
2.17.1

