Return-Path: <SRS0=5FCK=TP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C6AC04E53
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2193F20843
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfEOTKQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:10:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44348 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbfEOTKP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:10:15 -0400
Received: by mail-pg1-f195.google.com with SMTP id z16so235679pgv.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 May 2019 12:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7ItfzZKOt1nrRaCHb3cf3KeNap2LA1hzeISdKQJswc=;
        b=G3V3GHnynqBqQPBgaCSR/7NWdysRSsdPPi8axiSwIo1/BbYrnHWf2w6KZJIBeP+UQX
         Md7FIkUcSf6qRuIA1qw2fjozpibAbKYEcGbdayY5G0KdvSLvozJy4rIffA1HMk6Ff0t6
         d/1MHUeNUjiBmE7o/Th00QXVHhktPflU0dPSk78TZqbJMz9Pj1q67esoQFpawEXYGcSR
         R6XGRShnch62fyUVp6xNAGiNo3u1XOkItmlq2ceft690SS9GSIdtdRjyJqftYLkriqWE
         mZWEDJDF2Hj/D2diKU2W6dHIH3aP3hjXdA2+H5nH1pQ8THHRiO/OE1vlGldkXWjm8dnU
         7oIQ==
X-Gm-Message-State: APjAAAXB7707Vt05h/D1kd5voXc0aXLkXHJDHLpg8jsuUJ7s39YmHhOM
        DeoC6lutvHtgxOBnJ9kt4cU=
X-Google-Smtp-Source: APXvYqw5wA8VgaxEQduzYpFuWQu7KwZB5XIhiOd1OOfV//GWMtCvuKorxXQXwY+dMK8wQXtzBf2ZTA==
X-Received: by 2002:a65:62d8:: with SMTP id m24mr45131836pgv.141.1557947415357;
        Wed, 15 May 2019 12:10:15 -0700 (PDT)
Received: from localhost.localdomain (50-204-120-225-static.hfc.comcastbusiness.net. [50.204.120.225])
        by smtp.gmail.com with ESMTPSA id l65sm5772595pfb.7.2019.05.15.12.10.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:10:14 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Troy Engel <troyengel@gmail.com>
Subject: [PATCH 2/6] kernel-shark: Use XDG compliant path when saving cached data
Date:   Wed, 15 May 2019 12:09:07 -0700
Message-Id: <20190515190911.20755-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190515190911.20755-1-ykaradzhov@vmware.com>
References: <20190515190911.20755-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Use the QStandardPaths class provided by Qt in order to guarantee that
the location of the cached data is XDG compliant.

Suggested-by: Troy Engel <troyengel@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 5f326f5..bb593bd 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -409,8 +409,10 @@ QString KsMainWindow::_getCacheDir()
 		if (!QDir(dir).exists())
 			lamMakePath(true);
 	} else {
-		dir = QString(QDir::homePath()) +
-		      "/.cache/kernelshark";
+		auto appCachePath = QStandardPaths::GenericCacheLocation;
+		dir = QStandardPaths::writableLocation(appCachePath);
+		dir += "/kernelshark";
+
 		if (!QDir(dir).exists())
 			lamMakePath(false);
 	}
-- 
2.20.1

