Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA4CC432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CAB321781
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kmDZ3Une"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfK1IyR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 03:54:17 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40488 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfK1IyR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 03:54:17 -0500
Received: by mail-lj1-f193.google.com with SMTP id s22so8573507ljs.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 00:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZlId46raQm99CyqcEPElFx6Ys5AGmgS/V/H8bCM/z48=;
        b=kmDZ3UneRgvRoBpby/TPUyboGZji0hZNbyFgG1K1E59VSTQaNkQLnboA9iB6XCh3Rc
         nfg/NkQBLXYPVVJ3CSxzmVMSGKRD7902nWQCQCqkBSSB9GOgoFwwjN0UTmF7yGQ7O4QM
         ITgVHTauPU5GX6qpnbKSurjGU7pOvwVxpzdKOH6kK5i7M57bxOe/kEsrTMLudjsc8pFM
         mCWOmfHeqX6r+gBDVs3qx38uztQr6AQNzTDYDvf7m8dGmhz1Ej+V9HUg+4jYp6Cpb6PC
         cTHqQCR1JpJSc4adwhHFe0/hXw2JhBGG9lK72K1RaXcyZRqApJdjucuOfJnuyP4rucMO
         a5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZlId46raQm99CyqcEPElFx6Ys5AGmgS/V/H8bCM/z48=;
        b=Se2awk/g11UtuhQXimAQzjkMP3ew2OGoEbpkSz9jGn60wdEw9zyVgWrTBrJ9jFA/Z7
         DLVllJ5APF37ctKxblpvRl9zcxKMljX5f06JXHlqEim46FDPYZIyIqPXWyABfy47KT8t
         sHKcay1vysUUQqUWLMsoMbMoSQckj+9cGPMqbdTTezMAso1IMi4wgd8moiJPwd2AWfxe
         C9fvPliM6VbiH1d57pwEg0NKtoqIf/40uEncWCnaTgdNrpue5i4iMIPsmy1bukNQKbtg
         cgl9tCFciSNhdM9BhHCCnYazrPpgxBiKriMnv85hUlFuSOewN47IMntVPFbJiA+MilTx
         l8ng==
X-Gm-Message-State: APjAAAWs4PuvK1V3Em2h4OzPONK3Df2hhhbALvPaCcPLUzmTzlzUTxDY
        +3m4JMB7+3cPex/AVx5upjI=
X-Google-Smtp-Source: APXvYqzFoMkTqaKM3kN8zHbH/fY7idEStDXCZEXVKqCi2npth7HAGTvj6QDfi86Be3HLBGBr2OyFTw==
X-Received: by 2002:a2e:7811:: with SMTP id t17mr34043183ljc.225.1574931253339;
        Thu, 28 Nov 2019 00:54:13 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z19sm8253735ljk.66.2019.11.28.00.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 00:54:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 01/18] trace-cmd: Implement new lib API: tracecmd_local_events_system()
Date:   Thu, 28 Nov 2019 10:53:52 +0200
Message-Id: <20191128085409.289684-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128085409.289684-1-tz.stoyanov@gmail.com>
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
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
index 8aa3b6c..311f183 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -613,39 +613,20 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
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
@@ -674,7 +655,7 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 		goto out_free;
 	}
 
-	ret = read_header(pevent, events_dir);
+	ret = read_header(tep, events_dir);
 	if (ret < 0) {
 		ret = -1;
 		goto out_free;
@@ -687,7 +668,8 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 		if (strcmp(name, ".") == 0 ||
 		    strcmp(name, "..") == 0)
 			continue;
-
+		if (sys_names && !contains(name, sys_names))
+			continue;
 		sys = append_file(events_dir, name);
 		ret = stat(sys, &st);
 		if (ret < 0 || !S_ISDIR(st.st_mode)) {
@@ -695,7 +677,7 @@ int tracecmd_fill_local_events(const char *tracing_dir,
 			continue;
 		}
 
-		ret = load_events(pevent, name, sys);
+		ret = load_events(tep, name, sys);
 
 		free(sys);
 
@@ -713,6 +695,60 @@ int tracecmd_fill_local_events(const char *tracing_dir,
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

