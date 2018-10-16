Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0072.outbound.protection.outlook.com ([104.47.37.72]:24316
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbeJPXpD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:45:03 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 20/23] kernel-shark-qt: Add make install
Date: Tue, 16 Oct 2018 15:53:21 +0000
Message-ID: <20181016155232.5257-21-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

Define CMake installation rules for kernel-shark-qt project.
Add a script for uninstalling.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt             |  3 +++
 kernel-shark-qt/build/cmake_uninstall.sh   | 17 +++++++++++++++++
 kernel-shark-qt/src/CMakeLists.txt         | 10 ++++++++++
 kernel-shark-qt/src/plugins/CMakeLists.txt |  3 +++
 4 files changed, 33 insertions(+)
 create mode 100755 kernel-shark-qt/build/cmake_uninstall.sh

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.tx=
t
index 278241b..767bec9 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -46,6 +46,9 @@ if (NOT _DEBUG)
=20
 endif (NOT _DEBUG)
=20
+SET(CMAKE_INSTALL_RPATH "/usr/local/lib/kshark/")
+SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
+
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
diff --git a/kernel-shark-qt/build/cmake_uninstall.sh b/kernel-shark-qt/bui=
ld/cmake_uninstall.sh
new file mode 100755
index 0000000..50c163b
--- /dev/null
+++ b/kernel-shark-qt/build/cmake_uninstall.sh
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+CYAN=3D'\033[0;36m'
+PURPLE=3D'\033[0;35m'
+NC=3D'\033[0m' # No Color
+
+if [[ $EUID -ne 0 ]]; then
+   echo -e "${PURPLE}Permission denied${NC}" 1>&2
+   exit 100
+fi
+
+if [ -e install_manifest.txt ]
+then
+    echo -e "${CYAN}Uninstall the project...${NC}"
+    xargs rm -v < install_manifest.txt
+    rm -f install_manifest.txt
+fi
diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 6819f86..2592094 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -73,6 +73,16 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     add_executable(kshark-record        kshark-record.cpp)
     target_link_libraries(kshark-record kshark-gui)
=20
+    install(TARGETS kernelshark kshark-record kshark kshark-plot kshark-gu=
i
+            RUNTIME DESTINATION /usr/local/bin/
+            LIBRARY DESTINATION /usr/local/lib/kshark/)
+
+    install(FILES "${KS_DIR}/kernelshark.desktop"
+            DESTINATION /usr/share/applications/)
+
+    install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
+            DESTINATION /usr/share/polkit-1/actions/)
+
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
 add_subdirectory(plugins)
diff --git a/kernel-shark-qt/src/plugins/CMakeLists.txt b/kernel-shark-qt/s=
rc/plugins/CMakeLists.txt
index 88fd93c..2d7251d 100644
--- a/kernel-shark-qt/src/plugins/CMakeLists.txt
+++ b/kernel-shark-qt/src/plugins/CMakeLists.txt
@@ -24,4 +24,7 @@ BUILD_PLUGIN(NAME sched_events
 list(APPEND PLUGIN_LIST "sched_events default") # This plugin will be load=
ed by default
 # list(APPEND PLUGIN_LIST "sched_events") # This plugin isn't loaded by de=
fault
=20
+install(TARGETS sched_events
+        LIBRARY DESTINATION /usr/local/lib/kshark/)
+
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
--=20
2.17.1
