Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6BCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9652A61284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhKKPJv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbhKKPJu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:09:50 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60D6C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:00 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id f8so25584951edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t2RTbigUu8hgnrUlUjYIspTrn/p5f4JzJAqGjWL0i9M=;
        b=atTBCozxyaHN6zaF0vaPI5WIewjaCBWyOAL9yp/YVbh4hGcn+bneWCIHlmisTgDoI/
         8GRFqJxfqL2iVdrEF0zU+hIYheyzn/Wmr1OSKU+BMWtM5sXqh5C+c7P2bPo0RoApGj54
         F3Txc45EmpmA99qN7DlDP0MY/UboOKtxOwfBW/UUUTpRV0leXfmpTZGQXjPkQkBGOyGo
         ZpwlKth4EWg9MpcSMfDqgYPrHUOmUJK4yKTd51SFI1nsSTAhIZtiQ3JlxgiDJHcN8dpz
         spkurYHnnQ9mAxMpWN51K+R4wPRtSkyimAMDcPk8M5AYj4ipM2MMEygyhWNaA+DdulAw
         0aRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t2RTbigUu8hgnrUlUjYIspTrn/p5f4JzJAqGjWL0i9M=;
        b=mQsH4LoWJuxSJVzAukU0ttBMNLKIpNU60ThVfiGDEpb3nphb92ido3nNq2mfXD9aBD
         JXGS5nt/C/EdJB3Jct/w1kKkSS9ld52zPWT14JDrHLHFjwKLGB1RSYtOEh83nv1VftxV
         Eogfr9I+/8KlNBeZUCmM9SGVukCSfGLWbwlI7CwV3+yN7VUNRyOfkOUyZ3vpExr4Qn4v
         ed+Pk5Ij+grM+t9nDmTuEWpwkQhKB73hOpI2Wmaabq1ZjXik18nL5vukvV1jnXer1Lll
         Be9nCJcNUuonQy5Mux0JmlMyfBfRwkVGpz3G9aTTE4fZtj70L6d4Vn9LIdm22rErV5Ve
         b0vg==
X-Gm-Message-State: AOAM532TC0tisxxxKyAJA4ScpTkY1x5rgTxrkzbEyEWPVXHq9a6FWy8i
        OaexVjZCdEkBunZbpJGG1lTzg4aURE/5wA==
X-Google-Smtp-Source: ABdhPJzIfXsPrt7UtoajnICxRZHCDjPFD3l4pxN0pyu2xnZcqn7/MrccT3iwAT44naUyAyn31pv8Sw==
X-Received: by 2002:a05:6402:26ce:: with SMTP id x14mr10726091edd.326.1636643219498;
        Thu, 11 Nov 2021 07:06:59 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h7sm1665678edt.37.2021.11.11.07.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:06:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/10] trace-cmd library: New API for setting a custom kallsyms to an output handler
Date:   Thu, 11 Nov 2021 17:06:58 +0200
Message-Id: <20211111150658.86228-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API associates an output file handler with a custom kernel symbols
file. It is used when creating the trace file instead of the system default
kernel symbols file.
 tracecmd_output_set_kallsyms()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 32 +++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index eb173a39..23e86107 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -273,6 +273,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd);
 int tracecmd_output_set_msg(struct tracecmd_output *handler,
 			    struct tracecmd_msg_handle *msg_handle);
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
+int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a5d7ed5f..c654561a 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -54,6 +54,7 @@ struct tracecmd_output {
 	int			cpus;
 	struct tep_handle	*pevent;
 	char			*tracing_dir;
+	char			*kallsyms;
 	int			nr_options;
 	bool			quiet;
 	unsigned long		file_state;
@@ -767,8 +768,8 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 		return -1;
 	}
 
-	if (kallsyms)
-		path = kallsyms;
+	if (handle->kallsyms)
+		path = handle->kallsyms;
 
 	ret = stat(path, &st);
 	if (ret < 0) {
@@ -968,6 +969,33 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *t
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_kallsyms - Set a custom kernel symbols file, instead of system default
+ * @handle: output handler to a trace file.
+ * @tracing_dir: full path to a file with kernel symbols
+ *
+ * This API associates an output file handler with a custom kernel symbols file, to be used when
+ * creating the trace file instead of the system default kernel symbols file.
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	free(handler->kallsyms);
+	if (kallsyms) {
+		handler->kallsyms = strdup(kallsyms);
+		if (!handler->kallsyms)
+			return -1;
+	} else
+		handler->kallsyms = NULL;
+
+	return 0;
+}
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-- 
2.33.1

