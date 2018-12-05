Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710060.outbound.protection.outlook.com ([40.107.71.60]:45856
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727103AbeLEJWQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:22:16 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/2] tools/lib/traceevent: make few libtraceevent internal
 variables to be per thread
Date: Wed, 5 Dec 2018 09:22:14 +0000
Message-ID: <20181205092200.2291-3-tstoyanov@vmware.com>
References: <20181205092200.2291-1-tstoyanov@vmware.com>
In-Reply-To: <20181205092200.2291-1-tstoyanov@vmware.com>
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
 lib/traceevent/event-parse.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index cacdcc4..1cab1a5 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -28,9 +28,9 @@
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
2.19.2
