Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89274C3B18D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC11024706
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwWgmQtp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfLMPag (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:36 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34565 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbfLMPag (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:36 -0500
Received: by mail-lj1-f194.google.com with SMTP id m6so3022902ljc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=48DWwwEYyw48EygG6TFL0DnJZu3gTt59BdyysN0il34=;
        b=WwWgmQtpPip5SzSZkUwcO1ZjDCamt+W2tuN8lC30X49K3RNZyR9w4ThKwBrrkBTPr6
         F52p2SDIZpuGEgXJN8rZhYeWUGFWNLOoxX+mHQstXIgkvrv98GyTiFtQ998O5aSObBh0
         6GppiVgDsfuJBrtRu+Z0ErtWHRNym5DaRDolDkrBn+ugWilAzELyj+CdecsoLlUPMY4A
         KN8gOHF3Sp82326QKXVZCdEGKunSRTFqW52F3XqVcHZFNchG4yUDbV/IJBgF7+qYUulx
         s/SHoDlpU/T7NmjFr03lZXtWo6RDz6Oeykf01uFgtCE9PLGlc24Qr5szkBzCHNTOM6AN
         1iIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=48DWwwEYyw48EygG6TFL0DnJZu3gTt59BdyysN0il34=;
        b=p2Pp/MAHml6sqvj5x6zu7BHJqI4B8n7Hvr+xvY4Je1t+2GZKNrw6VBOQ/jl7KaPwR6
         vV+M376R9Gbd4Sl3AN3/sDQJve/O5piqFyE3Oj9YTnT8aNezZ95HbWUEgUGfyArm08VM
         nCVMT2BHkvjNs/8PcudaQwUUzQOZsIj7G9IPwXSlT6tIgaNAlM0NqLxL4R3E28QP59wB
         q9f38ge0ZJ4QGhQKnwMkvqISj00KggSOCT5P0C6O8Ay6ps3Bh24bDpYBG+L2Hk0ghN9m
         MLVZ7eBcFg+Q4DnKJiIOaLCKPAJy4Nh2LuWc/saaFHvTKiMFEJzHfjfZiDnw8fTcpX8V
         aEdg==
X-Gm-Message-State: APjAAAWUcQPfh5iVcq4rJjeVEbGQj3BxSx4tcDc+LPQyD/+4OwnOhcCw
        0RLY60cIjFYVri1Le9tE2qnTvesN2I0=
X-Google-Smtp-Source: APXvYqyMUhmOLjaRwjAQ1QootoRXXXtqydDN6DfbJHC+VdfZ+zVUaAxQuLwspucOf7K/CWLgNn3Btg==
X-Received: by 2002:a2e:b0e3:: with SMTP id h3mr9804208ljl.56.1576251033655;
        Fri, 13 Dec 2019 07:30:33 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 01/18] trace-cmd: Implement new lib API: tracecmd_local_events_system()
Date:   Fri, 13 Dec 2019 17:30:12 +0200
Message-Id: <20191213153029.133570-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

The new tracecmd lib API tracecmd_local_events_system() creates
a tep handler and initializes it with the events of the specified
subsystems. It can be used instead of tracecmd_local_events(), when
not all events are going to be parsed using that tep handler.

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
index b5bb0d5..e93225f 100644
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
+ * tracecmd_local_events_system - create a tep from the events of the specified subsystem
+ *
+ * @tracing_dir: The directory that contains the events
+ * @sys_name: Array of system names, to load the events from
+ * The last element from the array must be NULL
+ *
+ * Returns a tep structure that contains the tep local to
+ * the system
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
+ * @tracing_dir: The directory that contains the events
+ *
+ * Returns a pevent structure that contains the pevents local to
+ * the system
+ */
+struct tep_handle *tracecmd_local_events(const char *tracing_dir)
+{
+	return tracecmd_local_events_system(tracing_dir, NULL);
+}
+
+/**
+ * tracecmd_fill_local_events - Fill a pevent with the events on system
+ * @tracing_dir: The directory that contains the events
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

