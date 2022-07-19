Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAF4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Jul 2022 17:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbiGSR3j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Jul 2022 13:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbiGSR3M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Jul 2022 13:29:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8232C5A898;
        Tue, 19 Jul 2022 10:28:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EE3BB81C94;
        Tue, 19 Jul 2022 17:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E0AC385A2;
        Tue, 19 Jul 2022 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658251729;
        bh=jMZVeCFNG4dpHgeQfS2wMhntLm6EIEbS/wXdQsl3uxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHBMj2xAvM9mqa1rYEA/UJk5kjvaCARRCZTSkP+1GMoJ4A9xbrNFcTsKhg/vP/7SD
         imj/Ue2qtRhMCmWmUZzaYOG6bRrcwFGcud440hG1nH14v3QDuZvetWYNWs5eyejqwq
         F/ycOfB5ActO7/DlVfHgtgJ3Sh/U/0jDk2hNrfJkvfc9aw3y40uxyGXlZ2Nr6XdCfT
         bUGpoGEUFbVmrtH7H4DRiSlGcXudqAdlriQdFqXUlvKFuBOovA1euHS9gJyw8+YTgs
         w+lNfSkHIUgiEPMAy8kFDSwTLNrKaflUBYweZRA98YilREsQ4bAnMTxLpv+jJu9TPB
         utNb+wFWBaXXw==
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
Subject: [PATCH V6 15/16] rv/reactor: Add the printk reactor
Date:   Tue, 19 Jul 2022 19:27:20 +0200
Message-Id: <ad355eb25b933124e6e24045f6331ada5bf7adb3.1658244826.git.bristot@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1658244826.git.bristot@kernel.org>
References: <cover.1658244826.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A reactor that printks the reaction message.

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
 kernel/trace/rv/Kconfig          |  8 ++++++
 kernel/trace/rv/Makefile         |  3 ++-
 kernel/trace/rv/reactor_printk.c | 42 ++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100644 kernel/trace/rv/reactor_printk.c

diff --git a/kernel/trace/rv/Kconfig b/kernel/trace/rv/Kconfig
index d8c40fd67e88..f1d92d431130 100644
--- a/kernel/trace/rv/Kconfig
+++ b/kernel/trace/rv/Kconfig
@@ -63,3 +63,11 @@ config RV_REACTORS
 	  on the model's execution. By default, the monitors have
 	  tracing reactions, printing the monitor output via tracepoints,
 	  but other reactions can be added (on-demand) via this interface.
+
+config RV_REACT_PRINTK
+	bool "Printk reactor"
+	depends on RV_REACTORS
+	default y
+	help
+	  Enables the printk reactor. The printk reactor emits a printk()
+	  message if an exception is found.
diff --git a/kernel/trace/rv/Makefile b/kernel/trace/rv/Makefile
index af0ff9a46418..a13c750a35c1 100644
--- a/kernel/trace/rv/Makefile
+++ b/kernel/trace/rv/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_RV) += rv.o
-obj-$(CONFIG_RV_REACTORS) += rv_reactors.o
 obj-$(CONFIG_RV_MON_WIP) += monitors/wip/wip.o
 obj-$(CONFIG_RV_MON_WWNR) += monitors/wwnr/wwnr.o
+obj-$(CONFIG_RV_REACTORS) += rv_reactors.o
+obj-$(CONFIG_RV_REACT_PRINTK) += reactor_printk.o
diff --git a/kernel/trace/rv/reactor_printk.c b/kernel/trace/rv/reactor_printk.c
new file mode 100644
index 000000000000..8b5c70b05634
--- /dev/null
+++ b/kernel/trace/rv/reactor_printk.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019-2022 Red Hat, Inc. Daniel Bristot de Oliveira <bristot@kernel.org>
+ *
+ * Printk RV reactor:
+ *   Prints the exception msg to the kernel message log.
+ */
+#include <linux/ftrace.h>
+#include <linux/tracepoint.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/rv.h>
+
+static void rv_printk_reaction(char *msg)
+{
+	printk_deferred(msg);
+}
+
+static struct rv_reactor rv_printk = {
+	.name = "printk",
+	.description = "prints the exception msg to the kernel message log",
+	.react = rv_printk_reaction
+};
+
+static int register_react_printk(void)
+{
+	rv_register_reactor(&rv_printk);
+	return 0;
+}
+
+static void unregister_react_printk(void)
+{
+	rv_unregister_reactor(&rv_printk);
+}
+
+module_init(register_react_printk);
+module_exit(unregister_react_printk);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Daniel Bristot de Oliveira");
+MODULE_DESCRIPTION("printk rv reactor: printk if an exception is hit");
-- 
2.35.1

