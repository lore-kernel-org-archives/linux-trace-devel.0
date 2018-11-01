Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810073.outbound.protection.outlook.com ([40.107.81.73]:3002
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727753AbeKBGu0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:26 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/8] kernel-shark-qt: Fix potential memory leak when searching
 in collections
Date: Thu, 1 Nov 2018 21:45:38 +0000
Message-ID: <20181101214512.18684-3-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In some cases the Data Collection can map the original data request into
a list of data requests. This is done in the cases when the range of the
original request overlaps with more the one data interval (as defined by
the collection). In such a case we must free the entire list of requests.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark-model.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/li=
bkshark-model.c
index 246a60c..7800090 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -900,7 +900,7 @@ ksmodel_get_entry_front(struct kshark_trace_histo *hist=
o,
 	else
 		entry =3D kshark_get_entry_front(req, histo->data, index);
=20
-	free(req);
+	kshark_free_entry_request(req);
=20
 	return entry;
 }
@@ -947,7 +947,7 @@ ksmodel_get_entry_back(struct kshark_trace_histo *histo=
,
 	else
 		entry =3D kshark_get_entry_back(req, histo->data, index);
=20
-	free(req);
+	kshark_free_entry_request(req);
=20
 	return entry;
 }
@@ -1160,7 +1160,7 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_tr=
ace_histo *histo,
 	else
 		entry =3D kshark_get_entry_front(req, histo->data, index);
=20
-	free(req);
+	kshark_free_entry_request(req);
=20
 	if (!entry || !entry->visible) {
 		/* No visible entry has been found. */
@@ -1213,7 +1213,7 @@ bool ksmodel_task_visible_event_exist(struct kshark_t=
race_histo *histo,
 	else
 		entry =3D kshark_get_entry_front(req, histo->data, index);
=20
-	free(req);
+	kshark_free_entry_request(req);
=20
 	if (!entry || !entry->visible) {
 		/* No visible entry has been found. */
--=20
2.17.1
