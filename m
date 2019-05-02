Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24243C04AA8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E851A2075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfEBMkn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:40:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42000 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfEBMkn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:40:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id l2so3129982wrb.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7ItfzZKOt1nrRaCHb3cf3KeNap2LA1hzeISdKQJswc=;
        b=JpFWH6xGImItAlBYcAo1fkFWdCvGPruvzkV9EFfWCOheHI2wD7gFbPtqSNzhWoF4vV
         oa8MpV94QCf2VpLjVvQAOgh9lig5bAjKS7/5FL4UEBfoNDbJTpBue/rHEAjBiUBRPdBM
         FSNklo6Dw7l/dX7dzs5GQXlrlTzqHTX0bwyln0hDR3+kuv40ACGypqCZfONb7kOP1bH2
         HO4t7/pe8rjUuWWb4i/DtS15dD2eQ/hqotOZdM58vHy91o64aKLodsDNy85YkO0rMEJ1
         u+JY/VwGutZjH51YbvtchNN6DQ5WBVMps/dtiI5dMj+7GM6OCEkxH9KIRkrhmEVqZBG/
         svLw==
X-Gm-Message-State: APjAAAV9LMEgBNodODnI8W4SDipleynvxmIg76jHrSDNAxm1g7stMLb4
        fKsEvE1HzrNXvC90sMMTmmU=
X-Google-Smtp-Source: APXvYqxICNcv5KKQp1NqeqjJwuOsChTgWQP8mJmLCzKHih3ZURPgOKH3owhk8KremBH05x9PRWFHEw==
X-Received: by 2002:adf:db05:: with SMTP id s5mr2623511wri.247.1556800842252;
        Thu, 02 May 2019 05:40:42 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:41 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 8/8] kernel-shark: Use XDG compliant path when saving cached data
Date:   Thu,  2 May 2019 15:40:09 +0300
Message-Id: <20190502124009.32208-9-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124009.32208-1-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
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

