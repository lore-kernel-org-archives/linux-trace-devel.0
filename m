Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F38CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49AE460296
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhKKPO6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhKKPO5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:57 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729A5C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:08 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c8so25072456ede.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H1BTFzuf5o5+0+Pd0gbo1N6C81aahbk2Yrr+z91o030=;
        b=bhMPPhYeaG9xkDaN+JI4FD3+yF9EscpPRwMK1s43avqL/8cmOzY5GjzXhNEO2KHvEV
         iYPMeK/JAxhgPN6K0bDxjRZMCfFnVildmrX1mPSkgrqJeBHdU1G7nV37QIuuS5ErJpdz
         mSlJT7YIzAbBXh+/vrOmP1eYjeqfCQsZRPvySh5Ks4e12EFOQBa6sNv84cYhYxCeRV5J
         C+8G06xFJGVJcQLQoKk64TmZ6ulnEmurX4KDGAEShuxu8K5J8fpRC9vDdhdy5U5xEz/M
         Y5Ym1RPNDsqaqiGDgBdNYBvKCbDMT1ktBTLQDIGYFP+SPhe5h87vLAA8b5VFEoLaU2zI
         1ubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H1BTFzuf5o5+0+Pd0gbo1N6C81aahbk2Yrr+z91o030=;
        b=5sNxA/uwJ/0LtYRbNJY4/rgT7FIkCXXWvJCaubEKrFFnQ7ISsdZ9WSe9QBt3UOfeuE
         bBZ5Gsxt2XWq5/ENjCyTGicGLWzHCVjb65t7Hb5xu/Rv3nJdeQxhecFtfk0gsOi5T7CX
         cbdWmI1ktjq/VnUxQMwfgM/Ma04dEW3zu14+ODioTOeOXaOHVy/I68qmVo0wLgmsgRUf
         0SNMFZ24IFQRTPKnHmLMkalzjPHN24eGFEborOjOEd/58uBTE0GytMh0lg42CIVBt7ua
         s/0ZR2sTiL1GH7Y3hozMICLfghjq4CTxhaCBLQUJOGFKsvhghe3NeuBxyax6OFBQYZ5N
         ucbQ==
X-Gm-Message-State: AOAM530ZZxebequ6O0VmBlZuY0dDnlMV7BVwuEfUIo7AHoOa6UQi67uZ
        +T2YWKse3WmM6MzG7leRMiAwyhW7XVGyXw==
X-Google-Smtp-Source: ABdhPJxPu1miA7Ya3yDl1S/6Oe3/D62hghgW0DuW8+9JvWOSGdHCVDLXXjEUVgyIpmG1atbbXO/QxQ==
X-Received: by 2002:a05:6402:14c3:: with SMTP id f3mr10580008edx.67.1636643527069;
        Thu, 11 Nov 2021 07:12:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 10/20] trace-cmd library: Decompress the options section, if it is compressed
Date:   Thu, 11 Nov 2021 17:11:43 +0200
Message-Id: <20211111151153.86855-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, options section can be compressed. Extended
the options handling decompression if needed .

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 45 ++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a3cc600d..b7ad946c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3025,6 +3025,7 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
+	bool compress = false;
 	char *buf;
 	int cpus;
 	int ret;
@@ -3036,23 +3037,32 @@ static int handle_options(struct tracecmd_input *handle)
 			return -1;
 		if (id != TRACECMD_OPTION_DONE)
 			return -1;
+		if (flags & TRACECMD_SEC_FL_COMPRESS)
+			compress = true;
 	}
 
+	if (compress && in_uncompress_block(handle))
+		return -1;
 	for (;;) {
-		if (read2(handle, &option))
-			return -1;
+		ret = read2(handle, &option);
+		if (ret)
+			goto out;
 
 		if (!HAS_SECTIONS(handle) && option == TRACECMD_OPTION_DONE)
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
@@ -3106,15 +3116,17 @@ static int handle_options(struct tracecmd_input *handle)
 							     buf + 8, 4);
 			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
 			if (ret < 0)
-				return ret;
+				goto out;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
 			cpustats = realloc(handle->cpustats,
 					   handle->cpustats_size + size + 1);
-			if (!cpustats)
-				return -ENOMEM;
+			if (!cpustats) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			memcpy(cpustats + handle->cpustats_size, buf, size);
 			handle->cpustats_size += size;
 			cpustats[handle->cpustats_size] = 0;
@@ -3124,7 +3136,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_BUFFER_TEXT:
 			ret = handle_buffer_option(handle, option, buf, size);
 			if (ret < 0)
-				return ret;
+				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3183,6 +3195,8 @@ static int handle_options(struct tracecmd_input *handle)
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
 		case TRACECMD_OPTION_DONE:
+			if (compress)
+				in_uncompress_reset(handle);
 			ret = handle_option_done(handle, buf, size);
 			free(buf);
 			return ret;
@@ -3195,7 +3209,12 @@ static int handle_options(struct tracecmd_input *handle)
 
 	}
 
-	return 0;
+	ret = 0;
+
+out:
+	if (compress)
+		in_uncompress_reset(handle);
+	return ret;
 }
 
 static int read_options_type(struct tracecmd_input *handle)
-- 
2.33.1

