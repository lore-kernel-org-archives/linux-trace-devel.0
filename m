Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 794AAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Sep 2021 20:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5922A6115C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Sep 2021 20:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241581AbhIHUFk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Sep 2021 16:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230044AbhIHUFk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 16:05:40 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 216D061078;
        Wed,  8 Sep 2021 20:04:32 +0000 (UTC)
Date:   Wed, 8 Sep 2021 16:04:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 3/4] libtraceevent: Add APIs for printing the fields
 of a record
Message-ID: <20210908160425.2ed9ec07@oasis.local.home>
In-Reply-To: <20210823095618.138887-4-y.karadz@gmail.com>
References: <20210823095618.138887-1-y.karadz@gmail.com>
        <20210823095618.138887-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 23 Aug 2021 12:56:17 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The new methods can print all unique data fielsd, or only a subset of
> the fields of the trace event. The print format is derived from the
> parsing tokens (tep_print_parse objects) of the event.

The more I look at this, the more I think we should have a
"selected_fields" mask, and not a ignored mask. At least for the API.
The internal functions can stay the same. That is, the internal
functions have the ignored_mask.

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---


> +/**
> + * tep_record_print_selected_fields - print the field name followed by the

I think the above should be "tep_record_print_fields" ?

> + * record's field value for a selected subset of record fields.
> + * @s: The seq to print to
> + * @record: The record to get the event from
> + * @event: The event that the field is for
> + */
> +void tep_record_print_fields(struct trace_seq *s,
> +			     struct tep_record *record,
> +			     struct tep_event *event)
> +{
> +	print_selected_fields(s, record->data, event, 0);
> +}
> +
> +/**
> + * tep_record_print_selected_fields - print the field name followed by the
> + * record's field value for a selected subset of record fields.
> + * @s: The seq to print to
> + * @record: The record to get the event from
> + * @event: The event that the field is for
> + * @ignore_mask: Bit mask defining the fields to be ignored

change to:

      @select_mask: Bit mask defining the fields to record

> + */
> +void tep_record_print_selected_fields(struct trace_seq *s,
> +				      struct tep_record *record,
> +				      struct tep_event *event,
> +				      unsigned long long ignore_mask)

				      unsigned long long select_mask)

> +{

Since print_selected_fields() will still have the ignore_mask, you can
have:

	unsigned long long ignore_mask = ~select_mask;


> +	print_selected_fields(s, record->data, event, ignore_mask);

The above would remain the same.

-- Steve

> +}
> +
>  static int print_function(struct trace_seq *s, const char *format,
>  			  void *data, int size, struct tep_event
> *event, struct tep_print_arg *arg)
> diff --git a/src/event-parse.h b/src/event-parse.h
> index d4a876f..08dcbd8 100644
> --- a/src/event-parse.h
> +++ b/src/event-parse.h
> @@ -545,6 +545,13 @@ int tep_cmdline_pid(struct tep_handle *tep,
> struct tep_cmdline *cmdline); 
>  void tep_print_field(struct trace_seq *s, void *data,
>  		     struct tep_format_field *field);
> +void tep_record_print_fields(struct trace_seq *s,
> +			     struct tep_record *record,
> +			     struct tep_event *event);
> +void tep_record_print_selected_fields(struct trace_seq *s,
> +				      struct tep_record *record,
> +				      struct tep_event *event,
> +				      unsigned long long
> ignore_mask); void tep_print_fields(struct trace_seq *s, void *data,
>  		      int size __maybe_unused, struct tep_event
> *event); int tep_strerror(struct tep_handle *tep, enum tep_errno
> errnum,

