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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CECC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D919A613C3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbhD0Q1D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbhD0Q0B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:26:01 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A507C06135E
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:29 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r9so90373049ejj.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wDoYhbKqi7r7+XeFLpvtcL7WyvNxB0XsH3vwGXpVVCs=;
        b=YbsW5t/bi/Gef3GqyZsqqbTRSQIM0hZNsTBqIl/V8MntC8XyaHu8g6pzNe7SNlZfSm
         pjsKeYFQD0yqmkc3REF98MLWMyYTQF0YXx9MrejUbmviRjK4fmjFdFXQXPjiivIr0Nuh
         elETqkinhJKpVm22e4Jv2t1/2XHYy8xnZnAhEu1FAQmug68uDZ6RkCMOoVCh0gS8uC9t
         narcbLqdvQtoYkS4P+cR9CPWsKhRKoU04Ui0HDu4LAUoqGhS5EJsnI3vBYTF3fYX4wJU
         SARH+5r89VjHbdTOj96r9fc8RE2hsaCRDBGBP8VT5O7wD7+7wJpEHqmjYy1I7Jog81Vl
         nhsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wDoYhbKqi7r7+XeFLpvtcL7WyvNxB0XsH3vwGXpVVCs=;
        b=kYyH5Z6mFPctYnMVkhptrZyk8m7YTJj1TC9mtn0H0dmlvUnkpydax9pDdJH8zBJfw3
         nWwiGnNnYIQ0EUHcbKxJyneV/SSvNo+RMxIXBl6OVo2hVUlZ7qQqd08a9FiJ0Q3tj9f1
         xGwv+k3AlwqKM3jyeqlZ9nftoCbIw32kOY0fx3zhh7Xboizuus/x8FQWrgB4yboPSAcS
         c2Q/HXyvtGk/nciTGvXvf0cleQF5VpWTzrVg6cHGaaSC5LCENweWTadbIkELgHo7tbzl
         DFRyQ/kY4LEpwcNPfMPisMz3YXQggE+pxcuhe4yW/RvI+iN0br7vbj/2guVCXFNxJhsN
         dFUw==
X-Gm-Message-State: AOAM533sUAwTezAhX/7/kRhYg7o7AkkQtDx6tj/GRC2DvB33IQ03CpuB
        RRrgOuiaKyjSiiK/YBtiG0SxSUssQM8=
X-Google-Smtp-Source: ABdhPJyGWglWpxmOwUPLcB1vy6/fq8KYppAX1RAG4pvqsrDM1BZlZCtjfDdIAuKt/AHTWqZ1ijR9JQ==
X-Received: by 2002:a17:906:5952:: with SMTP id g18mr4988507ejr.313.1619540668121;
        Tue, 27 Apr 2021 09:24:28 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id d15sm2740284edu.86.2021.04.27.09.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 09:24:27 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/7] kernel-shark: Disable the pop-up offset dialog
Date:   Tue, 27 Apr 2021 19:24:07 +0300
Message-Id: <20210427162408.134001-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210427162408.134001-1-y.karadz@gmail.com>
References: <20210427162408.134001-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The pop-up dialog that asks for the time offset, when a trace data
file is appended, is a legacy from the time when we have been doing
the calculation of the offset by hand. It still can be useful in some
specific cases, but the user can do the same from the "Tools" menu.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsMainWindow.cpp | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index e830c5e..d0a434a 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -1248,7 +1248,7 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 	QString pbLabel("Loading    ");
 	bool loadDone = false;
 	struct stat st;
-	double shift;
+	double shift(.0);
 	int ret, sd;
 
 	ret = stat(fileName.toStdString().c_str(), &st);
@@ -1264,15 +1264,6 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 
 	qInfo() << "Loading " << fileName;
 
-	if (append) {
-		bool ok;
-		shift = KsTimeOffsetDialog::getValueNanoSec(fileName, &ok);
-		if (ok)
-			shift *= 1000.;
-		else
-			shift = 0.;
-	}
-
 	if (fileName.size() < 40) {
 		pbLabel += fileName;
 	} else {
-- 
2.27.0

