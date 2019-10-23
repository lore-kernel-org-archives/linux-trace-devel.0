Return-Path: <SRS0=f3YT=YQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C650BCA9EB6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 996D02086D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Oct 2019 12:21:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XSiN7Yg8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405263AbfJWMVo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 08:21:44 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40367 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfJWMVo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 08:21:44 -0400
Received: by mail-lf1-f67.google.com with SMTP id i15so8456302lfo.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Oct 2019 05:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7X2qsJ74vhvdXE1votE/9VV4vTFGcJWaoW5AMUPUXwk=;
        b=XSiN7Yg87dIR4QHKssvFvOfLkQ2TJ5MYmUO2HeZOGO010wAYAmjP9qkiFrwTuI1WeT
         LFkJdNHYy+7Xkvcekk0PLpfqmIaJBTabiKT9tAO/ir30fOandisT3Jl++QEEo8T2QVa7
         YlBHEPp6KhiG2qFoI/m+V3cosBGBn2KASxlpQWXgyLA4FNA0AW3fyQe6Nwbc2Vb3XL05
         KGVpFgDCpT7Jg/lWOUzUq7fPcLWw2YyANqcaS1Bo+PnGz07bqDSVyo3BDgUluDnrJdzE
         5kKMT5/wmRn2v1Uzmm+xkEMSQKb9yXf7SDy48PKocfThFDMeqgx9+dE/eoAMshjrMWII
         DnhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7X2qsJ74vhvdXE1votE/9VV4vTFGcJWaoW5AMUPUXwk=;
        b=cyiz8PC21O1wUvcBQBx+BGSdc0tPw/Oq2Pp9885fa5ijxwd2HCvIUqRDoBVZIPpP8N
         TNQMDwz0pMTjIVsm9pjnKlu60DXWV8nspyNtTpyeb87UiP9G6AgU2YDLVtS+/XthrSBq
         Cob2YZwmwOsrdr2oFCa8itaYeL+wji9jSch4POafrghx+G0JWxJM3Xxq2M4hrfH2I3Fl
         d1438OMAvpsM5KQOCDEwSXeuo22FqIrej0ea0Qfta+Lludd3zdioH8ASm6b8Tbf3YAQw
         lmTlDw0wLJozbO8UWR+H6/tc9HE391hQM/D9v1H62Kjg5Wb2nQZdsZ8gZXUgY1SwAYWD
         I2Rg==
X-Gm-Message-State: APjAAAVCuS+PEPdD3j2x88spHJAsZ0FHLZDPJJGf0olBK4jDJGgPvgRs
        Sk0W1EUJR/4Ev9BJyRSrOOg=
X-Google-Smtp-Source: APXvYqwd5T2YhENJfATGTvkqOzoJ4bK+dYRMPujBCRXeoSPFHXuICBJqb5YIur0fLKknyOdZ4EZAsQ==
X-Received: by 2002:a19:7d06:: with SMTP id y6mr7256299lfc.120.1571833300778;
        Wed, 23 Oct 2019 05:21:40 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g26sm10453566lje.80.2019.10.23.05.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 05:21:40 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH v2 1/3] kernel-shark: Fix simple typo in the "File" menu.
Date:   Wed, 23 Oct 2019 15:21:43 +0300
Message-Id: <20191023122145.14314-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Reported-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index a583f5f..3402764 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -45,7 +45,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _openAction("Open", this),
   _restoreSessionAction("Restore Last Session", this),
   _importSessionAction("Import Session", this),
-  _exportSessionAction("Export Sassion", this),
+  _exportSessionAction("Export Session", this),
   _quitAction("Quit", this),
   _importFilterAction("Import Filter", this),
   _exportFilterAction("Export Filter", this),
-- 
2.20.1

