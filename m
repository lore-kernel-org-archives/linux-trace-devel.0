Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2B8C432C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B47120722
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lIY+TUN4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfK0OCy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:02:54 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44467 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfK0OCx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:02:53 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so16207862lfa.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZlId46raQm99CyqcEPElFx6Ys5AGmgS/V/H8bCM/z48=;
        b=lIY+TUN4fqwlMq4rl594dFB4H+1UHwNy7vx9kSSZllgqf6MzN94d14y9D7XmP9maBH
         2VWUV5faNUW8ebXXXfUZ+Ml2rPqDk1fM31flzEaZ2RLlN9PlHJ4OX1CayTUJX9CDpsyb
         PbDMYdERBuv8o6yYJvAvxLvFCvjqH9DiNpd4L3MMSsXNrSc7vYkJc1g6C/ojpLyJE7xM
         +7yclOj+2DbFQz0XI6BeUKVmPcNnIsozgjIMC5NyVbMz/fdNHeWxuorWOw/OZvxsVee3
         mmfDSPrL/ae1gN/6xclblQGJadWBWKzBL/PQuChAWPHtF0lzk+BdABPd0KhIvjLyGz2F
         2ZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZlId46raQm99CyqcEPElFx6Ys5AGmgS/V/H8bCM/z48=;
        b=sM1ereanQEpaqj3mXvhGXjbp2vmQWHuze75SG1yT4Pe21YjZcMyQJfylO5EeONTAgp
         Sm3V7Ict9iOv1XXSXKL1jJAX9wikOW+w6rd0HH722EbIKQAs1FCqg8R4xlVhNzM2Kbeu
         OHm9rJZCEBi8aBeaWcqEb5zm2YfDGxaIwM8HJ5EQ3YQ2Toxwi9ubaStal04tsIm2HH+e
         7QnZlrpzhnPx0c8Tpt/xm5YBOd/+MU8IMS0bKLo87t+uv5Y5c5j7IGZqMJSq0oB6uzD4
         oVkAZpmDBGWGVZDD06qYdJnIPD7XxoOVakW2sTlre5NxPT03L5+GSmYkmPSKFPgUlzT/
         Yx5w==
X-Gm-Message-State: APjAAAXqFOM4vhJQZhICEwHhVMLpve7tZk3/8+dH0gbPOj7RNNOwerDg
        k1941m2jdPkJ0uhExVenRsh9p3gJz+k=
X-Google-Smtp-Source: APXvYqyfbVNkEp9ptutcT/HIk23YGDMu0z7cpjJumcXMtjv2ff2Py1UygXpNirH0xkzUCQRU0hyehw==
X-Received: by 2002:ac2:5b0f:: with SMTP id v15mr17717594lfn.99.1574863370840;
        Wed, 27 Nov 2019 06:02:50 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:02:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 01/19] trace-cmd: Implement new lib API: tracecmd_local_events_system()
Date:   Wed, 27 Nov 2019 16:02:29 +0200
Message-Id: <20191127140247.258766-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
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

