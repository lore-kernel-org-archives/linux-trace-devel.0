Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24001C48BE5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Jun 2021 01:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE766128A
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Jun 2021 01:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhFLBsW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 21:48:22 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:33717 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhFLBsW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 21:48:22 -0400
Received: by mail-qv1-f73.google.com with SMTP id dr11-20020a05621408ebb029021e40008bd5so22724081qvb.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 18:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2d6F0jWxV3WmN3WXrDucXjgB6Iyj+9cQ0Z88+2tSQ6Q=;
        b=hxOe6SVsI3g88RGrgHYHEp2oVtSF3ZsJqYpdOyBqEOIygjpadVCcLxD72oLsrd5HLE
         SoRMDuSsHITuiR+IeMSjV6VTQ4pqaP/ee/ExPU/6MGilvukRE6s/DA1+wbDpi4GpygI8
         ElmseX8PkILAF7cQcV+1/+GH14avaTLnAUUg5b1y7LmSgsQNQJsyVHTR+OIr3GHWVMLx
         TCExyWlHLJyDuzkmv5N3fXb0jfsbr7zN/a2pYKYLH/ZlefRM4mfZWL5uoMPHSoNA4cn6
         k0LSfsN73QdrpNPDBG82aA1E8UZuZAdLZRs1m79YJGvqV9mgOhYI1VuyT3s92Lcg/Ngv
         Lj1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2d6F0jWxV3WmN3WXrDucXjgB6Iyj+9cQ0Z88+2tSQ6Q=;
        b=cNIfVsmBQMBTdAtAbEHVMtrwy9DK60v1pJR3cT2sfFbx9a9P8CDdV4rnb1wcPNxn6+
         59ETMlbT94rcgdIOLUKslP9CZPQavMqfpy0o70LWEmPEbYT6SV0ftZAAHU2barT1tXJV
         KVHL/GNP/eNVkBn2ed4d44R6CuL2C8vJNNFDpiYtHemxi64d7EjivrAdM5pP3NxAwa8F
         G1JcOnkIWoQgH1bDrcxT/gPW+D0DHw3PzenkbpukF3NQ0jAOwt/Jz0vV4Vo1q1CLT4y0
         l625uN59mRSb0SGYmmTG/YJ/t1IvtvoG7SGrRwAt/wAY/R+GCXoJ6lEg6R5UEoPDfOzT
         2Viw==
X-Gm-Message-State: AOAM5309bTH2o+5vo65PLkWw/yjyarnP0GYLzQGuMKJHezuDnE3dQn91
        cwHz1tEmorMhl5aUuQJegECF2ydVXbM0wHGMryWuVB4kModYxUAgX408YoK+W0g0hA7A0xYWGS8
        RCC0tll89wj2Fv6TKK4aCKD8YIN7dCCmE2b7XxB/+96hpyEb6kNyiCPiprF8hcRCbke9Xt6+sGK
        vBNOg=
X-Google-Smtp-Source: ABdhPJxftsIm+me+NnjjNbOkKR0FFz0V57xjRlkhS6actEKSZ8DE7VB6/cCUZhhIc3eqXlFjK2qK6Cb0mV6g
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:27c2:28ad:b3af:418a])
 (user=irogers job=sendgmr) by 2002:a05:6214:2a8a:: with SMTP id
 jr10mr7945292qvb.50.1623462309547; Fri, 11 Jun 2021 18:45:09 -0700 (PDT)
Date:   Fri, 11 Jun 2021 18:45:01 -0700
In-Reply-To: <20210612014501.890593-1-irogers@google.com>
Message-Id: <20210612014501.890593-3-irogers@google.com>
Mime-Version: 1.0
References: <20210612014501.890593-1-irogers@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 2/2] libtraceevent: Changed angled brackets to double quotes.
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Claire Jensen <cjense@google.com>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Claire Jensen <cjense@google.com>

Signed-off-by: Claire Jensen <cjense@google.com>
Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/event-utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-utils.h b/src/event-utils.h
index d377201..44f7968 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -10,7 +10,7 @@
 #include <stdarg.h>
 #include <stdbool.h>
 
-#include <event-parse.h>
+#include "event-parse.h"
 
 void tep_warning(const char *fmt, ...);
 void tep_info(const char *fmt, ...);
-- 
2.32.0.272.g935e593368-goog

