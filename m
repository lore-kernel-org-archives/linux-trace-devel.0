Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810073.outbound.protection.outlook.com ([40.107.81.73]:3002
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbeKBGu0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:26 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/8] kernel-shark-qt: Free all collections when closing the
 trace file.
Date: Thu, 1 Nov 2018 21:45:37 +0000
Message-ID: <20181101214512.18684-2-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

All data collections are file specific. We have to guarantee that
collections from one file cannot be used with another file.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index 33d25de..64236a5 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -188,6 +188,13 @@ void kshark_close(struct kshark_context *kshark_ctx)
 		kshark_ctx->advanced_event_filter =3D NULL;
 	}
=20
+	/*
+	 * All data collections are file specific. Make sure that collections
+	 * from this file are not going to be used with another file.
+	 */
+	kshark_free_collection_list(kshark_ctx->collections);
+	kshark_ctx->collections =3D NULL;
+
 	tracecmd_close(kshark_ctx->handle);
 	kshark_ctx->handle =3D NULL;
 	kshark_ctx->pevent =3D NULL;
--=20
2.17.1
