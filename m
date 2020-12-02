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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4116C64E7C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 04:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 592F720679
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 04:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgLBEIq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 23:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgLBEIq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 23:08:46 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79C8C0613CF
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Dec 2020 20:08:05 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id m19so507085ejj.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Dec 2020 20:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=td9JLZ38aiuXJgmJroUEpdz2N+rsBHgJzMAZBPEOows=;
        b=UyNhPsvbnzE9vmPLFpffRWJW1I3UfHzlCDbLlLDBmbRcIrVOiXm/jWSsU7m2O+FA5e
         1Gti/xWAZ/4IlCCEl9tOJX/Sz9tBD0jn1hxMB7vGM+XNGyQJgWQrN9a/sAukR1Og3Lz6
         QI6XZ18lEhRNN5CSDPw+X8o3KkzydatfCOLaM3DzHbN7DJxPHRKijzyqcA1T4LzNMHH+
         JZDi60ZjCjRJWYC/UMW3Oah/G/s25tvsCAS0n98HXI0qiz44xnKoAReygy3RRnHBT1Rp
         Me9kZPwj4m9e6UYj+64tI8qbLrkeOYpPonI9QP4stM+nvBU18n43jiI0XXFIbz1lIzCx
         dZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=td9JLZ38aiuXJgmJroUEpdz2N+rsBHgJzMAZBPEOows=;
        b=dbSrhlCnUvs7sODWGv8UhIQq92243tuNCTrOirMeY5tb/6KF///0jOJlt7RbMa8zlx
         sjYGcRQ08P3cq5vZwHEuOZ2ybGRxBG5ag7PCWXvBdrQ3oFcsYf4CmWQwczJTCoGogb++
         gWNvWVu3D/Fizek18xDL/j/v4FvNaUJYNxR9aWasvf5lx7Do+9QaLYp5oC/l+VB/b3BQ
         hRP/JzIMIVoUendU3o4pe22uuGblAMAq9GLuYc7uulydQoGwwjpOSQiG88JKbeB3zLc8
         HA6QX/oSHHwrEyD+dwLAHCrIn7I7wshjnLQjzS0wYl4KY2gZgKF5w9pzRwF3IlyTwv8d
         4pIw==
X-Gm-Message-State: AOAM532GOYZWkrM1/hdbtJOfsRw0puQ1IKnRlpXAsGMV9g5qo6PIDr+N
        3QFVaCoBcCo9nWLcK9RH8ew=
X-Google-Smtp-Source: ABdhPJzdvbmIZlNufB7L5qunLHhtRn7U+cb5hzjcTvSepFCayvduDrSdzA21Vtwt8JVkEvtUEvpQOw==
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr501174eju.375.1606882084730;
        Tue, 01 Dec 2020 20:08:04 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z2sm261824edr.47.2020.12.01.20.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 20:08:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, beniaminsandu@gmail.com
Subject: [PATCH] libtracefs: make it build against musl C library
Date:   Wed,  2 Dec 2020 06:08:02 +0200
Message-Id: <20201202040802.327203-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Beniamin Sandu <beniaminsandu@gmail.com>

* add some missing headers and macros
* set pthread affinity using pthread_setaffinity_np after creating the thread
instead of pthread_attr_setaffinity_np (which seems to not be implemented
in musl)

Tested using https://musl.cc/x86_64-linux-musl-native.tgz

Link: https://lore.kernel.org/linux-trace-devel/20201130122755.31000-1-beniaminsandu@gmail.com

Reviewed-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>
[ Fixed a whitespace issue ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h | 12 ++++++++++++
 tracefs-events.c        |  1 +
 2 files changed, 13 insertions(+)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 9cc371b..bdbf89e 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
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
diff --git a/tracefs-events.c b/tracefs-events.c
index ca1d22b..ee45988 100644
--- a/tracefs-events.c
+++ b/tracefs-events.c
@@ -13,6 +13,7 @@
 #include <errno.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <limits.h>
 
 #include <traceevent/kbuffer.h>
 
-- 
2.28.0

