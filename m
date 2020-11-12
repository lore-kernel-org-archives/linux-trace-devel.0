Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FFAC2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 11:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF17221FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 11:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PBk9dT20"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgKLLxV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 06:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728278AbgKLLwR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 06:52:17 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3504C0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 03:52:12 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l1so5674182wrb.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 03:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rxg/qDkcmkzIN9cuMzBkiMiMvkhFjDrl4jaDGnRZZmk=;
        b=PBk9dT20QPpNcPYv1FcZ5l2Huzahd3rIjLEywTDR/y33/rk587h4paZXHEjorKXuIp
         oYyGaSTynlotc2zSE51K/e5Pzd3l0XN4LUQcw1wa60PJbbYuweFv/NiV5L3PTHZS4ZyX
         tUsy9/k+aQS/QramMN4Rd8DucjMlUC1r1hgJ65MSoPrJsC436cxDtFBE5IPcA28sNI3O
         brzVEmJVVUnf42n8k1Oc9rEWkxsgr+UgFYmkwLCJr8gU5YfwIpHLEGqVwwpxVMT9It3w
         Gt2DFqvPrz1MoYvNaHQdDO6Mh70blXj5OoKE8nkOpbk39uH5UYNlATZR00h4A31GsZ1C
         bUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rxg/qDkcmkzIN9cuMzBkiMiMvkhFjDrl4jaDGnRZZmk=;
        b=YkV9BBqJLAqGJLfl2Km7BpFgCdPYW8S2y/LxDXbuHyYiViptlcSpDvZ6Brxt2XBG3m
         OQ/U+lImfHtBFIzZNEcAhNb8IOU77Hs4JmnU16pW7/YvFVDEvz1uD4Ji5yhI6jujHB9h
         Mj9sZhrT1JzRsRsc70J92I9bXer/2OA6oGmlmB0U+9z51U9jMGG8lulEQD8/+DBzX4NC
         3wh0SLbnO1SSFYGx33ou+lANj48UJg9P4kwSFxjdWARCDkEr5NQ9m7OVc7w8XswOsrnv
         qUI78HaVxaH9vWx3CHYMvigSHKQ1yJlZhFRIK2RjxCnOCPVSyZkzFOSZ7rbdaLSBRjaD
         TafQ==
X-Gm-Message-State: AOAM531TZOSZbxZFg5voMScu3q+2niHwo4HUQHskIfYlHw9jpsvPvT0P
        vw28idePLncGLeYwGuRSu88=
X-Google-Smtp-Source: ABdhPJzQy0eXBLgUMNcxpN2tDm/Qf/9HTWTyhJrwqPta9AcUMjSkZyalNPTAl0vYVF5Lwo4shDJK+A==
X-Received: by 2002:a05:6000:187:: with SMTP id p7mr3509251wrx.240.1605181931774;
        Thu, 12 Nov 2020 03:52:11 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d2sm1258657wra.73.2020.11.12.03.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:52:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtraceevent: Remove plugins dependencies of libtracecmd
Date:   Thu, 12 Nov 2020 13:52:07 +0200
Message-Id: <20201112115208.1250789-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112115208.1250789-1-tz.stoyanov@gmail.com>
References: <20201112115208.1250789-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

None of the libtraceevent plugins should depend on libtracecmd, they
should depend only on the traceevent library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/plugins/plugin_blk.c          | 10 +++++++---
 lib/traceevent/plugins/plugin_function.c     |  2 +-
 lib/traceevent/plugins/plugin_futex.c        |  6 +++++-
 lib/traceevent/plugins/plugin_kmem.c         |  2 +-
 lib/traceevent/plugins/plugin_sched_switch.c |  2 +-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/lib/traceevent/plugins/plugin_blk.c b/lib/traceevent/plugins/plugin_blk.c
index ea3a9cf6..04d99a21 100644
--- a/lib/traceevent/plugins/plugin_blk.c
+++ b/lib/traceevent/plugins/plugin_blk.c
@@ -8,13 +8,17 @@
 
 #include <linux/blktrace_api.h>
 
-#include "trace-cmd.h"
+#include "event-parse.h"
 
 #define MINORBITS	20
 #define MINORMASK	((1U << MINORBITS) - 1)
 #define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(_a) (sizeof(_a) / sizeof((_a)[0]))
+#endif
+
 struct blk_data {
 	unsigned long long	sector;
 	struct tep_event	*event;
@@ -129,7 +133,7 @@ static unsigned int be32_to_cpu(unsigned int val)
 {
 	unsigned int swap;
 
-	if (tracecmd_host_bigendian())
+	if (tep_is_bigendian())
 		return val;
 
 	swap = ((val & 0xffULL) << 24) |
@@ -144,7 +148,7 @@ static unsigned long long be64_to_cpu(unsigned long long val)
 {
 	unsigned long long swap;
 
-	if (tracecmd_host_bigendian())
+	if (tep_is_bigendian())
 		return val;
 
 	swap = ((val & 0xffULL) << 56) |
diff --git a/lib/traceevent/plugins/plugin_function.c b/lib/traceevent/plugins/plugin_function.c
index 938b7410..807b16e1 100644
--- a/lib/traceevent/plugins/plugin_function.c
+++ b/lib/traceevent/plugins/plugin_function.c
@@ -6,7 +6,7 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "trace-cmd.h"
+#include "event-parse.h"
 #include "event-utils.h"
 #include "trace-seq.h"
 
diff --git a/lib/traceevent/plugins/plugin_futex.c b/lib/traceevent/plugins/plugin_futex.c
index 1e235c2a..b8eb8a5f 100644
--- a/lib/traceevent/plugins/plugin_futex.c
+++ b/lib/traceevent/plugins/plugin_futex.c
@@ -10,7 +10,11 @@
 #include <string.h>
 #include <linux/futex.h>
 
-#include "trace-cmd.h"
+#include "event-parse.h"
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(_a) (sizeof(_a) / sizeof((_a)[0]))
+#endif
 
 struct futex_args {
 	unsigned long long	uaddr;
diff --git a/lib/traceevent/plugins/plugin_kmem.c b/lib/traceevent/plugins/plugin_kmem.c
index 1117bdd2..45696f12 100644
--- a/lib/traceevent/plugins/plugin_kmem.c
+++ b/lib/traceevent/plugins/plugin_kmem.c
@@ -6,7 +6,7 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "trace-cmd.h"
+#include "event-parse.h"
 #include "trace-seq.h"
 
 static int call_site_handler(struct trace_seq *s, struct tep_record *record,
diff --git a/lib/traceevent/plugins/plugin_sched_switch.c b/lib/traceevent/plugins/plugin_sched_switch.c
index 566f1661..8c90677c 100644
--- a/lib/traceevent/plugins/plugin_sched_switch.c
+++ b/lib/traceevent/plugins/plugin_sched_switch.c
@@ -6,7 +6,7 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "trace-cmd.h"
+#include "event-parse.h"
 #include "trace-seq.h"
 
 static void write_state(struct trace_seq *s, int val)
-- 
2.28.0

