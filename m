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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A217AC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7785F23AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbgLINqu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732187AbgLINqu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:46:50 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B78C06179C
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:09 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id m5so1802262wrx.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VTYOJ2N06ljUooZi9c2lkn1MDu5EVXVAuiQc5VtZhH8=;
        b=UtcM3AtQpjg9PgbWwCtCspdk5ul2jeKRrGCoXBF1W86DiHMiqGW5i1Hl/45T+VUYlj
         QXwcgxq6nebHpVnn1FkQb2m20hzzJTvkfhbr+PRt58MGnNjEhPK+p9K8YODDW3IxLH2z
         FSaXQ7KrexlHsRB1iKMvqiU1cQu1b3VoyOVrUkCy+NxKi8bawn0tokURa8nej5NPvkxU
         5Zg9eu4/qh1Z8/IlKjHE6vB3S50waXAAgEUccs0SvEUqDa+Bmeq/nkUtmY8V0m3A/phH
         uZyZt+FHNLxjLS35sPMLQNZZtptlaX5KPree/rNCzuqVziW7JNUO2m50VpIYzakEXq9v
         ra1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VTYOJ2N06ljUooZi9c2lkn1MDu5EVXVAuiQc5VtZhH8=;
        b=YUCnZBmILFeOqQVPSozpADAq0KwH8UfrfLCBJ0ZYwXt1BOBhArCQN9ajeOqyI9fShR
         Ayh2NakstrETRvZPF1vHFVrIvuzmIhoSk3Z6yOuA2pxXZTM8F8pc+dFe7aPn9yUJMFrb
         X8o4v74CXyEg8KuDJX7o12Neth8XnAa04wNmcwrXaEFMM597M/mgeEMTABX/m6kTUyoz
         PCMzb9vcbNa+sof+CPZViFtrl1NIHQYWVvhQ0hH69HEsBTW0mKG2pdej/NLwVkbSlpq4
         qPzKbyqlRk9qtbBVheZ/0XBjm9uRjkYfZUcTHP4lug+HtnDy65LyFXl4DlRcy1P6sIRL
         tBaw==
X-Gm-Message-State: AOAM531Fily7tc4ua6asPa7mg7pleCk/lbB/x6JM4RJLJJq+dYJd+LlZ
        czABqSrSRlz9ZKVO3KcDD9QR5ytL/+Q=
X-Google-Smtp-Source: ABdhPJw+hyPDwmIVL9mqhjnJ8gOeEHJzmOZXJuqTBF2mxzWvLL5gEnlhFJKGQn6nKON1mN4mQTqaeQ==
X-Received: by 2002:a05:6000:112:: with SMTP id o18mr2781288wrx.7.1607521568511;
        Wed, 09 Dec 2020 05:46:08 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 03/10] kernel-shark: Redefine the args of KsPlot::getColor()
Date:   Wed,  9 Dec 2020 15:45:23 +0200
Message-Id: <20201209134530.428368-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
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
index 7a0450b..52c3cbb 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -216,17 +216,17 @@ ColorTable getStreamColorTable()
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
index ab28f43..dbb15bf 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -80,7 +80,7 @@ ColorTable getCPUColorTable();
 
 ColorTable getStreamColorTable();
 
-Color getColor(ColorTable *colors, int pid);
+Color getColor(const ColorTable *colors, int id);
 
 /** Represents an abstract graphical element. */
 class PlotObject {
-- 
2.25.1

