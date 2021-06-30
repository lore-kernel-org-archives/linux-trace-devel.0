Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A05C11F6C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF73361477
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 15:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbhF3PuC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 11:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235889AbhF3PuA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 11:50:00 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DC9761466;
        Wed, 30 Jun 2021 15:47:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lycR0-000Xoe-33; Wed, 30 Jun 2021 11:47:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 4/4] libtracefs: Implement tracefs_kprobe_clear_probe()
Date:   Wed, 30 Jun 2021 11:47:29 -0400
Message-Id: <20210630154729.129873-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210630154729.129873-1-rostedt@goodmis.org>
References: <20210630154729.129873-1-rostedt@goodmis.org>
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
 src/tracefs-kprobes.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 19b9b49d2dae..d7980c773b3d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -218,4 +218,5 @@ void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kprobe_clear(bool force);
+int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index a6faf69fc010..6f3fbac35d76 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -184,3 +184,32 @@ int tracefs_kprobe_clear(bool force)
 	free(content);
 	return ret;
 }
+
+int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force)
+{
+	char **instance_list;
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
+		instance_list = tracefs_instances(NULL);
+		disable_events(system, event, instance_list);
+		tracefs_list_free(instance_list);
+	}
+
+	ret = tracefs_instance_file_append(NULL, KPROBE_EVENTS, content);
+	free(content);
+
+	return ret < 0 ? -1 : 0;
+}
-- 
2.30.2

