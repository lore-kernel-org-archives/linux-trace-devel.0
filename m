Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E877FC432C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF3F4217BC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeZwKjBk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfK2KRk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:17:40 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40183 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfK2KRk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:17:40 -0500
Received: by mail-lj1-f193.google.com with SMTP id s22so12374689ljs.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UlloWdexl+9O5OkTNnM3Udk0+LESBNPOa46PpvzWRgk=;
        b=WeZwKjBkpvzkw7JFN7QE3x3spR7ke15R2A+zb2dv9J6aGW9paks0l8mOP+RhmtCH5+
         S2iZi3ayPee+ESokVhdHzk5SwCO26R0lzkdJOd98xmgy+1lfpuijoT5voMFSfpCw4z67
         jGdfNPyTNqTzCbwIP+2XKTeDNPbfRTDBzZ2MomoUzeWEmUh97cwGk0To3TgRSgcdeDA+
         75sgzHYIGQJmeSDfvzQcuw1s2Cv010VjcBt5nWI57dKV0q2N4DxwPeoXCWu07o65hZjH
         gb0nJavO4wlnSGJRYqZIV0agDVD0mskCe0PZ1S1to83MdUL9+22UDAi3JbcJXl17KL7C
         1ajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UlloWdexl+9O5OkTNnM3Udk0+LESBNPOa46PpvzWRgk=;
        b=Ef2JnGe6XnySkIcFE55YOaA55UkYu6F4AOOW6fxHyloXT5C5XlZvvE5kiJHQaDOQjb
         UzRSe/HwBao+8f35h4tSNYzOcxSieMZX4D7S7L5lVW89OY5DWis2wHoCLjVoILVGQW9E
         uR8rxrly/sc4pY9pgL9xU1DUvj7J0z+UitrDA5jo2EStEAWE7WkNXsLl2xm4ngxcO3zz
         l8vYhYpxSbGUJPggWSmscWEEw7Ru952cWwk2V3we7vbn7PSEW/zNM95gV44bgS/l71xP
         aM5c/QYRTUsU4yP01S7qkiRqdSUyQakqki8re97Wkm32eKYXGHHG2fOcpvWsukrAtcVW
         j0ow==
X-Gm-Message-State: APjAAAUYzzznDCPg3oVoXBzel5jTfkCXZzGf2tWSgTriR50aj5yGxJDZ
        LwAbAJRd5JXoNVbHt1KHQb25b5juyRk=
X-Google-Smtp-Source: APXvYqyndyY5FOZ7/tSg0RZniiE/lbMvBaF7Bt29FRUgJCT+NXI1rHLeqYMnEMRVO1+b0xdIyE9UWg==
X-Received: by 2002:a2e:9356:: with SMTP id m22mr25059350ljh.160.1575022657659;
        Fri, 29 Nov 2019 02:17:37 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:37 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 01/18] trace-cmd: Implement new lib API: tracecmd_local_events_system()
Date:   Fri, 29 Nov 2019 12:17:16 +0200
Message-Id: <20191129101733.375808-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129101733.375808-1-tz.stoyanov@gmail.com>
References: <20191129101733.375808-1-tz.stoyanov@gmail.com>
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

