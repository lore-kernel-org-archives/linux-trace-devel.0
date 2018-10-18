Return-Path: <SRS0=VoGV=M6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam01on0045.outbound.protection.outlook.com ([104.47.32.45]:4020
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726043AbeJRUGS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Oct 2018 16:06:18 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/3] tools/lib/traceevent, tools/perf: Rename struct
 tep_event_format to struct tep_event
Date: Thu, 18 Oct 2018 12:04:15 +0000
Message-ID: <20181018120404.3533-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. This renames struct tep_event_format to struct tep_event,
which describes more closely the purpose of the struct.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c        |   2 +-
 tools/lib/traceevent/event-parse-local.h      |   6 +-
 tools/lib/traceevent/event-parse.c            | 188 +++++++++---------
 tools/lib/traceevent/event-parse.h            |  62 +++---
 tools/lib/traceevent/parse-filter.c           |  42 ++--
 tools/lib/traceevent/plugin_function.c        |   2 +-
 tools/lib/traceevent/plugin_hrtimer.c         |   4 +-
 tools/lib/traceevent/plugin_kmem.c            |   2 +-
 tools/lib/traceevent/plugin_kvm.c             |  14 +-
 tools/lib/traceevent/plugin_mac80211.c        |   4 +-
 tools/lib/traceevent/plugin_sched_switch.c    |   4 +-
 tools/perf/builtin-trace.c                    |   2 +-
 tools/perf/util/evsel.h                       |   4 +-
 tools/perf/util/header.c                      |   2 +-
 tools/perf/util/python.c                      |   4 +-
 .../util/scripting-engines/trace-event-perl.c |   6 +-
 .../scripting-engines/trace-event-python.c    |   8 +-
 tools/perf/util/trace-event-parse.c           |  16 +-
 tools/perf/util/trace-event.c                 |   8 +-
 tools/perf/util/trace-event.h                 |  16 +-
 20 files changed, 198 insertions(+), 198 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index e4d7b15f64ca..52188921cfe3 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -15,7 +15,7 @@
  * This returns pointer to the first element of the events array
  * If @pevent is NULL, NULL is returned.
  */
-struct tep_event_format *tep_get_first_event(struct tep_handle *tep)
+struct tep_event *tep_get_first_event(struct tep_handle *tep)
 {
 	if (tep && tep->events)
 		return tep->events[0];
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index b9bddde577f8..94746efef433 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
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
@@ -84,7 +84,7 @@ struct tep_handle {
 	struct tep_function_handler *func_handlers;
=20
 	/* cache */
-	struct tep_event_format *last_event;
+	struct tep_event *last_event;
=20
 	char *trace_clock;
 };
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index aa26d0e7c074..d2aac1461769 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -111,7 +111,7 @@ struct tep_function_handler {
=20
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct tep_event_format *event, struct tep_print_arg *arg);
+		     struct tep_event *event, struct tep_print_arg *arg);
=20
 static void free_func_handle(struct tep_function_handler *func);
=20
@@ -754,16 +754,16 @@ void tep_print_printk(struct tep_handle *pevent)
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
-						  (pevent->nr_events + 1));
+	struct tep_event **events =3D realloc(pevent->events, sizeof(event) *
+					    (pevent->nr_events + 1));
 	if (!events)
 		return -1;
=20
@@ -1370,7 +1370,7 @@ static unsigned int type_size(const char *name)
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
@@ -1657,7 +1657,7 @@ static int event_read_fields(struct tep_event_format =
*event, struct tep_format_f
 	return -1;
 }
