Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BC27096A
	for <linux-trace-devel@vger.kernel.org>; Wed,  6 Dec 2023 23:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD6BC433C8;
	Wed,  6 Dec 2023 23:07:21 +0000 (UTC)
Date: Wed, 6 Dec 2023 18:07:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ze Gao <zegao2021@gmail.com>, Ze Gao <zegao@tencent.com>
Subject: [PATCH] libtraceevent: Parse sched_switch "prev_state" field for
 state info
Message-ID: <20231206180750.68fc8648@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The write_state() function uses a hard coded string "SDTtXZPI" to index
the sched_switch prev_state field bitmask. This is fine, except for when
the kernel changes this string, in which case this will break again.

Worse yet, there can be various saved trace files that have various
versions of this string, and updating the string may work for one trace
file, it will likely break another trace file.

Instead, look into the event itself, and how it parsed the "print fmt".
Using the tep_print_args, the mapping between the bits and the output that
the kernel uses is exposed to user space. Walk the print arguments until
the __print_flags() for the "prev_state" field is found, and use that to
build the states string for future parsing.

Save the "prev_state_field" pointer, as it should be the same for later
occurrences, but if more than one trace data (more than one tep handler)
is being parsed, the string will need to be updated each time a new field
is passed in, as this is not saved in the tep handle itself.

Link: https://lore.kernel.org/linux-trace-devel/20231206175506.14f6081d@gandalf.local.home/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 plugins/plugin_sched_switch.c | 130 ++++++++++++++++++++++++++++++++--
 1 file changed, 125 insertions(+), 5 deletions(-)

diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index e0986ac9cc3d..af1ca6dd1c2a 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -9,13 +9,133 @@
 #include "event-parse.h"
 #include "trace-seq.h"
 
-static void write_state(struct trace_seq *s, int val)
+static const char *convert_sym(struct tep_print_flag_sym *sym)
 {
-	const char states[] = "SDTtXZPI";
+	static char save_states[33];
+
+	memset(save_states, 0, sizeof(save_states));
+
+	/* This is the flags for the prev_state_field, now make them into a string */
+	for (; sym; sym = sym->next) {
+		long bitmask = strtoul(sym->value, NULL, 0);
+		int i;
+
+		for (i = 0; !(bitmask & 1); i++)
+			bitmask >>= 1;
+
+		if (i > 32)
+			continue; // warn?
+
+		save_states[i] = sym->str[0];
+	}
+
+	return save_states;
+}
+
+static struct tep_print_arg_field *
+find_arg_field(struct tep_format_field *prev_state_field, struct tep_print_arg *arg)
+{
+	struct tep_print_arg_field *field;
+
+	if (!arg)
+		return NULL;
+
+	if (arg->type == TEP_PRINT_FIELD)
+		return &arg->field;
+
+	if (arg->type == TEP_PRINT_OP) {
+		field = find_arg_field(prev_state_field, arg->op.left);
+		if (field && field->field == prev_state_field)
+			return field;
+		field = find_arg_field(prev_state_field, arg->op.right);
+		if (field && field->field == prev_state_field)
+			return field;
+	}
+	return NULL;
+}
+
+static struct tep_print_flag_sym *
+test_flags(struct tep_format_field *prev_state_field, struct tep_print_arg *arg)
+{
+	struct tep_print_arg_field *field;
+
+	field = find_arg_field(prev_state_field, arg->flags.field);
+	if (!field)
+		return NULL;
+
+	return arg->flags.flags;
+}
+
+static struct tep_print_flag_sym *
+search_op(struct tep_format_field *prev_state_field, struct tep_print_arg *arg)
+{
+	struct tep_print_flag_sym *sym = NULL;
+
+	if (!arg)
+		return NULL;
+
+	if (arg->type == TEP_PRINT_OP) {
+		sym = search_op(prev_state_field, arg->op.left);
+		if (sym)
+			return sym;
+
+		sym = search_op(prev_state_field, arg->op.right);
+		if (sym)
+			return sym;
+	} else if (arg->type == TEP_PRINT_FLAGS) {
+		sym = test_flags(prev_state_field, arg);
+	}
+
+	return sym;
+}
+
+static const char *get_states(struct tep_format_field *prev_state_field)
+{
+	struct tep_print_flag_sym *sym;
+	struct tep_print_arg *arg;
+	struct tep_event *event;
+
+	event = prev_state_field->event;
+
+	/*
+	 * Look at the event format fields, and search for where
+	 * the prev_state is parsed via the format flags.
+	 */
+	for (arg = event->print_fmt.args; arg; arg = arg->next) {
+		/*
+		 * Currently, the __print_flags() for the prev_state
+		 * is embedded in operations, so they too must be
+		 * searched.
+		 */
+		sym = search_op(prev_state_field, arg);
+		if (sym)
+			return convert_sym(sym);
+	}
+	return NULL;
+}
+
+static void write_state(struct trace_seq *s, struct tep_format_field *field,
+			struct tep_record *record)
+{
+	static struct tep_format_field *prev_state_field;
+	static const char *states;
+	unsigned long long val;
 	int found = 0;
+	int len;
 	int i;
 
-	for (i = 0; i < (sizeof(states) - 1); i++) {
+	if (!states || field != prev_state_field) {
+		states = get_states(field);
+		if (!states)
+			states = "SDTtXZPI";
+		printf("states = '%s'\n", states);
+		prev_state_field = field;
+	}
+
+	tep_read_number_field(field, record->data, &val);
+
+	len = strlen(states);
+	for (i = 0; i < len; i++) {
 		if (!(val & (1 << i)))
 			continue;
 
@@ -99,8 +219,8 @@ static int sched_switch_handler(struct trace_seq *s,
 	if (tep_get_field_val(s, event, "prev_prio", record, &val, 1) == 0)
 		trace_seq_printf(s, "[%d] ", (int) val);
 
-	if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0)
-		write_state(s, val);
+	field = tep_find_any_field(event, "prev_state");
+	write_state(s, field, record);
 
 	trace_seq_puts(s, " ==> ");
 
-- 
2.42.0

