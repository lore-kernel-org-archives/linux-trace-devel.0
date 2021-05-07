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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779EFC43460
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 10:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A5CB6143F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 10:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhEGKV1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 06:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhEGKV0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 06:21:26 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09739C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 03:20:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id b25so12789789eju.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 03:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N64kpl+7XOTf/eBwPHwl+gC/eQZ6LF+23llhXv9ZhWA=;
        b=E+AzBFNikvdVtyz+0eVyhXux6LX4/FtiiUmtYKRTTGM0AdPs6Ue5L4Xfc/3r9tDHPJ
         sk5M9c6zK1COcndldQqlCCu5h9Tv2KbUODj7bPxGgIBctEds5PDUBFhFABjf7FO8LlLh
         fIAk+HVSZi0jvnqvLCQP+/EaAAKjO422rz7KKIPZJck8pKKdz8tOEGXi2aYnPmWA4k4O
         HRR9e1mc4ScDZWS3D/y2RGF/6b1hPle2GG+OYInPOT+u1m0I6JKL1MzyicZpR9kTukn9
         tYxGUVO0JXaOCxm/1h69TYi3VdJqAKSCFWVNCvA8W1FHfVvUmuxiSxZN8nbtZvjRJv4s
         jGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N64kpl+7XOTf/eBwPHwl+gC/eQZ6LF+23llhXv9ZhWA=;
        b=TQ9h/swAn1Zohmxa98bkxAYY8TFvqaFZ8iSSZmMSlLkoCNq48D/34sMsMdrFR3FfF2
         3W7GmkK34UD2e35N2SHDQ5mVD3pRPedcJaFQ0kyn58HYFTP2uJA7pcdbvI3Ci0Yjsjj/
         1Tj3F4dCIeOX1VmodXAXwP3JBPD5fYTm52iIo1gSPw4cKIERqFCsVJjXF88Z7KfjdCaC
         21LHugaOUXXNYeQyt/3J1GHF8qipOPd+PN8JUxLwo9Gn4HQY+e71EghwTpglKua1Q6rT
         ZYxZmTHX4Tgq4rlrW7NT0mvXfNAT/vHxpEAIA39YjMMXFi2nGBAsw68LMqfqpN+6d5aY
         CuaQ==
X-Gm-Message-State: AOAM532YD6M6TO8QeZf+UDJimFHwAwuXekpv9FTUZuket4/rRrYp77Qn
        Q953f9aeYvbqf/yUmOigAnNwRWrvQVL06A==
X-Google-Smtp-Source: ABdhPJx6oThED6Fg7gYmeWUCJux9MDphY8oG8yKVFXx0Lopt6XmiJKV0qsdDrOG4bT1GscUoTK7R3Q==
X-Received: by 2002:a17:906:1e0b:: with SMTP id g11mr9081444ejj.291.1620382824827;
        Fri, 07 May 2021 03:20:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f30sm3258595ejl.62.2021.05.07.03.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 03:20:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd report: Document --align-ts option
Date:   Fri,  7 May 2021 13:20:23 +0300
Message-Id: <20210507102023.1092265-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd report" man page with description of the new
"--align-ts" option.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-report.1.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index 72b47065..55c2371f 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -312,6 +312,9 @@ OPTIONS
 *--raw-ts*::
      Display raw timestamps, without any corrections.
 
+*--align-ts*::
+     Display timestamps aligned to the first event.
+
 EXAMPLES
 --------
 
-- 
2.31.1

