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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369B2C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2C6164E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhBKKjt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhBKKgT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:36:19 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A10C0611C2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:49 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id sa23so9314120ejb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BmQZYI+QNLd5YGfrxG4vJDZu8NObfohhVBHG+0tRPxk=;
        b=gixl6VHFPI/WIyRCvCtY3U1h9XMvhLXkUl3JnUGwsPDNCse61yC+ZxBU2cmnkXZuL6
         c2praCYHTWUwaJvFWER4Mvhgz1ahQJ7wPsHUbXSImvCndTYWQjxI9gAeqs7WVcngz6Rh
         tBlYsXa+lT0A2kfwn797OKpix7zS8muXNINjT6L+Z9Ig2Hf6XJYsoxv7HDAIPWwN0Ryh
         dxK8KOw1/ZXga46kwDgxxqAXqEVG101cpdfEN+cVmIlMm5n8Y/0c+mtNKmBl5O0/jYoA
         f9Oxx+jrM2zPZ8AWfjeBPEnllGNzF47QaRwTq0gu2CAxtr0/OeCwq0q7NlFsqHvh2QM7
         fSJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BmQZYI+QNLd5YGfrxG4vJDZu8NObfohhVBHG+0tRPxk=;
        b=HDQJ02ykNIUTeLHlH047E6qwz7ez5I3olHBTUp90evNAMfwIfNhYrSi+TNGE60rE6d
         zqF/AB+HUL3udPHY6o+/dCQNOr6guudKk11eKBKVX0OmHV5S16pSVxSx51B73syLWf4C
         znLLrq3kDaR/8GSAzEvopfSf9khuy3UEfMJkPsQbKK8EPkqBTgNjf499095z6iI0lZ2d
         Nee53nX/Rf6C3NpnlVFqfVanuICzGK2Ogs08fF0XrO+zJyGMNqRQMT9nRdQDqqSZBgUg
         dvMnkcTxP1ghItf7aEtXUbUNeN1xOVq84opzGmjVM4vobMSeANPq2vOqo6mVjGsYoSax
         KdBA==
X-Gm-Message-State: AOAM530mISSpCwkbVw8D9gUIXsz10HsfucWhzCVYRv+6hz7M6Gt+U74T
        ZodZIpWiCSmEj5RMO3apIPI=
X-Google-Smtp-Source: ABdhPJx1kVUg60claxiubtjJvxGyxLsHcxtDHFMBA3+khjLZdtXOR4aQOrD2JYKox+3e+L8boqJEQw==
X-Received: by 2002:a17:906:37c1:: with SMTP id o1mr7702217ejc.488.1613039568276;
        Thu, 11 Feb 2021 02:32:48 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:47 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 27/27] kernel-shark: Install libkshark-tepdata.h
Date:   Thu, 11 Feb 2021 12:32:05 +0200
Message-Id: <20210211103205.418588-28-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The header wull be installed as part of the "libkshark-devel" component.
It can be useful for applications dealing with data from trace-cmd. In
particular, the header is needed whene building trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 6a6eda1..1e86e9c 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -34,6 +34,7 @@ install(TARGETS kshark
 install(FILES "${KS_DIR}/src/libkshark.h"
               "${KS_DIR}/src/libkshark-model.h"
               "${KS_DIR}/src/libkshark-plugin.h"
+              "${KS_DIR}/src/libkshark-tepdata.h"
         DESTINATION ${KS_INCLUDS_DESTINATION}
             COMPONENT libkshark-devel)
 
-- 
2.25.1

