Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C675BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 16:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFE7610A5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 16:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhHSQsx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 12:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230472AbhHSQsw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 12:48:52 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8832610CE;
        Thu, 19 Aug 2021 16:48:15 +0000 (UTC)
Date:   Thu, 19 Aug 2021 12:48:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 3/5] libtraceevent: Improve tep_print_field()
Message-ID: <20210819124809.6e789f1a@oasis.local.home>
In-Reply-To: <20210812085929.54832-4-y.karadz@gmail.com>
References: <20210812085929.54832-1-y.karadz@gmail.com>
        <20210812085929.54832-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 11:59:27 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The existing method tep_print_fields() gets upgraded to use the
> printing formats provided by the tokens.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/event-parse.c | 115 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 87 insertions(+), 28 deletions(-)
> 
> diff --git a/src/event-parse.c b/src/event-parse.c
> index 02ec677..ff7337f 100644
> --- a/src/event-parse.c
> +++ b/src/event-parse.c
> @@ -3913,7 +3913,6 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
>  			arg->field.field = tep_find_any_field(event, arg->field.name);
>  			if (!arg->field.field)
>  				goto out_warning_field;
> -			
>  		}
>  		/* must be a number */
>  		val = tep_read_number(tep, data + arg->field.field->offset,
> @@ -5326,8 +5325,8 @@ static int is_printable_array(char *p, unsigned int len)
>  	return 1;
>  }
>  
> -void tep_print_field(struct trace_seq *s, void *data,
> -		     struct tep_format_field *field)
> +static void tep_print_field_raw(struct trace_seq *s, void *data,
> +			     struct tep_format_field *field)

As this is static, lets call it just "print_field_raw()" as the "tep_"
prefix should be reserved for the API only.

We may need to clean up any existing static function that start with
"tep_", but that can be a separate patch (if any exist, I haven't
looked). But let's not add new ones.

-- Steve



>  {
>  	struct tep_handle *tep = field->event->tep;
>  	unsigned int offset, len, i;
> @@ -5389,6 +5388,56 @@ void tep_print_field(struct trace_seq *s, void *data,
>  	}
>  }
>  
> +static int print_parse_data(struct tep_print_parse *parse, struct trace_seq *s,
> +			    void *data, int size, struct tep_event *event);
> +
> +void tep_print_field(struct trace_seq *s, void *data,
> +		     struct tep_format_field *field)
> +{
> +	struct tep_event *event = field->event;
> +	struct tep_print_parse *parse;
> +	bool has_0x;
> +
> +
