Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790053.outbound.protection.outlook.com ([40.107.79.53]:64832
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726849AbeKVBtR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:49:17 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 03/11] kernel-shark-qt: Avoid race condition in
 kshark_get_event_name_easy()
Date: Wed, 21 Nov 2018 15:14:21 +0000
Message-ID: <20181121151356.16901-5-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Calling tep_data_event_from_type() is not thread-safe (potential
race condition). This patch protects the access to it by using the
mutex associated with the input file.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index fa85171..89ae769 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -1147,7 +1147,18 @@ const char *kshark_get_event_name_easy(struct kshark=
_entry *entry)
 		}
 	}
=20
+	/*
+	 * Calling tep_data_event_from_type() is not thread-safe (potential
+	 * race condition).
+	 * TODO: See if we can add a thread-safe version of the
+	 * function. For the time being use a mutex to protect the access.
+	 */
+	pthread_mutex_lock(&kshark_ctx->input_mutex);
+
 	event =3D tep_data_event_from_type(kshark_ctx->pevent, event_id);
+
+	pthread_mutex_unlock(&kshark_ctx->input_mutex);
+
 	if (event)
 		return event->name;
=20
--=20
2.17.1
