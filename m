Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040E6C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbiAZJtZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbiAZJtZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:25 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF88BC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:24 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id d10so37718326eje.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6KL4QdeBcaOYqs2iV6FLzsAo1dOdc3UB/1uqgmgFfjg=;
        b=BEGOnk/bOJDHmLYzDwutEGfmwJYaHoi1BAZDXReMN1btRy5SC9Kgq5VVGtKMbifcON
         RjyLcOyq6j58waXmCpOgIBbw00b3jJoVjPfZTubrfcTnRdyCr/ui4vQ099DNwSXZgA2W
         fX9Li9C7pMnkA5X6VaomSPDvuU79cmTJSwcp9yYPIt2nEMt6lpHQffklCJmxmSP40zKI
         V96UxU9nY8LA2oPOTQ19rZz+vr/eH2TmDEiML4+oK8/BXokh0dCoQpt6v4uV9W/+uDoz
         UQ4rLrQNqTIc16r0DOXfDtoCzFtsm2CXyXmMvyLXZAah5nlbTh0rcbcze9BnDyKmSX0B
         FYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6KL4QdeBcaOYqs2iV6FLzsAo1dOdc3UB/1uqgmgFfjg=;
        b=DhZH800CVe2L0ZHU0LjNxoMsGxgHaFNb92v5/VtZ24dUzdHN3ob7VBWVVFgqXBfBLJ
         IT3OrE4qHAUA2+JFHbO/IbhZWTLA6Wy5iqKb1FTPXKtb1zZ3ExyMLL5K1op9kr9kT7Oa
         rpeOBPOSVp26lB1Os1ct4exbMVW/SnaAWuQFVRxTf9fsbuRlsi/cgAdTSoXQB16FKtK3
         d/9QL2iZ+LkqgGHhVtJpG7bvjOnnOFK2DI5/V03WX1QYfeDwnmGLyOFqVzKiH1Ok5zVf
         cKVH2UfynEYAJd7R7OTU0IhzR/kcfdsRIbPcWpPRyRpj0g8VfZM9u4tAaonmrA1sUjdr
         Vo1Q==
X-Gm-Message-State: AOAM530RbihafeD4mIKjc4TLMaYp3gJBgQCR70SB1T41E3oLC6s2sJCL
        l2pR7VefUT9ZYcDQOaIGgbK18RNKqes=
X-Google-Smtp-Source: ABdhPJzDztgEfjb7zK/pRt+fLtd6nnoyfjBXiurLZveAvrjiwSfaDdZWF+oXKKgfVDPPJJfNszmZrg==
X-Received: by 2002:a17:906:5048:: with SMTP id e8mr19225810ejk.651.1643190563383;
        Wed, 26 Jan 2022 01:49:23 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 10/20] trace-cmd library: Decompress the options section, if it is compressed
Date:   Wed, 26 Jan 2022 11:48:56 +0200
Message-Id: <20220126094906.570451-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, options section can be compressed. Extended
the options handling decompression if needed .

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 46 ++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2e75e9ac..2da24a7c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3045,6 +3045,7 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
+	bool compress = false;
 	char *buf;
 	int cpus;
 	int ret;
@@ -3056,23 +3057,33 @@ static int handle_options(struct tracecmd_input *handle)
 			return -1;
 		if (id != TRACECMD_OPTION_DONE)
 			return -1;
+		if (flags & TRACECMD_SEC_FL_COMPRESS)
+			compress = true;
 	}
 
+	if (compress && in_uncompress_block(handle))
+		return -1;
+
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
@@ -3126,15 +3137,17 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3144,7 +3157,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_BUFFER_TEXT:
 			ret = handle_buffer_option(handle, option, buf, size);
 			if (ret < 0)
-				return ret;
+				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3203,6 +3216,8 @@ static int handle_options(struct tracecmd_input *handle)
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
 		case TRACECMD_OPTION_DONE:
+			if (compress)
+				in_uncompress_reset(handle);
 			ret = handle_option_done(handle, buf, size);
 			free(buf);
 			return ret;
@@ -3216,7 +3231,12 @@ static int handle_options(struct tracecmd_input *handle)
 
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
2.34.1

