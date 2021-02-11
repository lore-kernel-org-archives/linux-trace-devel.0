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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BD1C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9709964E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBKKhw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhBKKfo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:44 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D34C0617AA
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:34 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id q2so6424158edi.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m4+jUQ3tJ43/c+ftesBve5vHRlWZboe+bBaAh67cMdM=;
        b=nasoYyC47KNBNY9nWHPKvAQwq7iTmNKjDyDcf6HgeJa1mBXIxDCNFvg2OKpHMtSGdZ
         wGPdMCbxUI8By5WXU2z6GvGa6v5ypUUFyCiF7vH9lbRMvYBUMGblve9eRbRPYSELBeG6
         7gxpVVM6slRCjhmP+d0ejC5F/rrbvEZDtfF4/xJx+WBD3kgAZkMpOoyFJsNRaVT3+61W
         TOPlowCIH8esoiViOHmjS//Szosnoh4J5LpI80ssn9eH3fb2oTjQ+DxazCmFU1nAA56X
         AZFxN2ZS1+YlJ39Uj47Gb9GLGzO6pFhgiTWrqpGuUsph8MGrA7b7dc+oLjbWx2ISw5oU
         J3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m4+jUQ3tJ43/c+ftesBve5vHRlWZboe+bBaAh67cMdM=;
        b=cNpqDdvFbp/NKUiiuhmuvv4Ur+wQzC1RNpy8GTy26fxTMKlD1adxzlN7xAes/Y6f1O
         P5pyRXGs12x+FslHzu873Njp9vGB0Nd1lTNTldsQLqC6SamEkqSprcfANwnEINhWTQyt
         gTHv2M8HfSCXs0L+3jvkUb6u+ctH2FeguhddOUWJ9zoDg679u3yhfyPyhVbqxO2ZGlXc
         KIDExKEXbTMhuACFAyWeHbvwTeYI/9xx2yDItTLrJTRakme73TZs5QfIqQxT8XwQ8yJ/
         Pak67VQkhbOZ8rLaoHQ5Uoe/Di1FajmCdnCV/rbCwBowkeSlfWLv6R615n5pkgGcvHLI
         FFLg==
X-Gm-Message-State: AOAM530YOJ+LU2rkvqX/hLgRkZxUXQnKhOcYzxUuw33HNJUEPQYrcX6p
        6khGR8h0U0BkkPFtHSALwGA=
X-Google-Smtp-Source: ABdhPJzmTDa+JvKkV53NAw3Jlwkq/eXVy7bIq4PANIp+DxCqhAktGjkbZhWDOwa8i49ReNhBIA/byQ==
X-Received: by 2002:a50:8a90:: with SMTP id j16mr7624796edj.334.1613039553173;
        Thu, 11 Feb 2021 02:32:33 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:32 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 12/27] kernel-shark: Add combo point to Mark
Date:   Thu, 11 Feb 2021 12:31:50 +0200
Message-Id: <20210211103205.418588-13-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
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

