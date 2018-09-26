Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730058.outbound.protection.outlook.com ([40.107.73.58]:63673
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbeIZScT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:32:19 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 16/16] tools lib traceevent: Add prefix tep_ to enum filter_trivial_type
Date: Wed, 26 Sep 2018 15:18:32 +0300
Message-Id: <20180926121832.16101-17-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to
enum filter_trivial_type and all its members.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185725.076387655@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 14 +++++++-------
 kernel-shark/trace-filter.c      |  8 ++++----
 kernel-shark/trace-graph.c       |  6 +++---
 kernel-shark/trace-view-store.c  |  2 +-
 lib/traceevent/parse-filter.c    | 22 +++++++++++-----------
 5 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index edb468d..5567d72 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -893,10 +893,10 @@ struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent);
 #define FILTER_MISS		TEP_ERRNO__FILTER_MISS
 #define FILTER_MATCH		TEP_ERRNO__FILTER_MATCH
 
-enum filter_trivial_type {
-	FILTER_TRIVIAL_FALSE,
-	FILTER_TRIVIAL_TRUE,
-	FILTER_TRIVIAL_BOTH,
+enum tep_filter_trivial_type {
+	TEP_FILTER_TRIVIAL_FALSE,
+	TEP_FILTER_TRIVIAL_TRUE,
+	TEP_FILTER_TRIVIAL_BOTH,
 };
 
 enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
@@ -914,7 +914,7 @@ int tep_event_filtered(struct tep_event_filter *filter,
 void tep_filter_reset(struct tep_event_filter *filter);
 
 int tep_filter_clear_trivial(struct tep_event_filter *filter,
-			     enum filter_trivial_type type);
+			     enum tep_filter_trivial_type type);
 
 void tep_filter_free(struct tep_event_filter *filter);
 
@@ -925,12 +925,12 @@ int tep_filter_remove_event(struct tep_event_filter *filter,
 
 int tep_filter_event_has_trivial(struct tep_event_filter *filter,
 				 int event_id,
-				 enum filter_trivial_type type);
+				 enum tep_filter_trivial_type type);
 
 int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *source);
 
 int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
-			enum filter_trivial_type type);
+			enum tep_filter_trivial_type type);
 
 int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter *filter2);
 
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index 6144d0c..90d1f39 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -1127,11 +1127,11 @@ create_tree_event_model(struct tep_handle *pevent,
 		if (active && filter) {
 			if (tep_event_filtered(filter, event->id) &&
 			    !tep_filter_event_has_trivial(filter, event->id,
-							     FILTER_TRIVIAL_BOTH))
+							  TEP_FILTER_TRIVIAL_BOTH))
 				normal = FALSE;
 			/* Make trivial false not selected */
 			else if (tep_filter_event_has_trivial(filter, event->id,
-								 FILTER_TRIVIAL_FALSE))
+							      TEP_FILTER_TRIVIAL_FALSE))
 				active = FALSE;
 		}
 		gtk_tree_store_append(treestore, &iter_events, &iter_sys);
@@ -1951,7 +1951,7 @@ void trace_filter_convert_filter_to_names(struct tep_event_filter *filter,
 		}
 
 		if (tep_filter_event_has_trivial(filter, event->id,
-						    FILTER_TRIVIAL_TRUE)) {
+						 TEP_FILTER_TRIVIAL_TRUE)) {
 			if (!all_selected || !systems)
 				*event_ids = tracecmd_add_id(*event_ids, event->id, event_count++);
 		} else {
@@ -2011,7 +2011,7 @@ void trace_filter_convert_char_to_filter(struct tep_event_filter *filter,
 		}
 	}
 
