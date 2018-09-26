Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:58268
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726342AbeIZSbx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:31:53 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/16] tools lib traceevent, perf tools: Add prefix tep_ to all print_* structures
Date: Wed, 26 Sep 2018 15:18:23 +0300
Message-Id: <20180926121832.16101-8-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to all
print_* structures

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185723.381753268@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h |  98 ++++++++++-----------
 lib/traceevent/event-parse.c     | 144 +++++++++++++++----------------
 2 files changed, 121 insertions(+), 121 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index dc1f1fa..f1af8d1 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -147,77 +147,77 @@ struct tep_format {
 	struct tep_format_field	*fields;
 };
 
-struct print_arg_atom {
+struct tep_print_arg_atom {
 	char			*atom;
 };
 
-struct print_arg_string {
+struct tep_print_arg_string {
 	char			*string;
 	int			offset;
 };
 
-struct print_arg_bitmask {
+struct tep_print_arg_bitmask {
 	char			*bitmask;
 	int			offset;
 };
 
-struct print_arg_field {
+struct tep_print_arg_field {
 	char			*name;
 	struct tep_format_field	*field;
 };
 
-struct print_flag_sym {
-	struct print_flag_sym	*next;
-	char			*value;
-	char			*str;
+struct tep_print_flag_sym {
+	struct tep_print_flag_sym	*next;
+	char				*value;
+	char				*str;
 };
 
-struct print_arg_typecast {
+struct tep_print_arg_typecast {
 	char 			*type;
-	struct print_arg	*item;
+	struct tep_print_arg	*item;
 };
 
-struct print_arg_flags {
-	struct print_arg	*field;
-	char			*delim;
-	struct print_flag_sym	*flags;
+struct tep_print_arg_flags {
+	struct tep_print_arg		*field;
+	char				*delim;
+	struct tep_print_flag_sym	*flags;
 };
 
-struct print_arg_symbol {
-	struct print_arg	*field;
-	struct print_flag_sym	*symbols;
+struct tep_print_arg_symbol {
+	struct tep_print_arg		*field;
+	struct tep_print_flag_sym	*symbols;
 };
 
-struct print_arg_hex {
-	struct print_arg	*field;
-	struct print_arg	*size;
+struct tep_print_arg_hex {
+	struct tep_print_arg	*field;
+	struct tep_print_arg	*size;
 };
 
-struct print_arg_int_array {
-	struct print_arg	*field;
-	struct print_arg	*count;
-	struct print_arg	*el_size;
+struct tep_print_arg_int_array {
+	struct tep_print_arg	*field;
+	struct tep_print_arg	*count;
+	struct tep_print_arg	*el_size;
 };
 
-struct print_arg_dynarray {
+struct tep_print_arg_dynarray {
 	struct tep_format_field	*field;
-	struct print_arg	*index;
+	struct tep_print_arg	*index;
 };
 
-struct print_arg;
+struct tep_print_arg;
 
-struct print_arg_op {
+struct tep_print_arg_op {
 	char			*op;
 	int			prio;
-	struct print_arg	*left;
-	struct print_arg	*right;
+	struct tep_print_arg	*left;
+	struct tep_print_arg	*right;
 };
 
 struct tep_function_handler;
 
-struct print_arg_func {
+struct tep_print_arg_func {
 	struct tep_function_handler	*func;
-	struct print_arg		*args;
+	struct tep_print_arg		*args;
 };
 
 enum print_arg_type {
@@ -239,28 +239,28 @@ enum print_arg_type {
 	PRINT_HEX_STR,
 };
 
-struct print_arg {
-	struct print_arg		*next;
+struct tep_print_arg {
+	struct tep_print_arg		*next;
 	enum print_arg_type		type;
 	union {
-		struct print_arg_atom		atom;
-		struct print_arg_field		field;
-		struct print_arg_typecast	typecast;
-		struct print_arg_flags		flags;
-		struct print_arg_symbol		symbol;
-		struct print_arg_hex		hex;
-		struct print_arg_int_array	int_array;
-		struct print_arg_func		func;
-		struct print_arg_string		string;
-		struct print_arg_bitmask	bitmask;
-		struct print_arg_op		op;
-		struct print_arg_dynarray	dynarray;
+		struct tep_print_arg_atom	atom;
+		struct tep_print_arg_field	field;
+		struct tep_print_arg_typecast	typecast;
+		struct tep_print_arg_flags	flags;
+		struct tep_print_arg_symbol	symbol;
+		struct tep_print_arg_hex	hex;
+		struct tep_print_arg_int_array	int_array;
+		struct tep_print_arg_func	func;
+		struct tep_print_arg_string	string;
+		struct tep_print_arg_bitmask	bitmask;
+		struct tep_print_arg_op		op;
+		struct tep_print_arg_dynarray	dynarray;
 	};
 };
 
-struct print_fmt {
+struct tep_print_fmt {
 	char			*format;
-	struct print_arg	*args;
+	struct tep_print_arg	*args;
 };
 
 struct tep_event_format {
@@ -269,7 +269,7 @@ struct tep_event_format {
 	int			id;
 	int			flags;
 	struct tep_format	format;
-	struct print_fmt	print_fmt;
+	struct tep_print_fmt	print_fmt;
 	char			*system;
 	tep_event_handler_func	handler;
 	void			*context;
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index a651c33..3beab91 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -95,7 +95,7 @@ struct tep_function_handler {
 
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct tep_event_format *event, struct print_arg *arg);
+		     struct tep_event_format *event, struct tep_print_arg *arg);
 
 static void free_func_handle(struct tep_function_handler *func);
 
@@ -118,9 +118,9 @@ void breakpoint(void)
 	x++;
 }
 
-struct print_arg *alloc_arg(void)
+struct tep_print_arg *alloc_arg(void)
 {
-	return calloc(1, sizeof(struct print_arg));
+	return calloc(1, sizeof(struct tep_print_arg));
 }
 
 struct cmdline {
@@ -781,9 +781,9 @@ static int event_item_type(enum tep_event_type type)
 	}
 }
 
-static void free_flag_sym(struct print_flag_sym *fsym)
+static void free_flag_sym(struct tep_print_flag_sym *fsym)
 {
-	struct print_flag_sym *next;
+	struct tep_print_flag_sym *next;
 
 	while (fsym) {
 		next = fsym->next;
@@ -794,9 +794,9 @@ static void free_flag_sym(struct print_flag_sym *fsym)
 	}
 }
 
-static void free_arg(struct print_arg *arg)
+static void free_arg(struct tep_print_arg *arg)
 {
-	struct print_arg *farg;
+	struct tep_print_arg *farg;
 
 	if (!arg)
 		return;
@@ -1674,11 +1674,11 @@ static int event_read_format(struct tep_event_format *event)
 }
 
 static enum tep_event_type
-process_arg_token(struct tep_event_format *event, struct print_arg *arg,
+process_arg_token(struct tep_event_format *event, struct tep_print_arg *arg,
 		  char **tok, enum tep_event_type type);
 
 static enum tep_event_type
-process_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_arg(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
 	enum tep_event_type type;
 	char *token;
@@ -1690,14 +1690,14 @@ process_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum tep_event_type
-process_op(struct tep_event_format *event, struct print_arg *arg, char **tok);
+process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok);
 
 /*
  * For __print_symbolic() and __print_flags, we need to completely
  * evaluate the first argument, which defines what to print next.
  */
 static enum tep_event_type
-process_field_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_field_arg(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
 	enum tep_event_type type;
 
@@ -1711,9 +1711,9 @@ process_field_arg(struct tep_event_format *event, struct print_arg *arg, char **
 }
 
 static enum tep_event_type
-process_cond(struct tep_event_format *event, struct print_arg *top, char **tok)
+process_cond(struct tep_event_format *event, struct tep_print_arg *top, char **tok)
 {
-	struct print_arg *arg, *left, *right;
+	struct tep_print_arg *arg, *left, *right;
 	enum tep_event_type type;
 	char *token = NULL;
 
@@ -1767,9 +1767,9 @@ out_free:
 }
 
 static enum tep_event_type
-process_array(struct tep_event_format *event, struct print_arg *top, char **tok)
+process_array(struct tep_event_format *event, struct tep_print_arg *top, char **tok)
 {
-	struct print_arg *arg;
+	struct tep_print_arg *arg;
 	enum tep_event_type type;
 	char *token = NULL;
 
@@ -1855,7 +1855,7 @@ static int get_op_prio(char *op)
 	}
 }
 
-static int set_op_prio(struct print_arg *arg)
+static int set_op_prio(struct tep_print_arg *arg)
 {
 
 	/* single ops are the greatest */
@@ -1869,9 +1869,9 @@ static int set_op_prio(struct print_arg *arg)
 
 /* Note, *tok does not get freed, but will most likely be saved */
 static enum tep_event_type
-process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_op(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
-	struct print_arg *left, *right = NULL;
+	struct tep_print_arg *left, *right = NULL;
 	enum tep_event_type type;
 	char *token;
 
@@ -2009,7 +2009,7 @@ process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 
 		if (right->type == PRINT_OP &&
 		    get_op_prio(arg->op.op) < get_op_prio(right->op.op)) {
-			struct print_arg tmp;
+			struct tep_print_arg tmp;
 
 			/* rotate ops according to the priority */
 			arg->op.right = right->op.left;
@@ -2070,7 +2070,7 @@ out_free:
 }
 
 static enum tep_event_type
-process_entry(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
+process_entry(struct tep_event_format *event __maybe_unused, struct tep_print_arg *arg,
 	      char **tok)
 {
 	enum tep_event_type type;
@@ -2110,9 +2110,9 @@ process_entry(struct tep_event_format *event __maybe_unused, struct print_arg *a
 }
 
 static int alloc_and_process_delim(struct tep_event_format *event, char *next_token,
-				   struct print_arg **print_arg)
+				   struct tep_print_arg **print_arg)
 {
-	struct print_arg *field;
+	struct tep_print_arg *field;
 	enum tep_event_type type;
 	char *token;
 	int ret = 0;
@@ -2141,7 +2141,7 @@ out_free_token:
 	return ret;
 }
 
-static char *arg_eval (struct print_arg *arg);
+static char *arg_eval (struct tep_print_arg *arg);
 
 static unsigned long long
 eval_type_str(unsigned long long val, const char *type, int pointer)
@@ -2238,7 +2238,7 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
  * Try to figure out the type.
  */
 static unsigned long long
-eval_type(unsigned long long val, struct print_arg *arg, int pointer)
+eval_type(unsigned long long val, struct tep_print_arg *arg, int pointer)
 {
 	if (arg->type != PRINT_TYPE) {
 		do_warning("expected type argument");
@@ -2248,7 +2248,7 @@ eval_type(unsigned long long val, struct print_arg *arg, int pointer)
 	return eval_type_str(val, arg->typecast.type, pointer);
 }
 
-static int arg_num_eval(struct print_arg *arg, long long *val)
+static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 {
 	long long left, right;
 	int ret = 1;
@@ -2414,7 +2414,7 @@ static int arg_num_eval(struct print_arg *arg, long long *val)
 	return ret;
 }
 
-static char *arg_eval (struct print_arg *arg)
+static char *arg_eval (struct tep_print_arg *arg)
 {
 	long long val;
 	static char buf[20];
@@ -2444,11 +2444,11 @@ static char *arg_eval (struct print_arg *arg)
 }
 
 static enum tep_event_type
-process_fields(struct tep_event_format *event, struct print_flag_sym **list, char **tok)
+process_fields(struct tep_event_format *event, struct tep_print_flag_sym **list, char **tok)
 {
 	enum tep_event_type type;
-	struct print_arg *arg = NULL;
-	struct print_flag_sym *field;
+	struct tep_print_arg *arg = NULL;
+	struct tep_print_flag_sym *field;
 	char *token = *tok;
 	char *value;
 
@@ -2525,9 +2525,9 @@ out_free:
 }
 
 static enum tep_event_type
-process_flags(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_flags(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
-	struct print_arg *field;
+	struct tep_print_arg *field;
 	enum tep_event_type type;
 	char *token = NULL;
 
@@ -2578,9 +2578,9 @@ out_free:
 }
 
 static enum tep_event_type
-process_symbols(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_symbols(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
-	struct print_arg *field;
+	struct tep_print_arg *field;
 	enum tep_event_type type;
 	char *token = NULL;
 
@@ -2617,7 +2617,7 @@ out_free:
 }
 
 static enum tep_event_type
-process_hex_common(struct tep_event_format *event, struct print_arg *arg,
+process_hex_common(struct tep_event_format *event, struct tep_print_arg *arg,
 		   char **tok, enum print_arg_type type)
 {
 	memset(arg, 0, sizeof(*arg));
@@ -2640,20 +2640,20 @@ out:
 }
 
 static enum tep_event_type
-process_hex(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_hex(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
 	return process_hex_common(event, arg, tok, PRINT_HEX);
 }
 
 static enum tep_event_type
-process_hex_str(struct tep_event_format *event, struct print_arg *arg,
+process_hex_str(struct tep_event_format *event, struct tep_print_arg *arg,
 		char **tok)
 {
 	return process_hex_common(event, arg, tok, PRINT_HEX_STR);
 }
 
 static enum tep_event_type
-process_int_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_int_array(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_INT_ARRAY;
@@ -2681,7 +2681,7 @@ out:
 }
 
 static enum tep_event_type
-process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_dynamic_array(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
 	struct tep_format_field *field;
 	enum tep_event_type type;
@@ -2745,7 +2745,7 @@ process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, cha
 }
 
 static enum tep_event_type
-process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
+process_dynamic_array_len(struct tep_event_format *event, struct tep_print_arg *arg,
 			  char **tok)
 {
 	struct tep_format_field *field;
@@ -2781,9 +2781,9 @@ process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
 }
 
 static enum tep_event_type
-process_paren(struct tep_event_format *event, struct print_arg *arg, char **tok)
+process_paren(struct tep_event_format *event, struct tep_print_arg *arg, char **tok)
 {
-	struct print_arg *item_arg;
+	struct tep_print_arg *item_arg;
 	enum tep_event_type type;
 	char *token;
 
@@ -2844,7 +2844,7 @@ process_paren(struct tep_event_format *event, struct print_arg *arg, char **tok)
 
 
 static enum tep_event_type
-process_str(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
+process_str(struct tep_event_format *event __maybe_unused, struct tep_print_arg *arg,
 	    char **tok)
 {
 	enum tep_event_type type;
@@ -2873,7 +2873,7 @@ process_str(struct tep_event_format *event __maybe_unused, struct print_arg *arg
 }
 
 static enum tep_event_type
-process_bitmask(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
+process_bitmask(struct tep_event_format *event __maybe_unused, struct tep_print_arg *arg,
 		char **tok)
 {
 	enum tep_event_type type;
@@ -2935,10 +2935,10 @@ static void remove_func_handler(struct tep_handle *pevent, char *func_name)
 
 static enum tep_event_type
 process_func_handler(struct tep_event_format *event, struct tep_function_handler *func,
-		     struct print_arg *arg, char **tok)
+		     struct tep_print_arg *arg, char **tok)
 {
-	struct print_arg **next_arg;
-	struct print_arg *farg;
+	struct tep_print_arg **next_arg;
+	struct tep_print_arg *farg;
 	enum tep_event_type type;
 	char *token;
 	int i;
@@ -2992,7 +2992,7 @@ err:
 }
 
 static enum tep_event_type
-process_function(struct tep_event_format *event, struct print_arg *arg,
+process_function(struct tep_event_format *event, struct tep_print_arg *arg,
 		 char *token, char **tok)
 {
 	struct tep_function_handler *func;
@@ -3048,7 +3048,7 @@ process_function(struct tep_event_format *event, struct print_arg *arg,
 }
 
 static enum tep_event_type
-process_arg_token(struct tep_event_format *event, struct print_arg *arg,
+process_arg_token(struct tep_event_format *event, struct tep_print_arg *arg,
 		  char **tok, enum tep_event_type type)
 {
 	char *token;
@@ -3136,10 +3136,10 @@ process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 	return type;
 }
 
-static int event_read_print_args(struct tep_event_format *event, struct print_arg **list)
+static int event_read_print_args(struct tep_event_format *event, struct tep_print_arg **list)
 {
 	enum tep_event_type type = TEP_EVENT_ERROR;
-	struct print_arg *arg;
+	struct tep_print_arg *arg;
 	char *token;
 	int args = 0;
 
@@ -3522,13 +3522,13 @@ tep_find_event_by_name(struct tep_handle *pevent,
 }
 
 static unsigned long long
-eval_num_arg(void *data, int size, struct tep_event_format *event, struct print_arg *arg)
+eval_num_arg(void *data, int size, struct tep_event_format *event, struct tep_print_arg *arg)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long val = 0;
 	unsigned long long left, right;
-	struct print_arg *typearg = NULL;
-	struct print_arg *larg;
+	struct tep_print_arg *typearg = NULL;
+	struct tep_print_arg *larg;
 	unsigned long offset;
 	unsigned int field_size;
 
@@ -3863,10 +3863,10 @@ static void print_bitmask_to_seq(struct tep_handle *pevent,
 
 static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct tep_event_format *event, const char *format,
-			  int len_arg, struct print_arg *arg)
+			  int len_arg, struct tep_print_arg *arg)
 {
 	struct tep_handle *pevent = event->pevent;
-	struct print_flag_sym *flag;
+	struct tep_print_flag_sym *flag;
 	struct tep_format_field *field;
 	struct printk_map *printk;
 	long long val, fval;
@@ -4117,13 +4117,13 @@ out_warning_field:
 
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct tep_event_format *event, struct print_arg *arg)
+		     struct tep_event_format *event, struct tep_print_arg *arg)
 {
 	struct tep_function_handler *func_handle = arg->func.func;
 	struct func_params *param;
 	unsigned long long *args;
 	unsigned long long ret;
-	struct print_arg *farg;
+	struct tep_print_arg *farg;
 	struct trace_seq str;
 	struct save_str {
 		struct save_str *next;
@@ -4200,9 +4200,9 @@ out_free:
 	return ret;
 }
 
-static void free_args(struct print_arg *args)
+static void free_args(struct tep_print_arg *args)
 {
-	struct print_arg *next;
+	struct tep_print_arg *next;
 
 	while (args) {
 		next = args->next;
@@ -4212,11 +4212,11 @@ static void free_args(struct print_arg *args)
 	}
 }
 
-static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event_format *event)
+static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
 	struct tep_format_field *field, *ip_field;
-	struct print_arg *args, *arg, **next;
+	struct tep_print_arg *args, *arg, **next;
 	unsigned long long ip, val;
 	char *ptr;
 	void *bptr;
@@ -4424,7 +4424,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 }
 
 static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
-			  struct tep_event_format *event, struct print_arg *arg)
+			  struct tep_event_format *event, struct tep_print_arg *arg)
 {
 	unsigned char *buf;
 	const char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
@@ -4578,7 +4578,7 @@ static void print_ip6_addr(struct trace_seq *s, char i, unsigned char *buf)
  */
 static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 			  void *data, int size, struct tep_event_format *event,
-			  struct print_arg *arg)
+			  struct tep_print_arg *arg)
 {
 	unsigned char *buf;
 
@@ -4615,7 +4615,7 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 
 static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
 			  void *data, int size, struct tep_event_format *event,
-			  struct print_arg *arg)
+			  struct tep_print_arg *arg)
 {
 	char have_c = 0;
 	unsigned char *buf;
@@ -4665,7 +4665,7 @@ static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
 
 static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 			  void *data, int size, struct tep_event_format *event,
-			  struct print_arg *arg)
+			  struct tep_print_arg *arg)
 {
 	char have_c = 0, have_p = 0;
 	unsigned char *buf;
@@ -4747,7 +4747,7 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 
 static int print_ip_arg(struct trace_seq *s, const char *ptr,
 			void *data, int size, struct tep_event_format *event,
-			struct print_arg *arg)
+			struct tep_print_arg *arg)
 {
 	char i = *ptr;  /* 'i' or 'I' */
 	char ver;
@@ -4868,9 +4868,9 @@ void tep_print_fields(struct trace_seq *s, void *data,
 static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
-	struct print_fmt *print_fmt = &event->print_fmt;
-	struct print_arg *arg = print_fmt->args;
-	struct print_arg *args = NULL;
+	struct tep_print_fmt *print_fmt = &event->print_fmt;
+	struct tep_print_arg *arg = print_fmt->args;
+	struct tep_print_arg *args = NULL;
 	const char *ptr = print_fmt->format;
 	unsigned long long val;
 	struct func_map *func;
@@ -5723,7 +5723,7 @@ struct tep_format_field **tep_event_fields(struct tep_event_format *event)
 				event->format.fields);
 }
 
-static void print_fields(struct trace_seq *s, struct print_flag_sym *field)
+static void print_fields(struct trace_seq *s, struct tep_print_flag_sym *field)
 {
 	trace_seq_printf(s, "{ %s, %s }", field->value, field->str);
 	if (field->next) {
@@ -5733,7 +5733,7 @@ static void print_fields(struct trace_seq *s, struct print_flag_sym *field)
 }
 
 /* for debugging */
-static void print_args(struct print_arg *args)
+static void print_args(struct tep_print_arg *args)
 {
 	int print_paren = 1;
 	struct trace_seq s;
@@ -6091,7 +6091,7 @@ enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 
 	if (!ret && (event->flags & TEP_EVENT_FL_ISFTRACE)) {
 		struct tep_format_field *field;
-		struct print_arg *arg, **list;
+		struct tep_print_arg *arg, **list;
 
 		/* old ftrace had no args */
 		list = &event->print_fmt.args;
-- 
2.17.1
