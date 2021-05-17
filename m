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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942AEC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A457611BF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbhEQNl0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhEQNlZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:41:25 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6134EC061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:09 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id k10so9261097ejj.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SudxD4UZxhW/p8ZhQet0h3YmNrxCM+8a0ySSyKYnMQE=;
        b=MfNW+d9tia7wYfbH6ilEpFLjtUH+0jpsOguwvKtaEINQp2FuEDc6CRzkwUB4K6ksRa
         gPCiKtnWOHLDYQ/tk6WkWPecGpdSft2Fc10SgxFVbj4ITx8UKdS9Mg8dIdL6woCGIGBQ
         AJ6e5LnLfS9iOiRVxf2d0dgZ+iHpPD/+mtYGQF+pC0B3Bb+a/6ltfufRbrnvcaSPJx8D
         MXJMMfLJ6PIWjJh/7KjX16ZUy0lyiCpWBMs4Zm4WMH1hBwUOXjZz3OhXrCjlS/WB84XX
         qwPZmkNbT/rn+qcslNbMjxxZMNfCzUqGGSaggExQKBrQ23xIqsM6blLzxhRPn7uSbSzC
         +Liw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SudxD4UZxhW/p8ZhQet0h3YmNrxCM+8a0ySSyKYnMQE=;
        b=VDAwgKeeq2Bzpe5/vhNa+52ClNZV/YsViG6iom16xroS7GWUidUtCQamgzLGYuqagT
         mtbE6vVLmb8+0TattVGw00brINtNeV8Q0iReHDF15LEEsLwYbDn1hvye5DzB2iHkn4R+
         GNqDJ+7UIE6TCky+xeLrBekHSl5xF6fU7pBocKU333n7yXx7Yf6+MTz1trj1AX6S4SCf
         GtPR4OkRYXQCL4eoe3DxaCa/Q5jh3FNug47JP3Xc3igYoczMxj+GtRJB52ZmnxyRXK6T
         GLM04NCaPvFqB4+pJLS7T4N5bXZjl163ICFqp0oJCLKSywp7ScFeVZhPjhQ/rFcUqZiC
         dggg==
X-Gm-Message-State: AOAM531D9O7ZpwZmOx1vE403YiHWODGtlqsiCsQvBIz8HdS2A9DvS4lM
        7joYtsiuNK5z1ouVApi4wBwEsXzQeglgLg==
X-Google-Smtp-Source: ABdhPJz6+zWSFKGU0Ajw9icS1D9KEiIOxpdS2lbIGcIYQP2i/rJd3CSJMZ6nupPJl/j9DSdfCimg8w==
X-Received: by 2002:a17:906:1ed1:: with SMTP id m17mr63636853ejj.208.1621258808194;
        Mon, 17 May 2021 06:40:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r25sm10961799edv.78.2021.05.17.06.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:40:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/6] trace-cmd library: Add log levels
Date:   Mon, 17 May 2021 16:40:00 +0300
Message-Id: <20210517134005.611251-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517134005.611251-1-tz.stoyanov@gmail.com>
References: <20210517134005.611251-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add levels to library logs and introduce a new API to set the desired
log severity:
 tracecmd_set_loglevel()
When a new trace-cmd library log level is set, propagate it to tracefs
and traceevent libraries as well.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  2 ++
 lib/trace-cmd/trace-util.c    | 24 ++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7305487c..6984db86 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -43,4 +43,6 @@ int tracecmd_buffer_instances(struct tracecmd_input *handle);
 const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
 struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
 
+void tracecmd_set_loglevel(enum tep_loglevel level);
+
 #endif /* _TRACE_CMD_H */
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 049fe049..6db754e4 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -30,7 +30,7 @@
 #define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
 static bool debug;
-
+static int log_level = TEP_LOG_CRITICAL;
 static FILE *logfp;
 
 const static struct {
@@ -355,19 +355,36 @@ trace_load_plugins(struct tep_handle *tep, int flags)
 	return list;
 }
 
+/**
+ * tracecmd_set_loglevel - set log level of the library
+ * @level: desired level of the library messages
+ */
+void tracecmd_set_loglevel(enum tep_loglevel level)
+{
+	log_level = level;
+	tracefs_set_loglevel(level);
+	tep_set_loglevel(level);
+}
+
 void __weak tracecmd_warning(const char *fmt, ...)
 {
 	va_list ap;
 
+	if (log_level < TEP_LOG_WARNING)
+		return;
+
 	va_start(ap, fmt);
 	tep_vprint("libtracecmd", TEP_LOG_WARNING, true, fmt, ap);
 	va_end(ap);
 }
 
-void tracecmd_info(const char *fmt, ...)
+void __weak tracecmd_info(const char *fmt, ...)
 {
 	va_list ap;
 
+	if (log_level < TEP_LOG_INFO)
+		return;
+
 	va_start(ap, fmt);
 	tep_vprint("libtracecmd", TEP_LOG_INFO, false, fmt, ap);
 	va_end(ap);
@@ -379,6 +396,9 @@ void __weak tracecmd_fatal(const char *fmt, ...)
 	int ret;
 	va_list ap;
 
+	if (log_level < TEP_LOG_CRITICAL)
+		return;
+
 	va_start(ap, fmt);
 	ret = tep_vprint("libtracecmd", TEP_LOG_CRITICAL, true, fmt, ap);
 	va_end(ap);
-- 
2.31.1

