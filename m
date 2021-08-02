Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70781C4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Aug 2021 16:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BFE560FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Aug 2021 16:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhHBQ3p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 12:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhHBQ3o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 12:29:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6E960EB2;
        Mon,  2 Aug 2021 16:29:34 +0000 (UTC)
Date:   Mon, 2 Aug 2021 12:29:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] libtraceevent: Add tep_print_selected_fields()
Message-ID: <20210802122933.1873b6f8@oasis.local.home>
In-Reply-To: <20210802112714.67631-1-y.karadz@gmail.com>
References: <20210802112714.67631-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  2 Aug 2021 14:27:14 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The new method can print only a subset of the unique data fields of
> the trace event. The print format is derived from the parsing tokens
> (tep_print_parse objects) of the event. As a byproduct of this change
> the existing method tep_print_fields() gets upgraded to use the
> formats provided by the tokens.

Why add a new API? Just fix tep_print_field().

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/event-parse.c | 87 ++++++++++++++++++++++++++++++++++++++++++-----
>  src/event-parse.h |  3 ++
>  2 files changed, 81 insertions(+), 9 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index f42ae38..7302f3d 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -3585,6 +3585,8 @@ tep_find_field(struct tep_event *event, const char *name)
>  	return format;
>  }
>  
> +
> +

Spurious newlines?

>  /**
>   * tep_find_any_field - find any field by name
>   * @event: handle for the event
> @@ -5333,6 +5335,19 @@ static int is_printable_array(char *p, unsigned int len)
>  	return 1;
>  }
>  
> +static void dynamic_offset(struct tep_handle *tep,
> +			   struct tep_format_field *field,
> +			   void *data,
> +			   unsigned int *offset,
> +			   unsigned int *len)
> +{
> +	unsigned long long val;
> +
> +	val = tep_read_number(tep, data + field->offset, field->size);
> +	*offset = val & SHRT_MAX;

Don't use SHRT_MAX. Although it is the same, there's no connection
of it being a short number (it only matches by coincidence), and I
don't want to add any assumptions that this is a short. It's 16 bits,
and that's all it is. The fact that a short is also 16 bits is just a
coincidence ;-)

> +	*len = val >> 16;

If anything, we should define:

#define TEP_OFFSET_MASK		0xffff
#define TEP_LEN_SHIFT		16

and then we can:

	*offset = val & TEP_OFFSET_MASK;
	*len = val >> TEP_LEN_SHIFT;

Which would make it much easier to read and document what it actually
is.

> +}
> +

Also, the above should be in a separate cleanup patch that that should
remove all the open coded conversions.

>  void tep_print_field(struct trace_seq *s, void *data,
>  		     struct tep_format_field *field)
>  {
> @@ -5343,12 +5358,9 @@ void tep_print_field(struct trace_seq *s, void *data,
>  	if (field->flags & TEP_FIELD_IS_ARRAY) {
>  		offset = field->offset;
>  		len = field->size;
> -		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
> -			val = tep_read_number(tep, data + offset, len);
> -			offset = val;
> -			len = offset >> 16;
> -			offset &= 0xffff;
> -		}
> +		if (field->flags & TEP_FIELD_IS_DYNAMIC)
> +			dynamic_offset(tep, field, data, &offset, &len);
> +
>  		if (field->flags & TEP_FIELD_IS_STRING &&
>  		    is_printable_array(data + offset, len)) {
>  			trace_seq_printf(s, "%s", (char *)data + offset);
> @@ -5398,19 +5410,76 @@ void tep_print_field(struct trace_seq *s, void *data,
>  	}
>  }
>  

What I was talking about is to change tep_print_field() to do something like:

Take the current tep_print_field() and turn it into static _tep_print_field().

 [ Not even compiled tested ]

void tep_print_field(struct trace_seq *s, void *data,
		     struct tep_format_field *field)
{
	struct tep_event = field->event;
	struct tep_print_parse = event->print_fmt.print_cache;
	struct tep_handle *tep = event->tep;
	unsigned int offset, len;

	if (event->flags & TEP_EVENT_FL_FAILED)
		goto out;

	if (field->flags & TEP_FIELD_IS_DYNAMIC)
		dynamic_offset(tep, field, data, &offset, &len);

	for (;parse; parse = parse->next) {
		if (parse->type == PRINT_FMT_STRING)
			continue;
		if (parse->arg->type != TEP_PRINT_FIELD)
			continue;
		if (parse->arg->field.field->field != field)
			continue;

		print_parse_data(parse, s, data, size, event);
		return;
	}

 out:
	/* Not found */
	_tep_print_field(s, data, field);
}

