Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710082.outbound.protection.outlook.com ([40.107.71.82]:33975
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726344AbeLNLe5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 06:34:57 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: fix "trace-cmd stat" output
Date: Fri, 14 Dec 2018 11:34:54 +0000
Message-ID: <20181214113441.12166-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes the output of the "trace-cmd stat"
command to not display "(none enabled)" in case there
are enabled events from individual systems.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-stat.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 99a22d0..538f4ad 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -324,6 +324,7 @@ static void report_events(struct buffer_instance *insta=
nce)
 	char *system;
 	enum event_iter_type type;
 	enum event_process processed =3D PROCESSED_NONE;
+	enum event_process processed_part =3D PROCESSED_NONE;
=20
 	str =3D get_instance_file_content(instance, "events/enable");
 	if (!str)
@@ -358,7 +359,6 @@ static void report_events(struct buffer_instance *insta=
nce)
=20
 	reset_event_iter(iter);
=20
-	processed =3D PROCESSED_NONE;
 	system =3D NULL;
 	while ((type =3D trace_event_iter_next(iter, path, system))) {
=20
@@ -369,18 +369,18 @@ static void report_events(struct buffer_instance *ins=
tance)
 				continue;
=20
 			system =3D iter->system_dent->d_name;
-			if (processed)
-				processed =3D PROCESSED_SYSTEM;
+			if (processed_part)
+				processed_part =3D PROCESSED_SYSTEM;
 			continue;
 		}
=20
 		process_event_enable(path, iter->system_dent->d_name,
-				     iter->event_dent->d_name, &processed);
+				     iter->event_dent->d_name, &processed_part);
 	}
=20
 	trace_event_iter_free(iter);
=20
-	if (!processed)
+	if (!processed && !processed_part)
 		printf("  (none enabled)\n");
=20
 	tracecmd_put_tracing_file(path);
--=20
2.19.2
