Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810077.outbound.protection.outlook.com ([40.107.81.77]:14518
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727735AbeKIXR4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 18:17:56 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools/lib/traceevent: libtraceevent Makefile "help" target
Date: Fri, 9 Nov 2018 13:37:12 +0000
Message-ID: <20181109133654.27598-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds a new target to the traceevent Makefile - "help".
"make help" prints a description of all targets, supported by
the Makefile.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Makefile | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3764e003d1cc..0853861d0cd2 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -326,6 +326,21 @@ doc-install:
 doc-uninstall:
 	$(call descend,Documentation,uninstall)
=20
+help:
+	@echo 'Possible targets:'
+	@echo''
+	@echo '  all                 - default, compile the library and the'\
+	 			      'plugins'
+	@echo '  plugins             - compile the plugins'
+	@echo '  install             - install the library, the plugins,'\
+					'the header and pkgconfig files'
+	@echo '  clean               - clean the library and the plugins object f=
iles'
+	@echo '  doc                 - compile the documentation files - man'\
+					'and html pages, in the Documentation directory'
+	@echo '  doc-clean           - clean the documentation files'
+	@echo '  doc-install         - install the man pages'
+	@echo '  doc-uninstall       - uninstall the man pages'
+	@echo''
 PHONY +=3D force plugins
 force:
=20
--=20
2.17.2
