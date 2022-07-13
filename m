Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E004FC43334
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Jul 2022 21:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiGMVUQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Jul 2022 17:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237472AbiGMVTn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Jul 2022 17:19:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1CFFE4;
        Wed, 13 Jul 2022 14:19:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AE47B82024;
        Wed, 13 Jul 2022 21:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CC4C385A9;
        Wed, 13 Jul 2022 21:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657747149;
        bh=yCkYhWen7pBPp8Qaie4klyI5Sstkqz5vyoR6lpX4PQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRZXDUwWacRJ6oAJbSb/Wme8EE+/C8WAU2tZC01Iysxcr2AlJ2T+RLIyMX1qe1Ia5
         JzujN22M7FDZMrzH/Z+vxdGoj06RlBPR8XpLQ8EM21U4/lVkj3FQyUnQoLZqBG1Fir
         56ga9bVmsZFvBrcJ+I5bpb8Tf7QHI0knLscuftqY5rBfeM9uWUEHSaf5ZMT74c3h+d
         Ml8XL0acnYLpJpJ28a3XwPUyuxNGsfYrCgVLMeqZc0tOcoXqU/CGeBoCf32d4aoDm3
         IAzA7/TW8SRoLDxHTxa2mHjEikfAUbk1OIEG54rQH3kp3/dMNm0JJLfh/Pi+PUW2nm
         Fa9ebtLePQpbA==
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
Subject: [PATCH V5 16/16] rv/reactor: Add the panic reactor
Date:   Wed, 13 Jul 2022 23:17:32 +0200
Message-Id: <5b3233ed8c7bd06895cc177da8a4299d764d6f9a.1657745645.git.bristot@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1657745645.git.bristot@kernel.org>
References: <cover.1657745645.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sample reactor that panics the system when an exception is found. This
is useful both to capture a vmcore, or to fail-safe a critical system.

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
 kernel/trace/rv/Kconfig         |  8 ++++++
 kernel/trace/rv/Makefile        |  1 +
 kernel/trace/rv/reactor_panic.c | 43 +++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)
 create mode 100644 kernel/trace/rv/reactor_panic.c

diff --git a/kernel/trace/rv/Kconfig b/kernel/trace/rv/Kconfig
index f1d92d431130..ce2a90a89f55 100644
--- a/kernel/trace/rv/Kconfig
+++ b/kernel/trace/rv/Kconfig
@@ -71,3 +71,11 @@ config RV_REACT_PRINTK
 	help
 	  Enables the printk reactor. The printk reactor emits a printk()
 	  message if an exception is found.
+
+config RV_REACT_PANIC
+	bool "Panic reactor"
+	depends on RV_REACTORS
+	default y
+	help
+	  Enables the panic reactor. The panic reactor emits a printk()
+	  message if an exception is found and panic()s the system.
diff --git a/kernel/trace/rv/Makefile b/kernel/trace/rv/Makefile
index a13c750a35c1..963d14875b45 100644
--- a/kernel/trace/rv/Makefile
+++ b/kernel/trace/rv/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_RV_MON_WIP) += monitors/wip/wip.o
 obj-$(CONFIG_RV_MON_WWNR) += monitors/wwnr/wwnr.o
 obj-$(CONFIG_RV_REACTORS) += rv_reactors.o
 obj-$(CONFIG_RV_REACT_PRINTK) += reactor_printk.o
+obj-$(CONFIG_RV_REACT_PANIC) += reactor_panic.o
diff --git a/kernel/trace/rv/reactor_panic.c b/kernel/trace/rv/reactor_panic.c
new file mode 100644
index 000000000000..c9b9ed99495b
--- /dev/null
+++ b/kernel/trace/rv/reactor_panic.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019-2022 Red Hat, Inc. Daniel Bristot de Oliveira <bristot@kernel.org>
+ *
+ * Panic RV reactor:
+ *   Prints the exception msg to the kernel message log and panic().
+ */
+
+#include <linux/ftrace.h>
+#include <linux/tracepoint.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/rv.h>
+
+static void rv_panic_reaction(char *msg)
+{
+	panic(msg);
+}
+
+struct rv_reactor rv_panic = {
+	.name = "panic",
+	.description = "panic the system if an exception is found.",
+	.react = rv_panic_reaction
+};
+
+int register_react_panic(void)
+{
+	rv_register_reactor(&rv_panic);
+	return 0;
+}
+
+void unregister_react_panic(void)
+{
+	rv_unregister_reactor(&rv_panic);
+}
+
+module_init(register_react_panic);
+module_exit(unregister_react_panic);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Daniel Bristot de Oliveira");
+MODULE_DESCRIPTION("panic rv reactor: panic if an exception is found");
-- 
2.35.1

