Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720049.outbound.protection.outlook.com ([40.107.72.49]:20658
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbeLAAWn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 19:22:43 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/2] tools/lib/traceevent: make few libtraceevent internal
 variables to be per thread
Date: Fri, 30 Nov 2018 13:13:09 +0000
Message-ID: <20181130131254.32621-3-tstoyanov@vmware.com>
References: <20181130131254.32621-1-tstoyanov@vmware.com>
In-Reply-To: <20181130131254.32621-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch continues the effort to transform libtraceevent
into a thread safe library. It converts input_buf, input_buf_ptr
and input_buf_siz internal variables to be thread specific. This
buffer is not related to a specific tep context. It is used
internally by the library during the parsing of various strings.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 8f19dcdd06ec..f6c926467fa3 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -42,9 +42,9 @@
 #include "event-utils.h"
 #include "trace-seq.h"
=20
-static const char *input_buf;
-static unsigned long long input_buf_ptr;
-static unsigned long long input_buf_siz;
+static __thread const char *input_buf;
+static __thread unsigned long long input_buf_ptr;
+static __thread unsigned long long input_buf_siz;
=20
 static int is_flag_field;
 static int is_symbolic_field;
--=20
2.19.1
