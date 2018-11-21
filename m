Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790053.outbound.protection.outlook.com ([40.107.79.53]:64832
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730512AbeKVBtP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:49:15 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 02/11] kernel-shark-qt: Fix the returned error value of
 kshark_get_event_id_easy()
Date: Wed, 21 Nov 2018 15:14:20 +0000
Message-ID: <20181121151356.16901-4-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes a simple bug in kshark_get_event_id_easy().
All returned error codes must be negative.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index 1a39968..fa85171 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -1111,7 +1111,7 @@ int kshark_get_event_id_easy(struct kshark_entry *ent=
ry)
 		free_record(data);
 	}
=20
-	return (event_id =3D=3D -1)? EFAULT : event_id;
+	return (event_id =3D=3D -1)? -EFAULT : event_id;
 }
=20
 /**
@@ -1133,7 +1133,7 @@ const char *kshark_get_event_name_easy(struct kshark_=
entry *entry)
 	struct tep_event_format *event;
=20
 	int event_id =3D kshark_get_event_id_easy(entry);
-	if (event_id =3D=3D EFAULT)
+	if (event_id =3D=3D -EFAULT)
 		return NULL;
=20
 	kshark_instance(&kshark_ctx);
--=20
2.17.1
