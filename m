Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC39C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637B360F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbhJHEPY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhJHEPX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:23 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212AEC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r18so31235220edv.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=etcGgXiYo5reRZk9tFjJLvh4qcHFH/gCF83vi60PtVw=;
        b=RGwqI9ocsrp3IzCylz5UMREOCrDvF8LqxUxx4x+LnxHeEIIkbD2JXhZfAnx63W5GCQ
         1S2G0Gk+nADxNY255wPwcad7JMeRAeSiY4UYyN44LjYsP2dnRPYGmH+y4BfymthfLYJC
         HkYitEOb4r7NnRbDlzj0PyIFCbtal4cPotRU1WC0xi7IMZi3ZI1eIKfbdb652iXOuk7l
         CFt9qTrDMhRHmT73X6ToZ3F2UFApsPnpUrFWSQjVA0uKho8iQHAaKeYdtFI9jIWMZJxw
         ZFpYN/a2Rpnb92QorQcBo/NmKLa1c2CIhMwEBrVrKaalyL1rDe981E6IwVGzTIeQsmu8
         ZcOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=etcGgXiYo5reRZk9tFjJLvh4qcHFH/gCF83vi60PtVw=;
        b=A7CUj5qIrkbx/ooyWbs/CEBosire/7ImLSobMk/2GlaVPwUcDfIm0rR0PYrBLY2nxj
         HWlM17zSjEejT8peEERRGTeW1alI7MTkRRjAuKZqrZFF0gn5pDvDWV9bCvulXfP1Onl4
         uvM+GklQvlpI5f2OWXDeOwBT0I2rTNPaVkFAG+OxyK0h56SOo+fUey3/sN6eJl1DcjZV
         gwvxAXaiSdwY57iPTvoXsRrGqQA5YMLNqQJFZ3PaZ3o0v72QiGJx+W1FiiJ5BaD8uPgN
         6bBNn8jk4eDHFQA8+QqabKVjVYSPMI+bb15WMzvJaVhTYkhPVegnL3FdwQwYzsR19p3x
         ynbA==
X-Gm-Message-State: AOAM532r4Uw6MEEkAe0RjcOIAmmOx8AQEy7CLmeZhHo6hWFWCSuduw9Y
        lnpDjHKBeBIaDqeGb2eecXYoDhnBQ3MbtQ==
X-Google-Smtp-Source: ABdhPJzD56QTvgsFBl6aopU8xyMyn8qrUE8rN5Dbl7F6agcqS0Aw3x+RkYq7LPYp2+depkWrfSm6pA==
X-Received: by 2002:a05:6402:143b:: with SMTP id c27mr12201044edx.224.1633666407713;
        Thu, 07 Oct 2021 21:13:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/10] trace-cmd library: New API for setting a custom kallsyms to an output handler
Date:   Fri,  8 Oct 2021 07:13:15 +0300
Message-Id: <20211008041321.973755-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
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
index ad9d5265..8ef448eb 100644
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
2.31.1

