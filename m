Return-Path: <SRS0=Ozv+=ZZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559C4C43215
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BFE52073C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Dec 2019 10:35:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zusgn0Ca"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbfLCKfa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 05:35:30 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34500 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCKf3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 05:35:29 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so2529240lfc.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Dec 2019 02:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UlloWdexl+9O5OkTNnM3Udk0+LESBNPOa46PpvzWRgk=;
        b=Zusgn0CaacQbbc8XpRPSOyNTt6jmZQwWk7cSMh5M9fLvDooFpGR8Eg8pWGo0yelduX
         q+E+lzKFXByc7jWx4X0JAk9CMII6RTp/tSsA1OWm22NTurVLlpXl1tNr1CutMoGMEO2G
         ZnsxLGfa7UFd5NTEuetMqfBClxSshPo58sBRXvK/TOqjP8Jb01hSiWwRThaGFGywfJMA
         XakLyy3Vh8lIGSJQ6M4rLYc5olHAudvNmCj3VFqY5oGXWgyvlWUmv97LL2QrLlOEUazF
         ECmSeLVfqxAW7rJ3BJ7MfsX8yjz8zdQd4kuI0LwDwv2t0x1chWSeZ41BjRigu2oX66g/
         0dpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UlloWdexl+9O5OkTNnM3Udk0+LESBNPOa46PpvzWRgk=;
        b=sIAJRtNNZuxuOb2/cyASRWySFlkfR298BNQSyAdzgmu4YtjrkaEPNA5FkDtHmetCO9
         uOkDT0t6ZhuqILMno3uGef36aQiJ4aow2RoAvuBTVT/MPW5w73cBux2O+NcpWT6zDndA
         t3NxAUdZrfoDyvngq7NImZrHKqKRBKmj9hoJQfNKy3Ya4wwmTMDWZw5wmGKGgqGyaIma
         w0mYf2UgmDU8ZUcOu8Qxn6WgtJWOHHnlUFyWiYusWuz4QFzGN2X8+jBEg4MUnBYrCfmU
         uajKucfHe4X5U0OK7FpEOvpbpk2+jzHGLzMCx51/yCV2CMJCM0jzplkmk/HzLYZPtPht
         z+yg==
X-Gm-Message-State: APjAAAVYYq22Te6TuWPtn5Q5GCRyKhdcxci4Y/QntV21NJCvM9wOVty6
        jcjJ7muBUhN3qHc4qOVTUjg=
X-Google-Smtp-Source: APXvYqzuEd/BmNS0iaPdkm/fQghoc0awpjCYfviGNxpWkWtfK088H7nbUs6SAZ9qkZqdyW+He9vGWw==
X-Received: by 2002:ac2:455c:: with SMTP id j28mr2369225lfm.184.1575369327539;
        Tue, 03 Dec 2019 02:35:27 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t9sm1053023lfl.51.2019.12.03.02.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 02:35:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v17 01/18] trace-cmd: Implement new lib API: tracecmd_local_events_system()
Date:   Tue,  3 Dec 2019 12:35:05 +0200
Message-Id: <20191203103522.482684-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191203103522.482684-1-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

The new tracecmd lib API tracecmd_local_events_system() creates
a tep handler and initializes it with the events of the
specified subsystems.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h |   4 +-
 lib/trace-cmd/trace-util.c    | 102 +++++++++++++++++++++++-----------
 2 files changed, 72 insertions(+), 34 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 13afce7..9363a26 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -27,8 +27,10 @@ extern int tracecmd_disable_plugins;
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
+struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
+						const char * const *sys_names);
 int tracecmd_fill_local_events(const char *tracing_dir,
-			       struct tep_handle *pevent, int *parsing_failures);
+			       struct tep_handle *tep, int *parsing_failures);
 char **tracecmd_local_plugins(const char *tracing_dir);
 
 char **tracecmd_add_list(char **list, const char *name, int len);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5bb0d5..49a80ae 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -616,39 +616,20 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
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
+					     struct tep_handle *tep,
+					     const char * const *sys_names,
+					     int *parsing_failures)
 {
 	struct dirent *dent;
 	char *events_dir;
@@ -677,7 +658,7 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 		goto out_free;
 	}
 
-	ret = read_header(pevent, events_dir);
+	ret = read_header(tep, events_dir);
 	if (ret < 0) {
 		ret = -1;
 		goto out_free;
@@ -690,7 +671,8 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 		if (strcmp(name, ".") == 0 ||
 		    strcmp(name, "..") == 0)
 			continue;
-
+		if (sys_names && !contains(name, sys_names))
+			continue;
 		sys = append_file(events_dir, name);
 		ret = stat(sys, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
@@ -698,7 +680,7 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 			continue;
 		}
 
-		ret = load_events(pevent, name, sys);
+		ret = load_events(tep, name, sys);
 
 		free(sys);
 
@@ -716,6 +698,60 @@ int tracecmd_fill_local_events(const char *tracing_dir,
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
+ * @tep: Allocated tep handler which will be filled
+ * @parsing_failures: return number of failures while parsing the event files
+ *
+ * Returns whether the operation succeeded
+ */
+int tracecmd_fill_local_events(const char *tracing_dir,
+			       struct tep_handle *tep, int *parsing_failures)
+{
+	return tracecmd_fill_local_events_system(tracing_dir, tep,
+						 NULL, parsing_failures);
+}
+
 /**
  * tracecmd_local_plugins - returns an array of available tracer plugins
  * @tracing_dir: The directory that contains the tracing directory
-- 
2.23.0

