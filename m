Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCECC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 16:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E50F360FA0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 16:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhHKQWL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 12:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHKQWK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 12:22:10 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF49E60EBC;
        Wed, 11 Aug 2021 16:21:46 +0000 (UTC)
Date:   Wed, 11 Aug 2021 12:21:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 4/5] libtraceevent: Optimize tep_print_fields()
Message-ID: <20210811122140.2387e9ac@oasis.local.home>
In-Reply-To: <20210811121203.29123-5-y.karadz@gmail.com>
References: <20210811121203.29123-1-y.karadz@gmail.com>
        <20210811121203.29123-5-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 11 Aug 2021 15:12:02 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The current implementation of tep_print_fields() loops over all
> individual fields of the event and calls tep_print_field() for
> each one. In the same time inside tep_print_field() we loop over
> the list of all tokens of the printing format descriptor in order
> to determine how the current field must be printed (its own
> appropriate printing format). The problem is that in this second
> loop over the tokens we always start from the very first token
> and this can be quite inefficient for example in a case of a
> kprobe that has a large number of fields. This patch optimizes
> tep_print_fields(), allowing the traverse of the list of tokens
> to continue from the place reached when we searched for the
> format of the previous field.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/event-parse.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 9399555..7831e74 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -5392,14 +5392,15 @@ static void tep_print_field_raw(struct trace_seq *s, void *data,
>  static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
>  			    void *data, int size, struct tep_event *event);
>  
> -void tep_print_field(struct trace_seq *s, void *data,
> -		     struct tep_format_field *field)
> +void static inline _tep_print_field(struct trace_seq *s, void *data,
> +				    struct tep_format_field *field,
> +				    struct tep_print_parse **parse_ptr)
>  {
>  	struct tep_event *event = field->event;
>  	struct tep_print_parse *parse;
>  	bool has_0x;
>  
> -	parse = event->print_fmt.print_cache;
> +	parse = parse_ptr ? *parse_ptr : event->print_fmt.print_cache;
>  
>  	if (event->flags & TEP_EVENT_FL_FAILED)
>  		goto out;
> @@ -5407,7 +5408,7 @@ void tep_print_field(struct trace_seq *s, void *data,
>  	if (field->flags & (TEP_FIELD_IS_ARRAY || TEP_FIELD_IS_STRING))
>  		goto out;
>  
> -	for (;parse; parse = parse->next) {
> +	while (parse) {

If the parse field is not found, this will loop forever. We need this:

	struct tep_print_parse *start_parse;

	start_parse = parse;
	do {

>  		if (parse->type == PRINT_FMT_STRING) {
>  			int len = strlen(parse->format);
>  
> @@ -5417,21 +5418,29 @@ void tep_print_field(struct trace_seq *s, void *data,
>  			else
>  				has_0x = false;
>  
> -			continue;
> +			goto next;
>  		}
>  
>  		if (!parse->arg ||
>  		    parse->arg->type != TEP_PRINT_FIELD ||
>  		    parse->arg->field.field != field) {
>  			has_0x = false;
> -			continue;
> +			goto next;
>  		}
>  
>  		if (has_0x)
>  			trace_seq_puts(s, "0x");
>  
>  		print_parse_data(parse, s, data, field->size, event);
> +
> +		if (parse_ptr)
> +			*parse_ptr = parse->next;
> +
>  		return;
> +
> + next:
> +		parse = parse->next ? parse->next :
> +				      event->print_fmt.print_cache;

	} while (parse != start_parse);

-- Steve


>  	}
>  
>   out:
> @@ -5439,15 +5448,22 @@ void tep_print_field(struct trace_seq *s, void *data,
>  	tep_print_field_raw(s, data, field);
>  }
>  
> +void tep_print_field(struct trace_seq *s, void *data,
> +		     struct tep_format_field *field)
> +{
> +	_tep_print_field(s, data, field, NULL);
> +}
> +
>  void tep_print_fields(struct trace_seq *s, void *data,
>  		      int size __maybe_unused, struct tep_event *event)
>  {
> +	struct tep_print_parse *parse = event->print_fmt.print_cache;
>  	struct tep_format_field *field;
>  
>  	field = event->format.fields;
>  	while (field) {
>  		trace_seq_printf(s, " %s=", field->name);
> -		tep_print_field(s, data, field);
> +		_tep_print_field(s, data, field, &parse);
>  		field = field->next;
>  	}
>  }

