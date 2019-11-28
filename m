Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BC7C432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 11:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F9D21775
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 11:45:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqZNESkU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfK1Lpt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 06:45:49 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40357 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK1Lpt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 06:45:49 -0500
Received: by mail-lf1-f66.google.com with SMTP id y5so7127115lfy.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 03:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=doRpkDH7dyICWrvXR6tJMunMiys34eya3SWDxOlKHkw=;
        b=DqZNESkU2z7HmGa8JkXizpMnyZKcWRZmFWBni7kGLqo9xA3q8MUMFFFZs20BClKpdd
         FFDrWjRPs62MtYsBmMs7ojDxIupAY7ASHHIqwnv5iP+eBpjny+wQKlehaZcCma1u4qIC
         3RCRbpgUv+olC0emXglSJV7JEKKlwKAF52/tzkwPcOlc5g0rfE4P2ja9Ci/3EG2FUQ3U
         qz0kjQSfoZc/LffCO9oLKqY2cNJAUs4XZoVopd8Kj4gCM9hydRXV/EkSoUOa78k/78KE
         hA4xS/fHzBLtS1x9mSF7BQL+SMI6wTjeurQDGVM6GNJvMVudLnNJAHcsK099EXXrRSa6
         FdnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=doRpkDH7dyICWrvXR6tJMunMiys34eya3SWDxOlKHkw=;
        b=j0H7CfGALr6WTf4RaPjPnYfl/Z6p94MEwd3cVP7v05dxx0a4262t72S0mtREdVWYl/
         UJadTzcwJdTw2YSoo7BdskNUzwrXpT616orlMPo2g0/ksDEuN3NAt7FQLXVMLTJxILjc
         gxY6eugie5T7I167oCjqw868GCNxq4ze2JLsF/chUt4zZ1vQdyin4Ajj5e25f17lskUu
         j/i+/hs4U/oxDeKgn5DtCscZeq37PrV63xKPJzo9K7DGHP55pqU8zOi8UTwhxCNbb0iW
         Rkeu7A5XybW1rlVC093kDRuLKk6Cze2nupOH4b3JXSRSznLs7K6lKrUM1lcmsGgTvWRE
         35fA==
X-Gm-Message-State: APjAAAXgxVZjDNw23LuxHstmDtpYkLE7lF7ny42mjxqh7Dd1k65rUs9h
        6xkb4wuqaRWQrK3U/w1lSCM=
X-Google-Smtp-Source: APXvYqwwmFcvXjPIFux9vKFRMEVc2DOBgVpHRVXKFGF9YsylVOGHzY8RPuZ/GuUX0cheC4xQKowo5A==
X-Received: by 2002:ac2:4553:: with SMTP id j19mr33112306lfm.142.1574941546927;
        Thu, 28 Nov 2019 03:45:46 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n14sm8266007lfe.40.2019.11.28.03.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 03:45:46 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Retrieve the home of root from "/etc/passwd"
Date:   Thu, 28 Nov 2019 13:45:00 +0200
Message-Id: <20191128114500.6289-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not assume that root is always at "/root". Instead read the
"/etc/passwd" file and searches for the user id of 0. Return the home
path for that user. On any error just quietly default back to "/root".

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index bd6c338..fa887fc 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -422,6 +422,30 @@ QString KsMainWindow::_getCacheDir()
 		QDir().mkpath(dir);
 	};
 
+	auto lamRootHome = [] () {
+		QFile fPswd("/etc/passwd");
+		QString home("/root");
+		QStringList userInfo;
+
+		fPswd.open(QIODevice::ReadOnly);
+		if (!fPswd.isOpen())
+			return home;
+
+		QTextStream s(&fPswd);
+		while (!s.atEnd()) {
+			userInfo = s.readLine().split(':');
+
+			/* Check the User Id. */
+			if (userInfo[2].toInt() == 0) {
+				home = userInfo[5];
+				break;
+			}
+		}
+
+		fPswd.close();
+		return home;
+	};
+
 	dir = getenv("KS_USER_CACHE_DIR");
 	if (!dir.isEmpty()) {
 		if (!QDir(dir).exists())
@@ -432,7 +456,7 @@ QString KsMainWindow::_getCacheDir()
 		dir += "/kernelshark";
 
 		if (geteuid() == 0)
-			dir.replace(QDir::homePath(), "/root");
+			dir.replace(QDir::homePath(), lamRootHome());
 
 		if (!QDir(dir).exists())
 			lamMakePath(false);
-- 
2.20.1

