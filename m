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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BC4C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02E4D6145A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhEGJvc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbhEGJv1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:51:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5FEC061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:50:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id t4so12757631ejo.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fewU8CCSpNVQZEazC24VUbehjl283KGqaJRi2EYCFao=;
        b=N95qtBDvwt9b/5DSeWx/sFdOw9p6Lne1fdeNitcXnhF6MlCOnryE9wUMJ+qU1vKPVs
         EZSs9TjZEpVgxK0QDXna+Iq2RSi/z8BOAReunH2WuXJC/osk4jxcc7ztZWztXTISthJg
         +UHdFIRrRKG7fOKeOM8e2bq3NKA/rvHSspvz9He858nvjgVnOenqcZQGpuumbTUVLsHG
         KDYYveJZj+khly8ZcV2b5SQcyT5mZIDXUzfg8p/fiSoQJ10c1Jn8Xo0hoJ9g4hVp8Kl/
         JusK9ZKdyxeW2UujQkAcvBif2Y1oq6l518PPJ8jRf6y6abiaftipxMbPTty2+nTQWu2r
         TgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fewU8CCSpNVQZEazC24VUbehjl283KGqaJRi2EYCFao=;
        b=huu3MS8XDH/iUJghjHowRcOtXjYrTD2TY5/kBZFP9U9GZc5SrhjhKl0GAI2r9nrC6Y
         DtHAI50OVkZUUK0T0bp7p9GU5NsmmjZWgkbN1xjFfHBH0zI1LSyX8Z+pLAoA4H3K8++8
         SmY14FLUdz+NJC3VWJbVJYIvpvEsLSuEr7BbYwzdv5KFFeqstL9lhCXtle3+quCqNcwZ
         Rrs2T4lv8CMCSO1EfP+UqQjzXMf8RimX1VBkScHipxEnzsy/aJIgJYtDG8kOQX3vqWSg
         7ENQnge++7Qk7nMzUdNcAc1a9gY7CGdxiIbZLknk7dOoPT1WCK06fWYOZkY9gCIk3K9R
         a8GA==
X-Gm-Message-State: AOAM531kVhjWoop2W6N+e9bdNW4MsXR10bBdDRX05UjrEJv4dy+klmIf
        kmgl/I/omSXm52GhqLSPGyM=
X-Google-Smtp-Source: ABdhPJyLHABCYRznmeSBb4iArMmBNQ0RnZrXNEPALeX/PfQmUNyD2oopO+jszfys6Xmmcf6WH5mt+A==
X-Received: by 2002:a17:906:d14c:: with SMTP id br12mr8925336ejb.429.1620381025550;
        Fri, 07 May 2021 02:50:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a24sm3787193edr.74.2021.05.07.02.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:50:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/4] libtraceevent: Add log levels
Date:   Fri,  7 May 2021 12:50:19 +0300
Message-Id: <20210507095022.1079364-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
References: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Defined levels of the library logs and new API to set the desired log
level. By default, only critical logs are enabled.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/event-parse.h | 12 ++++++++++++
 src/parse-utils.c | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/src/event-parse.h b/src/event-parse.h
index 05b156b..77be2b9 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -749,4 +749,16 @@ int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *sour
 
 int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter *filter2);
 
+/* Control library logs */
+enum tep_loglevel {
+	TEP_LOG_NONE = 0,
+	TEP_LOG_CRITICAL,
+	TEP_LOG_ERROR,
+	TEP_LOG_WARNING,
+	TEP_LOG_INFO,
+	TEP_LOG_DEBUG,
+	TEP_LOG_ALL
+};
+void tep_set_loglevel(enum tep_loglevel level);
+
 #endif /* _PARSE_EVENTS_H */
diff --git a/src/parse-utils.c b/src/parse-utils.c
index 6a4a2cd..bc89c44 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -9,8 +9,21 @@
 #include <stdarg.h>
 #include <errno.h>
 
+#include "event-parse.h"
+
 #define __weak __attribute__((weak))
 
+static int log_level = TEP_LOG_CRITICAL;
+
+/**
+ * tep_set_loglevel - set log level of the library
+ * @level: desired level of the library messages
+ */
+void tep_set_loglevel(enum tep_loglevel level)
+{
+	log_level = level;
+}
+
 int __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
 {
 	int ret = errno;
@@ -29,6 +42,9 @@ void __weak tep_warning(const char *fmt, ...)
 {
 	va_list ap;
 
+	if (log_level < TEP_LOG_WARNING)
+		return;
+
 	va_start(ap, fmt);
 	tep_vwarning("libtraceevent", fmt, ap);
 	va_end(ap);
-- 
2.31.1

