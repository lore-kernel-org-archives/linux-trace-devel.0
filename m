Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710043.outbound.protection.outlook.com ([40.107.71.43]:7840
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727941AbeK2CSP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:15 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 05/17] kernel-shark-qt: Protect all calls of
 tep_read_number_field()
Date: Wed, 28 Nov 2018 15:16:12 +0000
Message-ID: <20181128151530.21965-6-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

tep_read_number_field() is being used to retrieve the value of a data
field and this value has being used without checking if the function
succeeded. This is a potential bug because tep_read_number_field() may
fail and in such a case the retrieved field value will be arbitrary.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/sched_events.c | 52 +++++++++++++---------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/s=
rc/plugins/sched_events.c
index 1851569..59ffcfe 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -97,10 +97,12 @@ int plugin_get_next_pid(struct tep_record *record)
 	struct plugin_sched_context *plugin_ctx =3D
 		plugin_sched_context_handler;
 	unsigned long long val;
+	int ret;
=20
-	tep_read_number_field(plugin_ctx->sched_switch_next_field,
-			      record->data, &val);
-	return val;
+	ret =3D tep_read_number_field(plugin_ctx->sched_switch_next_field,
+				    record->data, &val);
+
+	return ret ? : val;
 }
=20
 /**
@@ -113,10 +115,12 @@ int plugin_get_rec_wakeup_pid(struct tep_record *reco=
rd)
 	struct plugin_sched_context *plugin_ctx =3D
 		plugin_sched_context_handler;
 	unsigned long long val;
+	int ret;
+
+	ret =3D tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
+				    record->data, &val);
=20
-	tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
-			      record->data, &val);
-	return val;
+	return ret ? : val;
 }
=20
 static void plugin_register_command(struct kshark_context *kshark_ctx,
@@ -145,11 +149,12 @@ static int plugin_get_rec_wakeup_new_pid(struct tep_r=
ecord *record)
 	struct plugin_sched_context *plugin_ctx =3D
 		plugin_sched_context_handler;
 	unsigned long long val;
+	int ret;
=20
-	tep_read_number_field(plugin_ctx->sched_wakeup_new_pid_field,
-				 record->data, &val);
+	ret =3D tep_read_number_field(plugin_ctx->sched_wakeup_new_pid_field,
+				    record->data, &val);
=20
-	return val;
+	return ret ? : val;
 }
=20
 /**
@@ -170,7 +175,7 @@ bool plugin_wakeup_match_rec_pid(struct kshark_context =
*kshark_ctx,
 	struct plugin_sched_context *plugin_ctx;
 	struct tep_record *record =3D NULL;
 	unsigned long long val;
-	int wakeup_pid =3D -1;
+	int ret, wakeup_pid =3D -1;
=20
 	plugin_ctx =3D plugin_sched_context_handler;
 	if (!plugin_ctx)
@@ -181,10 +186,10 @@ bool plugin_wakeup_match_rec_pid(struct kshark_contex=
t *kshark_ctx,
 		record =3D kshark_read_at(kshark_ctx, e->offset);
=20
 		/* We only want those that actually woke up the task. */
-		tep_read_number_field(plugin_ctx->sched_wakeup_success_field,
-				      record->data, &val);
+		ret =3D tep_read_number_field(plugin_ctx->sched_wakeup_success_field,
+					    record->data, &val);
=20
-		if (val)
+		if (ret =3D=3D 0 && val)
 			wakeup_pid =3D plugin_get_rec_wakeup_pid(record);
 	}
=20
@@ -193,10 +198,10 @@ bool plugin_wakeup_match_rec_pid(struct kshark_contex=
t *kshark_ctx,
 		record =3D kshark_read_at(kshark_ctx, e->offset);
=20
 		/* We only want those that actually woke up the task. */
-		tep_read_number_field(plugin_ctx->sched_wakeup_new_success_field,
-				      record->data, &val);
+		ret =3D tep_read_number_field(plugin_ctx->sched_wakeup_new_success_field=
,
+					    record->data, &val);
=20
-		if (val)
+		if (ret =3D=3D 0 && val)
 			wakeup_pid =3D plugin_get_rec_wakeup_new_pid(record);
 	}
=20
@@ -224,7 +229,7 @@ bool plugin_switch_match_rec_pid(struct kshark_context =
*kshark_ctx,
 {
 	struct plugin_sched_context *plugin_ctx;
 	unsigned long long val;
-	int switch_pid =3D -1;
+	int ret, switch_pid =3D -1;
=20
 	plugin_ctx =3D plugin_sched_context_handler;
=20
@@ -233,10 +238,10 @@ bool plugin_switch_match_rec_pid(struct kshark_contex=
t *kshark_ctx,
 		struct tep_record *record;
=20
 		record =3D kshark_read_at(kshark_ctx, e->offset);
-		tep_read_number_field(plugin_ctx->sched_switch_prev_state_field,
-				      record->data, &val);
+		ret =3D tep_read_number_field(plugin_ctx->sched_switch_prev_state_field,
+					    record->data, &val);
=20
-		if (!(val & 0x7f))
+		if (ret =3D=3D 0 && !(val & 0x7f))
 			switch_pid =3D tep_data_pid(plugin_ctx->pevent, record);
=20
 		free_record(record);
@@ -278,8 +283,11 @@ static void plugin_sched_action(struct kshark_context =
*kshark_ctx,
 				struct tep_record *rec,
 				struct kshark_entry *entry)
 {
-	entry->pid =3D plugin_get_next_pid(rec);
-	plugin_register_command(kshark_ctx, rec, entry->pid);
+	int pid =3D plugin_get_next_pid(rec);
+	if (pid >=3D 0) {
+		entry->pid =3D pid;
+		plugin_register_command(kshark_ctx, rec, entry->pid);
+	}
 }
=20
 static int plugin_sched_init(struct kshark_context *kshark_ctx)
--=20
2.17.1
