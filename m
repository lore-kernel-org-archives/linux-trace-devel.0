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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7997AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B018610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhINNOK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNOJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E0EC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:52 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t18so20188104wrb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/A80fJWoSFzNxEk5fUNHia3MlkikAeaBVf8zLeooVqY=;
        b=YFntG8st3TJFe9tdRGQP0zbfuNGZBVPiYgo/fAjZmKl4JoJ5Fv2h3Ahxy+fpL+B3Xn
         C7q+cbDZpOeD4hjeQB0jmpTSyQloxzIX4xomJksWxcSGokavgDdUaii6fYgO+041x9oz
         yQQR2w2iSqvFbTSA+Y4Cq70eO5ZjB+P3ZXyqyWTTI4U0GPC4ywemwLOKaznZyoQKhuM3
         +HEI6EON9BUgsTymNQkvJKXIk8fRBhtpx+ee7O+o2MNHH5TH2bqkba1D6S5IgPByqU9Y
         Qquc5PbqQU5U+7tJ++pDNHnqXqsCJq5TZ8TbPmBwHqSowwMI1LXymWcfsW3ldtpmNdL4
         cMGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/A80fJWoSFzNxEk5fUNHia3MlkikAeaBVf8zLeooVqY=;
        b=P7BRRUslnmviGXa3j5MYIwIt5vb6tMl9/yhfI1Qo+w75ibpFInaEdR5U7GnkI8dthV
         UUfiSzmoINaqDb3COG0KWWvpA5g/2jBt/dOnaN7lnIWRbhgzLXnPBYsLqlJoz0tJoH4H
         y3jdJU9wVt1SgYm2afoUT8QXueM/UxMssNu3o9bxmKIylXoAtP1bIKnb7o6z7rH4r0OM
         ZbmIe5D1628QBdYZLlaGYrUISRq/dqaQQRa6kDiNiG9raIIKjPbSwennNTcGqO/rW5W4
         cxaYDXjfBVbSF4HJV0rhy/kHNjTf5K+p3OSLGNIFtewKvdXXt7+r6jPaKTh3YGEdhf8K
         Xc2g==
X-Gm-Message-State: AOAM532hucByQNROsei4GPPO1onQFyVc5oVDdTZ0YjR5wGaf1BxsjFxw
        v7uwnxj7Brb3gg678C3U0pc=
X-Google-Smtp-Source: ABdhPJxulh6e11M5RU7JnC+aiIqB4RW7KTO1ktU3Y8X2qjd+Px+pWDbVlQRN8V7goGA+jgVDEXApbg==
X-Received: by 2002:a5d:53cd:: with SMTP id a13mr18808342wrw.33.1631625170704;
        Tue, 14 Sep 2021 06:12:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 14/21] trace-cmd library: Set input handler default values in allocation function
Date:   Tue, 14 Sep 2021 16:12:25 +0300
Message-Id: <20210914131232.3964615-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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
index 9fd7e6e8..cb8b9f14 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2677,8 +2677,6 @@ static int handle_options(struct tracecmd_input *handle)
 	int cpus;
 	int ret;
 
-	/* By default, use usecs, unless told otherwise */
-	handle->flags |= TRACECMD_FL_IN_USECS;
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
@@ -3310,6 +3308,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	handle->fd = fd;
 	handle->ref = 1;
+	/* By default, use usecs, unless told otherwise */
+	handle->flags |= TRACECMD_FL_IN_USECS;
 
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
-- 
2.31.1

