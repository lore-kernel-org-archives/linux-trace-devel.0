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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8FBC48BD1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC47F61406
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhFJLhF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhFJLhC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:02 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3021C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:53 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l11-20020a05600c4f0bb029017a7cd488f5so6243324wmq.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oyvni9NwSMBXewBmzBWQtJRoikj0AVHUlPO3dy5pHdU=;
        b=luGhXp5SklsR+W1RMOZ54X6mS1Hrrs5Grc8TZEqjozxSTIh0ESqhUhu0kYfHjSNyUQ
         Uk5qowIR+mR85gw3TqZ0J/hjFBkVRc9NHMoq5/yQ9TOsW5mszlnsqYqo2dQupQyyd40S
         7o4CbP8ZWnnIW45a7qv1tfS94Z2QyiuwtZX7rBddvZ0cx8oeZZKOALKUPjaaDUhQHbgy
         41S3mltjOIWfekVXoIwbefKY7clNTrdFUbkkqIhrUZebQ5mFuLFNHFv4PhEiV+SipBqw
         kEkWRVjjC0Mzu5Yokbjlgb71DHs7srmUG0VwO9NJhv1bB2i3H2dQuVRLrhG5sFbqsAPW
         KfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oyvni9NwSMBXewBmzBWQtJRoikj0AVHUlPO3dy5pHdU=;
        b=XhD7XVDQf/3lr9AvSaCwx3xSUMaPR4TnDflA+wZPD2NgCyKDE7u15326hTqeotj1dy
         79CGt+6dnn5j/hBTPPRDlU2gaJeqBwMmLLBrDttP1YTBvYWzefWkM8uHEdW7Uxqk5Lss
         1JtIdz4mQFq7D1mDihNarSubSjlHBBSiZCnsm614THnOysB7ZbWgpfiarBfA1eL/yH4n
         KseBOQ9SWJ61qfUrfUGWSkjDxc8YqaIxsHzgno8bl/hEwpMpbN6kWxqj2Vsz20BcZQu4
         cqU3MhV4tjGCa+WwE1JMMIIXNMnxK1QJcMqtlZEYidvLwTM7/9WXvBKn+GF6929BLI4V
         HSqw==
X-Gm-Message-State: AOAM531ybEF3RRTKXCQvjkd2YEbF7g731LfcsY8rmjMCyU1cCH1NtkyW
        tdals5aRBlQhL8+IVm0vDJg=
X-Google-Smtp-Source: ABdhPJzsEpJ+Bl41KUZZfqY6eHNwcPIQP1BV9wCq13voh/lTAJ96A9VPKzM0JRjPJlZQsLMy2KM+OA==
X-Received: by 2002:a1c:dcc3:: with SMTP id t186mr4829201wmg.23.1623324892639;
        Thu, 10 Jun 2021 04:34:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 26/40] trace-cmd library: Compress latency trace data
Date:   Thu, 10 Jun 2021 14:34:12 +0300
Message-Id: <20210610113426.257931-27-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating latency trace file of version 7, compress the latency
trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index bd14452a..6a272503 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1661,7 +1661,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (!path)
 		goto out_free;
 
-	copy_file(handle, path);
+	copy_file_compress(handle, path, NULL);
 
 	put_tracing_file(path);
 
-- 
2.31.1

