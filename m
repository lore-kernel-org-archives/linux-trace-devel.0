Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE48DC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 919452075C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfCZNj3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:39:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32910 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfCZNj3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 09:39:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id q1so14421066wrp.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Mar 2019 06:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rcXwAu319jdI0gNay8qXKcIDNBI8LPnJYobHrCTv3Xc=;
        b=mTGgKoyw8WRhcaIVmWfYTERjK+gdaLIjzHnKzKjAE09wLWgL2lZa9mGQ1noChZ8HCd
         mFoVmKq4UP6odOfm3lUNsy3c1JQAavgCzg3lWQBUP9RpN9Dw3MIi0vxCwJ/r2SxbC0E6
         Luf+KGoN7bmDVANQ0s0VnqY5kSTonjgD0EeNQMmXWb4y0kiAf13pfExjnvULoQkKS0Uc
         E2E9YNtadF53fbg8pB5+o7z0IAlUh843Xc1ZEFIX47f7OzajEgtiUd1RL5hb95qJTAsl
         XcY4aaluXhov1Flv6QZb5rreEuvLcsTxgWR+OB2r5cotyeQQTpiQVJsEjUyaQJjtAVSo
         Z23g==
X-Gm-Message-State: APjAAAU329SnWKUGSjlC2zWevf6VdhVp0Tdm/2ZplNipih+5M7XJSWrm
        8qtKmfIImXMQZH6+YTKoMZg=
X-Google-Smtp-Source: APXvYqx52/ZsDDu3kD5kN9aK9HfMYpWsEpYPQzcyaUPxG/KYtu8oDpKPYmXltaxum/6IYeFK0vuT6w==
X-Received: by 2002:a5d:4c88:: with SMTP id z8mr12247077wrs.291.1553607567366;
        Tue, 26 Mar 2019 06:39:27 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r16sm8485718wrx.37.2019.03.26.06.39.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 06:39:27 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] kernel-shark: Fix a bug in KsPluginManager
Date:   Tue, 26 Mar 2019 15:39:14 +0200
Message-Id: <20190326133914.18884-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

const char *lib = plugin.toStdString().c_str();

This line is a bad idea because the returned array may (will) be
invalidated when the destructor of std::string is called.

Fixes: 18cf94f48 ("kernel-shark-qt: Add KernalShark Utils")
Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsUtils.cpp | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 34b2e2d..3585cca 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -439,8 +439,8 @@ void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
 
 	auto lamRegUser = [&kshark_ctx](const QString &plugin)
 	{
-		const char *lib = plugin.toStdString().c_str();
-		kshark_register_plugin(kshark_ctx, lib);
+		std::string lib = plugin.toStdString();
+		kshark_register_plugin(kshark_ctx, lib.c_str());
 	};
 
 	_forEachInList(_ksPluginList,
@@ -474,8 +474,8 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
 
 	auto lamUregUser = [&kshark_ctx](const QString &plugin)
 	{
-		const char *lib = plugin.toStdString().c_str();
-		kshark_unregister_plugin(kshark_ctx, lib);
+		std::string lib = plugin.toStdString();
+		kshark_unregister_plugin(kshark_ctx, lib.c_str());
 	};
 
 	_forEachInList(_ksPluginList,
-- 
2.19.1

