Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983E3C46467
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 21:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbjADVmn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 16:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbjADVmh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 16:42:37 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 086661D0C1;
        Wed,  4 Jan 2023 13:42:36 -0800 (PST)
Received: from W11-BEAU-MD.localdomain (unknown [76.135.27.212])
        by linux.microsoft.com (Postfix) with ESMTPSA id 98D9F208FFCB;
        Wed,  4 Jan 2023 13:42:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 98D9F208FFCB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1672868555;
        bh=OSmDP26J8YzoMhJc3UKK7slznwSGVE3KNwggNF1IdJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPvPZKF2UMZ659OeNwBCRRaTLiJWY7UeJkUT7MU0F5HJQVZoKIhwPenRVwHRddQf1
         AAlTXZTfVhCZqLwYeHWc35FWKPpTJzvBtp3q51GyDWhMsPa5CYXYgK+hJfbD56ErKT
         ypZ8crE8v6Rhxv09mbCUhg4CrBOyWtQfaHL2f5Tw=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, dcook@linux.microsoft.com,
        alanau@linux.microsoft.com, brauner@kernel.org,
        akpm@linux-foundation.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 01/11] tracing/user_events: Split header into uapi and kernel
Date:   Wed,  4 Jan 2023 13:42:20 -0800
Message-Id: <20230104214230.26349-2-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230104214230.26349-1-beaub@linux.microsoft.com>
References: <20230104214230.26349-1-beaub@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The UAPI parts need to be split out from the kernel parts of user_events
now that other parts of the kernel will reference it. Do so by moving
the existing include/linux/user_events.h into
include/uapi/linux/user_events.h.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 include/linux/user_events.h      | 52 ++++----------------------------
 include/uapi/linux/user_events.h | 48 +++++++++++++++++++++++++++++
 kernel/trace/trace_events_user.c |  5 ---
 3 files changed, 54 insertions(+), 51 deletions(-)
 create mode 100644 include/uapi/linux/user_events.h

diff --git a/include/linux/user_events.h b/include/linux/user_events.h
index 592a3fbed98e..13689589d36e 100644
--- a/include/linux/user_events.h
+++ b/include/linux/user_events.h
@@ -1,54 +1,14 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (c) 2021, Microsoft Corporation.
+ * Copyright (c) 2022, Microsoft Corporation.
  *
  * Authors:
  *   Beau Belgrave <beaub@linux.microsoft.com>
  */
-#ifndef _UAPI_LINUX_USER_EVENTS_H
-#define _UAPI_LINUX_USER_EVENTS_H
 
-#include <linux/types.h>
-#include <linux/ioctl.h>
+#ifndef _LINUX_USER_EVENTS_H
+#define _LINUX_USER_EVENTS_H
 
-#ifdef __KERNEL__
-#include <linux/uio.h>
-#else
-#include <sys/uio.h>
-#endif
+#include <uapi/linux/user_events.h>
 
-#define USER_EVENTS_SYSTEM "user_events"
-#define USER_EVENTS_PREFIX "u:"
-
-/* Create dynamic location entry within a 32-bit value */
-#define DYN_LOC(offset, size) ((size) << 16 | (offset))
-
-/*
- * Describes an event registration and stores the results of the registration.
- * This structure is passed to the DIAG_IOCSREG ioctl, callers at a minimum
- * must set the size and name_args before invocation.
- */
-struct user_reg {
-
-	/* Input: Size of the user_reg structure being used */
-	__u32 size;
-
-	/* Input: Pointer to string with event name, description and flags */
-	__u64 name_args;
-
-	/* Output: Bitwise index of the event within the status page */
-	__u32 status_bit;
-
-	/* Output: Index of the event to use when writing data */
-	__u32 write_index;
-} __attribute__((__packed__));
-
-#define DIAG_IOC_MAGIC '*'
-
-/* Requests to register a user_event */
-#define DIAG_IOCSREG _IOWR(DIAG_IOC_MAGIC, 0, struct user_reg*)
-
-/* Requests to delete a user_event */
-#define DIAG_IOCSDEL _IOW(DIAG_IOC_MAGIC, 1, char*)
-
-#endif /* _UAPI_LINUX_USER_EVENTS_H */
+#endif /* _LINUX_USER_EVENTS_H */
diff --git a/include/uapi/linux/user_events.h b/include/uapi/linux/user_events.h
new file mode 100644
index 000000000000..03f92366068d
--- /dev/null
+++ b/include/uapi/linux/user_events.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2021-2022, Microsoft Corporation.
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
+#define USER_EVENTS_SYSTEM "user_events"
+#define USER_EVENTS_PREFIX "u:"
+
+/* Create dynamic location entry within a 32-bit value */
+#define DYN_LOC(offset, size) ((size) << 16 | (offset))
+
+/*
+ * Describes an event registration and stores the results of the registration.
+ * This structure is passed to the DIAG_IOCSREG ioctl, callers at a minimum
+ * must set the size and name_args before invocation.
+ */
+struct user_reg {
+
+	/* Input: Size of the user_reg structure being used */
+	__u32 size;
+
+	/* Input: Pointer to string with event name, description and flags */
+	__u64 name_args;
+
+	/* Output: Bitwise index of the event within the status page */
+	__u32 status_bit;
+
+	/* Output: Index of the event to use when writing data */
+	__u32 write_index;
+} __attribute__((__packed__));
+
+#define DIAG_IOC_MAGIC '*'
+
+/* Request to register a user_event */
+#define DIAG_IOCSREG _IOWR(DIAG_IOC_MAGIC, 0, struct user_reg *)
+
+/* Request to delete a user_event */
+#define DIAG_IOCSDEL _IOW(DIAG_IOC_MAGIC, 1, char *)
+
+#endif /* _UAPI_LINUX_USER_EVENTS_H */
diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 908e8a13c675..070551480747 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -19,12 +19,7 @@
 #include <linux/tracefs.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-/* Reminder to move to uapi when everything works */
-#ifdef CONFIG_COMPILE_TEST
 #include <linux/user_events.h>
-#else
-#include <uapi/linux/user_events.h>
-#endif
 #include "trace.h"
 #include "trace_dynevent.h"
 
-- 
2.25.1

