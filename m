Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FE3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC47961284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhKKPGR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbhKKPGP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:06:15 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3E8C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:26 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x15so25408399edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GE/ZhNuVOFMt61b2oYmfytP7w1fdYjceKUJeGml5guE=;
        b=jScqC7YR/nPPz8jNDyKmgVyzItcCpbvBCgwP9TNolYzn+IpQm3crLpIkpvetlWlb5c
         ruQ2nncwFnd5svXiVnqt7ZVM36AFsLPzogHIGMByG2u4z/CzocN9Ov7ydS62/pVeqDpB
         FhiZemHeui5PMAGP/vvCe4sCJ4LfeE2P+I6GuXN0VvTEgNvVinHyi3G5YKgt60nw5THQ
         rB2OXmfKhhHsiBAxf2JhW6udpjJRJVp9fH0XUbouGZ8MWQrB2/yns/kSjBN6hU47dqXQ
         Fq1Dl84duaOy4d3VHk8GaZO8Y7BcpXeLFTIokuG9yRsiHhFlGJFl4fyVrJtW+34KxOPZ
         NDyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GE/ZhNuVOFMt61b2oYmfytP7w1fdYjceKUJeGml5guE=;
        b=EcgnwX+XpWVILNLh9VMFOMJm0hmqWd4RDRq2AVPnIFtbQ1ySRpjRA/eZHRAt4UYptn
         lmoaUYv4lDPpwNfMaZxcOVK+xN2hry7kcEf3sIglZ2XsPg4gMv+ciX0MVgIQD7asQSrp
         nTGu2YleYz1vQ3jAAyp2o8uGOb1hfTegTta/B8esHiAPWG5bUhlHsJH2Oh9o5d9hmdBQ
         50jRFOlYix0F4gqk/sNwWKDYg47y8QvmBF1G0CMAy1I0Em1jTCx949yG0gjvg8dPicLB
         FU9tBBoV9VfEhUiu/C1m0++fRH2UMEcbi/HBEqiV5PUCklI9D5DZLmr279KXOM3Fxbzn
         cplA==
X-Gm-Message-State: AOAM531xEr8/AmiFQnjiMbbametHLZrYIU9NcFRIi/N/45/PO48FBwFs
        E8ndAO0gs9CEW5VP5YIhgOE=
X-Google-Smtp-Source: ABdhPJwmWIoH3sAS/hkOtfxl371u0a4yOEoBbmsslHW1GUtb2JvoPcoInu81EPzDMWgqH2ZHQKTfvQ==
X-Received: by 2002:a17:907:7785:: with SMTP id ky5mr9842586ejc.247.1636643004131;
        Thu, 11 Nov 2021 07:03:24 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d13sm1656128edv.29.2021.11.11.07.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 01/10] trace-cmd library: New API for allocating an output handler
Date:   Thu, 11 Nov 2021 17:03:12 +0200
Message-Id: <20211111150321.85979-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150321.85979-1-tz.stoyanov@gmail.com>
References: <20211111150321.85979-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API only allocates a handler and performs minimal initialization.
No data is written in the file.
  tracecmd_output_allocate()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  4 ++-
 lib/trace-cmd/trace-output.c                  | 36 +++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index f40babef..bed96657 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -102,7 +102,8 @@ static inline int tracecmd_host_bigendian(void)
 /* --- Opening and Reading the trace.dat file --- */
 
 enum tracecmd_file_states {
-	TRACECMD_FILE_INIT = 1,
+	TRACECMD_FILE_ALLOCATED = 0,
+	TRACECMD_FILE_INIT,
 	TRACECMD_FILE_HEADERS,
 	TRACECMD_FILE_FTRACE_EVENTS,
 	TRACECMD_FILE_ALL_EVENTS,
@@ -268,6 +269,7 @@ struct tracecmd_event_list {
 struct tracecmd_option;
 struct tracecmd_msg_handle;
 
+struct tracecmd_output *tracecmd_output_allocate(int fd);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index fe1d1aaa..3878b963 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -59,6 +59,7 @@ struct tracecmd_output {
 	unsigned long		file_state;
 	unsigned long		file_version;
 	size_t			options_start;
+	bool			big_endian;
 
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
@@ -883,6 +884,41 @@ out_free:
 	return ret;
 }
 
+/**
+ * tracecmd_output_allocate - allocate new output handler to a trace file
+ * @handle: file descriptor to an empty file, it can be -1 if the handler
+ *	    will not write to a file
+ *
+ * This API only allocates a handler and performs minimal initialization.
+ * No data is written in the file.
+ *
+ * Returns pointer to a newly allocated file descriptor, that can be used
+ * with other library APIs. In case of an error, NULL is returned. The returned
+ * handler must be freed with tracecmd_output_close() or tracecmd_output_free()
+ */
+struct tracecmd_output *tracecmd_output_allocate(int fd)
+{
+	struct tracecmd_output *handle;
+
+	handle = calloc(1, sizeof(*handle));
+	if (!handle)
+		return NULL;
+
+	handle->fd = fd;
+
+	handle->file_version = FILE_VERSION;
+
+	handle->page_size = getpagesize();
+	handle->big_endian = tracecmd_host_bigendian();
+
+	list_head_init(&handle->options);
+
+	handle->file_state = TRACECMD_FILE_ALLOCATED;
+
+	return handle;
+}
+
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-- 
2.33.1

