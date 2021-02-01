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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528D8C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E1E364E54
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhBARZs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhBARZl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:41 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE12C061797
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:24 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id l9so25648683ejx.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m4+jUQ3tJ43/c+ftesBve5vHRlWZboe+bBaAh67cMdM=;
        b=cKwHelqG2359lBEm3zwAF/Zj45BIprbqktXkbYGSFoluUQnX1zkFsmwXlUi1re/AyP
         VFHPavvSQuciAzOmh7pLoyfpoxaMZL+MkRO12zK5W8dUImU6xmwjmGlHF0gO23Qg6RId
         Ftsiv0QcjPjBphVcsft6RwB7K52l2WOlNg5F7SqOWKdX33726QYuSaKfcxYtzuGzd6fy
         bM8FPijzJ2WvkLKPkhq+hUUFtPGf0Le8pQGmr+/dAJIKO3pHGMTSMlI53MyFA5nxtc7m
         G/h5M8/tHClN4hIt+Mfa55pCQG9EHuYJ3MQ+YBOf2tDJNPbUoh+GQGNZr+k30p4aN1gC
         A49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m4+jUQ3tJ43/c+ftesBve5vHRlWZboe+bBaAh67cMdM=;
        b=BOTNj91OGPLldKWBmWP8wZJixDCAG8zs5O9O86GGRCTPz/q6k5tafdKsLNZoQ30MR2
         LVk/rYQsd5AXNGZeuaKXjO+CVZ6mhhiY4hRtmFa7JgI0/FzRp5LPjh0UpQulP6GyIppS
         WMSQ6lNEOzl22OIg6RAjeSY0Esl2lz8mryRepvG0cHDe2qkZtO+ljtLjbAGx01DBll6I
         +63D5vPbG5rRiK3+akMpuduWTOR1UDonQb4sIaG+rCmT093TG4WYtS58xOmZbYin0tmP
         HHaWfVIXCFH8AQCXSO4Kes2UjAJtn9UelscQyGBl8KOh8E59KiyE93mZY5dnpXhRPsPc
         nX/A==
X-Gm-Message-State: AOAM531+MeFbHHbCSTO6nZ7KKH6xv6YduNh/i3mMgR7Gryg5t1J/URZV
        a8H2DnK/m1lcBWY3C6PBfTtld7YTJNg=
X-Google-Smtp-Source: ABdhPJyxv6j9HO2GMnRApskRng+6liTgF4066m8LFo4WVThsS1hJ9vJ3Mkq3IiHh6QaDud9rhnoAjg==
X-Received: by 2002:a17:907:aa9:: with SMTP id bz9mr2897439ejc.528.1612200263760;
        Mon, 01 Feb 2021 09:24:23 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:23 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 12/24] kernel-shark: Add combo point to Mark
Date:   Mon,  1 Feb 2021 19:23:46 +0200
Message-Id: <20210201172358.175407-13-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KsPlot::Mark uses colored point to highlight the selected trace event
on CPU and Task plots. Here we add a combo point that will highlight
the selected event in Combo plots, like "Virtual Combo" for example.
Those Combo plots will be introduced at the level of the GUI code in
successive patches.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 23 ++++++++++++++++++++++-
 src/KsPlotTools.hpp | 15 ++++++++++++++-
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index ac9c5b2..225dc34 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -701,7 +701,7 @@ void Mark::_draw(const Color &col, float size) const
 void Mark::setDPR(int dpr)
 {
 	_size = 1.5 * dpr;
-	_task._size = _cpu._size = 1.5 + 4.0 * dpr;
+	_task._size = _cpu._size = _combo._size = 1.5 + 4.0 * dpr;
 }
 
 /**
@@ -715,6 +715,7 @@ void Mark::setX(int x)
 	_b.setX(x);
 	_cpu.setX(x);
 	_task.setX(x);
+	_combo.setX(x);
 }
 
 /**
@@ -769,6 +770,26 @@ void Mark::setTaskVisible(bool v)
 	_task._visible = v;
 }
 
+/**
+ * @brief Set the visiblity of the Mark's Combo point.
+ *
+ * @param v: If True, the Task point will be visible.
+ */
+void Mark::setComboVisible(bool v)
+{
+	_combo._visible = v;
+}
+
+/**
+ * @brief Set the Y coordinates (vertical) of the Mark's Combo points.
+ *
+ * @param yCombo: Y coordinate of the Mark's Task point.
+ */
+void Mark::setComboY(int yCombo)
+{
+	_combo.setY(yCombo);
+}
+
 /**
  * @brief Create a default Bin.
  */
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index c993181..a9a5ba8 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -406,6 +406,16 @@ public:
 	/** If True, the Mark will be plotted as a dashed line. */
 	void setDashed(bool d) {_dashed = d;}
 
+	/** Get the Y coordinate of the Mark's Combo point. */
+	int comboY() const {return _combo.y();}
+
+	void setComboY(int yCombo);
+
+	/** Is the Combo point visible. */
+	bool comboIsVisible() const {return _combo._visible;}
+
+	void setComboVisible(bool v);
+
 private:
 	void _draw(const Color &col, float size = 1.) const override;
 
@@ -421,7 +431,10 @@ private:
 	/** A point indicating the position of the Mark in a Task graph. */
 	Point _task;
 
-	/* If True, plot the Mark as a dashed line. */
+	/** A point indicating the position of the Mark in a Combo graph. */
+	Point _combo;
+
+	/** If True, plot the Mark as a dashed line. */
 	bool _dashed;
 };
 
-- 
2.25.1

