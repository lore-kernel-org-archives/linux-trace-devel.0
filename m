Return-Path: <SRS0=ubwn=OW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720078.outbound.protection.outlook.com ([40.107.72.78]:1332
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbeLMOVm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Dec 2018 09:21:42 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/5] fix "trace-cmd reset -a -d" segfault
Date: Thu, 13 Dec 2018 14:21:40 +0000
Message-ID: <20181213142125.12149-3-tstoyanov@vmware.com>
References: <20181213142125.12149-1-tstoyanov@vmware.com>
In-Reply-To: <20181213142125.12149-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes a segfault when "trace-cmd reset -a -d"
is executed and there is at least one ftrace instance created.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a044cf5..e02660a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4432,14 +4432,14 @@ void trace_reset(int argc, char **argv)
 		case 'a':
 			last_specified_all =3D 1;
 			add_all_instances();
-			for_each_instance(instance) {
-				instance->flags |=3D BUFFER_FL_KEEP;
+			for_each_instance(inst) {
+				inst->flags |=3D BUFFER_FL_KEEP;
 			}
 			break;
 		case 'd':
 			if (last_specified_all) {
 				for_each_instance(inst) {
-					instance->flags &=3D ~BUFFER_FL_KEEP;
+					inst->flags &=3D ~BUFFER_FL_KEEP;
 				}
 			} else {
 				if (is_top_instance(instance))
--=20
2.19.2
