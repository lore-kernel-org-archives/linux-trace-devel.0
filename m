Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84FAC04A68
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Jul 2022 18:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243276AbiG0SKS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Jul 2022 14:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243287AbiG0SJj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Jul 2022 14:09:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC4CCFE69;
        Wed, 27 Jul 2022 10:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8CD1B821E3;
        Wed, 27 Jul 2022 17:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81300C433D7;
        Wed, 27 Jul 2022 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658941953;
        bh=tFQeIFcFJY3lIF68AI4Lr4svxai5erbmpSh5Zi8+S+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBAcXj+HivFj4maiTMPOwCDidH2skt5nSBTBRq8M/W9VYzdDOofNJ2pq65zEiA1xo
         jBjXrHdhtp3VejSOyBs83EeSu+PYkGEiQu+KVnDxcgImmW3yb8luHLSxpJz+zVzBfj
         7mmRBHFvwNDGXbCjBAVrVVmXZZp96fRW4AQuwmfxZQhoa/aFJkq+mqwCDPJV8RrQob
         3JC8YO678mpkgEi994chSgGqRucfYxVLKfejf1hmnYq4H5m/wXElIdFDFP92Y5FYzB
         T33MBWEzRHDq/zbLvqmo7kGb0hADsLrWCA374PDSFv3AnG67mYnEVl5dlkqRwARVKu
         QHXktmE3RdS7w==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Tao Zhou <tao.zhou@linux.dev>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH V8 05/16] rv/include: Add instrumentation helper functions
Date:   Wed, 27 Jul 2022 19:11:33 +0200
Message-Id: <c6c8e0f34e9b476cef24763a9fde63b7d8014fd8.1658940828.git.bristot@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1658940828.git.bristot@kernel.org>
References: <cover.1658940828.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Instrumentation helper functions to facilitate the instrumentation of
auto-generated RV monitors create by dot2k.

Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Gabriele Paoloni <gpaoloni@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Tao Zhou <tao.zhou@linux.dev>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 include/rv/instrumentation.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 include/rv/instrumentation.h

diff --git a/include/rv/instrumentation.h b/include/rv/instrumentation.h
new file mode 100644
index 000000000000..d4e7a02ede1a
--- /dev/null
+++ b/include/rv/instrumentation.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019-2022 Red Hat, Inc. Daniel Bristot de Oliveira <bristot@kernel.org>
+ *
+ * Helper functions to facilitate the instrumentation of auto-generated
+ * RV monitors create by dot2k.
+ *
+ * The dot2k tool is available at tools/verification/dot2/
+ */
+
+#include <linux/ftrace.h>
+
+/*
+ * rv_attach_trace_probe - check and attach a handler function to a tracepoint
+ */
+#define rv_attach_trace_probe(monitor, tp, rv_handler)					\
+	do {										\
+		check_trace_callback_type_##tp(rv_handler);				\
+		WARN_ONCE(register_trace_##tp(rv_handler, NULL),			\
+				"fail attaching " #monitor " " #tp "handler");		\
+	} while (0)
+
+/*
+ * rv_detach_trace_probe - detach a handler function to a tracepoint
+ */
+#define rv_detach_trace_probe(monitor, tp, rv_handler)					\
+	do {										\
+		unregister_trace_##tp(rv_handler, NULL);				\
+	} while (0)
-- 
2.35.1

