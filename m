Return-Path: <SRS0=ubwn=OW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:1332
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727978AbeLMOVl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Dec 2018 09:21:41 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/5] fix "trace-cmd reset" command to restore "tracng_on"
Date: Thu, 13 Dec 2018 14:21:38 +0000
Message-ID: <20181213142125.12149-2-tstoyanov@vmware.com>
References: <20181213142125.12149-1-tstoyanov@vmware.com>
In-Reply-To: <20181213142125.12149-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The "trace-cmd reset" command should restore ftrace to its default state.
By default, "tracing/current_tracer" is "nop" and "tracing/tracing_on" is "=
1".
This patch sets "tracing/tracing_on" to 1, when the command "trace-cmd rese=
t"
is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7666a24..a044cf5 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4456,6 +4456,8 @@ void trace_reset(int argc, char **argv)
 	clear_triggers();
 	tracecmd_remove_instances();
 	clear_func_filters();
+	/* restore tracing_on to 1 */
+	tracecmd_enable_tracing();
 	exit(0);
 }
=20
--=20
2.19.2
