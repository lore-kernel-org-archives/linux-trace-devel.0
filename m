Return-Path: <SRS0=5Z96=UG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BAFC28CC3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2913208C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfFGJvZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 05:51:25 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41496 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfFGJvZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 05:51:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so1482903wrm.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Jun 2019 02:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EhiDbuHxFxc0opFEkunjkWWxZ0VY88U307vQQy88rJU=;
        b=OAzRDXwbyhjNal11YT22gH4XY2KNby+io8vfGG9MDnGxWl2YlqPi7uFgxTvfVXmw2Y
         KRZdKYmVh1mIPKxsaZZilTXRAtWVHv3R1cu9gOWIryABSULStxvl6Dk0JQDWVopJkHXC
         dT9OHbNs4OQFMe9nB/ARwBV9a+5S/dPUZXef1XnO8id1R5vEahzxXku1z0KjAsdJ60xc
         okzBs2JUcgUD1uc6jtfEOa4TjUHGTDTr7OtiN9xZ4KD6J1JZ7sbTJQAa+f3svgrO/PSl
         1IEEhvAguJtSFZsAj3NIUjFWHsadtQWBMIAcUJxggvb2jYNJRcf7JACzpWSbjh55H8eM
         cDlg==
X-Gm-Message-State: APjAAAURlgCgctHemxGF5EZujDCGCcdWwkrZ7+2DnqwhtBs/uz2CurJz
        4oWoCzhu9VAlVS/7EjDLSE4EF6qu
X-Google-Smtp-Source: APXvYqx8fw8Y3rOTcplpA5HXXRlaJB1Y1KaojrTYFu9ljmNlkt6eSi8yn2qMw1VYRd3DKDqCILK++w==
X-Received: by 2002:adf:dd51:: with SMTP id u17mr18492338wrm.218.1559901083477;
        Fri, 07 Jun 2019 02:51:23 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y5sm1606974wrs.63.2019.06.07.02.51.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 02:51:23 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        sstamenkova@vmware.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/3] kernel-shark: Start using the new logo and icon
Date:   Fri,  7 Jun 2019 12:50:55 +0300
Message-Id: <20190607095056.14666-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607095056.14666-1-ykaradzhov@vmware.com>
References: <20190607095056.14666-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new Logo is shown on the title page of the doxygen documentation.
The two new icons are installed ("jumping shark" and "fin only").
The "jumping shark" icon is used by default.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt     | 6 +++++-
 kernel-shark/doc/dox_config     | 3 ++-
 kernel-shark/src/CMakeLists.txt | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 145b058..d45be20 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -41,7 +41,11 @@ if(NOT _INSTALL_PREFIX)
 endif()
 
 set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
-set(KS_ICON ksharkicon.png)
+
+set(KS_ICON        KS_icon_shark.svg)
+set(KS_ICON_FIN    KS_icon_fin.svg)
+set(KS_LOGO        KS_logo_symbol.svg)
+set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
 
 if (NOT _DEBUG)
 
diff --git a/kernel-shark/doc/dox_config b/kernel-shark/doc/dox_config
index c6c53df..43c7f84 100644
--- a/kernel-shark/doc/dox_config
+++ b/kernel-shark/doc/dox_config
@@ -2,7 +2,7 @@
 # http://www.doxygen.org/manual/config.html
 
 DOXYFILE_ENCODING      = UTF-8
-PROJECT_NAME           = "kernel-shark"
+PROJECT_NAME           = "KernelShark"
 PROJECT_BRIEF = "Kernel Shark is a front-end reader of the Linux kernel tracing data."
 INPUT                  = ../src/ ../src/plugins/
 SOURCE_BROWSER         = YES
@@ -13,3 +13,4 @@ CASE_SENSE_NAMES       = YES
 SORT_MEMBER_DOCS       = NO
 STRICT_PROTO_MATCHING  = YES
 DOT_MULTI_TARGETS      = YES
+PROJECT_LOGO           = ../icons/KS_logo_stacked.svg
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 6cbc00f..c95741c 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -85,6 +85,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
             DESTINATION ${_INSTALL_PREFIX}/share/applications/)
 
     install(FILES "${KS_DIR}/icons/${KS_ICON}"
+                  "${KS_DIR}/icons/${KS_ICON_FIN}"
             DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
 
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
-- 
2.20.1

