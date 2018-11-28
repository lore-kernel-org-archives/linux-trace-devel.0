Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710043.outbound.protection.outlook.com ([40.107.71.43]:7840
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727941AbeK2CSR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:17 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 07/17] kernel-shark-qt: Fix the documentation of
 libkshark-model
Date: Wed, 28 Nov 2018 15:16:15 +0000
Message-ID: <20181128151530.21965-8-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes a simple copy/paste mistake in the Doxygen
documentation of the ksmodel_get_cpu_xxx() functions.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark-model.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/li=
bkshark-model.c
index 461f88e..76e2940 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -1070,7 +1070,7 @@ static int ksmodel_get_entry_cpu(const struct kshark_=
entry *entry)
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
- * @returns Process Id of the task if an entry has been found. Else a nega=
tive
+ * @returns The CPU Id of the task if an entry has been found. Else a nega=
tive
  *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
  */
 int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
@@ -1103,7 +1103,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *=
histo,
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
- * @returns Process Id of the task if an entry has been found. Else a nega=
tive
+ * @returns The CPU Id of the task if an entry has been found. Else a nega=
tive
  *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
  */
 int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
--=20
2.17.1
