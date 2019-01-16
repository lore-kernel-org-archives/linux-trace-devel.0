Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11162C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DED1320866
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbfAPTSn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 14:18:43 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32968 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730792AbfAPTSn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 14:18:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so8323493wrr.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 11:18:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BsTtzkquypSoawotUQLcu69xDu7USkM8yoJ56DCQzbk=;
        b=YP/Cw4oOA3Z2vRnEUAw4EH0YkrGpqQHncu4yx6MpEnY7Umw903nsEmxQatDLejET2Q
         K61TDzCkin/A0uDVBqXkeN1dHpVPy+zp8tbP9v59sPT8Hvy5nkeq1VCUnDnYNRv6bCj+
         ZOzJ45WD+swwZPmc9AQ7eWcsKB8rQ+81x1uKcg96/ryTybJlwvnsGX1b74HQrhHT+og7
         KdQacfRS0A1T//tOszcIi0EHN8ik3odUCYbDPLJ39NJpo3mAtRnXSLi3Jn+kg57/HhwV
         x8dSTOTdcwKSmc2jy1Eq2j6satu5V9sl6cfimnZUXyx3BUg9e8bVJw4m1/j4tG6oB+CL
         z0JA==
X-Gm-Message-State: AJcUukcRoIunGNp2BK9ChGbyuNw81xE+gC8ro9xIrcsTEzhOv38MCSH7
        T3ysRtyzM46OvqW0RU2CpqUG+qav
X-Google-Smtp-Source: ALg8bN74xeiDRinh3uGfjUJNymhHfz6HrBMM8yOLLSGICqqpcn8mbeV7N1+if4pbOuEaahzWC3C/jQ==
X-Received: by 2002:a5d:6487:: with SMTP id r7mr9097995wru.263.1547666321629;
        Wed, 16 Jan 2019 11:18:41 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm98393345wrx.50.2019.01.16.11.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 11:18:40 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/7] trace-cmd: Implemented new lib API: tracecmd_local_events_system()
Date:   Wed, 16 Jan 2019 21:18:32 +0200
Message-Id: <20190116191838.32127-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190116191838.32127-1-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new tracecmd lib API tracecmd_local_events_system() creates
a tep handler and initializes it with the events of the
specified subsystem.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  2 +
 lib/trace-cmd/trace-util.c    | 89 ++++++++++++++++++++++-------------
 2 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 238e16b..c79fc63 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -32,6 +32,8 @@ void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pe
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
+struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
+						char *sys_name);
 int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent);
 char **tracecmd_local_plugins(const char *tracing_dir);
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5aea39..706aab3 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1119,37 +1119,9 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
 	return ret;
 }
 
-/**
- * tracecmd_local_events - create a pevent from the events on system
- * @tracing_dir: The directory that contains the events.
- *
- * Returns a pevent structure that contains the pevents local to
- * the system.
- */
-struct tep_handle *tracecmd_local_events(const char *tracing_dir)
-{
-	struct tep_handle *pevent = NULL;
-
-	pevent = tep_alloc();
-	if (!pevent)
-		return NULL;
-
-	if (tracecmd_fill_local_events(tracing_dir, pevent)) {
-		tep_free(pevent);
-		pevent = NULL;
-	}
-
-	return pevent;
-}
-
-/**
- * tracecmd_fill_local_events - Fill a pevent with the events on system
- * @tracing_dir: The directory that contains the events.
- * @pevent: Allocated pevent which will be filled
- *
- * Returns whether the operation succeeded
- */
-int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent)
+static int tracecmd_fill_local_events_system(const char *tracing_dir,
+					     struct tep_handle *pevent,
+					     char *sys_name)
 {
 	struct dirent *dent;
 	char *events_dir;
@@ -1189,7 +1161,8 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
 		if (strcmp(name, ".") == 0 ||
 		    strcmp(name, "..") == 0)
 			continue;
-
+		if (sys_name && strcmp(name, sys_name))
+			continue;
 		sys = append_file(events_dir, name);
 		ret = stat(sys, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
@@ -1217,6 +1190,58 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
 	return ret;
 }
 
+/**
+ * tracecmd_local_events_system - create a tep from the
+ * events of the specified subsystem.
+ *
+ * @tracing_dir: The directory that contains the events.
+ * @sys_name: Name of the subsystem, to load events from
+ *
+ * Returns a tep structure that contains the tep local to
+ * the system.
+ */
+struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
+						char *sys_name)
+{
+	struct tep_handle *tep = NULL;
+
+	tep = tep_alloc();
+	if (!tep)
+		return NULL;
+
+	if (tracecmd_fill_local_events_system(tracing_dir, tep, sys_name)) {
+		tep_free(tep);
+		tep = NULL;
+	}
+
+	return tep;
+}
+
+/**
+ * tracecmd_local_events - create a pevent from the events on system
+ * @tracing_dir: The directory that contains the events.
+ *
+ * Returns a pevent structure that contains the pevents local to
+ * the system.
+ */
+struct tep_handle *tracecmd_local_events(const char *tracing_dir)
+{
+	return tracecmd_local_events_system(tracing_dir, NULL);
+}
+
+/**
+ * tracecmd_fill_local_events - Fill a pevent with the events on system
+ * @tracing_dir: The directory that contains the events.
+ * @pevent: Allocated pevent which will be filled
+ *
+ * Returns whether the operation succeeded
+ */
+int tracecmd_fill_local_events(const char *tracing_dir,
+			       struct tep_handle *pevent)
+{
+	return tracecmd_fill_local_events_system(tracing_dir, pevent, NULL);
+}
+
 /**
  * tracecmd_local_plugins - returns an array of available tracer plugins
  * @tracing_dir: The directory that contains the tracing directory
-- 
2.20.1

