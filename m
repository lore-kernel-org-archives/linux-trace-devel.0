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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4A6C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6207E23AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732533AbgLINqt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732187AbgLINqt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:46:49 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4B5C061794
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:08 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id i9so1811062wrc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6hg2TZ1H2k+X+18hsbeOQVbdKwhyM7lx1St9l3Gf114=;
        b=E+sRfAQzOU8YBfgyoruk4aNJ9MSjBrhNuJh8UaVvWSjegFKrUTAZJ9tiLPf2B2GUuG
         qrr2YmPj8y/g6on+as6Xi6Ihf7euD1xx4R+dr6b/tNmsgo0+KgRQSpObedRQRvW9JHsE
         csvNjM79UXGd8BELHwhjxrH5lJg3xvvjKUETr0NUWNOLh2mpdHrXBf2Sg1Jv9N845yvY
         cJsV+euAGohAv74gF77B1oA2xOSDBlaWGZkX1FVeiXq9vvs72GZolmigV54vYpK+w7Gn
         9+9bneTNdr+EdK2hoFF7LSbLu9KFI3S8yjCdhb8z1kAn04Xp42IFP3V6KM5ovT/Xp8FV
         Te1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6hg2TZ1H2k+X+18hsbeOQVbdKwhyM7lx1St9l3Gf114=;
        b=NsVimbAe+VZTIOhZi4vbmnp8zqfYqBiznhg64JQVpuJGAtAzThg8F+a6EWYVMr1rRj
         kgNwJmzcVveDT6u4uS/vQKGExBFiHwyiCj9mBBbTl5zmsP7MFL2PWkXf33nKqFm/ql0V
         Kba0jHGwBpVN46Qjb4/T9lkVTs/NvqVPwqevf3GcxB0YMwkAu3uKO6u+dueGHtkZRTtI
         zz0eG8AXKZynyrMaRNud4EAIDiy6Qa2hnug0KbPTzAnEZcvvULYapbMMi8LT5OMnNug4
         kgu8xutjLOc4UigFntZlIdQ66AiMDKyN7xwkjD0imWUkq59CDM8ZAZpfo8SI+VJpECpg
         JP7g==
X-Gm-Message-State: AOAM533IUwYDZTcgdZ4KWf5gZmuwJLEd+SbbMWJnbYDCdY6DAcwWAaEF
        qeKRrO2C0JO/7qBGSTPL0+U=
X-Google-Smtp-Source: ABdhPJx/4N16fGggkSFcitcprAiCYM05igsZRAAdjISpmAgR0mHW54M3Mwd8o2/to+r2/BbGpUgzQw==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr2860690wrt.246.1607521567411;
        Wed, 09 Dec 2020 05:46:07 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:06 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 02/10] kernel-shark: Add getStreamColorTable()
Date:   Wed,  9 Dec 2020 15:45:22 +0200
Message-Id: <20201209134530.428368-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This method provides a hash table that maps the stream Ids to
rainbow-like colors.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 33 +++++++++++++++++++++++++++++++++
 src/KsPlotTools.hpp |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 113a6c0..7a0450b 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -182,6 +182,39 @@ ColorTable getCPUColorTable()
 	return colors;
 }
 
+/**
+ * @brief Create a Hash table of Rainbow colors. The Steam Ids are
+ *	  mapped to the palette of Rainbow colors.
+ *
+ * @returns ColorTable instance.
+ */
+ColorTable getStreamColorTable()
+{
+	kshark_context *kshark_ctx(nullptr);
+	ColorTable colors;
+	Color color;
+	float alpha(.35);
+	int *streamIds;
+
+	if (!kshark_instance(&kshark_ctx))
+		return colors;
+
+	streamIds = kshark_all_streams(kshark_ctx);
+	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
+		/*
+		 * Starting from index 6 provides better functioning of the
+		 * color scheme slider.
+		 */
+		color.setRainbowColor(i + 6);
+		color.blend(alpha);
+		colors[streamIds[i]] = color;
+	}
+
+	free(streamIds);
+
+	return colors;
+}
+
 /**
  * @brief Search the Hash table of Rainbow colors for a particular key (pid).
  *
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 6e66373..ab28f43 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -78,6 +78,8 @@ ColorTable getTaskColorTable();
 
 ColorTable getCPUColorTable();
 
+ColorTable getStreamColorTable();
+
 Color getColor(ColorTable *colors, int pid);
 
 /** Represents an abstract graphical element. */
-- 
2.25.1

