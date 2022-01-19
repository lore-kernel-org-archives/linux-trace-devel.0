Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C7DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 12:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345778AbiASMCn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 07:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiASMCn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 07:02:43 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03F4C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:02:42 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c24so7725067edy.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R64BNmNwR/3RwuC6cXtolfCwzSJi0QnIOjrCeXNU4Ho=;
        b=KjLA7UXu/jWtk0hKDHFDsJ8++1qcSsTtQ69+UaeUHE3rnY5g7CmKy3NAKtSGBQCWBo
         GlWYPgyM2iX2NEmG4MCdaX6MN6Vz3EVLYfu1AXJgQs+bfs1RRuLEMCTE4B7VIuI73r/j
         s6eQwG7ypUoGCqeMQ9hLQXY0hcOaqYv+MeVU+cC+xfeZmL/IlS2VFqUKwzvwYgr64QnD
         6T8qfOKVwiVGyBQBVyKX1zI6qKWV7p9nslOhhnvjZrSVwbigMdEg4idgJ+qDve/tIHzv
         qqugMpBsv39Yu4i1bZ/pDqKQJ5w9kx+Az5Fflv8HVRL5XlBwUJ1h+icBxVnNhnFCC4rq
         3zxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R64BNmNwR/3RwuC6cXtolfCwzSJi0QnIOjrCeXNU4Ho=;
        b=Ts3OmmmXimCFDwJlS2Lyh/fD4WRUDeP5FOtZPs5O01WxXnlcDuyK6QfpqsNoxeKbfZ
         /cmCpANfK9u0O/OpU2/zxVmHtxTxOolxMenS16FvRh7YNc5mA6Tc9+ogFAhF7o5N9X14
         E+yWqneNyREJ88IIBj06YjUI3PVXijmnGj0JLMKMXHnfPQWIjMdXTZrk9cylHVp0AZ31
         oXaBD5ZeZWeSyNiIAwIjvxaK8E8oH2HR2sJUN/lO8HbF95DEA9ZDHF88dgfXaC12iujl
         UJRgsH9W0PDz+Y2J02iHrTldiNQJv6EsVi/1HEZXFim34lgAuPS45D/oIBfb152u9Q5W
         ibcw==
X-Gm-Message-State: AOAM530ywP46TLCIHl6IRhZQV2NX/F071PBBiNoz/RqX+/gpCjFC9c2N
        fz70DaSj98N0af1pWhBNiC8oMB05EWE=
X-Google-Smtp-Source: ABdhPJwN8ONrDHVMZVRh1lzD1ab6zOd7dEEmVt/AzA6Sqmy6AqO6jYBMHc9gm20Q/GyttanfNt53rg==
X-Received: by 2002:a17:907:72c5:: with SMTP id du5mr12953149ejc.210.1642593761378;
        Wed, 19 Jan 2022 04:02:41 -0800 (PST)
Received: from crow.vmware.com ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id d10sm569491ejt.55.2022.01.19.04.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 04:02:41 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, hongzhan.chen@intel.com,
        jan.kiszka@siemens.com
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH 1/2] kernel-shark: Add KsPluginsGUI.hpp/.cpp
Date:   Wed, 19 Jan 2022 14:02:28 +0200
Message-Id: <20220119120229.68627-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220119120229.68627-1-y.karadz@gmail.com>
References: <20220119120229.68627-1-y.karadz@gmail.com>
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
 src/CMakeLists.txt   |  1 +
 src/KsPluginsGUI.cpp | 27 +++++++++++++++++++++++++++
 src/KsPluginsGUI.hpp | 22 ++++++++++++++++++++++
 3 files changed, 50 insertions(+)
 create mode 100644 src/KsPluginsGUI.cpp
 create mode 100644 src/KsPluginsGUI.hpp

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 9e0b4ae..4c26122 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -97,6 +97,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                                                             KsTraceGraph.cpp
                                                             KsTraceViewer.cpp
                                                             KsMainWindow.cpp
+                                                            KsPluginsGUI.cpp
                                                             KsCaptureDialog.cpp
                                                             KsQuickContextMenu.cpp
                                                             KsAdvFilteringDialog.cpp)
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

