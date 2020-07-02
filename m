Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06908C433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA4FC20702
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sVfDuN1g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgGBRt6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgGBRt5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:49:57 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDAEC08C5C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Jul 2020 10:49:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o2so29259502wmh.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Jul 2020 10:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JN/PzF7TXkxaRvoflC5fkupSSO71kOQ2lX/liH+ja0U=;
        b=sVfDuN1gNbYh2/y87PrmVnRhAh7E+w7C/iJleegEL/9ESyuQU4YFDbyWXZzjZlp6Pp
         GBFCvn6RyXs1klJKninnAeOAILnANTTiQx95s6Z9JMCtGQ9UlV0PyHMc0W1ADUDaN6px
         2s4zBQnoKh05lANoAiHxXTjOL1M1dK7GfnKEqFBxliPzgf1nVVweLKYDL8MNW71GS5nC
         O72EF9B9HSNi4h693QK7ykd4/YkOf9W099YcPFqXBXxzYtoM5vHUwqytioMr/C1yILLF
         jz5G6QBQj7CI/4OtOo0W/5Ved0oI76i3GvVNbvRsV63lz6x3/1v/zJQgPmQFIk3EzETD
         W9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JN/PzF7TXkxaRvoflC5fkupSSO71kOQ2lX/liH+ja0U=;
        b=ZRB4QQ6m/TdDKdFw3EBQ9fNXMRZG/6f8QIrxP+NWPdKztJCDEAbtLilFhwIqPtnhaI
         fmceXDDOJ30tNXBN2fBmPz47er/1nBGo05Pgeah8oqgrUTxWIwMfsLCL34i48u1U+17v
         znUDeVo9GInXAujR0gV43+T0b2yyZ3LUUxi9ZnHgKa7pkD+JXLDheApcC68viJ64fG/7
         Znrj0dkj3wpKLPWkX+6N84gE09UgrY8xw0ZVf5HgrM1JprK34CSV2drxqtw6Lr/b9+Iq
         ec4LsbxqEsnpxObmi16r4HCNdLqwNIcPq247bKaS04vecbnlHaM9l7JEd1Ir0cTVml0H
         6U0Q==
X-Gm-Message-State: AOAM533pocMfvOfI3lwpAozQvcVAin48JRG+DHDK47I4q/OXnftXOf9t
        MZbmfIFOuqO/zWw4LYnnyinSNqEJr98=
X-Google-Smtp-Source: ABdhPJyMI+oQnWHNMIiYqxw9j539BgEOkB9CI+5iKDYH9VC1K7qqdTtwPWQKp7jD8Fayx3vSuH7T3g==
X-Received: by 2002:a1c:b4c2:: with SMTP id d185mr31223792wmf.57.1593712196126;
        Thu, 02 Jul 2020 10:49:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g82sm9289319wma.37.2020.07.02.10.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 10:49:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/15] tools lib traceevent: Add plugin for decoding syscalls/sys_enter_futex
Date:   Thu,  2 Jul 2020 20:49:46 +0300
Message-Id: <20200702174950.123454-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702174950.123454-1-tz.stoyanov@gmail.com>
References: <20200702174950.123454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Julia Cartwright <julia@ni.com>

The futex syscall is a complicated one.  It supports thirteen
multiplexed operations, each with different semantics and encodings for
the syscalls six arguments.

Manually decoding these arguments is tedious and error prone.

This plugin provides symbolic names for futex operations, futex flags,
and tries to be intelligent about the intent of specific arguments (for
example, waking operations use 'val' as an integer count, not just an
arbitrary value).

It doesn't do a full decode of the FUTEX_WAKE_OP's 'val3' argument,
however, this is a good starting point.

Link: http://lkml.kernel.org/r/20171207025649.12160-1-julia@ni.com

Signed-off-by: Julia Cartwright <julia@ni.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/plugins/Build          |   1 +
 tools/lib/traceevent/plugins/Makefile       |   1 +
 tools/lib/traceevent/plugins/plugin_futex.c | 137 ++++++++++++++++++++
 3 files changed, 139 insertions(+)
 create mode 100644 tools/lib/traceevent/plugins/plugin_futex.c

diff --git a/tools/lib/traceevent/plugins/Build b/tools/lib/traceevent/plugins/Build
index b866f231a536..dd4da823c38f 100644
--- a/tools/lib/traceevent/plugins/Build
+++ b/tools/lib/traceevent/plugins/Build
@@ -5,6 +5,7 @@ plugin_kvm-y          += plugin_kvm.o
 plugin_mac80211-y     += plugin_mac80211.o
 plugin_sched_switch-y += plugin_sched_switch.o
 plugin_function-y     += plugin_function.o
+plugin_futex-y        += plugin_futex.o
 plugin_xen-y          += plugin_xen.o
 plugin_scsi-y         += plugin_scsi.o
 plugin_cfg80211-y     += plugin_cfg80211.o
diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
index 8e72707e8630..946a4d31fcaf 100644
--- a/tools/lib/traceevent/plugins/Makefile
+++ b/tools/lib/traceevent/plugins/Makefile
@@ -134,6 +134,7 @@ PLUGINS += plugin_kvm.so
 PLUGINS += plugin_mac80211.so
 PLUGINS += plugin_sched_switch.so
 PLUGINS += plugin_function.so
+PLUGINS += plugin_futex.so
 PLUGINS += plugin_xen.so
 PLUGINS += plugin_scsi.so
 PLUGINS += plugin_cfg80211.so
