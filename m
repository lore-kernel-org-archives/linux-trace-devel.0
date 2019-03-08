Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1428DC10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E559F20851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfCHROf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:14:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52721 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfCHROf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:14:35 -0500
Received: by mail-wm1-f66.google.com with SMTP id f65so13219867wma.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:14:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b1aZaa7qJ/t0zmMfl0v7mjZ2rBQkdXS8aoMYMSi7kTE=;
        b=QmXCtfpIEAxG1ONhBw/r48JW84/muJ903Zco+ZNy4KaWiu9npNWnoBUF0lpLxYVypl
         pspxcSS85Qfvbvzq4MCXLOkhiEZqIbM6/rKishimMRldFH0ioPhX/tybAr27ZiNIrwtJ
         lxQupdQG4wa5Ng4kkisbNZop7ect7ZU1kCAlfn8HhZY24UUKng2d9c14XZo/4veAEGpN
         ozQznQgSREumcPPMgX/MHQRWmsmwGRFAAm/8wwHSEr+IUt0Af2K5ut/b0SaiHvajDTNm
         +525isgLMZNupwvCiNJ+gHrvJBKuWjxDKt+hYmlEdbSkThL6mRecG+snjuugcxyVz7uB
         wIGQ==
X-Gm-Message-State: APjAAAWoh4uQ+CYPSKCk1oKbjYpH90QtMtfWafeZtnXwdWWRGmrDPxJF
        /ebASibtGRWusrVKUhI3XZc=
X-Google-Smtp-Source: APXvYqzPRHinbRampi91Uvz5NabFbAUjo2LAZKYqZmsKAiuophNHHZe8lS7J8PBrVaAoUefO800b5Q==
X-Received: by 2002:a7b:cc86:: with SMTP id p6mr9468698wma.32.1552065273571;
        Fri, 08 Mar 2019 09:14:33 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id o5sm6126796wmh.12.2019.03.08.09.14.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:14:33 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/4] kernel-shark: Define addPlugin method for KsPluginManager
Date:   Fri,  8 Mar 2019 19:14:02 +0200
Message-Id: <20190308171405.15266-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190308171405.15266-1-ykaradzhov@vmware.com>
References: <20190308171405.15266-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The method can be used to register and load a user-defined plugin.
All other previously loaded plugins will be reloaded.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsUtils.cpp | 17 +++++++++++++++++
 kernel-shark/src/KsUtils.hpp |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index d7b1753..4d05bda 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -596,6 +596,23 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
 	}
 }
 
+/** @brief Add to the list and load a user-provided plugin. All other
+ *	   previously loaded plugins will be reloaded.
+ *
+ * @param fileName: the library file (.so) of the plugin.
+*/
+void KsPluginManager::addPlugin(const QString &fileName)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
+	registerPlugin(fileName);
+	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
+}
+
 /** Unload all plugins. */
 void KsPluginManager::unloadAll()
 {
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index cb95b4f..ae7f6d1 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -210,6 +210,9 @@ public:
 
 	void registerPlugin(const QString &plugin);
 	void unregisterPlugin(const QString &plugin);
+
+	void addPlugin(const QString &fileName);
+
 	void unloadAll();
 
 	void updatePlugins(QVector<int> pluginId);
-- 
2.19.1

