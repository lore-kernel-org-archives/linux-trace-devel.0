Return-Path: <SRS0=2N9E=BG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C2BC433EA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E00720672
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TVsdpRxV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgG0HSa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 03:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0HS3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 03:18:29 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B54C0619D2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:29 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 184so13649801wmb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xX9tbAaXa30JAoxFlbW3MjjRPYPFtUW0nlkm78CuPKI=;
        b=TVsdpRxVRVfo7xvb2lqUlPL31TwIDfm1VxSaKJMcYp0jGB2pgCP5iYa6Qs/UnEsoD8
         ynIL8Pl/D2kggNxYUiH1OAIl6a9OSSxXhvGzoTNUqUMfQ9C5tai/9vi2C/un7Nui8h8M
         hOzhGO/9aC4LdewRCiXXDcbzwyKySVP3vw3PZFHB+wnW2JAEkbek/EpxkW6fpHrkfXio
         WCo9YFbXO1POUx76bEwhFA9iXO/xL32UySdCSr6jVT/lB3pkWCXKFQIt6upUFfw8/6wV
         xdG3dDaXdbvHXrcfCla+hRsVzPoCLFWvF03Ca83gCZQzI+dxAXLAhxxg9SZNdgGR3zoQ
         Cg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xX9tbAaXa30JAoxFlbW3MjjRPYPFtUW0nlkm78CuPKI=;
        b=BRdDk3XueKtwoHyb1ll5B3jAV60ptMVWmL0H3660f72RMsQiQE3uXqXiMyCD935+I8
         w+YLno+0vd2QtDcTHHVjDnE1jEApKqXvVV/21LzVRhaIhdt5jNBGx0d/TrGG9FN+6KRT
         4ToA2ucMR/f9vjdBjBqeRYs5P/5DYw4qzYPXnTOhj+gVHvEyyNjUSUo0Qc1yePMLY2fi
         kzS/skjTJJ12wdyKKZz/O5bP4uBVKmBzON0Juv/WmLbJUf6g/39TBcQsRHFqagel5dI4
         4PbDpfuBO64pcBvBPics4GnlXcVM1wUuL/2/vfjlcPfPcHvrk0X7BS3dJ36omHdlr3nS
         RQ6A==
X-Gm-Message-State: AOAM531MjmL6sJt2e5ET+Se+RHhsZrI+B1a+5fa9ggfsVZGR95arq8MQ
        Z8KISShPdKR4BertvOe4oXk=
X-Google-Smtp-Source: ABdhPJx2OkiHr71ng4x0R22O0Z5k3DJJ0DI7jM/QQC1Eb6MShU4c/Tmh44jn/BN6cliITuFr3so/sA==
X-Received: by 2002:a1c:5646:: with SMTP id k67mr20020883wmb.61.1595834308430;
        Mon, 27 Jul 2020 00:18:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j24sm12312162wrb.49.2020.07.27.00.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 00:18:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/5] KernelShark: Fix compilation issues on  Fedora 32
Date:   Mon, 27 Jul 2020 10:18:20 +0300
Message-Id: <20200727071823.169962-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727071823.169962-1-tz.stoyanov@gmail.com>
References: <20200727071823.169962-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

Included <string.h> to fix this compilation error:
   "error: ‘string’ in namespace ‘std’ does not name a type"
Converted fontHeight and stringWidth to inline to fix these
compilation errors:
   "multiple definition of `fontHeight';"
   "multiple definition of `stringWidth';"

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/KsPlotTools.cpp | 1 +
 src/KsPlotTools.hpp | 1 +
 src/KsUtils.hpp     | 4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 17db451..7dcd4f2 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -12,6 +12,7 @@
 // C
 #include <math.h>
 #include <cstring>
+#include <string>
 
 // C++
 #include <algorithm>
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 75fb4da..c66fea3 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -14,6 +14,7 @@
 
 // C
 #include <math.h>
+#include <string>
 
 // C++
 #include <limits>
diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
index cfb45f4..5857099 100644
--- a/src/KsUtils.hpp
+++ b/src/KsUtils.hpp
@@ -36,7 +36,7 @@
 
 //! @cond Doxygen_Suppress
 
-auto fontHeight = []()
+inline auto fontHeight = []()
 {
 	QFont font;
 	QFontMetrics fm(font);
@@ -44,7 +44,7 @@ auto fontHeight = []()
 	return fm.height();
 };
 
-auto stringWidth = [](QString s)
+inline auto stringWidth = [](QString s)
 {
 	QFont font;
 	QFontMetrics fm(font);
-- 
2.26.2

