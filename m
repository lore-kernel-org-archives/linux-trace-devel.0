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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F1CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22AA160F6C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhIMM3g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbhIMM3d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:33 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C344EC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:16 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id x6so14386290wrv.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/A80fJWoSFzNxEk5fUNHia3MlkikAeaBVf8zLeooVqY=;
        b=PiifEJikGKMDJd4BbVJt6QP7VhXU2kbVq2u12qijvdcnXdIscnTaSrVMuu5wPUV8Lc
         d6xKbia+Lh6MKqeOq2ZzxLhQtBV+530Z+RyHyGESZqGf2JcCS5ulKcuFiDxSPxbPisYk
         hd9A51VgqYN5S8+1/ScFPk+e1uNp0oBnH860zHn5tefHTbEwIxi7q/1/q8ESTPk5fja7
         2VhdUmAN4LlFqvQgcPI/Fo7mjdAVRNIrJIlYwW6K1nwwQjGXA9WbrbOz7rWK9MQLUSwj
         kYqj5+2aixF7jWMAWlnc+qyoPTZFt6YC0T3wYKfIazQCkuj+P1pprQVG5onX2WeLwGzn
         XkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/A80fJWoSFzNxEk5fUNHia3MlkikAeaBVf8zLeooVqY=;
        b=ky+jk1zvDTjXjN/jr/R8jF02/AWY2Z4+z4xaBPXGuolomO5p/OoQ9OqO+GO5Z79tap
         jOo+EY2G7U23LjxDFg4zQX1aR7S4cklUh4ZcR8jFBFlFe44lTqsiVXAWees3pUngxkmG
         OYKR9WvT/oQRDiFSarRobUuJ7+awNO3VYtvC9FJi8bpaDSZmp+yWwanVFFrq/LPnW6FQ
         SP/5b78Bor4WmhihT2V/5KqPxTZKyGwdf5Sa/h9y5RWS/jzKa/H/BgRxUIaldTQ8BRnR
         u5QwNyPZojHz8ILrlpTh7ODgcAZTdKzi31lY2Yczs/tGfKXyCeGVJKiNQUGDt0l6uH/F
         KEaw==
X-Gm-Message-State: AOAM530+pYM2geqC9X8Vq9dSr2IFDzDXZ8Dw4SCOBEfoijWM0zEboY+8
        3utT/9I45UXqjSNUIW5xCKwwrYIlmGs=
X-Google-Smtp-Source: ABdhPJwpoH4RpeAF8EB13YdCCtyIscm7pgiNE2lPQBoWQciClwRzDY9tCn/J78v+9VbY+nOTpzTZFQ==
X-Received: by 2002:a5d:6741:: with SMTP id l1mr12362725wrw.289.1631536095382;
        Mon, 13 Sep 2021 05:28:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 14/21] trace-cmd library: Set input handler default values in allocation function
Date:   Mon, 13 Sep 2021 15:27:52 +0300
Message-Id: <20210913122759.3672494-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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

