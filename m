Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FCDC73C53
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B987216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rNtIw7+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfGIP52 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54287 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIP52 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so3628208wme.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AHunqJETTE6J5yl+agrAXzmMG4fvntDz6Z8j37hRPyg=;
        b=rNtIw7+QdfafExM+vAYWdUlPlM56B5ixZU9c2oGZEXb+w5bHlleRGmkVMt50+U4aGn
         Ni6wlZK1UaZGVTGQ5cWEkCUa6K/PSSbcK+enIiV04Imn7lOVr1xGF8iy1D71OI30TnE1
         wOuVHA2ijU1RD93AkzCnOTrA6MU2SB+gcRsP/+CkaydFo9F4Gw3W9QBc7Y1/nPHiYh8I
         PqQgirsWw27tQuo8lilJWLB8OtNoxAWBd5MtXnWt3IP8H3MyvHKVLQYd7N/H42CRO0uV
         ShmzTkgxzuA8oGsSFSYWF8EDvS7ck14/Jqifh1KUTY0Q7lREG9K0ukXXy/NbaogWfvF2
         Xiig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AHunqJETTE6J5yl+agrAXzmMG4fvntDz6Z8j37hRPyg=;
        b=GvGtZRutxm+OYcvEAEETKWWUD/wpsKVEL5XksA37rhvLGOCjNFO1ZvAU1XPDo95LPI
         wYCRZlMVc3rPuHKsCvesfulsM441B4hU03o1wU0xbecOVUqONDtPM93WtTeKe1xIwqgC
         hpw6SP8f+bSjCeZsacBl9S29RtoSlwTrD7rxvDomJzi+ozS0VTdM9CqVITopobLgXvxY
         AmvDDgihcsFQEaUWoK/8UR8EWDXgtAYbNdSUguEIpXydmqdvY/Xd5kiGsoKMDlrt61h8
         aj/tdyi+8gJTvkm4uKs51e1OMdyij5ZG5JZuCTE6NiSZpOsLoXbA4aF/xmpnM+9wQxNO
         8Q6A==
X-Gm-Message-State: APjAAAUuNtRY2VuUSd949tIvigud8q/joU0nzj/5WHY0SkmXd+N3US7O
        QUXKGeYQlvT1C/6Luwnt5qa4tH33rSs=
X-Google-Smtp-Source: APXvYqwu5wepZkWkFmaC1Qh+XRcPkI/YfBV+m87IknWKlzpXKGepcV5zVdExsicqHo1nZ607O3hOcw==
X-Received: by 2002:a05:600c:284:: with SMTP id 4mr624121wmk.12.1562687846123;
        Tue, 09 Jul 2019 08:57:26 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/8] kernel-shark: Remove a duplicate error message
Date:   Tue,  9 Jul 2019 18:56:47 +0300
Message-Id: <20190709155650.2345-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709155650.2345-1-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the capture process finishes with an error the _captureError() slot
will print an error message. We do not need to print identical message
in _captureFinished().

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 1e03632..752a17a 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1143,35 +1143,9 @@ void KsMainWindow::_captureStarted()
 	_captureLocalServer.listen("KSCapture");
 }
 
-/**
- * If the authorization could not be obtained because the user dismissed
- * the authentication dialog (clicked Cancel), pkexec exits with a return
- * value of 126.
- */
-#define PKEXEC_DISMISS_RET	126
-
 void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 {
-	QProcess *capture = (QProcess *)sender();
-
 	_captureLocalServer.close();
-
-	if (ret == PKEXEC_DISMISS_RET) {
-		/*
-		 * Authorization could not be obtained because the user
-		 * dismissed the authentication dialog.
-		 */
-		return;
-	}
-
-	if (ret != 0 || st != QProcess::NormalExit) {
-		QString message = "Capture process failed:<br>";
-
-		message += capture->errorString();
-		message += "<br>Try doing:<br> sudo make install";
-
-		_error(message, "captureFinishedErr", false, false);
-	}
 }
 
 void KsMainWindow::_captureError(QProcess::ProcessError error)
-- 
2.20.1

