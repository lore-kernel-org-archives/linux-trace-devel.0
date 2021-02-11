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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39907C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0593864E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhBKKiY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhBKKfo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:44 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDE1C0617AB
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:35 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v7so6371109eds.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=77/C7IL9bwjDIfN6W1HD95rM7DeBqtf9m1fmX4fHhKw=;
        b=kUn8BrAQ0do04hXIawa2VF4gl/Ft/XL6ycMD/Uy30P5FLZg8GVkt3aTSc9tTDCAFim
         4REymHDFhQKklc2s8Rr0oGf7kooxp/37R5COPZ42K5EKiP7qNfctyNPAgaOzGU8dyg54
         JEZehIdHlmm5gD3y/Gl+kNEh+1XgHcTFXkpDz+uX6QUvbLlGo/DgUDPaym2Y9M4v6SO2
         mne8JM6EBcQPvnQK+goGFBN2eo/11nobNcmvDjFq3XrsxmEcLMghOaZYDLTw/7JfINsC
         egqFwtPfAHjHI89TEMflqN6AguEIZoux1Rb6va7O2kiFc/Awt9nwRLfUg+xLr1pHHgNl
         dj4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=77/C7IL9bwjDIfN6W1HD95rM7DeBqtf9m1fmX4fHhKw=;
        b=A8oND7WL/UwBLXYCJ78TZ3lDmjXHbD9nT4Iwg+tJNSnjjqfsvUQmZ7HHZAeSHahZ5M
         DhE1uHvbfF9NBs2yIJsLvOyGhzG6KoEULUCmyLrmHzEjXJErNhOD/Bsv5YNHxykrDeM7
         ysdInqf1EVdRpqcu6rN3z753YQYi0WxODPJlzLCxf2aWMOwJGxwPNXw1b8EKStS602/M
         S4E6hwEU0s5uP9J3pWyY/YwK6iC2cj48i++GZ2G9Tzo0ZrzWuqxj1fQDkM6oU7Kp42/t
         LV3QqrKDbzjWu39BKwIOb6AcAmxkVeIKt6PnjKH4qK5OcNIEhz2ApQ346Ltp8VVbqBxY
         Zztg==
X-Gm-Message-State: AOAM5336HYgIUTGo89er1yJz8WQ1HmvEMKDni6d6HfcqOHlQBU79N0pq
        Oqwyy/cZuzBNslkV9gDrFLo=
X-Google-Smtp-Source: ABdhPJyVoJZ+oY+U0rF/PSszKJnbHiMqeR108mRcYDoP5Qqq1MdQa/trRGwHxGvWTFkXn8PK66ybIQ==
X-Received: by 2002:a05:6402:1152:: with SMTP id g18mr7874839edw.18.1613039554193;
        Thu, 11 Feb 2021 02:32:34 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:33 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 13/27] kernel-shark: Add new methods to KsPlot::Mark
Date:   Thu, 11 Feb 2021 12:31:51 +0200
Message-Id: <20210211103205.418588-14-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new "get" methods are needed by the logic of the GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.hpp | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index a9a5ba8..1725926 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -395,12 +395,24 @@ public:
 
 	void setY(int yA, int yB);
 
+	/** Get the Y coordinate of the Mark's CPU point. */
+	int cpuY() const {return _cpu.y();}
+
 	void setCPUY(int yCPU);
 
+	/** Is the CPU point visible. */
+	bool cpuIsVisible() const {return _cpu._visible;}
+
 	void setCPUVisible(bool v);
 
+	/** Get the Y coordinate of the Mark's Task point. */
+	int taskY() const {return _task.y();}
+
 	void setTaskY(int yTask);
 
+	/** Is the Task point visible. */
+	bool taskIsVisible() const {return _task._visible;}
+
 	void setTaskVisible(bool v);
 
 	/** If True, the Mark will be plotted as a dashed line. */
-- 
2.25.1

