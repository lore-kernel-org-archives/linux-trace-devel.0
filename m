Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7231C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 951D920850
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 22:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfDKWjj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 18:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfDKWji (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 18:39:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFC5120850;
        Thu, 11 Apr 2019 22:39:36 +0000 (UTC)
Date:   Thu, 11 Apr 2019 18:39:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@chromium.org, zwisler@chromium.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v1 1/4] trace_events: Add trace_print_register to print
 register fields
Message-ID: <20190411183934.28e6ad65@gandalf.local.home>
In-Reply-To: <20190411220822.81845-2-rrangel@chromium.org>
References: <20190411220822.81845-1-rrangel@chromium.org>
        <20190411220822.81845-2-rrangel@chromium.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Apr 2019 16:08:19 -0600
Raul E Rangel <rrangel@chromium.org> wrote:

> This is a hybrid method that combines the functionality of
> trace_print_flags_seq and trace_print_symbols_seq. It supports printing
> bit fields, enum fields, and numeric fields.
> 
> Given the following register definition:
>   * 0   - Enabled
>   * 1   - Width, 0 = 1-bits, 1 = 4-bits
>   * 2:3 - DMA, 0 = None, 1 = SDMA, 2 = ADMA, 3 = ADMA2
>   * 4:7 - Timeout Counter
> 
> The register fields could be defined as follows:
> 
>   const struct trace_print_field reg[] = {
>     {1<<0, "ENABLED"},
>     {
>       .mask = 1<<1,
>       .name = "WIDTH",
>       .symbols = (const struct trace_print_flags[]) {
>         {0, "1-BIT"},
>         {1, "4-BIT"},
>         {}
>       }
>     }, {
>       .mask = 3<<2,
>       .symbols = (const struct trace_print_flags[]) {
>         {0, "NONE"},
>         {1, "SDMA"},
>         {2, "ADMA"},
>         {3, "ADMA2"},
>         {}
>       }
>     },
>     {0xF<<4, "TIMEOUT"}
>   }
> 
> This would print out the following given value 0xAB:
> 
> ENABLED: 1 | WIDTH: 4-BIT | ADMA | TIMEOUT: 0xA
> 

Note the rational for the __print_symbolic and __print_flags is that
they show how to translate into something that perf and trace-cmd can
read from userspace.

How does perf or trace-cmd parse this? To add something like this, you
need them to have the same output as what is displayed by the trace
file otherwise NAK.

-- Steve


