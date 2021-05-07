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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA87EC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 869AF613CD
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbhEGJw7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbhEGJw7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:52:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FD3C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:51:59 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id m12so12710664eja.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QQ5VglO2wJ0+HHv9EofTSb3WyZz3JsCTNZXMBILZdtQ=;
        b=t+8XmDMGShmPTqFylaXDSvUr86RnY3Vurqj5YCbn0DrzCZZEJqTi3hxjDbJ5hspewm
         vWxuOh4Kg5jyYFZCVn/lLKREynXE2fGjjTdhVzDLC1M2g+ZN6HmLf6KBASPaKXlLB7eZ
         PElIpVfBtRl0wTgVbP8nQHir/tNIVZUcC/zSz3aZ5Wbyh6D+8tPIhaWxjKZs+v4Iz3Qo
         lD6HINf4n6WBJ4AiyEU9pLzHgveMo6YjJC+yFq19L+P4dI9fcRD6rMMfhzHTSVGIi/jl
         sJng+LV/uLesMFRebh6DbikF47JDlt7vLQwwmNLf31aM3UAAOaVpORLGg/9aIs04Ce4d
         hRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QQ5VglO2wJ0+HHv9EofTSb3WyZz3JsCTNZXMBILZdtQ=;
        b=eTcUpEpX0HpXvJiZVpGc4gPgZWhKG8YbPrkDd6EKE2d8dLZakT5CoWe11QwczTTeq8
         lcdfXkCrCcNYeNWEYBJBLVB0gCIUEzI2j24QN0+O9gdDAuteeQPvjeSbB2+C2s4jcHM6
         SjgUzZQHGx9SrPkjwCLhc7jZug+bE7jE6nl9k0FUmOxLSRlykfgO1nO1kQumQ6E8UNHi
         q0o9cH3vZoyQah9woOwca0JcWDE2ZoSgms1T3Md+gMofnylST9A0VQBJliovKqvUCHww
         RTMro063jqrpM7EmfixL+K73i8iFbC6tIly8COL4wC/CyumEmVoy8gXxYwwm3oocA+p4
         WfYA==
X-Gm-Message-State: AOAM531llcRFyrlrxq0BvVhkFc6FGDozKHJnMDiejLJNEf4l0WqaqsS+
        1OLcxNMNpUAV2Gfhz3MwrHkMRQPVx23g2g==
X-Google-Smtp-Source: ABdhPJwqB/QTCkVHgPbm3Zr8o6+bfgvJBURNUkQPrmjXcNgqLD7bwdVb4ghoL0AFWstNLsqnB2pKYg==
X-Received: by 2002:a17:906:b104:: with SMTP id u4mr8981159ejy.211.1620381118292;
        Fri, 07 May 2021 02:51:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eb9sm3130893ejc.96.2021.05.07.02.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:51:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/3] libtracefs: Add API to set the log level
Date:   Fri,  7 May 2021 12:51:52 +0300
Message-Id: <20210507095154.1080202-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095154.1080202-1-tz.stoyanov@gmail.com>
References: <20210507095154.1080202-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Library log level is added and new API to set the desired level.
Log levels defined in libtraceevent are used. By default, the log level
of tracefs library is TEP_LOG_CRITICAL. When a new level is set, it is
also propagated to the libtraceevent.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h   |  4 ++++
 src/tracefs-utils.c | 18 +++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 73ee42b..08dda13 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -180,4 +180,8 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
 			     const char *module, unsigned int flags);
 
+
+/* Control library logs */
+void tracefs_set_loglevel(enum tep_loglevel level);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index e10b333..9e37e75 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <errno.h>
 
+#include <traceevent/event-parse.h>
 #include <traceevent/event-utils.h>
 #include "tracefs.h"
 #include "tracefs-local.h"
@@ -25,12 +26,27 @@
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
+static int log_level = TEP_LOG_CRITICAL;
+
+/**
+ * tracefs_set_loglevel - set log level of the library
+ * @level: desired level of the library messages
+ */
+void tracefs_set_loglevel(enum tep_loglevel level)
+{
+	log_level = level;
+	tep_set_loglevel(level);
+}
+
 void __weak tracefs_warning(const char *fmt, ...)
 {
 	va_list ap;
 
+	if (log_level < TEP_LOG_WARNING)
+		return;
+
 	va_start(ap, fmt);
-	tep_vwarning("libtracefs", fmt, ap);
+	tep_vprint("libtracefs", TEP_LOG_WARNING, true, fmt, ap);
 	va_end(ap);
 }
 
-- 
2.31.1

