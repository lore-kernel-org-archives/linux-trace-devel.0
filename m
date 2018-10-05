Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-by2nam01on0078.outbound.protection.outlook.com ([104.47.34.78]:4782
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728044AbeJFBda (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 21:33:30 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3 5/5] kernel-shark-qt: Fix a bug in
 kshark_data_collection_alloc()
Date: Fri, 5 Oct 2018 18:33:32 +0000
Message-ID: <20181005183241.27026-6-ykaradzhov@vmware.com>
References: <20181005183241.27026-1-ykaradzhov@vmware.com>
In-Reply-To: <20181005183241.27026-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The margin data added at the end of the data interval of the collection
may actually include the beginning of another interval. Because of this
we have to iterate over the margin data and check for "good" entries. In
the case of a "good" entry being found, we have to continue extending the
last interval.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark-collection.c | 27 +++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark-collection.c b/kernel-shark-qt/s=
rc/libkshark-collection.c
index 79b6fff..9838042 100644
--- a/kernel-shark-qt/src/libkshark-collection.c
+++ b/kernel-shark-qt/src/libkshark-collection.c
@@ -157,14 +157,25 @@ kshark_data_collection_alloc(struct kshark_context *k=
shark_ctx,
 			 * number of margin entries requested, keep adding
 			 * until you fill the margin.
 			 */
-			if (i + margin < j)
-				i =3D j;
-			else
-				i +=3D margin;
-
-			last_added =3D i;
-			collection_add_entry(&temp, i, COLLECTION_BREAK);
-			++break_count;
+			if (i + margin >=3D j) {
+				for (;j < i + margin; ++j) {
+					if (cond(kshark_ctx, data[j], val)) {
+						/*
+						 * Good data has been found.
+						 * Continue extending the
+						 * previous data interval.
+						 */
+						good_data =3D true;
+						break;
+					}
+				}
+			}
+
+			last_added =3D i =3D j;
+			if (!good_data) {
+				collection_add_entry(&temp, i, COLLECTION_BREAK);
+				++break_count;
+			}
 		}
 	}
=20
--=20
2.17.1
