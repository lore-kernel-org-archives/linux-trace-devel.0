Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732893AbeITAgl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 20:36:41 -0400
Message-Id: <20180919185723.972818215@goodmis.org>
Date: Wed, 19 Sep 2018 14:56:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 10/15] tools/lib/traceevent: Add prefix tep_ to struct
 filter_{arg,value_type}
References: <20180919185643.358126338@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to
struct filter_arg, enum filter_value_type and all enum's members.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h  |  28 +++----
 tools/lib/traceevent/parse-filter.c | 120 ++++++++++++++--------------
 2 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5e55c83d43fe..64ce3eb0dcbc 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -819,13 +819,13 @@ enum tep_filter_arg_type {
 	TEP_FILTER_ARG_STR,
 };
 
-enum filter_value_type {
-	FILTER_NUMBER,
-	FILTER_STRING,
-	FILTER_CHAR
+enum tep_filter_value_type {
+	TEP_FILTER_NUMBER,
+	TEP_FILTER_STRING,
+	TEP_FILTER_CHAR
 };
 
-struct fliter_arg;
+struct tep_filter_arg;
 
 struct filter_arg_boolean {
 	enum tep_filter_boolean_type	value;
@@ -836,7 +836,7 @@ struct filter_arg_field {
 };
 
 struct filter_arg_value {
-	enum filter_value_type	type;
+	enum tep_filter_value_type	type;
 	union {
 		char			*str;
 		unsigned long long	val;
@@ -845,20 +845,20 @@ struct filter_arg_value {
 
 struct filter_arg_op {
 	enum tep_filter_op_type	type;
-	struct filter_arg	*left;
-	struct filter_arg	*right;
+	struct tep_filter_arg	*left;
+	struct tep_filter_arg	*right;
 };
 
 struct filter_arg_exp {
 	enum tep_filter_exp_type	type;
-	struct filter_arg		*left;
-	struct filter_arg		*right;
+	struct tep_filter_arg		*left;
+	struct tep_filter_arg		*right;
 };
 
 struct filter_arg_num {
 	enum tep_filter_cmp_type	type;
-	struct filter_arg	*left;
-	struct filter_arg	*right;
+	struct tep_filter_arg	*left;
+	struct tep_filter_arg	*right;
 };
 
 struct filter_arg_str {
@@ -869,7 +869,7 @@ struct filter_arg_str {
 	regex_t			reg;
 };
 
-struct filter_arg {
+struct tep_filter_arg {
 	enum tep_filter_arg_type		type;
 	union {
 		struct filter_arg_boolean	boolean;
@@ -885,7 +885,7 @@ struct filter_arg {
 struct filter_type {
 	int			event_id;
 	struct tep_event_format	*event;
-	struct filter_arg	*filter;
+	struct tep_filter_arg	*filter;
 };
 
 #define TEP_FILTER_ERROR_BUFSZ  1024
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index d1e0dd5b63ea..b9ca1b9e14e4 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -180,12 +180,12 @@ struct event_filter *tep_filter_alloc(struct tep_handle *pevent)
 	return filter;
 }
 
-static struct filter_arg *allocate_arg(void)
+static struct tep_filter_arg *allocate_arg(void)
 {
-	return calloc(1, sizeof(struct filter_arg));
+	return calloc(1, sizeof(struct tep_filter_arg));
 }
 
-static void free_arg(struct filter_arg *arg)
+static void free_arg(struct tep_filter_arg *arg)
 {
 	if (!arg)
 		return;
@@ -212,8 +212,8 @@ static void free_arg(struct filter_arg *arg)
 		break;
 
 	case TEP_FILTER_ARG_VALUE:
-		if (arg->value.type == FILTER_STRING ||
-		    arg->value.type == FILTER_CHAR)
+		if (arg->value.type == TEP_FILTER_STRING ||
+		    arg->value.type == TEP_FILTER_CHAR)
 			free(arg->value.str);
 		break;
 
@@ -334,10 +334,10 @@ static void free_events(struct event_list *events)
 
 static enum tep_errno
 create_arg_item(struct tep_event_format *event, const char *token,
-		enum tep_event_type type, struct filter_arg **parg, char *error_str)
+		enum tep_event_type type, struct tep_filter_arg **parg, char *error_str)
 {
 	struct tep_format_field *field;
-	struct filter_arg *arg;
+	struct tep_filter_arg *arg;
 
 	arg = allocate_arg();
 	if (arg == NULL) {
@@ -351,7 +351,7 @@ create_arg_item(struct tep_event_format *event, const char *token,
 	case TEP_EVENT_DQUOTE:
 		arg->type = TEP_FILTER_ARG_VALUE;
 		arg->value.type =
-			type == TEP_EVENT_DQUOTE ? FILTER_STRING : FILTER_CHAR;
+			type == TEP_EVENT_DQUOTE ? TEP_FILTER_STRING : TEP_FILTER_CHAR;
 		arg->value.str = strdup(token);
 		if (!arg->value.str) {
 			free_arg(arg);
@@ -363,7 +363,7 @@ create_arg_item(struct tep_event_format *event, const char *token,
 		/* if it is a number, then convert it */
 		if (isdigit(token[0])) {
 			arg->type = TEP_FILTER_ARG_VALUE;
-			arg->value.type = FILTER_NUMBER;
+			arg->value.type = TEP_FILTER_NUMBER;
 			arg->value.val = strtoull(token, NULL, 0);
 			break;
 		}
@@ -394,10 +394,10 @@ create_arg_item(struct tep_event_format *event, const char *token,
 	return 0;
 }
 
-static struct filter_arg *
+static struct tep_filter_arg *
 create_arg_op(enum tep_filter_op_type btype)
 {
-	struct filter_arg *arg;
+	struct tep_filter_arg *arg;
 
 	arg = allocate_arg();
 	if (!arg)
@@ -409,10 +409,10 @@ create_arg_op(enum tep_filter_op_type btype)
 	return arg;
 }
 
-static struct filter_arg *
+static struct tep_filter_arg *
 create_arg_exp(enum tep_filter_exp_type etype)
 {
-	struct filter_arg *arg;
+	struct tep_filter_arg *arg;
 
 	arg = allocate_arg();
 	if (!arg)
@@ -424,10 +424,10 @@ create_arg_exp(enum tep_filter_exp_type etype)
 	return arg;
 }
 
-static struct filter_arg *
+static struct tep_filter_arg *
 create_arg_cmp(enum tep_filter_cmp_type ctype)
 {
-	struct filter_arg *arg;
+	struct tep_filter_arg *arg;
 
 	arg = allocate_arg();
 	if (!arg)
@@ -441,9 +441,9 @@ create_arg_cmp(enum tep_filter_cmp_type ctype)
 }
 
 static enum tep_errno
-add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
+add_right(struct tep_filter_arg *op, struct tep_filter_arg *arg, char *error_str)
 {
-	struct filter_arg *left;
+	struct tep_filter_arg *left;
 	char *str;
 	int op_type;
 	int ret;
@@ -481,7 +481,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 		 * convert this to a string or regex.
 		 */
 		switch (arg->value.type) {
-		case FILTER_CHAR:
+		case TEP_FILTER_CHAR:
 			/*
 			 * A char should be converted to number if
 			 * the string is 1 byte, and the compare
@@ -490,11 +490,11 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 			if (strlen(arg->value.str) == 1 &&
 			    op->num.type != TEP_FILTER_CMP_REGEX &&
 			    op->num.type != TEP_FILTER_CMP_NOT_REGEX) {
-				arg->value.type = FILTER_NUMBER;
+				arg->value.type = TEP_FILTER_NUMBER;
 				goto do_int;
 			}
 			/* fall through */
-		case FILTER_STRING:
+		case TEP_FILTER_STRING:
 
 			/* convert op to a string arg */
 			op_type = op->num.type;
@@ -573,7 +573,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 
 			break;
 
-		case FILTER_NUMBER:
+		case TEP_FILTER_NUMBER:
 
  do_int:
 			switch (op->num.type) {
@@ -605,17 +605,17 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 	return TEP_ERRNO__SYNTAX_ERROR;
 }
 
-static struct filter_arg *
-rotate_op_right(struct filter_arg *a, struct filter_arg *b)
+static struct tep_filter_arg *
+rotate_op_right(struct tep_filter_arg *a, struct tep_filter_arg *b)
 {
-	struct filter_arg *arg;
+	struct tep_filter_arg *arg;
 
 	arg = a->op.right;
 	a->op.right = b;
 	return arg;
 }
 
-static enum tep_errno add_left(struct filter_arg *op, struct filter_arg *arg)
+static enum tep_errno add_left(struct tep_filter_arg *op, struct tep_filter_arg *arg)
 {
 	switch (op->type) {
 	case TEP_FILTER_ARG_EXP:
@@ -720,7 +720,7 @@ static enum op_type process_op(const char *token,
 	return OP_CMP;
 }
 
-static int check_op_done(struct filter_arg *arg)
+static int check_op_done(struct tep_filter_arg *arg)
 {
 	switch (arg->type) {
 	case TEP_FILTER_ARG_EXP:
@@ -752,11 +752,11 @@ enum filter_vals {
 };
 
 static enum tep_errno
-reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
-		struct filter_arg *arg, char *error_str)
+reparent_op_arg(struct tep_filter_arg *parent, struct tep_filter_arg *old_child,
+		struct tep_filter_arg *arg, char *error_str)
 {
-	struct filter_arg *other_child;
-	struct filter_arg **ptr;
+	struct tep_filter_arg *other_child;
+	struct tep_filter_arg **ptr;
 
 	if (parent->type != TEP_FILTER_ARG_OP &&
 	    arg->type != TEP_FILTER_ARG_OP) {
@@ -804,7 +804,7 @@ reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 }
 
 /* Returns either filter_vals (success) or tep_errno (failfure) */
-static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
+static int test_arg(struct tep_filter_arg *parent, struct tep_filter_arg *arg,
 		    char *error_str)
 {
 	int lval, rval;
@@ -904,8 +904,8 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 }
 
 /* Remove any unknown event fields */
-static int collapse_tree(struct filter_arg *arg,
-			 struct filter_arg **arg_collapsed, char *error_str)
+static int collapse_tree(struct tep_filter_arg *arg,
+			 struct tep_filter_arg **arg_collapsed, char *error_str)
 {
 	int ret;
 
@@ -939,15 +939,15 @@ static int collapse_tree(struct filter_arg *arg,
 }
 
 static enum tep_errno
-process_filter(struct tep_event_format *event, struct filter_arg **parg,
+process_filter(struct tep_event_format *event, struct tep_filter_arg **parg,
 	       char *error_str, int not)
 {
 	enum tep_event_type type;
 	char *token = NULL;
-	struct filter_arg *current_op = NULL;
-	struct filter_arg *current_exp = NULL;
-	struct filter_arg *left_item = NULL;
-	struct filter_arg *arg = NULL;
+	struct tep_filter_arg *current_op = NULL;
+	struct tep_filter_arg *current_exp = NULL;
+	struct tep_filter_arg *left_item = NULL;
+	struct tep_filter_arg *arg = NULL;
 	enum op_type op_type;
 	enum tep_filter_op_type btype;
 	enum tep_filter_exp_type etype;
@@ -1180,7 +1180,7 @@ process_filter(struct tep_event_format *event, struct filter_arg **parg,
 
 static enum tep_errno
 process_event(struct tep_event_format *event, const char *filter_str,
-	      struct filter_arg **parg, char *error_str)
+	      struct tep_filter_arg **parg, char *error_str)
 {
 	int ret;
 
@@ -1208,7 +1208,7 @@ filter_event(struct event_filter *filter, struct tep_event_format *event,
 	     const char *filter_str, char *error_str)
 {
 	struct filter_type *filter_type;
-	struct filter_arg *arg;
+	struct tep_filter_arg *arg;
 	enum tep_errno ret;
 
 	if (filter_str) {
@@ -1449,13 +1449,13 @@ void tep_filter_free(struct event_filter *filter)
 	free(filter);
 }
 
-static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg);
+static char *arg_to_str(struct event_filter *filter, struct tep_filter_arg *arg);
 
 static int copy_filter_type(struct event_filter *filter,
 			     struct event_filter *source,
 			     struct filter_type *filter_type)
 {
-	struct filter_arg *arg;
+	struct tep_filter_arg *arg;
 	struct tep_event_format *event;
 	const char *sys;
 	const char *name;
@@ -1540,7 +1540,7 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
 	struct tep_handle *dest_pevent;
 	struct tep_event_format *event;
 	struct filter_type *filter_type;
-	struct filter_arg *arg;
+	struct tep_filter_arg *arg;
 	char *str;
 	int i;
 
@@ -1682,7 +1682,7 @@ int tep_filter_event_has_trivial(struct event_filter *filter,
 	}
 }
 
-static int test_filter(struct tep_event_format *event, struct filter_arg *arg,
+static int test_filter(struct tep_event_format *event, struct tep_filter_arg *arg,
 		       struct tep_record *record, enum tep_errno *err);
 
 static const char *
@@ -1733,11 +1733,11 @@ get_value(struct tep_event_format *event,
 }
 
 static unsigned long long
-get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
+get_arg_value(struct tep_event_format *event, struct tep_filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err);
 
 static unsigned long long
-get_exp_value(struct tep_event_format *event, struct filter_arg *arg,
+get_exp_value(struct tep_event_format *event, struct tep_filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
@@ -1792,7 +1792,7 @@ get_exp_value(struct tep_event_format *event, struct filter_arg *arg,
 }
 
 static unsigned long long
-get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
+get_arg_value(struct tep_event_format *event, struct tep_filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->type) {
@@ -1800,7 +1800,7 @@ get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
 		return get_value(event, arg->field.field, record);
 
 	case TEP_FILTER_ARG_VALUE:
-		if (arg->value.type != FILTER_NUMBER) {
+		if (arg->value.type != TEP_FILTER_NUMBER) {
 			if (!*err)
 				*err = TEP_ERRNO__NOT_A_NUMBER;
 		}
@@ -1816,7 +1816,7 @@ get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
 	return 0;
 }
 
-static int test_num(struct tep_event_format *event, struct filter_arg *arg,
+static int test_num(struct tep_event_format *event, struct tep_filter_arg *arg,
 		    struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
@@ -1857,7 +1857,7 @@ static int test_num(struct tep_event_format *event, struct filter_arg *arg,
 	}
 }
 
-static const char *get_field_str(struct filter_arg *arg, struct tep_record *record)
+static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *record)
 {
 	struct tep_event_format *event;
 	struct tep_handle *pevent;
@@ -1907,7 +1907,7 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 	return val;
 }
 
-static int test_str(struct tep_event_format *event, struct filter_arg *arg,
+static int test_str(struct tep_event_format *event, struct tep_filter_arg *arg,
 		    struct tep_record *record, enum tep_errno *err)
 {
 	const char *val;
@@ -1938,7 +1938,7 @@ static int test_str(struct tep_event_format *event, struct filter_arg *arg,
 	}
 }
 
-static int test_op(struct tep_event_format *event, struct filter_arg *arg,
+static int test_op(struct tep_event_format *event, struct tep_filter_arg *arg,
 		   struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->op.type) {
@@ -1960,7 +1960,7 @@ static int test_op(struct tep_event_format *event, struct filter_arg *arg,
 	}
 }
 
-static int test_filter(struct tep_event_format *event, struct filter_arg *arg,
+static int test_filter(struct tep_event_format *event, struct tep_filter_arg *arg,
 		       struct tep_record *record, enum tep_errno *err)
 {
 	if (*err) {
@@ -2059,7 +2059,7 @@ enum tep_errno tep_filter_match(struct event_filter *filter,
 	return ret ? TEP_ERRNO__FILTER_MATCH : TEP_ERRNO__FILTER_MISS;
 }
 
-static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
+static char *op_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 	char *left = NULL;
@@ -2163,7 +2163,7 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 	return str;
 }
 
-static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
+static char *val_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 
@@ -2172,12 +2172,12 @@ static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
 	return str;
 }
 
-static char *field_to_str(struct event_filter *filter, struct filter_arg *arg)
+static char *field_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 {
 	return strdup(arg->field.field->name);
 }
 
-static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
+static char *exp_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *lstr;
 	char *rstr;
@@ -2233,7 +2233,7 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 	return str;
 }
 
-static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
+static char *num_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *lstr;
 	char *rstr;
@@ -2283,7 +2283,7 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 	return str;
 }
 
-static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
+static char *str_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 	char *op = NULL;
@@ -2315,7 +2315,7 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 	return str;
 }
 
-static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
+static char *arg_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 
-- 
2.18.0
