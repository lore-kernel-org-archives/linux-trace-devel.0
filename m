Return-Path: <SRS0=bpiG=YL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFE1CA9EA1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 07:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB573222C5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 07:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFqzs7mo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394121AbfJRHr5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:47:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34845 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfJRHr5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 03:47:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id n124so1374486wmf.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Oct 2019 00:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pBjTBqwQgyt5HNMo5yaSdt65/6Qpdnks8maN4uEpFf0=;
        b=KFqzs7moakrAoDUQdAXoEipVjcMU22FyWsXlbnArgBlpap+sULo31WPjptr/Zsl6ui
         kcCGbDRc2MUVFvoAqYZns9y/SOfrMCOdrjwc7BzmEh8FFrahhBFw0DWF4lKIS4eMabx4
         oFX7muGvXA/psTZ7yA/C9liJI527PYktlJlx2quQSD1QdYTK4qB0J+p0va8oAlHzwogR
         TPjW0yPzAXusBDVV9a3t0G4hvmtDtrluVdMduBzDmLMrNy21bnY5S0Xb4LZWn+DAGVo/
         DFxTr+pHLF0/X8Fv1J2//yA4jmAWV9/lLQUPoM7zNtn31TRUkgPRweEWEjO6xQRJBcRh
         KxSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pBjTBqwQgyt5HNMo5yaSdt65/6Qpdnks8maN4uEpFf0=;
        b=XE3Zb7pdtxWqOxdL5JIQf//BJ/h4qGiqxcbOIUe/0f678r7q2wpeXmLU/hzTpuqipg
         0EwknHrLRamltxlJa7naMtO1gDJH4rTclv4YX9WwIKA3Xu5n8uC6GJFCkbDqzQtxtSEN
         wKgpOGfDOiFK89l2Z3B5xPiMmTE8RS1z6BVmVuu2IvtjLlgnQS+rqZwDnxK2gzwgZnVQ
         897ri0zlzcnnMG+627eS5H+kzPuCrBWPD0CLjM/YAyEhEoGvAQEjDEz8YYURi4hTu5dP
         IlpmKi1y6veMBxaZvrUSZWag64XcWijNKJ/8Ca4Bhnht+xJZ8L1pbumkCXD9vp55eOTF
         zbxA==
X-Gm-Message-State: APjAAAU9Hrtr89pD14us+cNwZu88PFLp4i+evTeB06dQJfu+5EArLmxa
        Db2wku7Y2v54JSWgXBFi+VIUuHbP
X-Google-Smtp-Source: APXvYqyX1k2AHLivt4og4XLWxhu8mophlwfgqNrJ3MTEQ36w8JiutZqV4r9DVyQyAJZBXGFBMt74/w==
X-Received: by 2002:a1c:7418:: with SMTP id p24mr6075317wmc.132.1571384876006;
        Fri, 18 Oct 2019 00:47:56 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm7740832wrg.8.2019.10.18.00.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 00:47:55 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark: Do not save the settings when running as Root
Date:   Fri, 18 Oct 2019 10:47:21 +0300
Message-Id: <20191018074722.6976-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018074722.6976-1-y.karadz@gmail.com>
References: <20191018074722.6976-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not save the settings if KernelShark is running with Root privileges.
Otherwise the configuration file will be owned by Root and later the
normal user will have no access to it.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 3402764..6da8670 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -152,9 +152,15 @@ KsMainWindow::~KsMainWindow()
 					_session.getConfDocPtr());
 	}
 
-	_settings.setValue("dataPath", _lastDataFilePath);
-	_settings.setValue("confPath", _lastConfFilePath);
-	_settings.setValue("pluginPath", _lastPluginFilePath);
+	/*
+	 * Do not save the settings if KernelShark is running with Root
+	 * privileges. Otherwise the configuration file will be owned by Root.
+	 */
+	if (geteuid() != 0) {
+		_settings.setValue("dataPath", _lastDataFilePath);
+		_settings.setValue("confPath", _lastConfFilePath);
+		_settings.setValue("pluginPath", _lastPluginFilePath);
+	}
 
 	_data.clear();
 
-- 
2.20.1

