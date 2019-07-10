Return-Path: <SRS0=fQJa=VH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FF0C74A2B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 15:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC6E02086D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Jul 2019 15:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PjK6jowF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfGJPjP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 11:39:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46603 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfGJPjP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 11:39:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so2941119wru.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jul 2019 08:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NlHWAvjbHezNBAEFaBmx+hN0v3GuklYBl7Pj6WNb328=;
        b=PjK6jowFPjNupb7xCFbOGSDgxgOPAGP664Sfx+L+Y3foUYICe3nZ/C1+mVwfIOtZur
         u2k590mtsXCMbfL0BLyWdmLEDn8YWaXwNi5BqKCeQEX91uYaLAzZnek2OLUi25CzqMpj
         3fC7KxItslfmQ5AeZLa8vXHTZad+NcEHQeYPEWjIiJ5BHVG/A4DdAQjYJEkid0zKQraI
         YctvAtVtOD0vyWLlDlHd0P9TwuX1vCZjDjsvCzwK+mEne3A5bmTiBXpwkl4eoi/g2L07
         n88aMtHw/I42f9Ai54p6LiYz9eX+SYal1BE96Q6lT8rZn/JyF5DwNaBdbq3RxbaBfClT
         Qt1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NlHWAvjbHezNBAEFaBmx+hN0v3GuklYBl7Pj6WNb328=;
        b=ZRnAoA++Z8b2JT2Z4SxmAu7ATfaib0x8W2LgvNysS6eEgDJy1R58ruOwSykVYD0W4R
         wt4qY72xyFFeDa5VCmwATUDSoOf4mw7d9ego34oRl1s74VrEi9i4sV9b1ziqA147N3dM
         qr8G2zyWzo3paCclHtnmhtM/jjpuYPBJoU2vCbWxxvC0RILWKg6Eb60nnpOokx64ybgX
         SueEBrLlu9j8w1FTYk/a7gZpNgjzi0OgBlXd1QlOh8UBZx6vjWgEidriliN8zEV9FV88
         4dq7TSDBfvWc9IuPOGCp1cAERT1LEf2AEQxvgO3zi35uOrmu1FcJTOs0ovzQIJ+YWFD3
         x+lg==
X-Gm-Message-State: APjAAAUxTXbhrJ7GJ6qHMdKobAd2vuib2FZFGRoS25IcUamZO9DfH3HO
        JrOHDxY+NpHBQ27NV6klYQQVLPeQKB0=
X-Google-Smtp-Source: APXvYqxeXxoGXZEu6l8vGsv3VBhWReKfFIsjvJ/8WKAix2uE4ZArCCfo4I8Mq023Vwr1f0cmrr3Dcw==
X-Received: by 2002:adf:e947:: with SMTP id m7mr32816897wrn.123.1562773153453;
        Wed, 10 Jul 2019 08:39:13 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id j10sm2667996wrw.96.2019.07.10.08.39.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 08:39:12 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: kernel-shark: Avoid a duplicate error message from capture
Date:   Wed, 10 Jul 2019 18:39:06 +0300
Message-Id: <20190710153906.32048-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the capture process finishes with an error the _captureError() slot
will print an error message. We do not need to print identical message
in _captureFinished().

However, we have to keep in mind that the process that we started is
"pkexec" and the capture dialog is a child process of "pkexec". So if
the capture dialog failed to start or crashed the "pkexec" process
itself will have a normal exit, however its return value will be
different from 0 (it will just pass the return value of the capture
dialog executable). In this case _captureError() is not triggered,
but we still want to see an error message.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 29d44d9..c127ad1 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1180,7 +1180,7 @@ void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 		return;
 	}
 
-	if (ret != 0 || st != QProcess::NormalExit) {
+	if (ret != 0 || st == QProcess::NormalExit) {
 		QString message = "Capture process failed:<br>";
 
 		message += capture->errorString();
-- 
2.20.1

