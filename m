Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720066.outbound.protection.outlook.com ([40.107.72.66]:54754
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727561AbeKHBpl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 20:45:41 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 6/8] kernel-shark-qt: Add tot_count field to the model
 descriptor
Date: Wed, 7 Nov 2018 16:14:38 +0000
Message-ID: <20181107161410.22507-7-ykaradzhov@vmware.com>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
In-Reply-To: <20181107161410.22507-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The tot_count field of the Visualization model descriptor provides
fast access to the total number of entries being currently visualized.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark-model.c | 7 +++++++
 kernel-shark-qt/src/libkshark-model.h | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/li=
bkshark-model.c
index ef6ad48..461f88e 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -298,6 +298,7 @@ static void ksmodel_set_bin_counts(struct kshark_trace_=
histo *histo)
 {
 	int i =3D 0, prev_not_empty;
=20
+	histo->tot_count =3D 0;
 	memset(&histo->bin_count[0], 0,
 	       (histo->n_bins) * sizeof(histo->bin_count[0]));
 	/*
@@ -329,6 +330,10 @@ static void ksmodel_set_bin_counts(struct kshark_trace=
_histo *histo)
 			histo->bin_count[prev_not_empty] =3D
 				histo->map[i] - histo->map[prev_not_empty];
=20
+			if (prev_not_empty !=3D LOB(histo))
+				histo->tot_count +=3D
+					histo->bin_count[prev_not_empty];
+
 			prev_not_empty =3D i;
 		}
 	}
@@ -350,6 +355,8 @@ static void ksmodel_set_bin_counts(struct kshark_trace_=
histo *histo)
 		histo->bin_count[prev_not_empty] =3D histo->map[UOB(histo)] -
 						   histo->map[prev_not_empty];
 	}
+
+	histo->tot_count +=3D histo->bin_count[prev_not_empty];
 }
=20
 /**
diff --git a/kernel-shark-qt/src/libkshark-model.h b/kernel-shark-qt/src/li=
bkshark-model.h
index db681cc..95c30b6 100644
--- a/kernel-shark-qt/src/libkshark-model.h
+++ b/kernel-shark-qt/src/libkshark-model.h
@@ -51,6 +51,9 @@ struct kshark_trace_histo {
 	/** Number of entries in each bin. */
 	size_t			*bin_count;
=20
+	/** Total number of entries in all bin except the overflow bins. */
+	int			tot_count;
+
 	/**
 	 * Lower edge of the time-window to be visualized. Only entries having
 	 * timestamp >=3D min will be visualized.
--=20
2.17.1
