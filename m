Return-Path: <SRS0=Ttn5=65=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C0CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 01:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D169C20709
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 May 2020 01:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgEOBON (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 May 2020 21:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgEOBON (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 May 2020 21:14:13 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 596EB206D8;
        Fri, 15 May 2020 01:14:12 +0000 (UTC)
Date:   Thu, 14 May 2020 21:14:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Optimize pretty_print() function
Message-ID: <20200514211410.0362161b@oasis.local.home>
In-Reply-To: <20200514071243.2396492-1-tz.stoyanov@gmail.com>
References: <20200514071243.2396492-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 May 2020 10:12:43 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static int parse_arg_format_pointer(const char *format)
> +{
> +	int ret = 0;
> +	int index;
> +	int loop;
> +
> +	switch (*format) {
> +	case 'F':
> +	case 'S':
> +	case 'f':
> +	case 's':
> +		ret++;
> +		break;
> +	case 'M':
> +		/* MF */
> +		if (format[1] == 'F')
> +			ret++;
> +		/* fall through */

Note, this fall through, will process "%pMFR"


> +	case 'm':
> +		/* [mM]R */

Also, looking at lib/vsprintf.c in the Linux kernel, it appears that it
accepts "mF" as well.

> +		if (format[1] == 'R')
> +			ret++;
> +		ret++;
> +		break;
> +	case 'I':
> +	case 'i':
> +		index = 2;
> +		loop = 1;
> +		switch (format[1]) {
> +		case 'S':
> +			/*[S][pfs]*/
> +			while (loop) {
> +				switch (format[index]) {
> +				case 'p':
> +				case 'f':
> +				case 's':
> +					ret++;
> +					index++;
> +					break;
> +				default:
> +					loop = 0;
> +				}
> +			}
> +			/* fall through */
> +		case '4':
> +			/* [4S][hnbl] */
> +			switch (format[index]) {
> +			case 'h':
> +			case 'n':
> +			case 'l':
> +			case 'b':
> +				ret++;
> +				index++;
> +				break;
> +			}
> +			if (format[1] == '4') {
> +				ret++;
> +				break;
> +			}
> +			/* fall through */
> +		case '6':
> +			/* [6S]c */
> +			if (format[index] == 'c') {
> +				ret++;
> +				index++;

This index update seems pointless. It's not referenced after the two
breaks below.

> +			}
> +			ret++;
> +			break;
> +		}
> +		ret++;
> +		break;
> +	case 'U':
> +		switch (format[1]) {
> +		case 'L':
> +		case 'l':
> +		case 'B':
> +		case 'b':
> +			ret++;
> +			break;
> +		}
> +		ret++;
> +		break;
> +	case 'h':
> +		switch (format[1]) {
> +		case 'C':
> +		case 'D':
> +		case 'N':
> +			ret++;
> +			break;
> +		}
> +		ret++;
> +		break;
> +	default:
> +		break;
>  	}
>  
> -	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
> -		bprint_fmt = get_bprint_format(data, size, event);
> -		args = make_bprint_args(bprint_fmt, data, size,
> event);
> -		arg = args;
> -		ptr = bprint_fmt;
> +	return ret;
> +}
> +
> +static void free_parse_args(struct tep_print_parse *arg)
> +{
> +	struct tep_print_parse *del;
> +
> +	while (arg) {
> +		del = arg;
> +		arg = del->next;
> +		free(del->format);
> +		free(del);
>  	}
> +}
>  
> -	for (; *ptr; ptr++) {
> -		ls = 0;
> -		if (*ptr == '\\') {
> -			ptr++;
> -			switch (*ptr) {
> +static int parse_arg_add(struct tep_print_parse **parse, char
> *format,
> +			 enum tep_print_parse_type type,
> +			 struct tep_print_arg *arg,
> +			 struct tep_print_arg *len_as_arg,
> +			 int ls)
> +{
> +	struct tep_print_parse *parg = NULL, *last;
> +
> +	parg = calloc(1, sizeof(*parg));
> +	if (!parg)
> +		goto error;
> +	parg->format = strdup(format);
> +	if (!parg->format)
> +		goto error;
> +	parg->type = type;
> +	parg->arg = arg;
> +	parg->len_as_arg = len_as_arg;
> +	parg->ls = ls;
> +
> +	last = *parse;
> +	if (last) {
> +		while (last->next)
> +			last = last->next;
> +		last->next = parg;
> +	} else
> +		*parse = parg;
> +
> +	return 0;
> +error:
> +	if (parg) {
> +		free(parg->format);
> +		free(parg);
> +	}
> +	return -1;
> +}
> +
> +static int parse_arg_format(struct tep_print_parse **parse,
> +			    struct tep_event *event,
> +			    const char *format, struct tep_print_arg
> **arg) +{
> +	struct tep_print_arg *len_arg = NULL;
> +	char print_format[32];
> +	const char *start = format;
> +	int ret = 0;
> +	int ls = 0;
> +	int res;
> +	int len;
> +
> +	if (*format != '%')
> +		return ret;
> +	format++;
> +
> +	/* %% */
> +	if (*format == '%')
> +		return ret;

The above two checks for '%' isn't needed as it is checked by the
caller. If for some reason that the caller didn't catch it, and we
return here,  it would return zero and the calling loop would never
proceed. It's not protecting anything, I would just remove these two
checks.

> +	ret++;
> +
> +	for (; *format; format++) {
> +		switch (*format) {
> +		case '#':
> +			/* FIXME: need to handle properly */
> +			break;
> +		case 'h':
> +			ls--;
> +			break;
> +		case 'l':
> +			ls++;
> +			break;
> +		case 'L':
> +			ls = 2;
> +			break;
> +		case '.':
> +		case 'z':
> +		case 'Z':
> +		case '0' ... '9':
> +		case '-':
> +			break;
> +		case '*':
> +			/* The argument is the length. */
> +			if (!arg) {
> +				do_warning_event(event, "no argument match");
> +				event->flags |= TEP_EVENT_FL_FAILED;
> +				goto out_failed;
> +			}

Since all cases to exit this loop do the same check, I think we can
move this check before the loop. The old code didn't do this check
properly for %p, but that was a bug in the old code.


> +			len_arg = *arg;

Perhaps we should fail and warn if len_arg is already set?

> +			*arg = (*arg)->next;
> +			break;
> +		case 'p':
> +			if (!*arg)
> +				goto out_failed;
> +			res = parse_arg_format_pointer(format + 1);
> +			if (res > 0) {
> +				format += res;
> +				ret += res;
> +			}
> +			len = ((unsigned long)format + 1) -
> +				(unsigned long)start;
> +			/* should never happen */
> +			if (len > 31) {
> +				do_warning_event(event, "bad format!");
> +				event->flags |= TEP_EVENT_FL_FAILED;
> +				len = 31;
> +			}
> +			memcpy(print_format, start, len);
> +			print_format[len] = 0;
> +
> +			parse_arg_add(parse, print_format,
> +				      PRINT_FMT_ARG_POINTER, *arg, len_arg, ls);
> +			*arg = (*arg)->next;
> +			ret++;
> +			return ret;
> +		case 'd':
> +		case 'u':
> +		case 'i':
> +		case 'x':
> +		case 'X':
> +		case 'o':
> +			if (!arg) {
> +				do_warning_event(event, "no argument match");
> +				event->flags |= TEP_EVENT_FL_FAILED;
> +				goto out_failed;
> +			}
> +
> +			len = ((unsigned long)format + 1) -
> +				(unsigned long)start;
> +
> +			/* should never happen */
> +			if (len > 31) {
> +				do_warning_event(event, "bad format!");
> +				event->flags |= TEP_EVENT_FL_FAILED;
> +				len = 31;
> +			}
> +			memcpy(print_format, start, len);
> +			print_format[len] = 0;
> +
> +			if (event->tep->long_size == 8 && ls == 1 &&
> +			    sizeof(long) != 8) {
> +				char *p;
> +
> +				/* make %l into %ll */
> +				if (ls == 1 && (p = strchr(print_format, 'l')))
> +					memmove(p+1, p, strlen(p)+1);

I just realized that this can cause us to overflow, as we just
increased the size of the print_format. Probably should change the 31
to 30 above to be safe. This is a bug in the current code.


> +				ls = 2;
> +			}
> +			if (ls < -2 || ls > 2) {
> +				do_warning_event(event, "bad count (%d)", ls);
> +				event->flags |= TEP_EVENT_FL_FAILED;
> +			}
> +			parse_arg_add(parse, print_format,
> +				      PRINT_FMT_ARG_DIGIT, *arg, len_arg, ls);
> +			*arg = (*arg)->next;
> +			ret++;
> +			return ret;
> +		case 's':
> +			if (!arg) {
> +				do_warning_event(event, "no matching argument");
> +				event->flags |= TEP_EVENT_FL_FAILED;
> +				goto out_failed;
> +			}
> +
> +			len = ((unsigned long)format + 1) -
> +				(unsigned long)start;
> +
> +			/* should never happen */
> +			if (len > 31) {
> +				do_warning_event(event, "bad format!");
> +				event->flags |= TEP_EVENT_FL_FAILED;
> +				len = 31;
> +			}
> +
> +			memcpy(print_format, start, len);
> +			print_format[len] = 0;
> +
> +			parse_arg_add(parse, print_format,
> +					PRINT_FMT_ARG_STRING, *arg, len_arg, 0);
> +			*arg = (*arg)->next;
> +			ret++;
> +			return ret;
> +		default:
> +			snprintf(print_format, 32, ">%c<", *format);
> +			parse_arg_add(parse, print_format,
> +					PRINT_FMT_STING, NULL, NULL, 0);
> +			ret++;
> +			return ret;
> +		}
> +		ret++;
> +	}
> +
> +	return ret;
> +out_failed:
> +	return -1;

Hmm, a return of -1 isn't checked by the caller, and can cause the loop
to be unpredictable.

-- Steve


> +}
> +
> +static int parse_arg_string(struct tep_print_parse **parse, const char *format)
> +{
> +	struct trace_seq s;
> +	int ret = 0;
> +
> +	trace_seq_init(&s);
> +	for (; *format; format++) {
> +		if (*format == '\\') {
> +			format++;
> +			ret++;
> +			switch (*format) {
>  			case 'n':
> -				trace_seq_putc(s, '\n');
> +				trace_seq_putc(&s, '\n');
>  				break;
>  			case 't':
> -				trace_seq_putc(s, '\t');
> +				trace_seq_putc(&s, '\t');
>  				break;
>  			case 'r':
> -				trace_seq_putc(s, '\r');
> +				trace_seq_putc(&s, '\r');
>  				break;
>  			case '\\':
> -				trace_seq_putc(s, '\\');
> +				trace_seq_putc(&s, '\\');
>  				break;
>  			default:
> -				trace_seq_putc(s, *ptr);
> +				trace_seq_putc(&s, *format);
>  				break;
>  			}
> -
> -		} else if (*ptr == '%') {
> -			saveptr = ptr;
> -			len_as_arg = 0;
> - cont_process:
> -			ptr++;
> -			switch (*ptr) {
> -			case '%':
> -				trace_seq_putc(s, '%');
> -				break;
> -			case '#':
> -				/* FIXME: need to handle properly */
> -				goto cont_process;
> -			case 'h':
> -				ls--;
> -				goto cont_process;
> -			case 'l':
> -				ls++;
> -				goto cont_process;
> -			case 'L':
> -				ls = 2;
> -				goto cont_process;
> -			case '*':
> -				/* The argument is the length. */
> -				if (!arg) {
> -					do_warning_event(event, "no argument match");
> -					event->flags |= TEP_EVENT_FL_FAILED;
> -					goto out_failed;
> -				}
> -				len_arg = eval_num_arg(data, size, event, arg);
> -				len_as_arg = 1;
> -				arg = arg->next;
> -				goto cont_process;
> -			case '.':
> -			case 'z':
> -			case 'Z':
> -			case '0' ... '9':
> -			case '-':
> -				goto cont_process;
> -			case 'p':
> -				if (arg->type == TEP_PRINT_BSTRING) {
> -					if (isalnum(ptr[1]))
> -						ptr++;
> -					trace_seq_puts(s, arg->string.string);
> -					arg = arg->next;
> -					break;
> -				}
> -				ret = print_pointer(s, ptr + 1,
> -						    len_as_arg ? len_arg : 1,
> -						    data, size,
> -						    event, arg);
> -				arg = arg->next;
> -				if (ret > 0)
> -					ptr += ret;
> +		} else if (*format == '%') {
> +			if (*(format + 1) == '%') {
> +				trace_seq_putc(&s, '%');
> +				format++;
> +				ret++;
> +			} else
>  				break;
> -			case 'd':
> -			case 'u':
> -			case 'i':
> -			case 'x':
> -			case 'X':
> -			case 'o':
> -				if (!arg) {
> -					do_warning_event(event, "no argument match");
> -					event->flags |= TEP_EVENT_FL_FAILED;
> -					goto out_failed;
> -				}
> -
> -				len = ((unsigned long)ptr + 1) -
> -					(unsigned long)saveptr;
> -
> -				/* should never happen */
> -				if (len > 31) {
> -					do_warning_event(event, "bad format!");
> -					event->flags |= TEP_EVENT_FL_FAILED;
> -					len = 31;
> -				}
> -
> -				memcpy(format, saveptr, len);
> -				format[len] = 0;
> -
> -				val = eval_num_arg(data, size, event, arg);
> -				arg = arg->next;
> +		} else
> +			trace_seq_putc(&s, *format);
>  
> -				if (tep->long_size == 8 && ls == 1 &&
> -				    sizeof(long) != 8) {
> -					char *p;
> +		ret++;
> +	}
> +	trace_seq_terminate(&s);
> +	parse_arg_add(parse, s.buffer, PRINT_FMT_STING, NULL, NULL, 0);
> +	trace_seq_destroy(&s);
>  
> -					/* make %l into %ll */
> -					if (ls == 1 && (p = strchr(format, 'l')))
> -						memmove(p+1, p, strlen(p)+1);
> -					ls = 2;
> -				}
> -				switch (ls) {
> -				case -2:
> -					if (len_as_arg)
> -						trace_seq_printf(s, format, len_arg, (char)val);
> -					else
> -						trace_seq_printf(s, format, (char)val);
> -					break;
> -				case -1:
> -					if (len_as_arg)
> -						trace_seq_printf(s, format, len_arg, (short)val);
> -					else
> -						trace_seq_printf(s, format, (short)val);
> -					break;
> -				case 0:
> -					if (len_as_arg)
> -						trace_seq_printf(s, format, len_arg, (int)val);
> -					else
> -						trace_seq_printf(s, format, (int)val);
> -					break;
> -				case 1:
> -					if (len_as_arg)
> -						trace_seq_printf(s, format, len_arg, (long)val);
> -					else
> -						trace_seq_printf(s, format, (long)val);
> -					break;
> -				case 2:
> -					if (len_as_arg)
> -						trace_seq_printf(s, format, len_arg,
> -								 (long long)val);
> -					else
> -						trace_seq_printf(s, format, (long long)val);
> -					break;
> -				default:
> -					do_warning_event(event, "bad count (%d)", ls);
> -					event->flags |= TEP_EVENT_FL_FAILED;
> -				}
> -				break;
> -			case 's':
> -				if (!arg) {
> -					do_warning_event(event, "no matching argument");
> -					event->flags |= TEP_EVENT_FL_FAILED;
> -					goto out_failed;
> -				}
> +	return ret;
> +}
>  
> -				len = ((unsigned long)ptr + 1) -
> -					(unsigned long)saveptr;
> +static struct tep_print_parse *
> +parse_args(struct tep_event *event, const char *format, struct tep_print_arg *arg)
> +{
> +	struct tep_print_parse *parse = NULL;
> +	int ret;
> +	int len;
>  
> -				/* should never happen */
> -				if (len > 31) {
> -					do_warning_event(event, "bad format!");
> -					event->flags |= TEP_EVENT_FL_FAILED;
> -					len = 31;
> -				}
> +	len = strlen(format);
> +	while (*format) {
> +		if (*format == '%' && *(format + 1) != '%')
> +			ret = parse_arg_format(&parse, event, format, &arg);
> +		else
> +			ret = parse_arg_string(&parse, format);
> +		len -= ret;
> +		if (len > 0)
> +			format += ret;
> +		else
> +			break;
> +	}
> +	return parse;
> +}
>  
> -				memcpy(format, saveptr, len);
> -				format[len] = 0;
> -				if (!len_as_arg)
> -					len_arg = -1;
> -				/* Use helper trace_seq */
> -				trace_seq_init(&p);
> -				print_str_arg(&p, data, size, event,
> -					      format, len_arg, arg);
> -				trace_seq_terminate(&p);
> -				trace_seq_puts(s, p.buffer);
> -				trace_seq_destroy(&p);
> -				arg = arg->next;
> -				break;
> -			default:
> -				trace_seq_printf(s, ">%c<", *ptr);
> +static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s,
> +			      void *data, int size, struct tep_event *event)
> +{
> +	int len_arg;
>  
> -			}
> -		} else
> -			trace_seq_putc(s, *ptr);
> +	while (parse) {
> +		if (parse->len_as_arg)
> +			len_arg = eval_num_arg(data, size, event, parse->len_as_arg);
> +		switch (parse->type) {
> +		case PRINT_FMT_ARG_DIGIT:
> +			print_arg_number(s, parse->format,
> +					parse->len_as_arg ? len_arg : -1, data,
> +					 size, parse->ls, event, parse->arg);
> +			break;
> +		case PRINT_FMT_ARG_POINTER:
> +			print_arg_pointer(s, parse->format,
> +					  parse->len_as_arg ? len_arg : 1,
> +					  data, size, event, parse->arg);
> +			break;
> +		case PRINT_FMT_ARG_STRING:
> +			print_arg_string(s, parse->format,
> +					 parse->len_as_arg ? len_arg : -1,
> +					 data, size, event, parse->arg);
> +			break;
> +		case PRINT_FMT_STING:
> +		default:
> +			trace_seq_printf(s, "%s", parse->format);
> +			break;
> +		}
> +		parse = parse->next;
>  	}
> +}
> +
> +static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event *event)
> +{
> +	struct tep_print_parse *parse = event->print_fmt.print_cache;
> +	struct tep_print_arg *args = NULL;
> +	char *bprint_fmt = NULL;
>  
>  	if (event->flags & TEP_EVENT_FL_FAILED) {
> -out_failed:
>  		trace_seq_printf(s, "[FAILED TO PARSE]");
> +		tep_print_fields(s, data, size, event);
> +		return;
>  	}
>  
> -	if (args) {
> +	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
> +		bprint_fmt = get_bprint_format(data, size, event);
> +		args = make_bprint_args(bprint_fmt, data, size, event);
> +		parse = parse_args(event, bprint_fmt, args);
> +	}
> +
> +	print_event_cache(parse, s, data, size, event);
> +
> +	if (event->flags & TEP_EVENT_FL_ISBPRINT) {
> +		free_parse_args(parse);
>  		free_args(args);
>  		free(bprint_fmt);
>  	}
> @@ -6526,9 +6802,13 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
>  			*list = arg;
>  			list = &arg->next;
>  		}
> -		return 0;
>  	}
>  
> +	if (!(event->flags & TEP_EVENT_FL_ISBPRINT))
> +		event->print_fmt.print_cache = parse_args(event,
> +							  event->print_fmt.format,
> +							  event->print_fmt.args);
> +
>  	return 0;
>  
>   event_parse_failed:
> @@ -7195,7 +7475,7 @@ void tep_free_event(struct tep_event *event)
>  
>  	free(event->print_fmt.format);
>  	free_args(event->print_fmt.args);
> -
> +	free_parse_args(event->print_fmt.print_cache);
>  	free(event);
>  }
>  

