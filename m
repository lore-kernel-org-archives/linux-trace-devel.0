Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD688C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhLJLLn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbhLJLLm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:11:42 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CDEC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:08:07 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z5so29276469edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O6XgVhG0bKaGdM5E2HIYMTglE5wqe8Qq/1CXJ2bRsr4=;
        b=MfPFm3Q8WSUCJ7dD+NFcGHTtNOgctLCSJ3doGWGPJl4FHMeK0WrotnGQqoHMdOfpSp
         2ioR916Foum0QQruPb1b7cTOWMdeG/gl+ze4CO4VGsTuKd0JPI3Uf5Gc0TiQi3lRTjIh
         ceXdAP1TZEZQ0fhky9JCKMSlRXKOeoyhs7KucjalfFQgmXAm4snOXBRm5XZjZir3qcQC
         eJ3xgax5/ueiv5pGaZvFZoiqBxO9llbdSRoWAXY6MGdBd+F6U0rAs5gwINUL+dOSv2IS
         iRtiV73Hp1GTsy7h8+mbIdprHZx0+f5tlwlsOyPKFeDY4OKV9gu5mszQ472igxe4nM5/
         /tFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O6XgVhG0bKaGdM5E2HIYMTglE5wqe8Qq/1CXJ2bRsr4=;
        b=bi7XvO3K8/dgYu6VjcKOyT32p2KjfIpgZGeqM6NavXQJSgXP5XOE0jA8bMlmw8BA9e
         a57gJcFtwnJJYCcnnOPJhu1a9ntEMAlOXVzQuRTg6+W/gYnfTMbsKVOB/K38DX68HK5d
         r+kzSkQR/JDqKHhcjAsdx537jYUcuPYjowWCYNhFQH26eHTgZ2ceXCF303wCay9mFOa4
         e7UGUNM/yzTim/yovpOSQ/0G85KoBWIzMUN8Abio87JBMyzHb/GcDlBfXYd5r6QMiPfl
         l1JhhuXoJsxpgznQmT7NoBboNT4aEp2u/zF0Mb3FknrzYtwjhlihcIkMK7H2QvQQOH0U
         ek2g==
X-Gm-Message-State: AOAM531YOW7BK66e1LRelLMmQRwwXAgHldBVm0IsXOLfY2lqeKmhJyhd
        WLK/kQam+iWrr3HTMhNSS25Q9pg8Sds=
X-Google-Smtp-Source: ABdhPJyr1qsjGxG4/mJ6hllwZ9t6lO/5rgRjxpmjl4ImLCLfkxgZrF8uXOLMTdsCNJYddKmiMDznYA==
X-Received: by 2002:a05:6402:2152:: with SMTP id bq18mr37689944edb.105.1639134486302;
        Fri, 10 Dec 2021 03:08:06 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j14sm1287172edw.96.2021.12.10.03.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:08:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/2] trace-cmd library: Use the real trace buffer page size
Date:   Fri, 10 Dec 2021 13:08:02 +0200
Message-Id: <20211210110803.99188-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110803.99188-1-tz.stoyanov@gmail.com>
References: <20211210110803.99188-1-tz.stoyanov@gmail.com>
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
index 544ee4fe..8b0e6823 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1274,6 +1274,41 @@ static int write_compression_header(struct tracecmd_output *handle)
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
  * tracecmd_output_create_fd - allocate new output handle to a trace file
  * @fd: File descriptor for the handle to write to.
@@ -1298,7 +1333,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = getpagesize();
+	handle->page_size = get_trace_page_size(handle);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
-- 
2.33.1

