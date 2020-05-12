Return-Path: <SRS0=k6k0=62=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7B1C54E8D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 May 2020 14:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4575220752
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 May 2020 14:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbgELO0O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 May 2020 10:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730192AbgELO0N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 May 2020 10:26:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE9DE20673;
        Tue, 12 May 2020 14:26:12 +0000 (UTC)
Date:   Tue, 12 May 2020 10:26:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] trace-cmd: Add support for more printk format
 specifiers
Message-ID: <20200512102611.62504f3d@gandalf.local.home>
In-Reply-To: <20200508094547.2420964-1-tz.stoyanov@gmail.com>
References: <20200508094547.2420964-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 May 2020 12:45:47 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

Hi Tzvetomir,

First, please add some blank lines in the change log. It gets a bit run-on,
and hard to read without them.

> The printk format specifiers used in event's print format files extend
> the standard printf formats. There are a lot of new options related to
> printing pointers and kernel specific structures. Currently trace-cmd
> does not support many of them.

<blank line here>

> Support for these new printk specifiers is added to the pretty_print()
> function:
>  - UUID/GUID address: %pU[bBlL]
>  - Raw buffer as a hex string: %*ph[CDN]

<blank line here>

> add these ones are improved:

s/add these ones are improved:/These are improved:/

>  - MAC address: %pMF, %pM and %pmR
>  - IPv4 adderss: %p[Ii]4[hnbl]

<blank line here>

> Function pretty_print() is refactored. The logic for printing pointers
> %p[...] is moved to its own function.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207605
> Reported-by: Johannes Berg <johannes@sipsolutions.net>

Also, its good to include anyone listed in the tags in the Cc of the patch.
I added Johannes here.

> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/traceevent/event-parse.c | 363 ++++++++++++++++++++++++++++-------
>  1 file changed, 289 insertions(+), 74 deletions(-)
> 
> diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
> index 064c100d..879e4bf8 100644
> --- a/lib/traceevent/event-parse.c
> +++ b/lib/traceevent/event-parse.c
> @@ -4510,43 +4510,93 @@ get_bprint_format(void *data, int size __maybe_unused,
>  	return format;
>  }
>  
> -static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
> -			  struct tep_event *event, struct tep_print_arg *arg)
> +static int print_mac_arg(struct trace_seq *s, const char *format,
> +			 void *data, int size, struct tep_event *event,
> +			 struct tep_print_arg *arg)
>  {
> -	unsigned char *buf;
>  	const char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
> +	unsigned char *buf;
> +	int ret = 0;
> +	bool reverse = false;

Upside-down x-mas tree please ;-)

	const char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
	bool reverse = false;
	unsigned char *buf;
	int ret = 0;

>  
>  	if (arg->type == TEP_PRINT_FUNC) {
>  		process_defined_func(s, data, size, event, arg);
> -		return;
> +		return 0;
>  	}
>  
>  	if (arg->type != TEP_PRINT_FIELD) {
>  		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d",
>  				 arg->type);
> -		return;
> +		return 0;
>  	}
>  
> -	if (mac == 'm')
> +	if (*format == 'm')
>  		fmt = "%.2x%.2x%.2x%.2x%.2x%.2x";
> +

Make the condition below "else if" as it's a bit better code generation,
and also comments to the reader of the code that only one of these can be
true.

> +	if (format[1] == 'F' && *format == 'M') {

If using "format[1]" then please use "format[0]" instead of *format. And
you can swap them as well:

	if (format[0] == 'M' && format[1] == 'F') {

As then the reader can see this would be if the format started with "MF".


> +		fmt = "%.2x-%.2x-%.2x-%.2x-%.2x-%.2x";
> +		ret++;
> +	}


> +	if (format[1] == 'R') {
> +		reverse = true;
> +		ret++;
> +	}
> +
>  	if (!arg->field.field) {
>  		arg->field.field =
>  			tep_find_any_field(event, arg->field.name);
>  		if (!arg->field.field) {
>  			do_warning_event(event, "%s: field %s not found",
>  					 __func__, arg->field.name);
> -			return;
> +			return ret;
>  		}
>  	}
>  	if (arg->field.field->size != 6) {
>  		trace_seq_printf(s, "INVALIDMAC");
> -		return;
> +		return ret;
>  	}
> +
>  	buf = data + arg->field.field->offset;
> -	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
> +	if (reverse)
> +		trace_seq_printf(s, fmt, buf[5], buf[4], buf[3], buf[2], buf[1], buf[0]);
> +	else
> +		trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5]);
> +
> +	return ret;
>  }
>  
> -static void print_ip4_addr(struct trace_seq *s, char i, unsigned char *buf)
> +static int parse_ip4_print_args(const char *ptr, bool *reverse)
> +{
> +	int ret = 0;
> +
> +	*reverse = false;
> +
> +	/* hnbl */
> +	switch (*ptr) {
> +	case 'h':
> +#ifdef __BIG_ENDIAN

Do we care what the machine is? Shouldn't this be checking if the file is
big endian or not?

I'll wait for a v2 and then start testing it.

Thanks Ceco!

-- Steve

> +		*reverse = false;
> +#else
> +		*reverse = true;
> +#endif
> +		ret++;
> +	break;
> +	case 'l':
> +		*reverse = true;
> +		ret++;
> +	break;
> +	case 'n':
> +	case 'b':
> +		ret++;
> +		/* fall through */
> +	default:
> +		*reverse = false;
> +		break;
> +	}
> +
> +	return ret;
> +}

