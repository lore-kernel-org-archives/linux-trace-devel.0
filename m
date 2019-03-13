Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4598C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E123214AE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfCMPHt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:07:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34341 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMPHt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:07:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id o10so4670443wmc.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vEMKkG3s/JUgNbpBXoysD3tEBH/BFsvtW/Te48muOrc=;
        b=jTYqkSKrlWvpdRChuC/fl+IytTK2P1MRmLHWNfWQihneQt/kAx+LolcgYyNDG6mayB
         J0yGV7p5noGMjaesOPQEy0a4iMo+g8BwRxx2MrzLM3Cw7mmlYVx+Qh5AmICLI4WdMd/6
         6x9kmn8HFhn1/4OVOKrObAqR0P9Anyqcfk16GV6zum+WZbIL3wqUbBa1RmL9khjKv7Io
         MlLto0vjOJKjRzwel6wxKo21fMIzl2FvL0BIVS3dtqFFTLBC8fawGSyAOkzoeDLgPk7m
         pkAjFoauEniGymkX+GpddX5K0wnGeVGLc8iDfWb0u6YLKwUxiV+Kx32Ioh9MG328Sk1G
         Nl8g==
X-Gm-Message-State: APjAAAVdvYb3ifVvHxN7Lm9JksMP3pXGVTE/5T2lx/vPwLhsbokT6DHS
        iJtK431FkRrLxHyyVqA+I22eMu4z3k4=
X-Google-Smtp-Source: APXvYqyzi+Swt6NC5qK/f/UVu/5HG4OiVkuku9b8pJK8qFl4tgpUrCGNIZVZ6M064U2JG9iXZJBRWw==
X-Received: by 2002:a1c:7903:: with SMTP id l3mr2801560wme.22.1552489667586;
        Wed, 13 Mar 2019 08:07:47 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id f6sm22515103wrs.45.2019.03.13.08.07.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:07:47 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 1/4] kernel-shark: Define addPlugins method for KsPluginManager
Date:   Wed, 13 Mar 2019 17:07:14 +0200
Message-Id: <20190313150717.21345-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313150717.21345-1-ykaradzhov@vmware.com>
References: <20190313150717.21345-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The method can be used to register and load user-defined plugins.
All other previously loaded plugins will be reinitialized and the
data will be reloaded.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsUtils.cpp | 23 +++++++++++++++++++++++
 kernel-shark/src/KsUtils.hpp |  3 +++
 2 files changed, 26 insertions(+)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 3585cca..6af0c66 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -596,6 +596,29 @@ void KsPluginManager::unregisterPlugin(const QString &plugin)
 	}
 }
 
+/** @brief Add to the list and initialize user-provided plugins. All other
+ *	   previously loaded plugins will be reinitialized and the data will be
+ *	   reloaded.
+ *
+ * @param fileNames: the library files (.so) of the plugins.
+*/
+void KsPluginManager::addPlugins(const QStringList &fileNames)
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
+
+	for (auto const &p: fileNames)
+		registerPlugin(p);
+
+	kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT);
+
+	emit dataReload();
+}
+
 /** Unload all plugins. */
 void KsPluginManager::unloadAll()
 {
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index cb95b4f..c8b5e88 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -210,6 +210,9 @@ public:
 
 	void registerPlugin(const QString &plugin);
 	void unregisterPlugin(const QString &plugin);
+
+	void addPlugins(const QStringList &fileNames);
+
 	void unloadAll();
 
 	void updatePlugins(QVector<int> pluginId);
-- 
2.19.1

