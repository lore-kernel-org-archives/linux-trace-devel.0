Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684C8C10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EFF221872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfCOIiA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:38:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55909 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfCOIh7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 04:37:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id 4so5562137wmf.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 01:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/UnSjgn063r718kUxw+hYTPaixZKeywUhQaFk7tTPRA=;
        b=mlG6W34ZKlRTNZjNv+nDCFwxwiLvLnB4yCf68JFl3Zbta55QimwkNViYuBHhHoBUEw
         Xg+eyIYfovLIxYSZX6+tCb8EaRHtHyd69zFxopHpKvPBm7f5RrEJRg3G8dileK3iogNj
         8VdVZ9VZvmMEeIGQI4EjkYiSYi33nnkt3Mn8oDpaD7VQb9qxQTfPq7IZe+9NJvthCru0
         C8MH5YG+OeFC3Owtq8TLNHihJHdgAjsOKgiyW23seldu+tJf9q4+01irJecBjt0EBaIv
         ALmXAdjTvy5gPNTa6IeQ2VeEOCgIucawZ80CUnIjVDEgrldihnN9McN2RMKH0wnAuV49
         vKHw==
X-Gm-Message-State: APjAAAWbw2LC9z1l7EX9YW/2MKNHzfsyQDguO96GTP9tMpPoEQZ4bNVy
        Ne7s8WCtwbSfrbyoGpThNQ73inUZ
X-Google-Smtp-Source: APXvYqw+xURQJaZ/ARpLT9i9mNIGa/BunMN0A4o3yrBSA/G5bQig9tyhpSAPugcHg23ujlqLzY/2mg==
X-Received: by 2002:a1c:dc85:: with SMTP id t127mr1170787wmg.136.1552639077514;
        Fri, 15 Mar 2019 01:37:57 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o5sm979395wmh.12.2019.03.15.01.37.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 01:37:56 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 1/9] trace-cmd: Implemented new lib API: tracecmd_local_events_system()
Date:   Fri, 15 Mar 2019 10:37:46 +0200
Message-Id: <20190315083754.27532-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315083754.27532-1-tstoyanov@vmware.com>
References: <20190315083754.27532-1-tstoyanov@vmware.com>
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
 lib/trace-cmd/trace-util.c    | 95 ++++++++++++++++++++++++-----------
 2 files changed, 67 insertions(+), 30 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 27ba89d..21f83e2 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -32,6 +32,8 @@ void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pe
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
+struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
+						const char * const *sys_names);
 int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent);
 char **tracecmd_local_plugins(const char *tracing_dir);
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5aea39..ca32fcf 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1119,43 +1119,25 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
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
-	if (tracecmd_fill_local_events(tracing_dir, pevent)) {
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
- *
- * Returns whether the operation succeeded
- */
-int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent)
+static int tracecmd_fill_local_events_system(const char *tracing_dir,
+					     struct tep_handle *pevent,
+					     const char * const *sys_names)
 {
+	int ret, failure = 0;
 	struct dirent *dent;
 	char *events_dir;
 	struct stat st;
 	DIR *dir;
-	int ret, failure = 0;
 
 	if (!tracing_dir)
 		return -1;
@@ -1189,7 +1171,8 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
 		if (strcmp(name, ".") == 0 ||
 		    strcmp(name, "..") == 0)
 			continue;
-
+		if (sys_names && !contains(name, sys_names))
+			continue;
 		sys = append_file(events_dir, name);
 		ret = stat(sys, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
@@ -1217,6 +1200,58 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
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

