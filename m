Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B6A70963
	for <linux-trace-devel@vger.kernel.org>; Wed,  6 Dec 2023 22:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA97DC433C8;
	Wed,  6 Dec 2023 22:54:37 +0000 (UTC)
Date: Wed, 6 Dec 2023 17:55:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ze Gao <zegao2021@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: Re: [PATCH v6 1/2] libtraceevent: sync state char array with the
 kernel
Message-ID: <20231206175506.14f6081d@gandalf.local.home>
In-Reply-To: <20230803030955.380537-1-zegao@tencent.com>
References: <20230803030955.380537-1-zegao@tencent.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  2 Aug 2023 23:09:54 -0400
Ze Gao <zegao2021@gmail.com> wrote:

> Update state char array to match the latest kernel
> definitions.
> 
> Signed-off-by: Ze Gao <zegao@tencent.com>
> ---
>  plugins/plugin_sched_switch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
> index 8752cae..e0986ac 100644
> --- a/plugins/plugin_sched_switch.c
> +++ b/plugins/plugin_sched_switch.c
> @@ -11,7 +11,7 @@
>  
>  static void write_state(struct trace_seq *s, int val)
>  {
> -	const char states[] = "SDTtZXxW";
> +	const char states[] = "SDTtXZPI";
>  	int found = 0;
>  	int i;
>  

Hi Ze,

As your update never made it into the kernel I never pulled these patches
in. But we do have an issue with the state getting out of sync with what
the kernel actually uses.

I did this "hack" but it seems to work. What I do is to look at the
sched_switch event print parsing arguments, find the __print_flags
arguments for the "prev_state" field. And then parse them, creating a new
output and I use that for the write_state() function.

I guess this should work for you too?

I still need to pull in this patch and use that as the default. I'll do
that before applying this one, and have your above update be the default.

Thanks!

-- Steve

diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 8752caea5c38..760d224f5507 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -9,13 +9,132 @@
 #include "event-parse.h"
 #include "trace-seq.h"
 
-static void write_state(struct trace_seq *s, int val)
+static const char *convert_sym(struct tep_print_flag_sym *sym)
 {
-	const char states[] = "SDTtZXxW";
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
+	if (field != prev_state_field) {
+		states = get_states(field);
+		if (!states)
+			states = "SDTtZXxW";
+		prev_state_field = field;
+	}
+
+	tep_read_number_field(field, record->data, &val);
+
+	len = strlen(states);
+	for (i = 0; i < len; i++) {
 		if (!(val & (1 << i)))
 			continue;
 
@@ -99,8 +218,8 @@ static int sched_switch_handler(struct trace_seq *s,
 	if (tep_get_field_val(s, event, "prev_prio", record, &val, 1) == 0)
 		trace_seq_printf(s, "[%d] ", (int) val);
 
-	if (tep_get_field_val(s,  event, "prev_state", record, &val, 1) == 0)
-		write_state(s, val);
+	field = tep_find_any_field(event, "prev_state");
+	write_state(s, field, record);
 
 	trace_seq_puts(s, " ==> ");
 
