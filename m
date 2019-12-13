Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A610BC3498D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1D2C24705
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aknrQYDx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLMLrl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 06:47:41 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39737 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLMLrk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 06:47:40 -0500
Received: by mail-lf1-f67.google.com with SMTP id y1so1734194lfb.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 03:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e7g+whTuKQ/+G5YfYKPldn53qY1wbx6W1fCYzfjMD/k=;
        b=aknrQYDxS0GdJVtNKg/Ai0YYgkhMhhpTMEFU3WYM6lL+WlV+w7dGV3oYf4hiFZyCKj
         Spz+1V1PWHcpkpCOu+QSXa1eUjbckhnRy48rnUBpltYrDGRQ9py7FNfA57qWOmpJeuip
         4qgorviT97F7caEXdCg3kU2SsYyByIvWDPyHCXZKgRRvTqeuOialMW+QRrnKRzOhQMS+
         PEyvieyzedycCLexi6MAXIsFpUEGQalwvle+YxNQLSZZu3wmIxW5R9xdZmKE2nGo2+Gy
         W+bR/hF+TI566ZOgD2hDHXra3uxe4349lqshLKmur/gjySuUGmOA86SLnHTS8Ylhr33Z
         J/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e7g+whTuKQ/+G5YfYKPldn53qY1wbx6W1fCYzfjMD/k=;
        b=j1hDAz1zPBBvzdAt6iY050tcPOjGNvciFs2d2N9h7VAK5ADk+9/8a64wqftmv/+rUK
         PFJ76/kNWawp+SmLhgxlgNgdCfehXmputPqrIN99eyv0s+SuwE0V1PwnySah8Ma3nHB1
         /i+whYzCVIQpOebmNJ7VlLDdB1aWwauN+O1XGS0GpxuXmY1ErdI4gtFrQxybp5i0N9TW
         ul5IS6F8WlU+TObuI5wEWqrjWp0B0tyLR7ks8ZLLCxjcrKyRwQS9/pDEBRKBPY4rO3sz
         td5PM8x+Oachszkvdih6LQTtuTxpPEmQ4tUR1Fi0/LcGmaDH21JJYUkdI3eZYHsw0cG6
         E6AQ==
X-Gm-Message-State: APjAAAUkv6rhF2kksADfLxLTxjN0If7v8GfNvS+g33KBC/Tg+7u3hUbh
        zbD59Dts9QLHRUpBfWv/8ZF7DkIh
X-Google-Smtp-Source: APXvYqxfgzNSm3DJjQ3QOd93rz8R1RDbU1pP8HdihbRDgal/EaofN9m+bz0RMxowtLo3Klj1SXUNCQ==
X-Received: by 2002:a19:4b87:: with SMTP id y129mr9282791lfa.32.1576237658739;
        Fri, 13 Dec 2019 03:47:38 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n23sm4487145lfa.41.2019.12.13.03.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 03:47:38 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v3] kernel-shark: Retrieve the home of root using getpwuid()
Date:   Fri, 13 Dec 2019 13:47:07 +0200
Message-Id: <20191213114707.27459-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not assume that root is always at "/root". Instead use getpwuid() and
get the home path for the user with id=0. On any error just quietly
default back to "/root".

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index bd6c338..a5a399c 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -422,6 +422,12 @@ QString KsMainWindow::_getCacheDir()
 		QDir().mkpath(dir);
 	};
 
+	auto lamRootHome = [] () {
+		struct passwd *pwd = getpwuid(0);
+
+		return pwd ? QString(pwd->pw_dir) : QString("/root");
+	};
+
 	dir = getenv("KS_USER_CACHE_DIR");
 	if (!dir.isEmpty()) {
 		if (!QDir(dir).exists())
@@ -432,7 +438,7 @@ QString KsMainWindow::_getCacheDir()
 		dir += "/kernelshark";
 
 		if (geteuid() == 0)
-			dir.replace(QDir::homePath(), "/root");
+			dir.replace(QDir::homePath(), lamRootHome());
 
 		if (!QDir(dir).exists())
 			lamMakePath(false);
-- 
2.20.1

