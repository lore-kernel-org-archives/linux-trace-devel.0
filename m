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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC76C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2613861052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhG2FKn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266EDC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:39 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id go31so8446282ejc.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rkIWM45qXCxkk1hczFTdWShdbvftacGLnbBLuxGPqLc=;
        b=OHqN+b5H5hboLDP7eHpevQZpYJx1AmKyNM9heoXMM8dLa68nzh+y54Y8LyhRZkRCMO
         Pwf3LxSQ9pp+Okyx2KwLdzRmsTOg92LvBdJIQN9Wd/rF5wF7eONwzzlKzgg1eiBs8NVU
         /G6OKkSd1PKg4eH0kqtd3rY7GfnxbnbBYTCx8iSYdkQL2dxdhoMJGh8W7YW4PI91zZJI
         h2X2j+ZVdbXbNa2ulp8/NMuB88L0rcQqbAL3u0RD2U5v56gtVT/H9RR8Jd1lAGoLIpFx
         73Rjg9SZkEF1AzsUs230xmtL2FMxRCAo9hm2NtmQYFrNx9dfp7oFAo3CiVFA8GrOfLX1
         Yr9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rkIWM45qXCxkk1hczFTdWShdbvftacGLnbBLuxGPqLc=;
        b=N9mXGdRhX1szMEwHTh+8HQFl+QLVG6h6kidIHdjWNKHNJHwSS4dlldoTwFbA8W4sTu
         5sUKcoHeqY6+mo4efwXZD0O9NNDuJOT3ebdxv3117n6JjRvxmJk30c8TxM0a01lQCcUY
         MqM0Go5m7BMq6XMdr5Nl6HC6+HQ+NSwf0k/JSKKZS5huqopG5xiSdSCbc0nJvXZST5Ec
         SjQBVr54P/O9Sd/uS8p//uO5+hQMAksQrDaZLVaXVHUuVrIWVuiOyxPd+q0bvQRV3/3Y
         mW/mLgeGi7iCtoyu/npoBszu8wOH/VfYBk65JrfU75Zs5hwPWn63u/xLPF6PSY13tF0e
         wFvw==
X-Gm-Message-State: AOAM533xPVKUxRWdju0UH4WKQHlQphql3yturijJYQds8luc+4cH/Y2f
        ir0FJ9vwifop5MzIIkdKx90=
X-Google-Smtp-Source: ABdhPJweXy2wwTuoLioQa/hch2FDxfB6rIsEao/Ah4iMTg73iJEiPZMiSMGJu2ftZGYcBUppopREzQ==
X-Received: by 2002:a17:906:7716:: with SMTP id q22mr2897185ejm.457.1627535437837;
        Wed, 28 Jul 2021 22:10:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 37/87] trace-cmd library: Set log size to the input tep handler when it is read from the file
Date:   Thu, 29 Jul 2021 08:09:09 +0300
Message-Id: <20210729050959.12263-38-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Setting the long size to the input tep handler in tracecmd_read_headers()
API may be too late, as this tep handler is used to read and parse data
from the file before that. The most suitable place for that is
tracecmd_alloc_fd() API, right after reading the long size from the
file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index bf56c92a..0ced15a8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -976,8 +976,6 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 	if (ret < 0)
 		return -1;
 
-	tep_set_long_size(handle->pevent, handle->long_size);
-
 	if (state <= handle->file_state)
 		return 0;
 
@@ -3473,6 +3471,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	do_read_check(handle, buf, 1);
 	handle->long_size = buf[0];
+	tep_set_long_size(handle->pevent, handle->long_size);
 
 	read4(handle, &page_size);
 	handle->page_size = page_size;
-- 
2.31.1

