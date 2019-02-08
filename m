Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824B5C169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D07620869
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfBHNtZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:49:25 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46302 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfBHNtZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 08:49:25 -0500
Received: by mail-wr1-f65.google.com with SMTP id l9so3584347wrt.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Feb 2019 05:49:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JRqyt+M4cmm4p89m+KxTOOAGF9xTczaRLDHmiiCxd/c=;
        b=RJ3lNaNaWjL1nGASSTkP5FjX8QVC8VfdrFZuDwSN0XH8mopsrYuNQmzT/UzZR1wp/J
         lGrjov+V3G1sdF49GRDS9qHSO94zCc5bu4eFXaBeVwtOhNg27BNhvlNWxA+ePSVISAX2
         +Hp2r2alur6xfcZu22jl55ybAl8Q5a4lim3865rT5W4/VQ/wQa8hUjGf4Uab4tpaCubj
         ar8m7rLLQsmzlKhPGtEi0IuBO7QfzN/gFnyz7flsgyrQjpxKUZMv0nUcCpYAhKFEUwDo
         r50qhJr6YpN0iVigTxOhwi5KXVVwdTt0Uepoj8lTY6ZMwtq7RRZ7eCamJXS9JSMk9odR
         MZ5Q==
X-Gm-Message-State: AHQUAua6iIoda58LGs/H2f7V2ivxA8PYtiVOu2+V/YGKypJdASLweF9h
        Zd48DEn+dE6qwcc0La2w+sM=
X-Google-Smtp-Source: AHgI3IYkpMX+5Eu3ImskyxUaMGaUk9heP4zywSaiWOjKLJ6LGzzMZAyFjBlPlBRJqzgHJSQWkQticA==
X-Received: by 2002:a5d:4202:: with SMTP id n2mr16601682wrq.260.1549633762600;
        Fri, 08 Feb 2019 05:49:22 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a184sm2534796wmh.37.2019.02.08.05.49.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 05:49:21 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/7] trace-cmd: Implemented new lib API: tracecmd_local_events_system()
Date:   Fri,  8 Feb 2019 15:49:12 +0200
Message-Id: <20190208134918.5618-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208134918.5618-1-tstoyanov@vmware.com>
References: <20190208134918.5618-1-tstoyanov@vmware.com>
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
 lib/trace-cmd/trace-util.c    | 99 +++++++++++++++++++++++------------
 2 files changed, 68 insertions(+), 33 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 84dc95a..3d72430 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -32,6 +32,8 @@ void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pe
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
+struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
+						char **sys_names);
 int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent);
 char **tracecmd_local_plugins(const char *tracing_dir);
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5aea39..0e925ed 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1119,43 +1119,15 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
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
+					     char **sys_names)
 {
+	int ret, i, failure = 0;
 	struct dirent *dent;
 	char *events_dir;
 	struct stat st;
 	DIR *dir;
-	int ret, failure = 0;
 
 	if (!tracing_dir)
 		return -1;
@@ -1189,7 +1161,16 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
 		if (strcmp(name, ".") == 0 ||
 		    strcmp(name, "..") == 0)
 			continue;
-
+		if (sys_names) {
+			i = 0;
+			while (sys_names[i]) {
+				if (strcmp(name, sys_names[i]) == 0)
+					break;
+				i++;
+			}
+			if (sys_names[i] == NULL)
+				continue;
+		}
 		sys = append_file(events_dir, name);
 		ret = stat(sys, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
@@ -1217,6 +1198,58 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
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
+						char **sys_names)
+{
+	struct tep_handle *tep = NULL;
+
+	tep = tep_alloc();
+	if (!tep)
+		return NULL;
+
+	if (tracecmd_fill_local_events_system(tracing_dir, tep, sys_names)) {
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

