Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED8FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF7660FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbhIMMnb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbhIMMnb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:31 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544DEC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so6503099wms.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e697NvpF9tuRuBTrXAkHfX8ZI1uKeZM8RJGq29d0nbI=;
        b=YPdqO5ffR7RKOM2P9+5Zr/w5iwszy9+84EmYZwdQqfemD51VjpCRHBHEdGF1gy3E/V
         vhgwZ3I30PBtwgpUXz3OBikPgs5uIrcvRNwwzunrJEMDwZel31C6TF1yUWgN3fjw+EKg
         Yk/jWl+NdrhKURuklUfp8cjqvF1FgceRShHaMFEIrJgbKEu9IBREZZ/to+sqTD3hEku6
         Z12C5e0B+alqBMpcxzouGWIiyOLpVjL6mg6iJKvR7sdg553Z9Qh4TwwO4DZBsDJgpYJ1
         Qrr+qYXFg/tXkA/sqCMKYCgW0I1dSHVT4b+Lu7qMwtLg1eYHh8NwoT0/IQ3l9bFcgken
         O+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e697NvpF9tuRuBTrXAkHfX8ZI1uKeZM8RJGq29d0nbI=;
        b=wM64OploBEyI1elYFoKz+P+5mkZUrY0oQTvZwjRB1GKTc/pNAofhstL3Z8tUDtzbQd
         Ah6XHEDDBdWIj8SQgAksT2Uy4V10SycZTPyMx5K9ubErMlJoS4Yx+VzetiiHq8sBZiMV
         E2Vb+rDPE/TI1+1hdn2vtjk5FLwspQKWzk/HW/SAPJjYI5f9fHWASu6FsoVsLpAEC4sZ
         aabrAPw/SVoYd5UxrrOkqpsNORqPPeMs5OPa5oMsncByw68NTPY1KDImVSHqt7Va/jIN
         IJnMFdnRrYF47e65JzO51yFb0JoGdWJXi9TimUw5O6+23P/rUnGrcP2GnNoYnUXNBguC
         k3xg==
X-Gm-Message-State: AOAM533nPOuHgCvb7etF5+B4FgfU0ACf+8JdSQ7+Tm90lAjgSLQqlKWx
        s4JCtRH6G4IztSdKEJgvesVB1XZqfX8=
X-Google-Smtp-Source: ABdhPJwxSI/zgwBC9Qpj5s9HSUtDpXzINDfCyb8PTZX66iBIJXKouoTvxo4Jit2wQg/29PTRiE+1tQ==
X-Received: by 2002:a05:600c:4e86:: with SMTP id f6mr3993938wmq.52.1631536933973;
        Mon, 13 Sep 2021 05:42:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/20] trace-cmd library: Decompress the options section, if it is compressed
Date:   Mon, 13 Sep 2021 15:41:53 +0300
Message-Id: <20210913124203.3677760-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, options section can be compressed. Extended
the options handling decompression if needed .

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 41 ++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2ea8f5a5..320561d0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3036,6 +3036,7 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
+	bool compress = false;
 	char *buf;
 	int cpus;
 	int ret;
@@ -3047,23 +3048,32 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3113,7 +3123,7 @@ static int handle_options(struct tracecmd_input *handle)
 							     buf + 8, 4);
 			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
 			if (ret < 0)
-				return ret;
+				goto out;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
@@ -3122,7 +3132,7 @@ static int handle_options(struct tracecmd_input *handle)
 					   handle->cpustats_size + size + 1);
 			if (!cpustats) {
 				ret = -ENOMEM;
-				return ret;
+				goto out;
 			}
 			memcpy(cpustats + handle->cpustats_size, buf, size);
 			handle->cpustats_size += size;
@@ -3133,7 +3143,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_BUFFER_TEXT:
 			ret = handle_buffer_option(handle, option, buf, size);
 			if (ret < 0)
-				return ret;
+				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3191,6 +3201,8 @@ static int handle_options(struct tracecmd_input *handle)
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
 		case TRACECMD_OPTION_DONE:
+			if (compress)
+				in_uncompress_reset(handle);
 			ret = handle_option_done(handle, buf, size);
 			free(buf);
 			return ret;
@@ -3203,7 +3215,12 @@ static int handle_options(struct tracecmd_input *handle)
 
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
2.31.1

