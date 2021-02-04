Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F497C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 10:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 073D864F10
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 10:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhBDKxH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Feb 2021 05:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbhBDKxF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 05:53:05 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F0AC0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Feb 2021 02:52:25 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so3509571eds.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Feb 2021 02:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/yHZS0fZu8trI7KMNaqSGSkaI4ND/Oi8KX2Z31WKFsk=;
        b=t4t7Zx1TAGdjpZYg+Q9RvxHmgoE53JcwyewvN/RPpzeUDdGeQ9J45c6oPH0L2TpXro
         Qobz6lbOYBzfebb+xq2Jcbj3F+WOG45b/ClP1JXQmt1VtUteqOxeWixM7Db3trKB0ihB
         RdjyMZ5soQM0fu9TVUemHOGHCkaDbLWQP89J+jM0lKIWkBJEMSyxQEJDg5fYpnaK5BcY
         XtnAjuo1xY6fhfE4TlWqc1ex+iDALa0hK31SuP2QqLwoduNI5Jf+LY/JLoWPEnEpbfFi
         oJ9pIRsZqEoDz3IKS7X5jIAHpvwApySl3EoQZMLKM1k+uTH8sNhrt6FjTO+uiIjKCbIn
         gyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/yHZS0fZu8trI7KMNaqSGSkaI4ND/Oi8KX2Z31WKFsk=;
        b=DRYlCt6n0eHNt83Hi7Tqj9dwhkoDUS661qnFo8N/wrVFSOzSh0ZThP9QQXY6cuxkxv
         HAAKqBIttRvTN/w7dphsZK3N8VflAY8hmmKkdpU6smLXGIsh7hewHyg/0FpvfKU9uGBW
         vFbUeG1aqynOFAHB8DM87/XFqVb6QHxsvi2gM219HXvSdWcUjw5axsuvb6r9CZ0OWbkX
         kfMZkAz0quXYA5K5MN7XdYmY/l21Qf7BVVMfTgfzXBm8siThdtXVMIcUgIpdGwYiE/CY
         /KtxcZ/RTO5BHh5JT+lHOxsphTyWwDhi3U2sYH+IDoVcElbTgqYM2IfrEnLVdeyRbdfg
         9UaA==
X-Gm-Message-State: AOAM530ETRZwmKfE6aRo2yE2hpeJF5oH2GaScIM5jZ8ppQrfci+NWCk0
        VvD0MIE5uGgDbX60dAEeqmQ=
X-Google-Smtp-Source: ABdhPJzZW30H16irTPy5jCN0dWxKMbwBFUz0sNxKDExC4n9ub2idOX2DrtLROtrWSdRrLJSLY2G4xw==
X-Received: by 2002:a05:6402:1383:: with SMTP id b3mr7061040edv.131.1612435944473;
        Thu, 04 Feb 2021 02:52:24 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a10sm2335705ejk.75.2021.02.04.02.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 02:52:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, douglas.raillard@arm.com
Subject: [PATCH] trace-cmd: Do not load ftrace function event plugins if plugins are disabled
Date:   Thu,  4 Feb 2021 12:52:21 +0200
Message-Id: <20210204105221.1081729-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If plugin loading is disabled with trace-cmd report options '-L' or '-N',
do not load ftrace function event plugins as well.

Reported-by: Douglas RAILLARD <douglas.raillard@arm.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=211255
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7d28254e..89e936d3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3128,7 +3128,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 		goto failed_read;
 
 	/* register default ftrace functions first */
-	tracecmd_ftrace_overrides(handle, &handle->finfo);
+	if (!tracecmd_disable_plugins && !tracecmd_disable_sys_plugins)
+		tracecmd_ftrace_overrides(handle, &handle->finfo);
 
 	handle->plugin_list = trace_load_plugins(handle->pevent);
 
-- 
2.29.2

