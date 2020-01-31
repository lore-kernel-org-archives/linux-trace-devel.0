Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EC2C35246
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3C8E214D8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LK5O2Fs2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgAaMLX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:23 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45217 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgAaMLX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:23 -0500
Received: by mail-lj1-f194.google.com with SMTP id f25so6813713ljg.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2IEueMfQZZNIHNBefzvUMdkfV4yE9cHq6rPCr86k1O0=;
        b=LK5O2Fs2NQ4cgYGhZ8/CvPBXaVmfz6kWypUNWa//LaOAAlYRt7cU3c4iFEsQon5RN8
         5XUEf0suWeicXCF4jrzlqEq2WKNvsLuGqBVwAC3jLtQ8jaWTJVATHNvyvEhNZdrui97+
         VUL6n30/ySXOmfY8XzufU5K8kdxaZOXJchJ3GxeLPvBQqkzzpiGf2O1A8fL+vf/KY4te
         XFq+7WAT8krpDm55XF5jr24UPPsdOV3efjS1ajGf/H3cNeNmDnGcr8hGEIVZHqMqT5BC
         Zic3kHL8GgMykQGZU4du4P8dEw2prHzrCJBlzo+Var3nQ82H+QayOhgQHkYwqrmmH+TZ
         IbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2IEueMfQZZNIHNBefzvUMdkfV4yE9cHq6rPCr86k1O0=;
        b=oCSOla7kMpy/j4M8dHtKxIBzvIGhyTE2l2M5tGNlYdB6TI7zu+NlhI3jIVKEEuI0au
         8ll8AKGfUYGmQXLBgP69z2ot4FQo1xTDUbI/pYq0QnpBxMU4qXIeUp4xdnme8ZNjZR31
         GvTvPk/7AGysPWI3x37nHYLk5FnOHNuc3u6lsqrzHlRVGybngtxU6RwX1hDVz8bmEvOT
         CNr0L7OZB2l+pKIFuWRFpidHbmRN6LUHH1IEvaJtQLWNb25ATyGmUAzU4keXtnaTzyEW
         z9jlLbbw9iC17j5yF+1awCrHZ0Iws6GmV5n1keiXxMHwYWGfJ++/W3Pda5dvliQbIN2i
         dmiA==
X-Gm-Message-State: APjAAAU0lJ7FfqiPKCsF6l6JsW/aJR5b0mPb5MCueqZisCfgjym+Um3g
        JL9MrdTXmzRYz7WW4GPHX6Em+qTSyD8=
X-Google-Smtp-Source: APXvYqzp9XB3aCRpGWeFYN8gYq+ew21zTnBDHAriba58089gh2NLcdiA4UsqIHh5eluyeHUP7PT9qA==
X-Received: by 2002:a2e:9110:: with SMTP id m16mr5666967ljg.140.1580472681400;
        Fri, 31 Jan 2020 04:11:21 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:20 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 05/15] trace-cmd: Add new API to generate a unique ID of the tracing session
Date:   Fri, 31 Jan 2020 14:11:01 +0200
Message-Id: <20200131121111.130355-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
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
index b6393a8..7519e82 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -415,6 +415,7 @@ void tracecmd_plog_error(const char *fmt, ...);
 int tracecmd_set_logfile(char *logfile);
 
 /* --- System --- */
+unsigned long long tracecmd_generate_traceid(void);
 int tracecmd_count_cpus(void);
 
 /* --- Hack! --- */
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b884139..04dc804 100644
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
index a5cf064..6fe22bb 100644
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
index b479e91..a815a85 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5181,6 +5181,7 @@ void init_top_instance(void)
 		top_instance.tracefs = tracefs_instance_alloc(NULL);
 	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
+	top_instance.trace_id = tracecmd_generate_traceid();
 	init_instance(&top_instance);
 }
 
-- 
2.24.1

