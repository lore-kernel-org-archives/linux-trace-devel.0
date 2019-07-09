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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB08C73C53
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 935E5216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DttUS7co"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfGIP5c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:32 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51036 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfGIP5c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:32 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so3652804wml.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pYazrgosvtTthqaC1yaLNiDyalB8WLVpERa/5Wr2ZZE=;
        b=DttUS7coK4OyqNwgWzqmswMSI1i11mZXBaeGj860KkJgVJ88LI/QW88AAeB0qTEXvK
         whKLOdMNItBw47NBqeak7zc6HeXN7FOYY72AqJOYdGf6E7Cy84A6WdIhiBlGVAiYqMXC
         eYRmjKnYcKjsEyRm8sD/MJSoICVaoiupKUcjvyFOVQbykoegsws49vwbPiTzxVR0+wfY
         DIHLeu5W0RFvuHKI+a1CuhSkO5EJDw+kVE9ITQXidrO6hi97FvN4Y7Du/Hki6xAUMaiK
         CvhgP/p5bOF19GD4bzMt0Qux2jeh79w3N4mIKw1UsRHbV4F/dMyMFMOY/7QSQCcU9c1Q
         nYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pYazrgosvtTthqaC1yaLNiDyalB8WLVpERa/5Wr2ZZE=;
        b=OOXZh+TTVckWgbWvWKLAZVBlY29Uy5c/4ztfjDR4aQKcnxh71qC9kYMWxiV0xm09H/
         FJWUp/CE8mlyRlRSBJJF8vXck4j+vTZdd30R2qistq1R8HOi+JdRKHc1Pz4TvjNjvJ2I
         4l+OAItGX7rye3hycG3QFCQrYhPAPNBGy6bLPh2WCT7+FrfrXB5rpb7WfhQGOEGuyk/L
         qwASjhW4jGv8Dqg/UDJJGz03E0bEhIS8qwfFDTObIUD83rjiD9Q2fmufBw6raSBF0TXd
         b+HmzO18e1XhlHIlFSMvGi9Xik6lBmDkN0FD47VblU+/8ZEHrZ7/vsrvX4EQ7yRVDgMy
         02iQ==
X-Gm-Message-State: APjAAAWAzOUr9iZj2vTd70HFTYHE/t2FN7Xd2orJ9bdbPxAV5Z4g+JuK
        5ATzfw8ZVzQnVJn29rabcFg=
X-Google-Smtp-Source: APXvYqy3ZLSCtYQ5hNKF+OdcRYJALsCS4e7Euf81VkNhsYp42sMSd5z6EkoE7mQlMtCsIxijNBGgvA==
X-Received: by 2002:a1c:770d:: with SMTP id t13mr559784wmi.79.1562687850405;
        Tue, 09 Jul 2019 08:57:30 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:30 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 8/8] kernel-shark: Less scary error message from Capture dialog
Date:   Tue,  9 Jul 2019 18:56:50 +0300
Message-Id: <20190709155650.2345-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709155650.2345-1-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Most likely the reason for this error to occur is that the KernelShark GUI
is not open (was closed).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index c877094..acba330 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -554,6 +554,9 @@ void KsCaptureDialog::_sendOpenReq(const QString &fileName)
 		socket->flush();
 		socket->disconnectFromServer();
 	} else {
-		_captureMon.print(socket->errorString());
+		QString error(socket->errorString());
+
+		error += "\n(maybe KernelShark GUI is not open)";
+		_captureMon.print(error);
 	}
 }
-- 
2.20.1