> See https://pastebin.com/x73d5cvL for this in action.
> 
> Signed-off-by: Raul E Rangel <rrangel@chromium.org>
> ---
> 
>  include/linux/trace_events.h    |   4 ++
>  include/linux/tracepoint-defs.h |   6 ++
>  include/trace/trace_events.h    |   9 +++
>  kernel/trace/trace_output.c     | 121 ++++++++++++++++++++++++++++++++
>  4 files changed, 140 insertions(+)
> 
> diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
> index 8a62731673f7..3c44909ce8b3 100644
> --- a/include/linux/trace_events.h
> +++ b/include/linux/trace_events.h
> @@ -23,6 +23,10 @@ const char *trace_print_flags_seq(struct trace_seq *p, const char *delim,
>  const char *trace_print_symbols_seq(struct trace_seq *p, unsigned long val,
>  				    const struct trace_print_flags *symbol_array);
>  
> +const char *trace_print_register(struct trace_seq *p,
> +				 const struct trace_print_field fields[],
> +				 unsigned long val, unsigned long mask);
> +
>  #if BITS_PER_LONG == 32
>  const char *trace_print_flags_seq_u64(struct trace_seq *p, const char *delim,
>  		      unsigned long long flags,
> diff --git a/include/linux/tracepoint-defs.h b/include/linux/tracepoint-defs.h
> index 49ba9cde7e4b..c3dc27c192f4 100644
> --- a/include/linux/tracepoint-defs.h
> +++ b/include/linux/tracepoint-defs.h
> @@ -16,6 +16,12 @@ struct trace_print_flags {
>  	const char		*name;
>  };
>  
> +struct trace_print_field {
> +	unsigned long			mask;
> +	const char			*name;
> +	const struct trace_print_flags	*symbols;
> +};
> +
>  struct trace_print_flags_u64 {
>  	unsigned long long	mask;
>  	const char		*name;
> diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
> index 4ecdfe2e3580..6adc32fcb1c3 100644
> --- a/include/trace/trace_events.h
> +++ b/include/trace/trace_events.h
> @@ -300,6 +300,14 @@ TRACE_MAKE_SYSTEM_STR();
>  		trace_print_symbols_seq(p, value, symbols);		\
>  	})
>  
> +#undef __print_register
> +#define __print_register(value, mask, field_array...)			\
> +	({								\
> +		static const struct trace_print_field fields[] =	\
> +			{ field_array, {} };			\
> +		trace_print_register(p, value, mask, fields);		\
> +	})
> +
>  #undef __print_flags_u64
>  #undef __print_symbolic_u64
>  #if BITS_PER_LONG == 32
> @@ -744,6 +752,7 @@ static inline void ftrace_test_probe_##call(void)			\
>  
>  #undef __print_flags
>  #undef __print_symbolic
> +#undef __print_register
>  #undef __print_hex
>  #undef __print_hex_str
>  #undef __get_dynamic_array
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 54373d93e251..cd5727ad54c3 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -124,6 +124,127 @@ trace_print_symbols_seq(struct trace_seq *p, unsigned long val,
>  }
>  EXPORT_SYMBOL(trace_print_symbols_seq);
>  
> +/**
> + * trace_print_register - Prints all the fields of a register.
> + *
> + * This is a hybrid method that combines the functionality of
> + * trace_print_flags_seq and trace_print_symbols_seq. It supports printing
> + * bit fields, enum fields, and numeric fields.
> + *
> + * Given the following register definition:
> + *   * 0   - Enabled
> + *   * 1   - Width, 0 = 1-bits, 1 = 4-bits
> + *   * 2:3 - DMA, 0 = None, 1 = SDMA, 2 = ADMA, 3 = ADMA2
> + *   * 4:7 - Timeout Counter
> + *
> + * The register fields could be defined as follows:
> + *
> + *   const struct trace_print_field reg[] = {
> + *     {1<<0, "ENABLED"},
> + *     {
> + *       .mask = 1<<1,
> + *       .name = "WIDTH",
> + *       .symbols = (const struct trace_print_flags[]) {
> + *         {0, "1-BIT"},
> + *         {1, "4-BIT"},
> + *         {}
> + *       }
> + *     }, {
> + *       .mask = 3<<2,
> + *       .symbols = (const struct trace_print_flags[]) {
> + *         {0, "NONE"},
> + *         {1, "SDMA"},
> + *         {2, "ADMA"},
> + *         {3, "ADMA2"},
> + *         {}
> + *       }
> + *     },
> + *     {0xF<<4, "TIMEOUT"}
> + *   }
> + *
> + * This would print out the following given value 0xAB:
> + *
> + * ENABLED: 1 | WIDTH: 4-BIT | ADMA | TIMEOUT: 0xA
> + *
> + * @p: trace buffer
> + * @fields: Array of fields that describe the register. Must be terminated with
> + *          an empty value.
> + * @val: register value
> + * @mask: Mask that defines the bits present in @val. Useful if only a subset
> + *        of the register was read. Any fields that fall outside of the mask
> + *        will not be printed.
> + */
> +const char *trace_print_register(struct trace_seq *p,
> +				 const struct trace_print_field fields[],
> +				 unsigned long val, unsigned long mask)
> +{
> +	const char *ret = trace_seq_buffer_ptr(p);
> +	char *tail;
> +	unsigned long fval;
> +	int first = 1, symbol_found;
> +	const struct trace_print_field *field;
> +	const struct trace_print_flags *symbol;
> +
> +	for (field = fields; field->mask; field++) {
> +		/* Make sure the field mask is within the accessed bits */
> +		if ((mask & field->mask) != field->mask)
> +			continue;
> +
> +		if (!first)
> +			trace_seq_puts(p, " | ");
> +
> +		first = 0;
> +
> +		if (field->name) {
> +			trace_seq_puts(p, field->name);
> +			trace_seq_puts(p, ": ");
> +		}
> +
> +		fval = val & field->mask;
> +		fval >>= ffs(field->mask) - 1;
> +
> +		val &= ~field->mask;
> +
> +		symbol_found = 0;
> +		for (symbol = field->symbols; symbol && symbol->name;
> +		     symbol++) {
> +			if (symbol->mask != fval)
> +				continue;
> +			trace_seq_puts(p, symbol->name);
> +			symbol_found = 1;
> +			break;
> +		}
> +
> +		if (!symbol_found) {
> +			if (fval == 0) {
> +				trace_seq_puts(p, "0");
> +			} else if (fval == 1) {
> +				trace_seq_puts(p, "1");
> +			} else {
> +				trace_seq_printf(p, "%#x", fval);
> +
> +				/* Strip off the null terminator */
> +				for (tail = trace_seq_buffer_ptr(p) - 1;
> +				     tail > ret && !*tail; tail--) {
> +					p->seq.len--;
> +				}
> +			}
> +		}
> +	}
> +
> +	/* Print any left over bits */
> +	if (val) {
> +		if (!first)
> +			trace_seq_puts(p, " | ");
> +		trace_seq_printf(p, "%#x", val);
> +	}
> +
> +	trace_seq_putc(p, 0);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(trace_print_register);
> +
>  #if BITS_PER_LONG == 32
>  const char *
>  trace_print_flags_seq_u64(struct trace_seq *p, const char *delim,

