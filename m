Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC8CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F190610D0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhKKPO1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhKKPO1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:27 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A0EC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:37 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f8so25640579edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JvqHtw88yrWLlnBBs4NeaE4fixoXd7d33jNCQmgnuf4=;
        b=ea0JVQnF2MZSi3/9M7vSyqU30cV9ZcXaE4pDct0I+Dl7mX4iKMIUIE06qkTbornRrr
         i8fxMCLSgxX99/u5YRzoVM+Lysp0g8g+08doY8fJYLVMyGUldE4KojEFIvNc4MfayD5P
         4YFqSqdKrlm3nzv4BjLiiLfTv5IshxK12qBUY37CdptEdBMuRjoDgl1eJyuirPlSb2ie
         jBKUfZbzr66GG6xIUiupEH296QH7OuWBDTFkKBmhYoQlgs96lxsZlgnXEXQpwNDjPVP4
         GtQ1O0EcFZDwu0honMqXsaM57Wb4ZcTxAvoopzRe1ettYnS7Pg8y7RHrhXsvQQEAqOSz
         bVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JvqHtw88yrWLlnBBs4NeaE4fixoXd7d33jNCQmgnuf4=;
        b=jEtN9qJ2sv0XVlPngRBUU5c/pwzvIfAiUtgfbTJ1NwmnD8aZGuNcEwatOQswD8pAYZ
         gzcpi0VTvwXsD/IMBm5jbiYWh6QZpi9O/wPX7NF52/zuTjfGbIEmaJ1JbhJtI9b5BSRQ
         TOAsSvG0cMs+TSTpYIs58E/PQm7araM/LgDD1HZ1gswRNBMvv8bdDfXwn0OEVdhwXBLL
         oCbur6rqob51LVN4HxlDQeVRsLjn1YtIP2TsW/aFiSy7g4eCksgN6UQ8Tf9aW2UQOxyN
         z30IzoosRYzwqCPS5TIScn4j+hk3b3V8i7zXvb4Y9booF3BH17rWX/1JlQQIJNJ/+L0Y
         EufQ==
X-Gm-Message-State: AOAM531PU7EHuiavPEhH5K2jjpm13/LUF8YaE6Oi6cXvpxAZofBRnNYh
        derMsuRvjvKcULkkpQEDVoU9AM+RRRD0aA==
X-Google-Smtp-Source: ABdhPJwHymjUYm/9NU6F8VM1UcjU+31Z0h27xSV3gObcUWoIn+sGSIQYI5KoJ4QJPx49ycCnxfKZiw==
X-Received: by 2002:a17:907:6da2:: with SMTP id sb34mr10416840ejc.509.1636643496557;
        Thu, 11 Nov 2021 07:11:36 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm967018edu.57.2021.11.11.07.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:36 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 22/25] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Thu, 11 Nov 2021 17:11:30 +0200
Message-Id: <20211111151133.86788-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151133.86788-1-tz.stoyanov@gmail.com>
References: <20211111151133.86788-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

CPU data initialization is different for trace files version 6 and 7.
When a new input handler to trace buffer is created, initialize the CPU
data according to the file version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 55 +++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5efa4859..f9978dde 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4466,34 +4466,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
 	new_handle->pid_maps = NULL;
+	if (!HAS_SECTIONS(handle)) {
+		/* Save where we currently are */
+		offset = lseek64(handle->fd, 0, SEEK_CUR);
 
-	/* Save where we currently are */
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to buffer %s offset %ld\n",
-				  buffer->name, buffer->offset);
-		goto error;
-	}
-
-	/*
-	 * read_options_type() is called right after the CPU count so update
-	 * file state accordingly.
-	 */
-	new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
-	ret = read_options_type(new_handle);
-	if (!ret)
-		ret = read_cpu_data(new_handle);
-	if (ret < 0) {
-		tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
-		goto error;
-	}
+		ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
+		if (ret == (off64_t)-1) {
+			tracecmd_warning("could not seek to buffer %s offset %ld\n",
+					  buffer->name, buffer->offset);
+			goto error;
+		}
+		/*
+		 * read_options_type() is called right after the CPU count so update
+		 * file state accordingly.
+		 */
+		new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+		ret = read_options_type(new_handle);
+		if (!ret)
+			ret = read_cpu_data(new_handle);
 
-	ret = lseek64(handle->fd, offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to back to offset %ld\n", offset);
-		goto error;
+		if (ret < 0) {
+			tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
+			goto error;
+		}
+		ret = lseek64(handle->fd, offset, SEEK_SET);
+		if (ret < 0) {
+			tracecmd_warning("could not seek to back to offset %ld\n", offset);
+			goto error;
+		}
+	} else {
+		if (init_buffer_cpu_data(new_handle, buffer) < 0)
+			goto error;
 	}
 
 	return new_handle;
-- 
2.33.1

