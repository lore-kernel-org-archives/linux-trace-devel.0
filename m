Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF74C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51AD120652
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfCGPnr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:43:47 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55047 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfCGPnr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:43:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id f3so9789031wmj.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:43:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eMAX++wxUEb3/+S1k0GjhXMPAUaZXGR6sOY/EpkRX04=;
        b=EdQnTADByO41qYgOobNtLLS7HyOx/fApc8eKJ6HeVB9DfGLwzAF9VdY69B/wCtyWOq
         DKaR6xmwxkwO7CnUbs/r3NF5Vll25AaDCNcIjw0O+dMEbxVDmEu/JCgq4g4Ri3MliHVA
         AvWjhsi1sTVO9a8VKYz7IuiZZsr4KcbKIcoCuBk1I/ES8WB6c/LPYOIGWXCPtKE0M997
         e0lk9jGQfEJcy89beaFaaycRY2q+CXE9sr5F4896hdnOlHuqLAW7CCm3d1yaEmteeI8h
         l1AKiEPIvmxMTKTyYEMEOV8PCz9nxH8WgYzrtw1PGyeqwHh09RGucKDRHx9v4B9mDFVX
         k5Rg==
X-Gm-Message-State: APjAAAUXT0w4W2dPzUHDLIdhes3vXdmf7W+9SDX2dEu2paaCz4RVnYo6
        0mhVc3ZMpYUOFAMAfNg7OvQ=
X-Google-Smtp-Source: APXvYqxyl9fiML/SjsUPY2J01jQTpK1MI3H9zZuLgGfdAS1531h84ySzdlrnlUrm4tLCFsgNo4CGSg==
X-Received: by 2002:a1c:dc0a:: with SMTP id t10mr6182738wmg.101.1551973425140;
        Thu, 07 Mar 2019 07:43:45 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id h9sm10081463wrv.11.2019.03.07.07.43.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:43:44 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 4/4] kernel-shark: Fix a bug in KsPluginManager
Date:   Thu,  7 Mar 2019 17:43:16 +0200
Message-Id: <20190307154316.19194-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190307154316.19194-1-ykaradzhov@vmware.com>
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

const char *lib = plugin.toStdString().c_str();

This line is a bad idea because the returned array may (will) be
invalidated when the destructor of std::string is called.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsUtils.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 34b2e2d..d7b1753 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -439,7 +439,7 @@ void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
 
 	auto lamRegUser = [&kshark_ctx](const QString &plugin)
 	{
-		const char *lib = plugin.toStdString().c_str();
+		const char *lib = plugin.toLocal8Bit().data();
 		kshark_register_plugin(kshark_ctx, lib);
 	};
 
@@ -474,7 +474,7 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
 
 	auto lamUregUser = [&kshark_ctx](const QString &plugin)
 	{
-		const char *lib = plugin.toStdString().c_str();
+		const char *lib = plugin.toLocal8Bit().data();
 		kshark_unregister_plugin(kshark_ctx, lib);
 	};
 
-- 
2.19.1

