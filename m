Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D51FC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E9820661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfCHNo3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37314 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfCHNo2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id x10so12366230wmg.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iGC7rh6ccnovJ9Vj2x/cclblPNlik72qrfXGJ/5N6b4=;
        b=jfmO3QXE0GogOQgoke6448wA8rum+NZjFrn3bDqB0VjvqkiPO37Z36f7NLaesmCGlZ
         pgE2BCnTkWFOGcYf7wjmsehzpfwflJ9dsEanind628Ccflutiv83HPwpPaa+m5iDfXd5
         dMu9RruAh0DgcSz//3NEPpq3phFNLLKGc+VLS8E9uLC37fMPpDQbUlX+D96EMgHhYppA
         YVJC9E5rti2m08lz91xNOizRsRb8qnD8Wzr4CGrgk3BGxLlBNyy0HXK5kCYTy7VRlunQ
         5RHEOwcrwxGvCAxy/BimSACwKndI78Hi2ZsVtSuQ/h5Lp8j+BtVZYy+AHQnonl1QU7Be
         L1Vw==
X-Gm-Message-State: APjAAAUAFh43FhF5nhBrmx2hO3wg9dxhq0sAeEKuOphun36glPUF2LIj
        85DILGlMBk04UE44/fKYHJB/AnpF
X-Google-Smtp-Source: APXvYqwMO/eJbHF+hoB6L4YZOVWSeJKakhy+nwamHY9A0DJeDr0oSMvGtXrcZppEveUgx+6jvNwpIg==
X-Received: by 2002:a7b:c34c:: with SMTP id l12mr3059520wmj.126.1552052666384;
        Fri, 08 Mar 2019 05:44:26 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w4sm11631872wmg.8.2019.03.08.05.44.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:25 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 1/9] trace-cmd: Implemented new lib API: tracecmd_local_events_system()
Date:   Fri,  8 Mar 2019 15:44:15 +0200
Message-Id: <20190308134423.22008-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308134423.22008-1-tstoyanov@vmware.com>
References: <20190308134423.22008-1-tstoyanov@vmware.com>
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
index 27ba89d..0067882 100644
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