-	tep_update_trivial(filter, copy, FILTER_TRIVIAL_BOTH);
+	tep_update_trivial(filter, copy, TEP_FILTER_TRIVIAL_BOTH);
 
 	tep_filter_free(copy);
 }
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index c3b99e4..fe28019 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -2242,7 +2242,7 @@ void trace_graph_event_filter_callback(gboolean accept,
 
 	ginfo->all_events = FALSE;
 
-	tep_filter_clear_trivial(ginfo->event_filter, FILTER_TRIVIAL_BOTH);
+	tep_filter_clear_trivial(ginfo->event_filter, TEP_FILTER_TRIVIAL_BOTH);
 
 	trace_filter_convert_char_to_filter(ginfo->event_filter,
 					    systems, events);
@@ -2279,7 +2279,7 @@ void trace_graph_adv_filter_callback(gboolean accept,
 		ginfo->all_events = FALSE;
 
 		tep_filter_clear_trivial(event_filter,
-					    FILTER_TRIVIAL_BOTH);
+					 TEP_FILTER_TRIVIAL_BOTH);
 
 		ret = tep_filter_add_filter_str(event_filter, text);
 		if (ret < 0) {
@@ -2645,7 +2645,7 @@ static int load_event_filter(struct graph_info *ginfo,
 	if (!node)
 		return -1;
 
-	tep_filter_clear_trivial(event_filter, FILTER_TRIVIAL_BOTH);
+	tep_filter_clear_trivial(event_filter, TEP_FILTER_TRIVIAL_BOTH);
 	ginfo->all_events = FALSE;
 
 	trace_filter_load_events(event_filter, handle, node);
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index 9fd2d5e..53fab98 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -512,7 +512,7 @@ void trace_view_store_clear_all_events_enabled(TraceViewStore *store)
 {
 	g_return_if_fail (TRACE_VIEW_IS_LIST (store));
 
-	tep_filter_clear_trivial(store->event_filter, FILTER_TRIVIAL_BOTH);
+	tep_filter_clear_trivial(store->event_filter, TEP_FILTER_TRIVIAL_BOTH);
 	store->all_events = 0;
 }
 
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 875bfaf..d64b612 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1534,7 +1534,7 @@ int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *sour
  *   events may have still been updated on error.
  */
 int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
-		       enum filter_trivial_type type)
+		       enum tep_filter_trivial_type type)
 {
 	struct tep_handle *src_pevent;
 	struct tep_handle *dest_pevent;
@@ -1556,8 +1556,8 @@ int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *s
 		arg = filter_type->filter;
 		if (arg->type != TEP_FILTER_ARG_BOOLEAN)
 			continue;
-		if ((arg->boolean.value && type == FILTER_TRIVIAL_FALSE) ||
-		    (!arg->boolean.value && type == FILTER_TRIVIAL_TRUE))
+		if ((arg->boolean.value && type == TEP_FILTER_TRIVIAL_FALSE) ||
+		    (!arg->boolean.value && type == TEP_FILTER_TRIVIAL_TRUE))
 			continue;
 
 		event = filter_type->event;
@@ -1593,7 +1593,7 @@ int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *s
  * Returns 0 on success and -1 if there was a problem.
  */
 int tep_filter_clear_trivial(struct tep_event_filter *filter,
-			     enum filter_trivial_type type)
+			     enum tep_filter_trivial_type type)
 {
 	struct tep_filter_type *filter_type;
 	int count = 0;
@@ -1614,11 +1614,11 @@ int tep_filter_clear_trivial(struct tep_event_filter *filter,
 		if (filter_type->filter->type != TEP_FILTER_ARG_BOOLEAN)
 			continue;
 		switch (type) {
-		case FILTER_TRIVIAL_FALSE:
+		case TEP_FILTER_TRIVIAL_FALSE:
 			if (filter_type->filter->boolean.value)
 				continue;
 			break;
-		case FILTER_TRIVIAL_TRUE:
+		case TEP_FILTER_TRIVIAL_TRUE:
 			if (!filter_type->filter->boolean.value)
 				continue;
 		default:
@@ -1656,7 +1656,7 @@ int tep_filter_clear_trivial(struct tep_event_filter *filter,
  */
 int tep_filter_event_has_trivial(struct tep_event_filter *filter,
 				 int event_id,
-				 enum filter_trivial_type type)
+				 enum tep_filter_trivial_type type)
 {
 	struct tep_filter_type *filter_type;
 
@@ -1672,10 +1672,10 @@ int tep_filter_event_has_trivial(struct tep_event_filter *filter,
 		return 0;
 
 	switch (type) {
-	case FILTER_TRIVIAL_FALSE:
+	case TEP_FILTER_TRIVIAL_FALSE:
 		return !filter_type->filter->boolean.value;
 
-	case FILTER_TRIVIAL_TRUE:
+	case TEP_FILTER_TRIVIAL_TRUE:
 		return filter_type->filter->boolean.value;
 	default:
 		return 1;
@@ -2409,8 +2409,8 @@ int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter
 		if (filter_type1->filter->type != filter_type2->filter->type)
 			break;
 		switch (filter_type1->filter->type) {
-		case FILTER_TRIVIAL_FALSE:
-		case FILTER_TRIVIAL_TRUE:
+		case TEP_FILTER_TRIVIAL_FALSE:
+		case TEP_FILTER_TRIVIAL_TRUE:
 			/* trivial types just need the type compared */
 			continue;
 		default:
-- 
2.17.1
