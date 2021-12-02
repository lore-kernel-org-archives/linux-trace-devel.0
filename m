Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D4FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhLBM2n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhLBM2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:42 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C531C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:19 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z5so50278331edd.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ztvDFnMs8qoOx4qtDt7YdpO/uQKxoQoibBCS6/uCJFU=;
        b=d8Agr4jHEKf9LQaWES9AJvVkoP/rvmc/je7+stSA9t/muacz3XHeZWM9Nqar1Gxwgm
         5uviLyd7r+53XvrA/gC+e/695uMjRaHuIXH1ndIrW/1mdJx8ODQnHn4fkXheS+As10Ft
         7trxdcJ+bIvLLbNXVfouq/CaKbDBS+JqLLTkjDlGt7xR460++fbQ1/xHVSxAhW6X9kzW
         gQrIuxiezlk2aQKc2CTMo3SXyS+sSFgAk3AtlS/zpG09SU5Uk0W+aeckj6KljEAQYUmC
         vpQUEzmXl2riFMQFGhPeVp576PdZtaUNo/PhSDZoJjb1g8fbmP7TbDnz9/llMM5tnPtj
         B3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ztvDFnMs8qoOx4qtDt7YdpO/uQKxoQoibBCS6/uCJFU=;
        b=DKjt7HZhB3xEg/5hzlo0nhofeICf13z6w+Kaehe7vGPTCEZoVE5kj3uoiBAp9BAL9a
         dTvDR5fc9eDP9nIpPmP00MGJm9LzOjzesgndBfmgGro0MneP/g8hbG19fFhrlFice2x5
         4o2XppcL8+xubzAlxmyXeSS40CcZNjSKgdRVXJjhRk4Epj1FvMWfBemqgBEENOahQDGm
         mxbgY2qBipr9uovvphWu5vDj/svpK6nhKZGzSgR1G+98HY0xM2Ta4pLwd/XSMwWnue8j
         4R7jFb9sz2xgnGdBO5uLSDheRjeFn6Cr2FKVsL55yZWIIquXrjkRTysRFLsz9YAtvDEQ
         7hxw==
X-Gm-Message-State: AOAM5326nT6wswfCD9GpQiShtq6Xl+iD/ShgLnvaiR9BWjzqlDetWjHF
        RBwqs53HsMrN/2y7EoHCWWk1PW8JPTc+pw==
X-Google-Smtp-Source: ABdhPJwY3sCm+zX3Q1ESIhtiPW6G+nxxpYygua2faIb4iVUvZs+BKyCFB/yPj4TPPeqyy8GWU4LMfQ==
X-Received: by 2002:a05:6402:34cd:: with SMTP id w13mr17058284edc.112.1638447918223;
        Thu, 02 Dec 2021 04:25:18 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 10/20] trace-cmd library: Decompress the options section, if it is compressed
Date:   Thu,  2 Dec 2021 14:24:57 +0200
Message-Id: <20211202122507.43572-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index 8db43708..bd655d0c 100644
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

