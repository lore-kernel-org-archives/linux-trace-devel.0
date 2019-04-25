Return-Path: <SRS0=Y1eu=S3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6671AC282E3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E2BB214AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 11:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbfDYLFh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 07:05:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36826 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730647AbfDYLFg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 07:05:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id h18so9953093wml.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Apr 2019 04:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QQbXz20o3QGykPDbw1eNITmK+OX+briHF1W+aH7SnD8=;
        b=S4EMq9iNlMMFq6Hvc7o/qwqlgWnMuRoCMi0ykQUEK5fhg4uxHlu9WELGh3W9UqUMhd
         p0J/ZeMNZmGQJ4Y3QAoCI0aUEq0zeDjpvuREnPXqhBHO+gB7IFvkvsI1mfABnR+jrKpX
         hOAm1fmQhnJVX9ZQBUgYWUOQVLjRyLkw8UQMPE5kyBbmbg1ozLM+QQgdYYYNGTzm87mR
         09o32nLJot2Dc02lIspWdkH3dTDMzBhs6s0BrJ/Yxo5gm0q7ofRD5w+aH86cdB/9Z6OM
         P9S/iAtOrPoeoVLYt19Ha0p02nIBH77DPvz5yeFzwSO7FPuTJ3Tfa+LbUSZUoFBfyiiL
         6Y9w==
X-Gm-Message-State: APjAAAXp3YcU414TzCZQ5kRwKnOahDLr/Oh3bbm7qsH6Dq80NHdmP5k5
        NSOnQE8vzdrRdypzmI4e00s=
X-Google-Smtp-Source: APXvYqy6bz6bRlvT10JMIOyLoJHDWdhsNnzKE9o7+wRWYELj+b7BipExkfuLNMTOCu0OtXmumskAHw==
X-Received: by 2002:a7b:cc12:: with SMTP id f18mr3205022wmh.40.1556190334472;
        Thu, 25 Apr 2019 04:05:34 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a6sm23013606wrp.49.2019.04.25.04.05.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 04:05:33 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 1/9] trace-cmd: Implemented new lib API: tracecmd_local_events_system()
Date:   Thu, 25 Apr 2019 14:05:23 +0300
Message-Id: <20190425110531.8941-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190425110531.8941-1-tstoyanov@vmware.com>
References: <20190425110531.8941-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new tracecmd lib API tracecmd_local_events_system() creates
a tep handler and initializes it with the events of the
specified subsystems.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  2 +
 lib/trace-cmd/trace-util.c    | 98 ++++++++++++++++++++++++-----------
 2 files changed, 69 insertions(+), 31 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 094d8d2..c8a145b 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -32,6 +32,8 @@ void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pe
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
+struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
+						const char * const *sys_names);
 int tracecmd_fill_local_events(const char *tracing_dir,
 			       struct tep_handle *pevent, int *parsing_failures);
 char **tracecmd_local_plugins(const char *tracing_dir);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 190cf74..163b862 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1120,39 +1120,20 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
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
+static bool contains(const char *name, const char * const *names)
 {
-	struct tep_handle *pevent = NULL;
-
-	pevent = tep_alloc();
-	if (!pevent)
-		return NULL;
-
-	if (tracecmd_fill_local_events(tracing_dir, pevent, NULL)) {
-		tep_free(pevent);
-		pevent = NULL;
-	}
-
-	return pevent;
+	if (!names)
+		return false;
+	for (; *names; names++)
+		if (strcmp(name, *names) == 0)
+			return true;
+	return false;
 }
 
-/**
- * tracecmd_fill_local_events - Fill a pevent with the events on system
- * @tracing_dir: The directory that contains the events.
- * @pevent: Allocated pevent which will be filled
- * @parsing_failures: return number of failures while parsing the event files
- *
- * Returns whether the operation succeeded
- */
-int tracecmd_fill_local_events(const char *tracing_dir,
-			       struct tep_handle *pevent, int *parsing_failures)
+static int tracecmd_fill_local_events_system(const char *tracing_dir,
+					     struct tep_handle *pevent,
+					     const char * const *sys_names,
+					     int *parsing_failures)
 {
 	struct dirent *dent;
 	char *events_dir;
@@ -1194,7 +1175,8 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 		if (strcmp(name, ".") == 0 ||
 		    strcmp(name, "..") == 0)
 			continue;
-
+		if (!contains(name, sys_names))
+			continue;
 		sys = append_file(events_dir, name);
 		ret = stat(sys, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
@@ -1220,6 +1202,60 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 	return ret;
 }
 
+/**
+ * tracecmd_local_events_system - create a tep from the events of the specified subsystem.
+ *
+ * @tracing_dir: The directory that contains the events.
+ * @sys_name: Array of system names, to load the events from.
+ * The last element from the array must be NULL
+ *
+ * Returns a tep structure that contains the tep local to
+ * the system.
+ */
+struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
+						const char * const *sys_names)
+{
+	struct tep_handle *tep = NULL;
+
+	tep = tep_alloc();
+	if (!tep)
+		return NULL;
+
+	if (tracecmd_fill_local_events_system(tracing_dir, tep, sys_names, NULL)) {
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
+ * @parsing_failures: return number of failures while parsing the event files
+ *
+ * Returns whether the operation succeeded
+ */
+int tracecmd_fill_local_events(const char *tracing_dir,
+			       struct tep_handle *pevent, int *parsing_failures)
+{
+	return tracecmd_fill_local_events_system(tracing_dir, pevent,
+						 NULL, parsing_failures);
+}
+
 /**
  * tracecmd_local_plugins - returns an array of available tracer plugins
  * @tracing_dir: The directory that contains the tracing directory
-- 
2.20.1

