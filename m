Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:2944
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbeK2CSe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:34 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 12/17] kernel-shark-qt: Add CPU-based filtering to the C API
Date: Wed, 28 Nov 2018 15:16:22 +0000
Message-ID: <20181128151530.21965-13-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds "Show CPU" and "Hide CPU" filters to the C API of
KernelShark. The implementation of those filters follows the pattern
used to implement the Task (pid) and Event filters.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark.c | 37 +++++++++++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h | 17 +++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index b4b3d5b..86d3e58 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -41,6 +41,9 @@ static bool kshark_default_context(struct kshark_context =
**context)
 	kshark_ctx->show_event_filter =3D tracecmd_filter_id_hash_alloc();
 	kshark_ctx->hide_event_filter =3D tracecmd_filter_id_hash_alloc();
=20
+	kshark_ctx->show_cpu_filter =3D tracecmd_filter_id_hash_alloc();
+	kshark_ctx->hide_cpu_filter =3D tracecmd_filter_id_hash_alloc();
+
 	kshark_ctx->filter_mask =3D 0x0;
=20
 	/* Will free kshark_context_handler. */
@@ -180,6 +183,8 @@ void kshark_close(struct kshark_context *kshark_ctx)
 	tracecmd_filter_id_clear(kshark_ctx->hide_task_filter);
 	tracecmd_filter_id_clear(kshark_ctx->show_event_filter);
 	tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
+	tracecmd_filter_id_clear(kshark_ctx->show_cpu_filter);
+	tracecmd_filter_id_clear(kshark_ctx->hide_cpu_filter);
=20
 	if (kshark_ctx->advanced_event_filter) {
 		tep_filter_reset(kshark_ctx->advanced_event_filter);
@@ -226,6 +231,9 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	tracecmd_filter_id_hash_free(kshark_ctx->show_event_filter);
 	tracecmd_filter_id_hash_free(kshark_ctx->hide_event_filter);
=20
+	tracecmd_filter_id_hash_free(kshark_ctx->show_cpu_filter);
+	tracecmd_filter_id_hash_free(kshark_ctx->hide_cpu_filter);
+
 	if (kshark_ctx->plugins) {
 		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
 		kshark_free_plugin_list(kshark_ctx->plugins);
@@ -366,6 +374,12 @@ static bool kshark_show_event(struct kshark_context *k=
shark_ctx, int pid)
 	       filter_find(kshark_ctx->hide_event_filter, pid, false);
 }
=20
+static bool kshark_show_cpu(struct kshark_context *kshark_ctx, int cpu)
+{
+	return filter_find(kshark_ctx->show_cpu_filter, cpu, true) &&
+	       filter_find(kshark_ctx->hide_cpu_filter, cpu, false);
+}
+
 /**
  * @brief Add an Id value to the filster specified by "filter_id".
  *
@@ -379,6 +393,12 @@ void kshark_filter_add_id(struct kshark_context *kshar=
k_ctx,
 	struct tracecmd_filter_id *filter;
=20
 	switch (filter_id) {
+		case KS_SHOW_CPU_FILTER:
+			filter =3D kshark_ctx->show_cpu_filter;
+			break;
+		case KS_HIDE_CPU_FILTER:
+			filter =3D kshark_ctx->hide_cpu_filter;
+			break;
 		case KS_SHOW_EVENT_FILTER:
 			filter =3D kshark_ctx->show_event_filter;
 			break;
@@ -409,6 +429,12 @@ void kshark_filter_clear(struct kshark_context *kshark=
_ctx, int filter_id)
 	struct tracecmd_filter_id *filter;
=20
 	switch (filter_id) {
+		case KS_SHOW_CPU_FILTER:
+			filter =3D kshark_ctx->show_cpu_filter;
+			break;
+		case KS_HIDE_CPU_FILTER:
+			filter =3D kshark_ctx->hide_cpu_filter;
+			break;
 		case KS_SHOW_EVENT_FILTER:
 			filter =3D kshark_ctx->show_event_filter;
 			break;
@@ -444,6 +470,8 @@ bool kshark_filter_is_set(struct kshark_context *kshark=
_ctx)
 {
 	return filter_is_set(kshark_ctx->show_task_filter) ||
 	       filter_is_set(kshark_ctx->hide_task_filter) ||
+	       filter_is_set(kshark_ctx->show_cpu_filter) ||
+	       filter_is_set(kshark_ctx->hide_cpu_filter) ||
 	       filter_is_set(kshark_ctx->show_event_filter) ||
 	       filter_is_set(kshark_ctx->hide_event_filter);
 }
@@ -505,6 +533,10 @@ void kshark_filter_entries(struct kshark_context *ksha=
rk_ctx,
 		if (!kshark_show_event(kshark_ctx, data[i]->event_id))
 			unset_event_filter_flag(kshark_ctx, data[i]);
=20
+		/* Apply CPU filtering. */
+		if (!kshark_show_cpu(kshark_ctx, data[i]->cpu))
+			data[i]->visible &=3D ~kshark_ctx->filter_mask;
+
 		/* Apply task filtering. */
 		if (!kshark_show_task(kshark_ctx, data[i]->pid))
 			data[i]->visible &=3D ~kshark_ctx->filter_mask;
@@ -732,6 +764,11 @@ static size_t get_records(struct kshark_context *kshar=
k_ctx,
 					unset_event_filter_flag(kshark_ctx, entry);
 				}
=20
+				/* Apply CPU filtering. */
+				if (!kshark_show_cpu(kshark_ctx, entry->pid)) {
+					entry->visible &=3D ~kshark_ctx->filter_mask;
+				}
+
 				/* Apply task filtering. */
 				if (!kshark_show_task(kshark_ctx, entry->pid)) {
 					entry->visible &=3D ~kshark_ctx->filter_mask;
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index b94bdc3..eb8c261 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -110,6 +110,12 @@ struct kshark_context {
 	/** Hash of events to not display. */
 	struct tracecmd_filter_id	*hide_event_filter;
=20
+	/** Hash of CPUs to filter on. */
+	struct tracecmd_filter_id	*show_cpu_filter;
+
+	/** Hash of CPUs to not display. */
+	struct tracecmd_filter_id	*hide_cpu_filter;
+
 	/**
 	 * Bit mask, controlling the visibility of the entries after filtering.
 	 * If given bit is set here, all entries which are filtered-out will
@@ -232,6 +238,17 @@ enum kshark_filter_type {
 	 * filtered-out.
 	 */
 	KS_HIDE_TASK_FILTER,
+
+	/**
+	 * Identifier of the filter, used to specified the CPUs to be shown.
+	 */
+	KS_SHOW_CPU_FILTER,
+
+	/**
+	 * Identifier of the filter, used to specified the CPUs to be
+	 * filtered-out.
+	 */
+	KS_HIDE_CPU_FILTER,
 };
=20
 void kshark_filter_add_id(struct kshark_context *kshark_ctx,
--=20
2.17.1
