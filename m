Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bn3nam01on0067.outbound.protection.outlook.com ([104.47.33.67]:34715
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727254AbeJPXo1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:27 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 17/23] kernel-shark-qt: Add PolicyKit Configuration for
 kshark-record
Date: Tue, 16 Oct 2018 15:53:17 +0000
Message-ID: <20181016155232.5257-18-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The PolicyKit Policy Configuration  will allow the kshark-record
executable to be started as Root via pkexec.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 .../org.freedesktop.kshark-record.policy       | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 kernel-shark-qt/org.freedesktop.kshark-record.policy

diff --git a/kernel-shark-qt/org.freedesktop.kshark-record.policy b/kernel-=
shark-qt/org.freedesktop.kshark-record.policy
new file mode 100644
index 0000000..dc73817
--- /dev/null
+++ b/kernel-shark-qt/org.freedesktop.kshark-record.policy
@@ -0,0 +1,18 @@
+<?xml version=3D"1.0" encoding=3D"UTF-8"?>
+<!DOCTYPE policyconfig PUBLIC
+  "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
+  "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
+<policyconfig>
+
+  <action id=3D"org.freedesktop.pkexec.kshark-record">
+    <message gettext-domain=3D"gparted">Authentication is required to run =
KernelShark Record</message>
+    <defaults>
+      <allow_any>auth_admin</allow_any>
+      <allow_inactive>auth_admin</allow_inactive>
+      <allow_active>auth_admin</allow_active>
+    </defaults>
+    <annotate key=3D"org.freedesktop.policykit.exec.path">/usr/local/bin/k=
shark-record</annotate>
+    <annotate key=3D"org.freedesktop.policykit.exec.allow_gui">true</annot=
ate>
+  </action>
+
+</policyconfig>
--=20
2.17.1
