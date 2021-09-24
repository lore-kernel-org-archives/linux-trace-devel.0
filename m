Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B51C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FD8C6105A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243849AbhIXJdl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237056AbhIXJdl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 05:33:41 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADFDC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:32:08 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g8so33716936edt.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xnI+CFoh2+7uRYX5ZvO+ffHGzgo9Dj/vMAhFopRFqvA=;
        b=iKpu/0SWT+mXf4p6TpDMvsBk0A/MSMGhaeW8Vj0FQltgYYYKEIx0gBv4bzWmNU6LG9
         L4i6hdtUqy2TcqIvr7FQTGkqEnwtVy0QdjrMrZ/8/LVumSmhcIRF3HqAYUZE8aDh4SXh
         nMWXV2pIzHJwX/7+dsZtHKiVL+0UQ9UZ+/UyHtTR8WMcmssJVIz6pvFD9m/TG7+3pMLB
         4WtXWzmB/g8uTaR3zcJlpq3TNO7C2tNdOrecuKhoEf/7Zdp45hhaKFnKYT5dVoJ53Bws
         oTGClQ0esU1Xd/TsnejVtSCGtokHdf3bWAbSPyjIHd2jaYcPNLogdfeLqDmLkinRmPR8
         jZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xnI+CFoh2+7uRYX5ZvO+ffHGzgo9Dj/vMAhFopRFqvA=;
        b=B3so1vFVYA0gh0cCDfbxd4G0T+Ypxx5lSNEonVdiW0f3Pc77dXDg7UmlItdzL63lfj
         UNh4zwiYvmtLO71fZQEdQXTAPvlKqJE865dNwYPYZFD76qdXNZaW9BdxK+5LgUKRPkfD
         x1yHLMV7ugVl8yUSpvGXWjUYN40MTK4aGouflhhgxH+5PCQcRKE4Bm8v6S7fd4j1CJ8p
         iCsAK0pn8AglRqNgub5JnudFJ4RCEm8dyPqgJUEVnLCk8iMOfwfoqUmGHYWXpBuR6z6b
         on6EhdoQhF1VpElONg0P0V0cGgdExaNlI661r3HEjEZy2K7tvv5l/u1kvF1OlAj0V2Nf
         BIeQ==
X-Gm-Message-State: AOAM532B4BtLVstxNdqkq0QjyCPVVslObFXiSJtldd+AWvgjLiqwpbk5
        B+lGG4WTIYbEf4TbI6IREqcjUZg8h3Q=
X-Google-Smtp-Source: ABdhPJxnZIPnCBvKeE1GAQqePruuR8KAxu/Zaa/q1tNRe2RZYeEntIdkwj7ydeOQYC8jcdZ2oLUNEQ==
X-Received: by 2002:a17:906:c055:: with SMTP id bm21mr10072871ejb.350.1632475926404;
        Fri, 24 Sep 2021 02:32:06 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id c19sm5433770edt.50.2021.09.24.02.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:32:06 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Fix the install instructions in README
Date:   Fri, 24 Sep 2021 12:31:55 +0300
Message-Id: <20210924093155.150647-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Removing 'trace-cmd' from the list of external dependencies
was a mistake. trace-cruncher depends on trace-cmd indirectly
via libkshark.

The address of the KernelShark repository is updated as well.

Fixes: 502aa91 (trace-cruncher: Update README.md)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 README.md | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/README.md b/README.md
index 93f12c8..740d60b 100644
--- a/README.md
+++ b/README.md
@@ -13,7 +13,7 @@ The Trace-Cruncher allows for sophisticated analysis of kernel tracing data via
 ### Prerequisites
 
 Trace-Cruncher has the following external dependencies:
-  libtraceevent, libtracefs, KernelShark, Json-C, Cython, NumPy.
+  libtraceevent, libtracefs, trace-cmd, KernelShark, Json-C, Cython, NumPy.
 
 1.1 In order to install all packages on Ubuntu do the following:
 
@@ -62,7 +62,18 @@ Trace-Cruncher has the following external dependencies:
     > cd ..
 
 
-    > git clone https://github.com/yordan-karadzhov/kernel-shark-v2.beta.git kernel-shark
+    > git clone https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+    > cd trace-cmd
+
+    > make
+
+    > sudo make install_libs
+
+    > cd ..
+
+
+    > git clone https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
 
     > cd kernel-shark/build
 
-- 
2.30.2

