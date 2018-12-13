Return-Path: <SRS0=ubwn=OW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720045.outbound.protection.outlook.com ([40.107.72.45]:10556
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbeLMOVo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Dec 2018 09:21:44 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/5] fix "trace-cmd reset" command to restore default clock
Date: Thu, 13 Dec 2018 14:21:41 +0000
Message-ID: <20181213142125.12149-4-tstoyanov@vmware.com>
References: <20181213142125.12149-1-tstoyanov@vmware.com>
In-Reply-To: <20181213142125.12149-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The "trace-cmd reset" command should restore ftrace to its default state.
This patch sets "tracing/trace_clock" to its default value "local",
when the "trace-cmd reset" command is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e02660a..38d9871 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3753,6 +3753,14 @@ static void clear_filters(void)
 		clear_instance_filters(instance);
 }
=20
+static void reset_clock(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		write_instance_file(instance, "trace_clock", "local", "clock");
+}
+
 static void clear_triggers(void)
 {
 	struct buffer_instance *instance;
@@ -4454,6 +4462,8 @@ void trace_reset(int argc, char **argv)
 	set_buffer_size();
 	clear_filters();
 	clear_triggers();
+	/* set clock to "local" */
+	reset_clock();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
--=20
2.19.2
