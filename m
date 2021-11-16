Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36E8C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 00:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EEE161B3B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 00:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343623AbhKPA4N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:56:13 -0500
Received: from linux.microsoft.com ([13.77.154.182]:49984 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358579AbhKPAxt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 19:53:49 -0500
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id C128820C6353;
        Mon, 15 Nov 2021 16:50:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C128820C6353
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637023851;
        bh=lad/j+ot53rXPTIMEBiBmAPcSVSE3JYr+2WF4ax63Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlIOIVsKFFfloEglT1t2deWx++qNkHGak8tdIXo+V/xxKq5iGxRNgXUcBJa6WxC1B
         /97gUhbDUvcC1XsqWYB9ceNwZ57JQNu9S1Us6loZYiughqqmIJQGH8OtDy8O2JuuzO
         rqPq6/zbYzk9sHEWGNIxF2ZLvJTxBzri+MAEnpR0=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        beaub@linux.microsoft.com
Subject: [PATCH v5 01/12] user_events: Add UABI header for user access to user_events
Date:   Mon, 15 Nov 2021 16:50:36 -0800
Message-Id: <20211116005047.1808-2-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116005047.1808-1-beaub@linux.microsoft.com>
References: <20211116005047.1808-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Define the basic structs and ioctl commands that allow user processes to
interact with user_events.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 include/uapi/linux/user_events.h | 68 ++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 include/uapi/linux/user_events.h

diff --git a/include/uapi/linux/user_events.h b/include/uapi/linux/user_events.h
new file mode 100644
index 000000000000..5bff99418deb
--- /dev/null
+++ b/include/uapi/linux/user_events.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2021, Microsoft Corporation.
+ *
+ * Authors:
+ *   Beau Belgrave <beaub@linux.microsoft.com>
+ */
+#ifndef _UAPI_LINUX_USER_EVENTS_H
+#define _UAPI_LINUX_USER_EVENTS_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#ifdef __KERNEL__
+#include <linux/uio.h>
+#else
+#include <sys/uio.h>
+#endif
+
+#define USER_EVENTS_SYSTEM "user_events"
+#define USER_EVENTS_PREFIX "u:"
+
+/* Bits 0-6 are for known probe types, Bit 7 is for unknown probes */
+#define EVENT_BIT_FTRACE 0
+#define EVENT_BIT_PERF 1
+#define EVENT_BIT_OTHER 7
+
+#define EVENT_STATUS_FTRACE (1 << EVENT_BIT_FTRACE)
+#define EVENT_STATUS_PERF (1 << EVENT_BIT_PERF)
+#define EVENT_STATUS_OTHER (1 << EVENT_BIT_OTHER)
+
+/* Use raw iterator for attached BPF program(s), no affect on ftrace/perf */
+#define FLAG_BPF_ITER (1 << 0)
+
+struct user_reg {
+	__u32 size;
+	__u64 name_args;
+	__u32 status_index;
+	__u32 write_index;
+};
+
+#define DIAG_IOC_MAGIC '*'
+#define DIAG_IOCSREG _IOWR(DIAG_IOC_MAGIC, 0, struct user_reg*)
+#define DIAG_IOCSDEL _IOW(DIAG_IOC_MAGIC, 1, char*)
+
+enum {
+	USER_BPF_DATA_KERNEL,
+	USER_BPF_DATA_USER,
+	USER_BPF_DATA_ITER,
+};
+
+struct user_bpf_iter {
+	__u32 iov_offset;
+	__u32 nr_segs;
+	const struct iovec *iov;
+};
+
+struct user_bpf_context {
+	__u32 data_type;
+	__u32 data_len;
+	union {
+		void *kdata;
+		void *udata;
+		struct user_bpf_iter *iter;
+	};
+};
+
+#endif /* _UAPI_LINUX_USER_EVENTS_H */
-- 
2.17.1

