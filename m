Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 096A6C11F69
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB60561D78
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Jun 2021 20:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbhF2U4L (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235527AbhF2U4J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 16:56:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E52BE60FF0;
        Tue, 29 Jun 2021 20:53:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lyKjj-000UTB-V6; Tue, 29 Jun 2021 16:53:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracefs: Implement tracefs_kprobe_clear_probe()
Date:   Tue, 29 Jun 2021 16:53:26 -0400
Message-Id: <20210629205326.117059-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629205326.117059-1-rostedt@goodmis.org>
References: <20210629205326.117059-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the function tracefs_kprobe_clear_probe() that will remove a single
kprobe. If the @force parameter is set, it will disable that probe in all
instances (including the top level instance) before removing it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h     |  1 +
 src/tracefs-kprobes.c | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 54c461e85a2b..447821e65ce2 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -213,4 +213,5 @@ void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kprobe_clear(bool force);
+int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 48a4f090f041..27d4c2181404 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -204,3 +204,39 @@ int tracefs_kprobe_clear(bool force)
 	free_instance_list(list);
 	return ret;
 }
+
+int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force)
+{
+	struct instance_list *list = NULL;
+	struct instance_list **plist = &list;
+	char *content;
+	int ret;
+
+	if (!system)
+		system = "kprobes";
+
+	ret = asprintf(&content, "-:%s/%s", system, event);
+	if (ret < 0)
+		return -1;
+
+	/*
+	 * Since we know we are disabling a specific event, try
+	 * to disable it first before clearing it.
+	 */
+	if (force) {
+		ret = tracefs_instances_walk(build_instances, &plist);
+		if (ret < 0)
+			goto out;
+
+		ret = disable_events(system, event, list);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, content);
+ out:
+	free(content);
+	free_instance_list(list);
+
+	return ret < 0 ? -1 : 0;
+}
-- 
2.30.2

