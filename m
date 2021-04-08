Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0668C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 13:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A4061153
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 13:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhDHNfF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:35:05 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:3322 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231721AbhDHNfD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 09:35:03 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 06:34:45 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 79D9020C0C;
        Thu,  8 Apr 2021 06:34:48 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 5/5] libtracefs: Add a pthread_mutex per instance
Date:   Thu, 8 Apr 2021 09:34:31 -0400
Message-ID: <20210408133431.2023697-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210408133431.2023697-1-rostedt@goodmis.org>
References: <20210408133431.2023697-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a pthread_mutex per instance such that modifications being done on
specific instances do not interfere with each other. This also includes a
new "toplevel_lock" that is to be used when modifying the toplevel
instance.

Convert the filter_mutex over to the toplevel/instance locking.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h | 13 ++++++++-----
 src/tracefs-instance.c  |  5 +++++
 src/tracefs-tools.c     |  8 +++++---
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 060de7e..6865611 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -15,13 +15,16 @@
 	do { if (!(1/!(cond))) { } } while (0)
 
 struct tracefs_instance {
-	char	*trace_dir;
-	char	*name;
-	int	flags;
-	int	ftrace_filter_fd;
-	int	ftrace_notrace_fd;
+	char			*trace_dir;
+	char			*name;
+	pthread_mutex_t		lock;
+	int			flags;
+	int			ftrace_filter_fd;
+	int			ftrace_notrace_fd;
 };
 
+extern pthread_mutex_t toplevel_lock;
+
 /* Can be overridden */
 void warning(const char *fmt, ...);
 
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 6ccf7d8..41ad1f5 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -15,6 +15,7 @@
 #include <fcntl.h>
 #include <dirent.h>
 #include <limits.h>
+#include <pthread.h>
 #include "tracefs.h"
 #include "tracefs-local.h"
 
@@ -43,6 +44,9 @@ static struct tracefs_instance *instance_alloc(const char *trace_dir, const char
 			goto error;
 	}
 
+	if (pthread_mutex_init(&instance->lock, NULL) < 0)
+		goto error;
+
 	instance->ftrace_filter_fd = -1;
 	instance->ftrace_notrace_fd = -1;
 
@@ -76,6 +80,7 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 
 	free(instance->trace_dir);
 	free(instance->name);
+	pthread_mutex_destroy(&instance->lock);
 	free(instance);
 }
 
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 0f733b4..037875f 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -19,6 +19,8 @@
 #include "tracefs.h"
 #include "tracefs-local.h"
 
+__hidden pthread_mutex_t toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
+
 #define TRACE_CTRL		"tracing_on"
 #define TRACE_FILTER		"set_ftrace_filter"
 #define TRACE_NOTRACE		"set_ftrace_notrace"
@@ -27,7 +29,6 @@
 /* File descriptor for Top level set_ftrace_filter  */
 static int ftrace_filter_fd = -1;
 static int ftrace_notrace_fd = -1;
-static pthread_mutex_t filter_lock = PTHREAD_MUTEX_INITIALIZER;
 
 static const char * const options_map[] = {
 	"unknown",
@@ -755,6 +756,7 @@ static int update_filter(const char *filter_path, int *fd,
 	bool reset = flags & TRACEFS_FL_RESET;
 	bool cont = flags & TRACEFS_FL_CONTINUE;
 	bool future = flags & TRACEFS_FL_FUTURE;
+	pthread_mutex_t *lock = instance ? &instance->lock : &toplevel_lock;
 	int open_flags;
 	int ret = 1;
 
@@ -764,7 +766,7 @@ static int update_filter(const char *filter_path, int *fd,
 		return 1;
 	}
 
-	pthread_mutex_lock(&filter_lock);
+	pthread_mutex_lock(lock);
 
 	/* RESET is only allowed if the file is not opened yet */
 	if (reset && *fd >= 0) {
@@ -839,7 +841,7 @@ static int update_filter(const char *filter_path, int *fd,
  out_free:
 	free_func_list(func_list);
  out:
-	pthread_mutex_unlock(&filter_lock);
+	pthread_mutex_unlock(lock);
 
 	return ret;
 }
-- 
2.29.2

