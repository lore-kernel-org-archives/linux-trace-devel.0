Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37339 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728418AbeHJPrt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:49 -0400
Received: by mail-wm0-f66.google.com with SMTP id n11-v6so1875664wmc.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:17:54 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 07/14] tools/lib/traceevent, tools/perf: Rename enum print_arg_type to enum tep_print_arg_type and add prefix TEP_ to all its members.
Date: Fri, 10 Aug 2018 16:17:25 +0300
Message-Id: <20180810131732.24677-8-tz.stoyanov@gmail.com>
In-Reply-To: <20180810131732.24677-1-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames enum print_arg_type to
enum tep_print_arg_type and add prefix TEP_ to all its members.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c            | 248 +++++++++---------
 tools/lib/traceevent/event-parse.h            |  36 +--
 .../util/scripting-engines/trace-event-perl.c |  32 +--
 .../scripting-engines/trace-event-python.c    |  56 ++--
 4 files changed, 186 insertions(+), 186 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 791bb66aabe5..5a6e29c4b5cf 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -815,52 +815,52 @@ static void free_arg(struct tep_print_arg *arg)
 		return;
 
 	switch (arg->type) {
-	case PRINT_ATOM:
+	case TEP_PRINT_ATOM:
 		free(arg->atom.atom);
 		break;
-	case PRINT_FIELD:
+	case TEP_PRINT_FIELD:
 		free(arg->field.name);
 		break;
-	case PRINT_FLAGS:
+	case TEP_PRINT_FLAGS:
 		free_arg(arg->flags.field);
 		free(arg->flags.delim);
 		free_flag_sym(arg->flags.flags);
 		break;
-	case PRINT_SYMBOL:
+	case TEP_PRINT_SYMBOL:
 		free_arg(arg->symbol.field);
 		free_flag_sym(arg->symbol.symbols);
 		break;
-	case PRINT_HEX:
-	case PRINT_HEX_STR:
+	case TEP_PRINT_HEX:
+	case TEP_PRINT_HEX_STR:
 		free_arg(arg->hex.field);
 		free_arg(arg->hex.size);
 		break;
-	case PRINT_INT_ARRAY:
+	case TEP_PRINT_INT_ARRAY:
 		free_arg(arg->int_array.field);
 		free_arg(arg->int_array.count);
 		free_arg(arg->int_array.el_size);
 		break;
-	case PRINT_TYPE:
+	case TEP_PRINT_TYPE:
 		free(arg->typecast.type);
 		free_arg(arg->typecast.item);
 		break;
-	case PRINT_STRING:
-	case PRINT_BSTRING:
+	case TEP_PRINT_STRING:
+	case TEP_PRINT_BSTRING:
 		free(arg->string.string);
 		break;
-	case PRINT_BITMASK:
+	case TEP_PRINT_BITMASK:
 		free(arg->bitmask.bitmask);
 		break;
-	case PRINT_DYNAMIC_ARRAY:
-	case PRINT_DYNAMIC_ARRAY_LEN:
+	case TEP_PRINT_DYNAMIC_ARRAY:
+	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
 		free(arg->dynarray.index);
 		break;
-	case PRINT_OP:
+	case TEP_PRINT_OP:
 		free(arg->op.op);
 		free_arg(arg->op.left);
 		free_arg(arg->op.right);
 		break;
-	case PRINT_FUNC:
+	case TEP_PRINT_FUNC:
 		while (arg->func.args) {
 			farg = arg->func.args;
 			arg->func.args = farg->next;
@@ -868,7 +868,7 @@ static void free_arg(struct tep_print_arg *arg)
 		}
 		break;
 
-	case PRINT_NULL:
+	case TEP_PRINT_NULL:
 	default:
 		break;
 	}
@@ -1742,7 +1742,7 @@ process_cond(struct tep_event_format *event, struct tep_print_arg *top, char **t
 		goto out_free;
 	}
 
-	arg->type = PRINT_OP;
+	arg->type = TEP_PRINT_OP;
 	arg->op.left = left;
 	arg->op.right = right;
 
