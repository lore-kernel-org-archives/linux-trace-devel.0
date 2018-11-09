Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0087.outbound.protection.outlook.com ([104.47.36.87]:31385
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727941AbeKIWht (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 17:37:49 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools/perf: traceevent API cleanup, remove __tep_data2host*()
Date: Fri, 9 Nov 2018 12:57:14 +0000
Message-ID: <20181109125702.22152-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, its API
should be straightforward. The __tep_data2host*() functions are
going to no longer be available as a libtraceevent API, tep_read_number()
should be used instead. This patch replaces __tep_data2host*() usage with
tep_read_number() in perf.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/perf/util/trace-event-read.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-eve=
nt-read.c
index cdf6de82a507..3191bd310fcf 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -102,7 +102,7 @@ static unsigned int read4(struct tep_handle *pevent)
=20
 	if (do_read(&data, 4) < 0)
 		return 0;
-	return __tep_data2host4(pevent, data);
+	return tep_read_number(pevent, &data, 4);
 }
=20
 static unsigned long long read8(struct tep_handle *pevent)
@@ -111,7 +111,7 @@ static unsigned long long read8(struct tep_handle *peve=
nt)
=20
 	if (do_read(&data, 8) < 0)
 		return 0;
-	return __tep_data2host8(pevent, data);
+	return tep_read_number(pevent, &data, 8);
 }
=20
 static char *read_string(void)
--=20
2.17.2
