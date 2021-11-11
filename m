Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AA9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C45E60F58
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhKKPPD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhKKPPD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300DFC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:14 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id m14so25744044edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5ZdgtACZNoxhLbpI1BAp/Q/VnJlL8lle6m0luqtHneY=;
        b=FeNb5RMisx8ZBM0iv3+4aEmSip/gjPLcPUboMr6YgxLTh1d9F+3sRz1CgHmN0iry3Z
         ZZDbkYQrboX55f6IPFU0iOQkDv7Z/4cdiTU9MP2wCTmpAIaZyAhyGbAQuxUZYUA5Xbyw
         B5ARWp3oEFECAhNChWqsUoh9m5KHnv+gGt60JVo1+ZUqq4tFCdZzXiC/IRg8kNk/x8eI
         MygyRCYDq7i2Zx/v/YnfZOYItkILMamONXx7u3EOZMbKliB9/Uc2N/qh8aITUv9uDNhG
         oGCYkqDGqTcvQ0blyVhU2+2aCdFwxdbJB6tWYwO2NKU62IunGxGNGPCoeEB4omRCPavU
         QT9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ZdgtACZNoxhLbpI1BAp/Q/VnJlL8lle6m0luqtHneY=;
        b=kuowAMNzHMEwqVJvVHSPZZETsCkysBcnavQ5C7/6gqK+uFhOZf5QtGM4NMvr4PsTe7
         glwKVKHZvw2IBSxP1udrjmKCYR6i+Q5xz3LlZJW/9CDgHtLjAt0rmlaO0tdok+8Ac1gp
         uSrMbKbSmIjZrAs86Sa/LVXC/K/FsOw/EyG2emyDgTveZ9KUFXn4t4eCWyp9BL+jHXc4
         lkAFrOLLhaIDGQ5o3BkKiAKUgiYYME/6zDVdkowz/knkDs19+Z7Zla9DBY5RqWrAxSAF
         4Yo0sr5jKsu8qiKAlHuE8uJxnQ9Bz4w/vX5MtECJ8zv57IUka4r2wigg5dB1SKeXbpOc
         Hguw==
X-Gm-Message-State: AOAM532QGlezBaU9sO1hq0HVXcl+dW6DLdb4Brn4QaHkFzX2WdW/HAgY
        LYzaeFQ68HptY7c1FxpdBeGprcrb3M9B0Q==
X-Google-Smtp-Source: ABdhPJyKrQCjDXHpuauBJEmBQTX/w2jAiph3gTTsS3Ymr+h2HIER1kE8UbdyjlyZypOGA7/md0wUOQ==
X-Received: by 2002:a05:6402:5216:: with SMTP id s22mr10708918edd.291.1636643532813;
        Thu, 11 Nov 2021 07:12:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 16/20] trace-cmd library: Decompress file sections on reading
Date:   Thu, 11 Nov 2021 17:11:49 +0200
Message-Id: <20211111151153.86855-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading sections from trace file v7 - check section flags to find
out if the section is compressed and decompress  it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 43094b11..7bcf4cf4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -481,12 +481,15 @@ static struct file_section *section_open(struct tracecmd_input *handle, int id)
 
 	if (lseek64(handle->fd, sec->data_offset, SEEK_SET) == (off64_t)-1)
 		return NULL;
+	if ((sec->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return NULL;
 	return sec;
 }
 
 static void section_close(struct tracecmd_input *handle, struct file_section *sec)
 {
-	/* To Do */
+	if (sec->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
 }
 
 static int section_add_or_update(struct tracecmd_input *handle, int id, int flags,
@@ -1109,6 +1112,8 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		return -1;
 
 	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return -1;
 
 	switch (section->id) {
 	case TRACECMD_OPTION_HEADER_INFO:
@@ -1134,6 +1139,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		break;
 	}
 
+	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+
 	return ret;
 }
 
-- 
2.33.1

