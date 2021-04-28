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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A065AC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D6B613F3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhD1Hmo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbhD1Hmo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:42:44 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F00DC06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:59 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i24so13402490edy.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmpITfbu5iSXz343gdLkGmlkGx2yNagBgVhYyKZBci8=;
        b=XuvPC0u7UlG+aR2tf3GSV09gQDmw6rCdbqvEsXN6TtgsdSbNeY20Jlx3b9pC33Wm+u
         awgHV4L6oWtfY2rmoCAEiMCWhorNel7KQXofgKq4TA8firg3dfeCjHJaQZ7lyutmZFIA
         s0+JEe8i/+cVQDKg5470J9fAy3tmLu3FsfhqkxVePHYt1+ttiulejPhPHSSFqVo1/Dcz
         xE8x+XFEWfO8pGCdnXgQ9lYXDWDAcq8brvEMusVyBvbJvgBN+tmccUmHNqcWAnZ7x+YT
         I8t9GgP6AdNnT2p2xajALdSBwS+SxdnYWujNgxfnMHLmZHf82G3tSGEg9IOi5T6Mna7l
         k0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmpITfbu5iSXz343gdLkGmlkGx2yNagBgVhYyKZBci8=;
        b=nqlSwdyTkWVbI4Z91gXhAX/AU+9Qvgyde5njLdlDryltVl9B78BPaFWtdrHHMB5GR8
         ooG7rHQRRPyPYckUVgKRElt9FlY5pDE43FcmW5xxQjkgjcB/whCuYxaR14G7kEUmwx+M
         F2E/70z98e0pJ5RN34ATlYmtMH+Nx1G+D8vbsSjmFnKkcHRNLIgK90MKemmUk+/kWPeI
         6clJq09X0SBsDCP7Ne9MeF3mWZWJ9X55t9O3im1QbmZXqh0z3Vrf9d01lG9AVvplYJNy
         lL5J5XS2JtBfef9fHN+cxITx1WjDWiFhKmC0b3pk9EaolFVBWZ7VwdwnIZBPoC6L7T2U
         zmtg==
X-Gm-Message-State: AOAM531MZAu+hGCeKRZWuNB+pBnxSd6T0dVBuccbkuLH+FYLo9UjhMiI
        HF2xgTQQbgkbKwNFCQE7nioaakd2ms1f1g==
X-Google-Smtp-Source: ABdhPJw3c18IrfRWs60l3qd1vSZPTrth127dml4PAUFOQJ6hhic6fxx+XOtSLzalLPs2xI1iDRRxrA==
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr9556905edt.4.1619595718213;
        Wed, 28 Apr 2021 00:41:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k5sm4530504edk.46.2021.04.28.00.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:41:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/8] trace-cmd library: Set debug log level in debug mode
Date:   Wed, 28 Apr 2021 10:41:47 +0300
Message-Id: <20210428074149.757163-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074149.757163-1-tz.stoyanov@gmail.com>
References: <20210428074149.757163-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the library works in debug mode, set the log level to debug.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 25c1ee92..6a2b237e 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -93,6 +93,11 @@ const char *tracecmd_clock_id2str(enum tracecmd_clocks clock)
 void tracecmd_set_debug(bool set_debug)
 {
 	debug = set_debug;
+
+	if (set_debug)
+		tracecmd_set_loglevel(TEP_LOG_DEBUG);
+	else
+		tracecmd_set_loglevel(TEP_LOG_CRITICAL);
 }
 
 /**
-- 
2.30.2

