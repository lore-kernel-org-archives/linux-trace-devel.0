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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327ABC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01F7961027
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbhD0Q0c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238927AbhD0QZi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:25:38 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721A8C061358
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:26 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id e7so70590082edu.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fzEgHU4+iYy8isoiMjMORmtrb8HCDvmgUOveuZzhBHs=;
        b=HV22esFPHrXuDcCddR6fVdfHOMLMbOiZv7jXF+QEYc+01g7GKZsdhOX1Fqzvrj6TyB
         mzq+qj6CUdz814sJYaypfm088toqcOVPG0UIqmbEkym1kL5C9XwB34qX8TOXMG/A7+w9
         ZDLSTy4qs3GbrxX+T/mC0HY9vBB6Y4b+1o4IYw/snMa+NNy5Sd9pCQTe6WXszohUV2+u
         OJsNnFkMQcIxjoeLBdPdjdgoZsRxzJenmkEgvv/CoqTrQhU8gsuR3YxO63yAi5VAiidQ
         9y7XLt8V2W4/4fpIT+6Aq3s2Z3NHZ+X+8TagLnpg/GsOYAEnbCXTx8ExQtlxMSGSrsLa
         7rMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fzEgHU4+iYy8isoiMjMORmtrb8HCDvmgUOveuZzhBHs=;
        b=VYfbyl1vRGriVsbDg37ExQJeDuqqjtk7Kn/HWOeHAuKneVdD6G7VBcGsdyHn06aPOZ
         gWmVDnTynd0lJ7cwjeg5k8Eir1FbyKhq57kp5m3sXaoofc94m3ZK9A9b+tCBraIENMsm
         yDC/Fy1AIMZGP/mPs0K35tx4z3oQ3fi1Sl4harxV7bHdqXL7xVD7Am/k8cCl7+oXyHU9
         1GzcBA+KXlIp5ARMIk+kJTHnSKuB3Mk8XkDjbb2Fa71S4SeR8PmYBXtyAvTn+m/VkPy0
         FzW6Bk6PKgioYfE3lCwNRQmo0elmjrInvBlT/OCreKXw3Bd8v7tj64+nfBH0arHBrrsb
         32JQ==
X-Gm-Message-State: AOAM530jWCV1aJteZ19wQmEYuA9TfM9DQOzEvoIApZZwpLrtJksPipTz
        QHBrIJ6gxK7UrdIcLj1uNFORSKpMpH0=
X-Google-Smtp-Source: ABdhPJxGh12bN6o07XiN4mUWtbFZmVLtFS4CDO4k5BqU/Dyt98w3VIHrQoPtmKX7widI41euE67gsQ==
X-Received: by 2002:a05:6402:382:: with SMTP id o2mr5446537edv.370.1619540665068;
        Tue, 27 Apr 2021 09:24:25 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id d15sm2740284edu.86.2021.04.27.09.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 09:24:24 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/7] kernel-shark: Add "cron" job to workflows
Date:   Tue, 27 Apr 2021 19:24:03 +0300
Message-Id: <20210427162408.134001-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210427162408.134001-1-y.karadz@gmail.com>
References: <20210427162408.134001-1-y.karadz@gmail.com>
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

