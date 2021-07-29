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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DF6C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B4E761054
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhG2FKt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbhG2FKs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:48 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84FAC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:45 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n2so6357309eda.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W9+QRCCf8HDtczTrLkNWVkYGcyxFDhPU60GJbVA7mRA=;
        b=XkgRW1QTPuF0bnzLZ2vkwMYZzxGg755PFmuS40QI396mYQ+Qo4Tn31PfStvXMGhIj6
         vYcqsAn3OqiWtUemiNZewyDHF46mYYnmQwBcKnyeuggtGTk1OkO3+8IoU8wp1MjY7C4a
         No1cmoh982zrZpo6es2pgEM5ZaiGmxjjqtxI/iaa+3txrCXNAHVxls3yDh5rmcmvIJG2
         nqwYprqSjTzHWRh6G/vx/TtyqYwuQy9IveoF5bKEma7KMZKJt2hu2vIxhLJkXlCpzpm3
         Y7XToSXuoIRjbjUPv9G74ysQnXvTMdSV6WSuws1LWKnZ3l05orslR/8jiUq+ONp5281O
         FoeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W9+QRCCf8HDtczTrLkNWVkYGcyxFDhPU60GJbVA7mRA=;
        b=YdslvQ8Ye5inzOPgxkKuTToxr1mWdMYF/eh3Z+n+z5s8pvcb25SeJ+m31ydc0a8mCv
         YaKtqZPQKWsghp2XCXuncYX9pWXri2VUkyL4/u3Hp/xlwwItH1voOCsdHXEqmrQvssl4
         kbpNjohwweZGpcIiKIN+LZlxJgWI3iY2a3/RwigXeC87YCYkIBuL8K9MTGBy0KyBozhP
         LY3xciEJP3BN3rGi1YSqRu0QphVJfSK3jbmv82Wr/r7SwOgODKqp1Tn1lehtMJxhfNVR
         mPbRvkEiZXQcaGR76iD0u3WSKqgqXZpFrbBB6ym/qRKXzWR6JYE9OR7x3J/loKgGONd9
         XO4A==
X-Gm-Message-State: AOAM530EvE57FwPv9Th4OV0nBBg/Zqrzr46yqkpaCG2h1b9cQ0gtRWt0
        BfruoD1wdwK4fkv+QlMhW2Eff0alqkGiOA==
X-Google-Smtp-Source: ABdhPJyY5rIpnSzAaDG5oRs4gTsMqwzEkhSFN7XOmrVw9mMXGgllShrTVI0GLr/BqF9Sej9dSglicA==
X-Received: by 2002:a50:fe10:: with SMTP id f16mr3860531edt.85.1627535444497;
        Wed, 28 Jul 2021 22:10:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 44/87] trace-cmd library: Set input handler default values in allocation function
Date:   Thu, 29 Jul 2021 08:09:16 +0300
Message-Id: <20210729050959.12263-45-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Set usecs flag by default when the input handler is allocated, it makes
more sense than setting it when options are handeled. This clean up is
needed for parsing version 7 trace files, where multiple options
sections may exist.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 41f95874..23eea0d1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2794,8 +2794,6 @@ static int handle_options(struct tracecmd_input *handle)
 	int cpus;
 	int ret;
 
-	/* By default, use usecs, unless told otherwise */
-	handle->flags |= TRACECMD_FL_IN_USECS;
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
@@ -3448,6 +3446,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->fd = fd;
 	handle->ref = 1;
 
+	/* By default, use usecs, unless told otherwise */
+	handle->flags |= TRACECMD_FL_IN_USECS;
+
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
 
-- 
2.31.1

