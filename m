Return-Path: <SRS0=ubwn=OW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720074.outbound.protection.outlook.com ([40.107.72.74]:20288
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbeLMOVr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Dec 2018 09:21:47 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 5/5] fix "trace-cmd reset" command to restore the default
 value of tracing_max_latency
Date: Thu, 13 Dec 2018 14:21:44 +0000
Message-ID: <20181213142125.12149-6-tstoyanov@vmware.com>
References: <20181213142125.12149-1-tstoyanov@vmware.com>
In-Reply-To: <20181213142125.12149-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The "trace-cmd reset" command should restore ftrace to its default state.
This patch sets "tracing/tracing_max_latency" to 0,
when the "trace-cmd reset" command is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f77e49a..a9bcd8d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3769,6 +3769,14 @@ static void reset_event_pid(void)
 		write_instance_file(instance, "set_event_pid", "", "event_pid");
 }
=20
+static void reset_max_latency_instance(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		write_instance_file(instance,
+				    "tracing_max_latency", "0", "max_latency");
+}
=20
 static void clear_triggers(void)
 {
@@ -4474,6 +4482,7 @@ void trace_reset(int argc, char **argv)
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
+	reset_max_latency_instance();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
--=20
2.19.2
