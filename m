Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700058.outbound.protection.outlook.com ([40.107.70.58]:36480
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbeK1Cjb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:39:31 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 09/14] tools/lib/traceevent: Initialize host_bigendian at
 tep_handle allocation
Date: Tue, 27 Nov 2018 15:41:03 +0000
Message-ID: <20181127154038.11175-10-tstoyanov@vmware.com>
References: <20181127154038.11175-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154038.11175-1-tstoyanov@vmware.com>
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
