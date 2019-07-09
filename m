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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F634C73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC5BB216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsnBZ+3x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfGIP53 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36270 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfGIP53 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so3812983wme.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oafdOE8cfRFcWDHI3K/XrnurRFkCwhoOhyD3nfV4xjc=;
        b=dsnBZ+3xtGobcd4JSiENGMzhLM9tNbjUdHw1/3UebxFHWXPssY7ep7lX4QIqQxjE56
         FkaeiipwZVJMHtGjY/o8Ye1v+f5cZ0rsZa2rGRA7kZwpjsv6zJHFLkV4wj/yM8A/H6Ak
         EKcrXnukrTc+amF6OeCxiO5n3zmJhlrjuvFt94XXgADGG9Nn2AJiPe8AVOBmMTFTLqpk
         0iArAA84Q0nFVwbFFABU6b4Elr+VCUnzIW45aYO5Q5JK4115H7iXMk7ZFOcyY3SNgfOj
         d0fNdLhEId2A8j/bTW6eGVGGLqnvzWJka4ZyWbIHhzCtW/5dHhAb1LoBLz1k0YZJnn7B
         ZdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oafdOE8cfRFcWDHI3K/XrnurRFkCwhoOhyD3nfV4xjc=;
        b=IudCVsRi6BwazfL1Gdgcjn+/z/MgvlNaPXfaUH4MMF6GiqN1DAmVeaiqSau+MBmzbD
         +BOqAV1Fq5679nWkWBOGfs6yKHIMNd9OuSa2qRz4nN22sR8co5t28qHi3gSGSrsMC5ix
         oIQLk30ID8dzjHVHykarsuF0phUUFsynwFLj9FKIugx28iGtXyXwP9Ne1CDAoaWiPLPo
         Au+3gmNhVIPmnt9XrhaqTAktKQwc/KSgMz3dXtsURD4ph6CEoYWH/+Ti19nNGcaLKcIF
         I0VoSgZHHbNG33WiY1GsbAzG8DAu2SULYn77HxOdXh6wbHP7mq8Hve4C+MOeNKDnIsUR
         NErw==
X-Gm-Message-State: APjAAAU8is7MN1VGpbQxgSRUog+sOSJAEC/0QumJb8BnoczGX5SKJfw/
        FYLnAhiJVVVCtekn7KbolvM=
X-Google-Smtp-Source: APXvYqzhhRbw/4AEN7R0yl6ZSKTv8OrxyAQJ5GuGWimKZ3tGoOv++2VoZqKCLL2hjxmvMTeDTinD8A==
X-Received: by 2002:a7b:c0d0:: with SMTP id s16mr556271wmh.136.1562687847497;
        Tue, 09 Jul 2019 08:57:27 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:27 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/8] kernel-shark: remove the "make install" suggestion for capture errors
Date:   Tue,  9 Jul 2019 18:56:48 +0300
Message-Id: <20190709155650.2345-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709155650.2345-1-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The message is not appropriate, although it is most likely that the
error occurs because the user didn't install KernelShark and it runs
the executable from its build location.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 752a17a..3f238db 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1154,8 +1154,6 @@ void KsMainWindow::_captureError(QProcess::ProcessError error)
 	QString message = "Capture process failed:<br>";
 
 	message += capture->errorString();
-	message += "<br>Try doing:<br> sudo make install";
-
 	_error(message, "captureFinishedErr", false, false);
 }
 
-- 
2.20.1

