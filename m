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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CD1C4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D012861052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhG2FKv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbhG2FKv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D37C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:48 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n2so6357423eda.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CPlQbi1EQ/fkB8hu9TuApFd/+kavhl61vaYmxME6n1Q=;
        b=AWjlneMDy4aQ3wrAw9VmqVikkys+KpelFh8I4YQyQO3xDvtZs90hDrPqZvSZvxPWlQ
         ivH3RoYv7h1eBjrXSQUtad0Yx32SIdL39v7B+38mfkOoKfpJF+a7cCWxq9KJs91JA+U6
         k7pi+Nevj9IvD61+N6Mp0hsqzJ76p5BaO4i5F4zJlvGM2bO72sbraBbsIQ21AJACt4Hf
         WdHu1FU6lCM6nU6eCqgU0I9ozyGiXaVDXgx02WwejyQ+27QJUcYJds7nF8KXCicEJLh7
         CdRpCjA0FcN+HuRh+JQsik+BiKDDi8FwrY+quZev7ZUps7t2cEAzuWcyBVmisxvmLayn
         leUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CPlQbi1EQ/fkB8hu9TuApFd/+kavhl61vaYmxME6n1Q=;
        b=cF4FYI9axKv5l9nDYti/mU9QdJgUhiCB3IJVezRqQOAb84YhcRt01HbcJpyl24UpCg
         gU+gS9ct0bsdeoqzt9oSRDtSjw6xym3M5tV76o0kNfDvlwupGAEAU9YwHVS8vcOIqpi8
         SoT6YiHkJoqYfgLTJLGn10WNaSAu1bKME4qFPuSth5ZIACs+K7SQDUzWV+686sOG6rA5
         enGvR7sP4sMx4owbdNvOANH3WmyDdKZj2RdC/w3J2KbYDPZ+wk5dUmKeyF1oSnQIfUzy
         GVBjAM7j+GjZGvwS5PdUp3sqCyh94Oace2g6f0dLpeJXBb62rWkmkxIDLhObvjq/dcWN
         i9aw==
X-Gm-Message-State: AOAM530jBu5k5P2lzNcM8e4x+qDldX2exPHRC1lPhNMY4e2XGbT7nNjx
        /GSQW8psTqKjcRZUuf2WCN4=
X-Google-Smtp-Source: ABdhPJxfiHIL2AeHM4OcuogSJn4cZcB9DNbLFEVnI1Q5AxupSHaYofqdfIQCFYZEAKjbmjEfGR1j/w==
X-Received: by 2002:a05:6402:7da:: with SMTP id u26mr2410812edy.270.1627535447400;
        Wed, 28 Jul 2021 22:10:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 47/87] trace-cmd library: Read handle header and compression of the option section
Date:   Thu, 29 Jul 2021 08:09:19 +0300
Message-Id: <20210729050959.12263-48-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, options section has a section header and
possible compression of the data. Extend the options handling logic with
this new format.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 50 ++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d8c8b9b0..e7f97561 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2909,30 +2909,47 @@ static int handle_options(struct tracecmd_input *handle)
 	long long offset;
 	unsigned short option;
 	unsigned int size;
+	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
+	bool comperss = false;
 	char *buf;
 	int cpus;
 	int ret;
 
-	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
-
-	for (;;) {
-		if (read2(handle, &option))
+	if (handle->file_version < 7) {
+		handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
+	} else {
+		if (read_section_header(handle, &id, &flags, NULL, NULL))
 			return -1;
+		if (id != TRACECMD_OPTION_DONE)
+			return -1;
+		if (flags & TRACECMD_SEC_FL_COMPRESS)
+			comperss = true;
+	}
 
-		if (option == TRACECMD_OPTION_DONE)
+	if (comperss && in_uncompress_block(handle))
+		return -1;
+	for (;;) {
+		ret = read2(handle, &option);
+		if (ret)
+			goto out;
+		if (handle->file_version < 7 && option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
-		if (read4(handle, &size))
-			return -1;
+		ret = read4(handle, &size);
+		if (ret)
+			goto out;
 		buf = malloc(size);
-		if (!buf)
-			return -ENOMEM;
-		if (do_read_check(handle, buf, size))
-			return -1;
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = do_read_check(handle, buf, size);
+		if (ret)
+			goto out;
 
 		switch (option) {
 		case TRACECMD_OPTION_DATE:
@@ -2982,7 +2999,7 @@ static int handle_options(struct tracecmd_input *handle)
 							     buf + 8, 4);
 			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
 			if (ret < 0)
-				return ret;
+				goto out;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
@@ -2991,7 +3008,7 @@ static int handle_options(struct tracecmd_input *handle)
 					   handle->cpustats_size + size + 1);
 			if (!cpustats) {
 				ret = -ENOMEM;
-				return ret;
+				goto out;
 			}
 			memcpy(cpustats + handle->cpustats_size, buf, size);
 			handle->cpustats_size += size;
@@ -3078,9 +3095,12 @@ static int handle_options(struct tracecmd_input *handle)
 
 	}
 
-	handle->cpustats = cpustats;
+	ret = 0;
 
-	return 0;
+out:
+	if (comperss)
+		in_uncompress_reset(handle);
+	return ret;
 }
 
 static int read_options_type(struct tracecmd_input *handle)
-- 
2.31.1

