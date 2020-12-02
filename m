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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFF0C64E7B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 17:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2042B221FA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 17:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgLBRfg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgLBRfg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 12:35:36 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E76FC0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 09:34:56 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id y22so4910606edv.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Dec 2020 09:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k7HWHkdVwSZrDlrib+FMt/5xAZ81txwEJShZNo4tjfA=;
        b=g+/KoFEjsrvv5I/Vb+RX6PgE0kbMNF8wYxZYjVy5enMYjYTroZAQJ7AP0GPOZs1xCu
         nSC4MUURKulqjrXeWoE5ZBtPJ+Nx/bjpWNrdgQHiaMmD2G91OOg8aNMkXtEZ80H3tpmA
         +cGjiOVUnxyZN4hfP3e6f6J/od+JhtTjksq8LvStWfCsu57oetcmqW2sOxR1GPXN1pRr
         W6lh7QzD0n5pZwCn0zbQ9IYS7W8r+82LZiGWwPtDpZ9C5dCb59dP4AUj1hnlUePva3t1
         n6XTJ5p+rHwShqgh1TYP6bcqvNdajtBKxg5fOh4Wu93/1SehVj8YolBKpRMbQJo7anL7
         lDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k7HWHkdVwSZrDlrib+FMt/5xAZ81txwEJShZNo4tjfA=;
        b=PjTVicIGk/3o5MKUZNIbUrMs6Iyh1egsKfO7OxDgtTbrtnb6TOdrEXiGRQcSIiNKR0
         kTCUVJvbW/QIVrCXnav6qdImdnDnNl6yy7VhiQZ3Fb3+R4ro8LzZRUHFpVeOIyz+Up2d
         liUEaanl1qiIwqPgPK5jGW8WO0tm2rKAFF9gybz5OtOlhNLNg6hI8b0yGWDPxbTD7Akv
         CYqlp3lXOSUj9gRIGUQ2XA6MjPDzbapqSpo7EpCIKPFTeSHzvegYYneAp62sIkdvlsO3
         zRTP8YnymMcVIahM51yH4lCAV/YSuPsCKy/Vlp8rpTdbvg/Lcqt8qgp8wrEbCECPuB/Z
         pylQ==
X-Gm-Message-State: AOAM532UYn9DkaZMv+Xjjm1b0yKTu4mRnKCMcdvVx9p+jurM4ZOWodML
        AEDquuZBCWyKxgfZLWqtw+4=
X-Google-Smtp-Source: ABdhPJz3vvyQc4qL5ALO86hgIiHBL69V6KoG3g+TI4Vnnth6UpmxgaFw1KQkjKE/WD6RmO6fsSMKgg==
X-Received: by 2002:aa7:dac5:: with SMTP id x5mr1061051eds.198.1606930494738;
        Wed, 02 Dec 2020 09:34:54 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r1sm360370eje.51.2020.12.02.09.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 09:34:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     beniaminsandu@gmail.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: make it build against musl C library
Date:   Wed,  2 Dec 2020 19:34:52 +0200
Message-Id: <20201202173452.440349-1-tz.stoyanov@gmail.com>
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
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
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

