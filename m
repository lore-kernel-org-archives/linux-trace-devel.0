Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB00C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Apr 2022 15:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347475AbiDKPUP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 11:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244798AbiDKPUO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 11:20:14 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3177326C8
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Apr 2022 08:17:59 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v4so5361974edl.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Apr 2022 08:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uz0Qj4HqGj8zZuxN93G4U/BHoUPzN/AMV7S8css1VRc=;
        b=K2c58GFB1sNql49nIZe7fcbDZU9Nv2r1ZcNytKOh5ZysDJxhTV4C+TjjqoTJJ1sxZz
         UHvF07ga2CXKA4R41ZMcNktI8+dNh+IWotbvPVe9anSeSs1HoIYzHlDzstlXwk+koc1T
         ehp7LwHnLbBrXiadNgSldbBe/h3T4qwu+HCL0LKUsA9T9haUARxxy3Nj9i7oHw+rEQmo
         RMJoGjYlLkYrgnEMOVj17hWblj/rutZfITnIkYrY5l0lG+pIuI1vmJj4A+6TT5gRoP1J
         ViU3CLTKiJRXHrn7SQAN7uaA5/KxhzOv4BSk6uN1F0mBMlumMGLPmnBcZ87egexlV3QK
         yU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uz0Qj4HqGj8zZuxN93G4U/BHoUPzN/AMV7S8css1VRc=;
        b=gvMoOIehwWm5PKbFiV41VKYW7qD1DksR2zEtrcEr5FmAu3L/Sa9cECSeJhVdrdDfSq
         pzrnIYImqMc0V3uOV2oMQgCGz9LLSv55UyqH2qQVh/SjwklzGE0vxam8ygJr21w+ouur
         EsxkuB+K1lyvOZJqBwGxBLNv9tSXZKFxp58+iAW1QIbG2PQ8J3VddBbqWoO08SqMM0XC
         PzWrDJgU8rFKIOWkoWtwHk4NgRXCWdUmQjMvpV+1imRgXTTdSjyIIxx7irN9Vy5a+X2v
         Qtlnp+K7w1hcxr8yw7FjiHU/1HO9SFT0Mt+lDUTLlZJRNh4JxSHzG5cjIS1sWdJP+x8s
         +Fkg==
X-Gm-Message-State: AOAM532L2d4Ut/YLaQciFyxLHyeZC+XtGtqgmrBsltKLnZKVrX0zYbuT
        y5br4715VDGslX2+KIiu0z38v6qZ+vc=
X-Google-Smtp-Source: ABdhPJwtF5q/iK2jkgtF0+qJECv2gMo4eaFE00sPlQbn1NbUnAjN9ebmt2ajE2Smz7EKlO9WMU0how==
X-Received: by 2002:a05:6402:2688:b0:419:5dde:4700 with SMTP id w8-20020a056402268800b004195dde4700mr34123419edd.124.1649690277890;
        Mon, 11 Apr 2022 08:17:57 -0700 (PDT)
Received: from crow.. (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id s12-20020a1709062ecc00b006e8558c9a5csm3867262eji.94.2022.04.11.08.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:17:57 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Do not hard-code app name
Date:   Mon, 11 Apr 2022 18:17:43 +0300
Message-Id: <20220411151744.445930-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Instead, use 'cmakedefine' the export the corresponding Cmake
build variable.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 build/deff.h.cmake  | 3 +++
 src/kernelshark.cpp | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/build/deff.h.cmake b/build/deff.h.cmake
index 82379df..4302f00 100644
--- a/build/deff.h.cmake
+++ b/build/deff.h.cmake
@@ -11,6 +11,9 @@
 /** KernelShark Version number. */
 #cmakedefine KS_VERSION_STRING "@KS_VERSION_STRING@"
 
+/** KernelShark Application name. */
+#cmakedefine KS_APP_NAME "@KS_APP_NAME@"
+
 /** KernelShark installation prefix path. */
 #cmakedefine _INSTALL_PREFIX "@_INSTALL_PREFIX@"
 
diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
index c373f54..1ad15f4 100644
--- a/src/kernelshark.cpp
+++ b/src/kernelshark.cpp
@@ -56,7 +56,7 @@ int main(int argc, char **argv)
 	int c;
 
 	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
-	QApplication::setDesktopFileName("kernelshark");
+	QApplication::setDesktopFileName(KS_APP_NAME);
 	QApplication a(argc, argv);
 
 	KsMainWindow ks;
-- 
2.32.0

