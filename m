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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B848C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 04:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F8A9610FC
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 04:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhDHE1p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 00:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhDHE1o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 00:27:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F973C061760
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 21:27:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x15so579644wrq.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Apr 2021 21:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K0FYpNPbhuhvNbVqALK1kwCsexJkZiB370PxBPeCa7Q=;
        b=jLyQh8RcPug+irGDVXS/upYTrVRnWU2uXkImiRuNWy059bsi2OvLmnyzptzoODtFJ6
         uVQu3c5Kimzs8IfK1qapfNkARwGIZvNeNtOQfabwiD0rAhwba2P5sGXaKuPm3R5XA7I/
         vrsEvPTOKbX/Xq77LtwLRrPC23bjs//O9Tp0PIZecr1SqxVYVcID+m9GjDFM5cp/Z5r/
         ZX6CCmmIy8xFl4IDgmyArqKU93aSBCB8E8k48S+0yIFK9M0OAWLTpH3ErThp5zhMZEu/
         BcufHTvjrSzTESpbgsDXi5OkywiJ9XASRkOCu/dPBwfSgf5M06+nZsJt7pcxdouwZBSg
         SGuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K0FYpNPbhuhvNbVqALK1kwCsexJkZiB370PxBPeCa7Q=;
        b=oLT1hZkGkIvAze8bTHaREXd+anrK46S2DW0/bUIDQswKF4n4+yeC+2PUGvJ68zj8mA
         kUp91y6r3VqWDgFvCcJCk8TmkEnJ/j7xXRdQqDx8fhds8xn/TjMtG4EL7VjrAjMvXT6o
         Zy/TeeIWtocpIQUKnar7DTpMaVC1V4N3SD30SiIOZBZHP9qmVO6VnSnOK/3m2QB6IDGe
         Oytwz2B+HI9zTxLThcDLWmjJuE1oiQOeQ12zsAFKXMFCXSA3vf344st9XpCjiy3lOL7t
         6pMnnoF3vUX4Z+JGRj1c5sJKxbsS/seQmuTQsmQwMkIjKsTE43tjVltQqndk5/hCcUGO
         iLpA==
X-Gm-Message-State: AOAM530j0DS1kUds9lMIvigY0RQaK/Y4tYo9hGkz5vyP6dCYM+IuYYIe
        IDG9JpzqugiBW6QEohI/Iy4GGNNTBtNtJw==
X-Google-Smtp-Source: ABdhPJzOl6tymWQyVGS+gxM5P37frxAMmnwj1rtTZDz5iR/VCGJqAdUOXPrk9o8KMmaKZ0yhXAeNBw==
X-Received: by 2002:a5d:630e:: with SMTP id i14mr8513918wru.137.1617856051042;
        Wed, 07 Apr 2021 21:27:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x1sm33610560wro.66.2021.04.07.21.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 21:27:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: Implement tracefs_warning()
Date:   Thu,  8 Apr 2021 07:27:29 +0300
Message-Id: <20210408042729.3112180-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The warning() function is used in a lot of places in the libracefs
library, and it is implemented as a dummy weak function. There is a
weak implementation of the same function in traceevent library, which
could cause a problem when both are used in an application.
Replaced warning() with tracefs_warning() and implemented it as a
weak function, specific to this library.
The tracefs_warning() uses tep_vwarning() from libtraceevent for
printing the warning, which is also a weak function and can be
overridden by the application.
Added a __weak define in the library internal header file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Depends on "[PATCH v2] libtraceevent: Add tep_warning()"
 https://lore.kernel.org/linux-trace-devel/20210408042623.3112002-1-tz.stoyanov@gmail.com/

 v2 changes:
  - Use tep_vwarning() for printing the warning message.

 include/tracefs-local.h |  3 ++-
 src/tracefs-events.c    |  2 +-
 src/tracefs-instance.c  |  8 ++++----
 src/tracefs-utils.c     | 17 ++++++++++++-----
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 73ec113..5a69ef7 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -7,6 +7,7 @@
 #define _TRACE_FS_LOCAL_H
 
 #define __hidden __attribute__((visibility ("hidden")))
