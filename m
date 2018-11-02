Return-Path: <SRS0=Mn5y=NN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730056.outbound.protection.outlook.com ([40.107.73.56]:48320
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727744AbeKCAEu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 20:04:50 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/3] tools/lib/traceevent: Fix libtraceevent/Documentation
 Makefile
Date: Fri, 2 Nov 2018 14:57:26 +0000
Message-ID: <20181102145714.25885-2-tstoyanov@vmware.com>
References: <20181102145714.25885-1-tstoyanov@vmware.com>
In-Reply-To: <20181102145714.25885-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes "clean" rule of libtraceevent/Documentation Makefile,
to clean up compiled man pages.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Documentation/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Documentation/Makefile b/tools/lib/tracee=
vent/Documentation/Makefile
index b975080a6705..1b2efdfff246 100644
--- a/tools/lib/traceevent/Documentation/Makefile
+++ b/tools/lib/traceevent/Documentation/Makefile
@@ -174,7 +174,7 @@ endif
 CLEAN_FILES =3D					\
 	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
 	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
-	$(DOC_MAN3)
+	$(DOC_MAN3) *.3
=20
 clean:
 	$(call QUIET_CLEAN, Documentation) $(RM) $(CLEAN_FILES)
--=20
2.17.2
