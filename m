Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51708C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 11:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiA0LLX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 06:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiA0LLW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 06:11:22 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A3AC061714
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 03:11:22 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id s5so5074360ejx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 03:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=USQ37QhlVMABhMLY3x7luE999tVTLIXv6aAbPy6/kbQ=;
        b=bqcwnuXVw8xI5iMEv2rxX1wR9WUORO6LRTbqspJbO6VN02arD4tVDAsJJL2U+zoz2B
         Pnsbd3NCdfIRvhNxCCZsoH7NYtGsm+Op1oOHqJMBJCXTu8qUjJYzO1fH46ZZvLeBmlmz
         EKTDLsik1HZ6CgEjbr3QgiCwoxrZxY5IoMCWYRGBjqO68ZjvfaUYYTdzTyCmH1e6NIEq
         4S6CPkcy7VGW+xt3YZJAuLe9h5iF2YGiaelnPuuwrLP5fjTIbRABUhsvWfxKCUbbKrm5
         AG8y5LqYmLzqBeFHsg0BEgY5NMlrZ2yvKWkjwTwZEGLEna7m69M8gEoceoAUSmJeSIZx
         MrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=USQ37QhlVMABhMLY3x7luE999tVTLIXv6aAbPy6/kbQ=;
        b=7R35OByl+sfvJVc7+PfYBnpjkH50nd53SO24SZS08ID6cHICIp7Rrd/ZZo5NWp16wF
         rn41Os2TRB7RG3KWi2554fw1HpCdva7b8uwLXEg1QrIJCeLHFl43tYCjUnNU5SqhSYIu
         ahPkbXY4ChtZI1JqZZEhMTSfJRkLA2oEDfrFtH217ee5ZO5xZmu2pMv4JN5CXP03C1Wt
         VBo5bg4KaReLQhgSSlvJMNP1S1vOTKWbDFc0neuh1ZvVL3q0KE//o5hld3uUOao0Nkq6
         XmooznLx0M9MIZ3Wzbgla75Pfv5BChzFBEn6wSqB9ItwMCFQ0KLHjg9liq1sNZZlzbg0
         ZcFw==
X-Gm-Message-State: AOAM532Ko5w+/a5XrPQewyPZjWCi1c8QzqBgmDuENduBzD8cFadn5LhS
        mn+Mv4nSr6WEtGCFR30BVTvs0LNZX5M=
X-Google-Smtp-Source: ABdhPJzbI8ZfHiPGrtQTEB/uFlg3iy1tKmtBkjeL9CWecm54/wzNoqXEHJ3TJzkBUpey0MbHN4Todg==
X-Received: by 2002:a17:906:58d4:: with SMTP id e20mr2462394ejs.769.1643281880903;
        Thu, 27 Jan 2022 03:11:20 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id bf21sm11160418edb.2.2022.01.27.03.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 03:11:20 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] kernel-shark: Install missing headers
Date:   Thu, 27 Jan 2022 13:11:10 +0200
Message-Id: <20220127111110.272289-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Building an external plugin that uses libkshark-plot and libkshark-gui
libraries haven't been realy tested so far. It turns that headers that
are required in order to do this are not installed. The installation of
those headers is made part of the 'libkshark-devel' component.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---

Changes in v2:
 - Making this a stand-alone patch

 src/CMakeLists.txt         | 8 ++++++++
 src/plugins/CMakeLists.txt | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 9e0b4ae..fbf3819 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -67,6 +67,14 @@ if (OPENGL_FOUND)
             LIBRARY DESTINATION    ${_LIBDIR}
                 COMPONENT              kernelshark)
 
+    install(FILES "${KS_DIR}/src/stb_truetype.h"
+                  "${KS_DIR}/src/libkshark-plot.h"
+                  "${KS_DIR}/src/KsPlotTools.hpp"
+                  "${KS_DIR}/src/KsPlugins.hpp"
+                  "${KS_DIR}/src/KsCmakeDef.hpp"
+            DESTINATION ${KS_INCLUDS_DESTINATION}
+                COMPONENT libkshark-devel)
+
 endif (OPENGL_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 3e170fa..e9d9068 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -69,4 +69,8 @@ install(TARGETS ${PLUGIN_LIST}
         LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX}
         COMPONENT kernelshark)
 
+install(FILES "${KS_DIR}/src/plugins/common_sched.h"
+        DESTINATION "${KS_INCLUDS_DESTINATION}/plugins"
+            COMPONENT libkshark-devel)
+
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
-- 
2.32.0

