Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A39C43215
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE45206F0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksjYqnlk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfK0ODD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:03:03 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46090 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfK0ODD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:03:03 -0500
Received: by mail-lj1-f196.google.com with SMTP id e9so24590228ljp.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S5U9SmDY9JT28W6d0apExNxzS8k4zqM51/rvn+do++I=;
        b=ksjYqnlkwrD1Xfve7ToftW71jaMeOXHV4/XZmQD8cgzgAMF7zccBaqlX3OKm8J9dZY
         lTeGx7kwqm6giWjtl8622C6ebsE/IIXJ9uCgSsVZjGZl509AdpBMNX6TCGZ/cvCyWVG6
         V7ax4fTfeyIdZX1lx2KSAK7MKZDtDrB0NT/3u6RFXd6nGKZYN41qy17Z/zWmIplIyxg7
         CjS4bIHc82Y1piOcJWnXcWhkkJgXpTIda4jRXKebm8oNWrqP5USlLXg9x/PJjYa3g7kE
         HFtYbU8Uak6adiX+b87geovv2gK4EfcRbl4WzaHnZNbsJbH4T5kp6eCgxjqFWbHdLrXQ
         Qqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S5U9SmDY9JT28W6d0apExNxzS8k4zqM51/rvn+do++I=;
        b=jpNJeAcX2HB7RE3z2+sTYpUXYHZFO94f69zq/g7WJwIlIn8XtwlbRB4BAjmS+Kf5CZ
         5s8T/oViIHv+SGbJGpLeK+o4SsJL41J9SfLKHLuWt2HBVjQ+m572SD9iPu8CTi2012uE
         frtfhmuZsQrAgpXTgA8yNxfz5NpzVTJGbDC1RNOypai4KQBZnI7iRYn1Kpv6eqH9S5OC
         6XYa4L5pTg6yFFHxCacenKI5V/swjK3UsiSXviZCfICveRWFNChqwYAsC5JTfdGTZLoR
         h1tCmloBh+HNgvSwwz8WNQSzx41HF45jvKN1nUDMpnTNtMdkON1o1lPYIYYcAEkRVujQ
         BKIQ==
X-Gm-Message-State: APjAAAU8PKVOZeLl5ayoUU5WQJugY+EevbU/BYhA53VmVc2MjTRioqUi
        RnGUZ4qPAP2CBJGTRN8Yssv02WgBkkE=
X-Google-Smtp-Source: APXvYqxjGc64k0j7EuzF5Fubu/GifdrGg6/3op2VS09zS6sWKHVpk0Oqexf+CVQf+FdyA37DsJ2eOA==
X-Received: by 2002:a2e:b4da:: with SMTP id r26mr28468673ljm.153.1574863381401;
        Wed, 27 Nov 2019 06:03:01 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:03:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 10/19] trace-cmd: Add new API to generate a unique ID of the tracing session
Date:   Wed, 27 Nov 2019 16:02:38 +0200
Message-Id: <20191127140247.258766-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
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
index a08ee52..70d75f6 100644
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

