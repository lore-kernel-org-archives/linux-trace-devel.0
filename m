Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3ABC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B7164F4F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 16:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhCQQuw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:50:52 -0400
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:43697 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhCQQuW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 12:50:22 -0400
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id D1399422F0;
        Wed, 17 Mar 2021 17:50:20 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id 5LF19gJOJ6US; Wed, 17 Mar 2021 17:50:18 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id 5A3F34259B;
        Wed, 17 Mar 2021 17:41:22 +0100 (CET)
Received: (nullmailer pid 30939 invoked by uid 1000);
        Wed, 17 Mar 2021 16:41:21 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Michal Sojka <michal.sojka@cvut.cz>
Subject: [PATCH 3/4] kernel-shark: Allow installing polkit policy separately
Date:   Wed, 17 Mar 2021 17:41:00 +0100
Message-Id: <20210317164101.30848-4-michal.sojka@cvut.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317164101.30848-1-michal.sojka@cvut.cz>
References: <20210317164101.30848-1-michal.sojka@cvut.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For a polkit policy to be found by polkit daemon, it must be installed
to a single system-wide location, typically /usr/share/polkit-1/actions.
CMakeLists file reflects that and always installs the policy under /usr.
But when one wants to install kernel-shark to a non-standard location,
e.g., by configuring it as follows:

    cmake -D_INSTALL_PREFIX=$HOME ...

then "make install" fails, with the following error:

    CMake Error at src/cmake_install.cmake:225 (file):
      file INSTALL cannot copy file
      "/home/user/src/trace-cmd/kernel-shark/org.freedesktop.kshark-record.policy"
      to "/usr/share/polkit-1/actions/org.freedesktop.kshark-record.policy".

This commit fixes that by changing two things:
- custom location where to install polkit policy can be specified via
  cmake command line argument -D_POLKIT_INSTALL_PREFIX=... This will
  also help distributions where polkit is configured with different
  prefix than /usr.
- polkit policy is now a separate cmake component, which can be
  installed separately from the rest.

The later allows generating better messages for the user to understand
that the failed polkit policy installation is not a critical error.

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
---
 CMakeLists.txt       |  6 ++++++
 build/install_gui.sh | 10 +++++++++-
 src/CMakeLists.txt   |  4 ++--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c4731c1..94023a8 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -36,6 +36,12 @@ elseif (NOT _LIBDIR)
 
 endif ()
 
+if (NOT _POLKIT_INSTALL_PREFIX)
+
+    set(_POLKIT_INSTALL_PREFIX "/usr")
+
+endif ()
+
 set(CMAKE_MODULE_PATH "${KS_DIR}/build")
 find_package(TraceEvent REQUIRED)
 find_package(TraceFS    REQUIRED)
diff --git a/build/install_gui.sh b/build/install_gui.sh
index 1583fb9..d262f79 100755
--- a/build/install_gui.sh
+++ b/build/install_gui.sh
@@ -1 +1,9 @@
-sudo cmake -DCOMPONENT=kernelshark -P cmake_install.cmake
+if sudo cmake -DCOMPONENT=kernelshark -P cmake_install.cmake; then
+    echo "Kernelshark installed correctly"
+else
+    exit 1
+fi
+
+if ! sudo cmake -DCOMPONENT=polkit-policy -P cmake_install.cmake; then
+    echo >&2 "Warning: polkit policy not installed"
+fi
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index b81d7d9..b557eb7 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -127,8 +127,8 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                 COMPONENT                 kernelshark)
 
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
-            DESTINATION /usr/share/polkit-1/actions/
-                COMPONENT                 kernelshark)
+            DESTINATION ${_POLKIT_INSTALL_PREFIX}/share/polkit-1/actions/
+                COMPONENT                 polkit-policy)
 
     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
             DESTINATION ${_INSTALL_PREFIX}/bin/
-- 
2.30.1

