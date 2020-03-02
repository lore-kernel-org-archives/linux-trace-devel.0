Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70D1C3F2D7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 735D8208C3
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PFed5VQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgCBKON (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:14:13 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38148 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgCBKON (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 05:14:13 -0500
Received: by mail-lf1-f67.google.com with SMTP id w22so6535169lfk.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 02:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g+/tLfKlbgwIdY98GGr7oJqOHDp5IFnUgbzS+y3tRIU=;
        b=PFed5VQViJJquZwbhG7gVFgZo4jEPbNnirdQREvRXjX/5+mVDD0MfF2DwZry+NJZs3
         zh/FcMVcA7PMWRoghDko88WPoCENNX3GXDdxXYu+E2CWYISPV2YFskPsujNNrobUXbap
         rpyWHo5Q2PUG2OezINk9QxFH3BXheMLUhrZJVhQK8mz+oJnMZyEbwQhHaPNmxMAOekxY
         l2r9z/fwlyqpG3dN4HGpELL/4CZrxKgz1VGBCOwZ8Fr6rvz7oGdomn9G+CpDul+NbZmy
         +dgAfRSPHXcKnvZms+8ae+0TJmYS7qS4P/bpl2SbuVySPFjN/MrSYRJAEiIQVneQaYSn
         SGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+/tLfKlbgwIdY98GGr7oJqOHDp5IFnUgbzS+y3tRIU=;
        b=JBYkV0JkRNbVCMc+p25wzMi2UR44UJAi6QrNuHKzgys4yQmpB5Xpmcn49HTuYy6Etr
         Yeb/nqAFKhFM55QFI9y2zDxxqyZwWNJGDGahzVJh2zsY3zQzi2dSyvcTtqoxfNAs7cTx
         p5JvX1qHvoU/vOjRkEetVNaWzWA32hE0jdNuxx4AESTQD3PrUPTIeJ17iCJmmix5UJnd
         8KXnNvlqkjS7/xDl0+YjeQ17YY1vmVDJS2Dq6kLMuW+Sa8Y8rZ4C/cxyL0eAj6le0iDr
         Lbq7HsyoL3RH6xJSbqP9oeuoP/RXf5aftJrnfOxoEhpKn7XZHSpWt2ZrzqUWS+zG/140
         q70A==
X-Gm-Message-State: ANhLgQ0QUSSDoGh4LqzQAgISeqZmraZXlegv6mqi40fo8lMCt5jXmSwu
        nVHylYLbSoBAeoUow09y7GY9H5+a
X-Google-Smtp-Source: ADFU+vuNo0fHEd2h24Yv32vu0jP2zhydZNcj/lJ3csaDMr9AxryXFiiln5Iqv4+JUbCjSYrifzc5tQ==
X-Received: by 2002:ac2:5bcd:: with SMTP id u13mr10372294lfn.116.1583144051168;
        Mon, 02 Mar 2020 02:14:11 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x10sm11048236ljd.68.2020.03.02.02.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:14:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v21 03/13] trace-cmd: Add new API to generate a unique ID of the tracing session
Date:   Mon,  2 Mar 2020 12:13:54 +0200
Message-Id: <20200302101404.150035-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302101404.150035-1-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new libtracecmd API is implemented:
	unsigned long long tracecmd_generate_traceid(void);
At trace-cmd init phase a unique ID, used for the current tracing session.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h  |  1 +
 lib/trace-cmd/trace-util.c     | 37 ++++++++++++++++++++++++++++++++++
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-record.c        |  1 +
 4 files changed, 40 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index b6393a89..7519e82a 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -415,6 +415,7 @@ void tracecmd_plog_error(const char *fmt, ...);
 int tracecmd_set_logfile(char *logfile);
 
 /* --- System --- */
+unsigned long long tracecmd_generate_traceid(void);
 int tracecmd_count_cpus(void);
 
 /* --- Hack! --- */
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b8841393..04dc804c 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -18,6 +18,8 @@
 #include <sys/mount.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/sysinfo.h>
+#include <time.h>
 
 #include "trace-cmd.h"
 #include "event-utils.h"
@@ -510,3 +512,38 @@ int tracecmd_count_cpus(void)
 
 	return cpus;
 }
+
+#define FNV_64_PRIME 0x100000001b3ULL
+/*
+ * tracecmd_generate_traceid - Generate a unique ID, used to identify
+ *			       the current tracing session
+ *
+ * Returns unique ID
+ */
+unsigned long long tracecmd_generate_traceid(void)
+{
+	unsigned long long hash = 0;
+	unsigned char *ustr;
+	struct sysinfo sinfo;
+	struct timespec ts;
+	char *str = NULL;
+
+	clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
+	sysinfo(&sinfo);
+	asprintf(&str, "%ld %ld %ld %ld %ld %ld %ld %ld %d",
+		 ts.tv_sec, ts.tv_nsec,
+		 sinfo.loads[0], sinfo.loads[1], sinfo.loads[2],
+		 sinfo.freeram, sinfo.sharedram, sinfo.freeswap,
+		 sinfo.procs);
+	if (!str)
+		return 0;
+	ustr = (unsigned char *)str;
+	hash = 0;
+	while (*ustr) {
+		hash ^= (unsigned long long)*ustr++;
+		hash *= FNV_64_PRIME;
+	}
+
+	free(str);
+	return hash;
+}
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a5cf0640..6fe22bb0 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -185,6 +185,7 @@ struct pid_addr_maps {
 struct buffer_instance {
 	struct buffer_instance	*next;
 	struct tracefs_instance	*tracefs;
+	unsigned long long	trace_id;
 	char			*cpumask;
 	struct event_list	*events;
 	struct event_list	**event_next;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3cbc832c..ef05bbc6 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5246,6 +5246,7 @@ void init_top_instance(void)
 		top_instance.tracefs = tracefs_instance_alloc(NULL);
 	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
+	top_instance.trace_id = tracecmd_generate_traceid();
 	init_instance(&top_instance);
 }
 
-- 
2.24.1

