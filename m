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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CFCC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B7FF61158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbhD1Nsd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239917AbhD1Ns3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:29 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7511BC06138F
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:43 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z5so37804281edr.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fzEgHU4+iYy8isoiMjMORmtrb8HCDvmgUOveuZzhBHs=;
        b=rY2uA6/wJXbJxG+55bPiDLxXnvFN836xiY0kbz/zIsuPX0nSpDrN+0U79OGnhYFUkd
         BoAAVO7ixc2Bm4cn+jBkxl65b7Bvzc8EK0alC0wvEpFz+6LR6lTli9QlxDQVWuu5PGFp
         Uv7uIbMNx85NnDJM6+rtuOq+1IFzyv4LysSVavzaeyxeuCUWro47LB4+a2xtptOQv05y
         hStDb7bYMo3yjkYGk00RinadSGJneCp5PRvajYkMZKgJwckwQe7cXLbKWOca768iplQ2
         f/Gv2bqL8TKTmFUzOELRz2+L9NMJSS8P2rFNQMNT0VWGFGVHHhMps0xUgY5elbIomz5s
         KeyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fzEgHU4+iYy8isoiMjMORmtrb8HCDvmgUOveuZzhBHs=;
        b=kz0SHtbXYB8XJX757KFDbk5SCJ9yytEc2l2+ccOUkBI3QJNRf+pDpC/rX0WXHWcDM0
         DE7nYf/4Iy2x5f60svgCXEFhlVn9FsYQja2cXstGnf9j9HJRlGsDXXYdhLLMgertH18v
         wHZewFU/9bcfAF0BEMOmBXxDT6qVvBFStDpngMKauQ6xfyoOZ+5mZMHSCKBU32nT3KY1
         NOjDSTIpq5Kq0o2G4FrnYNyA6HVrQnFXIdV255248SYCeDamyuthGZa2HhbZRjHuEMLE
         VUdhH8/8wQAT1Imz8OFIYPF7ihmjPqr9YO6l1NzlwOYP1DMJ+kuD5hQIAUA4ZLvLtyZK
         qtNA==
X-Gm-Message-State: AOAM530/GLeawRmIHcLmW0WF5b7zzyMNLYRSF5frRj+pqDcqM4r2xFAR
        UgMuuCWv18L+Z2tZFelsnbpEHL0Pfdc=
X-Google-Smtp-Source: ABdhPJzdcwKdeUtI7KiWV9eS2d+wBSxIlFDMxOJYykNbeGdD9v+Ml1a0nq2eHkLoceTRgCIThy83CA==
X-Received: by 2002:aa7:cb89:: with SMTP id r9mr11523797edt.245.1619617662063;
        Wed, 28 Apr 2021 06:47:42 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/9] kernel-shark: Add "cron" job to workflows
Date:   Wed, 28 Apr 2021 16:47:23 +0300
Message-Id: <20210428134730.187533-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CI testing will execute automatically once a week on Thursday 3PM UTC.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .github/workflows/main.yml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
index 4125354..925e235 100644
--- a/.github/workflows/main.yml
+++ b/.github/workflows/main.yml
@@ -1,6 +1,9 @@
 name: KernelShark CI (CMAKE)
 
-on: [push]
+on:
+  push:
+  schedule:
+    - cron:  '0 15 * * THU'
 
 env:
   # Customize the CMake build type here (Release, Debug, RelWithDebInfo, etc.)
-- 
2.27.0

