Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0045.outbound.protection.outlook.com ([104.47.37.45]:45184
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727794AbeKIXM3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 18:12:29 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 01/11] tools/lib/traceevent: Fix
 libtraceevent/Documentation Makefile
Date: Fri, 9 Nov 2018 13:31:47 +0000
Message-ID: <20181109133135.25804-2-tstoyanov@vmware.com>
References: <20181109133135.25804-1-tstoyanov@vmware.com>
In-Reply-To: <20181109133135.25804-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

As libtraceevent/Documentation Makefile and all XLS files were taken
from tools/perf/Documentation, and modified for libtraceevent, this patch
adds a note on the top of the Makefile to state it. It also fixes the "clea=
n"
rule, to clean up compiled man pages.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Documentation/Makefile | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Documentation/Makefile b/tools/lib/tracee=
vent/Documentation/Makefile
index b975080a6705..8a4693571cef 100644
--- a/tools/lib/traceevent/Documentation/Makefile
+++ b/tools/lib/traceevent/Documentation/Makefile
@@ -1,6 +1,9 @@
 include ../../../scripts/Makefile.include
 include ../../../scripts/utilities.mak
=20
+# This Makefile and manpage XSL files were taken from tools/perf/Documenta=
tion=20
+# and modified for libtraceevent.
+
 MAN3_TXT=3D \
 	$(wildcard libtraceevent-*.txt) \
 	libtraceevent.txt
@@ -174,7 +177,7 @@ endif
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
