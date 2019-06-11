Return-Path: <SRS0=+uc8=UK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45947C43218
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 15:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2411D212F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jun 2019 15:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404185AbfFKPVq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jun 2019 11:21:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52717 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388810AbfFKPVp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jun 2019 11:21:45 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so3420586wms.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jun 2019 08:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8cYpwkxDhXV+UrEIBkKOBklOceWNxHM5PgZ0wLRmIfQ=;
        b=HbD3P8H/jnrr4Z0w9SLo52sh/VBxvzYBFi2YzeyPHXWMVJPVMroXMF5kKURpjPkJjE
         xi5Q79ZAdgHhS9RGOo9s142llFGyfYIt7rPbJhQvKGi7UzxUjcZNlCkOdnnrKaiJqh21
         PEO8zsrmVan26xjsgnZsvniJ0CRS1EzNzQTwIaNvP/9HMbqFnI5jgSBxW1+ZV64xB5Iu
         Ywh4GB0uszCpARj/STJ5Y2xvi3EmOUOmknAHw5pPuEiVbnEUoHNUfjLfWyy5rcKJ35UE
         wKcMp93WUa+ffxqNTHJD4ihbkM8igjXnFEhC+eVpIORotP3a2bugZNgczhc+eJzRwZ7X
         E07A==
X-Gm-Message-State: APjAAAU/ZNN3iRlD4Mz+INEifXlmQzZCXTOhwGSF01Qkk2+uNp6Lck3w
        IZV8PsquTmAE+O1v6qIUoJE=
X-Google-Smtp-Source: APXvYqw/x/buiox4E/3LeTvI0b7J0IA7JEs3uBhyD3KamH0B+ZH5vr3oscSRh71BicyhRy0ZIAJIzQ==
X-Received: by 2002:a1c:1b81:: with SMTP id b123mr17679206wmb.144.1560266503472;
        Tue, 11 Jun 2019 08:21:43 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r2sm2793821wma.26.2019.06.11.08.21.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:21:43 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/2] kernel-shark: Avoid debug build when CMAKE_BUILD_TYPE=Release
Date:   Tue, 11 Jun 2019 18:20:43 +0300
Message-Id: <20190611152043.22572-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611152043.22572-1-ykaradzhov@vmware.com>
References: <20190611152043.22572-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The debug flags by design embed the build paths, but the distro package
binaries should not have such paths embedded in them.

Reported-by: Troy Engel <troyengel@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt | 25 ++++++++++++++++---------
 kernel-shark/README         |  4 ++--
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index d45be20..fe398bb 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -33,8 +33,22 @@ endif (Qt5Widgets_FOUND)
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
-set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -g -pthread -fPIC")
-set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -std=c++11 -pthread -fPIC")
+set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
+set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread -fPIC")
+
+if (NOT CMAKE_BUILD_TYPE MATCHES Release)
+
+    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -g")
+    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
+
+endif (NOT CMAKE_BUILD_TYPE MATCHES Release)
+
+if (NOT CMAKE_BUILD_TYPE MATCHES Debug)
+
+    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -O2")
+    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
+
+endif (NOT CMAKE_BUILD_TYPE MATCHES Debug)
 
 if(NOT _INSTALL_PREFIX)
 	set(_INSTALL_PREFIX "/usr/local")
@@ -47,13 +61,6 @@ set(KS_ICON_FIN    KS_icon_fin.svg)
 set(KS_LOGO        KS_logo_symbol.svg)
 set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
 
-if (NOT _DEBUG)
-
-	set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -O2")
-	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
-
-endif (NOT _DEBUG)
-
 SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
 SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
 
diff --git a/kernel-shark/README b/kernel-shark/README
index 379c390..2027044 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -39,13 +39,13 @@ the original trace-cmd end traceevent libraries.
 as a CMake Command-Line option.
 
 2.1.2 In order to generates complete debug information to be used by GDB add
--D_DEBUG=1 as a CMake Command-Line option.
+-DCMAKE_BUILD_TYPE=Debug as a CMake Command-Line option.
 
 2.1.3 By default, installation prefix is "/usr/local". It can be changed using
 -D_INSTALL_PREFIX= as a CMake Command-Line option.
 
 Example:
-    cmake -D_DOXYGEN_DOC=1 -D_DEBUG=1 -D_INSTALL_PREFIX=/usr ../
+    cmake -D_DOXYGEN_DOC=1 -DCMAKE_BUILD_TYPE=Debug -D_INSTALL_PREFIX=/usr ../
 
 2.2.1 Use "make clean" if you want to delete all already compiled objects.
 
-- 
2.20.1

