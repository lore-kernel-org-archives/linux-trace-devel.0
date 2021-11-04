Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7689C4321E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A92DB610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhKDRHR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:07:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54218 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhKDRHQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 13:07:16 -0400
Received: from localhost.localdomain (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 58A0420B9D56;
        Thu,  4 Nov 2021 10:04:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 58A0420B9D56
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636045478;
        bh=NTGnw12ZWarE2jLGXYX05L387yaE4HHNvnnd9F3t9/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLNOHz48eIX6tC8uMhjv5zKjExf/sHaG8QBx1feIQFVrQoiwFkZ3jQwBvFKTAPNog
         E0oSx+07dJgHKVz5Hq74AzoH2Ck+Zxa9xj47gyh5fyifz+EYg/kw1a1yuqMyXgTeMZ
         PyUzH9KzHPBR98lAMxWYxcd9/1Av7alGNIZ2qsfo=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        beaub@linux.microsoft.com
Subject: [PATCH v4 05/10] user_events: Add basic perf and eBPF support
Date:   Thu,  4 Nov 2021 10:04:28 -0700
Message-Id: <20211104170433.2206-6-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211104170433.2206-1-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adds support to write out user_event data to perf_probe/perf files as
well as to any attached eBPF program.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 kernel/trace/trace_events_user.c | 63 ++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index cd78cc481557..b5fe0550b489 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -516,6 +516,50 @@ static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
 	trace_event_buffer_commit(&event_buffer);
 }
 
+#ifdef CONFIG_PERF_EVENTS
+/*
+ * Writes the user supplied payload out to perf ring buffer or eBPF program.
+ */
+static void user_event_perf(struct user_event *user, void *data, u32 datalen,
+			    void *tpdata)
+{
+	struct hlist_head *perf_head;
+
+	if (bpf_prog_array_valid(&user->call)) {
+		struct user_bpf_context context = {0};
+
+		context.data_len = datalen;
+		context.data_type = USER_BPF_DATA_KERNEL;
+		context.kdata = data;
+
+		trace_call_bpf(&user->call, &context);
+	}
+
+	perf_head = this_cpu_ptr(user->call.perf_events);
+
+	if (perf_head && !hlist_empty(perf_head)) {
+		struct trace_entry *perf_entry;
+		struct pt_regs *regs;
+		size_t size = sizeof(*perf_entry) + datalen;
+		int context;
+
+		perf_entry = perf_trace_buf_alloc(ALIGN(size, 8),
+						  &regs, &context);
+
+		if (unlikely(!perf_entry))
+			return;
+
+		perf_fetch_caller_regs(regs);
+
+		memcpy(perf_entry + 1, data, datalen);
+
+		perf_trace_buf_submit(perf_entry, size, context,
+				      user->call.event.type, 1, regs,
+				      perf_head, NULL);
+	}
+}
+#endif
+
 /*
  * Update the register page that is shared between user processes.
  */
@@ -538,6 +582,10 @@ static void update_reg_page_for(struct user_event *user)
 
 				if (probe_func == user_event_ftrace)
 					status |= EVENT_STATUS_FTRACE;
+#ifdef CONFIG_PERF_EVENTS
+				else if (probe_func == user_event_perf)
+					status |= EVENT_STATUS_PERF;
+#endif
 				else
 					status |= EVENT_STATUS_OTHER;
 			} while ((++probe_func_ptr)->func);
@@ -579,7 +627,19 @@ static int user_event_reg(struct trace_event_call *call,
 
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
+		ret = tracepoint_probe_register(call->tp,
+						call->class->perf_probe,
+						data);
+		if (!ret)
+			goto inc;
+		break;
+
 	case TRACE_REG_PERF_UNREGISTER:
+		tracepoint_probe_unregister(call->tp,
+					    call->class->perf_probe,
+					    data);
+		goto dec;
+
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
 	case TRACE_REG_PERF_ADD:
@@ -821,6 +881,9 @@ static int user_event_parse(char *name, char *args, char *flags,
 	user->class.get_fields = user_event_get_fields;
 	user->class.reg = user_event_reg;
 	user->class.probe = user_event_ftrace;
+#ifdef CONFIG_PERF_EVENTS
+	user->class.perf_probe = user_event_perf;
+#endif
 
 	mutex_lock(&event_mutex);
 	ret = user_event_trace_register(user);
-- 
2.17.1

