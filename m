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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEA7C433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE4D020700
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbhADRt3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbhADRt3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:29 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF093C06138B
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:14 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ce23so37889148ejb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2H4nudzpSsWEB0/dzAjsoV+CDB73TMcPs68ddOwHN34=;
        b=d7ZJPs9xTSWcRLuOY7ssFDaujmYXj7jFPdIo27dZKrG9Pp3JHxgk/9tbxm9ryUkHep
         MVKxc/0IU5t8S5oa3ZN67EaC//VSbWswLXafVcGWm3T9REb+DdJPT5gHDaLTIF65RaO2
         FtcbuM0unuGXuKu6ENPxJfBekHzPykKILGDxQvtfSrN02IkfyTXTwvNQdO3xVAIeNZIw
         HpU7gAOBBm2EyFsFV/uVSYz5vLu2ItY1d8GrKykxpiGtDsg++Q00SjqnUioknRei7ooU
         OLvFb77w+jqcb0a7puyAUc5uFidHusWeeQreFutXq+8bFCmb5IX6XYnxQmlYsdP6JX3Y
         oIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2H4nudzpSsWEB0/dzAjsoV+CDB73TMcPs68ddOwHN34=;
        b=Ry1u3OafK1dmVkQTc31BKfpxRSxkA/a86DQvD8ptMqlN9EHXXqBIBNLeph3+VYmpeF
         RoWnKFsfuPRQDmtmceLwISn5XZZxqtpsWcGsVh2RY/fCCQVRg355tZx0mJqdbJJMs9jq
         BZ10yM+pKuQ3J/j87x0m4sjaaLGi01/o8EIe7UZIkK1YbAH8xA0YttPX8WK64fjjDZmn
         5cA/QiGy/3XsBWiZ339yYAO9p+Osjl6EqflM3e7HSQkA56ZVAK3DjvrhRafkNaY0igyF
         Y4DjsmemLWHn1eOcx2IXXOf919BfwLUo1zhdgB8nPRd8VYmVJj5GFdodr+UUPrfSkVYU
         Oj5A==
X-Gm-Message-State: AOAM531a28rDeHh86btCvZERLf0RRQRykE1aOyGW5wlFHuuJI62Q9V20
        1Jhc/Pgmn6H8EVO5ccKzG8o=
X-Google-Smtp-Source: ABdhPJyYrnDZ9nzdLdnfsVKT7yEH3pduUsEDjo6Amjiq+yJkccRaLVWHAKskV9NIHZ0GQbrHiqLQ9w==
X-Received: by 2002:a17:906:74d9:: with SMTP id z25mr67044053ejl.217.1609782493568;
        Mon, 04 Jan 2021 09:48:13 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:13 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 36/44] kernel-shark: Add getStreamColorTable()
Date:   Mon,  4 Jan 2021 19:47:16 +0200
Message-Id: <20210104174724.70404-37-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This method provides a hash table that maps the stream Ids to
rainbow-like colors.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 50 +++++++++++++++++++++++++++++++++++++++++++++
 src/KsPlotTools.hpp |  4 ++++
 2 files changed, 54 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 113a6c0..400a3e2 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -97,6 +97,23 @@ void Color::setRainbowColor(int n)
 	set(r, g, b);
 }
 
+/** Alpha blending with white background. */
+void Color::blend(float alpha)
+{
+	if (alpha < 0 || alpha > 1.)
+		return;
+
+	auto lamBld = [alpha](int val) {
+		return  val * alpha + (1 - alpha) * 255;
+	};
+
+	int r = lamBld(this->r());
+	int g = lamBld(this->g());
+	int b = lamBld(this->b());
+
+	set(r, g, b);
+}
+
 /**
  * @brief Create a Hash table of Rainbow colors. The sorted Pid values are
  *	  mapped to the palette of Rainbow colors.
@@ -182,6 +199,39 @@ ColorTable getCPUColorTable()
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
index 6e66373..dd6c77f 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -47,6 +47,8 @@ public:
 
 	void setRainbowColor(int n);
 
+	void blend(float alpha);
+
 	/**
 	 * @brief Get the C struct defining the RGB color.
 	 */
@@ -78,6 +80,8 @@ ColorTable getTaskColorTable();
 
 ColorTable getCPUColorTable();
 
+ColorTable getStreamColorTable();
+
 Color getColor(ColorTable *colors, int pid);
 
 /** Represents an abstract graphical element. */
-- 
2.25.1

