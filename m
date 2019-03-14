Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE76EC4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA66C20811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfCNPKi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:38 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35525 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:38 -0400
Received: by mail-pg1-f195.google.com with SMTP id e17so4192453pgd.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YuF/EcS7EFekqU+ZXEezGqh6is9aeU2eL8pUaGLp0HU=;
        b=NMf20S0Uu2nv65vl6/X24NZ5OoOF9OSYUZ1+brYJWtCYOoVez0/Gpcvj/ogng7Bu42
         Rp6qD7qHHVwCxeo/ZOItpaN8/IP6CpdmMBBqQhjUxuwTdSY24MF8+ggi0CFrcrgLF+So
         4CCMonVD6cZjtnJK+CQ3uNT7gsEJ/VlpBpxuagOMHki0uUWnBB4T6LDlXLYSxu69TJOK
         M4X7uLhaNirLxLVn2DyGcI0I0e74lAGIdmYZgfc3iZN4WzzXueyXTSgSmM02P2Gx+Ng0
         xxJ0JznXPTiJ+QcRq8TWXGGV5/rSsHMMZcNg/pxwbbr6aat0xYV1CCSlpi7td7DpOvwZ
         Gikw==
X-Gm-Message-State: APjAAAVwtesL/WIlSIKZtRecHbMTgGKckcGpRyUjeFs6fMC0AE+aOO9i
        5nE6rwSXFohh72caQo9b6ZA=
X-Google-Smtp-Source: APXvYqydc72jn1I9By3XFWNU6ARWxvQeuI7CjyUtPVRAmGT1a8ogsu194gAr53VQJgoZlQSUpuhUBQ==
X-Received: by 2002:a63:e03:: with SMTP id d3mr28070497pgl.245.1552576237654;
        Thu, 14 Mar 2019 08:10:37 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:37 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/12] kernel-shark: Error message if the opening of the session file fails
Date:   Thu, 14 Mar 2019 17:10:04 +0200
Message-Id: <20190314151012.905-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we add proper handling of the case when the loading of the
session description file fails.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 91e0c9f..44221f6 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1010,7 +1010,16 @@ void KsMainWindow::loadSession(const QString &fileName)
 		return;
 	}
 
-	_session.importFromFile(fileName);
+	if (!_session.importFromFile(fileName)) {
+		QString text("Unable to open session description file ");
+
+		text.append(fileName);
+		text.append(".\n");
+		_error(text, "loadSessErr1", true, true);
+
+		return;
+	}
+
 	_session.loadPlugins(kshark_ctx, &_plugins);
 
 	QString dataFile(_session.getDataFile(kshark_ctx));
-- 
2.19.1

