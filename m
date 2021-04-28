Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEF4C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF81613D8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbhD1Hav (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhD1Hau (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:30:50 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFA4C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:30:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id w3so93162712ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+eigHkpaNbg45Tt4TdTfL0tA6GwEZIfvUmL0kqbGThA=;
        b=r+8FOFL6Fp9vdErw7g7CQ1nLW3ViTCw6MglX/fB84GuxZr6KupPgXYrxqrptElnJTo
         nRxzZHemPqcKeYwJgzp2j3m/nMe4t8tzzRIL3o1sBqNB/lJjuiRZ58VKz1OBppkcFHWV
         uoz81kopzP/eIoPSo/zfjJwXABELydUqqt6H6bOlGesWtR3AjFeT19TOCx+bmbnbgj0O
         63wgNHVCv4WpiWFKyp5l9wW5O7i8S9jrX/wUzVbJuxaNy036WggWLMm1a4Ih1LEllIGI
         pGPC3Bfb7LsBUEMEeLuIhRvVy+97QBnlx9NpzcFh+ZvKl8O089HTkkZTomquXD6Xo7mb
         IS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+eigHkpaNbg45Tt4TdTfL0tA6GwEZIfvUmL0kqbGThA=;
        b=d38K9vqmec+TwBYhbcfBJTDZsQ7jf1rNVd53TSg4r/WFkAcCk4/ikciISWrb7tr5Ws
         hlOx0LgXG3ciqpSQjh99/Rj4wnUDmyfwMH22E+Hrqn3UBVTecLKMlZJuD6I9mza/mMs8
         Ccbg6OJQmxs8XzGMPChVV3C410XN/xZzRFRJX0rrNBGJR5uPfooGHt5WFs6J5sXpFrCG
         dqfz3O27v48gcPxILxRXLX0SdMwEnVxNhFFCJeDj2mPD0M2wBL3bewQaPw4NGEx62HgO
         AZgPt7P9gOLdxFtHLF/d4Rj62a88jnSxijoXYDotS48BfcpIRbWB3IFcBljuQLHPDltW
         T2fw==
X-Gm-Message-State: AOAM531se3EwAeBAjthGcSJ4TQr3ZMb+gG/gq6IQlv4296Nux24SerXq
        UjZ1tybGT4oUdfo2nCjbqc4=
X-Google-Smtp-Source: ABdhPJyhI70LU0zf6A23GenhBFw1ZBYyaAdKBPmRmh41yYOHhiFImh1lxhQ3Sy7Ndhe9+azEuHQjKA==
X-Received: by 2002:a17:906:507:: with SMTP id j7mr10928054eja.151.1619595004609;
        Wed, 28 Apr 2021 00:30:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dh6sm4274292edb.63.2021.04.28.00.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:30:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] libtraceevent: Add log levels
Date:   Wed, 28 Apr 2021 10:29:58 +0300
Message-Id: <20210428073001.755905-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428073001.755905-1-tz.stoyanov@gmail.com>
References: <20210428073001.755905-1-tz.stoyanov@gmail.com>
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
2.30.2