@@ -1872,7 +1872,7 @@ static int set_op_prio(struct tep_print_arg *arg)
 {
 
 	/* single ops are the greatest */
-	if (!arg->op.left || arg->op.left->type == PRINT_NULL)
+	if (!arg->op.left || arg->op.left->type == TEP_PRINT_NULL)
 		arg->op.prio = 0;
 	else
 		arg->op.prio = get_op_prio(arg->op.op);
@@ -1891,7 +1891,7 @@ process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok
 	/* the op is passed in via tok */
 	token = *tok;
 
-	if (arg->type == PRINT_OP && !arg->op.left) {
+	if (arg->type == TEP_PRINT_OP && !arg->op.left) {
 		/* handle single op */
 		if (token[1]) {
 			do_warning_event(event, "bad op token %s", token);
@@ -1914,7 +1914,7 @@ process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok
 		if (!left)
 			goto out_warn_free;
 
-		left->type = PRINT_NULL;
+		left->type = TEP_PRINT_NULL;
 		arg->op.left = left;
 
 		right = alloc_arg();
@@ -1936,7 +1936,7 @@ process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok
 		/* copy the top arg to the left */
 		*left = *arg;
 
-		arg->type = PRINT_OP;
+		arg->type = TEP_PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = left;
 		arg->op.prio = 0;
@@ -1970,7 +1970,7 @@ process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok
 		/* copy the top arg to the left */
 		*left = *arg;
 
-		arg->type = PRINT_OP;
+		arg->type = TEP_PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = left;
 		arg->op.right = NULL;
@@ -1990,7 +1990,7 @@ process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok
 		    type == TEP_EVENT_DELIM && (strcmp(token, ")") == 0)) {
 			char *new_atom;
 
-			if (left->type != PRINT_ATOM) {
+			if (left->type != TEP_PRINT_ATOM) {
 				do_warning_event(event, "bad pointer type");
 				goto out_free;
 			}
@@ -2020,7 +2020,7 @@ process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok
 			goto out_free;
 		}
 
-		if (right->type == PRINT_OP &&
+		if (right->type == TEP_PRINT_OP &&
 		    get_op_prio(arg->op.op) < get_op_prio(right->op.op)) {
 			struct tep_print_arg tmp;
 
@@ -2044,7 +2044,7 @@ process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok
 
 		*left = *arg;
 
-		arg->type = PRINT_OP;
+		arg->type = TEP_PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = left;
 
@@ -2097,7 +2097,7 @@ process_entry(struct tep_event_format *event __maybe_unused, struct tep_print_ar
 		goto out_free;
 	field = token;
 
-	arg->type = PRINT_FIELD;
+	arg->type = TEP_PRINT_FIELD;
 	arg->field.name = field;
 
 	if (is_flag_field) {
@@ -2253,7 +2253,7 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
 static unsigned long long
 eval_type(unsigned long long val, struct tep_print_arg *arg, int pointer)
 {
-	if (arg->type != PRINT_TYPE) {
+	if (arg->type != TEP_PRINT_TYPE) {
 		do_warning("expected type argument");
 		return 0;
 	}
@@ -2267,16 +2267,16 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 	int ret = 1;
 
 	switch (arg->type) {
-	case PRINT_ATOM:
+	case TEP_PRINT_ATOM:
 		*val = strtoll(arg->atom.atom, NULL, 0);
 		break;
-	case PRINT_TYPE:
+	case TEP_PRINT_TYPE:
 		ret = arg_num_eval(arg->typecast.item, val);
 		if (!ret)
 			break;
 		*val = eval_type(*val, arg, 0);
 		break;
-	case PRINT_OP:
+	case TEP_PRINT_OP:
 		switch (arg->op.op[0]) {
 		case '|':
 			ret = arg_num_eval(arg->op.left, &left);
@@ -2379,7 +2379,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 			break;
 		case '-':
 			/* check for negative */
-			if (arg->op.left->type == PRINT_NULL)
+			if (arg->op.left->type == TEP_PRINT_NULL)
 				left = 0;
 			else
 				ret = arg_num_eval(arg->op.left, &left);
@@ -2391,7 +2391,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 			*val = left - right;
 			break;
 		case '+':
-			if (arg->op.left->type == PRINT_NULL)
+			if (arg->op.left->type == TEP_PRINT_NULL)
 				left = 0;
 			else
 				ret = arg_num_eval(arg->op.left, &left);
@@ -2414,11 +2414,11 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 		}
 		break;
 
-	case PRINT_NULL:
-	case PRINT_FIELD ... PRINT_SYMBOL:
-	case PRINT_STRING:
-	case PRINT_BSTRING:
-	case PRINT_BITMASK:
+	case TEP_PRINT_NULL:
+	case TEP_PRINT_FIELD ... TEP_PRINT_SYMBOL:
+	case TEP_PRINT_STRING:
+	case TEP_PRINT_BSTRING:
+	case TEP_PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		ret = 0;
@@ -2433,21 +2433,21 @@ static char *arg_eval (struct tep_print_arg *arg)
 	static char buf[20];
 
 	switch (arg->type) {
-	case PRINT_ATOM:
+	case TEP_PRINT_ATOM:
 		return arg->atom.atom;
-	case PRINT_TYPE:
+	case TEP_PRINT_TYPE:
 		return arg_eval(arg->typecast.item);
-	case PRINT_OP:
+	case TEP_PRINT_OP:
 		if (!arg_num_eval(arg, &val))
 			break;
 		sprintf(buf, "%lld", val);
 		return buf;
 
-	case PRINT_NULL:
-	case PRINT_FIELD ... PRINT_SYMBOL:
-	case PRINT_STRING:
-	case PRINT_BSTRING:
-	case PRINT_BITMASK:
+	case TEP_PRINT_NULL:
+	case TEP_PRINT_FIELD ... TEP_PRINT_SYMBOL:
+	case TEP_PRINT_STRING:
+	case TEP_PRINT_BSTRING:
+	case TEP_PRINT_BITMASK:
 	default:
 		do_warning("invalid eval type %d", arg->type);
 		break;
@@ -2545,7 +2545,7 @@ process_flags(struct tep_event_format *event, struct tep_print_arg *arg, char **
 	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
-	arg->type = PRINT_FLAGS;
+	arg->type = TEP_PRINT_FLAGS;
 
 	field = alloc_arg();
 	if (!field) {
@@ -2598,7 +2598,7 @@ process_symbols(struct tep_event_format *event, struct tep_print_arg *arg, char
 	char *token = NULL;
 
 	memset(arg, 0, sizeof(*arg));
-	arg->type = PRINT_SYMBOL;
+	arg->type = TEP_PRINT_SYMBOL;
 
 	field = alloc_arg();
 	if (!field) {
@@ -2631,7 +2631,7 @@ process_symbols(struct tep_event_format *event, struct tep_print_arg *arg, char
 
 static enum tep_event_type
 process_hex_common(struct tep_event_format *event, struct tep_print_arg *arg,
-		   char **tok, enum print_arg_type type)
+		   char **tok, enum tep_print_arg_type type)
 {
 	memset(arg, 0, sizeof(*arg));
 	arg->type = type;
@@ -2655,21 +2655,21 @@ process_hex_common(struct tep_event_format *event, struct tep_print_arg *arg,
 static enum tep_event_type
 process_hex(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
-	return process_hex_common(event, arg, tok, PRINT_HEX);
+	return process_hex_common(event, arg, tok, TEP_PRINT_HEX);
 }
 
 static enum tep_event_type
 process_hex_str(struct tep_event_format *event, struct tep_print_arg *arg,
 		char **tok)
 {
-	return process_hex_common(event, arg, tok, PRINT_HEX_STR);
+	return process_hex_common(event, arg, tok, TEP_PRINT_HEX_STR);
 }
 
 static enum tep_event_type
 process_int_array(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
 	memset(arg, 0, sizeof(*arg));
-	arg->type = PRINT_INT_ARRAY;
+	arg->type = TEP_PRINT_INT_ARRAY;
 
 	if (alloc_and_process_delim(event, ",", &arg->int_array.field))
 		goto out;
@@ -2701,7 +2701,7 @@ process_dynamic_array(struct tep_event_format *event, struct tep_print_arg *arg,
 	char *token;
 
 	memset(arg, 0, sizeof(*arg));
-	arg->type = PRINT_DYNAMIC_ARRAY;
+	arg->type = TEP_PRINT_DYNAMIC_ARRAY;
 
 	/*
 	 * The item within the parenthesis is another field that holds
@@ -2768,7 +2768,7 @@ process_dynamic_array_len(struct tep_event_format *event, struct tep_print_arg *
 	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
-	arg->type = PRINT_DYNAMIC_ARRAY_LEN;
+	arg->type = TEP_PRINT_DYNAMIC_ARRAY_LEN;
 
 	/* Find the field */
 	field = tep_find_field(event, token);
@@ -2827,8 +2827,8 @@ process_paren(struct tep_event_format *event, struct tep_print_arg *arg, char **
 		/* make this a typecast and contine */
 
 		/* prevous must be an atom */
-		if (arg->type != PRINT_ATOM) {
-			do_warning_event(event, "previous needed to be PRINT_ATOM");
+		if (arg->type != TEP_PRINT_ATOM) {
+			do_warning_event(event, "previous needed to be TEP_PRINT_ATOM");
 			goto out_free;
 		}
 
@@ -2839,7 +2839,7 @@ process_paren(struct tep_event_format *event, struct tep_print_arg *arg, char **
 			goto out_free;
 		}
 
-		arg->type = PRINT_TYPE;
+		arg->type = TEP_PRINT_TYPE;
 		arg->typecast.type = arg->atom.atom;
 		arg->typecast.item = item_arg;
 		type = process_arg_token(event, item_arg, &token, type);
@@ -2866,7 +2866,7 @@ process_str(struct tep_event_format *event __maybe_unused, struct tep_print_arg
 	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
-	arg->type = PRINT_STRING;
+	arg->type = TEP_PRINT_STRING;
 	arg->string.string = token;
 	arg->string.offset = -1;
 
@@ -2895,7 +2895,7 @@ process_bitmask(struct tep_event_format *event __maybe_unused, struct tep_print_
 	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
 		goto out_free;
 
-	arg->type = PRINT_BITMASK;
+	arg->type = TEP_PRINT_BITMASK;
 	arg->bitmask.bitmask = token;
 	arg->bitmask.offset = -1;
 
@@ -2956,7 +2956,7 @@ process_func_handler(struct tep_event_format *event, struct tep_function_handler
 	char *token;
 	int i;
 
-	arg->type = PRINT_FUNC;
+	arg->type = TEP_PRINT_FUNC;
 	arg->func.func = func;
 
 	*tok = NULL;
@@ -3109,13 +3109,13 @@ process_arg_token(struct tep_event_format *event, struct tep_print_arg *arg,
 			type = read_token_item(&token);
 		}
 
-		arg->type = PRINT_ATOM;
+		arg->type = TEP_PRINT_ATOM;
 		arg->atom.atom = atom;
 		break;
 
 	case TEP_EVENT_DQUOTE:
 	case TEP_EVENT_SQUOTE:
-		arg->type = PRINT_ATOM;
+		arg->type = TEP_PRINT_ATOM;
 		arg->atom.atom = token;
 		type = read_token_item(&token);
 		break;
@@ -3127,7 +3127,7 @@ process_arg_token(struct tep_event_format *event, struct tep_print_arg *arg,
 		}
 	case TEP_EVENT_OP:
 		/* handle single ops */
-		arg->type = PRINT_OP;
+		arg->type = TEP_PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = NULL;
 		type = process_op(event, arg, &token);
@@ -3546,12 +3546,12 @@ eval_num_arg(void *data, int size, struct tep_event_format *event, struct tep_pr
 	unsigned int field_size;
 
 	switch (arg->type) {
-	case PRINT_NULL:
+	case TEP_PRINT_NULL:
 		/* ?? */
 		return 0;
-	case PRINT_ATOM:
+	case TEP_PRINT_ATOM:
 		return strtoull(arg->atom.atom, NULL, 0);
-	case PRINT_FIELD:
+	case TEP_PRINT_FIELD:
 		if (!arg->field.field) {
 			arg->field.field = tep_find_any_field(event, arg->field.name);
 			if (!arg->field.field)
@@ -3562,27 +3562,27 @@ eval_num_arg(void *data, int size, struct tep_event_format *event, struct tep_pr
 		val = tep_read_number(pevent, data + arg->field.field->offset,
 				      arg->field.field->size);
 		break;
-	case PRINT_FLAGS:
-	case PRINT_SYMBOL:
-	case PRINT_INT_ARRAY:
-	case PRINT_HEX:
-	case PRINT_HEX_STR:
+	case TEP_PRINT_FLAGS:
+	case TEP_PRINT_SYMBOL:
+	case TEP_PRINT_INT_ARRAY:
+	case TEP_PRINT_HEX:
+	case TEP_PRINT_HEX_STR:
 		break;
-	case PRINT_TYPE:
+	case TEP_PRINT_TYPE:
 		val = eval_num_arg(data, size, event, arg->typecast.item);
 		return eval_type(val, arg, 0);
-	case PRINT_STRING:
-	case PRINT_BSTRING:
-	case PRINT_BITMASK:
+	case TEP_PRINT_STRING:
+	case TEP_PRINT_BSTRING:
+	case TEP_PRINT_BITMASK:
 		return 0;
-	case PRINT_FUNC: {
+	case TEP_PRINT_FUNC: {
 		struct trace_seq s;
 		trace_seq_init(&s);
 		val = process_defined_func(&s, data, size, event, arg);
 		trace_seq_destroy(&s);
 		return val;
 	}
-	case PRINT_OP:
+	case TEP_PRINT_OP:
 		if (strcmp(arg->op.op, "[") == 0) {
 			/*
 			 * Arrays are special, since we don't want
@@ -3592,7 +3592,7 @@ eval_num_arg(void *data, int size, struct tep_event_format *event, struct tep_pr
 
 			/* handle typecasts */
 			larg = arg->op.left;
-			while (larg->type == PRINT_TYPE) {
+			while (larg->type == TEP_PRINT_TYPE) {
 				if (!typearg)
 					typearg = larg;
 				larg = larg->typecast.item;
@@ -3602,7 +3602,7 @@ eval_num_arg(void *data, int size, struct tep_event_format *event, struct tep_pr
 			field_size = pevent->long_size;
 
 			switch (larg->type) {
-			case PRINT_DYNAMIC_ARRAY:
+			case TEP_PRINT_DYNAMIC_ARRAY:
 				offset = tep_read_number(pevent,
 						   data + larg->dynarray.field->offset,
 						   larg->dynarray.field->size);
@@ -3616,7 +3616,7 @@ eval_num_arg(void *data, int size, struct tep_event_format *event, struct tep_pr
 				offset &= 0xffff;
 				offset += right;
 				break;
-			case PRINT_FIELD:
+			case TEP_PRINT_FIELD:
 				if (!larg->field.field) {
 					larg->field.field =
 						tep_find_any_field(event, larg->field.name);
@@ -3732,7 +3732,7 @@ eval_num_arg(void *data, int size, struct tep_event_format *event, struct tep_pr
 			goto out_warning_op;
 		}
 		break;
-	case PRINT_DYNAMIC_ARRAY_LEN:
+	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
 		offset = tep_read_number(pevent,
 					 data + arg->dynarray.field->offset,
 					 arg->dynarray.field->size);
@@ -3743,7 +3743,7 @@ eval_num_arg(void *data, int size, struct tep_event_format *event, struct tep_pr
 		 */
 		val = (unsigned long long)(offset >> 16);
 		break;
-	case PRINT_DYNAMIC_ARRAY:
+	case TEP_PRINT_DYNAMIC_ARRAY:
 		/* Without [], we pass the address to the dynamic data */
 		offset = tep_read_number(pevent,
 					 data + arg->dynarray.field->offset,
@@ -3890,13 +3890,13 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	int i, len;
 
 	switch (arg->type) {
-	case PRINT_NULL:
+	case TEP_PRINT_NULL:
 		/* ?? */
 		return;
-	case PRINT_ATOM:
+	case TEP_PRINT_ATOM:
 		print_str_to_seq(s, format, len_arg, arg->atom.atom);
 		return;
-	case PRINT_FIELD:
+	case TEP_PRINT_FIELD:
 		field = arg->field.field;
 		if (!field) {
 			field = tep_find_any_field(event, arg->field.name);
@@ -3953,7 +3953,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		print_str_to_seq(s, format, len_arg, str);
 		free(str);
 		break;
-	case PRINT_FLAGS:
+	case TEP_PRINT_FLAGS:
 		val = eval_num_arg(data, size, event, arg->flags.field);
 		print = 0;
 		for (flag = arg->flags.flags; flag; flag = flag->next) {
@@ -3976,7 +3976,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			trace_seq_printf(s, "0x%llx", val);
 		}
 		break;
-	case PRINT_SYMBOL:
+	case TEP_PRINT_SYMBOL:
 		val = eval_num_arg(data, size, event, arg->symbol.field);
 		for (flag = arg->symbol.symbols; flag; flag = flag->next) {
 			fval = eval_flag(flag->value);
@@ -3988,9 +3988,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		if (!flag)
 			trace_seq_printf(s, "0x%llx", val);
 		break;
-	case PRINT_HEX:
-	case PRINT_HEX_STR:
-		if (arg->hex.field->type == PRINT_DYNAMIC_ARRAY) {
+	case TEP_PRINT_HEX:
+	case TEP_PRINT_HEX_STR:
+		if (arg->hex.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
 			offset = tep_read_number(pevent,
 				data + arg->hex.field->dynarray.field->offset,
@@ -4009,17 +4009,17 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		}
 		len = eval_num_arg(data, size, event, arg->hex.size);
 		for (i = 0; i < len; i++) {
-			if (i && arg->type == PRINT_HEX)
+			if (i && arg->type == TEP_PRINT_HEX)
 				trace_seq_putc(s, ' ');
 			trace_seq_printf(s, "%02x", hex[i]);
 		}
 		break;
 
-	case PRINT_INT_ARRAY: {
+	case TEP_PRINT_INT_ARRAY: {
 		void *num;
 		int el_size;
 
-		if (arg->int_array.field->type == PRINT_DYNAMIC_ARRAY) {
+		if (arg->int_array.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
 			struct tep_format_field *field =
 				arg->int_array.field->dynarray.field;
@@ -4063,9 +4063,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		}
 		break;
 	}
-	case PRINT_TYPE:
+	case TEP_PRINT_TYPE:
 		break;
-	case PRINT_STRING: {
+	case TEP_PRINT_STRING: {
 		int str_offset;
 
 		if (arg->string.offset == -1) {
@@ -4079,10 +4079,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
 	}
-	case PRINT_BSTRING:
+	case TEP_PRINT_BSTRING:
 		print_str_to_seq(s, format, len_arg, arg->string.string);
 		break;
-	case PRINT_BITMASK: {
+	case TEP_PRINT_BITMASK: {
 		int bitmask_offset;
 		int bitmask_size;
 
@@ -4099,7 +4099,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 				     data + bitmask_offset, bitmask_size);
 		break;
 	}
-	case PRINT_OP:
+	case TEP_PRINT_OP:
 		/*
 		 * The only op for string should be ? :
 		 */
@@ -4113,7 +4113,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			print_str_arg(s, data, size, event,
 				      format, len_arg, arg->op.right->op.right);
 		break;
-	case PRINT_FUNC:
+	case TEP_PRINT_FUNC:
 		process_defined_func(s, data, size, event, arg);
 		break;
 	default:
@@ -4268,7 +4268,7 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 	arg->next = NULL;
 	next = &arg->next;
 
-	arg->type = PRINT_ATOM;
+	arg->type = TEP_PRINT_ATOM;
 		
 	if (asprintf(&arg->atom.atom, "%lld", ip) < 0)
 		goto out_free;
@@ -4356,7 +4356,7 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 					goto out_free;
 				}
 				arg->next = NULL;
-				arg->type = PRINT_ATOM;
+				arg->type = TEP_PRINT_ATOM;
 				if (asprintf(&arg->atom.atom, "%lld", val) < 0) {
 					free(arg);
 					goto out_free;
@@ -4380,7 +4380,7 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 					goto out_free;
 				}
 				arg->next = NULL;
-				arg->type = PRINT_BSTRING;
+				arg->type = TEP_PRINT_BSTRING;
 				arg->string.string = strdup(bptr);
 				if (!arg->string.string)
 					goto out_free;
@@ -4442,12 +4442,12 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 	unsigned char *buf;
 	const char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
 
-	if (arg->type == PRINT_FUNC) {
+	if (arg->type == TEP_PRINT_FUNC) {
 		process_defined_func(s, data, size, event, arg);
 		return;
 	}
 
-	if (arg->type != PRINT_FIELD) {
+	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d",
 				 arg->type);
 		return;
@@ -4595,12 +4595,12 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 {
 	unsigned char *buf;
 
-	if (arg->type == PRINT_FUNC) {
+	if (arg->type == TEP_PRINT_FUNC) {
 		process_defined_func(s, data, size, event, arg);
 		return 0;
 	}
 
-	if (arg->type != PRINT_FIELD) {
+	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
 		return 0;
 	}
@@ -4641,12 +4641,12 @@ static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
 		rc++;
 	}
 
-	if (arg->type == PRINT_FUNC) {
+	if (arg->type == TEP_PRINT_FUNC) {
 		process_defined_func(s, data, size, event, arg);
 		return rc;
 	}
 
-	if (arg->type != PRINT_FIELD) {
+	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
 		return rc;
 	}
@@ -4699,12 +4699,12 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 		}
 	}
 
-	if (arg->type == PRINT_FUNC) {
+	if (arg->type == TEP_PRINT_FUNC) {
 		process_defined_func(s, data, size, event, arg);
 		return rc;
 	}
 
-	if (arg->type != PRINT_FIELD) {
+	if (arg->type != TEP_PRINT_FIELD) {
 		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
 		return rc;
 	}
@@ -4980,7 +4980,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 				if (isalnum(ptr[1]))
 					ptr++;
 
-				if (arg->type == PRINT_BSTRING) {
+				if (arg->type == TEP_PRINT_BSTRING) {
 					trace_seq_puts(s, arg->string.string);
 					break;
 				}
@@ -5752,16 +5752,16 @@ static void print_args(struct tep_print_arg *args)
 	struct trace_seq s;
 
 	switch (args->type) {
-	case PRINT_NULL:
+	case TEP_PRINT_NULL:
 		printf("null");
 		break;
-	case PRINT_ATOM:
+	case TEP_PRINT_ATOM:
 		printf("%s", args->atom.atom);
 		break;
-	case PRINT_FIELD:
+	case TEP_PRINT_FIELD:
 		printf("REC->%s", args->field.name);
 		break;
-	case PRINT_FLAGS:
+	case TEP_PRINT_FLAGS:
 		printf("__print_flags(");
 		print_args(args->flags.field);
 		printf(", %s, ", args->flags.delim);
@@ -5771,7 +5771,7 @@ static void print_args(struct tep_print_arg *args)
 		trace_seq_destroy(&s);
 		printf(")");
 		break;
-	case PRINT_SYMBOL:
+	case TEP_PRINT_SYMBOL:
 		printf("__print_symbolic(");
 		print_args(args->symbol.field);
 		printf(", ");
@@ -5781,21 +5781,21 @@ static void print_args(struct tep_print_arg *args)
 		trace_seq_destroy(&s);
 		printf(")");
 		break;
-	case PRINT_HEX:
+	case TEP_PRINT_HEX:
 		printf("__print_hex(");
 		print_args(args->hex.field);
 		printf(", ");
 		print_args(args->hex.size);
 		printf(")");
 		break;
-	case PRINT_HEX_STR:
+	case TEP_PRINT_HEX_STR:
 		printf("__print_hex_str(");
 		print_args(args->hex.field);
 		printf(", ");
 		print_args(args->hex.size);
 		printf(")");
 		break;
-	case PRINT_INT_ARRAY:
+	case TEP_PRINT_INT_ARRAY:
 		printf("__print_array(");
 		print_args(args->int_array.field);
 		printf(", ");
@@ -5804,18 +5804,18 @@ static void print_args(struct tep_print_arg *args)
 		print_args(args->int_array.el_size);
 		printf(")");
 		break;
-	case PRINT_STRING:
-	case PRINT_BSTRING:
+	case TEP_PRINT_STRING:
+	case TEP_PRINT_BSTRING:
 		printf("__get_str(%s)", args->string.string);
 		break;
-	case PRINT_BITMASK:
+	case TEP_PRINT_BITMASK:
 		printf("__get_bitmask(%s)", args->bitmask.bitmask);
 		break;
-	case PRINT_TYPE:
+	case TEP_PRINT_TYPE:
 		printf("(%s)", args->typecast.type);
 		print_args(args->typecast.item);
 		break;
-	case PRINT_OP:
+	case TEP_PRINT_OP:
 		if (strcmp(args->op.op, ":") == 0)
 			print_paren = 0;
 		if (print_paren)
@@ -6114,7 +6114,7 @@ enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 				event->flags |= TEP_EVENT_FL_FAILED;
 				return TEP_ERRNO__OLD_FTRACE_ARG_FAILED;
 			}
-			arg->type = PRINT_FIELD;
+			arg->type = TEP_PRINT_FIELD;
 			arg->field.name = strdup(field->name);
 			if (!arg->field.name) {
 				event->flags |= TEP_EVENT_FL_FAILED;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 52156ff5c7ee..b6099eebcc60 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -276,28 +276,28 @@ struct tep_print_arg_func {
 	struct tep_print_arg		*args;
 };
 
-enum print_arg_type {
-	PRINT_NULL,
-	PRINT_ATOM,
-	PRINT_FIELD,
-	PRINT_FLAGS,
-	PRINT_SYMBOL,
-	PRINT_HEX,
-	PRINT_INT_ARRAY,
-	PRINT_TYPE,
-	PRINT_STRING,
-	PRINT_BSTRING,
-	PRINT_DYNAMIC_ARRAY,
-	PRINT_OP,
-	PRINT_FUNC,
-	PRINT_BITMASK,
-	PRINT_DYNAMIC_ARRAY_LEN,
-	PRINT_HEX_STR,
+enum tep_print_arg_type {
+	TEP_PRINT_NULL,
+	TEP_PRINT_ATOM,
+	TEP_PRINT_FIELD,
+	TEP_PRINT_FLAGS,
+	TEP_PRINT_SYMBOL,
+	TEP_PRINT_HEX,
+	TEP_PRINT_INT_ARRAY,
+	TEP_PRINT_TYPE,
+	TEP_PRINT_STRING,
+	TEP_PRINT_BSTRING,
+	TEP_PRINT_DYNAMIC_ARRAY,
+	TEP_PRINT_OP,
+	TEP_PRINT_FUNC,
+	TEP_PRINT_BITMASK,
+	TEP_PRINT_DYNAMIC_ARRAY_LEN,
+	TEP_PRINT_HEX_STR,
 };
 
 struct tep_print_arg {
 	struct tep_print_arg		*next;
-	enum print_arg_type		type;
+	enum tep_print_arg_type		type;
 	union {
 		struct tep_print_arg_atom	atom;
 		struct tep_print_arg_field	field;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 481a1ecb1eaf..89cb887648f9 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -197,54 +197,54 @@ static void define_event_symbols(struct tep_event_format *event,
 		return;
 
 	switch (args->type) {
-	case PRINT_NULL:
+	case TEP_PRINT_NULL:
 		break;
-	case PRINT_ATOM:
+	case TEP_PRINT_ATOM:
 		define_flag_value(ev_name, cur_field_name, "0",
 				  args->atom.atom);
 		zero_flag_atom = 0;
 		break;
-	case PRINT_FIELD:
+	case TEP_PRINT_FIELD:
 		free(cur_field_name);
 		cur_field_name = strdup(args->field.name);
 		break;
-	case PRINT_FLAGS:
+	case TEP_PRINT_FLAGS:
 		define_event_symbols(event, ev_name, args->flags.field);
 		define_flag_field(ev_name, cur_field_name, args->flags.delim);
 		define_flag_values(args->flags.flags, ev_name, cur_field_name);
 		break;
-	case PRINT_SYMBOL:
+	case TEP_PRINT_SYMBOL:
 		define_event_symbols(event, ev_name, args->symbol.field);
 		define_symbolic_field(ev_name, cur_field_name);
 		define_symbolic_values(args->symbol.symbols, ev_name,
 				       cur_field_name);
 		break;
-	case PRINT_HEX:
-	case PRINT_HEX_STR:
+	case TEP_PRINT_HEX:
+	case TEP_PRINT_HEX_STR:
 		define_event_symbols(event, ev_name, args->hex.field);
 		define_event_symbols(event, ev_name, args->hex.size);
 		break;
-	case PRINT_INT_ARRAY:
+	case TEP_PRINT_INT_ARRAY:
 		define_event_symbols(event, ev_name, args->int_array.field);
 		define_event_symbols(event, ev_name, args->int_array.count);
 		define_event_symbols(event, ev_name, args->int_array.el_size);
 		break;
-	case PRINT_BSTRING:
-	case PRINT_DYNAMIC_ARRAY:
-	case PRINT_DYNAMIC_ARRAY_LEN:
-	case PRINT_STRING:
-	case PRINT_BITMASK:
+	case TEP_PRINT_BSTRING:
+	case TEP_PRINT_DYNAMIC_ARRAY:
+	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
+	case TEP_PRINT_STRING:
+	case TEP_PRINT_BITMASK:
 		break;
-	case PRINT_TYPE:
+	case TEP_PRINT_TYPE:
 		define_event_symbols(event, ev_name, args->typecast.item);
 		break;
-	case PRINT_OP:
+	case TEP_PRINT_OP:
 		if (strcmp(args->op.op, ":") == 0)
 			zero_flag_atom = 1;
 		define_event_symbols(event, ev_name, args->op.left);
 		define_event_symbols(event, ev_name, args->op.right);
 		break;
-	case PRINT_FUNC:
+	case TEP_PRINT_FUNC:
 	default:
 		pr_err("Unsupported print arg type\n");
 		/* we should warn... */
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 35dc5f3b581b..69aa93d4ee99 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -193,7 +193,7 @@ static void try_call_object(const char *handler_name, PyObject *args)
 		call_object(handler, args, handler_name);
 }
 
-static void define_value(enum print_arg_type field_type,
+static void define_value(enum tep_print_arg_type field_type,
 			 const char *ev_name,
 			 const char *field_name,
 			 const char *field_value,
@@ -204,7 +204,7 @@ static void define_value(enum print_arg_type field_type,
 	unsigned long long value;
 	unsigned n = 0;
 
-	if (field_type == PRINT_SYMBOL)
+	if (field_type == TEP_PRINT_SYMBOL)
 		handler_name = "define_symbolic_value";
 
 	t = PyTuple_New(4);
@@ -223,7 +223,7 @@ static void define_value(enum print_arg_type field_type,
 	Py_DECREF(t);
 }
 
-static void define_values(enum print_arg_type field_type,
+static void define_values(enum tep_print_arg_type field_type,
 			  struct tep_print_flag_sym *field,
 			  const char *ev_name,
 			  const char *field_name)
@@ -235,7 +235,7 @@ static void define_values(enum print_arg_type field_type,
 		define_values(field_type, field->next, ev_name, field_name);
 }
 
-static void define_field(enum print_arg_type field_type,
+static void define_field(enum tep_print_arg_type field_type,
 			 const char *ev_name,
 			 const char *field_name,
 			 const char *delim)
@@ -244,10 +244,10 @@ static void define_field(enum print_arg_type field_type,
 	PyObject *t;
 	unsigned n = 0;
 
-	if (field_type == PRINT_SYMBOL)
+	if (field_type == TEP_PRINT_SYMBOL)
 		handler_name = "define_symbolic_field";
 
-	if (field_type == PRINT_FLAGS)
+	if (field_type == TEP_PRINT_FLAGS)
 		t = PyTuple_New(3);
 	else
 		t = PyTuple_New(2);
@@ -256,7 +256,7 @@ static void define_field(enum print_arg_type field_type,
 
 	PyTuple_SetItem(t, n++, _PyUnicode_FromString(ev_name));
 	PyTuple_SetItem(t, n++, _PyUnicode_FromString(field_name));
-	if (field_type == PRINT_FLAGS)
+	if (field_type == TEP_PRINT_FLAGS)
 		PyTuple_SetItem(t, n++, _PyUnicode_FromString(delim));
 
 	try_call_object(handler_name, t);
@@ -272,46 +272,46 @@ static void define_event_symbols(struct tep_event_format *event,
 		return;
 
 	switch (args->type) {
-	case PRINT_NULL:
+	case TEP_PRINT_NULL:
 		break;
-	case PRINT_ATOM:
-		define_value(PRINT_FLAGS, ev_name, cur_field_name, "0",
+	case TEP_PRINT_ATOM:
+		define_value(TEP_PRINT_FLAGS, ev_name, cur_field_name, "0",
 			     args->atom.atom);
 		zero_flag_atom = 0;
 		break;
-	case PRINT_FIELD:
+	case TEP_PRINT_FIELD:
 		free(cur_field_name);
 		cur_field_name = strdup(args->field.name);
 		break;
-	case PRINT_FLAGS:
+	case TEP_PRINT_FLAGS:
 		define_event_symbols(event, ev_name, args->flags.field);
-		define_field(PRINT_FLAGS, ev_name, cur_field_name,
+		define_field(TEP_PRINT_FLAGS, ev_name, cur_field_name,
 			     args->flags.delim);
-		define_values(PRINT_FLAGS, args->flags.flags, ev_name,
+		define_values(TEP_PRINT_FLAGS, args->flags.flags, ev_name,
 			      cur_field_name);
 		break;
-	case PRINT_SYMBOL:
+	case TEP_PRINT_SYMBOL:
 		define_event_symbols(event, ev_name, args->symbol.field);
-		define_field(PRINT_SYMBOL, ev_name, cur_field_name, NULL);
-		define_values(PRINT_SYMBOL, args->symbol.symbols, ev_name,
+		define_field(TEP_PRINT_SYMBOL, ev_name, cur_field_name, NULL);
+		define_values(TEP_PRINT_SYMBOL, args->symbol.symbols, ev_name,
 			      cur_field_name);
 		break;
-	case PRINT_HEX:
-	case PRINT_HEX_STR:
+	case TEP_PRINT_HEX:
+	case TEP_PRINT_HEX_STR:
 		define_event_symbols(event, ev_name, args->hex.field);
 		define_event_symbols(event, ev_name, args->hex.size);
 		break;
-	case PRINT_INT_ARRAY:
+	case TEP_PRINT_INT_ARRAY:
 		define_event_symbols(event, ev_name, args->int_array.field);
 		define_event_symbols(event, ev_name, args->int_array.count);
 		define_event_symbols(event, ev_name, args->int_array.el_size);
 		break;
-	case PRINT_STRING:
+	case TEP_PRINT_STRING:
 		break;
-	case PRINT_TYPE:
+	case TEP_PRINT_TYPE:
 		define_event_symbols(event, ev_name, args->typecast.item);
 		break;
-	case PRINT_OP:
+	case TEP_PRINT_OP:
 		if (strcmp(args->op.op, ":") == 0)
 			zero_flag_atom = 1;
 		define_event_symbols(event, ev_name, args->op.left);
@@ -319,11 +319,11 @@ static void define_event_symbols(struct tep_event_format *event,
 		break;
 	default:
 		/* gcc warns for these? */
-	case PRINT_BSTRING:
-	case PRINT_DYNAMIC_ARRAY:
-	case PRINT_DYNAMIC_ARRAY_LEN:
-	case PRINT_FUNC:
-	case PRINT_BITMASK:
+	case TEP_PRINT_BSTRING:
+	case TEP_PRINT_DYNAMIC_ARRAY:
+	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
+	case TEP_PRINT_FUNC:
+	case TEP_PRINT_BITMASK:
 		/* we should warn... */
 		return;
 	}
-- 
2.17.1
