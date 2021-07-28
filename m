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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009DDC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF06760FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhG1Ndf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbhG1Ndf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1371C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:30 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r16so3229582edt.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xn1/dgmzYeWp2JZ48pRNKDHyTXAwHHXitKe3tpasDbg=;
        b=GPfsJm1fs1JVIi+jYPLiM+Ddu5x4xzsYRjMi1zsjDSeQw9d2op4ZiKoVzIuYmUPB84
         cyYUZt33jHBgN/WqvNVqa9em6ZnqRo6pXz1rwwOn5CXSF2w9bB0Lu2zxbLAkX0QlWK9s
         K4u3EvpV1wobKW/RKtvf4U6Qyxoe3iRl5tU1Qr0uStxjr3pat1NZZC5Mk5AWV46in3Wo
         Se7ouq5TOPqC8+PZ0RfppC5n+0jIIgNUTbS59glSfsnJmxCzY4IjCWjIZSF/v6u0WtCO
         HAnrumw+rmV6GPKTlXDrLLkQZK+JGvpzJPfV1iowlts+X1ws3DH8RVGvdJdtVAaz0yAz
         nWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xn1/dgmzYeWp2JZ48pRNKDHyTXAwHHXitKe3tpasDbg=;
        b=XPgessPskbfB1Ht6tBTJgWVZULylEaFQvQkFQZyl0LFQfiDh6qviI0JpRpfpU7dEhx
         rdmrESKJxWqsRf77CgRhGsNBnTTMXGSAZ8e5cuyb4B+CTB0rdtWx39TPgGM08TIjsRU+
         GDF730nUresDfNNExLyQn31GLkio8jS5a/n5XRiMtOjtuCCcklFcp/cQ+UlfuDxrBhn8
         e6ADqlM+J+69/KMMLOg1rfBNu7MoLJIZvkrVyMiFddzyBntwx2R2UQJX353yqrr3vArd
         IaWAOnGygZfzjlFYsKSrXgeiBgMRL0EdC9xdqmDrv9Q6ZDYa0X3Nj6bJ+LGNCDSrVjs+
         z7eA==
X-Gm-Message-State: AOAM530T+6L50/MIfuz4k5UTWDm32YeS+FdkGqBGy3J8PqHT2l5fMTkx
        0nwICq3PTBJDSp895XfzUyI=
X-Google-Smtp-Source: ABdhPJyW3q8V6OPrJSFpIoGQmsbnEK4RR6AFASSDPJmAAfVFoqmzbc28av3KaMD5InTMmXfM18lRUA==
X-Received: by 2002:aa7:dbc8:: with SMTP id v8mr33389588edt.242.1627479209399;
        Wed, 28 Jul 2021 06:33:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 37/87] trace-cmd library: Set log size to the input tep handler when it is read from the file
Date:   Wed, 28 Jul 2021 16:32:00 +0300
Message-Id: <20210728133250.234140-38-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index b96f6d1b..1445a540 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -977,8 +977,6 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
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

