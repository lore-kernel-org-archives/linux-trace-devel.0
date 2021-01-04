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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38728C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 124E920700
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhADRt3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbhADRt3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:29 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895D7C06138C
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:15 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id n26so37886136eju.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Br8DNfdS6ZBCWS5r5dxkv3R/dbDG0DQTli280a8a4U=;
        b=sGj69qu6RrWIF5/+bcTZqJq4wvn8qPGBB0v6nCZ2lyxFKYtTwT2IBGumg38mF727NK
         bCyQT5jhvCxQXZ6k0U/bDUqXLDaBt1UxGgoavJ1Rf6sBc+LlaxtjnSYjtueEJZBvm44k
         ewA0ft3BWp/ae0lgDX2GdBR8saRGhNG1JFoKO/1O+3lwCakDm4vTvVezlRL53flX4pdW
         wblAjaiWlu992Jq4LkSHCEsK5qArGxq7zH3S9vDXPHHoaoyUYkWYN/eSiGj75eKuJN6p
         YBeuFCyt0qArMqFzbKWyat3YsNvvtcP93oAbqW+yQt7JdeQFQ0TrCM+Eq+MXmGC1wGYh
         OHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Br8DNfdS6ZBCWS5r5dxkv3R/dbDG0DQTli280a8a4U=;
        b=eZsFdML+2qyFtPdQ3qXYU47/uTqKJVDU0emre51s277vToDDX3euc+DY+MUW0kN5Xz
         6VnZfz+SlbK71xwIwwYWh39CM5XcPr2bQTnF3S/3MmF3ZvQrlPemlSJy/6VZiwxdGg2q
         oD6lLRiGCTjRFj/bp/mhyxVq/g8z8YuOpy+GymYLeUzOurtPAT4epw149o8GryJ+xamT
         Kfz5NOebuLobX+LcHIu+jR03YZtpXrltcqThLtKcCMVjh7r8oPwL0dycQ3cm4mPrVjk9
         K6wp2d3VpPw+vAyN/tlghtJbmwgMnO+/qkE/r+3pLZQfydH34gqug0FG4cqipiSdfLjC
         ErOQ==
X-Gm-Message-State: AOAM533lJzIHPDxib7q8NSzXwAs6/g4auvkzXHqLd4Ug28r4/tEZcPpi
        BNG/6xJg46p4JrYRwWh5Yg8=
X-Google-Smtp-Source: ABdhPJzL7gTfCBaX7vXkWgtzWCn5Hp2JwENkLkSw5iWd58lKuzDSaDilUA08WKn/lm2SKslBGk0jBg==
X-Received: by 2002:a17:906:8594:: with SMTP id v20mr66921062ejx.470.1609782494368;
        Mon, 04 Jan 2021 09:48:14 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:13 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 37/44] kernel-shark: Redefine the args of KsPlot::getColor()
Date:   Mon,  4 Jan 2021 19:47:17 +0200
Message-Id: <20210104174724.70404-38-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The function was originally designed to return the color that
correspond to a given PID. However we now have 3 different color
maps (for PID, CPU Id and Stream Id) and the same method can be
used with each of the 3 maps. We also want to prevent the method
from modifying the map itself.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 10 +++++-----
 src/KsPlotTools.hpp |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 400a3e2..6c3902a 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -233,17 +233,17 @@ ColorTable getStreamColorTable()
 }
 
 /**
- * @brief Search the Hash table of Rainbow colors for a particular key (pid).
+ * @brief Search the Hash table of Rainbow colors for a particular key (Id).
  *
  * @param colors: Input location for the ColorTable instance.
- * @param pid: the Process Id to search for.
+ * @param id: The Id to search for.
  *
- * @returns The Rainbow color of the key "pid". If "pid" does not exist, the
+ * @returns The Rainbow color of the key "id". If "id" does not exist, the
  *	    returned color is Black.
  */
-Color getColor(ColorTable *colors, int pid)
+Color getColor(const ColorTable *colors, int id)
 {
-	auto item = colors->find(pid);
+	auto item = colors->find(id);
 
 	if (item != colors->end())
 		return item->second;
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index dd6c77f..7ffabd8 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -82,7 +82,7 @@ ColorTable getCPUColorTable();
 
 ColorTable getStreamColorTable();
 
-Color getColor(ColorTable *colors, int pid);
+Color getColor(const ColorTable *colors, int id);
 
 /** Represents an abstract graphical element. */
 class PlotObject {
-- 
2.25.1

