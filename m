Return-Path: <SRS0=KH1A=YA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CEDAC47404
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Oct 2019 11:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 398C52190F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Oct 2019 11:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HgSj9n2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfJGLtz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Oct 2019 07:49:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52768 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727588AbfJGLty (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Oct 2019 07:49:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id r19so12315970wmh.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Oct 2019 04:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=quTCgnXAEANb78+ujZiZtqg/yjkhnjJTI4XREtGC+Hk=;
        b=HgSj9n2Ml0jaPd0FN2NU1m/TTdy+2Zv73VEuiZaiuykCK6mXcmOKDkKC0JmMgL82PT
         xtuaPJb1Wg9SgI5Npi79cOSnm7XEMIdtYOk4wCzqvtLxFyO2O3K1BgQwDmCzTR7x2JuN
         i4uNWPm1ci3i/tnuM2viiMKtXk9agZkDl6F+n7+/ufY/KFW5T/JENwkbde33sS+TTD0S
         BqPiB1KD2V/NKyt7ugoeByd2JursdprUfpE8889W5SASOPltrq4J3jmBP6Weu3z4eQ+t
         iEzNVa74rbNxK1qBZPow9yfzcx0JrpMd60IV/HoLtQGsl1UXmN49RBjDiP9HGq5RYmNU
         y2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=quTCgnXAEANb78+ujZiZtqg/yjkhnjJTI4XREtGC+Hk=;
        b=OWcrViC2Fb227lphV6G1iAoP5JaHUavljJyC8ybbeJzfpEE8F8XNPh2ow/UOWyMIXg
         HOalUHxJX+0DVfET4OMJNhl2iJY5WxVfFzJN8fkdHag10I5/I6hfTgarJiq/9mDUEw6i
         WLPTxr6GT0VQ3fK2IwUEARAqkUC1NiY3lyjOPF89OIu4+Ff3Rijm+M4zrkXb2lClESTx
         cEVn3OrnUM3aS1n2VcmKFBP6mAQqgvxbHQPtA8aQVhOm91AJIOzlVe8vw4ZOecyEr9Ac
         wL1zn38Y7+fACmPDKCRmmdZOkdL8IYJNYtv3wokgp+XT4FOB0y/pIEY+j3cU069T3rTG
         0nTQ==
X-Gm-Message-State: APjAAAWXGztuNN3kOAtirjiRUtwmeTOkGNp9t1PRHxHtn++IyLejGXAZ
        uboHIralv0wGgXgIKI1fnaQ=
X-Google-Smtp-Source: APXvYqyhloQRNORCfOhqwmqrT7QI7Cc59raai/S+m0DPKeMWdHrCyWP1L7MLYaxQ0jVeJLEPsjXELw==
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr19300350wmi.108.1570448991781;
        Mon, 07 Oct 2019 04:49:51 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t13sm39350773wra.70.2019.10.07.04.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 04:49:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 2/3] trace-cmd: Load libtraceevent plugins from build folder, if exists.
Date:   Mon,  7 Oct 2019 14:49:46 +0300
Message-Id: <20191007114947.17104-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007114947.17104-1-tz.stoyanov@gmail.com>
References: <20191007114947.17104-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a development version of trace-cmd is built and run on the machine,
by default it loads only installed plugins, from system directories.
Thus, the development plugins will not be loaded. To simplify the development
process, a new logic is added:
  At plugins load time, check the location of trace-cmd application and look
  for "plugins" directory around it. If found, load plugins from it. Those
  plugins will be loaded last, so in case of duplication the "development"
  plugins win.
A two new APIs are introduced to libtraceevent, in order to accomplish this
logic:
 tep_load_plugins_dir() - loads tep plugins from a specific directory.
 tep_plugins_append() - Append two plugin lists.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  2 ++
 lib/trace-cmd/trace-input.c   |  7 +-----
 lib/trace-cmd/trace-util.c    | 42 +++++++++++++++++++++++++++++++++++
 tracecmd/trace-check-events.c |  7 +-----
 tracecmd/trace-list.c         | 14 ++----------
 5 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 4090eba..d1aaef8 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -24,6 +24,8 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigne
 extern int tracecmd_disable_sys_plugins;
 extern int tracecmd_disable_plugins;
 
+struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep);
+
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct tep_handle *tracecmd_local_events(const char *tracing_dir);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6102eb3..28da455 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2886,15 +2886,10 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	if (!handle->pevent)
 		goto failed_read;
 
-	if (tracecmd_disable_plugins)
-		tep_set_flag(handle->pevent, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
-		tep_set_flag(handle->pevent, TEP_DISABLE_SYS_PLUGINS);
-
 	/* register default ftrace functions first */
 	tracecmd_ftrace_overrides(handle, &handle->finfo);
 
-	handle->plugin_list = tep_load_plugins(handle->pevent);
+	handle->plugin_list = trace_load_plugins(handle->pevent);
 
 	tep_set_file_bigendian(handle->pevent, buf[0]);
 	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 8aa3b6c..690a135 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -860,6 +860,48 @@ void trace_util_free_plugin_files(char **files)
 	free(files);
 }
 
+static char *get_source_plugins_dir(void)
+{
+	char *p, path[PATH_MAX+1];
+	int ret;
+
+	ret = readlink("/proc/self/exe", path, PATH_MAX);
+	if (ret > PATH_MAX || ret < 0)
+		return NULL;
+
+	dirname(path);
+	p = strrchr(path, '/');
+	if (!p)
+		return NULL;
+	/* Check if we are in the the source tree */
+	if (strcmp(p, "/tracecmd") != 0)
+		return NULL;
+
+	strcpy(p, "/lib/traceevent/plugins");
+	return strdup(path);
+}
+
+struct tep_plugin_list*
+trace_load_plugins(struct tep_handle *tep)
+{
+	struct tep_plugin_list *list;
+	char *path;
+
+	if (tracecmd_disable_plugins)
+		tep_set_flag(tep, TEP_DISABLE_PLUGINS);
+	if (tracecmd_disable_sys_plugins)
+		tep_set_flag(tep, TEP_DISABLE_SYS_PLUGINS);
+
+	path = get_source_plugins_dir();
+	if (path)
+		tep_add_plugin_path(tep, path, TEP_PLUGIN_LAST);
+	free(path);
+
+	list = tep_load_plugins(tep);
+
+	return list;
+}
+
 char *tracecmd_get_tracing_file(const char *name)
 {
 	static const char *tracing;
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index b09fcd0..ffaae27 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -43,12 +43,7 @@ void trace_check_events(int argc, char **argv)
 	if (!pevent)
 		exit(EINVAL);
 
-	if (tracecmd_disable_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
-
-	list = tep_load_plugins(pevent);
+	list = trace_load_plugins(pevent);
 	ret = tracecmd_fill_local_events(tracing, pevent, &parsing_failures);
 	if (ret || parsing_failures)
 		ret = EINVAL;
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 65099a5..6b59117 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -317,14 +317,9 @@ static void show_plugin_options(void)
 	if (!pevent)
 		die("Can not allocate pevent\n");
 
-	if (tracecmd_disable_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
-
 	trace_seq_init(&s);
 
-	list = tep_load_plugins(pevent);
+	list = trace_load_plugins(pevent);
 	tep_plugin_print_options(&s);
 	trace_seq_do_printf(&s);
 	tep_unload_plugins(list, pevent);
@@ -348,14 +343,9 @@ static void show_plugins(void)
 	if (!pevent)
 		die("Can not allocate pevent\n");
 
-	if (tracecmd_disable_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_PLUGINS);
-	if (tracecmd_disable_sys_plugins)
-		tep_set_flag(pevent, TEP_DISABLE_SYS_PLUGINS);
-
 	trace_seq_init(&s);
 
-	list = tep_load_plugins(pevent);
+	list = trace_load_plugins(pevent);
 	tep_print_plugins(&s, "  ", "\n", list);
 
 	trace_seq_do_printf(&s);
-- 
2.21.0

