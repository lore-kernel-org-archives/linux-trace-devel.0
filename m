Return-Path: <SRS0=/bgX=MG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731837AbeIXVHV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Sep 2018 17:07:21 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/27] tools lib traceevent: Add prefix tep_ to structs filter_type and event_filter
Date: Mon, 24 Sep 2018 12:02:32 -0300
Message-Id: <20180924150242.14235-18-acme@kernel.org>
In-Reply-To: <20180924150242.14235-1-acme@kernel.org>
References: <20180924150242.14235-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to
structs filter_type and event_filter

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185724.309837130@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.h  | 34 ++++++-------
 tools/lib/traceevent/parse-filter.c | 96 ++++++++++++++++++-------------------
 2 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 1330fca2da1e..1abf15882460 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -882,7 +882,7 @@ struct tep_filter_arg {
 	};
 };
 
-struct filter_type {
+struct tep_filter_type {
 	int			event_id;
 	struct tep_event_format	*event;
 	struct tep_filter_arg	*filter;
@@ -890,14 +890,14 @@ struct filter_type {
 
 #define TEP_FILTER_ERROR_BUFSZ  1024
 
-struct event_filter {
+struct tep_event_filter {
 	struct tep_handle	*pevent;
 	int			filters;
-	struct filter_type	*event_filters;
+	struct tep_filter_type	*event_filters;
 	char			error_buffer[TEP_FILTER_ERROR_BUFSZ];
 };
 
-struct event_filter *tep_filter_alloc(struct tep_handle *pevent);
+struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent);
 
 /* for backward compatibility */
 #define FILTER_NONE		TEP_ERRNO__NO_FILTER
@@ -911,39 +911,39 @@ enum filter_trivial_type {
 	FILTER_TRIVIAL_BOTH,
 };
 
-enum tep_errno tep_filter_add_filter_str(struct event_filter *filter,
+enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 					 const char *filter_str);
 
-enum tep_errno tep_filter_match(struct event_filter *filter,
+enum tep_errno tep_filter_match(struct tep_event_filter *filter,
 				struct tep_record *record);
 
-int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
+int tep_filter_strerror(struct tep_event_filter *filter, enum tep_errno err,
 			char *buf, size_t buflen);
 
-int tep_event_filtered(struct event_filter *filter,
+int tep_event_filtered(struct tep_event_filter *filter,
 		       int event_id);
 
-void tep_filter_reset(struct event_filter *filter);
+void tep_filter_reset(struct tep_event_filter *filter);
 
-int tep_filter_clear_trivial(struct event_filter *filter,
+int tep_filter_clear_trivial(struct tep_event_filter *filter,
 			     enum filter_trivial_type type);
 
-void tep_filter_free(struct event_filter *filter);
+void tep_filter_free(struct tep_event_filter *filter);
 
-char *tep_filter_make_string(struct event_filter *filter, int event_id);
+char *tep_filter_make_string(struct tep_event_filter *filter, int event_id);
 
-int tep_filter_remove_event(struct event_filter *filter,
+int tep_filter_remove_event(struct tep_event_filter *filter,
 			    int event_id);
 
-int tep_filter_event_has_trivial(struct event_filter *filter,
+int tep_filter_event_has_trivial(struct tep_event_filter *filter,
 				 int event_id,
 				 enum filter_trivial_type type);
 
-int tep_filter_copy(struct event_filter *dest, struct event_filter *source);
+int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *source);
 
-int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
+int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
 			enum filter_trivial_type type);
 
-int tep_filter_compare(struct event_filter *filter1, struct event_filter *filter2);
+int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter *filter2);
 
 #endif /* _PARSE_EVENTS_H */
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index b9ca1b9e14e4..875bfaf79771 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -94,8 +94,8 @@ static enum tep_event_type read_token(char **tok)
 
 static int filter_cmp(const void *a, const void *b)
 {
-	const struct filter_type *ea = a;
-	const struct filter_type *eb = b;
+	const struct tep_filter_type *ea = a;
+	const struct tep_filter_type *eb = b;
 
 	if (ea->event_id < eb->event_id)
 		return -1;
@@ -106,11 +106,11 @@ static int filter_cmp(const void *a, const void *b)
 	return 0;
 }
 
-static struct filter_type *
-find_filter_type(struct event_filter *filter, int id)
+static struct tep_filter_type *
+find_filter_type(struct tep_event_filter *filter, int id)
 {
-	struct filter_type *filter_type;
-	struct filter_type key;
+	struct tep_filter_type *filter_type;
+	struct tep_filter_type key;
 
 	key.event_id = id;
 
@@ -122,10 +122,10 @@ find_filter_type(struct event_filter *filter, int id)
 	return filter_type;
 }
 
-static struct filter_type *
-add_filter_type(struct event_filter *filter, int id)
+static struct tep_filter_type *
+add_filter_type(struct tep_event_filter *filter, int id)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	int i;
 
 	filter_type = find_filter_type(filter, id);
@@ -165,9 +165,9 @@ add_filter_type(struct event_filter *filter, int id)
  * tep_filter_alloc - create a new event filter
  * @pevent: The pevent that this filter is associated with
  */
-struct event_filter *tep_filter_alloc(struct tep_handle *pevent)
+struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent)
 {
-	struct event_filter *filter;
+	struct tep_event_filter *filter;
 
 	filter = malloc(sizeof(*filter));
 	if (filter == NULL)
@@ -1204,10 +1204,10 @@ process_event(struct tep_event_format *event, const char *filter_str,
 }
 
 static enum tep_errno
-filter_event(struct event_filter *filter, struct tep_event_format *event,
+filter_event(struct tep_event_filter *filter, struct tep_event_format *event,
 	     const char *filter_str, char *error_str)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	struct tep_filter_arg *arg;
 	enum tep_errno ret;
 
@@ -1237,7 +1237,7 @@ filter_event(struct event_filter *filter, struct tep_event_format *event,
 	return 0;
 }
 
-static void filter_init_error_buf(struct event_filter *filter)
+static void filter_init_error_buf(struct tep_event_filter *filter)
 {
 	/* clear buffer to reset show error */
 	tep_buffer_init("", 0);
@@ -1253,7 +1253,7 @@ static void filter_init_error_buf(struct event_filter *filter)
  * negative error code.  Use tep_filter_strerror() to see
  * actual error message in case of error.
  */
-enum tep_errno tep_filter_add_filter_str(struct event_filter *filter,
+enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 					 const char *filter_str)
 {
 	struct tep_handle *pevent = filter->pevent;
@@ -1351,7 +1351,7 @@ enum tep_errno tep_filter_add_filter_str(struct event_filter *filter,
 	return rtn;
 }
 
-static void free_filter_type(struct filter_type *filter_type)
+static void free_filter_type(struct tep_filter_type *filter_type)
 {
 	free_arg(filter_type->filter);
 }
@@ -1365,7 +1365,7 @@ static void free_filter_type(struct filter_type *filter_type)
  *
  * Returns 0 if message was filled successfully, -1 if error
  */
-int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
+int tep_filter_strerror(struct tep_event_filter *filter, enum tep_errno err,
 			char *buf, size_t buflen)
 {
 	if (err <= __TEP_ERRNO__START || err >= __TEP_ERRNO__END)
@@ -1393,10 +1393,10 @@ int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
  * Returns 1: if an event was removed
  *   0: if the event was not found
  */
-int tep_filter_remove_event(struct event_filter *filter,
+int tep_filter_remove_event(struct tep_event_filter *filter,
 			    int event_id)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	unsigned long len;
 
 	if (!filter->filters)
@@ -1428,7 +1428,7 @@ int tep_filter_remove_event(struct event_filter *filter,
  *
  * Removes all filters from a filter and resets it.
  */
-void tep_filter_reset(struct event_filter *filter)
+void tep_filter_reset(struct tep_event_filter *filter)
 {
 	int i;
 
@@ -1440,7 +1440,7 @@ void tep_filter_reset(struct event_filter *filter)
 	filter->event_filters = NULL;
 }
 
-void tep_filter_free(struct event_filter *filter)
+void tep_filter_free(struct tep_event_filter *filter)
 {
 	tep_unref(filter->pevent);
 
@@ -1449,11 +1449,11 @@ void tep_filter_free(struct event_filter *filter)
 	free(filter);
 }
 
-static char *arg_to_str(struct event_filter *filter, struct tep_filter_arg *arg);
+static char *arg_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg);
 
-static int copy_filter_type(struct event_filter *filter,
-			     struct event_filter *source,
-			     struct filter_type *filter_type)
+static int copy_filter_type(struct tep_event_filter *filter,
+			    struct tep_event_filter *source,
+			    struct tep_filter_type *filter_type)
 {
 	struct tep_filter_arg *arg;
 	struct tep_event_format *event;
@@ -1507,7 +1507,7 @@ static int copy_filter_type(struct event_filter *filter,
  *
  * Returns 0 on success and -1 if not all filters were copied
  */
-int tep_filter_copy(struct event_filter *dest, struct event_filter *source)
+int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *source)
 {
 	int ret = 0;
 	int i;
@@ -1533,13 +1533,13 @@ int tep_filter_copy(struct event_filter *dest, struct event_filter *source)
  * Returns 0 on success and -1 if there was a problem updating, but
  *   events may have still been updated on error.
  */
-int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
+int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
 		       enum filter_trivial_type type)
 {
 	struct tep_handle *src_pevent;
 	struct tep_handle *dest_pevent;
 	struct tep_event_format *event;
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	struct tep_filter_arg *arg;
 	char *str;
 	int i;
@@ -1592,10 +1592,10 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
  *
  * Returns 0 on success and -1 if there was a problem.
  */
-int tep_filter_clear_trivial(struct event_filter *filter,
+int tep_filter_clear_trivial(struct tep_event_filter *filter,
 			     enum filter_trivial_type type)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	int count = 0;
 	int *ids = NULL;
 	int i;
@@ -1654,11 +1654,11 @@ int tep_filter_clear_trivial(struct event_filter *filter,
  * Returns 1 if the event contains a matching trivial type
  *  otherwise 0.
  */
-int tep_filter_event_has_trivial(struct event_filter *filter,
+int tep_filter_event_has_trivial(struct tep_event_filter *filter,
 				 int event_id,
 				 enum filter_trivial_type type)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 
 	if (!filter->filters)
 		return 0;
@@ -2008,9 +2008,9 @@ static int test_filter(struct tep_event_format *event, struct tep_filter_arg *ar
  * Returns 1 if filter found for @event_id
  *   otherwise 0;
  */
-int tep_event_filtered(struct event_filter *filter, int event_id)
+int tep_event_filtered(struct tep_event_filter *filter, int event_id)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 
 	if (!filter->filters)
 		return 0;
@@ -2032,11 +2032,11 @@ int tep_event_filtered(struct event_filter *filter, int event_id)
  * NO_FILTER - if no filters exist
  * otherwise - error occurred during test
  */
-enum tep_errno tep_filter_match(struct event_filter *filter,
+enum tep_errno tep_filter_match(struct tep_event_filter *filter,
 				struct tep_record *record)
 {
 	struct tep_handle *pevent = filter->pevent;
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	int event_id;
 	int ret;
 	enum tep_errno err = 0;
@@ -2059,7 +2059,7 @@ enum tep_errno tep_filter_match(struct event_filter *filter,
 	return ret ? TEP_ERRNO__FILTER_MATCH : TEP_ERRNO__FILTER_MISS;
 }
 
-static char *op_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *op_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 	char *left = NULL;
@@ -2163,7 +2163,7 @@ static char *op_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 	return str;
 }
 
-static char *val_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *val_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 
@@ -2172,12 +2172,12 @@ static char *val_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 	return str;
 }
 
-static char *field_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *field_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	return strdup(arg->field.field->name);
 }
 
-static char *exp_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *exp_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *lstr;
 	char *rstr;
@@ -2233,7 +2233,7 @@ static char *exp_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 	return str;
 }
 
-static char *num_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *num_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *lstr;
 	char *rstr;
@@ -2283,7 +2283,7 @@ static char *num_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 	return str;
 }
 
-static char *str_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *str_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 	char *op = NULL;
@@ -2315,7 +2315,7 @@ static char *str_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 	return str;
 }
 
-static char *arg_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *arg_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 
@@ -2359,9 +2359,9 @@ static char *arg_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
  *  NULL is returned if no filter is found or allocation failed.
  */
 char *
-tep_filter_make_string(struct event_filter *filter, int event_id)
+tep_filter_make_string(struct tep_event_filter *filter, int event_id)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 
 	if (!filter->filters)
 		return NULL;
@@ -2383,10 +2383,10 @@ tep_filter_make_string(struct event_filter *filter, int event_id)
  *  1 if the two filters hold the same content.
  *  0 if they do not.
  */
-int tep_filter_compare(struct event_filter *filter1, struct event_filter *filter2)
+int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter *filter2)
 {
-	struct filter_type *filter_type1;
-	struct filter_type *filter_type2;
+	struct tep_filter_type *filter_type1;
+	struct tep_filter_type *filter_type2;
 	char *str1, *str2;
 	int result;
 	int i;
-- 
2.14.4
