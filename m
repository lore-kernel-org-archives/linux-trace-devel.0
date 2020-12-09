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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C25C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A14BF23AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732441AbgLINr2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732415AbgLINr2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:47:28 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB5FC061282
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:14 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id l9so1786656wrt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SyimfIUcyOxEzAGqudBgzM4qdeXWlI+NU+A9xhnpx+8=;
        b=SAjOzO6i6XyRVsjqjq9fkbvDdAONU2bPmlOmqIuNJ69vXJWysoRcJSMNPtvp3COjK1
         DI9c1SEYCaIbrinlVJQ+CYc4MTWglm0QdOMeUvzQZXgBaIdIPM26W5mDN/UjDkLvpP3w
         xClsoeZG6I8FCNclEy8cET5BVpH8Btc7UgFzY2a/KNU89c+Mru0d0JlbxXLLlaz/8M/L
         1o48+sv1oNgH9oC57W4JqTZK6U7J08FjfZqAw+NwZNoHl5D9Wet1HQfntyPEcHNOzDMe
         r4XSiqSR31AUsj4DT19HYoBatIqTMq2OwpCxyTaCmpS4MZnJNbSKNa7NObKdQNQJhuLe
         tl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SyimfIUcyOxEzAGqudBgzM4qdeXWlI+NU+A9xhnpx+8=;
        b=ehji4uiCHruyfxgm4hDznmW41S+138z54Y1dmyQDDOtTYz4yqJeX7FqRwmqQ7G2/PC
         B7sRUVZAaTuM3UuL6RhKUF3bpqAVu0A1h3kzX+2JzNL8iK5IlEnGBYDEuFuyAsl5GTO3
         XYD0Z2qU4I01G9pORH2IcaVG+dNSX1P3AkQcmDKc1ZaZ0JWkb/eSltKAZBdY912ZB2TB
         knZT4sdWdkerU/7y9ibB+r4zXTPVf/Jml4oz77qF/iPkW4i1zvfhWd1/hfmSEHNSPSUh
         VL0K4uYi6CulKWZ0KrqaEf5rz6FqkDE8yF5a0xZXvoAeUjLDfn5qMKak6ez8V/xLUSJV
         PmUQ==
X-Gm-Message-State: AOAM533xglJQndmF0HybSfRoOtkjLuL8p4W47NLwr73RBZqTKw4hE9L6
        DVT9COvUOukIqWVfiIatZOo=
X-Google-Smtp-Source: ABdhPJzHrzoyfxyUV9q2juTqfrh8C6o9MMs8U+3yvibpqyaR3+F7TucGMBsumELNWFLdMSdwSCIaBQ==
X-Received: by 2002:adf:f84b:: with SMTP id d11mr2822345wrq.216.1607521573329;
        Wed, 09 Dec 2020 05:46:13 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:12 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 08/10] kernel-shark: Add class Polyline to KsPlot namespace
Date:   Wed,  9 Dec 2020 15:45:28 +0200
Message-Id: <20201209134530.428368-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a simple plotting class that represents a poly-line.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 14 ++++++++++++++
 src/KsPlotTools.hpp | 16 ++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 529f737..9f98386 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -503,6 +503,20 @@ void Line::_draw(const Color &col, float size) const
 				 col.color_c_ptr(), size);
 }
 
+/**
+ * @brief Create a default polyline. All points are initialized at (0, 0).
+ *
+ * @param n: The number of points connected by the polyline.
+ */
+Polyline::Polyline(size_t n)
+: Shape(n)
+{}
+
+void Polyline::_draw(const Color &col, float size) const
+{
+	ksplot_draw_polyline(_points, _nPoints, col.color_c_ptr(), size);
+}
+
 /**
  * @brief Create a default polygon. All points are initialized at (0, 0).
  *
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 5ce8f6f..4a7ca0a 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -253,6 +253,22 @@ private:
 	void _draw(const Color &col, float size = 1.) const override;
 };
 
+/** This class represents a polyline. */
+class Polyline : public Shape {
+public:
+	Polyline(size_t n);
+
+	/**
+	 * @brief Destroy the polyline object. Keep this destructor virtual.
+	 */
+	virtual ~Polyline() {}
+
+private:
+	Polyline() = delete;
+
+	void _draw(const Color &, float size = 1.) const override;
+};
+
 /** This class represents a polygon. */
 class Polygon : public Shape {
 public:
-- 
2.25.1

