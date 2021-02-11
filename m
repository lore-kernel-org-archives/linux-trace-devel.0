Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF70C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6591264E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBKKjz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhBKKgT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:36:19 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA04C0611C1
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:48 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w2so9208953ejk.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zj1DNil3jwdXpEyehXx8Fo3ynzMWgMuMAEs4HlY43MY=;
        b=T7/COb2c+DJ5kjaxNLDAorOQIiKHLD4Lj/mLHOb9momyCsQx+bkzcsSkm5hcc1ZVbP
         SjHA5/AbronaKbt3O1pKxmi6471LJqLuGyQUxR8R3P+IAUL+t32OmZTgrEPcsrVXhok0
         9msJjXJNQgsJFcDd1ZJtWahv4dBumSwzwO6FBp9dRtqULhfOrQWA0MLsgqlRrkMK0oop
         i4ukd6JPbjp28o5jVLK0+fsszQoAIEbYvZZNoFL0ZG+BIc3XEg7hZOpw3Qrxbmd8/g87
         TAw36uzAySplVBREomSYWSFZG+rJ5/lBWUwKtQCXKSqNKrdATXtDfRmudfWrMf/ycURX
         D0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zj1DNil3jwdXpEyehXx8Fo3ynzMWgMuMAEs4HlY43MY=;
        b=WepT0QEhuD8zVJHXeJxkTXkD08ORQ0zcTdRFz+zvHg05i+B09N0RnqBkC8qqQ5wwjq
         nxcbZxWwYoOfLiEPuWnhCjQJ2x826f1N7zeF/zsE0VZAXJGjF9KOgsO87EoxVdcwgXNa
         bHEi9dGahgYA+w7IXbe+LP5u4YTegAcKpPaAgY+aOJ1VJYqw74iX8LGl9ro4yry1Q4qe
         BwoUSmV1gBpyHS3pYupY86XPQp1wAWz7Uq+UmTGeSkbqmNPenC5xy64d/xC7Fdez8A90
         Y8Gb0Sia1YAfnxMXfa0hM6OB+9fCpvx2VYvW9tOr3RGAv7A3f9sB3/1J5BiQ0wsJG15p
         jHaw==
X-Gm-Message-State: AOAM530ToYXzdIAfTEVrwtWAFLOVljFsYJW6cImO2ZqzROA5b+D5ILje
        tipsydHtaRgDJnybbYdfCok=
X-Google-Smtp-Source: ABdhPJyzKqqvTqeYwlPKHBZ2Uea05vXfjZ1ZVOHeVP3U7Y0mbEEpq958GhC5o+YLsoz+uEhvpgbJJw==
X-Received: by 2002:a17:906:80b:: with SMTP id e11mr7780660ejd.269.1613039567005;
        Thu, 11 Feb 2021 02:32:47 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:46 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 26/27] kernel-shark: Add pkg-config configuration for libkshark
Date:   Thu, 11 Feb 2021 12:32:04 +0200
Message-Id: <20210211103205.418588-27-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add auto-generated pkg-config setup file to install for pkg-config.
To be used for building against libkshark.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt           |  3 +++
 build/cmake_clean.sh     |  1 +
 build/libkshark.pc.cmake | 10 ++++++++++
 src/CMakeLists.txt       |  6 ++++++
 4 files changed, 20 insertions(+)
 create mode 100644 build/libkshark.pc.cmake

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8ca33fd..efcccb1 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -167,4 +167,7 @@ configure_file(${KS_DIR}/build/ks.desktop.cmake
 configure_file(${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
                ${KS_DIR}/org.freedesktop.kshark-record.policy)
 
+configure_file(${KS_DIR}/build/libkshark.pc.cmake
+               ${KS_DIR}/libkshark.pc @ONLY)
+
 message("")
diff --git a/build/cmake_clean.sh b/build/cmake_clean.sh
index 2ca1136..d645c32 100755
--- a/build/cmake_clean.sh
+++ b/build/cmake_clean.sh
@@ -12,6 +12,7 @@ rm -rf Testing/
 rm -f ../tests/*.dat
 rm -f ../lib/*
 rm ../kernelshark.desktop
+rm ../libkshark.pc
 rm ../org.freedesktop.kshark-record.policy
 rm -f ../src/KsCmakeDef.hpp
 rm -f CMakeDoxyfile.in
diff --git a/build/libkshark.pc.cmake b/build/libkshark.pc.cmake
new file mode 100644
index 0000000..ad4ce34
--- /dev/null
+++ b/build/libkshark.pc.cmake
@@ -0,0 +1,10 @@
+prefix=@_INSTALL_PREFIX@
+libdir=@_LIBDIR@
+includedir=${prefix}/include/@KS_APP_NAME@
+
+Name: libkshark
+URL: https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
+Description: Library for accessing ftrace file system
+Version: @KS_VERSION_STRING@
+Cflags: -I${includedir}
+Libs: -L${libdir} -lkshark
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 4158901..6a6eda1 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -133,6 +133,12 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
             DESTINATION ${_INSTALL_PREFIX}/bin/
                 COMPONENT                 kernelshark)
 
+    execute_process(COMMAND  bash "-c" "pkg-config --variable pc_path pkg-config | cut -f 1 -d: -z"
+                    OUTPUT_VARIABLE PKG_CONGIG_DIR)
+    install(FILES "${KS_DIR}/libkshark.pc"
+            DESTINATION ${PKG_CONGIG_DIR}
+                COMPONENT                 libkshark-devel)
+
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
 
 add_subdirectory(plugins)
-- 
2.25.1

