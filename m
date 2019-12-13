Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C4CC3B194
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6310246B1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vApciD0K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfLMPar (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:47 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46561 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbfLMPar (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:47 -0500
Received: by mail-lj1-f195.google.com with SMTP id z17so3051101ljk.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G07fCPUdQdBMBllS1oQw6U63n3YSWPV/vSRXIRNprWw=;
        b=vApciD0KE86RHSKYu8E85yFPtQS7UoHZonUHHfzv/Zu3fblX6LwNi7XfLHz+NM3t2s
         UVy/AwTEzrnDSnHD988HLVuhWCMjBCjj2Zu+fW2MHrzCYY6i4IB4sCHSWqkwkA8JPo/1
         xD4bTDF8iGeLAtgUPYVAek3xJDOU0NQ6NlzjXs/utYmZAcuR9+opctdDOWPtZ0/QYUZz
         L1u3Y8l4nrCW8aeHYoyPQaRfzm2G1BueEVqXoiSJtWM+fX0vqIkSJGaa3tFXeg6Sa6u+
         7J6CENx8f+0VY/MpuSsPPaqxXyQ/i8FEdwDc7pCmechF8QQEHLmnG54OgfMcZ7ZQ0wHz
         uVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G07fCPUdQdBMBllS1oQw6U63n3YSWPV/vSRXIRNprWw=;
        b=ZwdapRk8ceGsqdWQWqWFY66Hcw051yBu9BmRMRw/eU9tey3cRAUZjTzP3efnZh/tVq
         DKsq0W01HWKnO1xOKP2Ckf7WfIznVHu7TmWJIR8arVF4aglDCETwZM1FfVUA0ZbNDsKc
         cAv1i212kq3O2vWbwLdbfm3bF7xthE4LyNYmyCArUzBn0+FFXApQt7dE7X5A61Kmfl9R
         IoIVs7JMG7MrAE7mgs9IzQf21/2HmW0HeX2I1si1hmX6yrF/ef2+KF+XyxfZoa4+Qw6K
         numrF/E/32rvrui/Q9+9Rq8YpjVBLwZM6MkAe1VNMkypWcK/nQc9gP0zkuOxWQXDXO70
         sFTw==
X-Gm-Message-State: APjAAAUCmjW1//FJqvu666GNN27oyM9JquVWD/C+qP3nXPync3ualFyj
        m7Z+I5UYkuzrbe5xGxtIebw=
X-Google-Smtp-Source: APXvYqzJhxQ9lDZUGCGqymYXZPIwxpmd/xIMt/Esj6VlITq7iC1501TPRXtjzH3G69cZfeltIQFWoA==
X-Received: by 2002:a05:651c:152:: with SMTP id c18mr9942438ljd.146.1576251043553;
        Fri, 13 Dec 2019 07:30:43 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:42 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 09/18] trace-cmd: Add new API to generate a unique ID of the tracing session
Date:   Fri, 13 Dec 2019 17:30:20 +0200
Message-Id: <20191213153029.133570-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
index 9a2b7db..ad69313 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -441,6 +441,7 @@ void tracecmd_plog_error(const char *fmt, ...);
 int tracecmd_set_logfile(char *logfile);
 
 /* --- System --- */
+unsigned long long tracecmd_generate_traceid(void);
 int tracecmd_count_cpus(void);
 
 /* --- Hack! --- */
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 75ec5a3..fabd558 100644
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
@@ -1309,3 +1311,38 @@ error:
 	tracecmd_put_tracing_file(path);
 	return ret;
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
index 51abef1..6203e0d 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -182,6 +182,7 @@ struct pid_addr_maps {
 struct buffer_instance {
 	struct buffer_instance	*next;
 	struct tracecmd_instance	*ftrace;
+	unsigned long long	trace_id;
 	char			*cpumask;
 	struct event_list	*events;
 	struct event_list	**event_next;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7a3d687..7089f7b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5061,6 +5061,7 @@ void init_top_instance(void)
 		top_instance.ftrace = tracecmd_alloc_instance(NULL);
 	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
+	top_instance.trace_id = tracecmd_generate_traceid();
 	tracecmd_init_instance(&top_instance);
 }
 
-- 
2.23.0