diff --git a/tools/lib/traceevent/plugins/plugin_futex.c b/tools/lib/traceevent/plugins/plugin_futex.c
new file mode 100644
index 000000000000..5d76df141401
--- /dev/null
+++ b/tools/lib/traceevent/plugins/plugin_futex.c
@@ -0,0 +1,137 @@
+/*
+ * Copyright (C) 2017 National Instruments Corp.
+ *
+ * Author: Julia Cartwright <julia@ni.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/futex.h>
+
+#include "event-parse.h"
+
+#define ARRAY_SIZE(_a) (sizeof(_a) / sizeof((_a)[0]))
+
+struct futex_args {
+	unsigned long long	uaddr;
+	unsigned long long	op;
+	unsigned long long	val;
+	unsigned long long	utime; /* or val2 */
+	unsigned long long	uaddr2;
+	unsigned long long	val3;
+};
+
+struct futex_op {
+	const char	*name;
+	const char	*fmt_val;
+	const char	*fmt_utime;
+	const char	*fmt_uaddr2;
+	const char	*fmt_val3;
+};
+
+static const struct futex_op futex_op_tbl[] = {
+	{            "FUTEX_WAIT", " val=0x%08llx", " utime=0x%08llx",               NULL,             NULL },
+	{            "FUTEX_WAKE",     " val=%llu",              NULL,               NULL,             NULL },
+	{              "FUTEX_FD",     " val=%llu",              NULL,               NULL,             NULL },
+	{         "FUTEX_REQUEUE",     " val=%llu",      " val2=%llu", " uaddr2=0x%08llx",             NULL },
+	{     "FUTEX_CMP_REQUEUE",     " val=%llu",      " val2=%llu", " uaddr2=0x%08llx", " val3=0x%08llx" },
+	{         "FUTEX_WAKE_OP",     " val=%llu",      " val2=%llu", " uaddr2=0x%08llx", " val3=0x%08llx" },
+	{         "FUTEX_LOCK_PI",            NULL, " utime=0x%08llx",               NULL,             NULL },
+	{       "FUTEX_UNLOCK_PI",            NULL,              NULL,               NULL,             NULL },
+	{      "FUTEX_TRYLOCK_PI",            NULL,              NULL,               NULL,             NULL },
+	{     "FUTEX_WAIT_BITSET", " val=0x%08llx", " utime=0x%08llx",               NULL, " val3=0x%08llx" },
+	{     "FUTEX_WAKE_BITSET",     " val=%llu",              NULL,               NULL, " val3=0x%08llx" },
+	{ "FUTEX_WAIT_REQUEUE_PI", " val=0x%08llx", " utime=0x%08llx", " uaddr2=0x%08llx", " val3=0x%08llx" },
+	{  "FUTEX_CMP_REQUEUE_PI",     " val=%llu",      " val2=%llu", " uaddr2=0x%08llx", " val3=0x%08llx" },
+};
+
+
+static void futex_print(struct trace_seq *s, const struct futex_args *args,
+			const struct futex_op *fop)
+{
+	trace_seq_printf(s, " uaddr=0x%08llx", args->uaddr);
+
+	if (fop->fmt_val)
+		trace_seq_printf(s, fop->fmt_val, args->val);
+
+	if (fop->fmt_utime)
+		trace_seq_printf(s,fop->fmt_utime, args->utime);
+
+	if (fop->fmt_uaddr2)
+		trace_seq_printf(s, fop->fmt_uaddr2, args->uaddr2);
+
+	if (fop->fmt_val3)
+		trace_seq_printf(s, fop->fmt_val3, args->val3);
+}
+
+static int futex_handler(struct trace_seq *s, struct tep_record *record,
+			 struct tep_event *event, void *context)
+{
+	const struct futex_op *fop;
+	struct futex_args args;
+	unsigned long long cmd;
+
+	if (tep_get_field_val(s, event, "uaddr", record, &args.uaddr, 1))
+		return 1;
+
+	if (tep_get_field_val(s, event, "op", record, &args.op, 1))
+		return 1;
+
+	if (tep_get_field_val(s, event, "val", record, &args.val, 1))
+		return 1;
+
+	if (tep_get_field_val(s, event, "utime", record, &args.utime, 1))
+		return 1;
+
+	if (tep_get_field_val(s, event, "uaddr2", record, &args.uaddr2, 1))
+		return 1;
+
+	if (tep_get_field_val(s, event, "val3", record, &args.val3, 1))
+		return 1;
+
+	cmd = args.op & FUTEX_CMD_MASK;
+	if (cmd >= ARRAY_SIZE(futex_op_tbl))
+		return 1;
+
+	fop = &futex_op_tbl[cmd];
+
+	trace_seq_printf(s, "op=%s", fop->name);
+
+	if (args.op & FUTEX_PRIVATE_FLAG)
+		trace_seq_puts(s, "|FUTEX_PRIVATE_FLAG");
+
+	if (args.op & FUTEX_CLOCK_REALTIME)
+		trace_seq_puts(s, "|FUTEX_CLOCK_REALTIME");
+
+	futex_print(s, &args, fop);
+	return 0;
+}
+
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
+{
+	tep_register_event_handler(tep, -1, "syscalls", "sys_enter_futex",
+				   futex_handler, NULL);
+	return 0;
+}
+
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
+{
+	tep_unregister_event_handler(tep, -1, "syscalls", "sys_enter_futex",
+				     futex_handler, NULL);
+}
-- 
2.26.2

