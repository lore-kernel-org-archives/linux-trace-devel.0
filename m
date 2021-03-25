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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E3EC433E5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7760761A12
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhCYGli (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhCYGlL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:11 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599BBC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:11 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 12so511683wmf.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqCDMS6/zKiTKr+JmBzugazZXnt0+q8DIKy+t/24CuM=;
        b=qgQgasx3+yLGnWdgsbHSU8V/acy9bP5cJ3m/0xMfeprvU/3XNAzUT3jfq4T5KY9GnK
         RxiUbq47Bv372CagFxDKbQoZ7Du1p5OE2GwGIzCRFlSLVLFOuLZT6XiPxvqKNyWWb/PT
         ddLh0o7mHzKEph/dsr9mNZDeWJoD3TBEnthvj5aZix6A5iOr847BkR8s0hoU2JUi8+q9
         MT9jt00BoO+O8rZk/3FUNYn5WxmUAgAAlD/h+HcP2gx9YzFaiFuoOEyOp/bR6NdYEuej
         9n3ui0be5gI26XFa+7kEleyaEc0b0DvFZ42PCPu4hGdWYGNIrjFki91XddMDMWoXG1RB
         gLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqCDMS6/zKiTKr+JmBzugazZXnt0+q8DIKy+t/24CuM=;
        b=jhHzyWHi1RIEbh+SWSFwJ/9YFCiKxU0XIy6eUFvmPcdL1gHW7Ep0DQRhsdgb3BbSmm
         dxi9DyOv0lkM30P0joL7DxQCOvYUfF/Dbdnx4u+o6Umt2DmCTDDW5PPP87ach5PBtp7q
         ey3oaTHfG77mhbLhCS9kcSxcqsGuS0/zNCjqFvLBf4/dpNx5Iow73d5yykcwS79Z9EYW
         1Y4Y7WHe1Y/Ln46RMMPUNMrrojb8vJwsxQT2Z5WUF7NIUWaQNkABRx7O8ur1sRhroE1O
         lZWwX6XEncS3SKVdCm9+L1egjQZZlvI8yxR/wvmqBoJFMxy1Qn2MWDGbWU/5CgJ02Mf1
         9tHQ==
X-Gm-Message-State: AOAM531e941EutXdS9yVOkHSYqtsMQLn0MD+M/Yydl+/hbWz+HtSFGPl
        BjLpv8zNpkJ/+On3Y4q2X6A=
X-Google-Smtp-Source: ABdhPJxDhl9Z5r27d54lZv3O1xIaHySSp1gGcILjyzsFpGEtC4Jbgx7jnUHyBd2isUClmHXW3XdulQ==
X-Received: by 2002:a05:600c:252:: with SMTP id 18mr6058097wmj.67.1616654470150;
        Wed, 24 Mar 2021 23:41:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 13/23] trace-cmd: Perform all timestamp corrections in a single function
Date:   Thu, 25 Mar 2021 08:40:45 +0200
Message-Id: <20210325064055.539554-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading event timestamps from a trace file, there could be various
corrections depending on the metadata information from the file. Move
all logic that performs timestamp calculations in a single function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index be8a7919..e1842cce 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1276,6 +1276,17 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 					 &host->ts_samples[mid+1]);
 }
 
+static unsigned long long timestamp_calc(unsigned long long ts,
+					 struct tracecmd_input *handle)
+{
+	ts = timestamp_correct(ts, handle);
+
+	if (handle->ts2secs)
+		ts *= handle->ts2secs;
+
+	return ts;
+}
+
 /*
  * Page is mapped, now read in the page header info.
  */
@@ -1297,10 +1308,8 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(kbuffer_timestamp(kbuf),
+							 handle);
 
 	return 0;
 }
@@ -1930,10 +1939,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(ts, handle);
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.30.2

