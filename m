Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF55BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 04:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3F8B60F70
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 04:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhKLEQY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 23:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhKLEQX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 23:16:23 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C11C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 20:13:33 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z10so6039755edc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 20:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkyUxO3xBTYZqMjAwSmwf4uTMU/rf7W3UZxvayPIBvM=;
        b=cd7GmkBjTFZWLqW5xQ0UY7PvEYmidgCWgXZSBVGGgwM1CHmVCQyQndbWIcCbeQhcA8
         JGtsMoiT2USdZp8fVWs9dNocBsSDu3WXlFiuEzY3rbrIzx0UlqaZu/u03AlYhywJZ10i
         cXr6ZwG6sp3SPNy48h4jRwwnBQpFEH2WUUMz4nbIiTzYgrXNEyibT7c2pUvO9LGKlpBl
         bs5vDKQlp6cN6M9ZUP/Z8zkJCSofiZ5UNa5u3ydVQdqolIyilduv7c4i6U46ns3l+6aI
         Gdccl3gs0AuuP4gCpBaDH9UEBzXMVaq8pNiv/I6hMd3n74gGqDIfvU/RzCEHSh6wolwU
         bUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkyUxO3xBTYZqMjAwSmwf4uTMU/rf7W3UZxvayPIBvM=;
        b=XUvibTWWsQt7zl7cPCN4FynarMSLVqgDgxCgJH6bxbzdVcwCLYxsaknKlFlohANvQL
         64oNHV+SbHoj7N3mH09wCWNxmtC08npPpfDtZFCmFhdIsyL9jhlJoNj1NJ7EB1Mg/aq0
         7ZCtDmFdzRzumr52oUerFMpoHhGpqILBnYcnpwLMCOFv583wh0Eyyh/w5Q/hYmyLfPAm
         uZpQtFLRB+tHaLA3WUyQ3TCY1ovKZsJWsHGeNUdrhbS3ikt+vwg5EujAUZnFyatnjciz
         LiOzy4CI0KvFlWrZ0aaPchP+x5KpoVcKjG1u+2RRQYqUKAuddeayWZ1T7IGGroWeKRUO
         8keA==
X-Gm-Message-State: AOAM531A9aJ88/TyoIR2gGGFitHkDOOTXQe+gcNJ6TMhCjX/NqU1zvE3
        skUHdCLHuJ0Ud85b8du+ay/QHFR3yrRhmw==
X-Google-Smtp-Source: ABdhPJw4SxWObF210zf/J8nUnXelHN6EQditXDXOKf1/zYqRKenUr8VYUoqImPYMeTIUuf9GlXMCMg==
X-Received: by 2002:a17:906:ce2a:: with SMTP id sd10mr16094160ejb.154.1636690411722;
        Thu, 11 Nov 2021 20:13:31 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb3sm2212121ejc.81.2021.11.11.20.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 20:13:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cmd library: Use the real trace buffer page size
Date:   Fri, 12 Nov 2021 06:13:28 +0200
Message-Id: <20211112041329.23629-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211112041329.23629-1-tz.stoyanov@gmail.com>
References: <20211112041329.23629-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When new output handler is created, it assumes that the trace buffer page
size is equal to the system memory page size. This assumption is valid
for the current ftrace implementation, but it may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

This commit depends on:
 [PATCH] libtraceevent: A new API for trace page size
 https://lore.kernel.org/linux-trace-devel/20211001062338.2389024-1-tz.stoyanov@gmail.com/

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 37 +++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a029678b..f8de8f52 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1189,6 +1189,41 @@ static int write_compression_header(struct tracecmd_output *handle)
 	return 0;
 }
 
+static int get_trace_page_size(struct tracecmd_output *handle)
+{
+	struct tracefs_instance *instance;
+	struct tep_handle *tep = NULL;
+	int psize, size;
+	char *buff = NULL;
+
+	/* In case of an error, return user space page size */
+	psize = getpagesize();
+
+	instance = tracefs_instance_alloc(find_tracing_dir(handle), NULL);
+	if (!instance)
+		goto out;
+
+	buff = tracefs_instance_file_read(instance, "events/header_page", &size);
+	if (!buff)
+		goto out;
+
+	tep = tep_alloc();
+	if (!tep)
+		goto out;
+
+	if (tep_parse_header_page(tep, buff, size, sizeof(long long)))
+		goto out;
+
+	psize = tep_get_sub_buffer_size(tep);
+
+out:
+	tracefs_instance_free(instance);
+	tep_free(tep);
+	free(buff);
+
+	return psize;
+}
+
 /**
  * tracecmd_output_allocate - allocate new output handler to a trace file
  * @handle: file descriptor to an empty file, it can be -1 if the handler
@@ -1213,7 +1248,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = getpagesize();
+	handle->page_size = get_trace_page_size(handle);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
-- 
2.33.1

