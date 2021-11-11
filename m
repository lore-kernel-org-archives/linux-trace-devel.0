Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F00C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A260761284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbhKKPGS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbhKKPGR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:06:17 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E110C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:28 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m14so25638058edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6bW3IZBFCvSsUaHSwJ6OSA7Q0lEX3Nls6B+DugLLbvQ=;
        b=fjn3LYI8Nc/eC0yZavEH3+2VyZONIwJNbLzXhB1oJiHi4Ssk1SwIewTDYvSzNvTfsr
         3jKj/bSYBeKzsJmSck2YKvmEi/pFDUX1YBQo1cUNPgU55lgh1QwFs8KD+zyNK8Oh/SKB
         fP35hqfazdgaKjJXdQDhqkKOByeGMthk4RDQyQn/AHj5We1iJAEY8F8Uj9jdiOGkXvrO
         7MDvyOpJrFQTv7+BW5BPhgN6UHfrweNXc+0CTpYcXJ4ZoMTX367TI+2wYoRU0clImHut
         mq29/hB/RE+izOk7DHTPDTamPpmK2yjO3alLEIUeZO0ZDm+Q/cBlUFxOK4P5VbKoReEc
         8jOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6bW3IZBFCvSsUaHSwJ6OSA7Q0lEX3Nls6B+DugLLbvQ=;
        b=kMbD0nJoY62UyKnfT3Jt747W0ug8Lisi+wifFhqS58f3JYihH2dcqLCsmpnC71glrj
         L2fqfMO+giaBRpMYTDk3zqMz5V1mkFCRcbXOA5vzguaqabhLKNLX/eBAu1FD4mGSry12
         5Q/+C3BYpbcZ7Wf1PUK0/WF5CmUQnjXFbRb+cPR+Z6LCwvLh7hLj9GGVuZrRm9LgCGCj
         if+copQEPytMJ+qZwbUFv26oTRVJKHnqW2UR0XxecsX2GVuzVRVNCopLxXviRnM19let
         tZEiTg0UZ/8XRPFgl5bmcY3+qsYFiSSfiAvoCe8WJljUIdifKOhdri0fIx8iIMqQ9UuS
         JFEA==
X-Gm-Message-State: AOAM531ZwmMwOoCiAFK43o+ZSnHUVxEyi2tdlPQrCRlqYYm7xhIqsdyt
        yq0/sIUi90cZW1Crd3H46kY=
X-Google-Smtp-Source: ABdhPJxIqfQKkzz/zM83GfwHBVOC9VXnRawowR5XEkteptXuD6LPu4qIVUwXDde+nu2Wszi5BDtDWw==
X-Received: by 2002:a17:907:3e11:: with SMTP id hp17mr10146241ejc.243.1636643005978;
        Thu, 11 Nov 2021 07:03:25 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d13sm1656128edv.29.2021.11.11.07.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 03/10] trace-cmd library: New API for setting a custom trace directory to an output handler
Date:   Thu, 11 Nov 2021 17:03:14 +0200
Message-Id: <20211111150321.85979-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150321.85979-1-tz.stoyanov@gmail.com>
References: <20211111150321.85979-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API associates a custom tracing directory with an output file
handler. It is used when creating the trace file instead of the system
default tracing directory.
 tracecmd_output_set_trace_dir()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 27 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 49c8c138..eb173a39 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -272,6 +272,7 @@ struct tracecmd_msg_handle;
 struct tracecmd_output *tracecmd_output_allocate(int fd);
 int tracecmd_output_set_msg(struct tracecmd_output *handler,
 			    struct tracecmd_msg_handle *msg_handle);
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index d73c4f99..a5d7ed5f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -941,6 +941,33 @@ int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_trace_dir - Set a custom tracing dir, instead of system default
+ * @handle: output handler to a trace file.
+ * @tracing_dir: full path to a directory with tracing files
+ *
+ * This API associates an output file handler with a custom tracing directory, to be used when
+ * creating the trace file instead of the system default tracing directory.
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	free(handler->tracing_dir);
+	if (tracing_dir) {
+		handler->tracing_dir = strdup(tracing_dir);
+		if (!handler->tracing_dir)
+			return -1;
+	} else
+		handler->tracing_dir = NULL;
+
+	return 0;
+}
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-- 
2.33.1

