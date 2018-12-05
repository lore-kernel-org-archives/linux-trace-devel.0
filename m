Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr770074.outbound.protection.outlook.com ([40.107.77.74]:50035
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727376AbeLEJV5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:21:57 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/6] tools lib traceevent, perf tools: Rename 'struct
 tep_event_format' to 'struct tep_event'
Date: Wed, 5 Dec 2018 09:21:48 +0000
Message-ID: <20181205092134.2214-3-tstoyanov@vmware.com>
References: <20181205092134.2214-1-tstoyanov@vmware.com>
In-Reply-To: <20181205092134.2214-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts.

This renames 'struct tep_event_format' to 'struct tep_event', which
describes more closely the purpose of the struct.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181130154647.436403995@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[ Fixup conflict with 6e33c250a88f ("tools lib traceevent: Fix compile warn=
ings in lib/traceevent/event-parse.c") ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/trace-cmd/trace-cmd.h                |   2 +-
 include/traceevent/event-parse.h             |  60 +++---
 kernel-shark-qt/examples/datafilter.c        |   2 +-
 kernel-shark-qt/src/KsAdvFilteringDialog.cpp |  10 +-
 kernel-shark-qt/src/KsAdvFilteringDialog.hpp |   2 +-
 kernel-shark-qt/src/KsCaptureDialog.cpp      |   4 +-
 kernel-shark-qt/src/KsMainWindow.cpp         |   2 +-
 kernel-shark-qt/src/KsWidgetsLib.cpp         |   2 +-
 kernel-shark-qt/src/libkshark-configio.c     |   6 +-
 kernel-shark-qt/src/libkshark.c              |   8 +-
 kernel-shark-qt/src/plugins/sched_events.c   |   2 +-
 kernel-shark-qt/src/plugins/sched_events.h   |   6 +-
 kernel-shark/include/trace-view-store.h      |   6 +-
 kernel-shark/trace-capture.c                 |   6 +-
 kernel-shark/trace-dialog.c                  |   4 +-
 kernel-shark/trace-filter.c                  |  24 +--
 kernel-shark/trace-graph.c                   |   8 +-
 kernel-shark/trace-plot-cpu.c                |   4 +-
 kernel-shark/trace-plot-task.c               |   4 +-
 kernel-shark/trace-view-store.c              |   2 +-
 lib/trace-cmd/trace-blk-hack.c               |   2 +-
 lib/trace-cmd/trace-ftrace.c                 |  16 +-
 lib/traceevent/event-parse-api.c             |   4 +-
 lib/traceevent/event-parse-local.h           |   6 +-
 lib/traceevent/event-parse.c                 | 182 +++++++++----------
 lib/traceevent/parse-filter.c                |  42 ++---
 plugins/plugin_blk.c                         |   4 +-
 plugins/plugin_function.c                    |   2 +-
 plugins/plugin_futex.c                       |   2 +-
 plugins/plugin_hrtimer.c                     |   4 +-
 plugins/plugin_kmem.c                        |   2 +-
 plugins/plugin_kvm.c                         |  14 +-
 plugins/plugin_mac80211.c                    |  10 +-
 plugins/plugin_sched_switch.c                |   4 +-
 plugins/plugin_tlb.c                         |   2 +-
 python/ctracecmd.i                           |  10 +-
 tracecmd/trace-hist.c                        |  22 +--
 tracecmd/trace-mem.c                         |  18 +-
 tracecmd/trace-profile.c                     |  10 +-
 tracecmd/trace-read.c                        |  16 +-
 tracecmd/trace-record.c                      |   2 +-
 41 files changed, 269 insertions(+), 269 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 684ddb7..6fd9f33 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -90,7 +90,7 @@ enum {
=20
 struct tracecmd_ftrace {
 	struct tracecmd_input		*handle;
-	struct tep_event_format *fgraph_ret_event;
+	struct tep_event *fgraph_ret_event;
 	int fgraph_ret_id;
 	int long_size;
 };
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-pa=
rse.h
index ea6d25d..4252ff1 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -43,11 +43,11 @@ struct tep_record {
 /* ----------------------- tep ----------------------- */
=20
 struct tep_handle;
-struct tep_event_format;
+struct tep_event;
=20
 typedef int (*tep_event_handler_func)(struct trace_seq *s,
 				      struct tep_record *record,
-				      struct tep_event_format *event,
+				      struct tep_event *event,
 				      void *context);
=20
 typedef int (*tep_plugin_load_func)(struct tep_handle *pevent);
@@ -129,7 +129,7 @@ enum tep_format_flags {
=20
 struct tep_format_field {
 	struct tep_format_field	*next;
-	struct tep_event_format	*event;
+	struct tep_event	*event;
 	char			*type;
 	char			*name;
 	char			*alias;
@@ -263,7 +263,7 @@ struct tep_print_fmt {
 	struct tep_print_arg	*args;
 };
=20
-struct tep_event_format {
+struct tep_event {
 	struct tep_handle	*pevent;
 	char			*name;
 	int			id;
@@ -443,14 +443,14 @@ int tep_register_print_string(struct tep_handle *peve=
nt, const char *fmt,
 int tep_pid_is_registered(struct tep_handle *pevent, int pid);
=20
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record);
 void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record,
 			  bool use_trace_clock);
 void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record);
 void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock);
@@ -461,32 +461,32 @@ int tep_parse_header_page(struct tep_handle *pevent, =
char *buf, unsigned long si
 enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys);
 enum tep_errno tep_parse_format(struct tep_handle *pevent,
-				struct tep_event_format **eventp,
+				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void tep_free_format(struct tep_event_format *event);
+void tep_free_format(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
=20
-void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *even=
t,
+void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 			const char *name, struct tep_record *record,
 			int *len, int err);
=20
-int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
+int tep_get_field_val(struct trace_seq *s, struct tep_event *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err);
-int tep_get_common_field_val(struct trace_seq *s, struct tep_event_format =
*event,
+int tep_get_common_field_val(struct trace_seq *s, struct tep_event *event,
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err);
-int tep_get_any_field_val(struct trace_seq *s, struct tep_event_format *ev=
ent,
+int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
 			  const char *name, struct tep_record *record,
 			  unsigned long long *val, int err);
=20
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
-			   struct tep_event_format *event, const char *name,
+			   struct tep_event *event, const char *name,
 			   struct tep_record *record, int err);
=20
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
-			 struct tep_event_format *event, const char *name,
+			 struct tep_event *event, const char *name,
 			 struct tep_record *record, int err);
=20
 int tep_register_event_handler(struct tep_handle *pevent, int id,
@@ -502,9 +502,9 @@ int tep_register_print_function(struct tep_handle *peve=
nt,
 int tep_unregister_print_function(struct tep_handle *pevent,
 				  tep_func_handler func, char *name);
=20
-struct tep_format_field *tep_find_common_field(struct tep_event_format *ev=
ent, const char *name);
-struct tep_format_field *tep_find_field(struct tep_event_format *event, co=
nst char *name);
-struct tep_format_field *tep_find_any_field(struct tep_event_format *event=
, const char *name);
+struct tep_format_field *tep_find_common_field(struct tep_event *event, co=
nst char *name);
+struct tep_format_field *tep_find_field(struct tep_event *event, const cha=
r *name);
+struct tep_format_field *tep_find_any_field(struct tep_event *event, const=
 char *name);
=20
 const char *tep_find_function(struct tep_handle *pevent, unsigned long lon=
g addr);
 unsigned long long
@@ -513,20 +513,20 @@ unsigned long long tep_read_number(struct tep_handle =
*pevent, const void *ptr, i
 int tep_read_number_field(struct tep_format_field *field, const void *data=
,
 			  unsigned long long *value);
=20
-struct tep_event_format *tep_get_first_event(struct tep_handle *tep);
-struct tep_event_format *tep_get_event(struct tep_handle *tep, int index);
+struct tep_event *tep_get_first_event(struct tep_handle *tep);
+struct tep_event *tep_get_event(struct tep_handle *tep, int index);
 int tep_get_events_count(struct tep_handle *tep);
-struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id)=
;
+struct tep_event *tep_find_event(struct tep_handle *pevent, int id);
=20
-struct tep_event_format *
+struct tep_event *
 tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const c=
har *name);
-struct tep_event_format *
+struct tep_event *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *rec=
ord);
=20
 void tep_data_lat_fmt(struct tep_handle *pevent,
 		      struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
-struct tep_event_format *tep_data_event_from_type(struct tep_handle *peven=
t, int type);
+struct tep_event *tep_data_event_from_type(struct tep_handle *pevent, int =
type);
 int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *r=
ec);
 int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
@@ -539,15 +539,15 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct=
 cmdline *cmdline);
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct tep_event_format *event);
-void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
+		      int size __maybe_unused, struct tep_event *event);
+void tep_event_info(struct trace_seq *s, struct tep_event *event,
 		       struct tep_record *record);
 int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
=20
-struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum =
tep_event_sort_type);
-struct tep_format_field **tep_event_common_fields(struct tep_event_format =
*event);
-struct tep_format_field **tep_event_fields(struct tep_event_format *event)=
;
+struct tep_event **tep_list_events(struct tep_handle *pevent, enum tep_eve=
nt_sort_type);
+struct tep_format_field **tep_event_common_fields(struct tep_event *event)=
;
+struct tep_format_field **tep_event_fields(struct tep_event *event);
=20
 enum tep_endian {
         TEP_LITTLE_ENDIAN =3D 0,
@@ -709,7 +709,7 @@ struct tep_filter_arg {
=20
 struct tep_filter_type {
 	int			event_id;
-	struct tep_event_format	*event;
+	struct tep_event	*event;
 	struct tep_filter_arg	*filter;
 };
=20
diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/exampl=
es/datafilter.c
index 7f274d5..688e581 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -19,7 +19,7 @@ int main(int argc, char **argv)
 	struct kshark_context *kshark_ctx;
 	struct kshark_entry **data =3D NULL;
 	struct tep_event_filter *adv_filter;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	char *entry_str;
 	bool status;
 	int *pids;
diff --git a/kernel-shark-qt/src/KsAdvFilteringDialog.cpp b/kernel-shark-qt=
/src/KsAdvFilteringDialog.cpp
index ff5a39d..19c639e 100644
--- a/kernel-shark-qt/src/KsAdvFilteringDialog.cpp
+++ b/kernel-shark-qt/src/KsAdvFilteringDialog.cpp
@@ -151,7 +151,7 @@ KsAdvFilteringDialog::KsAdvFilteringDialog(QWidget *par=
ent)
=20
 void KsAdvFilteringDialog::_setSystemCombo(struct kshark_context *kshark_c=
tx)
 {
-	tep_event_format **events;
+	tep_event **events;
 	QStringList sysList;
 	int i(0), nEvts(0);
=20
@@ -204,7 +204,7 @@ QStringList KsAdvFilteringDialog::_operators()
=20
 void KsAdvFilteringDialog::_getFilters(struct kshark_context *kshark_ctx)
 {
-	tep_event_format **events;
+	tep_event **events;
 	char *str;
=20
 	events =3D tep_list_events(kshark_ctx->pevent, TEP_EVENT_SORT_SYSTEM);
@@ -275,7 +275,7 @@ void KsAdvFilteringDialog::_help()
 void KsAdvFilteringDialog::_systemChanged(const QString &sysName)
 {
 	kshark_context *kshark_ctx(NULL);
-	tep_event_format **events;
+	tep_event **events;
 	QStringList evtsList;
 	int i, nEvts;
=20
@@ -300,7 +300,7 @@ void KsAdvFilteringDialog::_systemChanged(const QString=
 &sysName)
 }
=20
 QStringList
-KsAdvFilteringDialog::_getEventFormatFields(struct tep_event_format *event=
)
+KsAdvFilteringDialog::_getEventFormatFields(struct tep_event *event)
 {
 	tep_format_field *field, **fields =3D tep_event_fields(event);
 	QStringList fieldList;
@@ -318,7 +318,7 @@ void KsAdvFilteringDialog::_eventChanged(const QString =
&evtName)
 {
 	QString sysName =3D _systemComboBox.currentText();
 	kshark_context *kshark_ctx(NULL);
-	tep_event_format **events;
+	tep_event **events;
 	QStringList fieldList;
 	int nEvts;
=20
diff --git a/kernel-shark-qt/src/KsAdvFilteringDialog.hpp b/kernel-shark-qt=
/src/KsAdvFilteringDialog.hpp
index cde685c..2a534d0 100644
--- a/kernel-shark-qt/src/KsAdvFilteringDialog.hpp
+++ b/kernel-shark-qt/src/KsAdvFilteringDialog.hpp
@@ -78,7 +78,7 @@ private:
=20
 	void _makeFilterTable(struct kshark_context *kshark_ctx);
=20
-	QStringList _getEventFormatFields(struct tep_event_format *event);
+	QStringList _getEventFormatFields(struct tep_event *event);
=20
 	void _setSystemCombo(struct kshark_context *kshark_ctx);
=20
diff --git a/kernel-shark-qt/src/KsCaptureDialog.cpp b/kernel-shark-qt/src/=
KsCaptureDialog.cpp
index 5d5ca2f..1272c2e 100644
--- a/kernel-shark-qt/src/KsCaptureDialog.cpp
+++ b/kernel-shark-qt/src/KsCaptureDialog.cpp
@@ -149,7 +149,7 @@ QStringList KsCaptureControl::getArgs()
 		argv << "-e" << "all";
 	} else {
 		QVector<int> evtIds =3D _eventsWidget.getCheckedIds();
-		tep_event_format *event;
+		tep_event *event;
=20
 		for (auto const &id: evtIds) {
 			event =3D tep_find_event(_localTEP, id);
@@ -198,7 +198,7 @@ void KsCaptureControl::_importSettings()
 	kshark_config_doc *conf, *jevents, *temp;
 	QVector<bool> v(nEvts, false);
 	tracecmd_filter_id *eventHash;
-	tep_event_format **events;
+	tep_event **events;
 	QString fileName;
=20
=20
diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index 7213c01..f5f33f7 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -534,7 +534,7 @@ void KsMainWindow::_showEvents()
 		 * The event filter contains IDs. Make this visible in the
 		 * CheckBox Widget.
 		 */
-		tep_event_format **events =3D
+		tep_event **events =3D
 			tep_list_events(_data.tep(), TEP_EVENT_SORT_SYSTEM);
 		int nEvts =3D tep_get_events_count(_data.tep());
 		QVector<bool> v(nEvts, false);
diff --git a/kernel-shark-qt/src/KsWidgetsLib.cpp b/kernel-shark-qt/src/KsW=
idgetsLib.cpp
index 4b41f86..ea02b5e 100644
--- a/kernel-shark-qt/src/KsWidgetsLib.cpp
+++ b/kernel-shark-qt/src/KsWidgetsLib.cpp
@@ -664,7 +664,7 @@ KsEventsCheckBoxWidget::KsEventsCheckBoxWidget(struct t=
ep_handle *tep,
 : KsCheckBoxTreeWidget("Events", parent)
 {
 	QTreeWidgetItem *sysItem, *evtItem;
-	tep_event_format **events(nullptr);
+	tep_event **events(nullptr);
 	QString sysName, evtName;
 	int nEvts(0), i(0);
=20
diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src=
/libkshark-configio.c
index 4fe7de3..d7b8a69 100644
--- a/kernel-shark-qt/src/libkshark-configio.c
+++ b/kernel-shark-qt/src/libkshark-configio.c
@@ -691,7 +691,7 @@ static bool kshark_event_filter_to_json(struct tep_hand=
le *pevent,
 					struct json_object *jobj)
 {
 	json_object *jfilter_data, *jevent, *jsystem, *jname;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	int i, evt, *ids, nr_events;
 	char *temp;
=20
@@ -797,7 +797,7 @@ static bool kshark_event_filter_from_json(struct tep_ha=
ndle *pevent,
 {
 	json_object *jfilter, *jevent, *jsystem, *jname;
 	const char *system_str, *name_str;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	int i, length;
=20
 	/*
@@ -1015,7 +1015,7 @@ static bool kshark_adv_filters_to_json(struct kshark_=
context *kshark_ctx,
 {
 	struct tep_event_filter *adv_filter =3D kshark_ctx->advanced_event_filter=
;
 	json_object *jfilter_data, *jevent, *jsystem, *jname, *jfilter;
-	struct tep_event_format **events;
+	struct tep_event **events;
 	char *str;
 	int i;
=20
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index 86d3e58..72279bf 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -997,7 +997,7 @@ static const char *kshark_get_latency(struct tep_handle=
 *pe,
=20
 static const char *kshark_get_info(struct tep_handle *pe,
 				   struct tep_record *record,
-				   struct tep_event_format *event)
+				   struct tep_event *event)
 {
 	char *pos;
=20
@@ -1166,7 +1166,7 @@ int kshark_get_event_id_easy(struct kshark_entry *ent=
ry)
 const char *kshark_get_event_name_easy(struct kshark_entry *entry)
 {
 	struct kshark_context *kshark_ctx =3D NULL;
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	int event_id =3D kshark_get_event_id_easy(entry);
 	if (event_id =3D=3D -EFAULT)
@@ -1205,7 +1205,7 @@ const char *kshark_get_event_name_easy(struct kshark_=
entry *entry)
 const char *kshark_get_info_easy(struct kshark_entry *entry)
 {
 	struct kshark_context *kshark_ctx =3D NULL;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_record *data;
 	const char *info =3D NULL;
 	int event_id;
@@ -1311,7 +1311,7 @@ char* kshark_dump_entry(const struct kshark_entry *en=
try)
 	task =3D tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
=20
 	if (entry->event_id >=3D 0) {
-		struct tep_event_format *event;
+		struct tep_event *event;
 		struct tep_record *data;
=20
 		data =3D kshark_read_at(kshark_ctx, entry->offset);
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/s=
rc/plugins/sched_events.c
index 59ffcfe..79b1428 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -26,7 +26,7 @@ struct plugin_sched_context *plugin_sched_context_handler=
 =3D NULL;
 static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 {
 	struct plugin_sched_context *plugin_ctx;
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	/* No context should exist when we initialize the plugin. */
 	assert(plugin_sched_context_handler =3D=3D NULL);
diff --git a/kernel-shark-qt/src/plugins/sched_events.h b/kernel-shark-qt/s=
rc/plugins/sched_events.h
index 28625e3..262119a 100644
--- a/kernel-shark-qt/src/plugins/sched_events.h
+++ b/kernel-shark-qt/src/plugins/sched_events.h
@@ -28,7 +28,7 @@ struct plugin_sched_context {
 	struct tep_handle	*pevent;
=20
 	/** Pointer to the sched_switch_event object. */
-	struct tep_event_format	*sched_switch_event;
+	struct tep_event	*sched_switch_event;
=20
 	/** Pointer to the sched_switch_next_field format descriptor. */
 	struct tep_format_field	*sched_switch_next_field;
@@ -40,7 +40,7 @@ struct plugin_sched_context {
 	struct tep_format_field	*sched_switch_prev_state_field;
=20
 	/** Pointer to the sched_wakeup_event object. */
-	struct tep_event_format	*sched_wakeup_event;
+	struct tep_event	*sched_wakeup_event;
=20
 	/** Pointer to the sched_wakeup_pid_field format descriptor. */
 	struct tep_format_field	*sched_wakeup_pid_field;
@@ -49,7 +49,7 @@ struct plugin_sched_context {
 	struct tep_format_field	*sched_wakeup_success_field;
=20
 	/** Pointer to the sched_wakeup_new_event object. */
-	struct tep_event_format	*sched_wakeup_new_event;
+	struct tep_event	*sched_wakeup_new_event;
=20
 	/** Pointer to the sched_wakeup_new_pid_field format descriptor. */
 	struct tep_format_field	*sched_wakeup_new_pid_field;
diff --git a/kernel-shark/include/trace-view-store.h b/kernel-shark/include=
/trace-view-store.h
index 1f65481..ae95eaa 100644
--- a/kernel-shark/include/trace-view-store.h
+++ b/kernel-shark/include/trace-view-store.h
@@ -83,11 +83,11 @@ struct trace_view_store
=20
 	/* Tracecmd specific info */
 	struct tracecmd_input *handle;
-	struct tep_event_format	*sched_switch_event;
+	struct tep_event	*sched_switch_event;
 	struct tep_format_field	*sched_switch_next_field;
-	struct tep_event_format	*sched_wakeup_event;
+	struct tep_event	*sched_wakeup_event;
 	struct tep_format_field	*sched_wakeup_pid_field;
-	struct tep_event_format	*sched_wakeup_new_event;
+	struct tep_event	*sched_wakeup_new_event;
 	struct tep_format_field	*sched_wakeup_new_pid_field;
 	int			cpus;
=20
diff --git a/kernel-shark/trace-capture.c b/kernel-shark/trace-capture.c
index e3e6ebc..aa678d4 100644
--- a/kernel-shark/trace-capture.c
+++ b/kernel-shark/trace-capture.c
@@ -349,7 +349,7 @@ static char *find_tracecmd(void)
=20
 static int add_trace_cmd_words(struct trace_capture *cap, char **args)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	char **systems =3D cap->info->cap_systems;
 	const gchar *output;
 	int *events =3D cap->info->cap_events;
@@ -808,7 +808,7 @@ static int load_events(struct trace_capture *cap,
 {
 	struct shark_info *info =3D cap->info;
 	struct tracecmd_xml_system_node *event_node;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_handle *pevent =3D cap->pevent;
 	const char *name;
 	int *events =3D NULL;
@@ -997,7 +997,7 @@ static void save_events(struct trace_capture *cap,
 			struct tracecmd_xml_handle *handle)
 {
 	struct tep_handle *pevent =3D cap->pevent;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	char **systems =3D cap->info->cap_systems;
 	int *events =3D cap->info->cap_events;
 	int i;
diff --git a/kernel-shark/trace-dialog.c b/kernel-shark/trace-dialog.c
index ac44ee3..fcb0554 100644
--- a/kernel-shark/trace-dialog.c
+++ b/kernel-shark/trace-dialog.c
@@ -373,7 +373,7 @@ GtkResponseType trace_dialog(GtkWindow *parent, enum tr=
ace_dialog_type type,
 }
=20
 static void read_raw_events(struct trace_seq *s,
-			    struct tep_event_format *event,
+			    struct tep_event *event,
 			    struct tep_record *record)
 {
 	struct tep_format_field **fields;
@@ -395,7 +395,7 @@ static void read_raw_events(struct trace_seq *s,
 void trace_show_record_dialog(GtkWindow *parent, struct tep_handle *pevent=
,
 			      struct tep_record *record, gboolean raw)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct trace_seq s;
 	int type;
=20
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index 90d1f39..61b016d 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -87,8 +87,8 @@ static GtkTreeModel *create_event_combo_model(gpointer da=
ta)
 	GtkTreeStore *tree;
 	GtkTreeIter sys_iter;
 	GtkTreeIter iter;
-	struct tep_event_format **events;
-	struct tep_event_format *event;
+	struct tep_event **events;
+	struct tep_event *event;
 	const char *last_sys =3D NULL;
 	int i;
=20
@@ -145,7 +145,7 @@ static GtkTreeModel *create_field_combo_model(gpointer =
data)
 	struct tep_handle *pevent =3D data;
 	GtkListStore *list;
 	GtkTreeIter iter;
-	struct tep_event_format **events;
+	struct tep_event **events;
 	struct tep_format_field **fields;
 	struct tep_format_field *field;
 	int i;
@@ -177,8 +177,8 @@ static void update_field_combo(struct tep_handle *peven=
t,
 			       const char *system,
 			       const char *event_name)
 {
-	struct tep_event_format **events;
-	struct tep_event_format *event;
+	struct tep_event **events;
+	struct tep_event *event;
 	struct tep_format_field **fields;
 	struct tep_format_field *field;
 	GtkTreeModel *model;
@@ -457,7 +457,7 @@ create_tree_filter_model(struct tep_handle *pevent,
 {
 	GtkTreeStore *treestore;
 	GtkTreeIter iter_events;
-	struct tep_event_format **events;
+	struct tep_event **events;
 	char *str;
 	gint i;
=20
@@ -1063,8 +1063,8 @@ create_tree_event_model(struct tep_handle *pevent,
 {
 	GtkTreeStore *treestore;
 	GtkTreeIter iter_all, iter_sys, iter_events;
-	struct tep_event_format **events;
-	struct tep_event_format *event;
+	struct tep_event **events;
+	struct tep_event *event;
 	char *last_system =3D NULL;
 	gboolean sysactive;
 	gboolean active, normal;
@@ -1923,8 +1923,8 @@ void trace_filter_convert_filter_to_names(struct tep_=
event_filter *filter,
 					  gint **event_ids)
 {
 	struct tep_handle *pevent =3D filter->pevent;
-	struct tep_event_format **events;
-	struct tep_event_format *event;
+	struct tep_event **events;
+	struct tep_event *event;
 	char *last_system =3D NULL;
 	int all_selected =3D 1;
 	int start_sys =3D 0;
@@ -1986,7 +1986,7 @@ void trace_filter_convert_char_to_filter(struct tep_e=
vent_filter *filter,
 {
 	struct tep_handle *pevent;
 	struct tep_event_filter *copy;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	int i;
=20
 	pevent =3D filter->pevent;
@@ -2019,7 +2019,7 @@ void trace_filter_convert_char_to_filter(struct tep_e=
vent_filter *filter,
 int trace_filter_save_events(struct tracecmd_xml_handle *handle,
 			     struct tep_event_filter *filter)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	char **systems;
 	gint *event_ids;
 	char *str;
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index fe28019..7aa0771 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -1007,7 +1007,7 @@ int trace_graph_check_sched_wakeup(struct graph_info =
*ginfo,
 				   struct tep_record *record,
 				   gint *pid)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	unsigned long long val;
 	gboolean found;
 	gint id;
@@ -1074,7 +1074,7 @@ int trace_graph_check_sched_switch(struct graph_info =
*ginfo,
 				   gint *pid, const char **comm)
 {
 	unsigned long long val;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	gint this_pid;
 	gint id;
 	int ret =3D 1;
@@ -1153,8 +1153,8 @@ enum graph_irq_type
 trace_graph_check_irq(struct graph_info *ginfo,
 		      struct tep_record *record)
 {
-	struct tep_event_format *event;
-	struct tep_event_format **events;
+	struct tep_event *event;
+	struct tep_event **events;
 	gint id;
 	int i;
=20
diff --git a/kernel-shark/trace-plot-cpu.c b/kernel-shark/trace-plot-cpu.c
index 0c520f4..8c6402c 100644
--- a/kernel-shark/trace-plot-cpu.c
+++ b/kernel-shark/trace-plot-cpu.c
@@ -117,7 +117,7 @@ static int cpu_plot_display_last_event(struct graph_inf=
o *ginfo,
 				       unsigned long long time)
 {
 	struct cpu_plot_info *cpu_info =3D plot->private;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_record *record;
 	int cpu =3D cpu_info->cpu;
 	unsigned long long offset =3D 0;
@@ -353,7 +353,7 @@ int cpu_plot_display_info(struct graph_info *ginfo,
 			  unsigned long long time)
 {
 	struct cpu_plot_info *cpu_info =3D plot->private;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_record *record;
 	struct tep_record *next_record;
 	struct tep_handle *pevent;
diff --git a/kernel-shark/trace-plot-task.c b/kernel-shark/trace-plot-task.=
c
index c5866c4..ebea6e2 100644
--- a/kernel-shark/trace-plot-task.c
+++ b/kernel-shark/trace-plot-task.c
@@ -240,7 +240,7 @@ static int task_plot_display_last_event(struct graph_in=
fo *ginfo,
 					unsigned long long time)
 {
 	struct task_plot_info *task_info =3D plot->private;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_record *record;
 	struct offset_cache *offsets;
 	gboolean is_sched;
@@ -734,7 +734,7 @@ int task_plot_display_info(struct graph_info *ginfo,
 			  unsigned long long time)
 {
 	struct task_plot_info *task_info =3D plot->private;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_record *record;
 	struct tep_handle *pevent;
 	unsigned long sec, usec;
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-stor=
e.c
index 53fab98..c457a81 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -406,7 +406,7 @@ trace_view_store_get_value (GtkTreeModel *tree_model,
 	TraceViewStore	*trace_view_store;
 	struct trace_seq s;
 	struct tep_handle *pevent;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_record *data;
 	const gchar *comm;
 	gchar *str;
diff --git a/lib/trace-cmd/trace-blk-hack.c b/lib/trace-cmd/trace-blk-hack.=
c
index 45ba77a..4f5953a 100644
--- a/lib/trace-cmd/trace-blk-hack.c
+++ b/lib/trace-cmd/trace-blk-hack.c
@@ -32,7 +32,7 @@ static const char blk_body[] =3D "\n"
 int tracecmd_blk_hack(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_format_field *field;
 	char buf[4096]; /* way more than enough! */
 	int id;
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 974f8b6..ba68a19 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -44,7 +44,7 @@ static void find_long_size(struct tracecmd_ftrace *finfo)
=20
 static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle=
 *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	/* Store the func ret id and event for later use */
 	event =3D tep_find_event_by_name(pevent, "ftrace", "funcgraph_exit");
@@ -63,7 +63,7 @@ static int find_ret_event(struct tracecmd_ftrace *finfo, =
struct tep_handle *peve
 	} while (0)
=20
 static int function_handler(struct trace_seq *s, struct tep_record *record=
,
-			    struct tep_event_format *event, void *context)
+			    struct tep_event *event, void *context)
 {
 	struct tep_handle *pevent =3D event->pevent;
 	unsigned long long function;
@@ -187,7 +187,7 @@ static void print_graph_duration(struct trace_seq *s, u=
nsigned long long duratio
=20
 static int
 print_graph_entry_leaf(struct trace_seq *s,
-		       struct tep_event_format *event,
+		       struct tep_event *event,
 		       struct tep_record *record,
 		       struct tep_record *ret_rec,
 		       struct tracecmd_ftrace *finfo)
@@ -237,7 +237,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 }
=20
 static int print_graph_nested(struct trace_seq *s,
-			      struct tep_event_format *event,
+			      struct tep_event *event,
 			      struct tep_record *record)
 {
 	struct tep_handle *pevent =3D event->pevent;
@@ -278,7 +278,7 @@ static int print_graph_nested(struct trace_seq *s,
=20
 static int
 fgraph_ent_handler(struct trace_seq *s, struct tep_record *record,
-		   struct tep_event_format *event, void *context)
+		   struct tep_event *event, void *context)
 {
 	struct tracecmd_ftrace *finfo =3D context;
 	struct tep_record *rec;
@@ -312,7 +312,7 @@ fgraph_ent_handler(struct trace_seq *s, struct tep_reco=
rd *record,
=20
 static int
 fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
-		   struct tep_event_format *event, void *context)
+		   struct tep_event *event, void *context)
 {
 	struct tracecmd_ftrace *finfo =3D context;
 	unsigned long long rettime, calltime;
@@ -363,7 +363,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_reco=
rd *record,
=20
 static int
 trace_stack_handler(struct trace_seq *s, struct tep_record *record,
-		    struct tep_event_format *event, void *context)
+		    struct tep_event *event, void *context)
 {
 	struct tracecmd_ftrace *finfo =3D context;
 	struct tep_format_field *field;
@@ -415,7 +415,7 @@ int tracecmd_ftrace_overrides(struct tracecmd_input *ha=
ndle,
 	struct tracecmd_ftrace *finfo)
 {
 	struct tep_handle *pevent;
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	finfo->handle =3D handle;
=20
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-=
api.c
index c8b7bfe..6641780 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -16,7 +16,7 @@
  * This returns pointer to the element of the events array with the given =
index
  * If @tep is NULL, or @index is not in the range 0 .. nr_events, NULL is =
returned.
  */
-struct tep_event_format *tep_get_event(struct tep_handle *tep, int index)
+struct tep_event *tep_get_event(struct tep_handle *tep, int index)
 {
 	if (tep && tep->events && index < tep->nr_events)
 		return tep->events[index];
@@ -31,7 +31,7 @@ struct tep_event_format *tep_get_event(struct tep_handle =
*tep, int index)
  * This returns pointer to the first element of the events array
  * If @tep is NULL, NULL is returned.
  */
-struct tep_event_format *tep_get_first_event(struct tep_handle *tep)
+struct tep_event *tep_get_first_event(struct tep_handle *tep)
 {
 	return tep_get_event(tep, 0);
 }
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-pars=
e-local.h
index 6df0e57..3198e9b 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -50,9 +50,9 @@ struct tep_handle {
 	unsigned int printk_count;
=20
=20
-	struct tep_event_format **events;
+	struct tep_event **events;
 	int nr_events;
-	struct tep_event_format **sort_events;
+	struct tep_event **sort_events;
 	enum tep_event_sort_type last_type;
=20
 	int type_offset;
@@ -86,7 +86,7 @@ struct tep_handle {
 	int parsing_failures;
=20
 	/* cache */
-	struct tep_event_format *last_event;
+	struct tep_event *last_event;
=20
 	char *trace_clock;
 };
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 57e3615..d0072b0 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -97,7 +97,7 @@ struct tep_function_handler {
=20
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct tep_event_format *event, struct tep_print_arg *arg);
+		     struct tep_event *event, struct tep_print_arg *arg);
=20
 static void free_func_handle(struct tep_function_handler *func);
=20
@@ -740,15 +740,15 @@ void tep_print_printk(struct tep_handle *pevent)
 	}
 }
=20
-static struct tep_event_format *alloc_event(void)
+static struct tep_event *alloc_event(void)
 {
-	return calloc(1, sizeof(struct tep_event_format));
+	return calloc(1, sizeof(struct tep_event));
 }
=20
-static int add_event(struct tep_handle *pevent, struct tep_event_format *e=
vent)
+static int add_event(struct tep_handle *pevent, struct tep_event *event)
 {
 	int i;
-	struct tep_event_format **events =3D realloc(pevent->events, sizeof(event=
) *
+	struct tep_event **events =3D realloc(pevent->events, sizeof(event) *
 						  (pevent->nr_events + 1));
 	if (!events)
 		return -1;
@@ -1356,7 +1356,7 @@ static unsigned int type_size(const char *name)
 	return 0;
 }
=20
-static int event_read_fields(struct tep_event_format *event, struct tep_fo=
rmat_field **fields)
+static int event_read_fields(struct tep_event *event, struct tep_format_fi=
eld **fields)
 {
 	struct tep_format_field *field =3D NULL;
 	enum tep_event_type type;
@@ -1643,7 +1643,7 @@ fail_expect:
 	return -1;
 }
=20
-static int event_read_format(struct tep_event_format *event)
+static int event_read_format(struct tep_event *event)
 {
 	char *token;
 	int ret;
@@ -1676,11 +1676,11 @@ static int event_read_format(struct tep_event_forma=
t *event)
 }
=20
 static enum tep_event_type
-process_arg_token(struct tep_event_format *event, struct tep_print_arg *ar=
g,
+process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		  char **tok, enum tep_event_type type);
=20
 static enum tep_event_type
-process_arg(struct tep_event_format *event, struct tep_print_arg *arg, cha=
r **tok)
+process_arg(struct tep_event *event, struct tep_print_arg *arg, char **tok=
)
 {
 	enum tep_event_type type;
 	char *token;
@@ -1692,14 +1692,14 @@ process_arg(struct tep_event_format *event, struct =
tep_print_arg *arg, char **to
 }
=20
 static enum tep_event_type
-process_op(struct tep_event_format *event, struct tep_print_arg *arg, char=
 **tok);
+process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)=
;
=20
 /*
  * For __print_symbolic() and __print_flags, we need to completely
  * evaluate the first argument, which defines what to print next.
  */
 static enum tep_event_type
-process_field_arg(struct tep_event_format *event, struct tep_print_arg *ar=
g, char **tok)
+process_field_arg(struct tep_event *event, struct tep_print_arg *arg, char=
 **tok)
 {
 	enum tep_event_type type;
=20
@@ -1713,7 +1713,7 @@ process_field_arg(struct tep_event_format *event, str=
uct tep_print_arg *arg, cha
 }
=20
 static enum tep_event_type
-process_cond(struct tep_event_format *event, struct tep_print_arg *top, ch=
ar **tok)
+process_cond(struct tep_event *event, struct tep_print_arg *top, char **to=
k)
 {
 	struct tep_print_arg *arg, *left, *right;
 	enum tep_event_type type;
@@ -1769,7 +1769,7 @@ out_free:
 }
=20
 static enum tep_event_type
-process_array(struct tep_event_format *event, struct tep_print_arg *top, c=
har **tok)
+process_array(struct tep_event *event, struct tep_print_arg *top, char **t=
ok)
 {
 	struct tep_print_arg *arg;
 	enum tep_event_type type;
@@ -1871,7 +1871,7 @@ static int set_op_prio(struct tep_print_arg *arg)
=20
 /* Note, *tok does not get freed, but will most likely be saved */
 static enum tep_event_type
-process_op(struct tep_event_format *event, struct tep_print_arg *arg, char=
 **tok)
+process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 {
 	struct tep_print_arg *left, *right =3D NULL;
 	enum tep_event_type type;
@@ -2072,7 +2072,7 @@ out_free:
 }
=20
 static enum tep_event_type
-process_entry(struct tep_event_format *event __maybe_unused, struct tep_pr=
int_arg *arg,
+process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg=
 *arg,
 	      char **tok)
 {
 	enum tep_event_type type;
@@ -2111,7 +2111,7 @@ process_entry(struct tep_event_format *event __maybe_=
unused, struct tep_print_ar
 	return TEP_EVENT_ERROR;
 }
=20
-static int alloc_and_process_delim(struct tep_event_format *event, char *n=
ext_token,
+static int alloc_and_process_delim(struct tep_event *event, char *next_tok=
en,
 				   struct tep_print_arg **print_arg)
 {
 	struct tep_print_arg *field;
@@ -2446,7 +2446,7 @@ static char *arg_eval (struct tep_print_arg *arg)
 }
=20
 static enum tep_event_type
-process_fields(struct tep_event_format *event, struct tep_print_flag_sym *=
*list, char **tok)
+process_fields(struct tep_event *event, struct tep_print_flag_sym **list, =
char **tok)
 {
 	enum tep_event_type type;
 	struct tep_print_arg *arg =3D NULL;
@@ -2527,7 +2527,7 @@ out_free:
 }
=20
 static enum tep_event_type
-process_flags(struct tep_event_format *event, struct tep_print_arg *arg, c=
har **tok)
+process_flags(struct tep_event *event, struct tep_print_arg *arg, char **t=
ok)
 {
 	struct tep_print_arg *field;
 	enum tep_event_type type;
@@ -2580,7 +2580,7 @@ out_free:
 }
=20
 static enum tep_event_type
-process_symbols(struct tep_event_format *event, struct tep_print_arg *arg,=
 char **tok)
+process_symbols(struct tep_event *event, struct tep_print_arg *arg, char *=
*tok)
 {
 	struct tep_print_arg *field;
 	enum tep_event_type type;
@@ -2619,7 +2619,7 @@ out_free:
 }
=20
 static enum tep_event_type
-process_hex_common(struct tep_event_format *event, struct tep_print_arg *a=
rg,
+process_hex_common(struct tep_event *event, struct tep_print_arg *arg,
 		   char **tok, enum tep_print_arg_type type)
 {
 	memset(arg, 0, sizeof(*arg));
@@ -2642,20 +2642,20 @@ out:
 }
=20
 static enum tep_event_type
-process_hex(struct tep_event_format *event, struct tep_print_arg *arg, cha=
r **tok)
+process_hex(struct tep_event *event, struct tep_print_arg *arg, char **tok=
)
 {
 	return process_hex_common(event, arg, tok, TEP_PRINT_HEX);
 }
=20
 static enum tep_event_type
-process_hex_str(struct tep_event_format *event, struct tep_print_arg *arg,
+process_hex_str(struct tep_event *event, struct tep_print_arg *arg,
 		char **tok)
 {
 	return process_hex_common(event, arg, tok, TEP_PRINT_HEX_STR);
 }
=20
 static enum tep_event_type
-process_int_array(struct tep_event_format *event, struct tep_print_arg *ar=
g, char **tok)
+process_int_array(struct tep_event *event, struct tep_print_arg *arg, char=
 **tok)
 {
 	memset(arg, 0, sizeof(*arg));
 	arg->type =3D TEP_PRINT_INT_ARRAY;
@@ -2683,7 +2683,7 @@ out:
 }
=20
 static enum tep_event_type
-process_dynamic_array(struct tep_event_format *event, struct tep_print_arg=
 *arg, char **tok)
+process_dynamic_array(struct tep_event *event, struct tep_print_arg *arg, =
char **tok)
 {
 	struct tep_format_field *field;
 	enum tep_event_type type;
@@ -2747,7 +2747,7 @@ process_dynamic_array(struct tep_event_format *event,=
 struct tep_print_arg *arg,
 }
=20
 static enum tep_event_type
-process_dynamic_array_len(struct tep_event_format *event, struct tep_print=
_arg *arg,
+process_dynamic_array_len(struct tep_event *event, struct tep_print_arg *a=
rg,
 			  char **tok)
 {
 	struct tep_format_field *field;
@@ -2783,7 +2783,7 @@ process_dynamic_array_len(struct tep_event_format *ev=
ent, struct tep_print_arg *
 }
=20
 static enum tep_event_type
-process_paren(struct tep_event_format *event, struct tep_print_arg *arg, c=
har **tok)
+process_paren(struct tep_event *event, struct tep_print_arg *arg, char **t=
ok)
 {
 	struct tep_print_arg *item_arg;
 	enum tep_event_type type;
@@ -2846,7 +2846,7 @@ process_paren(struct tep_event_format *event, struct =
tep_print_arg *arg, char **
=20
=20
 static enum tep_event_type
-process_str(struct tep_event_format *event __maybe_unused, struct tep_prin=
t_arg *arg,
+process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *=
arg,
 	    char **tok)
 {
 	enum tep_event_type type;
@@ -2875,7 +2875,7 @@ process_str(struct tep_event_format *event __maybe_un=
used, struct tep_print_arg
 }
=20
 static enum tep_event_type
-process_bitmask(struct tep_event_format *event __maybe_unused, struct tep_=
print_arg *arg,
+process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_a=
rg *arg,
 		char **tok)
 {
 	enum tep_event_type type;
@@ -2936,7 +2936,7 @@ static void remove_func_handler(struct tep_handle *pe=
vent, char *func_name)
 }
=20
 static enum tep_event_type
-process_func_handler(struct tep_event_format *event, struct tep_function_h=
andler *func,
+process_func_handler(struct tep_event *event, struct tep_function_handler =
*func,
 		     struct tep_print_arg *arg, char **tok)
 {
 	struct tep_print_arg **next_arg;
@@ -2994,7 +2994,7 @@ err:
 }
=20
 static enum tep_event_type
-process_function(struct tep_event_format *event, struct tep_print_arg *arg=
,
+process_function(struct tep_event *event, struct tep_print_arg *arg,
 		 char *token, char **tok)
 {
 	struct tep_function_handler *func;
@@ -3050,7 +3050,7 @@ process_function(struct tep_event_format *event, stru=
ct tep_print_arg *arg,
 }
=20
 static enum tep_event_type
-process_arg_token(struct tep_event_format *event, struct tep_print_arg *ar=
g,
+process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		  char **tok, enum tep_event_type type)
 {
 	char *token;
@@ -3138,7 +3138,7 @@ process_arg_token(struct tep_event_format *event, str=
uct tep_print_arg *arg,
 	return type;
 }
=20
-static int event_read_print_args(struct tep_event_format *event, struct te=
p_print_arg **list)
+static int event_read_print_args(struct tep_event *event, struct tep_print=
_arg **list)
 {
 	enum tep_event_type type =3D TEP_EVENT_ERROR;
 	struct tep_print_arg *arg;
@@ -3196,7 +3196,7 @@ static int event_read_print_args(struct tep_event_for=
mat *event, struct tep_prin
 	return args;
 }
=20
-static int event_read_print(struct tep_event_format *event)
+static int event_read_print(struct tep_event *event)
 {
 	enum tep_event_type type;
 	char *token;
@@ -3262,7 +3262,7 @@ static int event_read_print(struct tep_event_format *=
event)
  * This only searchs the common fields and not all field.
  */
 struct tep_format_field *
-tep_find_common_field(struct tep_event_format *event, const char *name)
+tep_find_common_field(struct tep_event *event, const char *name)
 {
 	struct tep_format_field *format;
=20
@@ -3284,7 +3284,7 @@ tep_find_common_field(struct tep_event_format *event,=
 const char *name)
  * This does not search common fields.
  */
 struct tep_format_field *
-tep_find_field(struct tep_event_format *event, const char *name)
+tep_find_field(struct tep_event *event, const char *name)
 {
 	struct tep_format_field *format;
=20
@@ -3307,7 +3307,7 @@ tep_find_field(struct tep_event_format *event, const =
char *name)
  * the non-common ones if a common one was not found.
  */
 struct tep_format_field *
-tep_find_any_field(struct tep_event_format *event, const char *name)
+tep_find_any_field(struct tep_event *event, const char *name)
 {
 	struct tep_format_field *format;
=20
@@ -3376,7 +3376,7 @@ int tep_read_number_field(struct tep_format_field *fi=
eld, const void *data,
 static int get_common_info(struct tep_handle *pevent,
 			   const char *type, int *offset, int *size)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_format_field *field;
=20
 	/*
@@ -3463,11 +3463,11 @@ static int events_id_cmp(const void *a, const void =
*b);
  *
  * Returns an event that has a given @id.
  */
-struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id)
+struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
 {
-	struct tep_event_format **eventptr;
-	struct tep_event_format key;
-	struct tep_event_format *pkey =3D &key;
+	struct tep_event **eventptr;
+	struct tep_event key;
+	struct tep_event *pkey =3D &key;
=20
 	/* Check cache first */
 	if (pevent->last_event && pevent->last_event->id =3D=3D id)
@@ -3495,11 +3495,11 @@ struct tep_event_format *tep_find_event(struct tep_=
handle *pevent, int id)
  * This returns an event with a given @name and under the system
  * @sys. If @sys is NULL the first event with @name is returned.
  */
-struct tep_event_format *
+struct tep_event *
 tep_find_event_by_name(struct tep_handle *pevent,
 		       const char *sys, const char *name)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	int i;
=20
 	if (pevent->last_event &&
@@ -3524,7 +3524,7 @@ tep_find_event_by_name(struct tep_handle *pevent,
 }
=20
 static unsigned long long
-eval_num_arg(void *data, int size, struct tep_event_format *event, struct =
tep_print_arg *arg)
+eval_num_arg(void *data, int size, struct tep_event *event, struct tep_pri=
nt_arg *arg)
 {
 	struct tep_handle *pevent =3D event->pevent;
 	unsigned long long val =3D 0;
@@ -3864,7 +3864,7 @@ static void print_bitmask_to_seq(struct tep_handle *p=
event,
 }
=20
 static void print_str_arg(struct trace_seq *s, void *data, int size,
-			  struct tep_event_format *event, const char *format,
+			  struct tep_event *event, const char *format,
 			  int len_arg, struct tep_print_arg *arg)
 {
 	struct tep_handle *pevent =3D event->pevent;
@@ -4119,7 +4119,7 @@ out_warning_field:
=20
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct tep_event_format *event, struct tep_print_arg *arg)
+		     struct tep_event *event, struct tep_print_arg *arg)
 {
 	struct tep_function_handler *func_handle =3D arg->func.func;
 	struct func_params *param;
@@ -4214,7 +4214,7 @@ static void free_args(struct tep_print_arg *args)
 	}
 }
=20
-static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int s=
ize, struct tep_event_format *event)
+static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int s=
ize, struct tep_event *event)
 {
 	struct tep_handle *pevent =3D event->pevent;
 	struct tep_format_field *field, *ip_field;
@@ -4391,7 +4391,7 @@ out_free:
=20
 static char *
 get_bprint_format(void *data, int size __maybe_unused,
-		  struct tep_event_format *event)
+		  struct tep_event *event)
 {
 	struct tep_handle *pevent =3D event->pevent;
 	unsigned long long addr;
@@ -4426,7 +4426,7 @@ get_bprint_format(void *data, int size __maybe_unused=
,
 }
=20
 static void print_mac_arg(struct trace_seq *s, int mac, void *data, int si=
ze,
-			  struct tep_event_format *event, struct tep_print_arg *arg)
+			  struct tep_event *event, struct tep_print_arg *arg)
 {
 	unsigned char *buf;
 	const char *fmt =3D "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
@@ -4579,7 +4579,7 @@ static void print_ip6_addr(struct trace_seq *s, char =
i, unsigned char *buf)
  * %pISpc print an IP address based on sockaddr; p adds port.
  */
 static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct tep_event_format *event,
+			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
 {
 	unsigned char *buf;
@@ -4616,7 +4616,7 @@ static int print_ipv4_arg(struct trace_seq *s, const =
char *ptr, char i,
 }
=20
 static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct tep_event_format *event,
+			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
 {
 	char have_c =3D 0;
@@ -4666,7 +4666,7 @@ static int print_ipv6_arg(struct trace_seq *s, const =
char *ptr, char i,
 }
=20
 static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct tep_event_format *event,
+			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
 {
 	char have_c =3D 0, have_p =3D 0;
@@ -4748,7 +4748,7 @@ static int print_ipsa_arg(struct trace_seq *s, const =
char *ptr, char i,
 }
=20
 static int print_ip_arg(struct trace_seq *s, const char *ptr,
-			void *data, int size, struct tep_event_format *event,
+			void *data, int size, struct tep_event *event,
 			struct tep_print_arg *arg)
 {
 	char i =3D *ptr;  /* 'i' or 'I' */
@@ -4855,7 +4855,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 }
=20
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct tep_event_format *event)
+		      int size __maybe_unused, struct tep_event *event)
 {
 	struct tep_format_field *field;
=20
@@ -4867,7 +4867,7 @@ void tep_print_fields(struct trace_seq *s, void *data=
,
 	}
 }
=20
-static void pretty_print(struct trace_seq *s, void *data, int size, struct=
 tep_event_format *event)
+static void pretty_print(struct trace_seq *s, void *data, int size, struct=
 tep_event *event)
 {
 	struct tep_handle *pevent =3D event->pevent;
 	struct tep_print_fmt *print_fmt =3D &event->print_fmt;
@@ -5231,7 +5231,7 @@ int tep_data_type(struct tep_handle *pevent, struct t=
ep_record *rec)
  *
  * This returns the event form a given @type;
  */
-struct tep_event_format *tep_data_event_from_type(struct tep_handle *peven=
t, int type)
+struct tep_event *tep_data_event_from_type(struct tep_handle *pevent, int =
type)
 {
 	return tep_find_event(pevent, type);
 }
@@ -5389,7 +5389,7 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct=
 cmdline *cmdline)
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
  */
-void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
+void tep_event_info(struct trace_seq *s, struct tep_event *event,
 		    struct tep_record *record)
 {
 	int print_pretty =3D 1;
@@ -5430,7 +5430,7 @@ static bool is_timestamp_in_us(char *trace_clock, boo=
l use_trace_clock)
  * Returns the associated event for a given record, or NULL if non is
  * is found.
  */
-struct tep_event_format *
+struct tep_event *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *rec=
ord)
 {
 	int type;
@@ -5455,7 +5455,7 @@ tep_find_event_by_record(struct tep_handle *pevent, s=
truct tep_record *record)
  * Writes the tasks comm, pid and CPU to @s.
  */
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record)
 {
 	void *data =3D record->data;
@@ -5483,7 +5483,7 @@ void tep_print_event_task(struct tep_handle *pevent, =
struct trace_seq *s,
  * Writes the timestamp of the record into @s.
  */
 void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record,
 			  bool use_trace_clock)
 {
@@ -5533,7 +5533,7 @@ void tep_print_event_time(struct tep_handle *pevent, =
struct trace_seq *s,
  * Writes the parsing of the record's data to @s.
  */
 void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record)
 {
 	static const char *spaces =3D "                    "; /* 20 spaces */
@@ -5552,7 +5552,7 @@ void tep_print_event_data(struct tep_handle *pevent, =
struct trace_seq *s,
 void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D tep_find_event_by_record(pevent, record);
 	if (!event) {
@@ -5574,8 +5574,8 @@ void tep_print_event(struct tep_handle *pevent, struc=
t trace_seq *s,
=20
 static int events_id_cmp(const void *a, const void *b)
 {
-	struct tep_event_format * const * ea =3D a;
-	struct tep_event_format * const * eb =3D b;
+	struct tep_event * const * ea =3D a;
+	struct tep_event * const * eb =3D b;
=20
 	if ((*ea)->id < (*eb)->id)
 		return -1;
@@ -5588,8 +5588,8 @@ static int events_id_cmp(const void *a, const void *b=
)
=20
 static int events_name_cmp(const void *a, const void *b)
 {
-	struct tep_event_format * const * ea =3D a;
-	struct tep_event_format * const * eb =3D b;
+	struct tep_event * const * ea =3D a;
+	struct tep_event * const * eb =3D b;
 	int res;
=20
 	res =3D strcmp((*ea)->name, (*eb)->name);
@@ -5605,8 +5605,8 @@ static int events_name_cmp(const void *a, const void =
*b)
=20
 static int events_system_cmp(const void *a, const void *b)
 {
-	struct tep_event_format * const * ea =3D a;
-	struct tep_event_format * const * eb =3D b;
+	struct tep_event * const * ea =3D a;
+	struct tep_event * const * eb =3D b;
 	int res;
=20
 	res =3D strcmp((*ea)->system, (*eb)->system);
@@ -5620,9 +5620,9 @@ static int events_system_cmp(const void *a, const voi=
d *b)
 	return events_id_cmp(a, b);
 }
=20
-struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum =
tep_event_sort_type sort_type)
+struct tep_event **tep_list_events(struct tep_handle *pevent, enum tep_eve=
nt_sort_type sort_type)
 {
-	struct tep_event_format **events;
+	struct tep_event **events;
 	int (*sort)(const void *a, const void *b);
=20
 	events =3D pevent->sort_events;
@@ -5705,7 +5705,7 @@ get_event_fields(const char *type, const char *name,
  * Returns an allocated array of fields. The last item in the array is NUL=
L.
  * The array must be freed with free().
  */
-struct tep_format_field **tep_event_common_fields(struct tep_event_format =
*event)
+struct tep_format_field **tep_event_common_fields(struct tep_event *event)
 {
 	return get_event_fields("common", event->name,
 				event->format.nr_common,
@@ -5719,7 +5719,7 @@ struct tep_format_field **tep_event_common_fields(str=
uct tep_event_format *event
  * Returns an allocated array of fields. The last item in the array is NUL=
L.
  * The array must be freed with free().
  */
-struct tep_format_field **tep_event_fields(struct tep_event_format *event)
+struct tep_format_field **tep_event_fields(struct tep_event *event)
 {
 	return get_event_fields("event", event->name,
 				event->format.nr_fields,
@@ -5961,7 +5961,7 @@ int tep_parse_header_page(struct tep_handle *pevent, =
char *buf, unsigned long si
 	return 0;
 }
=20
-static int event_matches(struct tep_event_format *event,
+static int event_matches(struct tep_event *event,
 			 int id, const char *sys_name,
 			 const char *event_name)
 {
@@ -5984,7 +5984,7 @@ static void free_handler(struct event_handler *handle=
)
 	free(handle);
 }
=20
-static int find_event_handle(struct tep_handle *pevent, struct tep_event_f=
ormat *event)
+static int find_event_handle(struct tep_handle *pevent, struct tep_event *=
event)
 {
 	struct event_handler *handle, **next;
=20
@@ -6025,11 +6025,11 @@ static int find_event_handle(struct tep_handle *pev=
ent, struct tep_event_format
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
+enum tep_errno __tep_parse_format(struct tep_event **eventp,
 				  struct tep_handle *pevent, const char *buf,
 				  unsigned long size, const char *sys)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	int ret;
=20
 	init_input_buf(buf, size);
@@ -6134,12 +6134,12 @@ enum tep_errno __tep_parse_format(struct tep_event_=
format **eventp,
=20
 static enum tep_errno
 __parse_event(struct tep_handle *pevent,
-	      struct tep_event_format **eventp,
+	      struct tep_event **eventp,
 	      const char *buf, unsigned long size,
 	      const char *sys)
 {
 	int ret =3D __tep_parse_format(eventp, pevent, buf, size, sys);
-	struct tep_event_format *event =3D *eventp;
+	struct tep_event *event =3D *eventp;
=20
 	if (event =3D=3D NULL)
 		return ret;
@@ -6176,7 +6176,7 @@ event_add_failed:
  * /sys/kernel/debug/tracing/events/.../.../format
  */
 enum tep_errno tep_parse_format(struct tep_handle *pevent,
-				struct tep_event_format **eventp,
+				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys)
 {
@@ -6200,7 +6200,7 @@ enum tep_errno tep_parse_format(struct tep_handle *pe=
vent,
 enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys)
 {
-	struct tep_event_format *event =3D NULL;
+	struct tep_event *event =3D NULL;
 	return __parse_event(pevent, &event, buf, size, sys);
 }
=20
@@ -6266,7 +6266,7 @@ int get_field_val(struct trace_seq *s, struct tep_for=
mat_field *field,
  *
  * On failure, it returns NULL.
  */
-void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *even=
t,
+void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 			const char *name, struct tep_record *record,
 			int *len, int err)
 {
@@ -6313,7 +6313,7 @@ void *tep_get_field_raw(struct trace_seq *s, struct t=
ep_event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
+int tep_get_field_val(struct trace_seq *s, struct tep_event *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err)
 {
@@ -6338,7 +6338,7 @@ int tep_get_field_val(struct trace_seq *s, struct tep=
_event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_common_field_val(struct trace_seq *s, struct tep_event_format =
*event,
+int tep_get_common_field_val(struct trace_seq *s, struct tep_event *event,
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err)
 {
@@ -6363,7 +6363,7 @@ int tep_get_common_field_val(struct trace_seq *s, str=
uct tep_event_format *event
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_any_field_val(struct trace_seq *s, struct tep_event_format *ev=
ent,
+int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
 			  const char *name, struct tep_record *record,
 			  unsigned long long *val, int err)
 {
@@ -6389,7 +6389,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct=
 tep_event_format *event,
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
-			struct tep_event_format *event, const char *name,
+			struct tep_event *event, const char *name,
 			struct tep_record *record, int err)
 {
 	struct tep_format_field *field =3D tep_find_field(event, name);
@@ -6421,7 +6421,7 @@ int tep_print_num_field(struct trace_seq *s, const ch=
ar *fmt,
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
-			 struct tep_event_format *event, const char *name,
+			 struct tep_event *event, const char *name,
 			 struct tep_record *record, int err)
 {
 	struct tep_format_field *field =3D tep_find_field(event, name);
@@ -6581,11 +6581,11 @@ int tep_unregister_print_function(struct tep_handle=
 *pevent,
 	return -1;
 }
=20
-static struct tep_event_format *search_event(struct tep_handle *pevent, in=
t id,
+static struct tep_event *search_event(struct tep_handle *pevent, int id,
 					 const char *sys_name,
 					 const char *event_name)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	if (id >=3D 0) {
 		/* search by id */
@@ -6625,7 +6625,7 @@ int tep_register_event_handler(struct tep_handle *pev=
ent, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct event_handler *handle;
=20
 	event =3D search_event(pevent, id, sys_name, event_name);
@@ -6709,7 +6709,7 @@ int tep_unregister_event_handler(struct tep_handle *p=
event, int id,
 				 const char *sys_name, const char *event_name,
 				 tep_event_handler_func func, void *context)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct event_handler *handle;
 	struct event_handler **next;
=20
@@ -6794,7 +6794,7 @@ static void free_formats(struct tep_format *format)
 	free_format_fields(format->fields);
 }
=20
-void tep_free_format(struct tep_event_format *event)
+void tep_free_format(struct tep_event *event)
 {
 	free(event->name);
 	free(event->system);
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index ed87cb5..cb5ce66 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -27,7 +27,7 @@ static struct tep_format_field cpu =3D {
=20
 struct event_list {
 	struct event_list	*next;
-	struct tep_event_format	*event;
+	struct tep_event	*event;
 };
=20
 static void show_error(char *error_buf, const char *fmt, ...)
@@ -229,7 +229,7 @@ static void free_arg(struct tep_filter_arg *arg)
 }
=20
 static int add_event(struct event_list **events,
-		     struct tep_event_format *event)
+		     struct tep_event *event)
 {
 	struct event_list *list;
=20
@@ -243,7 +243,7 @@ static int add_event(struct event_list **events,
 	return 0;
 }
=20
-static int event_match(struct tep_event_format *event,
+static int event_match(struct tep_event *event,
 		       regex_t *sreg, regex_t *ereg)
 {
 	if (sreg) {
@@ -259,7 +259,7 @@ static enum tep_errno
 find_event(struct tep_handle *pevent, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	regex_t ereg;
 	regex_t sreg;
 	int match =3D 0;
@@ -334,7 +334,7 @@ static void free_events(struct event_list *events)
 }
=20
 static enum tep_errno
-create_arg_item(struct tep_event_format *event, const char *token,
+create_arg_item(struct tep_event *event, const char *token,
 		enum tep_event_type type, struct tep_filter_arg **parg, char *error_str)
 {
 	struct tep_format_field *field;
@@ -940,7 +940,7 @@ static int collapse_tree(struct tep_filter_arg *arg,
 }
=20
 static enum tep_errno
-process_filter(struct tep_event_format *event, struct tep_filter_arg **par=
g,
+process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 	       char *error_str, int not)
 {
 	enum tep_event_type type;
@@ -1180,7 +1180,7 @@ process_filter(struct tep_event_format *event, struct=
 tep_filter_arg **parg,
 }
=20
 static enum tep_errno
-process_event(struct tep_event_format *event, const char *filter_str,
+process_event(struct tep_event *event, const char *filter_str,
 	      struct tep_filter_arg **parg, char *error_str)
 {
 	int ret;
@@ -1205,7 +1205,7 @@ process_event(struct tep_event_format *event, const c=
har *filter_str,
 }
=20
 static enum tep_errno
-filter_event(struct tep_event_filter *filter, struct tep_event_format *eve=
nt,
+filter_event(struct tep_event_filter *filter, struct tep_event *event,
 	     const char *filter_str, char *error_str)
 {
 	struct tep_filter_type *filter_type;
@@ -1457,7 +1457,7 @@ static int copy_filter_type(struct tep_event_filter *=
filter,
 			    struct tep_filter_type *filter_type)
 {
 	struct tep_filter_arg *arg;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	const char *sys;
 	const char *name;
 	char *str;
@@ -1539,7 +1539,7 @@ int tep_update_trivial(struct tep_event_filter *dest,=
 struct tep_event_filter *s
 {
 	struct tep_handle *src_pevent;
 	struct tep_handle *dest_pevent;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_filter_type *filter_type;
 	struct tep_filter_arg *arg;
 	char *str;
@@ -1683,11 +1683,11 @@ int tep_filter_event_has_trivial(struct tep_event_f=
ilter *filter,
 	}
 }
=20
-static int test_filter(struct tep_event_format *event, struct tep_filter_a=
rg *arg,
+static int test_filter(struct tep_event *event, struct tep_filter_arg *arg=
,
 		       struct tep_record *record, enum tep_errno *err);
=20
 static const char *
-get_comm(struct tep_event_format *event, struct tep_record *record)
+get_comm(struct tep_event *event, struct tep_record *record)
 {
 	const char *comm;
 	int pid;
@@ -1698,7 +1698,7 @@ get_comm(struct tep_event_format *event, struct tep_r=
ecord *record)
 }
=20
 static unsigned long long
-get_value(struct tep_event_format *event,
+get_value(struct tep_event *event,
 	  struct tep_format_field *field, struct tep_record *record)
 {
 	unsigned long long val;
@@ -1734,11 +1734,11 @@ get_value(struct tep_event_format *event,
 }
=20
 static unsigned long long
-get_arg_value(struct tep_event_format *event, struct tep_filter_arg *arg,
+get_arg_value(struct tep_event *event, struct tep_filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err);
=20
 static unsigned long long
-get_exp_value(struct tep_event_format *event, struct tep_filter_arg *arg,
+get_exp_value(struct tep_event *event, struct tep_filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
@@ -1793,7 +1793,7 @@ get_exp_value(struct tep_event_format *event, struct =
tep_filter_arg *arg,
 }
=20
 static unsigned long long
-get_arg_value(struct tep_event_format *event, struct tep_filter_arg *arg,
+get_arg_value(struct tep_event *event, struct tep_filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->type) {
@@ -1817,7 +1817,7 @@ get_arg_value(struct tep_event_format *event, struct =
tep_filter_arg *arg,
 	return 0;
 }
=20
-static int test_num(struct tep_event_format *event, struct tep_filter_arg =
*arg,
+static int test_num(struct tep_event *event, struct tep_filter_arg *arg,
 		    struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
@@ -1860,7 +1860,7 @@ static int test_num(struct tep_event_format *event, s=
truct tep_filter_arg *arg,
=20
 static const char *get_field_str(struct tep_filter_arg *arg, struct tep_re=
cord *record)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_handle *pevent;
 	unsigned long long addr;
 	const char *val =3D NULL;
@@ -1908,7 +1908,7 @@ static const char *get_field_str(struct tep_filter_ar=
g *arg, struct tep_record *
 	return val;
 }
=20
-static int test_str(struct tep_event_format *event, struct tep_filter_arg =
*arg,
+static int test_str(struct tep_event *event, struct tep_filter_arg *arg,
 		    struct tep_record *record, enum tep_errno *err)
 {
 	const char *val;
@@ -1939,7 +1939,7 @@ static int test_str(struct tep_event_format *event, s=
truct tep_filter_arg *arg,
 	}
 }
=20
-static int test_op(struct tep_event_format *event, struct tep_filter_arg *=
arg,
+static int test_op(struct tep_event *event, struct tep_filter_arg *arg,
 		   struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->op.type) {
@@ -1961,7 +1961,7 @@ static int test_op(struct tep_event_format *event, st=
ruct tep_filter_arg *arg,
 	}
 }
=20
-static int test_filter(struct tep_event_format *event, struct tep_filter_a=
rg *arg,
+static int test_filter(struct tep_event *event, struct tep_filter_arg *arg=
,
 		       struct tep_record *record, enum tep_errno *err)
 {
 	if (*err) {
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index 60e5ff6..c75e4fc 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -17,7 +17,7 @@
=20
 struct blk_data {
 	unsigned long long	sector;
-	struct tep_event_format	*event;
+	struct tep_event	*event;
 	unsigned int		action;
 	unsigned int		pid;
 	unsigned int		device;
@@ -279,7 +279,7 @@ static const struct {
 };
=20
 static int blktrace_handler(struct trace_seq *s, struct tep_record *record=
,
-			    struct tep_event_format *event, void *context)
+			    struct tep_event *event, void *context)
 {
 	struct tep_format_field *field;
 	unsigned long long val;
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 5bd394f..434a33a 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -129,7 +129,7 @@ static void show_function(struct trace_seq *s, struct t=
ep_handle *pevent,
 }
=20
 static int function_handler(struct trace_seq *s, struct tep_record *record=
,
-			    struct tep_event_format *event, void *context)
+			    struct tep_event *event, void *context)
 {
 	struct tep_handle *pevent =3D event->pevent;
 	unsigned long long function;
diff --git a/plugins/plugin_futex.c b/plugins/plugin_futex.c
index d44c1d9..1e235c2 100644
--- a/plugins/plugin_futex.c
+++ b/plugins/plugin_futex.c
@@ -65,7 +65,7 @@ static void futex_print(struct trace_seq *s, const struct=
 futex_args *args,
 }
=20
 static int futex_handler(struct trace_seq *s, struct tep_record *record,
-			 struct tep_event_format *event, void *context)
+			 struct tep_event *event, void *context)
 {
 	const struct futex_op *fop;
 	struct futex_args args;
diff --git a/plugins/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
index 8524257..67846dc 100644
--- a/plugins/plugin_hrtimer.c
+++ b/plugins/plugin_hrtimer.c
@@ -11,7 +11,7 @@
 #include "trace-seq.h"
=20
 static int timer_expire_handler(struct trace_seq *s, struct tep_record *re=
cord,
-				struct tep_event_format *event, void *context)
+				struct tep_event *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=3D");
=20
@@ -28,7 +28,7 @@ static int timer_expire_handler(struct trace_seq *s, stru=
ct tep_record *record,
 }
=20
 static int timer_start_handler(struct trace_seq *s, struct tep_record *rec=
ord,
-			       struct tep_event_format *event, void *context)
+			       struct tep_event *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=3D");
=20
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index 8703c32..87c3463 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -10,7 +10,7 @@
 #include "trace-seq.h"
=20
 static int call_site_handler(struct trace_seq *s, struct tep_record *recor=
d,
-			     struct tep_event_format *event, void *context)
+			     struct tep_event *event, void *context)
 {
 	struct tep_format_field *field;
 	unsigned long long val, addr;
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index db3117b..8c7a54b 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -250,7 +250,7 @@ static const char *find_exit_reason(unsigned isa, int v=
al)
 }
=20
 static int print_exit_reason(struct trace_seq *s, struct tep_record *recor=
d,
-			     struct tep_event_format *event, const char *field)
+			     struct tep_event *event, const char *field)
 {
 	unsigned long long isa;
 	unsigned long long val;
@@ -271,7 +271,7 @@ static int print_exit_reason(struct trace_seq *s, struc=
t tep_record *record,
 }
=20
 static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record=
,
-			    struct tep_event_format *event, void *context)
+			    struct tep_event *event, void *context)
 {
 	unsigned long long info1 =3D 0, info2 =3D 0;
=20
@@ -293,7 +293,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct=
 tep_record *record,
 #define KVM_EMUL_INSN_F_CS_L   (1 << 3)
=20
 static int kvm_emulate_insn_handler(struct trace_seq *s, struct tep_record=
 *record,
-				    struct tep_event_format *event, void *context)
+				    struct tep_event *event, void *context)
 {
 	unsigned long long rip, csbase, len, flags, failed;
 	int llen;
@@ -333,7 +333,7 @@ static int kvm_emulate_insn_handler(struct trace_seq *s=
, struct tep_record *reco
=20
=20
 static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct te=
p_record *record,
-					    struct tep_event_format *event, void *context)
+					    struct tep_event *event, void *context)
 {
 	if (print_exit_reason(s, record, event, "exit_code") < 0)
 		return -1;
@@ -347,7 +347,7 @@ static int kvm_nested_vmexit_inject_handler(struct trac=
e_seq *s, struct tep_reco
 }
=20
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_recor=
d *record,
-				     struct tep_event_format *event, void *context)
+				     struct tep_event *event, void *context)
 {
 	tep_print_num_field(s, "rip %lx ", event, "rip", record, 1);
=20
@@ -370,7 +370,7 @@ union kvm_mmu_page_role {
 };
=20
 static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *reco=
rd,
-			      struct tep_event_format *event, void *context)
+			      struct tep_event *event, void *context)
 {
 	unsigned long long val;
 	static const char *access_str[] =3D
@@ -412,7 +412,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, stru=
ct tep_record *record,
 	return 0;
 }
 static int kvm_mmu_get_page_handler(struct trace_seq *s, struct tep_record=
 *record,
-				    struct tep_event_format *event, void *context)
+				    struct tep_event *event, void *context)
 {
 	unsigned long long val;
=20
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index 8bad2f0..274566e 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -11,7 +11,7 @@
=20
 #define INDENT 65
=20
-static void print_string(struct trace_seq *s, struct tep_event_format *eve=
nt,
+static void print_string(struct trace_seq *s, struct tep_event *event,
 			 const char *name, const void *data)
 {
 	struct tep_format_field *f =3D tep_find_field(event, name);
@@ -44,7 +44,7 @@ struct value_name {
 	const char *name;
 };
=20
-static void _print_enum(struct trace_seq *s, struct tep_event_format *even=
t,
+static void _print_enum(struct trace_seq *s, struct tep_event *event,
 			const char *name, const void *data,
 			const struct value_name *names, int n_names)
 {
@@ -77,7 +77,7 @@ static void _print_enum(struct trace_seq *s, struct tep_e=
vent_format *event,
 	_print_enum(s, ev, name, data, __n, sizeof(__n)/sizeof(__n[0]));	\
 	})
=20
-static void _print_flag(struct trace_seq *s, struct tep_event_format *even=
t,
+static void _print_flag(struct trace_seq *s, struct tep_event *event,
 			const char *name, const void *data,
 			const struct value_name *names, int n_names)
 {
@@ -125,7 +125,7 @@ static void _print_flag(struct trace_seq *s, struct tep=
_event_format *event,
 #define SP()	trace_seq_putc(s, ' ')
=20
 static int drv_bss_info_changed(struct trace_seq *s, struct tep_record *re=
cord,
-				struct tep_event_format *event, void *context)
+				struct tep_event *event, void *context)
 {
 	void *data =3D record->data;
=20
@@ -153,7 +153,7 @@ static int drv_bss_info_changed(struct trace_seq *s, st=
ruct tep_record *record,
 }
=20
 static int drv_config(struct trace_seq *s, struct tep_record *record,
-		      struct tep_event_format *event, void *context)
+		      struct tep_event *event, void *context)
 {
 	void *data =3D record->data;
=20
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 485c0b3..3f85bd5 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -51,7 +51,7 @@ static void write_and_save_comm(struct tep_format_field *=
field,
 }
=20
 static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *re=
cord,
-				struct tep_event_format *event, void *context)
+				struct tep_event *event, void *context)
 {
 	struct tep_format_field *field;
 	unsigned long long val;
@@ -79,7 +79,7 @@ static int sched_wakeup_handler(struct trace_seq *s, stru=
ct tep_record *record,
 }
=20
 static int sched_switch_handler(struct trace_seq *s, struct tep_record *re=
cord,
-				struct tep_event_format *event, void *context)
+				struct tep_event *event, void *context)
 {
 	struct tep_format_field *field;
 	unsigned long long val;
diff --git a/plugins/plugin_tlb.c b/plugins/plugin_tlb.c
index afe0f7a..fbcacac 100644
--- a/plugins/plugin_tlb.c
+++ b/plugins/plugin_tlb.c
@@ -17,7 +17,7 @@ enum tlb_flush_reason {
 };
=20
 static int tlb_flush_handler(struct trace_seq *s, struct tep_record *recor=
d,
-			     struct tep_event_format *event, void *context)
+			     struct tep_event *event, void *context)
 {
 	unsigned long long val;
=20
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index fae521e..b18cba9 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -32,7 +32,7 @@
 %inline %{
 static int python_callback(struct trace_seq *s,
 			   struct tep_record *record,
-			   struct tep_event_format *event,
+			   struct tep_event *event,
 			   void *context);
=20
 static int skip_output =3D 0;
@@ -82,7 +82,7 @@ void py_pevent_register_event_handler(struct tep_handle *=
pevent, int id,
=20
 static PyObject *py_field_get_stack(struct tep_handle *pevent,
 				    struct tep_record *record,
-				    struct tep_event_format *event,
+				    struct tep_event *event,
 				    int long_size)
 {
 	PyObject *list;
@@ -169,7 +169,7 @@ static PyObject *py_field_get_str(struct tep_format_fie=
ld *f, struct tep_record
 				strnlen((char *)r->data + f->offset, f->size));
 }
=20
-static PyObject *py_format_get_keys(struct tep_event_format *ef)
+static PyObject *py_format_get_keys(struct tep_event *ef)
 {
 	PyObject *list;
 	struct tep_format_field *f;
@@ -191,7 +191,7 @@ static PyObject *py_format_get_keys(struct tep_event_fo=
rmat *ef)
 %wrapper %{
 static int python_callback(struct trace_seq *s,
 			   struct tep_record *record,
-			   struct tep_event_format *event,
+			   struct tep_event *event,
 			   void *context)
 {
 	PyObject *arglist, *result;
@@ -205,7 +205,7 @@ static int python_callback(struct trace_seq *s,
 		SWIG_NewPointerObj(SWIG_as_voidptr(record),
 				   SWIGTYPE_p_tep_record, 0),
 		SWIG_NewPointerObj(SWIG_as_voidptr(event),
-				   SWIGTYPE_p_tep_event_format, 0));
+				   SWIGTYPE_p_tep_event, 0));
=20
 	result =3D PyEval_CallObject(context, arglist);
 	Py_XDECREF(arglist);
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 6378fc0..8afee14 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -530,7 +530,7 @@ process_sched_switch(struct tep_handle *pevent, struct =
tep_record *record)
 static void
 process_event(struct tep_handle *pevent, struct tep_record *record, int ty=
pe)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	const char *event_name;
 	unsigned long long val;
 	int pid;
@@ -592,11 +592,11 @@ process_record(struct tep_handle *pevent, struct tep_=
record *record)
 	process_event(pevent, record, type);
 }
=20
-static struct tep_event_format *
+static struct tep_event *
 update_event(struct tep_handle *pevent,
 	     const char *sys, const char *name, int *id)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D tep_find_event_by_name(pevent, sys, name);
 	if (!event)
@@ -609,7 +609,7 @@ update_event(struct tep_handle *pevent,
=20
 static void update_sched_wakeup(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "sched", "sched_wakeup", &sched_wakeup_typ=
e);
 	if (!event)
@@ -621,7 +621,7 @@ static void update_sched_wakeup(struct tep_handle *peve=
nt)
=20
 static void update_sched_wakeup_new(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "sched", "sched_wakeup_new", &sched_wakeup=
_new_type);
 	if (!event)
@@ -633,7 +633,7 @@ static void update_sched_wakeup_new(struct tep_handle *=
pevent)
=20
 static void update_sched_switch(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "sched", "sched_switch", &sched_switch_typ=
e);
 	if (!event)
@@ -647,7 +647,7 @@ static void update_sched_switch(struct tep_handle *peve=
nt)
=20
 static void update_function(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "ftrace", "function", &function_type);
 	if (!event)
@@ -659,7 +659,7 @@ static void update_function(struct tep_handle *pevent)
=20
 static void update_function_graph_entry(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "ftrace", "funcgraph_entry", &function_gra=
ph_entry_type);
 	if (!event)
@@ -671,7 +671,7 @@ static void update_function_graph_entry(struct tep_hand=
le *pevent)
=20
 static void update_function_graph_exit(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "ftrace", "funcgraph_exit", &function_grap=
h_exit_type);
 	if (!event)
@@ -686,7 +686,7 @@ static void update_function_graph_exit(struct tep_handl=
e *pevent)
=20
 static void update_kernel_stack(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "ftrace", "kernel_stack", &kernel_stack_ty=
pe);
 	if (!event)
@@ -934,7 +934,7 @@ static void print_chains(struct tep_handle *pevent)
 static void do_trace_hist(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent =3D tracecmd_get_pevent(handle);
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_record *record;
 	int cpus;
 	int cpu;
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 8c0286b..7b4c3df 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -61,11 +61,11 @@ static void *zalloc(size_t size)
 	return calloc(1, size);
 }
=20
-static struct tep_event_format *
+static struct tep_event *
 update_event(struct tep_handle *pevent,
 	     const char *sys, const char *name, int *id)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D tep_find_event_by_name(pevent, sys, name);
 	if (!event)
@@ -78,7 +78,7 @@ update_event(struct tep_handle *pevent,
=20
 static void update_kmalloc(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "kmem", "kmalloc", &kmalloc_type);
 	if (!event)
@@ -92,7 +92,7 @@ static void update_kmalloc(struct tep_handle *pevent)
=20
 static void update_kmalloc_node(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "kmem", "kmalloc_node", &kmalloc_node_type=
);
 	if (!event)
@@ -106,7 +106,7 @@ static void update_kmalloc_node(struct tep_handle *peve=
nt)
=20
 static void update_kfree(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "kmem", "kfree", &kfree_type);
 	if (!event)
@@ -117,7 +117,7 @@ static void update_kfree(struct tep_handle *pevent)
=20
 static void update_kmem_cache_alloc(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "kmem", "kmem_cache_alloc", &kmem_cache_al=
loc_type);
 	if (!event)
@@ -131,7 +131,7 @@ static void update_kmem_cache_alloc(struct tep_handle *=
pevent)
=20
 static void update_kmem_cache_alloc_node(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "kmem", "kmem_cache_alloc_node",
 			     &kmem_cache_alloc_node_type);
@@ -146,7 +146,7 @@ static void update_kmem_cache_alloc_node(struct tep_han=
dle *pevent)
=20
 static void update_kmem_cache_free(struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D update_event(pevent, "kmem", "kmem_cache_free", &kmem_cache_fre=
e_type);
 	if (!event)
@@ -462,7 +462,7 @@ static void print_list(void)
 static void do_trace_mem(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent =3D tracecmd_get_pevent(handle);
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_record *record;
 	int missed_events =3D 0;
 	int cpus;
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 06c66eb..d781d05 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -71,7 +71,7 @@ struct event_data {
 	struct trace_hash_item	hash;
 	int			id;
 	int			trace;
-	struct tep_event_format	*event;
+	struct tep_event	*event;
=20
 	struct event_data	*end;
 	struct event_data	*start;
@@ -795,7 +795,7 @@ static struct event_data *
 add_event(struct handle_data *h, const char *system, const char *event_nam=
e,
 	  enum event_data_type type)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct event_data *event_data;
=20
 	event =3D tep_find_event_by_name(h->pevent, system, event_name);
@@ -870,9 +870,9 @@ mate_events(struct handle_data *h, struct event_data *s=
tart,
  * @global: The events are global and not per task
  */
 void tracecmd_mate_events(struct tracecmd_input *handle,
-			  struct tep_event_format *start_event,
+			  struct tep_event *start_event,
 			  const char *pid_field, const char *end_match_field,
-			  struct tep_event_format *end_event,
+			  struct tep_event *end_event,
 			  const char *start_match_field,
 			  int migrate, int global)
 {
@@ -1268,7 +1268,7 @@ void trace_init_profile(struct tracecmd_input *handle=
, struct hook_list *hook,
 			int global)
 {
 	struct tep_handle *pevent =3D tracecmd_get_pevent(handle);
-	struct tep_event_format **events;
+	struct tep_event **events;
 	struct tep_format_field **fields;
 	struct handle_data *h;
 	struct event_data *event_data;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c406d66..971d5d3 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -529,7 +529,7 @@ static void process_filters(struct handle_list *handles=
)
=20
 static void init_wakeup(struct tracecmd_input *handle)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_handle *pevent;
=20
 	if (!show_wakeup)
@@ -789,7 +789,7 @@ void trace_show_data(struct tracecmd_input *handle, str=
uct tep_record *record)
 	}
 	use_trace_clock =3D tracecmd_get_use_trace_clock(handle);
 	if (tsdiff) {
-		struct tep_event_format *event;
+		struct tep_event *event;
 		unsigned long long rec_ts =3D record->ts;
=20
 		event =3D tep_find_event_by_record(pevent, record);
@@ -927,7 +927,7 @@ test_stacktrace(struct handle_list *handles, struct tep=
_record *record,
 	struct stack_info_cpu *cpu_info;
 	struct handle_list *h;
 	struct tracecmd_input *handle;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_handle *pevent;
 	static int init;
 	int ret;
@@ -1116,7 +1116,7 @@ static void read_data_info(struct list_head *handle_l=
ist, enum output_type otype
 	struct handle_list *last_handle;
 	struct tep_record *record;
 	struct tep_record *last_record;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_handle *pevent;
 	int cpus;
 	int ret;
@@ -1335,8 +1335,8 @@ static void process_plugin_option(char *option)
 static void set_event_flags(struct tep_handle *pevent, struct event_str *l=
ist,
 			    unsigned int flag)
 {
-	struct tep_event_format **events;
-	struct tep_event_format *event;
+	struct tep_event **events;
+	struct tep_event *event;
 	struct event_str *str;
 	regex_t regex;
 	int ret;
@@ -1735,8 +1735,8 @@ void trace_report (int argc, char **argv)
 		}
=20
 		if (show_events) {
-			struct tep_event_format **events;
-			struct tep_event_format *event;
+			struct tep_event **events;
+			struct tep_event *event;
 			int i;
=20
 			events =3D tep_list_events(pevent, TEP_EVENT_SORT_SYSTEM);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 038b231..7666a24 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3347,7 +3347,7 @@ static void add_func(struct func_list **list, const c=
har *mod, const char *func)
 static unsigned long long
 find_ts_in_page(struct tep_handle *pevent, void *page, int size)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_format_field *field;
 	struct tep_record *last_record =3D NULL;
 	struct tep_record *record;
--=20
2.19.2
