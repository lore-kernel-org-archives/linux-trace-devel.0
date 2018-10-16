Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bn3nam01on0082.outbound.protection.outlook.com ([104.47.33.82]:21632
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPXph (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:45:37 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 22/23] kernel-shark-qt: Workaround for running as Root on
 Wayland
Date: Tue, 16 Oct 2018 15:53:23 +0000
Message-ID: <20181016155232.5257-23-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

The Record dialog requires Root privileges in order to be able to collect
tracing data. However graphical applications cannot be run as root on
Wayland. The problem is worked around by wrapping the kshark-record
executable in a shell script which checks the XDG_SESSION_TYPE and in
the case of Wayland, allows the root user to access the running
X server.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/bin/kshark-su-record | 8 ++++++++
 kernel-shark-qt/src/CMakeLists.txt   | 3 +++
 2 files changed, 11 insertions(+)
 create mode 100755 kernel-shark-qt/bin/kshark-su-record

diff --git a/kernel-shark-qt/bin/kshark-su-record b/kernel-shark-qt/bin/ksh=
ark-su-record
new file mode 100755
index 0000000..ee839a2
--- /dev/null
+++ b/kernel-shark-qt/bin/kshark-su-record
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+if [ $XDG_SESSION_TYPE =3D "wayland" ]
+then
+    xhost +si:localuser:root &>/dev/null
+fi
+
+pkexec kshark-record -o ${PWD}/trace.dat
diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 2592094..ef0aa71 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -83,6 +83,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
             DESTINATION /usr/share/polkit-1/actions/)
=20
+    install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
+            DESTINATION /usr/local/bin/)
+
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
 add_subdirectory(plugins)
--=20
2.17.1
