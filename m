Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710070.outbound.protection.outlook.com ([40.107.71.70]:36576
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728664AbeK2CSL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:11 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 03/17] kernel-shark-qt: Fix a byg in unset_event_filter_flag()
Date: Wed, 28 Nov 2018 15:16:09 +0000
Message-ID: <20181128151530.21965-4-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Currently the unset_event_filter_flag() function unsets explicitly the
EVENT_VIEW visibility flag, ignoring the user's request for visibility
of the data after the filtering. This is wrong. The value of the
coresponging bit in the user-provided mask (kshark_ctx->filter_mask),
has to be used instead.

Since the function becames very simple now it is declared as inline.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index fa85171..b4b3d5b 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -448,19 +448,18 @@ bool kshark_filter_is_set(struct kshark_context *ksha=
rk_ctx)
 	       filter_is_set(kshark_ctx->hide_event_filter);
 }
=20
-static void unset_event_filter_flag(struct kshark_context *kshark_ctx,
-				    struct kshark_entry *e)
+static inline void unset_event_filter_flag(struct kshark_context *kshark_c=
tx,
+					   struct kshark_entry *e)
 {
 	/*
 	 * All entries, filtered-out by the event filters, will be treated
 	 * differently, when visualized. Because of this, ignore the value
 	 * of the GRAPH_VIEW flag provided by the user via
-	 * kshark_ctx->filter_mask and unset the EVENT_VIEW flag.
+	 * kshark_ctx->filter_mask. The value of the EVENT_VIEW flag in
+	 * kshark_ctx->filter_mask will be used instead.
 	 */
-	int event_mask =3D kshark_ctx->filter_mask;
+	int event_mask =3D kshark_ctx->filter_mask & ~KS_GRAPH_VIEW_FILTER_MASK;
=20
-	event_mask &=3D ~KS_GRAPH_VIEW_FILTER_MASK;
-	event_mask |=3D KS_EVENT_VIEW_FILTER_MASK;
 	e->visible &=3D ~event_mask;
 }
=20
--=20
2.17.1
