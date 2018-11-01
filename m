Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810041.outbound.protection.outlook.com ([40.107.81.41]:1377
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbeKBGua (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:30 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 5/8] kernel-shark-qt: Fix bug when loading plugins from
 session
Date: Thu, 1 Nov 2018 21:45:42 +0000
Message-ID: <20181101214512.18684-6-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The session description file may contain plugins which are not available
at the moment when the session is loaded. These can be user-defined
plugins for example. The modification of the code introduced by this
patch deals with such a case.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsSession.cpp | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel-shark-qt/src/KsSession.cpp b/kernel-shark-qt/src/KsSess=
ion.cpp
index 6cd1403..b7ef81c 100644
--- a/kernel-shark-qt/src/KsSession.cpp
+++ b/kernel-shark-qt/src/KsSession.cpp
@@ -545,7 +545,10 @@ void KsSession::loadPlugins(kshark_context *kshark_ctx=
, KsPluginManager *pm)
 {
 	kshark_config_doc *plugins =3D kshark_config_alloc(KS_CONFIG_JSON);
 	json_object *jplugins, *jlist, *jpl;
-	int length;
+	const char *pluginName;
+	QVector<int> pluginIds;
+	int length, index;
+	bool loaded;
=20
 	if (!kshark_config_doc_get(_config, "Plugins", plugins) ||
 	    !kshark_type_check(plugins, "kshark.config.plugins"))
@@ -562,13 +565,13 @@ void KsSession::loadPlugins(kshark_context *kshark_ct=
x, KsPluginManager *pm)
 		length =3D json_object_array_length(jlist);
 		for (int i =3D 0; i < length; ++i) {
 			jpl =3D json_object_array_get_idx(jlist, i);
-			pm->_ksPluginList[i] =3D
-				json_object_get_string(json_object_array_get_idx(jpl, 0));
-
-			pm->_registeredKsPlugins[i] =3D
-				json_object_get_boolean(json_object_array_get_idx(jpl, 1));
+			pluginName =3D json_object_get_string(json_object_array_get_idx(jpl, 0)=
);
+			index =3D pm->_ksPluginList.indexOf(pluginName);
+			loaded =3D json_object_get_boolean(json_object_array_get_idx(jpl, 1));
+			if (index >=3D 0 && loaded)
+				pluginIds.append(index);
 		}
 	}
=20
-	pm->registerFromList(kshark_ctx);
+	pm->updatePlugins(pluginIds);
 }
--=20
2.17.1
