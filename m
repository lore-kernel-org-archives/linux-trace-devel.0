Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BAEFC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 16:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D223E60F25
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 16:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhHDQEg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 12:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhHDQEg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 12:04:36 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B87360E97;
        Wed,  4 Aug 2021 16:04:23 +0000 (UTC)
Date:   Wed, 4 Aug 2021 12:04:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] libtraceevent: Keep the pointer to the field in
 args (WiP)
Message-ID: <20210804120421.46fb61be@oasis.local.home>
In-Reply-To: <20210804125526.19774-2-y.karadz@gmail.com>
References: <20210804125526.19774-1-y.karadz@gmail.com>
        <20210804125526.19774-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  4 Aug 2021 15:55:26 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


>  In v2 I am trying to add propper handling of the "file" fieled
>  (via "__get_str") of this particular probe. A solution for the general
>  case still needs to be developed.

That's not what I meant. No need to touch anything to do with strings.

> 
>  Any ideas?
>  
> Thanks!
> Yordan
> 
> 
>  src/event-parse.c | 60 +++++++++++++++++++++++++++--------------------
>  1 file changed, 34 insertions(+), 26 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index b0790d7..64ebed3 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -2334,12 +2334,12 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
>  	arg->type = TEP_PRINT_FIELD;
>  	arg->field.name = field;
>  
> +	arg->field.field = tep_find_any_field(event, arg->field.name);
> +
>  	if (is_flag_field) {
> -		arg->field.field = tep_find_any_field(event, arg->field.name);
>  		arg->field.field->flags |= TEP_FIELD_IS_FLAG;
>  		is_flag_field = 0;
>  	} else if (is_symbolic_field) {
> -		arg->field.field = tep_find_any_field(event, arg->field.name);
>  		arg->field.field->flags |= TEP_FIELD_IS_SYMBOLIC;
>  		is_symbolic_field = 0;
>  	}

The above is all that was needed. The below should not be touched.

