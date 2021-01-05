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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AEBC433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0EE922BEF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbhAEP41 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Jan 2021 10:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbhAEP41 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Jan 2021 10:56:27 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43F1C06179A
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Jan 2021 07:55:11 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g24so582812edw.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Jan 2021 07:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jteLhQXLksTHm2X5jDt5shRzW2X0JBe0d1/fcljCUhg=;
        b=L6VGahOGoZUvrDA5RSujzAtqyXcC46P4lJVjBp2FgTXD80K39b8PiombhJ5aSVwgC9
         N4z4fkJ60kFHj5V1K0OVgEg+Sj2NcKfgOAMh22HQlqt2RiW6gKXZgc7NlmzTetVfrij1
         wv6pArOdaUYzgzlmm+C0UQ6vPD/hLTGko7pp6E74IBmpgm3jiCjDjtXgnYRRb+CUF9Ta
         lIo/D/NwbZZ9WqYSGOyqUyGADGCsT6TL3Gl4nVZiru3x5rNxGTEIJHj2s8hOQnSTMxJ0
         BvSKGTFtCRbs9Yad+Svk0TpWerPg7CPbxBCtdC/u3GrhfeC2AhSMHng1QsBmKHg+xFfz
         JmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jteLhQXLksTHm2X5jDt5shRzW2X0JBe0d1/fcljCUhg=;
        b=dLahC5zSyDRTD1iPIZ7c+Od+g2bwLekDRCDizQcxPX85Q362R5Yi4eDQHOEkpU9rhQ
         hm1xoeKWlNaX0xF5Sozt785dcqhJTk5FQqsTt6xoXfk87DPEhRsqqYSco42zKWktQ8JY
         lLhoDoyM8hYwlNAdsU6fv/Md6ST7+thnN/UBSyF/afoEDc6oWcTrYUz3qgZQY7+W9Tkh
         M+gd+D5WyC+WQ7ibhP90BnCrfT/8yJyNSNXcfwtWg+YxlRuGoy/1wTGOfdqFVAXKEJvN
         /W/cbw7FvDPWbexoo7nOZ+Ftm24FTtzaMJbnJOEQ0imxwKaso39foGYCBNA57ShA1kLx
         76Fw==
X-Gm-Message-State: AOAM533FHAxHgTTRbK+jhk/BAXSydevbLQWW1h96BicLwtaF4CaPSf34
        kecbINDff16PMpg2zd6UIcM=
X-Google-Smtp-Source: ABdhPJx288m5Y7ZOJzyVHVbPw7aVTj/24kABaBrO+T+Vz6YMZB6Hy1bpDPy4ODGXEo+FwqiAoJtifA==
X-Received: by 2002:a50:bf4a:: with SMTP id g10mr346694edk.201.1609862110616;
        Tue, 05 Jan 2021 07:55:10 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id t12sm45367882edy.49.2021.01.05.07.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:55:10 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/5] kernel-shark: Fix "github Actions" workflow
Date:   Tue,  5 Jan 2021 17:54:53 +0200
Message-Id: <20210105155453.41228-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105155453.41228-1-y.karadz@gmail.com>
References: <20210105155453.41228-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix the part of the script that installs the third party libraries.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .github/workflows/main.yml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
index e818f46..a35f003 100644
--- a/.github/workflows/main.yml
+++ b/.github/workflows/main.yml
@@ -16,6 +16,7 @@ jobs:
     - name: Install Dependencies
       shell: bash
       run: |
+        sudo apt-get update
         sudo apt-get install build-essential git cmake libjson-c-dev -y
         sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
         sudo apt-get install qtbase5-dev libboost-all-dev -y
@@ -32,6 +33,7 @@ jobs:
         git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
         cd trace-cmd
         make
+        sudo make install
         sudo make install_libs
     - name: Create Build Environment
       # Some projects don't allow in-source building, so create a separate build directory
-- 
2.25.1

