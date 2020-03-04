Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7583C3F2CD
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A01E921739
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVgooqXi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgCDJMa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:12:30 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42163 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgCDJMa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:12:30 -0500
Received: by mail-lj1-f193.google.com with SMTP id q19so1135648ljp.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Mar 2020 01:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fiR+wh9IW65zkRqBY7CB/WIupofLmJUZXqDzSgDnfNc=;
        b=aVgooqXi6sYCVQTfH3ZF0mYpdjMUMad9ON+eKNEswYN0WYWdvxz2BdjmfJSH+6hh+R
         +bkMxIcyH4K0qTQu4nTccP+pw284nfWQjY19Ou3ISiHXByvA0Oe0i2ae8BRdHU5uqP0K
         fDkplYD5us8Gqrmor9unF9XebM1Z0vdEd1MaP/MCqfBiJjBH0pKarJ2kFjxkkGKFcXxo
         sOb3hBPkN+38zGgkPsoq2sBUlv7N0WhEldzpBdAGIpvcuOWx1qV/TicCsYDOgr+GpaW8
         09FlDsSwQbgfISzyTbmpwFU2qR98AzH9FhUPcJ+Ar0pRUxJYXLp50mQAE68TSbtOT4EP
         glRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fiR+wh9IW65zkRqBY7CB/WIupofLmJUZXqDzSgDnfNc=;
        b=Bk/LH/woEgW2I7pVltzbbS4cbTb6FHwF2i2H/Jc7rWOyL9MQRYioJRoE1qS0FOsaB+
         Y6hIppOAEHuVjgJhf6hE0RorN3VRBASkAPZeP/E4TjdoR4N4RnGXPY913a5JlHx1f2PB
         6WXOsPR6jXFfykoKAKTsu7zk79HdVqqW3wo88W6J0upaufyqTzY0QNhBOG3MMFwAPsX6
         wOI5SCqEvfuk3N+3wGeG6JxRtc+s2gU9bIyq+diaypQiqXrfKqs1xpaTgMouefD8y0I7
         yoKR2e+uTxdGh/vgrBfpvGyfr/HpaI0mJcvtauA7acnd+D3jvHwy1VXgJBlW5TW0VfsW
         mbeA==
X-Gm-Message-State: ANhLgQ2cXRce4rMaYbObVIRCkRI2vXPsT30ALj8hIThr/5CJ+KeU00Xf
        KbGAZumPyMxNLrlrKXqhuko=
X-Google-Smtp-Source: ADFU+vu5uEc7W6L+2z4OEfa7rtWLAWHtn0CFTR1kvHUFBrUsHorDY90hD2/KzndZSwVHkzwcISzhAw==
X-Received: by 2002:a2e:b895:: with SMTP id r21mr1441628ljp.126.1583313146697;
        Wed, 04 Mar 2020 01:12:26 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v15sm13327462lfg.51.2020.03.04.01.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:12:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v22 03/13] trace-cmd: Add new API to generate a unique ID of the tracing session
Date:   Wed,  4 Mar 2020 11:12:10 +0200
Message-Id: <20200304091220.30936-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304091220.30936-1-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
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
index 9ed79856..9cd8f590 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5247,6 +5247,7 @@ void init_top_instance(void)
 		top_instance.tracefs = tracefs_instance_alloc(NULL);
 	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
+	top_instance.trace_id = tracecmd_generate_traceid();
 	init_instance(&top_instance);
 }
 
-- 
2.24.1

