Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35600 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728415AbeHJPrv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:51 -0400
Received: by mail-wm0-f53.google.com with SMTP id o18-v6so1902917wmc.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:17:56 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 09/14] tools/lib/traceevent: Add prefix tep_ to enums filter_exp_type, filter_arg_type and all enum's members
Date: Fri, 10 Aug 2018 16:17:27 +0300
Message-Id: <20180810131732.24677-10-tz.stoyanov@gmail.com>
In-Reply-To: <20180810131732.24677-1-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to enums
filter_exp_type, filter_arg_type and all enum's members

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.h  |  56 ++++----
 tools/lib/traceevent/parse-filter.c | 210 ++++++++++++++--------------
 2 files changed, 133 insertions(+), 133 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 17d13b9d724a..9b739f98ddec 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -835,30 +835,30 @@ enum tep_filter_cmp_type {
 	TEP_FILTER_CMP_NOT_REGEX,
 };
 
-enum filter_exp_type {
-	FILTER_EXP_NONE,
-	FILTER_EXP_ADD,
-	FILTER_EXP_SUB,
-	FILTER_EXP_MUL,
-	FILTER_EXP_DIV,
-	FILTER_EXP_MOD,
-	FILTER_EXP_RSHIFT,
-	FILTER_EXP_LSHIFT,
-	FILTER_EXP_AND,
-	FILTER_EXP_OR,
-	FILTER_EXP_XOR,
-	FILTER_EXP_NOT,
-};
-
-enum filter_arg_type {
-	FILTER_ARG_NONE,
-	FILTER_ARG_BOOLEAN,
-	FILTER_ARG_VALUE,
-	FILTER_ARG_FIELD,
-	FILTER_ARG_EXP,
-	FILTER_ARG_OP,
-	FILTER_ARG_NUM,
-	FILTER_ARG_STR,
+enum tep_filter_exp_type {
+	TEP_FILTER_EXP_NONE,
+	TEP_FILTER_EXP_ADD,
+	TEP_FILTER_EXP_SUB,
+	TEP_FILTER_EXP_MUL,
+	TEP_FILTER_EXP_DIV,
+	TEP_FILTER_EXP_MOD,
+	TEP_FILTER_EXP_RSHIFT,
+	TEP_FILTER_EXP_LSHIFT,
+	TEP_FILTER_EXP_AND,
+	TEP_FILTER_EXP_OR,
+	TEP_FILTER_EXP_XOR,
+	TEP_FILTER_EXP_NOT,
+};
+
+enum tep_filter_arg_type {
+	TEP_FILTER_ARG_NONE,
+	TEP_FILTER_ARG_BOOLEAN,
+	TEP_FILTER_ARG_VALUE,
+	TEP_FILTER_ARG_FIELD,
+	TEP_FILTER_ARG_EXP,
+	TEP_FILTER_ARG_OP,
+	TEP_FILTER_ARG_NUM,
+	TEP_FILTER_ARG_STR,
 };
 
 enum filter_value_type {
@@ -892,9 +892,9 @@ struct filter_arg_op {
 };
 
 struct filter_arg_exp {
-	enum filter_exp_type	type;
-	struct filter_arg	*left;
-	struct filter_arg	*right;
+	enum tep_filter_exp_type	type;
+	struct filter_arg		*left;
+	struct filter_arg		*right;
 };
 
 struct filter_arg_num {
@@ -912,7 +912,7 @@ struct filter_arg_str {
 };
 
 struct filter_arg {
-	enum filter_arg_type	type;
+	enum tep_filter_arg_type		type;
 	union {
 		struct filter_arg_boolean	boolean;
 		struct filter_arg_field		field;
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 9e952f6f0db4..58c00c7f03c6 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -205,33 +205,33 @@ static void free_arg(struct filter_arg *arg)
 		return;
 
 	switch (arg->type) {
-	case FILTER_ARG_NONE:
-	case FILTER_ARG_BOOLEAN:
+	case TEP_FILTER_ARG_NONE:
+	case TEP_FILTER_ARG_BOOLEAN:
 		break;
 
-	case FILTER_ARG_NUM:
+	case TEP_FILTER_ARG_NUM:
 		free_arg(arg->num.left);
 		free_arg(arg->num.right);
 		break;
 
-	case FILTER_ARG_EXP:
+	case TEP_FILTER_ARG_EXP:
 		free_arg(arg->exp.left);
 		free_arg(arg->exp.right);
 		break;
 
-	case FILTER_ARG_STR:
+	case TEP_FILTER_ARG_STR:
 		free(arg->str.val);
 		regfree(&arg->str.reg);
 		free(arg->str.buffer);
 		break;
 
-	case FILTER_ARG_VALUE:
+	case TEP_FILTER_ARG_VALUE:
 		if (arg->value.type == FILTER_STRING ||
 		    arg->value.type == FILTER_CHAR)
 			free(arg->value.str);
 		break;
 
-	case FILTER_ARG_OP:
+	case TEP_FILTER_ARG_OP:
 		free_arg(arg->op.left);
 		free_arg(arg->op.right);
 	default:
@@ -363,7 +363,7 @@ create_arg_item(struct tep_event_format *event, const char *token,
 
 	case TEP_EVENT_SQUOTE:
 	case TEP_EVENT_DQUOTE:
-		arg->type = FILTER_ARG_VALUE;
+		arg->type = TEP_FILTER_ARG_VALUE;
 		arg->value.type =
 			type == TEP_EVENT_DQUOTE ? FILTER_STRING : FILTER_CHAR;
 		arg->value.str = strdup(token);
@@ -376,7 +376,7 @@ create_arg_item(struct tep_event_format *event, const char *token,
 	case TEP_EVENT_ITEM:
 		/* if it is a number, then convert it */
 		if (isdigit(token[0])) {
-			arg->type = FILTER_ARG_VALUE;
+			arg->type = TEP_FILTER_ARG_VALUE;
 			arg->value.type = FILTER_NUMBER;
 			arg->value.val = strtoull(token, NULL, 0);
 			break;
@@ -391,12 +391,12 @@ create_arg_item(struct tep_event_format *event, const char *token,
 				field = &cpu;
 			} else {
 				/* not a field, Make it false */
-				arg->type = FILTER_ARG_BOOLEAN;
+				arg->type = TEP_FILTER_ARG_BOOLEAN;
 				arg->boolean.value = TEP_FILTER_FALSE;
 				break;
 			}
 		}
-		arg->type = FILTER_ARG_FIELD;
+		arg->type = TEP_FILTER_ARG_FIELD;
 		arg->field.field = field;
 		break;
 	default:
@@ -417,14 +417,14 @@ create_arg_op(enum tep_filter_op_type btype)
 	if (!arg)
 		return NULL;
 
-	arg->type = FILTER_ARG_OP;
+	arg->type = TEP_FILTER_ARG_OP;
 	arg->op.type = btype;
 
 	return arg;
 }
 
 static struct filter_arg *
-create_arg_exp(enum filter_exp_type etype)
+create_arg_exp(enum tep_filter_exp_type etype)
 {
 	struct filter_arg *arg;
 
@@ -432,7 +432,7 @@ create_arg_exp(enum filter_exp_type etype)
 	if (!arg)
 		return NULL;
 
-	arg->type = FILTER_ARG_EXP;
+	arg->type = TEP_FILTER_ARG_EXP;
 	arg->exp.type = etype;
 
 	return arg;
@@ -448,7 +448,7 @@ create_arg_cmp(enum tep_filter_cmp_type ctype)
 		return NULL;
 
 	/* Use NUM and change if necessary */
-	arg->type = FILTER_ARG_NUM;
+	arg->type = TEP_FILTER_ARG_NUM;
 	arg->num.type = ctype;
 
 	return arg;
@@ -463,27 +463,27 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 	int ret;
 
 	switch (op->type) {
-	case FILTER_ARG_EXP:
+	case TEP_FILTER_ARG_EXP:
 		if (op->exp.right)
 			goto out_fail;
 		op->exp.right = arg;
 		break;
 
-	case FILTER_ARG_OP:
+	case TEP_FILTER_ARG_OP:
 		if (op->op.right)
 			goto out_fail;
 		op->op.right = arg;
 		break;
 
-	case FILTER_ARG_NUM:
+	case TEP_FILTER_ARG_NUM:
 		if (op->op.right)
 			goto out_fail;
 		/*
 		 * The arg must be num, str, or field
 		 */
 		switch (arg->type) {
-		case FILTER_ARG_VALUE:
-		case FILTER_ARG_FIELD:
+		case TEP_FILTER_ARG_VALUE:
+		case TEP_FILTER_ARG_FIELD:
 			break;
 		default:
 			show_error(error_str, "Illegal rvalue");
@@ -522,16 +522,16 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 			 * If left arg was a field not found then
 			 * NULL the entire op.
 			 */
-			if (left->type == FILTER_ARG_BOOLEAN) {
+			if (left->type == TEP_FILTER_ARG_BOOLEAN) {
 				free_arg(left);
 				free_arg(arg);
-				op->type = FILTER_ARG_BOOLEAN;
+				op->type = TEP_FILTER_ARG_BOOLEAN;
 				op->boolean.value = TEP_FILTER_FALSE;
 				break;
 			}
 
 			/* Left arg must be a field */
-			if (left->type != FILTER_ARG_FIELD) {
+			if (left->type != TEP_FILTER_ARG_FIELD) {
 				show_error(error_str,
 					   "Illegal lvalue for string comparison");
 				return TEP_ERRNO__ILLEGAL_LVALUE;
@@ -562,7 +562,7 @@ add_right(struct filter_arg *op, struct filter_arg *arg, char *error_str)
 				return TEP_ERRNO__ILLEGAL_STRING_CMP;
 			}
 
-			op->type = FILTER_ARG_STR;
+			op->type = TEP_FILTER_ARG_STR;
 			op->str.type = op_type;
 			op->str.field = left->field.field;
 			op->str.val = strdup(str);
@@ -632,22 +632,22 @@ rotate_op_right(struct filter_arg *a, struct filter_arg *b)
 static enum tep_errno add_left(struct filter_arg *op, struct filter_arg *arg)
 {
 	switch (op->type) {
-	case FILTER_ARG_EXP:
-		if (arg->type == FILTER_ARG_OP)
+	case TEP_FILTER_ARG_EXP:
+		if (arg->type == TEP_FILTER_ARG_OP)
 			arg = rotate_op_right(arg, op);
 		op->exp.left = arg;
 		break;
 
-	case FILTER_ARG_OP:
+	case TEP_FILTER_ARG_OP:
 		op->op.left = arg;
 		break;
-	case FILTER_ARG_NUM:
-		if (arg->type == FILTER_ARG_OP)
+	case TEP_FILTER_ARG_NUM:
+		if (arg->type == TEP_FILTER_ARG_OP)
 			arg = rotate_op_right(arg, op);
 
 		/* left arg of compares must be a field */
-		if (arg->type != FILTER_ARG_FIELD &&
-		    arg->type != FILTER_ARG_BOOLEAN)
+		if (arg->type != TEP_FILTER_ARG_FIELD &&
+		    arg->type != TEP_FILTER_ARG_BOOLEAN)
 			return TEP_ERRNO__INVALID_ARG_TYPE;
 		op->num.left = arg;
 		break;
@@ -668,10 +668,10 @@ enum op_type {
 static enum op_type process_op(const char *token,
 			       enum tep_filter_op_type *btype,
 			       enum tep_filter_cmp_type *ctype,
-			       enum filter_exp_type *etype)
+			       enum tep_filter_exp_type *etype)
 {
 	*btype = TEP_FILTER_OP_NOT;
-	*etype = FILTER_EXP_NONE;
+	*etype = TEP_FILTER_EXP_NONE;
 	*ctype = TEP_FILTER_CMP_NONE;
 
 	if (strcmp(token, "&&") == 0)
@@ -686,29 +686,29 @@ static enum op_type process_op(const char *token,
 
 	/* Check for value expressions */
 	if (strcmp(token, "+") == 0) {
-		*etype = FILTER_EXP_ADD;
+		*etype = TEP_FILTER_EXP_ADD;
 	} else if (strcmp(token, "-") == 0) {
-		*etype = FILTER_EXP_SUB;
+		*etype = TEP_FILTER_EXP_SUB;
 	} else if (strcmp(token, "*") == 0) {
-		*etype = FILTER_EXP_MUL;
+		*etype = TEP_FILTER_EXP_MUL;
 	} else if (strcmp(token, "/") == 0) {
-		*etype = FILTER_EXP_DIV;
+		*etype = TEP_FILTER_EXP_DIV;
 	} else if (strcmp(token, "%") == 0) {
-		*etype = FILTER_EXP_MOD;
+		*etype = TEP_FILTER_EXP_MOD;
 	} else if (strcmp(token, ">>") == 0) {
-		*etype = FILTER_EXP_RSHIFT;
+		*etype = TEP_FILTER_EXP_RSHIFT;
 	} else if (strcmp(token, "<<") == 0) {
-		*etype = FILTER_EXP_LSHIFT;
+		*etype = TEP_FILTER_EXP_LSHIFT;
 	} else if (strcmp(token, "&") == 0) {
-		*etype = FILTER_EXP_AND;
+		*etype = TEP_FILTER_EXP_AND;
 	} else if (strcmp(token, "|") == 0) {
-		*etype = FILTER_EXP_OR;
+		*etype = TEP_FILTER_EXP_OR;
 	} else if (strcmp(token, "^") == 0) {
-		*etype = FILTER_EXP_XOR;
+		*etype = TEP_FILTER_EXP_XOR;
 	} else if (strcmp(token, "~") == 0)
-		*etype = FILTER_EXP_NOT;
+		*etype = TEP_FILTER_EXP_NOT;
 
-	if (*etype != FILTER_EXP_NONE)
+	if (*etype != TEP_FILTER_EXP_NONE)
 		return OP_EXP;
 
 	/* Check for compares */
@@ -737,20 +737,20 @@ static enum op_type process_op(const char *token,
 static int check_op_done(struct filter_arg *arg)
 {
 	switch (arg->type) {
-	case FILTER_ARG_EXP:
+	case TEP_FILTER_ARG_EXP:
 		return arg->exp.right != NULL;
 
-	case FILTER_ARG_OP:
+	case TEP_FILTER_ARG_OP:
 		return arg->op.right != NULL;
 
-	case FILTER_ARG_NUM:
+	case TEP_FILTER_ARG_NUM:
 		return arg->num.right != NULL;
 
-	case FILTER_ARG_STR:
+	case TEP_FILTER_ARG_STR:
 		/* A string conversion is always done */
 		return 1;
 
-	case FILTER_ARG_BOOLEAN:
+	case TEP_FILTER_ARG_BOOLEAN:
 		/* field not found, is ok */
 		return 1;
 
@@ -772,8 +772,8 @@ reparent_op_arg(struct filter_arg *parent, struct filter_arg *old_child,
 	struct filter_arg *other_child;
 	struct filter_arg **ptr;
 
-	if (parent->type != FILTER_ARG_OP &&
-	    arg->type != FILTER_ARG_OP) {
+	if (parent->type != TEP_FILTER_ARG_OP &&
+	    arg->type != TEP_FILTER_ARG_OP) {
 		show_error(error_str, "can not reparent other than OP");
 		return TEP_ERRNO__REPARENT_NOT_OP;
 	}
@@ -826,16 +826,16 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 	switch (arg->type) {
 
 		/* bad case */
-	case FILTER_ARG_BOOLEAN:
+	case TEP_FILTER_ARG_BOOLEAN:
 		return FILTER_VAL_FALSE + arg->boolean.value;
 
 		/* good cases: */
-	case FILTER_ARG_STR:
-	case FILTER_ARG_VALUE:
-	case FILTER_ARG_FIELD:
+	case TEP_FILTER_ARG_STR:
+	case TEP_FILTER_ARG_VALUE:
+	case TEP_FILTER_ARG_FIELD:
 		return FILTER_VAL_NORM;
 
-	case FILTER_ARG_EXP:
+	case TEP_FILTER_ARG_EXP:
 		lval = test_arg(arg, arg->exp.left, error_str);
 		if (lval != FILTER_VAL_NORM)
 			return lval;
@@ -844,7 +844,7 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 			return rval;
 		return FILTER_VAL_NORM;
 
-	case FILTER_ARG_NUM:
+	case TEP_FILTER_ARG_NUM:
 		lval = test_arg(arg, arg->num.left, error_str);
 		if (lval != FILTER_VAL_NORM)
 			return lval;
@@ -853,7 +853,7 @@ static int test_arg(struct filter_arg *parent, struct filter_arg *arg,
 			return rval;
 		return FILTER_VAL_NORM;
 
-	case FILTER_ARG_OP:
+	case TEP_FILTER_ARG_OP:
 		if (arg->op.type != TEP_FILTER_OP_NOT) {
 			lval = test_arg(arg, arg->op.left, error_str);
 			switch (lval) {
@@ -933,7 +933,7 @@ static int collapse_tree(struct filter_arg *arg,
 		free_arg(arg);
 		arg = allocate_arg();
 		if (arg) {
-			arg->type = FILTER_ARG_BOOLEAN;
+			arg->type = TEP_FILTER_ARG_BOOLEAN;
 			arg->boolean.value = ret == FILTER_VAL_TRUE;
 		} else {
 			show_error(error_str, "Failed to allocate filter arg");
@@ -964,7 +964,7 @@ process_filter(struct tep_event_format *event, struct filter_arg **parg,
 	struct filter_arg *arg = NULL;
 	enum op_type op_type;
 	enum tep_filter_op_type btype;
-	enum filter_exp_type etype;
+	enum tep_filter_exp_type etype;
 	enum tep_filter_cmp_type ctype;
 	enum tep_errno ret;
 
@@ -1210,7 +1210,7 @@ process_event(struct tep_event_format *event, const char *filter_str,
 		if (*parg == NULL)
 			return TEP_ERRNO__MEM_ALLOC_FAILED;
 
-		(*parg)->type = FILTER_ARG_BOOLEAN;
+		(*parg)->type = TEP_FILTER_ARG_BOOLEAN;
 		(*parg)->boolean.value = TEP_FILTER_FALSE;
 	}
 
@@ -1236,7 +1236,7 @@ filter_event(struct event_filter *filter, struct tep_event_format *event,
 		if (arg == NULL)
 			return TEP_ERRNO__MEM_ALLOC_FAILED;
 
-		arg->type = FILTER_ARG_BOOLEAN;
+		arg->type = TEP_FILTER_ARG_BOOLEAN;
 		arg->boolean.value = TEP_FILTER_TRUE;
 	}
 
@@ -1492,7 +1492,7 @@ static int copy_filter_type(struct event_filter *filter,
 		if (arg == NULL)
 			return -1;
 
-		arg->type = FILTER_ARG_BOOLEAN;
+		arg->type = TEP_FILTER_ARG_BOOLEAN;
 		if (strcmp(str, "TRUE") == 0)
 			arg->boolean.value = 1;
 		else
@@ -1568,7 +1568,7 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
 	for (i = 0; i < dest->filters; i++) {
 		filter_type = &dest->event_filters[i];
 		arg = filter_type->filter;
-		if (arg->type != FILTER_ARG_BOOLEAN)
+		if (arg->type != TEP_FILTER_ARG_BOOLEAN)
 			continue;
 		if ((arg->boolean.value && type == FILTER_TRIVIAL_FALSE) ||
 		    (!arg->boolean.value && type == FILTER_TRIVIAL_TRUE))
@@ -1625,7 +1625,7 @@ int tep_filter_clear_trivial(struct event_filter *filter,
 		int *new_ids;
 
 		filter_type = &filter->event_filters[i];
-		if (filter_type->filter->type != FILTER_ARG_BOOLEAN)
+		if (filter_type->filter->type != TEP_FILTER_ARG_BOOLEAN)
 			continue;
 		switch (type) {
 		case FILTER_TRIVIAL_FALSE:
@@ -1682,7 +1682,7 @@ int tep_filter_event_has_trivial(struct event_filter *filter,
 	if (!filter_type)
 		return 0;
 
-	if (filter_type->filter->type != FILTER_ARG_BOOLEAN)
+	if (filter_type->filter->type != TEP_FILTER_ARG_BOOLEAN)
 		return 0;
 
 	switch (type) {
@@ -1767,37 +1767,37 @@ get_exp_value(struct tep_event_format *event, struct filter_arg *arg,
 	}
 
 	switch (arg->exp.type) {
-	case FILTER_EXP_ADD:
+	case TEP_FILTER_EXP_ADD:
 		return lval + rval;
 
-	case FILTER_EXP_SUB:
+	case TEP_FILTER_EXP_SUB:
 		return lval - rval;
 
-	case FILTER_EXP_MUL:
+	case TEP_FILTER_EXP_MUL:
 		return lval * rval;
 
-	case FILTER_EXP_DIV:
+	case TEP_FILTER_EXP_DIV:
 		return lval / rval;
 
-	case FILTER_EXP_MOD:
+	case TEP_FILTER_EXP_MOD:
 		return lval % rval;
 
-	case FILTER_EXP_RSHIFT:
+	case TEP_FILTER_EXP_RSHIFT:
 		return lval >> rval;
 
-	case FILTER_EXP_LSHIFT:
+	case TEP_FILTER_EXP_LSHIFT:
 		return lval << rval;
 
-	case FILTER_EXP_AND:
+	case TEP_FILTER_EXP_AND:
 		return lval & rval;
 
-	case FILTER_EXP_OR:
+	case TEP_FILTER_EXP_OR:
 		return lval | rval;
 
-	case FILTER_EXP_XOR:
+	case TEP_FILTER_EXP_XOR:
 		return lval ^ rval;
 
-	case FILTER_EXP_NOT:
+	case TEP_FILTER_EXP_NOT:
 	default:
 		if (!*err)
 			*err = TEP_ERRNO__INVALID_EXP_TYPE;
@@ -1810,17 +1810,17 @@ get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->type) {
-	case FILTER_ARG_FIELD:
+	case TEP_FILTER_ARG_FIELD:
 		return get_value(event, arg->field.field, record);
 
-	case FILTER_ARG_VALUE:
+	case TEP_FILTER_ARG_VALUE:
 		if (arg->value.type != FILTER_NUMBER) {
 			if (!*err)
 				*err = TEP_ERRNO__NOT_A_NUMBER;
 		}
 		return arg->value.val;
 
-	case FILTER_ARG_EXP:
+	case TEP_FILTER_ARG_EXP:
 		return get_exp_value(event, arg, record, err);
 
 	default:
@@ -1985,22 +1985,22 @@ static int test_filter(struct tep_event_format *event, struct filter_arg *arg,
 	}
 
 	switch (arg->type) {
-	case FILTER_ARG_BOOLEAN:
+	case TEP_FILTER_ARG_BOOLEAN:
 		/* easy case */
 		return arg->boolean.value;
 
-	case FILTER_ARG_OP:
+	case TEP_FILTER_ARG_OP:
 		return test_op(event, arg, record, err);
 
-	case FILTER_ARG_NUM:
+	case TEP_FILTER_ARG_NUM:
 		return test_num(event, arg, record, err);
 
-	case FILTER_ARG_STR:
+	case TEP_FILTER_ARG_STR:
 		return test_str(event, arg, record, err);
 
-	case FILTER_ARG_EXP:
-	case FILTER_ARG_VALUE:
-	case FILTER_ARG_FIELD:
+	case TEP_FILTER_ARG_EXP:
+	case TEP_FILTER_ARG_VALUE:
+	case TEP_FILTER_ARG_FIELD:
 		/*
 		 * Expressions, fields and values evaluate
 		 * to true if they return non zero
@@ -2204,34 +2204,34 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 		goto out;
 
 	switch (arg->exp.type) {
-	case FILTER_EXP_ADD:
+	case TEP_FILTER_EXP_ADD:
 		op = "+";
 		break;
-	case FILTER_EXP_SUB:
+	case TEP_FILTER_EXP_SUB:
 		op = "-";
 		break;
-	case FILTER_EXP_MUL:
+	case TEP_FILTER_EXP_MUL:
 		op = "*";
 		break;
-	case FILTER_EXP_DIV:
+	case TEP_FILTER_EXP_DIV:
 		op = "/";
 		break;
-	case FILTER_EXP_MOD:
+	case TEP_FILTER_EXP_MOD:
 		op = "%";
 		break;
-	case FILTER_EXP_RSHIFT:
+	case TEP_FILTER_EXP_RSHIFT:
 		op = ">>";
 		break;
-	case FILTER_EXP_LSHIFT:
+	case TEP_FILTER_EXP_LSHIFT:
 		op = "<<";
 		break;
-	case FILTER_EXP_AND:
+	case TEP_FILTER_EXP_AND:
 		op = "&";
 		break;
-	case FILTER_EXP_OR:
+	case TEP_FILTER_EXP_OR:
 		op = "|";
 		break;
-	case FILTER_EXP_XOR:
+	case TEP_FILTER_EXP_XOR:
 		op = "^";
 		break;
 	default:
@@ -2334,26 +2334,26 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
 	char *str = NULL;
 
 	switch (arg->type) {
-	case FILTER_ARG_BOOLEAN:
+	case TEP_FILTER_ARG_BOOLEAN:
 		asprintf(&str, arg->boolean.value ? "TRUE" : "FALSE");
 		return str;
 
-	case FILTER_ARG_OP:
+	case TEP_FILTER_ARG_OP:
 		return op_to_str(filter, arg);
 
-	case FILTER_ARG_NUM:
+	case TEP_FILTER_ARG_NUM:
 		return num_to_str(filter, arg);
 
-	case FILTER_ARG_STR:
+	case TEP_FILTER_ARG_STR:
 		return str_to_str(filter, arg);
 
-	case FILTER_ARG_VALUE:
+	case TEP_FILTER_ARG_VALUE:
 		return val_to_str(filter, arg);
 
-	case FILTER_ARG_FIELD:
+	case TEP_FILTER_ARG_FIELD:
 		return field_to_str(filter, arg);
 
-	case FILTER_ARG_EXP:
+	case TEP_FILTER_ARG_EXP:
 		return exp_to_str(filter, arg);
 
 	default:
-- 
2.17.1
