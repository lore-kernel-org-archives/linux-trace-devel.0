Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37924C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 08:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiBPI3n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 03:29:43 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiBPI3m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 03:29:42 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F8429C139
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 00:29:31 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id vz16so2954409ejb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 00:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c050Hww4AE5ncKSfZTga89giUcEJFB49JJ2OSOQdTBo=;
        b=cwMSgL3Qe1WSeu27035l06Xm9TI3KpZayV2yXrZWo949HRwybaFW0t7obB2CiVmab7
         rQicyOtkud03bpu1pV59Poq5UrjvAFgBOplRb2su06dyNlp9GZ+bnOFzO7jF7+eBzaU/
         wU6XsRhyhtegH59r2W3JeYRiVKo++RVe9ywON5sUrlCr8DJ7W8woGJ+mUySNMZ9Kx52/
         miPZ4lyQeOoZRG1sBKpcHMDnZ9rv1s/ksof7VZoBloNYWq8RrolMdYe6wobVr3uNNB4j
         uT3tAbA/cshqBTdcWxEDukmv0XHp6KPoZjWuaCQ9uqJOiY2qHxgO0YkHCyBQRPCxFq4r
         SYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c050Hww4AE5ncKSfZTga89giUcEJFB49JJ2OSOQdTBo=;
        b=unArHKH5jKGBM9vXdn3xygmusUZXmKUx/Vpq/ToMhRfUBkV0bQI1FDlZQXRdLkIxMs
         wVf/xkNX/MVfraSpDUzpTDrBVqE0ILbR4il4RKl/NgxK/3qqeafYLEVqTp4kP0qgBswd
         JyqdDdUu0nTlfVJuukwIOAzKWPWfY73T9ozuiybx5zmRpIQq7Mg6LaDVB4zU2y0gvxdW
         ndaWtqDcVHROGTAXPRKdiS5Fqq3xosco+O+sSaTmWzY3A8rprLxsaeAC6Tmk+qb5Uaq3
         oRXPeHcwcPBQnCFZBlwTzxuCM1ryd+Urg3O29LeX4d9eydH7466iLfwiNzh/J4yOKrM0
         Qp5A==
X-Gm-Message-State: AOAM532p1bSiCGO58P7fKQQPyWQ14ucTxHdGkp719Tg/7ODxMnFQmcGP
        ThslT3+SoLfbfPa7/Bq/r9+mYOkp1Qo=
X-Google-Smtp-Source: ABdhPJx2OCNlzE/CWYA8N6og+WHQaXi0I6fBw1J5i8bEPsYYTG4aS/f8f8QatIboSoh+G0UDfPbyRg==
X-Received: by 2002:a17:906:d206:b0:6b8:f35c:d7a with SMTP id w6-20020a170906d20600b006b8f35c0d7amr1367807ejz.122.1645000169460;
        Wed, 16 Feb 2022 00:29:29 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id v18sm2592998ejk.125.2022.02.16.00.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:29:28 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     hongzhan.chen@intel.com, jan.kiszka@siemens.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Add KsPluginsGUI.hpp/.cpp
Date:   Wed, 16 Feb 2022 10:29:08 +0200
Message-Id: <20220216082909.614231-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220216082909.614231-1-y.karadz@gmail.com>
References: <20220216082909.614231-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we will place all GUI-related APIs that will be exposed to
the external plugins. For the moment we add only two such APIs
that will allow the plugins to manipulate the markers.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt   |  5 +++++
 src/KsPluginsGUI.cpp | 27 +++++++++++++++++++++++++++
 src/KsPluginsGUI.hpp | 22 ++++++++++++++++++++++
 3 files changed, 54 insertions(+)
 create mode 100644 src/KsPluginsGUI.cpp
 create mode 100644 src/KsPluginsGUI.hpp

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index fbf3819..0ee62c8 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -105,6 +105,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                                                             KsTraceGraph.cpp
                                                             KsTraceViewer.cpp
                                                             KsMainWindow.cpp
+                                                            KsPluginsGUI.cpp
                                                             KsCaptureDialog.cpp
                                                             KsQuickContextMenu.cpp
                                                             KsAdvFilteringDialog.cpp)
@@ -147,6 +148,10 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
             DESTINATION ${_INSTALL_PREFIX}/bin/
                 COMPONENT                 kernelshark)
 
+    install(FILES "${KS_DIR}/src/KsPluginsGUI.hpp"
+            DESTINATION ${KS_INCLUDS_DESTINATION}
+                COMPONENT libkshark-devel)
+
     add_subdirectory(plugins)
     set(PLUGINS ${PLUGINS} PARENT_SCOPE)
 
diff --git a/src/KsPluginsGUI.cpp b/src/KsPluginsGUI.cpp
new file mode 100644
index 0000000..a964510
--- /dev/null
+++ b/src/KsPluginsGUI.cpp
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright 2022 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+  *  @file    KsPluginsGUI.cpp
+  *  @brief   KernelShark C++ plugin declarations.
+  */
+
+// KernelShark
+#include "KsPluginsGUI.hpp"
+#include "KsMainWindow.hpp"
+#include "KsDualMarker.hpp"
+
+void markEntryA(void *ks_ptr, const kshark_entry *e)
+{
+	KsMainWindow *ks = static_cast<KsMainWindow *>(ks_ptr);
+	ks->markEntry(e, DualMarkerState::A);
+}
+
+void markEntryB(void *ks_ptr, const kshark_entry *e)
+{
+	KsMainWindow *ks = static_cast<KsMainWindow *>(ks_ptr);
+	ks->markEntry(e, DualMarkerState::B);
+}
diff --git a/src/KsPluginsGUI.hpp b/src/KsPluginsGUI.hpp
new file mode 100644
index 0000000..808a951
--- /dev/null
+++ b/src/KsPluginsGUI.hpp
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright 2022 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+/**
+  *  @file    KsPluginsGUI.hpp
+  *  @brief   KernelShark C++ plugin declarations.
+  */
+
+#ifndef _KS_PLUGINS_GUI_H
+#define _KS_PLUGINS_GUI_H
+
+// KernelShark
+#include "libkshark.h"
+
+void markEntryA(void *ks_ptr, const kshark_entry *e);
+
+void markEntryB(void *ks_ptr, const kshark_entry *e);
+
+#endif
-- 
2.32.0

