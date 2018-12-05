Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710054.outbound.protection.outlook.com ([40.107.71.54]:10064
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727195AbeLEJV5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:21:57 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 6/6] tools lib traceevent: Install trace-seq.h API header file
Date: Wed, 5 Dec 2018 09:21:53 +0000
Message-ID: <20181205092134.2214-7-tstoyanov@vmware.com>
References: <20181205092134.2214-1-tstoyanov@vmware.com>
In-Reply-To: <20181205092134.2214-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch installs trace-seq.h header file on "make install".

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181130154647.176265533@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index efbd83d..4f9355d 100644
--- a/Makefile
+++ b/Makefile
@@ -376,6 +376,7 @@ install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
 	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedi=
r_libtrace_SQ))
+	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_=
libtrace_SQ))
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_t=
c_SQ))
=20
 doc:
--=20
2.19.2
