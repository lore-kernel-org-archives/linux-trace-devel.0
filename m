Return-Path: <SRS0=xW9H=SA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE419C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 14:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9485E206B6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Mar 2019 14:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbfC2OFS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 10:05:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43138 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbfC2OFS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 10:05:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id k17so2737051wrx.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Mar 2019 07:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IJMf6vVYCBuE+GFwcCeILDg2QeUhKnwcz3Onl0yfwc0=;
        b=gc50KTWDKuFRnm6wApB3S1sWPgPGxHxN6dz2QUMgjD+WVqyD9NJriSNQmEvx5ygcKv
         zXezD1SnJf+KITHlsroMaLjFX7Qv9ex6kp6D7/JO2lFO2uUMAa9/9BSZMXQxMIxEodcF
         TvFuyXAAlhU0b60HW+bLNZT9RTf2P7Jwg/HTKZ03LshOBO2KtRO5F9NSGFrtM0uOPIKq
         VcBXlc/dWGveugQiZCgnrojWxYGTUMhLGnZ6X/eI+w+RBnwmQmi1U1nmQJTB+ku3pzbi
         uC4E0HeSV/R1M8LTaWp7tlf6crZrp1enQEM3i0dR9+BfaWFtqcKbYYyBCwoa1CRxhUGX
         Eo9Q==
X-Gm-Message-State: APjAAAXLeCLm0MFW5NsP0gbNd8kB2eKJX7KrLtlXrhdZQjiFXhxAbajR
        x89z2yJW8cU+CvuVnrhwtrrPQfAF
X-Google-Smtp-Source: APXvYqyMp6+JD2pGYEpFTPyq873i2Sn2mSEByDXITKUblPZ8AsYYfi7xIOtf1j/v1kAbae39mbC2LA==
X-Received: by 2002:adf:ed8f:: with SMTP id c15mr31956188wro.144.1553868316631;
        Fri, 29 Mar 2019 07:05:16 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t81sm4201352wmb.5.2019.03.29.07.05.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Mar 2019 07:05:15 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark: install the application in "System" category
Date:   Fri, 29 Mar 2019 16:05:13 +0200
Message-Id: <20190329140514.1373-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Kernelshark is a system tool, thus should by classified as System application.
The template desktop file is modified to set Kernelshark in "System" category.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 kernel-shark/build/ks.desktop.cmake | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel-shark/build/ks.desktop.cmake b/kernel-shark/build/ks.desktop.cmake
index 0b947f1..f1951f0 100644
--- a/kernel-shark/build/ks.desktop.cmake
+++ b/kernel-shark/build/ks.desktop.cmake
@@ -6,4 +6,5 @@ GenericName=Kernel Shark
 Comment=
 Exec=/usr/local/bin/kernelshark
 Icon=@KS_DIR@/icons/ksharkicon.png
+Categories=System;
 Terminal=false
-- 
2.20.1

