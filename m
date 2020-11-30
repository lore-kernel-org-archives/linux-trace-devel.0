Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF63C64E7B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Nov 2020 12:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50AB92074A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Nov 2020 12:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fs+KRjtD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgK3M2r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 07:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgK3M2r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 07:28:47 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC508C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Nov 2020 04:28:06 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id o1so2000584wrx.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Nov 2020 04:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A4naiNINMUS/8CXy8O1+JSd64iVyPgueNHbW1GAJx5E=;
        b=Fs+KRjtDFkPWLId7oDzBto3q51vNobJC5YCyTr4vjzVmd0cS07KIw1pUd0rBa++oxD
         Ie4zdFXsS5OTWX+xTu4hRjW80h8jiubLYObdAC0y+jMqcY2rywAN8OA/OwcSeOAtj6Np
         8JtVW99LkiOkIXmPI9RDsOyhWWvNEVx2CEU0OKUhB/TSFwf04ddVkiNpVI0YlEO/0f3v
         YQHNJWWhlsx9REG3VDt1ti+KALPJ2SN1KbHh515zfslOaoHwljtLPq6tszw2fHfWyUMh
         o3rCfgXrV/xRd/nQthVh6MXTWSR+k6LL8Osl9zBl5hwJ/J/Xu5wdpSnQzQ/bLQ5xVHKZ
         xG1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A4naiNINMUS/8CXy8O1+JSd64iVyPgueNHbW1GAJx5E=;
        b=Irv52w6vVhqUrdXSBY9ectFhZwO2OxYiTdOTzSNHX+m2MtcqTyB6vaFrCcVDtMObqz
         s///J9HdRLMTNW9HTutJBejOcofYeCkhdHFFY+0uGJVvxfEHjcs21EX6o0G2QfO62A86
         x7PPJyFaVommcAyU6HzDgUMmYgKSBwZKyel9ImNYZ7c8ISHFXZiLt2m++A8cs31wbrMn
         MMS7jOFukYbcrPq+Ybv/JD5QwNg+7AktcvqNRy4k/7VS10DGh781Dza6Pc7ebwnXwXab
         Ng9OmVcJGEGkjPL27SpRZUH5g/6C2IDlQYHdYY0o43b+qADiTLj6AEojsgd6e7T0dhjO
         S5dA==
X-Gm-Message-State: AOAM531DmBt22UuScS3PZuBuXHgxNO8uNe9DDEKgB9/NDspmaMHdCk/E
        cAsTl1Z5NYw9+jFDjgdSSOoLX/fEMeo=
X-Google-Smtp-Source: ABdhPJwTKjkUhH7PTJ4c75fGCX2+6qT6DA3V+IeVCYQ5PYAOFsFSUY/T8cOxQ3mv+pqjs0ds7vskZw==
X-Received: by 2002:adf:e80b:: with SMTP id o11mr28998079wrm.409.1606739285269;
        Mon, 30 Nov 2020 04:28:05 -0800 (PST)
Received: from localhost.localdomain (5-13-193-159.residential.rdsnet.ro. [5.13.193.159])
        by smtp.gmail.com with ESMTPSA id k11sm18298650wmj.42.2020.11.30.04.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 04:28:04 -0800 (PST)
From:   Beniamin Sandu <beniaminsandu@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Beniamin Sandu <beniaminsandu@gmail.com>
Subject: [PATCH v2] trace-cmd: make it build against musl C library
Date:   Mon, 30 Nov 2020 14:27:55 +0200
Message-Id: <20201130122755.31000-1-beniaminsandu@gmail.com>
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
 .../include/private/trace-cmd-private.h          |  1 +
 lib/trace-cmd/include/trace-cmd-local.h          |  1 +
 lib/tracefs/include/tracefs-local.h              | 12 ++++++++++++
 lib/tracefs/tracefs-events.c                     |  1 +
 tracecmd/include/trace-local.h                   |  1 +
 tracecmd/trace-tsync.c                           | 16 +++++++++++-----
 6 files changed, 27 insertions(+), 5 deletions(-)

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
index e639788..1fce6d0 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -104,13 +104,16 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 
 	pthread_attr_init(&attrib);
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
-	if (!get_first_cpu(&pin_mask, &mask_size))
-		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
 
 	ret = pthread_create(&instance->tsync_thread, &attrib,
 			     tsync_host_thread, &instance->tsync);
-	if (!ret)
+
+	if (!ret) {
+		if (!get_first_cpu(&pin_mask, &mask_size))
+			pthread_setaffinity_np(instance->tsync_thread, mask_size, pin_mask);
 		instance->tsync_thread_running = true;
+	}
+
 	if (pin_mask)
 		CPU_FREE(pin_mask);
 	pthread_attr_destroy(&attrib);
@@ -243,11 +246,14 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
 	pthread_attr_init(&attrib);
 	tsync->sync_proto = proto;
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
-	if (!get_first_cpu(&pin_mask, &mask_size))
-		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
 
 	ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
 
+	if(!ret) {
+		if (!get_first_cpu(&pin_mask, &mask_size))
+			pthread_setaffinity_np(*thr_id, mask_size, pin_mask);
+	}
+
 	if (pin_mask)
 		CPU_FREE(pin_mask);
 	pthread_attr_destroy(&attrib);
-- 
2.25.1

