Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2848C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 10:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345936AbhLBLCy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 06:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbhLBLCx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 06:02:53 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708EFC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 02:59:31 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x6so113968428edr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 02:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8y5S0KqVL6cied6EKvfwWZipESfhLPD48J9SEk1nB6w=;
        b=a9P+dDJVTZzz0mgI4AMrcTVofSeW6W6Gx6mkEVb7vaRZIqIfDmPVt2XSsieEIl48CS
         Iu4GWtDAqQqAbyoQY7PQc4S1z2tQZC3vopZtimXfGYNUEGExVp0r80R28Om+UTE2aiqJ
         ipaKWwtBrb00N+RA0EwJok8NOzo4R0iFPa3XKQKkCZEKIOoyV1SptRPh5luJIyYxRmK7
         1Ws2wF3zYUsx65VhvNs+jQPf6D0gF4hNS7sRhgCWYJbLzggmInQweI6XbDVl6gZE95sT
         qNndpCJchFB8wwIvl/mVV2b5F1+8URpKXZVzZqaIkZWx8ObJMLq5as5rlyZrUfXvV+kW
         IwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8y5S0KqVL6cied6EKvfwWZipESfhLPD48J9SEk1nB6w=;
        b=oVwm76JizZXltYUytcIhZfOwuGuPDVCFDchmE6l6lWGjPx2aRAuTbrhShH31fynhn4
         NjEvoEKT9VXajR76tsGEGKmhfk48HzUTsTT9EmYa2wi/QpkQyt+Xow7qKunTaX9uCyDH
         vSQ13ikp1CTa+LJ9LQV+tN9FAcOxM3vj+QFXjUMPzL3pbNiLFnwsMksHxeUuOlw7FoYa
         S3RnKfu7OvF/dnOTxrPkTVTLFZckLAGKIR8L2OFFX84zNljxZpH4WhscSt9lvJj6OQGJ
         2dOlQFdU0NYTiuKVs2q71iayzly3M5Jj94OEZYniX63tlRKeqKkSYUZwuS6XqmvZt7X4
         dw6A==
X-Gm-Message-State: AOAM5333gatRApn3fGo9BWnzaIrCahdJaqqeX1QiqI/WGNEoAlwym7dl
        szcM9wKCEYBQ9Pg53UaH5B85009EKWgilQ==
X-Google-Smtp-Source: ABdhPJzuA8PCfM9r9SMu2X47XYK/zENY754HN2nXCBCCew4c8wLRLJ5+5TfdVFiCYP3shsuLXCIrjg==
X-Received: by 2002:a05:6402:26c8:: with SMTP id x8mr17194823edd.156.1638442770039;
        Thu, 02 Dec 2021 02:59:30 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e19sm1852930edu.47.2021.12.02.02.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 02:59:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/4] libtracefs: Reuse logic for loading events inside the library
Date:   Thu,  2 Dec 2021 12:59:23 +0200
Message-Id: <20211202105926.32581-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202105926.32581-1-tz.stoyanov@gmail.com>
References: <20211202105926.32581-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for parsing and loading new tep events could be reused in
tracefs library. Two new internal APIs are introduced:
	trace_load_events()
	trace_rescan_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs-local.h |  5 +++++
 src/tracefs-events.c    | 26 +++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index a59e806..daea5da 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -112,4 +112,9 @@ dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
 	       const char *event, const char *address, const char *format);
 int dynevent_get_count(unsigned int types, const char *system);
 
+int trace_load_events(struct tep_handle *tep,
+		      const char *tracing_dir, const char *system);
+int trace_rescan_events(struct tep_handle *tep,
+			const char *tracing_dir, const char *system);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 4679926..067f6e0 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -689,7 +689,7 @@ char **tracefs_tracers(const char *tracing_dir)
 }
 
 static int load_events(struct tep_handle *tep,
-		       const char *tracing_dir, const char *system)
+		       const char *tracing_dir, const char *system, bool check)
 {
 	int ret = 0, failure = 0;
 	char **events = NULL;
@@ -697,6 +697,9 @@ static int load_events(struct tep_handle *tep,
 	int len = 0;
 	int i;
 
+	if (!tracing_dir)
+		tracing_dir = tracefs_tracing_dir();
+
 	events = tracefs_system_events(tracing_dir, system);
 	if (!events)
 		return -ENOENT;
@@ -716,6 +719,10 @@ static int load_events(struct tep_handle *tep,
 		if (ret < 0)
 			goto next_event;
 
+		/* check if event is already added, to avoid duplicates */
+		if (check && tep_find_event_by_name(tep, system, events[i]))
+			goto next_event;
+
 		len = str_read_file(format, &buf, true);
 		if (len <= 0)
 			goto next_event;
@@ -732,6 +739,19 @@ next_event:
 	return failure;
 }
 
+__hidden int trace_rescan_events(struct tep_handle *tep,
+				const char *tracing_dir, const char *system)
+{
+	/* ToDo: add here logic for deleting removed events from tep handle */
+	return load_events(tep, tracing_dir, system, true);
+}
+
+__hidden int trace_load_events(struct tep_handle *tep,
+			       const char *tracing_dir, const char *system)
+{
+	return load_events(tep, tracing_dir, system, false);
+}
+
 static int read_header(struct tep_handle *tep, const char *tracing_dir)
 {
 	struct stat st;
@@ -886,14 +906,14 @@ static int fill_local_events_system(const char *tracing_dir,
 	for (i = 0; systems[i]; i++) {
 		if (sys_names && !contains(systems[i], sys_names))
 			continue;
-		ret = load_events(tep, tracing_dir, systems[i]);
+		ret = trace_load_events(tep, tracing_dir, systems[i]);
 		if (ret && parsing_failures)
 			(*parsing_failures)++;
 	}
 
 	/* Include ftrace, as it is excluded for not having "enable" file */
 	if (!sys_names || contains("ftrace", sys_names))
-		load_events(tep, tracing_dir, "ftrace");
+		trace_load_events(tep, tracing_dir, "ftrace");
 
 	load_mappings(tracing_dir, tep);
 
-- 
2.33.1