That print_parse_data() would be extracted from print_event_cache()

static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
			    void *data, int size, struct tep_event *event)
{
	if (parse->len_as_arg)
		len_arg = eval_num_arg(data, size, event, parse->len_as_arg);
	switch (parse->type) {
	case PRINT_FMT_ARG_DIGIT:
		print_arg_number(s, parse->format,
				parse->len_as_arg ? len_arg : -1, data,
				 size, parse->ls, event, parse->arg);
		break;
	case PRINT_FMT_ARG_POINTER:
		print_arg_pointer(s, parse->format,
				  parse->len_as_arg ? len_arg : 1,
				  data, size, event, parse->arg);
		break;
	case PRINT_FMT_ARG_STRING:
		print_arg_string(s, parse->format,
				 parse->len_as_arg ? len_arg : -1,
				 data, size, event, parse->arg);
		break;
	case PRINT_FMT_STRING:
	default:
		trace_seq_printf(s, "%s", parse->format);
		/* Return 1 on non field */
		return 1;
	}
	/* Return 0 on field being processed */
	return 0;
}


static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s,
			      void *data, int size, struct tep_event *event)
{
	int len_arg;

	while (parse) {
		parse = parse->next;
		parse_parse_data(parse, s, data, size, event);
	}
}


> -void tep_print_fields(struct trace_seq *s, void *data,
> -		      int size __maybe_unused, struct tep_event *event)
> +static struct tep_print_parse *parse_format_next(struct tep_print_parse *parse)
> +{
> +	while (parse) {
> +		if (strncmp(parse->format, "%", 1) == 0)
> +			break;
> +
> +		parse = parse->next;
> +	}
> +
> +	return parse;
> +}
> +
> +static void tep_print_fmt_field(struct trace_seq *s, void *data,
> +				const char *format,
> +				struct tep_format_field *field)
> +{
> +	struct tep_handle *tep = field->event->tep;
> +	unsigned int len, offset;
> +	unsigned long long val;
> +
> +	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
> +		dynamic_offset(tep, field, data, &offset, &len);
> +		if (len)
> +			trace_seq_printf(s, format, (char *)data + offset);
> +		else
> +			trace_seq_printf(s, format, "(nil)");
> +	} else {
> +		val = tep_read_number(tep, data + field->offset, field->size);
> +		trace_seq_printf(s, format, val);
> +	}
> +}
> +
> +void tep_print_selected_fields(struct trace_seq *s, void *data,
> +			       struct tep_event *event,
> +			       int ignore_mask)
>  {
>  	struct tep_format_field *field;
> +	struct tep_print_parse *parse;
> +	unsigned int len;
> +	int field_mask = 1;
>  
> +	parse = event->print_fmt.print_cache;
>  	field = event->format.fields;
>  	while (field) {
> +		parse = parse_format_next(parse);
> +
> +		if (field_mask & ignore_mask)
> +			goto next;
> +
>  		trace_seq_printf(s, " %s=", field->name);
> -		tep_print_field(s, data, field);
> +
> +		len = strlen(parse->format);
> +		if (len > 0 && parse->format[len - 1] == 'x')
> +			trace_seq_printf(s, "0x");
> +
> +		tep_print_fmt_field(s, data, parse->format, field);
> +
> + next:
>  		field = field->next;
> +		parse = parse->next;
> +		field_mask *= 2;
>  	}
>  }
>  
> +void tep_print_fields(struct trace_seq *s, void *data,
> +		      int size __maybe_unused, struct tep_event *event)
> +{
> +	tep_print_selected_fields(s, data, event, 0);
> +}
> +
>  static int print_function(struct trace_seq *s, const char *format,
>  			  void *data, int size, struct tep_event *event,
>  			  struct tep_print_arg *arg)
> diff --git a/src/event-parse.h b/src/event-parse.h
> index d4a876f..fe0fbf4 100644
> --- a/src/event-parse.h
> +++ b/src/event-parse.h
> @@ -547,6 +547,9 @@ void tep_print_field(struct trace_seq *s, void *data,
>  		     struct tep_format_field *field);
>  void tep_print_fields(struct trace_seq *s, void *data,
>  		      int size __maybe_unused, struct tep_event *event);
> +void tep_print_selected_fields(struct trace_seq *s, void *data,
> +			       struct tep_event *event,
> +			       int ignore_mask);

Again, I'm not so big on the selected fields version. Just call
tep_print_field for each section, as it just adds to the trace_seq()
which was created for this purpose (to avoid having to enter a list).


-- Steve


>  int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
>  		 char *buf, size_t buflen);
>  

