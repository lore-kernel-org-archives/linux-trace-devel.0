Return-Path: <SRS0=Fk9f=SG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A507C4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BF4A205F4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfDDO4T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:56:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46674 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbfDDO4S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 10:56:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id t17so4129874wrw.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Apr 2019 07:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=frj9H5zYvSb6RavHTSwMKoitEP2oz6MyHpmET+IXKMg=;
        b=a8T5vBAu1QA+3PLZ7cJNipIBftAeONRhQFw4m6iUF4VIbcMUv5Evsbaw9F7719Jvrl
         q2Nmmx4IgPZiLoMlpP7dyIxfnFhirVz4rotetROsLk36aPVjkXSe4cC54PWCGSS9xLkS
         KnqiYr2jGOxMLap35+nxiWRX8T6/ilduC79f7F2fHw+JeSBIstbzf1ZquqA01KPPZxJt
         Xu2mHKmZoPaWqZ2w+hv48RxN90r7fvUzvlCaTivWskFNgDRF3xLeBoHkEkAIvZ28huq7
         U2G55CpdA08H0tFLyXzK2vjCUJ8GuwElDBEgmwZD1wv82EPJXMD8zccqXIIvXM3xOWUS
         bj3Q==
X-Gm-Message-State: APjAAAUY0srv90lzva7oCGpFzTYDF06e/E8EmJRBe4F7BuQCz//6K7mo
        cZtiMtbJe1LWt9M8Y67AAac=
X-Google-Smtp-Source: APXvYqy9uPiFaFJPVmOLkda/npXthhcW4AHkTjwe0mD47GKX0xU866+PvQjtpczjKGvI+xkaTf2Dhw==
X-Received: by 2002:adf:f68d:: with SMTP id v13mr4428766wrp.6.1554389777123;
        Thu, 04 Apr 2019 07:56:17 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id m13sm21919883wmg.42.2019.04.04.07.56.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 07:56:16 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] kernel-shark: Configuration file directory to be created by the executable
Date:   Thu,  4 Apr 2019 17:56:03 +0300
Message-Id: <20190404145603.13592-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190404145603.13592-1-ykaradzhov@vmware.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The build process should not make the directory that will contain
KernelShark configuration files. This directory should be made by
the application itself.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt       | 2 --
 kernel-shark/src/KsMainWindow.cpp | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 14d73f5..c6a4abf 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -17,8 +17,6 @@ set(KS_DIR ${CMAKE_SOURCE_DIR})
 set(_KS_CACHE_DIR "$ENV{HOME}/.cache/kernelshark"
     CACHE STRING "Directory for cached configuration files.")
 
-file(MAKE_DIRECTORY ${_KS_CACHE_DIR})
-
 include(${KS_DIR}/build/FindTraceCmd.cmake)
 include(${KS_DIR}/build/FindJSONC.cmake)
 
diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 39b06d6..898e598 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -127,6 +127,9 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 		this,		&KsMainWindow::_deselectB);
 
 	_resizeEmpty();
+
+	if (!QDir(KS_CACHE_DIR).exists())
+		QDir().mkdir(KS_CACHE_DIR);
 }
 
 /** Destroy KernelShark Main window. */
-- 
2.19.1

