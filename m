Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790052.outbound.protection.outlook.com ([40.107.79.52]:55564
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727623AbeK1UIs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 15:08:48 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 09/15] tools/lib/traceevent: Initialize host_bigendian at
 tep_handle allocation
Date: Wed, 28 Nov 2018 09:07:40 +0000
Message-ID: <20181128090711.17792-10-tstoyanov@vmware.com>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
In-Reply-To: <20181128090711.17792-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch initializes host_bigendian member of the tep_handle structure
with the byte order of current host, when this handler is created - in
tep_alloc() API. We need this in order to remove tep_set_host_bigendian() A=
PI.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 2c0597a29f58..e9d9728385a2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6805,8 +6805,10 @@ struct tep_handle *tep_alloc(void)
 {
 	struct tep_handle *pevent =3D calloc(1, sizeof(*pevent));
=20
-	if (pevent)
+	if (pevent) {
 		pevent->ref_count =3D 1;
+		pevent->host_bigendian =3D tep_host_bigendian();
+	}
=20
 	return pevent;
 }
--=20
2.19.1
