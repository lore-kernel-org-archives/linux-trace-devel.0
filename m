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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2670CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5D660C51
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhINNSQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNSQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:16 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1758C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:58 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u16so20167075wrn.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVAcQFUvhJRbVIAGcoLA1dmhOPwqFtnMRxVkdR4wv1w=;
        b=SxUT6xWreeUl3H8CarfgzNkRw3IV/yY9ZMsM/2PFXBOFWY9aGFSAmj6tbo0YnRC1FJ
         KctuJpFgcoYU0krm2hjyPexaAq+tTuN0665VkUpyNKyFTRag4F0GSjLCm8Yq/Zjq0uFp
         4BDH09lSb5bPnsj46j3TjTYe4vvGi1oUqdLw7n0dCV5DksP3f40uqQjjcnJ1zpdNWx8q
         mSRIB3jtSX1FWxMrFAOFoGzPEPPv2IC8vD17x5tT52RCz97KFiwp5+8RKTZsZG9GAITQ
         /rd/o59fJlSSk1oHhicetmSee6T1E7MUzmt8WbgPRI1IsUi8rQnulzK1o2Nr4UgcHezA
         kO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVAcQFUvhJRbVIAGcoLA1dmhOPwqFtnMRxVkdR4wv1w=;
        b=X0U49bu+Ivrxj57b7IK/g5790mu0/JQ2GUKyO2dGdksgeJ4nBqH2Mdy09ep/krp3ls
         j6zUUKyZzMt82te47VIl6U9zQHdcUGRUSWQudm9rwgUR2H79CX45NEfUEMhR0yslaoCk
         2ypf3AP9Buqib32YSBM/oVMDuaHrf/iqVNltzlO7PEOfaH331B8q4DK7qBNeXrvLQ6dX
         i0pHk0ywnFR3VrtmuJoU753IwfId//fDqSGMEpb1p54VR1l9uNgnQ1axapZV3h4ArEoj
         1eWtnHdATveOeuQm6T7Qo1ZnEwEe0NLchl/fJ1b9zEOaYlOqOt6ahyBhVqPS/jsJSK+C
         XGhQ==
X-Gm-Message-State: AOAM533qrj7x6hEQxRTPe3sHL4utLf9vJtvWCV1mC7kxTMYBiQpBIdor
        8KpVC1QYkYvA8RCagYvnMrqScgy09tY=
X-Google-Smtp-Source: ABdhPJy+VhXvMjqd6Et+rzVxHLBk6bNHi780QD6bcuU5xPFdB8/+MRiAB3EHyxbxRsX/XOXY2DkPOA==
X-Received: by 2002:a5d:49c6:: with SMTP id t6mr18064659wrs.201.1631625417312;
        Tue, 14 Sep 2021 06:16:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 10/20] trace-cmd library: Decompress the options section, if it is compressed
Date:   Tue, 14 Sep 2021 16:16:35 +0300
Message-Id: <20210914131645.3966308-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index 11ee6470..41b60649 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3038,6 +3038,7 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
+	bool compress = false;
 	char *buf;
 	int cpus;
 	int ret;
@@ -3049,23 +3050,32 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3115,7 +3125,7 @@ static int handle_options(struct tracecmd_input *handle)
 							     buf + 8, 4);
 			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
 			if (ret < 0)
-				return ret;
+				goto out;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
@@ -3124,7 +3134,7 @@ static int handle_options(struct tracecmd_input *handle)
 					   handle->cpustats_size + size + 1);
 			if (!cpustats) {
 				ret = -ENOMEM;
-				return ret;
+				goto out;
 			}
 			memcpy(cpustats + handle->cpustats_size, buf, size);
 			handle->cpustats_size += size;
@@ -3135,7 +3145,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_BUFFER_TEXT:
 			ret = handle_buffer_option(handle, option, buf, size);
 			if (ret < 0)
-				return ret;
+				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3193,6 +3203,8 @@ static int handle_options(struct tracecmd_input *handle)
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
 		case TRACECMD_OPTION_DONE:
+			if (compress)
+				in_uncompress_reset(handle);
 			ret = handle_option_done(handle, buf, size);
 			free(buf);
 			return ret;
@@ -3205,7 +3217,12 @@ static int handle_options(struct tracecmd_input *handle)
 
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

