Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6B8C432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E4321774
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LsKgCpA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfK1IyY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 03:54:24 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39023 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfK1IyY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 03:54:24 -0500
Received: by mail-lj1-f193.google.com with SMTP id e10so18412913ljj.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 00:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QmB6jkNVbEHwa/ODmA0tzuLaeLBqPRqsBNvJgOqSs6k=;
        b=LsKgCpA7AkRhlx4On/vDPql+YOn+yCRkaBpTcItJ/xaeWLseBua+NaE88AjT117GaW
         0Y8vSfEMi7RWrh09VC1Ay5J7ijTCMqIjEtajz0V6gGCkG0WCZJ0NeN2YbI5Y3dgPzmpA
         7qWIqzi3PlN3tLp1kM5FgNtNVkg4C5aYVZkFDl3jpgyyWAAa+aMBj3lp8fLuwdOWeaWN
         62gqHXZdWAPig3fhF4WwUgZANWHwECroyt1+oG1ToJ4MlrEMJXpEwx2JrQ4fvDObH9hB
         B9pYimlaaKiR7lAP3fXIEnvdwQDy9+Mw+vUICJmfiMsXfNsp6CTslAUr6cepzClTeo87
         kJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QmB6jkNVbEHwa/ODmA0tzuLaeLBqPRqsBNvJgOqSs6k=;
        b=GxlLBgiy2RLs0D2osC1MvalBDdEEMxHlan0KwO3TzKstyRrnxpxy8TzR5pwqQ4hMPy
         XpNZMck8pXzTS59mAT+WyVuIP3HCkhXZA2UZftsnknY68jsjI59Lrf+uCUA2zRFPUOFY
         SztEAVx5KI11G7ROviDf4AicA8gz3B8GaOrNxdeWy8/Qgo/CThtO/N4lziJnSJjjWAAI
         ymkWbCBQF4/iecRzpb145Kb1F2xw2MkcawfEbi+IeSQec1BhnTK1S+ImqcusMesuzdDX
         s5QuR/JpfEzSumKWixvvs0Prgbix13Zn0wBCaupt9AEWiAY7+zk2H6ZXJXBX5xYU7OwM
         F6hw==
X-Gm-Message-State: APjAAAV74zwkLL0qmB9/E/pP+y8xkL48HPpvdoNZsFLKmUKUaSQiy8b4
        39OZALmfjaRem8b3AfXh0Cw=
X-Google-Smtp-Source: APXvYqwFc85Qli3wO8klhttEP9GUhzGcpoxJ8DqNpSvS0DbWFHf3nbz8IkovNNkD0cbazt/Yyf27nQ==
X-Received: by 2002:a2e:9016:: with SMTP id h22mr33417068ljg.137.1574931262759;
        Thu, 28 Nov 2019 00:54:22 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z19sm8253735ljk.66.2019.11.28.00.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 00:54:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 09/18] trace-cmd: Add new API to generate a unique ID of the tracing session
Date:   Thu, 28 Nov 2019 10:54:00 +0200
Message-Id: <20191128085409.289684-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128085409.289684-1-tz.stoyanov@gmail.com>
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-util.c     | 31 +++++++++++++++++++++++++++++++
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-record.c        |  1 +
 4 files changed, 34 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 47fa463..6d50b08 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -441,6 +441,7 @@ void tracecmd_plog_error(const char *fmt, ...);
 int tracecmd_set_logfile(char *logfile);
 
 /* --- System --- */
+unsigned long long tracecmd_generate_traceid(void);
 int tracecmd_count_cpus(void);
 
 /* --- Hack! --- */
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index ee6f48a..fdafbd6 100644
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
@@ -1296,3 +1298,32 @@ error:
 	tracecmd_put_tracing_file(path);
 	return ret;
 }
+
+#define FNV_64_PRIME 0x100000001b3ULL
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
index fd7ca82..1583c53 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5062,6 +5062,7 @@ void init_top_instance(void)
 		top_instance.ftrace = tracecmd_create_instance(NULL);
 	top_instance.cpu_count = tracecmd_count_cpus();
 	top_instance.flags = BUFFER_FL_KEEP;
+	top_instance.trace_id = tracecmd_generate_traceid();
 	tracecmd_init_instance(&top_instance);
 }
 
-- 
2.23.0

