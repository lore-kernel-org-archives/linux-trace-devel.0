Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bn3nam01on0067.outbound.protection.outlook.com ([104.47.33.67]:34715
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPXo2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:28 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 19/23] kernel-shark-qt: Add kernelshark.desktop file
Date: Tue, 16 Oct 2018 15:53:19 +0000
Message-ID: <20181016155232.5257-20-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

Instruct CMake to generate kernelshark.desktop. This file is used to
add the KernelShark application in the desktop menus.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt         | 3 +++
 kernel-shark-qt/build/cmake_clean.sh   | 1 +
 kernel-shark-qt/build/ks.desktop.cmake | 9 +++++++++
 3 files changed, 13 insertions(+)
 create mode 100644 kernel-shark-qt/build/ks.desktop.cmake

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.tx=
t
index 0ccb61e..278241b 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -75,4 +75,7 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
=20
 endif ()
=20
+configure_file( ${KS_DIR}/build/ks.desktop.cmake
+                ${KS_DIR}/kernelshark.desktop)
+
 message("")
diff --git a/kernel-shark-qt/build/cmake_clean.sh b/kernel-shark-qt/build/c=
make_clean.sh
index 4f984db..ea04dc0 100755
--- a/kernel-shark-qt/build/cmake_clean.sh
+++ b/kernel-shark-qt/build/cmake_clean.sh
@@ -6,6 +6,7 @@ rm -rf CMakeFiles/
 rm -rf src/
 rm -rf examples/
 rm -f ../lib/*
+rm ../kernelshark.desktop
 rm -f ../src/KsCmakeDef.hpp
 rm -f CMakeDoxyfile.in
 rm -f CMakeDoxygenDefaults.cmake
diff --git a/kernel-shark-qt/build/ks.desktop.cmake b/kernel-shark-qt/build=
/ks.desktop.cmake
new file mode 100644
index 0000000..0b947f1
--- /dev/null
+++ b/kernel-shark-qt/build/ks.desktop.cmake
@@ -0,0 +1,9 @@
+[Desktop Entry]
+Version=3D@KS_VERSION_STRING@
+Type=3DApplication
+Name=3DKernel Shark
+GenericName=3DKernel Shark
+Comment=3D
+Exec=3D/usr/local/bin/kernelshark
+Icon=3D@KS_DIR@/icons/ksharkicon.png
+Terminal=3Dfalse
--=20
2.17.1