> @@ -3103,7 +3103,7 @@ process_paren(struct tep_event *event, struct tep_print_arg *arg, char **tok)
>  
>  static enum tep_event_type
>  process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
> -	    char **tok)
> +	    char **field, char **tok)
>  {
>  	enum tep_event_type type;
>  	char *token;
> @@ -3111,6 +3111,7 @@ process_str(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
>  	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
>  		goto out_free;
>  
> +	*field = token;
>  	arg->type = TEP_PRINT_STRING;
>  	arg->string.string = token;
>  	arg->string.offset = -1;
> @@ -3285,59 +3286,66 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
>  		 char *token, char **tok)
>  {
>  	struct tep_function_handler *func;
> +	int ret = TEP_EVENT_ERROR;
> +	char *field = NULL;
>  
>  	if (strcmp(token, "__print_flags") == 0) {
> -		free_token(token);
>  		is_flag_field = 1;
> -		return process_flags(event, arg, tok);
> +		ret = process_flags(event, arg, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__print_symbolic") == 0) {
> -		free_token(token);
>  		is_symbolic_field = 1;
> -		return process_symbols(event, arg, tok);
> +		ret = process_symbols(event, arg, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__print_hex") == 0) {
> -		free_token(token);
> -		return process_hex(event, arg, tok);
> +		ret = process_hex(event, arg, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__print_hex_str") == 0) {
> -		free_token(token);
> -		return process_hex_str(event, arg, tok);
> +		ret = process_hex_str(event, arg, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__print_array") == 0) {
> -		free_token(token);
> -		return process_int_array(event, arg, tok);
> +		ret = process_int_array(event, arg, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__get_str") == 0) {
> -		free_token(token);
> -		return process_str(event, arg, tok);
> +		ret = process_str(event, arg, &field, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__get_bitmask") == 0) {
> -		free_token(token);
> -		return process_bitmask(event, arg, tok);
> +		ret = process_bitmask(event, arg, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__get_dynamic_array") == 0) {
> -		free_token(token);
> -		return process_dynamic_array(event, arg, tok);
> +		ret = process_dynamic_array(event, arg, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__get_dynamic_array_len") == 0) {
> -		free_token(token);
> -		return process_dynamic_array_len(event, arg, tok);
> +		ret = process_dynamic_array_len(event, arg, tok);
> +		goto done;
>  	}
>  	if (strcmp(token, "__builtin_expect") == 0) {
> -		free_token(token);
> -		return process_builtin_expect(event, arg, tok);
> +		ret = process_builtin_expect(event, arg, tok);
> +		goto done;
>  	}
>  
>  	func = find_func_handler(event->tep, token);
>  	if (func) {
> -		free_token(token);
> -		return process_func_handler(event, func, arg, tok);
> +		ret = process_func_handler(event, func, arg, tok);
> +		goto done;
>  	}
>  
>  	do_warning_event(event, "function %s not defined", token);
> +
> + done:
> +	if (field)
> +		arg->field.field = tep_find_any_field(event, field);
> +
>  	free_token(token);
> -	return TEP_EVENT_ERROR;
> +	return ret;
>  }
>  
>  static enum tep_event_type

Fixing the offset and len dereferences in the first patch and then
applying this patch should give you exactly what you are looking for.
As we only care about conversions of numbers. Strings and arrays will
just be whatever they are.

-- Steve

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/src/event-parse.c b/src/event-parse.c
index b0790d7..24c69f2 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2334,12 +2334,12 @@ process_entry(struct tep_event *event __maybe_unused, struct tep_print_arg *arg,
 	arg->type = TEP_PRINT_FIELD;
 	arg->field.name = field;
 
+	arg->field.field = tep_find_any_field(event, arg->field.name);
+
 	if (is_flag_field) {
-		arg->field.field = tep_find_any_field(event, arg->field.name);
 		arg->field.field->flags |= TEP_FIELD_IS_FLAG;
 		is_flag_field = 0;
 	} else if (is_symbolic_field) {
-		arg->field.field = tep_find_any_field(event, arg->field.name);
 		arg->field.field->flags |= TEP_FIELD_IS_SYMBOLIC;
 		is_symbolic_field = 0;
 	}
@@ -5326,8 +5326,8 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
-void tep_print_field(struct trace_seq *s, void *data,
-		     struct tep_format_field *field)
+static void _tep_print_field(struct trace_seq *s, void *data,
+			     struct tep_format_field *field)
 {
 	struct tep_handle *tep = field->event->tep;
 	unsigned int offset, len, i;
@@ -5390,6 +5390,39 @@ void tep_print_field(struct trace_seq *s, void *data,
 	}
 }
 
+static void print_parse_data(struct tep_print_parse *parse,
+			     struct trace_seq *s, void *data, int size,
+			     struct tep_event *event);
+
+void tep_print_field(struct trace_seq *s, void *data,
+		     struct tep_format_field *field)
+{
+	struct tep_event *event = field->event;
+	struct tep_print_parse *parse = event->print_fmt.print_cache;
+
+	if (event->flags & TEP_EVENT_FL_FAILED)
+		goto out;
+
+	if (field->flags & (TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_STRING))
+		goto out;
+
+	for (;parse; parse = parse->next) {
+		if (parse->type == PRINT_FMT_STRING)
+			continue;
+		if (parse->arg->type != TEP_PRINT_FIELD)
+			continue;
+		if (parse->arg->field.field != field)
+			continue;
+
+		print_parse_data(parse, s, data, field->size, event);
+		return;
+	}
+	/* Not found */
+
+ out:
+	_tep_print_field(s, data, field);
+}
+
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event)
 {
@@ -5909,35 +5942,42 @@ parse_args(struct tep_event *event, const char *format, struct tep_print_arg *ar
 	return parse_ret;
 }
 
-static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s,
-			      void *data, int size, struct tep_event *event)
+static void print_parse_data(struct tep_print_parse *parse,
+			     struct trace_seq *s, void *data, int size,
+			     struct tep_event *event)
 {
 	int len_arg;
 
+	if (parse->len_as_arg)
+		len_arg = eval_num_arg(data, size, event, parse->len_as_arg);
+	switch (parse->type) {
+	case PRINT_FMT_ARG_DIGIT:
+		print_arg_number(s, parse->format,
+				 parse->len_as_arg ? len_arg : -1, data,
+				 size, parse->ls, event, parse->arg);
+		break;
+	case PRINT_FMT_ARG_POINTER:
+		print_arg_pointer(s, parse->format,
+				  parse->len_as_arg ? len_arg : 1,
+				  data, size, event, parse->arg);
+		break;
+	case PRINT_FMT_ARG_STRING:
+		print_arg_string(s, parse->format,
+				 parse->len_as_arg ? len_arg : -1,
+				 data, size, event, parse->arg);
+		break;
+	case PRINT_FMT_STRING:
+	default:
+		trace_seq_printf(s, "%s", parse->format);
+		break;
+	}
+}
+
+static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s,
+			      void *data, int size, struct tep_event *event)
+{
 	while (parse) {
-		if (parse->len_as_arg)
-			len_arg = eval_num_arg(data, size, event, parse->len_as_arg);
-		switch (parse->type) {
-		case PRINT_FMT_ARG_DIGIT:
-			print_arg_number(s, parse->format,
-					parse->len_as_arg ? len_arg : -1, data,
-					 size, parse->ls, event, parse->arg);
-			break;
-		case PRINT_FMT_ARG_POINTER:
-			print_arg_pointer(s, parse->format,
-					  parse->len_as_arg ? len_arg : 1,
-					  data, size, event, parse->arg);
-			break;
-		case PRINT_FMT_ARG_STRING:
-			print_arg_string(s, parse->format,
-					 parse->len_as_arg ? len_arg : -1,
-					 data, size, event, parse->arg);
-			break;
-		case PRINT_FMT_STRING:
-		default:
-			trace_seq_printf(s, "%s", parse->format);
-			break;
-		}
+		print_parse_data(parse, s, data, size, event);
 		parse = parse->next;
 	}
 }
