Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4938DC433E2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ADE0206B7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvxYLiwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403852AbgFYKF3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403816AbgFYKF2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:05:28 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33557C061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:28 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k6so5221664wrn.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BinqAEUtdZ/Bn5f8nA7mhTC6/MdAhgdFgfWDsE1Ywfw=;
        b=HvxYLiwUemvsexpIF2FKrBv+57+TtnWOWVHiCiC9LsYCiouqRXvNDfA9GT/T644pBX
         VqsGCrbYwaHSDiETTVllJq06eUdjYAokf+IDvXL0hUf72/yjbMdcKoLzal4qgRX3x4Vz
         XIx1wUgK3hokWHpFdIdRi7dI49QVSdxQ67AmB/FV0A5s3Ot8IqApo8/RZQrfkCtDVIRD
         9EVEDs+W8+Vrc/4+vG2j1uVOdEcnCliUpzY/+TnqU60nuTfSs1q7B+g6CIMTxmSzF3b4
         wIQeaTi1Y5kPqGj9xX4q6LONyjilvKzv7LuLCWJbp/UbiZTxAT9oaD4iAZ5gQjyBTvIm
         iEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BinqAEUtdZ/Bn5f8nA7mhTC6/MdAhgdFgfWDsE1Ywfw=;
        b=kldWsdKeVxTsomEaGl72opHzfXAfuiX/TvYviUJB3Vbqrs/it7BsW4D+FWF2MO7vHQ
         rp9L/rJhiPH5E+pdk7Mdb8ePME1zCgKIurYqy2smiNX/Zoz+THKstAzltRe1f/OxMFpJ
         RtoUL1jU2ll7IgkVYVTvhde85uitzx2OQogh5fdNgsmK1mUf/Be+iOW00X+wFlWvXExk
         J3Q6vKOoc1A9UtcIjqpiD5e2L1aUTMLm4RyReseq/Y/mxNGQh/lI4K1gWsmm9a76T4Xy
         yMQqejhKIeHcxWXB619NmelLuwg2mBSZm935+jh65bbHOIP9yfHtr4n4jli+A80R8sd0
         DfHw==
X-Gm-Message-State: AOAM533qoYHJLmZaLPDCVGD5etWGpYPv73UeaHXx3nvnfu6hJXL0iFEL
        bNwVFjtbzwyuS8ceiAev4tM=
X-Google-Smtp-Source: ABdhPJxPRvd53VMOJn9Qneuferbkg7GKn775UGR9VGSNGJ8jmcq2RDbMVyk2Hj37vTEQ3RLBOb7Mow==
X-Received: by 2002:a5d:4bc8:: with SMTP id l8mr20203349wrt.159.1593079526890;
        Thu, 25 Jun 2020 03:05:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v7sm31268204wrp.45.2020.06.25.03.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:05:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/15] tools lib traceevent: Add plugin for tlb_flush
Date:   Thu, 25 Jun 2020 13:05:15 +0300
Message-Id: <20200625100516.365338-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625100516.365338-1-tz.stoyanov@gmail.com>
References: <20200625100516.365338-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (Red Hat) <rostedt@goodmis.org>

The tlb_flush tracepoints uses enums that are not yet known by
trace-cmd. Add a plugin to handle that.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/plugins/Build        |  1 +
 tools/lib/traceevent/plugins/Makefile     |  1 +
 tools/lib/traceevent/plugins/plugin_tlb.c | 81 +++++++++++++++++++++++
 3 files changed, 83 insertions(+)
 create mode 100644 tools/lib/traceevent/plugins/plugin_tlb.c

diff --git a/tools/lib/traceevent/plugins/Build b/tools/lib/traceevent/plugins/Build
index 210d26910613..b866f231a536 100644
--- a/tools/lib/traceevent/plugins/Build
+++ b/tools/lib/traceevent/plugins/Build
@@ -8,3 +8,4 @@ plugin_function-y     += plugin_function.o
 plugin_xen-y          += plugin_xen.o
 plugin_scsi-y         += plugin_scsi.o
 plugin_cfg80211-y     += plugin_cfg80211.o
+plugin_tlb-y          += plugin_tlb.o
\ No newline at end of file
diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
index 349bb81482ab..8e72707e8630 100644
--- a/tools/lib/traceevent/plugins/Makefile
+++ b/tools/lib/traceevent/plugins/Makefile
@@ -137,6 +137,7 @@ PLUGINS += plugin_function.so
 PLUGINS += plugin_xen.so
 PLUGINS += plugin_scsi.so
 PLUGINS += plugin_cfg80211.so
+PLUGINS += plugin_tlb.so
 
 PLUGINS    := $(addprefix $(OUTPUT),$(PLUGINS))
 PLUGINS_IN := $(PLUGINS:.so=-in.o)
diff --git a/tools/lib/traceevent/plugins/plugin_tlb.c b/tools/lib/traceevent/plugins/plugin_tlb.c
new file mode 100644
index 000000000000..1adade776306
--- /dev/null
+++ b/tools/lib/traceevent/plugins/plugin_tlb.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (C) 2015 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
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
+
+#include "event-parse.h"
+
+enum tlb_flush_reason {
+	TLB_FLUSH_ON_TASK_SWITCH,
+	TLB_REMOTE_SHOOTDOWN,
+	TLB_LOCAL_SHOOTDOWN,
+	TLB_LOCAL_MM_SHOOTDOWN,
+	NR_TLB_FLUSH_REASONS,
+};
+
+static int tlb_flush_handler(struct trace_seq *s, struct tep_record *record,
+			     struct tep_event *event, void *context)
+{
+	unsigned long long val;
+
+	trace_seq_printf(s, "pages=");
+
+	tep_print_num_field(s, "%ld", event, "pages", record, 1);
+
+	if (tep_get_field_val(s, event, "reason", record, &val, 1) < 0)
+		return -1;
+
+	trace_seq_puts(s, " reason=");
+
+	switch (val) {
+	case TLB_FLUSH_ON_TASK_SWITCH:
+		trace_seq_puts(s, "flush on task switch");
+		break;
+	case TLB_REMOTE_SHOOTDOWN:
+		trace_seq_puts(s, "remote shootdown");
+		break;
+	case TLB_LOCAL_SHOOTDOWN:
+		trace_seq_puts(s, "local shootdown");
+		break;
+	case TLB_LOCAL_MM_SHOOTDOWN:
+		trace_seq_puts(s, "local mm shootdown");
+		break;
+	}
+
+	trace_seq_printf(s, " (%lld)", val);
+
+	return 0;
+}
+
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
+{
+	tep_register_event_handler(tep, -1, "tlb", "tlb_flush",
+				   tlb_flush_handler, NULL);
+
+	return 0;
+}
+
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
+{
+	tep_unregister_event_handler(tep, -1,
+				     "tlb", "tlb_flush",
+				     tlb_flush_handler, NULL);
+}
-- 
2.26.2

