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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA5BC43462
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4705C6145D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhEGJvd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbhEGJva (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:51:30 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FFEC0613ED
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:50:28 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id b25so12656877eju.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EYmXLuz5HWqYvmjP3afWQgDI8brkrL0+fi+ydYlVaKA=;
        b=FF/c36hDXC41ouJ+1QocIjjhHl/UyT94ji/8FMyJCT0Phdfdc8C021QYaNd6DT3FpJ
         eJR1vUReEfh8gHzaM72wrpNZlf5jKco8jFtOmC0J055Pj+EkpRMAlJ5so3AOuVREP8mG
         3pGY4Q2EyI5HDYDRizZgMEuNc5onQv5qF7p/X3OwwEKDAVh3Uz4TM/RnG81Gykj/hudT
         wdvu5AO7+w3GnHxD8fhcT77EWuASzmZtGHFo41K81kV3PA6/oQZZ3AeE0mDqLkuNWSL3
         dEbkI2sQPtTA2NKrErhJdUYMBPWPx1iqnn/KPmHv/D1bx81lGx6eKwOcqB9i5A8Fs8p2
         vwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EYmXLuz5HWqYvmjP3afWQgDI8brkrL0+fi+ydYlVaKA=;
        b=oPDKsqj3Em1HJKs9XFNqxwXrxQY1HSR7To5P7UGSLd6IlJ4vzmSM/RD/+823aC4nop
         gU8Y7kHcNTjVA2XFhz/tkfDNeNsHvkdpjXPt4kJ+9rDLJED+KgIu5UDsLplc+DOJ/CRM
         5fIks5p5Tvcca98rtVi61RujbthL7QRew5pxC2ivhyNfbSDjpZh5oZ4jIs+GQw/9pEJF
         8xWsl2UOKQTQgxEPmjL+6OV+8iglu9IgezsssynrZxKYLbPrf1gCBvUArp+NO++laKvV
         GJsHv1VIjJ8AgWJ1aHtMSNp73T24xzZvGEHU2M5XSRQmITDtkvJrCV4Nh8Oz0QEpBPX/
         O+Sg==
X-Gm-Message-State: AOAM533LPUG//ko2Wf3GmEueB8ez1YQ3N8ty1k12ngqDlS9qZnzRDbTG
        9zqr1APzs9YYul36/7ALXP4=
X-Google-Smtp-Source: ABdhPJwtX1qbTovF7gEDe5aPZO836HgZJ+NGT5wXZdwiwkTDHtXcLLcdykDpDv1JAW5kVyIEMVPwbg==
X-Received: by 2002:a17:906:d0c8:: with SMTP id bq8mr8770996ejb.423.1620381027616;
        Fri, 07 May 2021 02:50:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a24sm3787193edr.74.2021.05.07.02.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:50:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/4] libtraceevent: Rename tep_vwarning() to tep_vprint()
Date:   Fri,  7 May 2021 12:50:21 +0300
Message-Id: <20210507095022.1079364-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
References: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Renamed the existing weak function tep_vwarning() to tep_vprint(), to
match its purpose. This function is used to print library logs with any
log severity, not only warnings.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/event-utils.h |  5 +++--
 src/parse-utils.c | 27 ++++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/src/event-utils.h b/src/event-utils.h
index 1951557..0617a28 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -9,10 +9,11 @@
 #include <ctype.h>
 #include <stdarg.h>
 
+void tep_warning(const char *fmt, ...);
 void tep_info(const char *fmt, ...);
 /* Can be overridden */
-void tep_warning(const char *fmt, ...);
-int tep_vwarning(const char *name, const char *fmt, va_list ap);
+int tep_vprint(const char *name, enum tep_loglevel level,
+	       bool print_err, const char *fmt, va_list ap);
 
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
diff --git a/src/parse-utils.c b/src/parse-utils.c
index b997823..7510157 100644
--- a/src/parse-utils.c
+++ b/src/parse-utils.c
@@ -24,11 +24,28 @@ void tep_set_loglevel(enum tep_loglevel level)
 	log_level = level;
 }
 
-int __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
+/**
+ * tep_vprint - print library log messages
+ * @name: name of the library.
+ * @level: severity of the log message. This parameter is not used in this implementation, but as
+ *	   the function is weak and can be overridden, having the log level could be useful
+ *	   for other implementations.
+ * @print_err: whether to print the errno, if non zero.
+ * @fmt: printf format string of the message.
+ * @ap: list of printf parameters.
+ *
+ * This function is used to print all messages from traceevent, tracefs and trace-cmd libraries.
+ * It is defined as weak, so the application that uses those libraries can override it in order
+ * to implement its own logic for printing library logs.
+ *
+ * Return the value of errno at the function enter.
+ */
+int __weak tep_vprint(const char *name, enum tep_loglevel level,
+		      bool print_err, const char *fmt, va_list ap)
 {
 	int ret = errno;
 
-	if (errno)
+	if (errno && print_err)
 		perror(name);
 
 	fprintf(stderr, "  ");
@@ -38,7 +55,7 @@ int __weak tep_vwarning(const char *name, const char *fmt, va_list ap)
 	return ret;
 }
 
-void __weak tep_warning(const char *fmt, ...)
+void tep_warning(const char *fmt, ...)
 {
 	va_list ap;
 
@@ -46,7 +63,7 @@ void __weak tep_warning(const char *fmt, ...)
 		return;
 
 	va_start(ap, fmt);
-	tep_vwarning("libtraceevent", fmt, ap);
+	tep_vprint("libtraceevent", TEP_LOG_WARNING, true, fmt, ap);
 	va_end(ap);
 }
 
@@ -59,6 +76,6 @@ void tep_info(const char *fmt, ...)
 		return;
 
 	va_start(ap, fmt);
-	tep_vwarning("libtraceevent", fmt, ap);
+	tep_vprint("libtraceevent", TEP_LOG_INFO, false, fmt, ap);
 	va_end(ap);
 }
-- 
2.31.1

