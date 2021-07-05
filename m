Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D49C07E99
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Jul 2021 12:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D1A61374
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Jul 2021 12:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhGEM37 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Jul 2021 08:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhGEM36 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Jul 2021 08:29:58 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0014C061574
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Jul 2021 05:27:21 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id w13so11301154wmc.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Jul 2021 05:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m8UX9OyhAUJxiW/9OWcqyjgCaijho/tkJ54c5wHAlvU=;
        b=LLQ+vSibrWHl9XFC10OMQ/5WG2laYhI72Y4A0/B4pn8Y/vxzrLYTj9W9PVXUwZVyhK
         pQlDHx8IDuy84V3pMT5nj0Z+jzaCD726ZmeftzhuMjFM/OEZH2+TkK+HRrLigCHLDDzb
         ufr11Jg2KpKFfgrnXnrlz0pVBqmwiSmsCh2ZAWvn9z45g3kwDMxcb+n/1gXCHza6jdo6
         unuiu0HMNiCxe2yYbL2taawlPfBwlPjew99KpQqGUisGFq7jSEI5X5JTjwxdyOvWO86w
         kvcaafAElHP6AAYpAlY57CtJVmzYmJicl2EcoaC+5Bk0X7WpMf9hnR3qefeF/38FJ2l2
         skgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m8UX9OyhAUJxiW/9OWcqyjgCaijho/tkJ54c5wHAlvU=;
        b=hKP9yW4sQICXPyUFMzC634Nbl2fT77NYWWh/h46b15XzAJFP2gahiuCK5tknsRXRZE
         SR4KpVD0Vd0Z3j+LWDkUeqBAAQcWG1RD+FQiuBmL1lJqSBCXZ9e7BI7ePJUxQ3weGXcZ
         x1UWKoiIY7067gGje6d80LksU1R2+F+kkYGdZSPXn20AyM89XrrR1OdI67qWAJxEns7e
         d1pt1UFKn/XooAeJ1kR3BOJ09VXqGRAcd6tOVR0m96dJ9AeJsTpzobPhYAqWX0gKuFL+
         h9tpgxYyt8+ProFdT/iouZoIewjLL+5vhZ2MQ1neVgcNcO+WrhrNfhMdNrENq5wc09QU
         wlnw==
X-Gm-Message-State: AOAM533KWIkKdqlzK673xcN6JH5ts03kBtb6Jvb9HQ0JrJvMrKwCEHnx
        AexoTaDiOuXaRuxny0i8OqY=
X-Google-Smtp-Source: ABdhPJzFdokYGvR8DIwSIwW+nyrSF3MpsCD4tWi/z80pRBSMeAwczPkago9cBH//1WvqTmlo5evdgA==
X-Received: by 2002:a05:600c:282:: with SMTP id 2mr14342621wmk.77.1625488040468;
        Mon, 05 Jul 2021 05:27:20 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id 16sm12094914wmk.18.2021.07.05.05.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 05:27:20 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH] libtracefs: Add tracefs_iterate_stop()
Date:   Mon,  5 Jul 2021 15:27:06 +0300
Message-Id: <20210705122706.146428-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the API for data streaming we implemented a special
function (tracefs_trace_pipe_stop()) that can be called from
the user in order to terminate the continuous streaming of the
tracing data. Here we add similar functionality that can be
used to terminate the continuous iteration over the raw events.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs-local.h |  1 +
 include/tracefs.h       |  1 +
 src/tracefs-events.c    | 27 ++++++++++++++++++++++++---
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 73698e8..5a469f9 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -31,6 +31,7 @@ struct tracefs_instance {
 	int				ftrace_marker_fd;
 	int				ftrace_marker_raw_fd;
 	bool				pipe_keep_going;
+	bool				iterate_keep_going;
 };
 
 extern pthread_mutex_t toplevel_lock;
diff --git a/include/tracefs.h b/include/tracefs.h
index 1c8703a..07124ef 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -97,6 +97,7 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 						struct tep_record *,
 						int, void *),
 				void *callback_context);
+void tracefs_iterate_stop(struct tracefs_instance *instance);
 
 char **tracefs_tracers(const char *tracing_dir);
 
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 568bfe6..3093bdd 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -109,7 +109,8 @@ static int read_cpu_pages(struct tep_handle *tep, struct cpu_iterate *cpus, int
 			  int (*callback)(struct tep_event *,
 					  struct tep_record *,
 					  int, void *),
-			  void *callback_context)
+			  void *callback_context,
+			  bool *keep_going)
 {
 	bool has_data = false;
 	int ret;
@@ -121,7 +122,7 @@ static int read_cpu_pages(struct tep_handle *tep, struct cpu_iterate *cpus, int
 			has_data = true;
 	}
 
-	while (has_data) {
+	while (has_data && *(volatile bool *)keep_going) {
 		j = count;
 		for (i = 0; i < count; i++) {
 			if (!cpus[i].event)
@@ -205,6 +206,8 @@ out:
 	return ret;
 }
 
+static bool top_iterate_keep_going;
+
 /*
  * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
  *				per CPU trace buffers
@@ -230,18 +233,24 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 						int, void *),
 				void *callback_context)
 {
+	bool *keep_going = instance ? &instance->pipe_keep_going :
+				      &top_iterate_keep_going;
 	struct cpu_iterate *all_cpus = NULL;
 	int count = 0;
 	int ret;
 	int i;
 
+	(*(volatile bool *)keep_going) = true;
+
 	if (!tep || !callback)
 		return -1;
 
 	ret = open_cpu_files(instance, cpus, cpu_size, &all_cpus, &count);
 	if (ret < 0)
 		goto out;
-	ret = read_cpu_pages(tep, all_cpus, count, callback, callback_context);
+	ret = read_cpu_pages(tep, all_cpus, count,
+			     callback, callback_context,
+			     keep_going);
 
 out:
 	if (all_cpus) {
@@ -256,6 +265,18 @@ out:
 	return ret;
 }
 
+/**
+ * tracefs_iterate_stop - stop the iteration over the raw events.
+ * @instance: ftrace instance, can be NULL for top tracing instance.
+ */
+void tracefs_iterate_stop(struct tracefs_instance *instance)
+{
+	if (instance)
+		instance->iterate_keep_going = false;
+	else
+		top_iterate_keep_going = false;
+}
+
 static char **add_list_string(char **list, const char *name, int len)
 {
 	if (!list)
-- 
2.27.0

