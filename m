Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387736AbeITAgl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 20:36:41 -0400
Message-Id: <20180919185725.076387655@goodmis.org>
Date: Wed, 19 Sep 2018 14:56:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 15/15] tools/lib/traceevent: Add prefix tep_ to enum filter_trivial_type
References: <20180919185643.358126338@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to
enum filter_trivial_type and all its members.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h  | 14 +++++++-------
 tools/lib/traceevent/parse-filter.c | 22 +++++++++++-----------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 830147dc6b21..9c29a5f7aa39 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -905,10 +905,10 @@ struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent);
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
@@ -926,7 +926,7 @@ int tep_event_filtered(struct tep_event_filter *filter,
 void tep_filter_reset(struct tep_event_filter *filter);
 
 int tep_filter_clear_trivial(struct tep_event_filter *filter,
-			     enum filter_trivial_type type);
+			     enum tep_filter_trivial_type type);
 
 void tep_filter_free(struct tep_event_filter *filter);
 
@@ -937,12 +937,12 @@ int tep_filter_remove_event(struct tep_event_filter *filter,
 
 int tep_filter_event_has_trivial(struct tep_event_filter *filter,
 				 int event_id,
-				 enum filter_trivial_type type);
+				 enum tep_filter_trivial_type type);
 
 int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *source);
 
 int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
-			enum filter_trivial_type type);
+			enum tep_filter_trivial_type type);
 
 int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter *filter2);
 
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 875bfaf79771..d64b6128fa7d 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
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
2.18.0
