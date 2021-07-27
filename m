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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C2EC432BE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Jul 2021 13:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAF3B61A8F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Jul 2021 13:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhG0Nmm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 09:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236613AbhG0Nml (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 09:42:41 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8792BC061757
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Jul 2021 06:42:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n12so11724688wrr.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Jul 2021 06:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CRRHkPhe5BEv84eniIjXS0jK7LL0m+0Wg2X5uCNyUrE=;
        b=IQlS7yyJDLWS0A4n2Po9K69t8yFpTkEqtcczuV+/m+gmnQXwzC+DD/1pFa+EKocgQb
         pu436TPvlMoz06m9us/VrHWa2jKUEV9CauJ3HG0g9cc9QqfIh3zCwVJZn1lN6jF8FHj0
         +HjZ+dHwQcrM763U90FNvOTbVbmsJqqFZMBZsvJMCpHiMAjmOQnq6qW0NBAAD95m4A9y
         wsEVhN157kxI9Yibm7upLEQlm3SqkpMLUufVIyBkm3YSG6X672fEUNOjBYqHLC7O3UJk
         y8F28ve69gpxvtkY69GxrTaTs5i7ebsZIjW9QdyYFcWaAMiAzYp3gSAY1x3YfSD5E+G3
         RZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CRRHkPhe5BEv84eniIjXS0jK7LL0m+0Wg2X5uCNyUrE=;
        b=he5wjR6KnBV6zqWygoSdsmmceeJ7hfCOtfhZ3vFDpqC0dt8RM9oWrR07a0c3bKNZeA
         3RCYVjtxST1kFa+hP/K5v5BOm/9hzBzaOxR3TEp6+Gg+kmzUts8y80EaOxdGSIUG2YUi
         oLmgzGARKfXpDfUcxFRr2Q7lfBs6jvjwm/7IeBLW7i6Y4/MwS0UxCkZAYqDwYzsjIJOH
         W/QpWaSv0LRz2SUH/TOEyMYXqfsl2Ub6FHa3HsbJ6E76XqKGx0eZmFaK2Lgv2Y3JPZsj
         js6RVL01oY2Kve6yLINZf0GWvxYuqlITGBlExTM6OCzgNkYPK7LCyi2+eZakV56jItYj
         IF0A==
X-Gm-Message-State: AOAM533zVrKtNhMED17st7DmK0Yt7mS8tZyE6ek9Zo5yO0EQV5JmFkFU
        AGi0cafzDE0O1a5PxSOQay9RE3CJt9c=
X-Google-Smtp-Source: ABdhPJz1u4YSRcJcvV9wcrHpRwgjiCsmxF+lLuFO3biHbFqu9XtBvx9265XxzjDrQCuLALijLp+fmw==
X-Received: by 2002:a5d:64c8:: with SMTP id f8mr24867944wri.290.1627393358962;
        Tue, 27 Jul 2021 06:42:38 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id i7sm3500667wre.64.2021.07.27.06.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 06:42:38 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Do not include trace-cmd.h in KsAdvFilteringDialog.cpp
Date:   Tue, 27 Jul 2021 16:42:24 +0300
Message-Id: <20210727134225.25025-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This header is not needed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsAdvFilteringDialog.cpp | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index f01467d..20412a7 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -9,9 +9,6 @@
  *  @brief   GUI Dialog for Advanced filtering settings.
  */
 
-// trace-cmd
-#include <trace-cmd.h>
-
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-tepdata.h"
-- 
2.30.2

