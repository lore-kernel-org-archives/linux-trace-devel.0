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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39FDC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 05:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 996F7613D0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 05:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbhDGFMK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 01:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbhDGFMK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 01:12:10 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135A9C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 22:12:00 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f12so10467436wro.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Apr 2021 22:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dby1Gtj+UfRH0qsyE/TlZ8PaMRd63uAnbcWaiFOx2Pg=;
        b=WZaHlR2ExUJM2uCQUaS5p9QB/yo71L9Du62RY6o9zMdA1gP4eglZBu5JS6qeLHit78
         Pp927VZvCZGeEozBhPsW+PedQFpHZDSUECp3MpzhHPDwlXd0MNPLLFyECFCMtx7oWvQg
         BfwbcVMA0wGXmo8Lj0iLGFhLHYpyAlKUBVePzjzwYzhWGv3GkfNEoAJhYigKKK+9NvCO
         lgQ/RVrK6Ts1iy3n3Ln9IA0Xas6zJ7dheq9wiyW6yeXaXYbRJlTCVJp+zZv7Nvmbf786
         ggtnvHem7v9VQWLIlEBCxbwGgT50weIkZnR2v05Bg2kUmlqYhwbNlCS/iPLmypHn8Rtm
         mruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dby1Gtj+UfRH0qsyE/TlZ8PaMRd63uAnbcWaiFOx2Pg=;
        b=IOc1hU+PeVsq2E6vve3/M/mW9OyeNb/zl2lT4u7QSWs5mAitczS+M+mgi6Oueg3P51
         pEZLj1q3yq22Eku0/D3eTXAVsU5X5t3yEOBEw1BFg4ILU9Qy+X/tQDgYPH+7i3ZcnsKG
         AdBUsxQEWoeyM7hmVv+Elbii7N+MLfyja306iz2zBzeHjf2qN4uFna8GeZusJFpt6wvC
         BNQGopLtlNt9yqca0oLWfFIF+VxN6Q5Xfnj8USV9n+7K8Q5jqMZIrErYxPpgij1wGhIU
         6KIfhbZNAAf4qY3YlJikNrlhW/Zinx0HhzBPVR4+V+1sUqZ1tSq2tMBJ8A9bMGT1wTlA
         x9eQ==
X-Gm-Message-State: AOAM532yaxLaz/lUiYLxQiWc/Mqw/AH+Rbl1ZFm3mbAWM7e1JPPys+bz
        g9kTHus7Uv8LTf56/kzQ0Q+kRVuV9ki/Og==
X-Google-Smtp-Source: ABdhPJxlMFO611iq22/iCi4zQh4y+38bPMYHI6vFK6R/aLyBsRDPkplHeQob/GE8vyW9NH3XVVfd5w==
X-Received: by 2002:a05:6000:cd:: with SMTP id q13mr1967719wrx.346.1617772317708;
        Tue, 06 Apr 2021 22:11:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x1sm25919709wro.66.2021.04.06.22.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 22:11:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Implement tracefs_warning()
Date:   Wed,  7 Apr 2021 08:11:54 +0300
Message-Id: <20210407051154.2422172-1-tz.stoyanov@gmail.com>
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
Added a __weak define in the library internal header file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs-local.h |  3 ++-
 src/tracefs-events.c    |  2 +-
 src/tracefs-instance.c  |  8 ++++----
 src/tracefs-utils.c     | 31 ++++++++++++++++++++++++++-----
 4 files changed, 33 insertions(+), 11 deletions(-)

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
index 0e96f8e..9a70175 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -13,6 +13,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#include <errno.h>
 
 #include "tracefs.h"
 #include "tracefs-local.h"
@@ -23,8 +24,28 @@
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-void __attribute__((weak)) warning(const char *fmt, ...)
+static int __vlib_warning(const char *fmt, va_list ap)
 {
+	int ret = errno;
+
+	if (errno)
+		perror("libtracefs");
+
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+
+	fprintf(stderr, "\n");
+
+	return ret;
+}
+
+void __weak tracefs_warning(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vlib_warning(fmt, ap);
+	va_end(ap);
 }
 
 static int mount_tracefs(void)
@@ -76,7 +97,7 @@ __hidden char *trace_find_tracing_dir(void)
 
 	fp = fopen("/proc/mounts", "r");
 	if (!fp) {
-		warning("Can't open /proc/mounts for read");
+		tracefs_warning("Can't open /proc/mounts for read");
 		return NULL;
 	}
 
@@ -103,7 +124,7 @@ __hidden char *trace_find_tracing_dir(void)
 				fspath[PATH_MAX] = 0;
 			} else {
 				if (mount_debugfs() < 0) {
-					warning("debugfs not mounted, please mount");
+					tracefs_warning("debugfs not mounted, please mount");
 					free(debug_str);
 					return NULL;
 				}
@@ -200,7 +221,7 @@ __hidden int str_read_file(const char *file, char **buffer)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
-		warning("File %s not found", file);
+		tracefs_warning("File %s not found", file);
 		return -1;
 	}
 
@@ -210,7 +231,7 @@ __hidden int str_read_file(const char *file, char **buffer)
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