+#define __weak __attribute__((weak))
 
 #define ARRAY_SIZE(array) (sizeof(array) / sizeof((array)[0]))
 
@@ -22,7 +23,7 @@ struct tracefs_instance {
 };
 
 /* Can be overridden */
-void warning(const char *fmt, ...);
+void tracefs_warning(const char *fmt, ...);
 
 int str_read_file(const char *file, char **buffer);
 char *trace_append_file(const char *dir, const char *name);
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index da56943..9a706ab 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -43,7 +43,7 @@ page_to_kbuf(struct tep_handle *tep, void *page, int size)
 
 	kbuffer_load_subbuffer(kbuf, page);
 	if (kbuffer_subbuffer_size(kbuf) > size) {
-		warning("%s: page_size > size", __func__);
+		tracefs_warning("%s: page_size > size", __func__);
 		kbuffer_free(kbuf);
 		kbuf = NULL;
 	}
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index bf2fabf..e87b360 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -203,7 +203,7 @@ int tracefs_instance_destroy(struct tracefs_instance *instance)
 	int ret = -1;
 
 	if (!instance || !instance->name) {
-		warning("Cannot remove top instance");
+		tracefs_warning("Cannot remove top instance");
 		return -1;
 	}
 
@@ -265,8 +265,8 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance)
 
 	ret = asprintf(&path, "%s/instances/%s", instance->trace_dir, instance->name);
 	if (ret < 0) {
-		warning("Failed to allocate path for instance %s",
-			 instance->name);
+		tracefs_warning("Failed to allocate path for instance %s",
+				instance->name);
 		return NULL;
 	}
 
@@ -308,7 +308,7 @@ static int write_file(const char *file, const char *str)
 
 	fd = open(file, O_WRONLY | O_TRUNC);
 	if (fd < 0) {
-		warning("Failed to open '%s'", file);
+		tracefs_warning("Failed to open '%s'", file);
 		return -1;
 	}
 	ret = write(fd, str, strlen(str));
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 0e96f8e..812a41a 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -13,7 +13,9 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <errno.h>
 
+#include <traceevent/event-utils.h>
 #include "tracefs.h"
 #include "tracefs-local.h"
 
@@ -23,8 +25,13 @@
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-void __attribute__((weak)) warning(const char *fmt, ...)
+void __weak tracefs_warning(const char *fmt, ...)
 {
+	va_list ap;
+
+	va_start(ap, fmt);
+	tep_vwarning("libtracefs", fmt, ap);
+	va_end(ap);
 }
 
 static int mount_tracefs(void)
@@ -76,7 +83,7 @@ __hidden char *trace_find_tracing_dir(void)
 
 	fp = fopen("/proc/mounts", "r");
 	if (!fp) {
-		warning("Can't open /proc/mounts for read");
+		tracefs_warning("Can't open /proc/mounts for read");
 		return NULL;
 	}
 
@@ -103,7 +110,7 @@ __hidden char *trace_find_tracing_dir(void)
 				fspath[PATH_MAX] = 0;
 			} else {
 				if (mount_debugfs() < 0) {
-					warning("debugfs not mounted, please mount");
+					tracefs_warning("debugfs not mounted, please mount");
 					free(debug_str);
 					return NULL;
 				}
@@ -200,7 +207,7 @@ __hidden int str_read_file(const char *file, char **buffer)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
-		warning("File %s not found", file);
+		tracefs_warning("File %s not found", file);
 		return -1;
 	}
 
@@ -210,7 +217,7 @@ __hidden int str_read_file(const char *file, char **buffer)
 			continue;
 		nbuf = realloc(buf, size+r+1);
 		if (!nbuf) {
-			warning("Failed to allocate file buffer");
+			tracefs_warning("Failed to allocate file buffer");
 			size = -1;
 			break;
 		}
-- 
2.30.2

