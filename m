Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:40280 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbeHJPrt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:49 -0400
Received: by mail-wm0-f46.google.com with SMTP id y9-v6so1882133wma.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:17:55 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 08/14] tools/lib/traceevent: Add prefix tep_ to enums filter_boolean_type, filter_op_type, filter_cmp_type and all enum's members
Date: Fri, 10 Aug 2018 16:17:26 +0300
Message-Id: <20180810131732.24677-9-tz.stoyanov@gmail.com>
In-Reply-To: <20180810131732.24677-1-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to enums
filter_boolean_type, filter_op_type, filter_cmp_type and all enum's members

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.h  |  46 ++++-----
 tools/lib/traceevent/parse-filter.c | 144 ++++++++++++++--------------
 2 files changed, 95 insertions(+), 95 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index b6099eebcc60..17d13b9d724a 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -810,29 +810,29 @@ void tep_print_printk(struct tep_handle *pevent);
 
 /* ----------------------- filtering ----------------------- */
 
-enum filter_boolean_type {
-	FILTER_FALSE,
-	FILTER_TRUE,
+enum tep_filter_boolean_type {
+	TEP_FILTER_FALSE,
+	TEP_FILTER_TRUE,
 };
 
-enum filter_op_type {
-	FILTER_OP_AND = 1,
-	FILTER_OP_OR,
-	FILTER_OP_NOT,
+enum tep_filter_op_type {
+	TEP_FILTER_OP_AND = 1,
+	TEP_FILTER_OP_OR,
+	TEP_FILTER_OP_NOT,
 };
 
-enum filter_cmp_type {
-	FILTER_CMP_NONE,
-	FILTER_CMP_EQ,
-	FILTER_CMP_NE,
-	FILTER_CMP_GT,
-	FILTER_CMP_LT,
-	FILTER_CMP_GE,
-	FILTER_CMP_LE,
-	FILTER_CMP_MATCH,
-	FILTER_CMP_NOT_MATCH,
-	FILTER_CMP_REGEX,
-	FILTER_CMP_NOT_REGEX,
+enum tep_filter_cmp_type {
+	TEP_FILTER_CMP_NONE,
+	TEP_FILTER_CMP_EQ,
+	TEP_FILTER_CMP_NE,
+	TEP_FILTER_CMP_GT,
+	TEP_FILTER_CMP_LT,
+	TEP_FILTER_CMP_GE,
+	TEP_FILTER_CMP_LE,
+	TEP_FILTER_CMP_MATCH,
+	TEP_FILTER_CMP_NOT_MATCH,
+	TEP_FILTER_CMP_REGEX,
+	TEP_FILTER_CMP_NOT_REGEX,
 };
 
 enum filter_exp_type {
@@ -870,7 +870,7 @@ enum filter_value_type {
 struct fliter_arg;
 
 struct filter_arg_boolean {
-	enum filter_boolean_type	value;
+	enum tep_filter_boolean_type	value;
 };
 
 struct filter_arg_field {
@@ -886,7 +886,7 @@ struct filter_arg_value {
 };
 
 struct filter_arg_op {
-	enum filter_op_type	type;
+	enum tep_filter_op_type	type;
 	struct filter_arg	*left;
 	struct filter_arg	*right;
 };
@@ -898,13 +898,13 @@ struct filter_arg_exp {
 };
 
 struct filter_arg_num {
-	enum filter_cmp_type	type;
+	enum tep_filter_cmp_type	type;
 	struct filter_arg	*left;
 	struct filter_arg	*right;
 };
 
 struct filter_arg_str {
-	enum filter_cmp_type	type;
+	enum tep_filter_cmp_type	type;
 	struct tep_format_field	*field;
 	char			*val;
 	char			*buffer;
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index a637cc6ed64d..9e952f6f0db4 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -392,7 +392,7 @@ create_arg_item(struct tep_event_format *event, const char *token,
 			} else {
 				/* not a field, Make it false */
 				arg->type = FILTER_ARG_BOOLEAN;
-				arg->boolean.value = FILTER_FALSE;
+				arg->boolean.value = TEP_FILTER_FALSE;
 				break;
 			}
 		}
@@ -409,7 +409,7 @@ create_arg_item(struct tep_event_format *event, const char *token,
 }
 
 static struct filter_arg *
-create_arg_op(enum filter_op_type btype)
+create_arg_op(enum tep_filter_op_type btype)
 {
 	struct filter_arg *arg;
 
@@ -439,7 +439,7 @@ create_arg_exp(enum filter_exp_type etype)
 }
 
 static struct filter_arg *
-create_arg_cmp(enum filter_cmp_type ctype)
+create_arg_cmp(enum tep_filter_cmp_type ctype)
 {
 	struct filter_arg *arg;
 
@@ -502,8 +502,8 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 			 * is not a REGEX.
 			 */
 			if (strlen(arg->value.str) == 1 &&
-			    op->num.type != FILTER_CMP_REGEX &&
-			    op->num.type != FILTER_CMP_NOT_REGEX) {
+			    op->num.type != TEP_FILTER_CMP_REGEX &&
+			    op->num.type != TEP_FILTER_CMP_NOT_REGEX) {
 				arg->value.type = FILTER_NUMBER;
 				goto do_int;
 			}
@@ -526,7 +526,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 				free_arg(left);
 				free_arg(arg);
 				op->type = FILTER_ARG_BOOLEAN;
-				op->boolean.value = FILTER_FALSE;
+				op->boolean.value = TEP_FILTER_FALSE;
 				break;
 			}
 
@@ -539,15 +539,15 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 
 			/* Make sure this is a valid string compare */
 			switch (op_type) {
-			case FILTER_CMP_EQ:
-				op_type = FILTER_CMP_MATCH;
+			case TEP_FILTER_CMP_EQ:
+				op_type = TEP_FILTER_CMP_MATCH;
 				break;
-			case FILTER_CMP_NE:
-				op_type = FILTER_CMP_NOT_MATCH;
+			case TEP_FILTER_CMP_NE:
+				op_type = TEP_FILTER_CMP_NOT_MATCH;
 				break;
 
-			case FILTER_CMP_REGEX:
-			case FILTER_CMP_NOT_REGEX:
+			case TEP_FILTER_CMP_REGEX:
+			case TEP_FILTER_CMP_NOT_REGEX:
 				ret = regcomp(&op->str.reg, str, REG_ICASE|REG_NOSUB);
 				if (ret) {
 					show_error(error_str,
@@ -591,8 +591,8 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 
  do_int:
 			switch (op->num.type) {
-			case FILTER_CMP_REGEX:
-			case FILTER_CMP_NOT_REGEX:
+			case TEP_FILTER_CMP_REGEX:
+			case TEP_FILTER_CMP_NOT_REGEX:
 				show_error(error_str,
 					   "Op not allowed with integers");
 				return TEP_ERRNO__ILLEGAL_INTEGER_CMP;
@@ -666,22 +666,22 @@ enum op_type {
 };
 
 static enum op_type process_op(const char *token,
-			       enum filter_op_type *btype,
-			       enum filter_cmp_type *ctype,
+			       enum tep_filter_op_type *btype,
+			       enum tep_filter_cmp_type *ctype,
 			       enum filter_exp_type *etype)
 {
-	*btype = FILTER_OP_NOT;
+	*btype = TEP_FILTER_OP_NOT;
 	*etype = FILTER_EXP_NONE;
-	*ctype = FILTER_CMP_NONE;
+	*ctype = TEP_FILTER_CMP_NONE;
 
 	if (strcmp(token, "&&") == 0)
-		*btype = FILTER_OP_AND;
+		*btype = TEP_FILTER_OP_AND;
 	else if (strcmp(token, "||") == 0)
-		*btype = FILTER_OP_OR;
+		*btype = TEP_FILTER_OP_OR;
 	else if (strcmp(token, "!") == 0)
 		return OP_NOT;
 
-	if (*btype != FILTER_OP_NOT)
+	if (*btype != TEP_FILTER_OP_NOT)
 		return OP_BOOL;
 
 	/* Check for value expressions */
@@ -713,21 +713,21 @@ static enum op_type process_op(const char *token,
 
 	/* Check for compares */
 	if (strcmp(token, "==") == 0)
-		*ctype = FILTER_CMP_EQ;
+		*ctype = TEP_FILTER_CMP_EQ;
 	else if (strcmp(token, "!=") == 0)
-		*ctype = FILTER_CMP_NE;
+		*ctype = TEP_FILTER_CMP_NE;
 	else if (strcmp(token, "<") == 0)
-		*ctype = FILTER_CMP_LT;
+		*ctype = TEP_FILTER_CMP_LT;
 	else if (strcmp(token, ">") == 0)
-		*ctype = FILTER_CMP_GT;
+		*ctype = TEP_FILTER_CMP_GT;
 	else if (strcmp(token, "<=") == 0)
-		*ctype = FILTER_CMP_LE;
+		*ctype = TEP_FILTER_CMP_LE;
 	else if (strcmp(token, ">=") == 0)
-		*ctype = FILTER_CMP_GE;
+		*ctype = TEP_FILTER_CMP_GE;
 	else if (strcmp(token, "=~") == 0)
-		*ctype = FILTER_CMP_REGEX;
+		*ctype = TEP_FILTER_CMP_REGEX;
 	else if (strcmp(token, "!~") == 0)
-		*ctype = FILTER_CMP_NOT_REGEX;
+		*ctype = TEP_FILTER_CMP_NOT_REGEX;
 	else
 		return OP_NONE;
 
@@ -854,13 +854,13 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 		return FILTER_VAL_NORM;
 
 	case FILTER_ARG_OP:
-		if (arg->op.type != FILTER_OP_NOT) {
+		if (arg->op.type != TEP_FILTER_OP_NOT) {
 			lval = test_arg(arg, arg->op.left, error_str);
 			switch (lval) {
 			case FILTER_VAL_NORM:
 				break;
 			case FILTER_VAL_TRUE:
-				if (arg->op.type == FILTER_OP_OR)
+				if (arg->op.type == TEP_FILTER_OP_OR)
 					return FILTER_VAL_TRUE;
 				rval = test_arg(arg, arg->op.right, error_str);
 				if (rval != FILTER_VAL_NORM)
@@ -870,7 +870,7 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 						       error_str);
 
 			case FILTER_VAL_FALSE:
-				if (arg->op.type == FILTER_OP_AND)
+				if (arg->op.type == TEP_FILTER_OP_AND)
 					return FILTER_VAL_FALSE;
 				rval = test_arg(arg, arg->op.right, error_str);
 				if (rval != FILTER_VAL_NORM)
@@ -891,18 +891,18 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 			break;
 
 		case FILTER_VAL_TRUE:
-			if (arg->op.type == FILTER_OP_OR)
+			if (arg->op.type == TEP_FILTER_OP_OR)
 				return FILTER_VAL_TRUE;
-			if (arg->op.type == FILTER_OP_NOT)
+			if (arg->op.type == TEP_FILTER_OP_NOT)
 				return FILTER_VAL_FALSE;
 
 			return reparent_op_arg(parent, arg, arg->op.left,
 					       error_str);
 
 		case FILTER_VAL_FALSE:
-			if (arg->op.type == FILTER_OP_AND)
+			if (arg->op.type == TEP_FILTER_OP_AND)
 				return FILTER_VAL_FALSE;
-			if (arg->op.type == FILTER_OP_NOT)
+			if (arg->op.type == TEP_FILTER_OP_NOT)
 				return FILTER_VAL_TRUE;
 
 			return reparent_op_arg(parent, arg, arg->op.left,
@@ -963,9 +963,9 @@ process_filter(struct tep_event_format *event, struct filter_arg **parg,
 	struct filter_arg *left_item = NULL;
 	struct filter_arg *arg = NULL;
 	enum op_type op_type;
-	enum filter_op_type btype;
+	enum tep_filter_op_type btype;
 	enum filter_exp_type etype;
-	enum filter_cmp_type ctype;
+	enum tep_filter_cmp_type ctype;
 	enum tep_errno ret;
 
 	*parg = NULL;
@@ -1211,7 +1211,7 @@ process_event(struct tep_event_format *event, const char *filter_str,
 			return TEP_ERRNO__MEM_ALLOC_FAILED;
 
 		(*parg)->type = FILTER_ARG_BOOLEAN;
-		(*parg)->boolean.value = FILTER_FALSE;
+		(*parg)->boolean.value = TEP_FILTER_FALSE;
 	}
 
 	return 0;
@@ -1237,7 +1237,7 @@ filter_event(struct event_filter *filter, struct tep_event_format *event,
 			return TEP_ERRNO__MEM_ALLOC_FAILED;
 
 		arg->type = FILTER_ARG_BOOLEAN;
-		arg->boolean.value = FILTER_TRUE;
+		arg->boolean.value = TEP_FILTER_TRUE;
 	}
 
 	filter_type = add_filter_type(filter, event->id);
@@ -1846,22 +1846,22 @@ static int test_num(struct tep_event_format *event, struct filter_arg *arg,
 	}
 
 	switch (arg->num.type) {
-	case FILTER_CMP_EQ:
+	case TEP_FILTER_CMP_EQ:
 		return lval == rval;
 
-	case FILTER_CMP_NE:
+	case TEP_FILTER_CMP_NE:
 		return lval != rval;
 
-	case FILTER_CMP_GT:
+	case TEP_FILTER_CMP_GT:
 		return lval > rval;
 
-	case FILTER_CMP_LT:
+	case TEP_FILTER_CMP_LT:
 		return lval < rval;
 
-	case FILTER_CMP_GE:
+	case TEP_FILTER_CMP_GE:
 		return lval >= rval;
 
-	case FILTER_CMP_LE:
+	case TEP_FILTER_CMP_LE:
 		return lval <= rval;
 
 	default:
@@ -1932,17 +1932,17 @@ static int test_str(struct tep_event_format *event, struct filter_arg *arg,
 		val = get_field_str(arg, record);
 
 	switch (arg->str.type) {
-	case FILTER_CMP_MATCH:
+	case TEP_FILTER_CMP_MATCH:
 		return strcmp(val, arg->str.val) == 0;
 
-	case FILTER_CMP_NOT_MATCH:
+	case TEP_FILTER_CMP_NOT_MATCH:
 		return strcmp(val, arg->str.val) != 0;
 
-	case FILTER_CMP_REGEX:
+	case TEP_FILTER_CMP_REGEX:
 		/* Returns zero on match */
 		return !regexec(&arg->str.reg, val, 0, NULL, 0);
 
-	case FILTER_CMP_NOT_REGEX:
+	case TEP_FILTER_CMP_NOT_REGEX:
 		return regexec(&arg->str.reg, val, 0, NULL, 0);
 
 	default:
@@ -1956,15 +1956,15 @@ static int test_op(struct tep_event_format *event, struct filter_arg *arg,
 		   struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->op.type) {
-	case FILTER_OP_AND:
+	case TEP_FILTER_OP_AND:
 		return test_filter(event, arg->op.left, record, err) &&
 			test_filter(event, arg->op.right, record, err);
 
-	case FILTER_OP_OR:
+	case TEP_FILTER_OP_OR:
 		return test_filter(event, arg->op.left, record, err) ||
 			test_filter(event, arg->op.right, record, err);
 
-	case FILTER_OP_NOT:
+	case TEP_FILTER_OP_NOT:
 		return !test_filter(event, arg->op.right, record, err);
 
 	default:
@@ -2084,10 +2084,10 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 	int val;
 
 	switch (arg->op.type) {
-	case FILTER_OP_AND:
+	case TEP_FILTER_OP_AND:
 		op = "&&";
 		/* fall through */
-	case FILTER_OP_OR:
+	case TEP_FILTER_OP_OR:
 		if (!op)
 			op = "||";
 
@@ -2108,8 +2108,8 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 			right_val = 0;
 
 		if (left_val >= 0) {
-			if ((arg->op.type == FILTER_OP_AND && !left_val) ||
-			    (arg->op.type == FILTER_OP_OR && left_val)) {
+			if ((arg->op.type == TEP_FILTER_OP_AND && !left_val) ||
+			    (arg->op.type == TEP_FILTER_OP_OR && left_val)) {
 				/* Just return left value */
 				str = left;
 				left = NULL;
@@ -2119,10 +2119,10 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 				/* just evaluate this. */
 				val = 0;
 				switch (arg->op.type) {
-				case FILTER_OP_AND:
+				case TEP_FILTER_OP_AND:
 					val = left_val && right_val;
 					break;
-				case FILTER_OP_OR:
+				case TEP_FILTER_OP_OR:
 					val = left_val || right_val;
 					break;
 				default:
@@ -2133,8 +2133,8 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 			}
 		}
 		if (right_val >= 0) {
-			if ((arg->op.type == FILTER_OP_AND && !right_val) ||
-			    (arg->op.type == FILTER_OP_OR && right_val)) {
+			if ((arg->op.type == TEP_FILTER_OP_AND && !right_val) ||
+			    (arg->op.type == TEP_FILTER_OP_OR && right_val)) {
 				/* Just return right value */
 				str = right;
 				right = NULL;
@@ -2149,7 +2149,7 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
 		asprintf(&str, "(%s) %s (%s)", left, op, right);
 		break;
 
-	case FILTER_OP_NOT:
+	case TEP_FILTER_OP_NOT:
 		op = "!";
 		right = arg_to_str(filter, arg->op.right);
 		if (!right)
@@ -2260,26 +2260,26 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 		goto out;
 
 	switch (arg->num.type) {
-	case FILTER_CMP_EQ:
+	case TEP_FILTER_CMP_EQ:
 		op = "==";
 		/* fall through */
-	case FILTER_CMP_NE:
+	case TEP_FILTER_CMP_NE:
 		if (!op)
 			op = "!=";
 		/* fall through */
-	case FILTER_CMP_GT:
+	case TEP_FILTER_CMP_GT:
 		if (!op)
 			op = ">";
 		/* fall through */
-	case FILTER_CMP_LT:
+	case TEP_FILTER_CMP_LT:
 		if (!op)
 			op = "<";
 		/* fall through */
-	case FILTER_CMP_GE:
+	case TEP_FILTER_CMP_GE:
 		if (!op)
 			op = ">=";
 		/* fall through */
-	case FILTER_CMP_LE:
+	case TEP_FILTER_CMP_LE:
 		if (!op)
 			op = "<=";
 
@@ -2303,18 +2303,18 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
 	char *op = NULL;
 
 	switch (arg->str.type) {
-	case FILTER_CMP_MATCH:
+	case TEP_FILTER_CMP_MATCH:
 		op = "==";
 		/* fall through */
-	case FILTER_CMP_NOT_MATCH:
+	case TEP_FILTER_CMP_NOT_MATCH:
 		if (!op)
 			op = "!=";
 		/* fall through */
-	case FILTER_CMP_REGEX:
+	case TEP_FILTER_CMP_REGEX:
 		if (!op)
 			op = "=~";
 		/* fall through */
-	case FILTER_CMP_NOT_REGEX:
+	case TEP_FILTER_CMP_NOT_REGEX:
 		if (!op)
 			op = "!~";
 
-- 
2.17.1
