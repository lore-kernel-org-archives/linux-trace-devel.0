Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5F9C07E9E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 03:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9A8061CC3
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 03:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhGGDNw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 23:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhGGDNw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 23:13:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5AF361CB9;
        Wed,  7 Jul 2021 03:11:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m0xxv-00130b-M0; Tue, 06 Jul 2021 23:11:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] libtracefs: Have instances have internal ref counting
Date:   Tue,  6 Jul 2021 23:11:09 -0400
Message-Id: <20210707031110.249759-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707031110.249759-1-rostedt@goodmis.org>
References: <20210707031110.249759-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a way to keep ref counts on accesses to instances. This way, another
structure can hold a reference to an instance, and if the user frees that
instance, it wont be freed until the other structure frees it.

That is, if we create a structure called tracefs_hist, that takes an
instance on its creation. It can hold a reference to that instance, and
make sure that it does not get freed:

  instance = tracefs_instance_create("my_instance");
  hist = tracefs_hist_alloc(instance, "sched", "sched_wakeup", "pid", 0);

  tracefs_instance_free(instance);

  tracefs_hist_start(hist);
  [..]
  tracefs_hist_free(hist);

Will not crash, as the tracefs_instance_free() will not free the instance
as there's still a reference on it, and tracefs_hist_start() will still
have that reference. But then when the tracefs_hist_free() is called, then
the instance will get freed.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h |  4 +++
 src/tracefs-instance.c  | 56 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 512f17a7c812..2324dec9d076 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -25,6 +25,7 @@ struct tracefs_instance {
 	char				*trace_dir;
 	char				*name;
 	pthread_mutex_t			lock;
+	int				ref;
 	int				flags;
 	int				ftrace_filter_fd;
 	int				ftrace_notrace_fd;
@@ -41,6 +42,9 @@ static inline pthread_mutex_t *trace_get_lock(struct tracefs_instance *instance)
 	return instance ? &instance->lock : &toplevel_lock;
 }
 
+void trace_put_instance(struct tracefs_instance *instance);
+int trace_get_instance(struct tracefs_instance *instance);
+
 /* Can be overridden */
 void tracefs_warning(const char *fmt, ...);
 
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 11fb580456ff..185d968ae319 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -20,7 +20,11 @@
 #include "tracefs.h"
 #include "tracefs-local.h"
 
-#define FLAG_INSTANCE_NEWLY_CREATED	(1 << 0)
+enum {
+	FLAG_INSTANCE_NEWLY_CREATED	= (1 << 0),
+	FLAG_INSTANCE_DELETED		= (1 << 1),
+};
+
 
 struct tracefs_options_mask	toplevel_supported_opts;
 struct tracefs_options_mask	toplevel_enabled_opts;
@@ -79,15 +83,30 @@ error:
 	return NULL;
 }
 
-/**
- * tracefs_instance_free - Free an instance, previously allocated by
-			   tracefs_instance_create()
- * @instance: Pointer to the instance to be freed
- *
- */
-void tracefs_instance_free(struct tracefs_instance *instance)
+
+__hidden int trace_get_instance(struct tracefs_instance *instance)
 {
-	if (!instance)
+	int ret;
+
+	pthread_mutex_lock(&instance->lock);
+	if (instance->flags & FLAG_INSTANCE_DELETED) {
+		ret = -1;
+	} else {
+		instance->ref++;
+		ret = 0;
+	}
+	pthread_mutex_unlock(&instance->lock);
+	return ret;
+}
+
+__hidden void trace_put_instance(struct tracefs_instance *instance)
+{
+	pthread_mutex_lock(&instance->lock);
+	if (--instance->ref < 0)
+		instance->flags |= FLAG_INSTANCE_DELETED;
+	pthread_mutex_unlock(&instance->lock);
+
+	if (!(instance->flags & FLAG_INSTANCE_DELETED))
 		return;
 
 	if (instance->ftrace_filter_fd >= 0)
@@ -108,6 +127,20 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 	free(instance);
 }
 
+/**
+ * tracefs_instance_free - Free an instance, previously allocated by
+			   tracefs_instance_create()
+ * @instance: Pointer to the instance to be freed
+ *
+ */
+void tracefs_instance_free(struct tracefs_instance *instance)
+{
+	if (!instance)
+		return;
+
+	trace_put_instance(instance);
+}
+
 static mode_t get_trace_file_permissions(char *name)
 {
 	mode_t rmode = 0;
@@ -248,6 +281,11 @@ int tracefs_instance_destroy(struct tracefs_instance *instance)
 	if (path)
 		ret = rmdir(path);
 	tracefs_put_tracing_file(path);
+	if (ret) {
+		pthread_mutex_lock(&instance->lock);
+		instance->flags |= FLAG_INSTANCE_DELETED;
+		pthread_mutex_unlock(&instance->lock);
+	}
 
 	return ret;
 }
-- 
2.30.2

