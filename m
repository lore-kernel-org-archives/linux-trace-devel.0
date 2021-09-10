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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617F7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DCE5611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbhIJNt1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbhIJNt1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:27 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1821CC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:16 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id jg16so4415991ejc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NVypbYtgUHgny7wAXLnJyOQJ1yqxvkL1dP4in6bDrys=;
        b=f+vPdczyVEu5lMS/SmJpHxj4rJ4L/rBvE1F2gHVSBQ4h+EcSoTLeRU7jYxPKdTW7t/
         AiRid3Sefp6ynFqlplpPQvDYBITSnr6Wwz7zpzmK9NIgYBZqTPWkBcdXhMso87uIvlS6
         rLy0MlBrn9kgyYn/e2Cp3RAd//mnkND0/DORJ6MI1AU9aaT/QyvySZ9U21gVHbl5FZ2l
         MhQy1dl/S/rLylPV6yzUETQbsybytnLrgQ6TnIfmUx5AyuvJMw4Uh2d08tp0TZnBr6i4
         G9nC8gafwc4Fl3Pb9IV/Om3912utN7LQdlg9Lw92oAuEmQ9qwwZHerU57sS6LZL9BuTL
         ovbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NVypbYtgUHgny7wAXLnJyOQJ1yqxvkL1dP4in6bDrys=;
        b=Y6HreRFwDLR3nJXAXwbqU8wibxBrWheK7TGWQNBiAEE3bvEhyUXhgFTw9s2Mx6Cvqc
         Y+iDV6u95wmSAZfGCtSXZtL3tpB6pSYcO5byxohlp2fWtfVfBkd+KOdkURfacK+INUPC
         zH3BngyH0GOFvVmvLxf8Zy8gKqM2tT7nOcLQ+S6bo342hv/0YfI1vbpPW3HNVmfh9K9u
         W9HYGT1AgGwk+j5OXgsnwCHdpwanlnn08Pd7xVkB0iFL4dL1JLih5fvlZwul/BwQWAIp
         sGAFCYeiDk6eokzEPxvjUYLRmkBnv65exEN2aupECvd+CjzI1H4ytpgIeQ4Yo3fDurvH
         XLCQ==
X-Gm-Message-State: AOAM531rtllIVGCP/KYXweL2pRVo4Kf1TNYKn7gh6l+KSlbZxNLH2Pke
        FT0JWQ8OVIoZZAS8Do49lmB6ZLtp0Zo=
X-Google-Smtp-Source: ABdhPJy1LLA/IFJlEudL2NriVg7T5EXZ8E0TOJHRnSUoJlA4b3yxbepiAAGMx7r+kf37FRTQm0rR3Q==
X-Received: by 2002:a17:907:96a2:: with SMTP id hd34mr9651881ejc.113.1631281694618;
        Fri, 10 Sep 2021 06:48:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 14/21] trace-cmd library: Set input handler default values in allocation function
Date:   Fri, 10 Sep 2021 16:47:50 +0300
Message-Id: <20210910134757.2863982-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Set usecs flag by default when the input handler is allocated, it makes
more sense than setting it when options are handled. This clean up is
needed for the next trace file version, where multiple options
sections may exist.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a23ba9c8..fbfc0d1c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2677,8 +2677,6 @@ static int handle_options(struct tracecmd_input *handle)
 	int cpus;
 	int ret;
 
-	/* By default, use usecs, unless told otherwise */
-	handle->flags |= TRACECMD_FL_IN_USECS;
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
@@ -3312,6 +3310,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	/* By default, use usecs, unless told otherwise */
+	handle->flags |= TRACECMD_FL_IN_USECS;
 
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
-- 
2.31.1

