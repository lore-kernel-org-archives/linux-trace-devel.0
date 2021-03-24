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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855B9C433F2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 403C161992
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhCXNFd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbhCXNEt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:49 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903D7C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:48 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g20so12861153wmk.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zm+BFXucsZyphQSVHYTcZQBOKWvv5kzSkT5G321QS7Y=;
        b=bc6ZTBPKEplfNLPmuSlmIx3WFs+yru7dg+7w/QzOlSNU/QvjkH9BfGvexeuuhRMv8k
         WHCyRJpoKJmNL7e6meFaADVfLzIfudGlk8zgBOCPMIWome8BiCvU0DwZ51hdYbI0cO9x
         A1iZwDXLwyzOWsLck3p8yLTYlAdT+JCX+NNRY/RZEfhuO70u4v+1WupCaN2+jxTVCQdd
         kfYEd26wFoQz4gF/hYBZmzYw0Xj/hbiQ4CrkN4yD4i3y2f8kE3/QY/TiUE4uwP0tYVOS
         k8a65IQMljQjtCGLVopprmOKzCqJ9/mQ+TNhQ2ADSBDL+xCjuhrDrpCKHgQGbF4WQIrZ
         MmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zm+BFXucsZyphQSVHYTcZQBOKWvv5kzSkT5G321QS7Y=;
        b=IElAF0hB+qFg0NZNMQ8Y/M9z7lD2iNFCLYWXPgeAhXdVTnOw57XXndyLpupdagvEKb
         izPnjBX80xnwQDH2OWrL4KUkeflwTCJokPkB8EKvs/6RgqViJt1ASvOQviNgADSCEVnf
         dGNcHC998BfiSxj/piKnhJA523QwZPizsaTwhXSc2RKFRj5/x0P3AM1UyT9BH3ati4d3
         NCNHZ0rFVaYFJWfO/aE1BPlfSWKDu31PZL7R+DwoS9I/5sQOPjWhP6xunDPe+ByvmmfE
         LleLSQVAYHUgpdcXESbIg4a38eOceO2C4hLmf/QFzqz291NVNnjHQiNPHRTfJ6LaTE3y
         r5Uw==
X-Gm-Message-State: AOAM530KqJjkSqyXPykn4V2pBqMqvRFg5JVlAkYMJ9yrVaqwAzWMSde5
        6LnEqzoRJ5VLxLzYfhGxkLmYq/o6gt1G1g==
X-Google-Smtp-Source: ABdhPJzq4hKNC0lTYKOaR6G/qeYjcNLAzmkmNnUP7GinaPMQYkBWzJNhGqJEt1KWfaU1Kp3Y8+S0mA==
X-Received: by 2002:a1c:f614:: with SMTP id w20mr2814735wmc.70.1616591086763;
        Wed, 24 Mar 2021 06:04:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 19/23] trace-cmd: Print times in TimeShift options as unsigned in trace-cmd dump
Date:   Wed, 24 Mar 2021 15:04:14 +0200
Message-Id: <20210324130418.436206-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed "trace-cmd dump" subcommand to print unsigned times from
Time Shift option in a trace.dat file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 31b9d201..f5b864f7 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -373,7 +373,7 @@ static void dump_option_timeshift(int fd, int size)
 {
 	long long *scalings = NULL;
 	long long *offsets = NULL;
-	long long *times = NULL;
+	unsigned long long *times = NULL;
 	long long trace_id;
 	unsigned int count;
 	unsigned int flags;
-- 
2.30.2

