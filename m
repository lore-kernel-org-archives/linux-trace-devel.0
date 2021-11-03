Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B171C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2508661076
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhKCPrA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhKCPq7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:46:59 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E19C061208
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:22 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id a20-20020a1c7f14000000b003231d13ee3cso4958873wmd.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mk8UsDEs/9HhhdOD6MZP+6P70WQWCZJP4h3Hu/8AwAg=;
        b=PVKH7tgrVgcxJinDuzl25FZynSYJvglbODOcdJ2QeFAiNxIORSn4WHhgiV/5nqGZdV
         uWrZFB4TfRJzNeS6shgbOGon8Lr1LWOiVZTj78UxlBeSFJjDn96BhdbB3bGJFukTcYIo
         JEkJ8PI7h14aWs5LoLzwIWp0xG9Q6oIKiHwPSd6vlpwyZ+hIBdHqguDiS/YqUewRLJEi
         0fAEmBamI+d+UMfwRwfKXbe1Zu1mFQcbkbf63IENxTyYPQm8IZw53gt0VnrfG99vCMeE
         ge6yDJ+LGfgCZ/uaK1LQKbro57PHUVKJDsLmXBOyRUX3aQJg1dHUouxZBZXwxRkudbbE
         9ZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mk8UsDEs/9HhhdOD6MZP+6P70WQWCZJP4h3Hu/8AwAg=;
        b=I9aFDxNouGqiwhpXW/2sgpvNd2EGbmRiAMa9Q4GjykPN4mzTLVlj/eZBSXwckOUSiF
         EsLBn1gRuwcUFBaUJEd5A9W6Y5UMhiFYboNYRksCMrUfvt31dY2MEahSAdNcPwj2vb2A
         6yz1dpNsimxfNpscEUeLTPT4jhOQeXCwPS1HjtTi/121dKRAE1ofC4g1cTMc4MOmH6BP
         8Sxc2MWhoPpHOZM4qgV0PL9GzfNBftpy4MPS6fl3L2/RtClHc6JV2gaHyxuhTLD6zRmE
         l8oRvp5f76C4bjya9vGoo9OaUkcdnKG9ef2kA0lNjZU0qQY0+uE8j7KThrF8TZCiKaeJ
         YkUA==
X-Gm-Message-State: AOAM530Vuy3zZR1Mh9SnDJHPQFwlZnAzF1Wr0SCHt9/WK/MthYqzjqUz
        mm5ap451VuMcBDpRiRJAa1jZ7GGfg5DNFg==
X-Google-Smtp-Source: ABdhPJygdVKr7jTuIRXHs2KKcRUwcxyRgTbDV97ELOIZdcNeYcqqlkm0LVzakrMpsL9h5G9CdtlO9Q==
X-Received: by 2002:a1c:2781:: with SMTP id n123mr16335372wmn.132.1635954260861;
        Wed, 03 Nov 2021 08:44:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 01/11] libtracefs: Add new public macros for bits manipulations
Date:   Wed,  3 Nov 2021 17:44:07 +0200
Message-Id: <20211103154417.246999-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some of the tracefs library APIs may have bit mask parameters. To
simplify the usage of such APIs, generic bit manipulations macros are
added to the library API:
 TRACEFS_BIT_SET
 TRACEFS_BIT_TEST
 TRACEFS_BIT_CLEAR

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index a2cda30..fa7f316 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -10,6 +10,10 @@
 #include <sched.h>
 #include <event-parse.h>
 
+#define TRACEFS_BIT_SET(M, B)	do { (M) |= (1ULL << (B)); } while (0)
+#define TRACEFS_BIT_TEST(M, B)	((M) & (1ULL<<(B)))
+#define TRACEFS_BIT_CLEAR(M, B)	do { (M) &= ~(1ULL << (B)); } while (0)
+
 char *tracefs_get_tracing_file(const char *name);
 void tracefs_put_tracing_file(char *name);
 
-- 
2.31.1

