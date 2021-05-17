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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C76C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5CF601FC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbhEQPBL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238227AbhEQO6v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 10:58:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1066C08E899
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:54 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id di13so7144229edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pIzHPXqbiAaEKSLBqogK8Sd1h6M0//+4RUcFlBIV+uU=;
        b=AGxOd8E4piy5GpD1Mp2wz32ZgX+9edvoNCWQEOe6rLpOdHYBftWbWyriVxYPQdNm4D
         O6l4kVgn3o+110RMSuwCBN6ip5+cQ+2LazPU/C7jvOwRqfws/Nz3STM/TkX/0fi3yFeN
         qn74mKP843QiEJ16e7qE1EPkI/Q3Ch4KKDJ/Fna1y5/pjggetiuwb+PKArSDCPb744Lq
         Mxovl3oSwE0SCFIMRArx3hFv7OhcoyRQoNyPcuYG3fr/26QVQM0HIMzwB4LKPaLvSqlW
         oWoPjQEIc4YjoJG5ucX0OUW/4ko5xkutZ401ujCSRZBUcUW8Etlw5VlPUEUCOF3k2hPG
         dGbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pIzHPXqbiAaEKSLBqogK8Sd1h6M0//+4RUcFlBIV+uU=;
        b=LKBzbTdjUXGJYc+br50ZxDoPo2bdNfUDybzcv8OS+L1W9VAiXS2pK/1CtE5iz4QvR8
         Jhy0e+oQTGZDM85Y+Nu242UlEKIH+gz+6kSQsLafHlIK0cewV1+PxckJExTGFIn5xYjf
         f8mj3+xvrpJwiRpfeCumoqPiXv50KsrSFZjeGpGmyGFVSNDJxaC5bSdPyjX13Xkv7Cn5
         LkLv8YQ4+WTS2nZTCdlLDba1Uie3DcQUCXhwSj2pYHxfdNtFZ/PfMMW/IfICV+qDbt/y
         hdwrDyzmalkJozvtRW403M+LCU908vcYzOZc6Q0azxaqOQZNBB/bgIZHKIrQPw0mjurg
         xBDA==
X-Gm-Message-State: AOAM532kEQug1QN4cMzne9wnnMFeuXS63XLm8N6uZjgfWUYdZgoc2iTD
        +jlqvb/RGUZurgca7SO2QkcBwMSoGOY=
X-Google-Smtp-Source: ABdhPJyTcxu2xMV0TjEbiRJQhsRA6un1Qk4Q7SmyXL9Iiuwi95mVi/9gOwa6q1ap28k4gXdx2Yrd6w==
X-Received: by 2002:a05:6402:354b:: with SMTP id f11mr306665edd.139.1621261313232;
        Mon, 17 May 2021 07:21:53 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id t2sm8484849edd.58.2021.05.17.07.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:21:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/7] kernel-shark: Do draw the combo point of the mark
Date:   Mon, 17 May 2021 17:21:38 +0300
Message-Id: <20210517142140.286153-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210517142140.286153-1-y.karadz@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The lines of the code that initialize and plot the combo point
are missing in the original commit.

Fixing: fc14e40 (kernel-shark: Add combo point to Mark)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index abef5f8..1d63a9b 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -680,6 +680,8 @@ Mark::Mark()
 	_cpu._size = 5.5f;
 	_task._color = Color(0, 255, 0);
 	_task._size = 5.5f;
+	_combo._color = Color(100, 150, 255);
+	_combo._size = 5.5f;
 }
 
 void Mark::_draw(const Color &col, float size) const
@@ -691,6 +693,7 @@ void Mark::_draw(const Color &col, float size) const
 
 	_cpu.draw();
 	_task.draw();
+	_combo.draw();
 }
 
 /**
-- 
2.27.0