=20
-static int event_read_format(struct tep_event_format *event)
+static int event_read_format(struct tep_event *event)
 {
 	char *token;
 	int ret;
@@ -1690,11 +1690,11 @@ static int event_read_format(struct tep_event_forma=
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
@@ -1706,14 +1706,14 @@ process_arg(struct tep_event_format *event, struct =
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
@@ -1727,7 +1727,7 @@ process_field_arg(struct tep_event_format *event, str=
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
@@ -1783,7 +1783,7 @@ process_cond(struct tep_event_format *event, struct t=
ep_print_arg *top, char **t
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
@@ -1885,7 +1885,7 @@ static int set_op_prio(struct tep_print_arg *arg)
=20
 /* Note, *tok does not get freed, but will most likely be saved */
 static enum tep_event_type
-process_op(struct tep_event_format *event, struct tep_print_arg *arg, char=
 **tok)
+process_op(struct tep_event *event, struct tep_print_arg *arg, char **tok)
 {
 	struct tep_print_arg *left, *right =3D NULL;
 	enum tep_event_type type;
@@ -2086,7 +2086,7 @@ process_op(struct tep_event_format *event, struct tep=
_print_arg *arg, char **tok
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
@@ -2125,7 +2125,7 @@ process_entry(struct tep_event_format *event __maybe_=
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
@@ -2460,7 +2460,7 @@ static char *arg_eval (struct tep_print_arg *arg)
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
@@ -2541,7 +2541,7 @@ process_fields(struct tep_event_format *event, struct=
 tep_print_flag_sym **list,
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
@@ -2594,7 +2594,7 @@ process_flags(struct tep_event_format *event, struct =
tep_print_arg *arg, char **
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
@@ -2633,7 +2633,7 @@ process_symbols(struct tep_event_format *event, struc=
t tep_print_arg *arg, char
 }
=20
 static enum tep_event_type
-process_hex_common(struct tep_event_format *event, struct tep_print_arg *a=
rg,
+process_hex_common(struct tep_event *event, struct tep_print_arg *arg,
 		   char **tok, enum tep_print_arg_type type)
 {
 	memset(arg, 0, sizeof(*arg));
@@ -2656,20 +2656,20 @@ process_hex_common(struct tep_event_format *event, =
struct tep_print_arg *arg,
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
@@ -2697,7 +2697,7 @@ process_int_array(struct tep_event_format *event, str=
uct tep_print_arg *arg, cha
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
@@ -2761,7 +2761,7 @@ process_dynamic_array(struct tep_event_format *event,=
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
@@ -2797,7 +2797,7 @@ process_dynamic_array_len(struct tep_event_format *ev=
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
@@ -2860,7 +2860,7 @@ process_paren(struct tep_event_format *event, struct =
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
@@ -2889,7 +2889,7 @@ process_str(struct tep_event_format *event __maybe_un=
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
@@ -2950,7 +2950,7 @@ static void remove_func_handler(struct tep_handle *pe=
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
@@ -3008,7 +3008,7 @@ process_func_handler(struct tep_event_format *event, =
struct tep_function_handler
 }
=20
 static enum tep_event_type
-process_function(struct tep_event_format *event, struct tep_print_arg *arg=
,
+process_function(struct tep_event *event, struct tep_print_arg *arg,
 		 char *token, char **tok)
 {
 	struct tep_function_handler *func;
@@ -3064,7 +3064,7 @@ process_function(struct tep_event_format *event, stru=
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
@@ -3152,7 +3152,7 @@ process_arg_token(struct tep_event_format *event, str=
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
@@ -3210,7 +3210,7 @@ static int event_read_print_args(struct tep_event_for=
mat *event, struct tep_prin
 	return args;
 }
=20
-static int event_read_print(struct tep_event_format *event)
+static int event_read_print(struct tep_event *event)
 {
 	enum tep_event_type type;
 	char *token;
@@ -3276,7 +3276,7 @@ static int event_read_print(struct tep_event_format *=
event)
  * This only searchs the common fields and not all field.
  */
 struct tep_format_field *
-tep_find_common_field(struct tep_event_format *event, const char *name)
+tep_find_common_field(struct tep_event *event, const char *name)
 {
 	struct tep_format_field *format;
=20
@@ -3298,7 +3298,7 @@ tep_find_common_field(struct tep_event_format *event,=
 const char *name)
  * This does not search common fields.
  */
 struct tep_format_field *
-tep_find_field(struct tep_event_format *event, const char *name)
+tep_find_field(struct tep_event *event, const char *name)
 {
 	struct tep_format_field *format;
=20
@@ -3321,7 +3321,7 @@ tep_find_field(struct tep_event_format *event, const =
char *name)
  * the non-common ones if a common one was not found.
  */
 struct tep_format_field *
-tep_find_any_field(struct tep_event_format *event, const char *name)
+tep_find_any_field(struct tep_event *event, const char *name)
 {
 	struct tep_format_field *format;
=20
@@ -3390,7 +3390,7 @@ int tep_read_number_field(struct tep_format_field *fi=
eld, const void *data,
 static int get_common_info(struct tep_handle *pevent,
 			   const char *type, int *offset, int *size)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_format_field *field;
=20
 	/*
@@ -3477,11 +3477,11 @@ static int events_id_cmp(const void *a, const void =
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
@@ -3509,11 +3509,11 @@ struct tep_event_format *tep_find_event(struct tep_=
handle *pevent, int id)
  * This returns an event with a given @name and under the system
  * @sys. If @sys is NULL the first event with @name is returned.
  */
-struct tep_event_format *
+struct tep_event *
 tep_find_event_by_name(struct tep_handle *pevent,
 		       const char *sys, const char *name)
 {
-	struct tep_event_format *event =3D NULL;
+	struct tep_event *event =3D NULL;
 	int i;
=20
 	if (pevent->last_event &&
@@ -3538,7 +3538,7 @@ tep_find_event_by_name(struct tep_handle *pevent,
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
@@ -3878,7 +3878,7 @@ static void print_bitmask_to_seq(struct tep_handle *p=
event,
 }
=20
 static void print_str_arg(struct trace_seq *s, void *data, int size,
-			  struct tep_event_format *event, const char *format,
+			  struct tep_event *event, const char *format,
 			  int len_arg, struct tep_print_arg *arg)
 {
 	struct tep_handle *pevent =3D event->pevent;
@@ -4133,7 +4133,7 @@ static void print_str_arg(struct trace_seq *s, void *=
data, int size,
=20
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct tep_event_format *event, struct tep_print_arg *arg)
+		     struct tep_event *event, struct tep_print_arg *arg)
 {
 	struct tep_function_handler *func_handle =3D arg->func.func;
 	struct func_params *param;
@@ -4228,7 +4228,7 @@ static void free_args(struct tep_print_arg *args)
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
@@ -4405,7 +4405,7 @@ static struct tep_print_arg *make_bprint_args(char *f=
mt, void *data, int size, s
=20
 static char *
 get_bprint_format(void *data, int size __maybe_unused,
-		  struct tep_event_format *event)
+		  struct tep_event *event)
 {
 	struct tep_handle *pevent =3D event->pevent;
 	unsigned long long addr;
@@ -4440,7 +4440,7 @@ get_bprint_format(void *data, int size __maybe_unused=
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
@@ -4593,7 +4593,7 @@ static void print_ip6_addr(struct trace_seq *s, char =
i, unsigned char *buf)
  * %pISpc print an IP address based on sockaddr; p adds port.
  */
 static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct tep_event_format *event,
+			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
 {
 	unsigned char *buf;
@@ -4630,7 +4630,7 @@ static int print_ipv4_arg(struct trace_seq *s, const =
char *ptr, char i,
 }
=20
 static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct tep_event_format *event,
+			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
 {
 	char have_c =3D 0;
@@ -4680,7 +4680,7 @@ static int print_ipv6_arg(struct trace_seq *s, const =
char *ptr, char i,
 }
=20
 static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct tep_event_format *event,
+			  void *data, int size, struct tep_event *event,
 			  struct tep_print_arg *arg)
 {
 	char have_c =3D 0, have_p =3D 0;
@@ -4762,7 +4762,7 @@ static int print_ipsa_arg(struct trace_seq *s, const =
char *ptr, char i,
 }
=20
 static int print_ip_arg(struct trace_seq *s, const char *ptr,
-			void *data, int size, struct tep_event_format *event,
+			void *data, int size, struct tep_event *event,
 			struct tep_print_arg *arg)
 {
 	char i =3D *ptr;  /* 'i' or 'I' */
@@ -4869,7 +4869,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 }
=20
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct tep_event_format *event)
+		      int size __maybe_unused, struct tep_event *event)
 {
 	struct tep_format_field *field;
=20
@@ -4881,7 +4881,7 @@ void tep_print_fields(struct trace_seq *s, void *data=
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
@@ -5244,7 +5244,7 @@ int tep_data_type(struct tep_handle *pevent, struct t=
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
@@ -5402,7 +5402,7 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct=
 cmdline *cmdline)
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
  */
-void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
+void tep_event_info(struct trace_seq *s, struct tep_event *event,
 		    struct tep_record *record)
 {
 	int print_pretty =3D 1;
@@ -5443,7 +5443,7 @@ static bool is_timestamp_in_us(char *trace_clock, boo=
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
@@ -5468,7 +5468,7 @@ tep_find_event_by_record(struct tep_handle *pevent, s=
truct tep_record *record)
  * Writes the tasks comm, pid and CPU to @s.
  */
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record)
 {
 	void *data =3D record->data;
@@ -5496,7 +5496,7 @@ void tep_print_event_task(struct tep_handle *pevent, =
struct trace_seq *s,
  * Writes the timestamp of the record into @s.
  */
 void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record,
 			  bool use_trace_clock)
 {
@@ -5546,7 +5546,7 @@ void tep_print_event_time(struct tep_handle *pevent, =
struct trace_seq *s,
  * Writes the parsing of the record's data to @s.
  */
 void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			  struct tep_event_format *event,
+			  struct tep_event *event,
 			  struct tep_record *record)
 {
 	static const char *spaces =3D "                    "; /* 20 spaces */
@@ -5565,7 +5565,7 @@ void tep_print_event_data(struct tep_handle *pevent, =
struct trace_seq *s,
 void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	event =3D tep_find_event_by_record(pevent, record);
 	if (!event) {
@@ -5587,8 +5587,8 @@ void tep_print_event(struct tep_handle *pevent, struc=
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
@@ -5601,8 +5601,8 @@ static int events_id_cmp(const void *a, const void *b=
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
@@ -5618,8 +5618,8 @@ static int events_name_cmp(const void *a, const void =
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
@@ -5633,9 +5633,9 @@ static int events_system_cmp(const void *a, const voi=
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
@@ -5718,7 +5718,7 @@ get_event_fields(const char *type, const char *name,
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
@@ -5732,7 +5732,7 @@ struct tep_format_field **tep_event_common_fields(str=
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
@@ -5974,7 +5974,7 @@ int tep_parse_header_page(struct tep_handle *pevent, =
char *buf, unsigned long si
 	return 0;
 }
=20
-static int event_matches(struct tep_event_format *event,
+static int event_matches(struct tep_event *event,
 			 int id, const char *sys_name,
 			 const char *event_name)
 {
@@ -5997,7 +5997,7 @@ static void free_handler(struct event_handler *handle=
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
@@ -6038,11 +6038,11 @@ static int find_event_handle(struct tep_handle *pev=
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
@@ -6147,12 +6147,12 @@ enum tep_errno __tep_parse_format(struct tep_event_=
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
@@ -6189,7 +6189,7 @@ __parse_event(struct tep_handle *pevent,
  * /sys/kernel/debug/tracing/events/.../.../format
  */
 enum tep_errno tep_parse_format(struct tep_handle *pevent,
-				struct tep_event_format **eventp,
+				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys)
 {
@@ -6213,7 +6213,7 @@ enum tep_errno tep_parse_format(struct tep_handle *pe=
vent,
 enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys)
 {
-	struct tep_event_format *event =3D NULL;
+	struct tep_event *event =3D NULL;
 	return __parse_event(pevent, &event, buf, size, sys);
 }
=20
@@ -6279,7 +6279,7 @@ int get_field_val(struct trace_seq *s, struct tep_for=
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
@@ -6326,7 +6326,7 @@ void *tep_get_field_raw(struct trace_seq *s, struct t=
ep_event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
+int tep_get_field_val(struct trace_seq *s, struct tep_event *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err)
 {
@@ -6351,7 +6351,7 @@ int tep_get_field_val(struct trace_seq *s, struct tep=
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
@@ -6376,7 +6376,7 @@ int tep_get_common_field_val(struct trace_seq *s, str=
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
@@ -6402,7 +6402,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct=
 tep_event_format *event,
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
-			struct tep_event_format *event, const char *name,
+			struct tep_event *event, const char *name,
 			struct tep_record *record, int err)
 {
 	struct tep_format_field *field =3D tep_find_field(event, name);
@@ -6434,7 +6434,7 @@ int tep_print_num_field(struct trace_seq *s, const ch=
ar *fmt,
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
-			 struct tep_event_format *event, const char *name,
+			 struct tep_event *event, const char *name,
 			 struct tep_record *record, int err)
 {
 	struct tep_format_field *field =3D tep_find_field(event, name);
@@ -6594,11 +6594,11 @@ int tep_unregister_print_function(struct tep_handle=
 *pevent,
 	return -1;
 }
=20
-static struct tep_event_format *search_event(struct tep_handle *pevent, in=
t id,
-					 const char *sys_name,
-					 const char *event_name)
+static struct tep_event *search_event(struct tep_handle *pevent, int id,
+				      const char *sys_name,
+				      const char *event_name)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
=20
 	if (id >=3D 0) {
 		/* search by id */
@@ -6638,7 +6638,7 @@ int tep_register_event_handler(struct tep_handle *pev=
ent, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct event_handler *handle;
=20
 	event =3D search_event(pevent, id, sys_name, event_name);
@@ -6722,7 +6722,7 @@ int tep_unregister_event_handler(struct tep_handle *p=
event, int id,
 				 const char *sys_name, const char *event_name,
 				 tep_event_handler_func func, void *context)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct event_handler *handle;
 	struct event_handler **next;
=20
@@ -6807,7 +6807,7 @@ static void free_formats(struct tep_format *format)
 	free_format_fields(format->fields);
 }
=20
-void tep_free_format(struct tep_event_format *event)
+void tep_free_format(struct tep_event *event)
 {
 	free(event->name);
 	free(event->system);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index f7f1d8d11b0a..00b696efd671 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -57,11 +57,11 @@ struct tep_record {
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
@@ -143,7 +143,7 @@ enum tep_format_flags {
=20
 struct tep_format_field {
 	struct tep_format_field	*next;
-	struct tep_event_format	*event;
+	struct tep_event	*event;
 	char			*type;
 	char			*name;
 	char			*alias;
@@ -277,7 +277,7 @@ struct tep_print_fmt {
 	struct tep_print_arg	*args;
 };
=20
-struct tep_event_format {
+struct tep_event {
 	struct tep_handle	*pevent;
 	char			*name;
 	int			id;
@@ -456,14 +456,14 @@ int tep_register_print_string(struct tep_handle *peve=
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
@@ -474,32 +474,32 @@ int tep_parse_header_page(struct tep_handle *pevent, =
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
-			struct tep_event_format *event, const char *name,
+			struct tep_event *event, const char *name,
 			struct tep_record *record, int err);
=20
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
-			 struct tep_event_format *event, const char *name,
+			 struct tep_event *event, const char *name,
 			 struct tep_record *record, int err);
=20
 int tep_register_event_handler(struct tep_handle *pevent, int id,
@@ -515,9 +515,9 @@ int tep_register_print_function(struct tep_handle *peve=
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
@@ -526,19 +526,19 @@ unsigned long long tep_read_number(struct tep_handle =
*pevent, const void *ptr, i
 int tep_read_number_field(struct tep_format_field *field, const void *data=
,
 			  unsigned long long *value);
=20
-struct tep_event_format *tep_get_first_event(struct tep_handle *tep);
+struct tep_event *tep_get_first_event(struct tep_handle *tep);
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
@@ -551,15 +551,15 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct=
 cmdline *cmdline);
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct tep_event_format *event);
-void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
-		       struct tep_record *record);
+		      int size __maybe_unused, struct tep_event *event);
+void tep_event_info(struct trace_seq *s, struct tep_event *event,
+		    struct tep_record *record);
 int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
-		    char *buf, size_t buflen);
+		 char *buf, size_t buflen);
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
@@ -715,7 +715,7 @@ struct tep_filter_arg {
=20
 struct tep_filter_type {
 	int			event_id;
-	struct tep_event_format	*event;
+	struct tep_event	*event;
 	struct tep_filter_arg	*filter;
 };
=20
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/par=
se-filter.c
index eebbff7cd1a3..77a1a4cc2357 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -41,7 +41,7 @@ static struct tep_format_field cpu =3D {
=20
 struct event_list {
 	struct event_list	*next;
-	struct tep_event_format	*event;
+	struct tep_event	*event;
 };
=20
 static void show_error(char *error_buf, const char *fmt, ...)
@@ -243,7 +243,7 @@ static void free_arg(struct tep_filter_arg *arg)
 }
=20
 static int add_event(struct event_list **events,
-		     struct tep_event_format *event)
+		     struct tep_event *event)
 {
 	struct event_list *list;
=20
@@ -257,7 +257,7 @@ static int add_event(struct event_list **events,
 	return 0;
 }
=20
-static int event_match(struct tep_event_format *event,
+static int event_match(struct tep_event *event,
 		       regex_t *sreg, regex_t *ereg)
 {
 	if (sreg) {
@@ -273,7 +273,7 @@ static enum tep_errno
 find_event(struct tep_handle *pevent, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	regex_t ereg;
 	regex_t sreg;
 	int match =3D 0;
@@ -348,7 +348,7 @@ static void free_events(struct event_list *events)
 }
=20
 static enum tep_errno
-create_arg_item(struct tep_event_format *event, const char *token,
+create_arg_item(struct tep_event *event, const char *token,
 		enum tep_event_type type, struct tep_filter_arg **parg, char *error_str)
 {
 	struct tep_format_field *field;
@@ -954,7 +954,7 @@ static int collapse_tree(struct tep_filter_arg *arg,
 }
=20
 static enum tep_errno
-process_filter(struct tep_event_format *event, struct tep_filter_arg **par=
g,
+process_filter(struct tep_event *event, struct tep_filter_arg **parg,
 	       char *error_str, int not)
 {
 	enum tep_event_type type;
@@ -1194,7 +1194,7 @@ process_filter(struct tep_event_format *event, struct=
 tep_filter_arg **parg,
 }
=20
 static enum tep_errno
-process_event(struct tep_event_format *event, const char *filter_str,
+process_event(struct tep_event *event, const char *filter_str,
 	      struct tep_filter_arg **parg, char *error_str)
 {
 	int ret;
@@ -1219,7 +1219,7 @@ process_event(struct tep_event_format *event, const c=
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
@@ -1471,7 +1471,7 @@ static int copy_filter_type(struct tep_event_filter *=
filter,
 			    struct tep_filter_type *filter_type)
 {
 	struct tep_filter_arg *arg;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	const char *sys;
 	const char *name;
 	char *str;
@@ -1553,7 +1553,7 @@ int tep_update_trivial(struct tep_event_filter *dest,=
 struct tep_event_filter *s
 {
 	struct tep_handle *src_pevent;
 	struct tep_handle *dest_pevent;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_filter_type *filter_type;
 	struct tep_filter_arg *arg;
 	char *str;
@@ -1697,11 +1697,11 @@ int tep_filter_event_has_trivial(struct tep_event_f=
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
@@ -1712,7 +1712,7 @@ get_comm(struct tep_event_format *event, struct tep_r=
ecord *record)
 }
=20
 static unsigned long long
-get_value(struct tep_event_format *event,
+get_value(struct tep_event *event,
 	  struct tep_format_field *field, struct tep_record *record)
 {
 	unsigned long long val;
@@ -1748,11 +1748,11 @@ get_value(struct tep_event_format *event,
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
@@ -1807,7 +1807,7 @@ get_exp_value(struct tep_event_format *event, struct =
tep_filter_arg *arg,
 }
=20
 static unsigned long long
-get_arg_value(struct tep_event_format *event, struct tep_filter_arg *arg,
+get_arg_value(struct tep_event *event, struct tep_filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->type) {
@@ -1831,7 +1831,7 @@ get_arg_value(struct tep_event_format *event, struct =
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
@@ -1874,7 +1874,7 @@ static int test_num(struct tep_event_format *event, s=
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
@@ -1922,7 +1922,7 @@ static const char *get_field_str(struct tep_filter_ar=
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
@@ -1953,7 +1953,7 @@ static int test_str(struct tep_event_format *event, s=
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
@@ -1975,7 +1975,7 @@ static int test_op(struct tep_event_format *event, st=
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
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/=
plugin_function.c
index 528acc75d81a..a73eca34a8f9 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -124,7 +124,7 @@ static int add_and_get_index(const char *parent, const =
char *child, int cpu)
 }
=20
 static int function_handler(struct trace_seq *s, struct tep_record *record=
,
-			    struct tep_event_format *event, void *context)
+			    struct tep_event *event, void *context)
 {
 	struct tep_handle *pevent =3D event->pevent;
 	unsigned long long function;
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/p=
lugin_hrtimer.c
index 9aa05b4ca811..5db5e401275f 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -27,7 +27,7 @@
=20
 static int timer_expire_handler(struct trace_seq *s,
 				struct tep_record *record,
-				struct tep_event_format *event, void *context)
+				struct tep_event *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=3D");
=20
@@ -47,7 +47,7 @@ static int timer_expire_handler(struct trace_seq *s,
=20
 static int timer_start_handler(struct trace_seq *s,
 			       struct tep_record *record,
-			       struct tep_event_format *event, void *context)
+			       struct tep_event *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=3D");
=20
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plug=
in_kmem.c
index 1beb4eaddfdf..0e3c601f9ed1 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -25,7 +25,7 @@
 #include "trace-seq.h"
=20
 static int call_site_handler(struct trace_seq *s, struct tep_record *recor=
d,
-			     struct tep_event_format *event, void *context)
+			     struct tep_event *event, void *context)
 {
 	struct tep_format_field *field;
 	unsigned long long val, addr;
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugi=
n_kvm.c
index d13c22846fa9..637be7c18476 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -249,7 +249,7 @@ static const char *find_exit_reason(unsigned isa, int v=
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
@@ -270,7 +270,7 @@ static int print_exit_reason(struct trace_seq *s, struc=
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
=20
 static int kvm_emulate_insn_handler(struct trace_seq *s,
 				    struct tep_record *record,
-				    struct tep_event_format *event, void *context)
+				    struct tep_event *event, void *context)
 {
 	unsigned long long rip, csbase, len, flags, failed;
 	int llen;
@@ -332,7 +332,7 @@ static int kvm_emulate_insn_handler(struct trace_seq *s=
,
=20
=20
 static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct te=
p_record *record,
-					    struct tep_event_format *event, void *context)
+					    struct tep_event *event, void *context)
 {
 	if (print_exit_reason(s, record, event, "exit_code") < 0)
 		return -1;
@@ -346,7 +346,7 @@ static int kvm_nested_vmexit_inject_handler(struct trac=
e_seq *s, struct tep_reco
 }
=20
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_recor=
d *record,
-				     struct tep_event_format *event, void *context)
+				     struct tep_event *event, void *context)
 {
 	tep_print_num_field(s, "rip %llx ", event, "rip", record, 1);
=20
@@ -372,7 +372,7 @@ union kvm_mmu_page_role {
 };
=20
 static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *reco=
rd,
-			      struct tep_event_format *event, void *context)
+			      struct tep_event *event, void *context)
 {
 	unsigned long long val;
 	static const char *access_str[] =3D {
@@ -419,7 +419,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, stru=
ct tep_record *record,
=20
 static int kvm_mmu_get_page_handler(struct trace_seq *s,
 				    struct tep_record *record,
-				    struct tep_event_format *event, void *context)
+				    struct tep_event *event, void *context)
 {
 	unsigned long long val;
=20
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/=
plugin_mac80211.c
index da3855e7b86f..e38b9477aad2 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -26,7 +26,7 @@
=20
 #define INDENT 65
=20
-static void print_string(struct trace_seq *s, struct tep_event_format *eve=
nt,
+static void print_string(struct trace_seq *s, struct tep_event *event,
 			 const char *name, const void *data)
 {
 	struct tep_format_field *f =3D tep_find_field(event, name);
@@ -60,7 +60,7 @@ static void print_string(struct trace_seq *s, struct tep_=
event_format *event,
=20
 static int drv_bss_info_changed(struct trace_seq *s,
 				struct tep_record *record,
-				struct tep_event_format *event, void *context)
+				struct tep_event *event, void *context)
 {
 	void *data =3D record->data;
=20
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceev=
ent/plugin_sched_switch.c
index 77882272672f..834c9e378ff8 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -67,7 +67,7 @@ static void write_and_save_comm(struct tep_format_field *=
field,
=20
 static int sched_wakeup_handler(struct trace_seq *s,
 				struct tep_record *record,
-				struct tep_event_format *event, void *context)
+				struct tep_event *event, void *context)
 {
 	struct tep_format_field *field;
 	unsigned long long val;
@@ -96,7 +96,7 @@ static int sched_wakeup_handler(struct trace_seq *s,
=20
 static int sched_switch_handler(struct trace_seq *s,
 				struct tep_record *record,
-				struct tep_event_format *event, void *context)
+				struct tep_event *event, void *context)
 {
 	struct tep_format_field *field;
 	unsigned long long val;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index eedf4455d89c..8bade7553e84 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -804,7 +804,7 @@ static struct syscall_fmt *syscall_fmt__find(const char=
 *name)
 }
=20
 struct syscall {
-	struct tep_event_format *tp_format;
+	struct tep_event *tp_format;
 	int			nr_args;
 	struct tep_format_field *args;
 	const char		*name;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index fa1729c49ef3..f444de14c1df 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -102,7 +102,7 @@ struct perf_evsel {
 	char			*name;
 	double			scale;
 	const char		*unit;
-	struct tep_event_format	*tp_format;
+	struct tep_event	*tp_format;
 	off_t			id_offset;
 	struct perf_stat_evsel  *stats;
 	void			*priv;
@@ -211,7 +211,7 @@ static inline struct perf_evsel *perf_evsel__newtp(cons=
t char *sys, const char *
=20
 struct perf_evsel *perf_evsel__new_cycles(bool precise);
=20
-struct tep_event_format *event_format__new(const char *sys, const char *na=
me);
+struct tep_event *event_format__new(const char *sys, const char *name);
=20
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a079243d3ffc..5a589f740be9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3209,7 +3209,7 @@ static int read_attr(int fd, struct perf_header *ph,
 static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
 						struct tep_handle *pevent)
 {
-	struct tep_event_format *event;
+	struct tep_event *event;
 	char bf[128];
=20
 	/* already prepared */
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 3de0bec30706..9ea52355cf45 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -385,7 +385,7 @@ get_tracepoint_field(struct pyrf_event *pevent, PyObjec=
t *attr_name)
 	struct tep_format_field *field;
=20
 	if (!evsel->tp_format) {
-		struct tep_event_format *tp_format;
+		struct tep_event *tp_format;
=20
 		tp_format =3D trace_event__tp_format_id(evsel->attr.config);
 		if (!tp_format)
@@ -1222,7 +1222,7 @@ static struct {
 static PyObject *pyrf__tracepoint(struct pyrf_evsel *pevsel,
 				  PyObject *args, PyObject *kwargs)
 {
-	struct tep_event_format *tp_format;
+	struct tep_event *tp_format;
 	static char *kwlist[] =3D { "sys", "name", NULL };
 	char *sys  =3D NULL;
 	char *name =3D NULL;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/p=
erf/util/scripting-engines/trace-event-perl.c
index 89cb887648f9..b93f36b887b5 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -189,7 +189,7 @@ static void define_flag_field(const char *ev_name,
 	LEAVE;
 }
=20
-static void define_event_symbols(struct tep_event_format *event,
+static void define_event_symbols(struct tep_event *event,
 				 const char *ev_name,
 				 struct tep_print_arg *args)
 {
@@ -338,7 +338,7 @@ static void perl_process_tracepoint(struct perf_sample =
*sample,
 				    struct addr_location *al)
 {
 	struct thread *thread =3D al->thread;
-	struct tep_event_format *event =3D evsel->tp_format;
+	struct tep_event *event =3D evsel->tp_format;
 	struct tep_format_field *field;
 	static char handler[256];
 	unsigned long long val;
@@ -537,7 +537,7 @@ static int perl_stop_script(void)
=20
 static int perl_generate_script(struct tep_handle *pevent, const char *out=
file)
 {
-	struct tep_event_format *event =3D NULL;
+	struct tep_event *event =3D NULL;
 	struct tep_format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools=
/perf/util/scripting-engines/trace-event-python.c
index 69aa93d4ee99..40b85c952692 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -264,7 +264,7 @@ static void define_field(enum tep_print_arg_type field_=
type,
 	Py_DECREF(t);
 }
=20
-static void define_event_symbols(struct tep_event_format *event,
+static void define_event_symbols(struct tep_event *event,
 				 const char *ev_name,
 				 struct tep_print_arg *args)
 {
@@ -332,7 +332,7 @@ static void define_event_symbols(struct tep_event_forma=
t *event,
 		define_event_symbols(event, ev_name, args->next);
 }
=20
-static PyObject *get_field_numeric_entry(struct tep_event_format *event,
+static PyObject *get_field_numeric_entry(struct tep_event *event,
 		struct tep_format_field *field, void *data)
 {
 	bool is_array =3D field->flags & TEP_FIELD_IS_ARRAY;
@@ -790,7 +790,7 @@ static void python_process_tracepoint(struct perf_sampl=
e *sample,
 				      struct perf_evsel *evsel,
 				      struct addr_location *al)
 {
-	struct tep_event_format *event =3D evsel->tp_format;
+	struct tep_event *event =3D evsel->tp_format;
 	PyObject *handler, *context, *t, *obj =3D NULL, *callchain;
 	PyObject *dict =3D NULL, *all_entries_dict =3D NULL;
 	static char handler_name[256];
@@ -1590,7 +1590,7 @@ static int python_stop_script(void)
=20
 static int python_generate_script(struct tep_handle *pevent, const char *o=
utfile)
 {
-	struct tep_event_format *event =3D NULL;
+	struct tep_event *event =3D NULL;
 	struct tep_format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-ev=
ent-parse.c
index a6ec3983cb02..ea40c841f437 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -33,7 +33,7 @@ static int get_common_field(struct scripting_context *con=
text,
 			    int *offset, int *size, const char *type)
 {
 	struct tep_handle *pevent =3D context->pevent;
-	struct tep_event_format *event;
+	struct tep_event *event;
 	struct tep_format_field *field;
=20
 	if (!*size) {
@@ -95,7 +95,7 @@ int common_pc(struct scripting_context *context)
 }
=20
 unsigned long long
-raw_field_value(struct tep_event_format *event, const char *name, void *da=
ta)
+raw_field_value(struct tep_event *event, const char *name, void *data)
 {
 	struct tep_format_field *field;
 	unsigned long long val;
@@ -109,12 +109,12 @@ raw_field_value(struct tep_event_format *event, const=
 char *name, void *data)
 	return val;
 }
=20
-unsigned long long read_size(struct tep_event_format *event, void *ptr, in=
t size)
+unsigned long long read_size(struct tep_event *event, void *ptr, int size)
 {
 	return tep_read_number(event->pevent, ptr, size);
 }
=20
-void event_format__fprintf(struct tep_event_format *event,
+void event_format__fprintf(struct tep_event *event,
 			   int cpu, void *data, int size, FILE *fp)
 {
 	struct tep_record record;
@@ -131,7 +131,7 @@ void event_format__fprintf(struct tep_event_format *eve=
nt,
 	trace_seq_destroy(&s);
 }
=20
-void event_format__print(struct tep_event_format *event,
+void event_format__print(struct tep_event *event,
 			 int cpu, void *data, int size)
 {
 	return event_format__fprintf(event, cpu, data, size, stdout);
@@ -190,12 +190,12 @@ int parse_event_file(struct tep_handle *pevent,
 	return tep_parse_event(pevent, buf, size, sys);
 }
=20
-struct tep_event_format *trace_find_next_event(struct tep_handle *pevent,
-					       struct tep_event_format *event)
+struct tep_event *trace_find_next_event(struct tep_handle *pevent,
+					struct tep_event *event)
 {
 	static int idx;
 	int events_count;
-	struct tep_event_format *all_events;
+	struct tep_event *all_events;
=20
 	all_events =3D tep_get_first_event(pevent);
 	events_count =3D tep_get_events_count(pevent);
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index 95664b2f771e..cbe0dd758e3a 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -72,12 +72,12 @@ void trace_event__cleanup(struct trace_event *t)
 /*
  * Returns pointer with encoded error via <linux/err.h> interface.
  */
-static struct tep_event_format*
+static struct tep_event*
 tp_format(const char *sys, const char *name)
 {
 	char *tp_dir =3D get_events_file(sys);
 	struct tep_handle *pevent =3D tevent.pevent;
-	struct tep_event_format *event =3D NULL;
+	struct tep_event *event =3D NULL;
 	char path[PATH_MAX];
 	size_t size;
 	char *data;
@@ -102,7 +102,7 @@ tp_format(const char *sys, const char *name)
 /*
  * Returns pointer with encoded error via <linux/err.h> interface.
  */
-struct tep_event_format*
+struct tep_event*
 trace_event__tp_format(const char *sys, const char *name)
 {
 	if (!tevent_initialized && trace_event__init2())
@@ -111,7 +111,7 @@ trace_event__tp_format(const char *sys, const char *nam=
e)
 	return tp_format(sys, name);
 }
=20
-struct tep_event_format *trace_event__tp_format_id(int id)
+struct tep_event *trace_event__tp_format_id(int id)
 {
 	if (!tevent_initialized && trace_event__init2())
 		return ERR_PTR(-ENOMEM);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index f024d73bfc40..d9b0a942090a 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -22,17 +22,17 @@ int trace_event__init(struct trace_event *t);
 void trace_event__cleanup(struct trace_event *t);
 int trace_event__register_resolver(struct machine *machine,
 				   tep_func_resolver_t *func);
-struct tep_event_format*
+struct tep_event*
 trace_event__tp_format(const char *sys, const char *name);
=20
-struct tep_event_format *trace_event__tp_format_id(int id);
+struct tep_event *trace_event__tp_format_id(int id);
=20
 int bigendian(void);
=20
-void event_format__fprintf(struct tep_event_format *event,
+void event_format__fprintf(struct tep_event *event,
 			   int cpu, void *data, int size, FILE *fp);
=20
-void event_format__print(struct tep_event_format *event,
+void event_format__print(struct tep_event *event,
 			 int cpu, void *data, int size);
=20
 int parse_ftrace_file(struct tep_handle *pevent, char *buf, unsigned long =
size);
@@ -40,7 +40,7 @@ int parse_event_file(struct tep_handle *pevent,
 		     char *buf, unsigned long size, char *sys);
=20
 unsigned long long
-raw_field_value(struct tep_event_format *event, const char *name, void *da=
ta);
+raw_field_value(struct tep_event *event, const char *name, void *data);
=20
 void parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned i=
nt size);
 void parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned i=
nt size);
@@ -48,9 +48,9 @@ void parse_saved_cmdline(struct tep_handle *pevent, char =
*file, unsigned int siz
=20
 ssize_t trace_report(int fd, struct trace_event *tevent, bool repipe);
=20
-struct tep_event_format *trace_find_next_event(struct tep_handle *pevent,
-					       struct tep_event_format *event);
-unsigned long long read_size(struct tep_event_format *event, void *ptr, in=
t size);
+struct tep_event *trace_find_next_event(struct tep_handle *pevent,
+					struct tep_event *event);
+unsigned long long read_size(struct tep_event *event, void *ptr, int size)=
;
 unsigned long long eval_flag(const char *flag);
=20
 int read_tracing_data(int fd, struct list_head *pattrs);
--=20
2.17.2
