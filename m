Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCE4C4360F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5964120857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfCSPzm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:55:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38003 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfCSPzl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 11:55:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id a188so16979657wmf.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 08:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WzYI0MXO56en0+SaHSh0HOvk8L3Kp48n8+Ba5YN3xF0=;
        b=T7PqN29V/M8L9D1sbq4p2J11GkJvIOo6TRfvIssK12TdUyzma9/nehXjn8c8LfAJaZ
         vRQ3Ese/CzWC6q8jd1oO5V7Ekwxs0HcnQj5f76Uu5UdZgy4IJEmRvgHYR6t57XihoPnS
         301TJOHrYLKjHWADr65mNjGh2lmp44F2mafpJQf9cGwkoqXvuV1jxHL2IkJWQJeh75X4
         7oycYsPtHF3SDl5kAutsgRzLtncA6y8qg/WSghjMKmJbIn9q2+2EYxVvaEKMvbMyI6z5
         y3uqqY9uJLEtCgKH3ky4OVHuD83h96Ns1qxDMtaKLj2yyK4x5+cSziE9CidKG0uD9Z3V
         cTZg==
X-Gm-Message-State: APjAAAUuUh1qlZqWAZNkX/9eWBkbBiPpRibVSiFD51h5xc6oveNrbNLM
        gWnWimk/qgqocAIqFUWh4yo=
X-Google-Smtp-Source: APXvYqw6HsYrmVMzd0+zsWjHzwNg766glLiAdV5KOPpElpcQGEahUSXZ57F75MKjYJGM8IoDlAVXiw==
X-Received: by 2002:a7b:c403:: with SMTP id k3mr4266053wmi.58.1553010939322;
        Tue, 19 Mar 2019 08:55:39 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t15sm9365911wrr.16.2019.03.19.08.55.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 08:55:38 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 1/9] trace-cmd: Implemented new lib API: tracecmd_local_events_system()
Date:   Tue, 19 Mar 2019 17:55:28 +0200
Message-Id: <20190319155536.19381-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319155536.19381-1-tstoyanov@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
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
index b5aea39..9cbd93b 100644
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
+		if (!contains(name, sys_names))
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

