Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE837C5ED3E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3EA246B3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rwn2IvLb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389853AbgB0OUO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:14 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39105 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389385AbgB0OUN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:13 -0500
Received: by mail-lj1-f196.google.com with SMTP id o15so3614536ljg.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fEiEQ65BuT5IqZCKZwhrCwsHR9aSt/uIprrHvPKzN7I=;
        b=Rwn2IvLbzFe0vvcMC/Afg2gM94n1Z0zH82GIJ2ZDjgLm6IsOkY2lUiD/v/xCMf63Fc
         bUtW9rhXb7bBE1/VjbmwHPRvYCMIWNPMwjPn9eUpEy5D0MEVv+FzA7txkbOMCxJ5ytfR
         VyUxLOXRgERHLMh5CwQ5VeLpQRpoqxh3Y18EdhlzOAAenCQ+HegXbC8v+LvFmIXqR0nZ
         Rg6qZ49PPonWeHWcmLuerxQ3SSO25N/SMW+WNIQP5NhAQSBP1DYCjxjW6izR+Z5LTDhU
         e3iqtBrAgKnO+zS2K14VqrW/XnKkJpZrzsaaD3N5TFIffok7jxCTN6gneDgB2sM8pUSX
         ENwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fEiEQ65BuT5IqZCKZwhrCwsHR9aSt/uIprrHvPKzN7I=;
        b=ejr8rA3BcSZFgo7VqUbM/RqIf70krvYavNB7h02vGnBp2wCq7fnDYL6Lg3/Vj/70DP
         O719ZHdyZzSF66iw3sDmZvBULZO+xRb709e+qiAUGJyWpn9uec6ZfHVRMq0vmTeFn3Jl
         cFKl1HcvILFvEplChQNxcugreu0sqVCr/p0yRVr/Linq5eV80B/xlQgTq3mUukN6NFyl
         rVZWuAulqPbDXG0tjvTm65OdydEFt86bMH8MUDkPPFKoDGeks+iU73ATkewk6UvbyGTW
         L2lgMUET7uYzUUINxIy9OAtfxlKrOU7dpG5Ujv5AXgi8ecNHuuh8ipx4hV26mG2T2puS
         FTtg==
X-Gm-Message-State: ANhLgQ1mVaCKuEZzz3O28D+VeEixuS/ftyGg8QZlL3xKz1lMSqOodktn
        ttlAibhvQlCkt4+PaNf7N9E=
X-Google-Smtp-Source: ADFU+vtJz+krLXXsi3PWJKpvYcYiR3U73tzG1gkvZ22n+5tiAwaU1YfcdfdSXKzTG3wyMAzZQgwY6A==
X-Received: by 2002:a05:651c:327:: with SMTP id b7mr2823085ljp.22.1582813211207;
        Thu, 27 Feb 2020 06:20:11 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 05/15] trace-cmd: Add new API to generate a unique ID of the tracing session
Date:   Thu, 27 Feb 2020 16:19:51 +0200
Message-Id: <20200227142001.61577-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
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
index 4370c964..5d31cad8 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5204,6 +5204,7 @@ void init_top_instance(void)
 		top_instance.tracefs = tracefs_instance_alloc(NULL);
 	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
+	top_instance.trace_id = tracecmd_generate_traceid();
 	init_instance(&top_instance);
 }
 
-- 
2.24.1

