Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D08C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 00:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7402C61AFF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 00:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349076AbhKPBB6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:01:58 -0500
Received: from linux.microsoft.com ([13.77.154.182]:50136 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359162AbhKPAys (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 19:54:48 -0500
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id A891C20C635A;
        Mon, 15 Nov 2021 16:50:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A891C20C635A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637023852;
        bh=rM8MHl4ykgEOSqBXbNpd3T1p3N1pd0+DYAkgx2CZx80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgFO57oJLuH3+KWqOsmhbBu59tENG+gj9ijOKjZlMj+A7axfX4mSMvDdt2kmGSx8F
         lymSC67yonmaUMduvWTJFMh+PrnTNtB8CoqjOVCe6AqEvpBfxBMEQs9R91uum7KywZ
         3KMF+SrGNE+/XNVhhk21m27YwjcbQL6LGKej3Q8Y=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        beaub@linux.microsoft.com
Subject: [PATCH v5 05/12] user_events: Add basic perf and eBPF support
Date:   Mon, 15 Nov 2021 16:50:40 -0800
Message-Id: <20211116005047.1808-6-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116005047.1808-1-beaub@linux.microsoft.com>
References: <20211116005047.1808-1-beaub@linux.microsoft.com>
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
index 8415aaf8e3b1..badf505568dd 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -528,6 +528,50 @@ static void user_event_ftrace(struct user_event *user, void *data, u32 datalen,
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
@@ -550,6 +594,10 @@ static void update_reg_page_for(struct user_event *user)
 
 				if (probe_func == user_event_ftrace)
 					status |= EVENT_STATUS_FTRACE;
+#ifdef CONFIG_PERF_EVENTS
+				else if (probe_func == user_event_perf)
+					status |= EVENT_STATUS_PERF;
+#endif
 				else
 					status |= EVENT_STATUS_OTHER;
 			} while ((++probe_func_ptr)->func);
@@ -591,7 +639,19 @@ static int user_event_reg(struct trace_event_call *call,
 
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
@@ -849,6 +909,9 @@ static int user_event_parse(char *name, char *args, char *flags,
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

