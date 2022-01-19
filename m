Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0736DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 12:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345795AbiASMCo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 07:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiASMCo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 07:02:44 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B8FC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:02:43 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b13so10362403edn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2MsgEH8UOmmaXq9hlueW8ERSGTyNihYMhDAX3WFLX0Q=;
        b=pp6DVF8V+k08UbOhlrZm07Af68rplaDU6r/tmodSx+9s9TdAslk9KXNouj22THU0Bb
         I4B42scxrGZYmVuJjJPRt/C0K2SMcKFcsq2Dm7d0Z0US9t7V4gF8i0XdmVGF+dg/+6Jg
         HFlANSUSHum/PaxrCffclYWYwaoSoxzAEEo6twq4Rxs9J4AZoxVzjhjE+mBCq/WXbNNo
         fkSNwxsqFI4ToNhgeN5KMK1I9/7eKpWEL0vgQgrrx8eTxIygglqGC8FdyWa1R++CxcMY
         FTAm+Cyc6E5H3Pxh9r5ZhKNzB8kOGgGHBfdpHh4sOl6YvFKjKKrPmmGiX8l459ktwa7A
         4DOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2MsgEH8UOmmaXq9hlueW8ERSGTyNihYMhDAX3WFLX0Q=;
        b=07QoX3SpDlxXpunbX72NQUcZvNm+7HJtYtf8eXVV0K5PblWrUIAIfYCuAElprd3KwM
         IkaMDw6Dh18Tdp/qM3/fvU8w9BYI0SWK0WRjVzKPXwG7aY9Wv3SDs3PiHEa/iTNGdssY
         4zWJva6vVFQE7avkgu74iefC4dWf/29jDvU4mAh32RkjTmheEvLE+u6S7sXmSTZ9ENjR
         5BFmO/L1VNY0y0FgMwuLnus+h/WD+odXTHiuR/jkWWTIYOsfjA12V/npxdmqZg08cahu
         HZv8uFwGaoAg3iGsozA1kpFWXdlApcyCsgYN5SSEhC+MGbFbbJnrXY1rkCV9KhMQK+p6
         yOxw==
X-Gm-Message-State: AOAM531oJSacQ5+sUKIru9jkNY19Q1Y5bOF3SB+/YoKq4DcxHwpZMYyp
        8QnnOpwYYoYU9wR/Gyy2b5Pfc75PcTA=
X-Google-Smtp-Source: ABdhPJxIxmzfq2dlrl1fy6rsp8pBD0ly1xV5cpnJP49Xi/KvPLKDN95+4HVbus0fR1kNOUKYl4LUtA==
X-Received: by 2002:a50:ff0e:: with SMTP id a14mr30538359edu.369.1642593762295;
        Wed, 19 Jan 2022 04:02:42 -0800 (PST)
Received: from crow.vmware.com ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id d10sm569491ejt.55.2022.01.19.04.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 04:02:42 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, hongzhan.chen@intel.com,
        jan.kiszka@siemens.com
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH 2/2] kernel-shark: Install missing headers
Date:   Wed, 19 Jan 2022 14:02:29 +0200
Message-Id: <20220119120229.68627-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220119120229.68627-1-y.karadz@gmail.com>
References: <20220119120229.68627-1-y.karadz@gmail.com>
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
 src/CMakeLists.txt         | 11 +++++++++++
 src/plugins/CMakeLists.txt |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 4c26122..3a20458 100644
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
@@ -139,6 +147,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
             DESTINATION ${_INSTALL_PREFIX}/bin/
                 COMPONENT                 kernelshark)
+    install(FILES "${KS_DIR}/src/KsPluginsGUI.hpp"
+            DESTINATION ${KS_INCLUDS_DESTINATION}
+                COMPONENT libkshark-devel)
 
     add_subdirectory(plugins)
     set(PLUGINS ${PLUGINS} PARENT_SCOPE)
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

