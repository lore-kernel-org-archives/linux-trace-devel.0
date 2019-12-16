Return-Path: <SRS0=pI6O=2G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83422C43603
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 13:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52EB920409
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 13:40:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJkn6KQO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfLPNkX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 08:40:23 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43843 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbfLPNkX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 08:40:23 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so6813946ljm.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Dec 2019 05:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EFVHEgHLJAebz5EwAeXRoL3zEoGbQptcoZphnGaS0/Q=;
        b=GJkn6KQOPeT8S42qI8MHx/1jabscLqNYTrh7vcvB/QSn4cPe+2uftVqoY8S532Btfs
         EJry0frOSWnUMmb+ol9v0d7W0oAgAZPFE0DuQYXNTN7Nu7PLSoDJxyIITbziNA1Qyq3E
         18KZFn8jrFXS+3ZaOFVuTTapuiVyOQxt/2Vm5t7tWYPRcLgGlwqHmeedQ6iwcikqXUje
         NtowMF1j58BuVSRYxEiXDwKhlTVqhMB48nkdbbNYUu4rZJpBQk2qA0hVZE0+jQH02/Tj
         LawfKb7X03Rxl3ckARWRTl5UJggIv2oFyexpv9tKK9CwMH4ko8EBz0O3g8JbrwzLMWIe
         y+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EFVHEgHLJAebz5EwAeXRoL3zEoGbQptcoZphnGaS0/Q=;
        b=Z6iGVLGBaN00206v7ho+uZd9pzTPNtSNLeZ10fOHSUmPTofXfBMkPyk/KnM2TZGipo
         g5c3nKUGtb8b/v4dbdARY7sM6IUWWmqTNgM6C3U8ylvkS0pewrE6auHHXNr8VlJtAfut
         eDSNyfnn3JTVSaw/0qi3ToHM/EfF4SiakkAWSmzsztFiCJZUJBEEyxbkdkGP/0z+9iLA
         diCYc1rLkle4QErBYsVEIPMfqD4brkQNMHEAuQncVhigfQfqrddLYsanr/IWOZhWfws5
         SdQzue/bg1d17x9Xr1zRHD+vHwCNsTlBBvujBCprNTncHxYpjnPkCelehM4It378/xlq
         avqA==
X-Gm-Message-State: APjAAAU6gso1wDI+HAzjq4PkzBw9JKWv7u0GAR7llbY5WRONugjCF0Sa
        1QGmr60tTq8RM7Skukj+EvU=
X-Google-Smtp-Source: APXvYqyfrCOmjuGH9A3iyawuRfuedyamuMPb3mehPnQVfGNk8hlPqjlAQXTsVAMs5r1VkT/X+Xn3AA==
X-Received: by 2002:a2e:b5d5:: with SMTP id g21mr19608185ljn.89.1576503620809;
        Mon, 16 Dec 2019 05:40:20 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 204sm7506118lfj.47.2019.12.16.05.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 05:40:20 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark: Avoid redrawing the graphs when switching the keyboard focus
Date:   Mon, 16 Dec 2019 15:39:16 +0200
Message-Id: <20191216133917.31690-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191216133917.31690-1-y.karadz@gmail.com>
References: <20191216133917.31690-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Reimplementing the event handler of the focus event, in order to avoid
the update (redrawing) of the graphs every time when the OpenGL widget
grabs / releases the focus of the keyboard. This is done because we do
not need to redraw, while on the other hand on large data-sets, redrawing
can take a lot of time.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsGLWidget.hpp | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
index 3d428b1..c6fd787 100644
--- a/kernel-shark/src/KsGLWidget.hpp
+++ b/kernel-shark/src/KsGLWidget.hpp
@@ -64,6 +64,24 @@ public:
 
 	void loadColors();
 
+	/**
+	 * Reimplementing the event handler of the focus event, in order to
+	 * avoid the update (redrawing) of the graphs every time when the
+	 * widget grabs the focus of the keyboard. This is done because we do
+	 * not need to redraw, while on the other hand on large data-sets,
+	 * redrawing can take a lot of time.
+	 */
+	void focusInEvent(QFocusEvent* e) override {}
+
+	/**
+	 * Reimplementing the event handler of the focus event, in order to
+	 * avoid the update (redrawing) of the graphs every time when the
+	 * widget releases the focus of the keyboard. This is done because we
+	 * do not need to redraw, while on the other hand on large data-sets,
+	 * redrawing can take a lot of time.
+	 */
+	void focusOutEvent(QFocusEvent* e) override {}
+
 	/**
 	 * Provide the widget with a pointer to the Dual Marker state machine
 	 * object.
-- 
2.20.1

