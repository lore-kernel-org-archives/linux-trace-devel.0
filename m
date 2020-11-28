Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFDDC64E7B
	for <linux-trace-devel@archiver.kernel.org>; Sat, 28 Nov 2020 22:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ECE92344C
	for <linux-trace-devel@archiver.kernel.org>; Sat, 28 Nov 2020 22:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="psNlDFWt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgK1Vuq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387510AbgK1TXP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 28 Nov 2020 14:23:15 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FA1C0613D2
        for <linux-trace-devel@vger.kernel.org>; Sat, 28 Nov 2020 11:22:35 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id d3so5318956wmb.4
        for <linux-trace-devel@vger.kernel.org>; Sat, 28 Nov 2020 11:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KnGWmKbQ6rw4aJkrnvltHZrldobCoChGcW/soZIIJiY=;
        b=psNlDFWt+jICkG8EguWan4VdxcAjEkRNom51XDSBNp9R+J6GxPHL0EWip8OTtAtI99
         M64NNIN4uzcYRc2qAbg6X6Mqtq2COr53QtPmzFFzr2NQSO3hm5bxmOi+SW/8uFafmRG7
         6EeLCX1YyORx0lw14uVZcULERtOE/mIUZPtgJR3uKDM5/sLaM04J2gSAlgm5CXenpK8h
         UNIUxh01ddNXJvImqNrrBsPJgbPeUbjAtWE6mVYTzHCI9GQ5OZLL2A3JH7a/g6GU/jdx
         Rjs/4BXSAg9qT4o4dDgU8sCpT4ApWyQyiWnLv+petYYmbG+ezML2MK2QZlocduAUKCjH
         KPPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KnGWmKbQ6rw4aJkrnvltHZrldobCoChGcW/soZIIJiY=;
        b=E1XL04cKS5W6tEjUko1d8C3hq/yGU1Tr6ESQb49ZeSK4PXWi1rH4Zq/lp4kR7XmUML
         778MoCpNfjneHHa8t3jwioSQymgTpFWdOapmjTmU7J6IwDaojcfBzlH5kJrH3SVCPMi0
         Z7gWE3Drf6n3ZhYnvoaOQVjNpYaiQ9dYxSehmRhtQ276kLDbIS2RQ2iXbmVheSAVamh5
         K9MuhLtuB8YpBVtJ0jLjgyr9aivkxtn6vS/8/eWIeL6hxlI+3Us4XXtERywnorLQkeT7
         c4I8ST0ARFfLksunwWGqbS2OKdWg4ioeUXxSTYU7eC50YuxDl+cFseehbkHchGgtLRtP
         5Grg==
X-Gm-Message-State: AOAM533ZI9XmB/NA+01JPBizyK1kJqnm3q9qeqWWFhVJr4aND4VqKh5K
        RO3fOAfiY0Pc0pWuwMK0nKj8mpD2tqo=
X-Google-Smtp-Source: ABdhPJxRE5Mt7mDb+8jTOAa6ik1TFz2Ksw3VEs5kebhP6G5QTYx1D5Olz8fgEbUpHzd/a3lrRF2UhA==
X-Received: by 2002:a1c:4456:: with SMTP id r83mr7096728wma.108.1606591353638;
        Sat, 28 Nov 2020 11:22:33 -0800 (PST)
Received: from localhost.localdomain (5-13-193-159.residential.rdsnet.ro. [5.13.193.159])
        by smtp.gmail.com with ESMTPSA id i11sm21914871wro.85.2020.11.28.11.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 11:22:32 -0800 (PST)
From:   Beniamin Sandu <beniaminsandu@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Beniamin Sandu <beniaminsandu@gmail.com>
Subject: [PATCH] trace-cmd: make it build against musl C library
Date:   Sat, 28 Nov 2020 21:22:21 +0200
Message-Id: <20201128192221.1165671-1-beniaminsandu@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

* add some missing headers and macros
* set pthread affinity using pthread_setaffinity_np after creating the thread
instead of pthread_attr_setaffinity_np (which seems to not be implemented
in musl)

Tested using https://musl.cc/x86_64-linux-musl-native.tgz

Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
 lib/trace-cmd/include/trace-cmd-local.h           |  1 +
 lib/tracefs/include/tracefs-local.h               | 12 ++++++++++++
 lib/tracefs/tracefs-events.c                      |  1 +
 tracecmd/include/trace-local.h                    |  1 +
 tracecmd/trace-tsync.c                            | 11 +++++++----
 6 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 458760e..a0dac5d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -6,6 +6,7 @@
 #ifndef _TRACE_CMD_PRIVATE_H
 #define _TRACE_CMD_PRIVATE_H
 
+#include <sys/types.h>
 #include "traceevent/event-parse.h"
 #include "trace-cmd/trace-cmd.h"
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index d0a7365..0cd2744 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -6,6 +6,7 @@
 #ifndef _TRACE_CMD_LOCAL_H
 #define _TRACE_CMD_LOCAL_H
 
+#include <byteswap.h>
 #include "trace-cmd-private.h"
 
 /* Can be overridden */
diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
index 9cc371b..bdbf89e 100644
--- a/lib/tracefs/include/tracefs-local.h
+++ b/lib/tracefs/include/tracefs-local.h
@@ -13,4 +13,16 @@ void warning(const char *fmt, ...);
 int str_read_file(const char *file, char **buffer);
 char *trace_append_file(const char *dir, const char *name);
 
+#ifndef ACCESSPERMS
+#define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
+#endif
+
+#ifndef ALLPERMS
+#define ALLPERMS (S_ISUID|S_ISGID|S_ISVTX|S_IRWXU|S_IRWXG|S_IRWXO) /* 07777 */
+#endif
+
+#ifndef DEFFILEMODE
+#define DEFFILEMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) /* 0666*/
+#endif
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
index 80a25ee..a4e5215 100644
--- a/lib/tracefs/tracefs-events.c
+++ b/lib/tracefs/tracefs-events.c
@@ -13,6 +13,7 @@
 #include <errno.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <limits.h>
 
 #include "kbuffer.h"
 #include "tracefs.h"
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 28d1b4e..85c7e03 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -8,6 +8,7 @@
 
 #include <sys/types.h>
 #include <dirent.h>	/* for DIR */
+#include <limits.h>
 
 #include "trace-cmd-private.h"
 #include "event-utils.h"
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index e639788..2cbe7f2 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -104,11 +104,13 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 
 	pthread_attr_init(&attrib);
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
-	if (!get_first_cpu(&pin_mask, &mask_size))
-		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
 
 	ret = pthread_create(&instance->tsync_thread, &attrib,
 			     tsync_host_thread, &instance->tsync);
+
+	if (!get_first_cpu(&pin_mask, &mask_size))
+		pthread_setaffinity_np(instance->tsync_thread, mask_size, pin_mask);
+
 	if (!ret)
 		instance->tsync_thread_running = true;
 	if (pin_mask)
@@ -243,11 +245,12 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
 	pthread_attr_init(&attrib);
 	tsync->sync_proto = proto;
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
-	if (!get_first_cpu(&pin_mask, &mask_size))
-		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
 
 	ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
 
+	if (!get_first_cpu(&pin_mask, &mask_size))
+		pthread_setaffinity_np(*thr_id, mask_size, pin_mask);
+
 	if (pin_mask)
 		CPU_FREE(pin_mask);
 	pthread_attr_destroy(&attrib);
-- 
2.25.1

