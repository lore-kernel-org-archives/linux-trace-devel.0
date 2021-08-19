Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3073BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 16:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158E0610E5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 16:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhHSQzx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 12:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhHSQzx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 12:55:53 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED9D6101A;
        Thu, 19 Aug 2021 16:55:16 +0000 (UTC)
Date:   Thu, 19 Aug 2021 12:55:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] libtraceevent: Add tep_print_selected_fields()
Message-ID: <20210819125510.0b0b04c2@oasis.local.home>
In-Reply-To: <20210812085929.54832-6-y.karadz@gmail.com>
References: <20210812085929.54832-1-y.karadz@gmail.com>
        <20210812085929.54832-6-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 11:59:29 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The new method can print only a subset of the unique data fields of
> the trace event. The print format is derived from the parsing tokens
> (tep_print_parse objects) of the event.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/event-parse.c | 26 ++++++++++++++++++++++----
>  src/event-parse.h |  3 +++
>  2 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 0795135..645506e 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -5455,20 +5455,38 @@ void tep_print_field(struct trace_seq *s, void *data,
>  	_tep_print_field(s, data, field, NULL);
>  }
>  
> -void tep_print_fields(struct trace_seq *s, void *data,
> -		      int size __maybe_unused, struct tep_event *event)
> +static inline void
> +print_selected_fields(struct trace_seq *s, void *data,
> +		      struct tep_event *event,
> +		      unsigned long long ignore_mask)
>  {
>  	struct tep_print_parse *parse = event->print_fmt.print_cache;
>  	struct tep_format_field *field;
> +	unsigned long long field_mask = 1;
>  
>  	field = event->format.fields;
> -	while (field) {
> +	for (;field; field = field->next, field_mask *= 2) {

The above should be:

	for(; field; field = field->next, field_mask <<= 1) {

As a shift should be done with a shift operator and not a
multiplication.

Other than that, the rest looks good. I'll go ahead and pull in patches
1 and 2.

-- Steve


> +		if (field_mask & ignore_mask)
> +			continue;
> +
>  		trace_seq_printf(s, " %s=", field->name);
>  		_tep_print_field(s, data, field, &parse);
> -		field = field->next;
>  	}
>  }
>  
> +void tep_print_selected_fields(struct trace_seq *s, void *data,

As the above is an API, it needs a kernel doc type comment, and also an
addition to the man pages. The man page may be a separate patch.

-- Steve


> +			       struct tep_event *event,
> +			       unsigned long long ignore_mask)
> +{
> +	print_selected_fields(s, data, event, ignore_mask);
> +}
> +
> +void tep_print_fields(struct trace_seq *s, void *data,
> +		      int size __maybe_unused, struct tep_event *event)
> +{
> +	print_selected_fields(s, data, event, 0);
> +}
> +
>  static int print_function(struct trace_seq *s, const char *format,
>  			  void *data, int size, struct tep_event *event,
>  			  struct tep_print_arg *arg)
> diff --git a/src/event-parse.h b/src/event-parse.h
> index d4a876f..e3638cf 100644
> --- a/src/event-parse.h
> +++ b/src/event-parse.h
> @@ -545,6 +545,9 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
>  
>  void tep_print_field(struct trace_seq *s, void *data,
>  		     struct tep_format_field *field);
> +void tep_print_selected_fields(struct trace_seq *s, void *data,
> +			       struct tep_event *event,
> +			       unsigned long long ignore_mask);
>  void tep_print_fields(struct trace_seq *s, void *data,
>  		      int size __maybe_unused, struct tep_event *event);
>  int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,

