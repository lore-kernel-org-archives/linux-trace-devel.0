Return-Path: <SRS0=wCVW=VV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D81C76191
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1981206B8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 15:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfIAwUH9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387394AbfGXPlA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 11:41:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35219 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387404AbfGXPlA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 11:41:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id y4so47525279wrm.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2019 08:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCuB/9KaAkuuXZUrB8z4Rd/JrV0a/sptwy60/02rzEY=;
        b=NfIAwUH9lzpKLhvg0hE2xZ8deNQanDEcyOm4HhH80faTz+oQ/F1R6tXAs20cZjwWrU
         twExgS8w9dfKNnb6tvat92eedl3qcYk2moEMFCObSp+4WAu6wmRE3rU/ka8QfAgDQOmc
         JWqsrqlKpAsPOatLN+3U6dazGulZJFUM+1IBQ0+zJjHRlFepRmIT2/KQFQ3Fmzs+od7d
         FTEBI7kkkfRyObBTLcPiGGaEGFsCOQye4CmZaLsXdlOx0QxiEYi8R3ir/NbbLItB8j+I
         Fhnu2VgrkYZCBPH8VHA0xaM/nMRdKGBO/E52ywNeZTVaI2UNKzaTDPbzLChmlwRo7XE0
         lBig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCuB/9KaAkuuXZUrB8z4Rd/JrV0a/sptwy60/02rzEY=;
        b=pVds5LnKQBo/ZVrt1BEqNX8fr/O20UKBlkn6o+Wd/0dlJ0DxZ1Qip9BLY+o1PsbP8E
         9M4mPAOA/sVNmuPw5T79CoOtgcMJQRBe+QN1v3HVYlK+i1vr9l7WtyCPU2W4kiF9mu0n
         d9dT8s5TNEVVQm8alPWpOX9eSVY7mfrQuvKU5jaHiDr/PYb8IZHzmtrxZ7awTfEmnUx7
         GkJJAzW1k4VTQGe+4srjwTmJPV60YG9oZ6mCXY1DRhbN/g3H77IAy9rLjGz+jMBC3wJf
         wFhLgeBBAs2MRbp6jeO4jsQtuRsnzLC7p3h/LkwZ3CJcrrqHEvdQJtmuf2ZEWiLFidxE
         823g==
X-Gm-Message-State: APjAAAWcMAfIdpYXvcUf9/sHORnPtOsXx7vTEEbV+2ofJ2GctSEr+sTA
        GRZDRhcwo0Xow3BrD5gB5S6VV322
X-Google-Smtp-Source: APXvYqzuSXmWB2bWt1YUNiM5MvePFwaYfhYOGvycJ3Fofg9mML+YVL8C26W7iDxGjHqYqQErU3nkgw==
X-Received: by 2002:adf:f286:: with SMTP id k6mr13211596wro.320.1563982858462;
        Wed, 24 Jul 2019 08:40:58 -0700 (PDT)
Received: from localhost.localdomain ([95.87.223.238])
        by smtp.gmail.com with ESMTPSA id a64sm45510570wmf.1.2019.07.24.08.40.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 08:40:58 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] kernel-shark: Allow KsCaptureControl widget to print text to the console
Date:   Wed, 24 Jul 2019 18:40:37 +0300
Message-Id: <20190724154039.23705-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190724154039.23705-1-y.karadz@gmail.com>
References: <20190724154039.23705-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This will be used to show Warning messages.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 3 +++
 kernel-shark/src/KsCaptureDialog.hpp | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 888ffea..6e526ff 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -437,6 +437,9 @@ void KsCaptureMonitor::connectMe(QProcess *proc, KsCaptureControl *ctrl)
 
 	connect(ctrl,	&KsCaptureControl::argsReady,
 		this,	&KsCaptureMonitor::_argsReady);
+
+	connect(ctrl,	&KsCaptureControl::print,
+		this,	&KsCaptureMonitor::print);
 }
 
 void KsCaptureMonitor::_captureStarted()
diff --git a/kernel-shark/src/KsCaptureDialog.hpp b/kernel-shark/src/KsCaptureDialog.hpp
index b168a2b..f8ddf4a 100644
--- a/kernel-shark/src/KsCaptureDialog.hpp
+++ b/kernel-shark/src/KsCaptureDialog.hpp
@@ -40,6 +40,12 @@ signals:
 	/** This signal is emitted when the "Apply" button is pressed. */
 	void argsReady(const QString &args);
 
+	/**
+	 * This signal is emitted when text has to be printed on the
+	 * KsCaptureMonitor widget.
+	 */
+	void print(const QString &message);
+
 private:
 	tep_handle		*_localTEP;
 
-- 
2.20.1

