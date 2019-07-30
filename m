Return-Path: <SRS0=vd9q=V3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB4AC433FF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 16:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84783206A2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 16:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfG3QMu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbfG3QMu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 12:12:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD7F206A2;
        Tue, 30 Jul 2019 16:12:47 +0000 (UTC)
Date:   Tue, 30 Jul 2019 12:12:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] tools/lib/traceevent, tools/perf: Changes in
 tep_print_event_* APIs
Message-ID: <20190730121245.2d14b2b6@gandalf.local.home>
In-Reply-To: <20190730125028.24789-2-tz.stoyanov@gmail.com>
References: <20190730125028.24789-1-tz.stoyanov@gmail.com>
 <20190730125028.24789-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Jul 2019 15:50:26 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:


> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index b36b536a9fcb..b3dfcc39f606 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -5174,14 +5174,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
>   * tep_data_latency_format - parse the data for the latency format
>   * @tep: a handle to the trace event parser context
>   * @s: the trace_seq to write to
> + * @format: a printf format string
>   * @record: the record to read from
>   *
>   * This parses out the Latency format (interrupts disabled,
>   * need rescheduling, in hard/soft interrupt, preempt count
>   * and lock depth) and places it into the trace_seq.
>   */
> -void tep_data_latency_format(struct tep_handle *tep,
> -			     struct trace_seq *s, struct tep_record *record)

Converting this to a static means that we don't need to start with
"tep_", as those should be reserved for external functions. We can also
modify the above kerndoc to be more of a simple comment, as we don't
need to have static functions turn into documentation.

> +static void tep_data_latency_format(struct tep_handle *tep, struct trace_seq *s,
> +				    char *format, struct tep_record *record)
>  {
>  	static int check_lock_depth = 1;
>  	static int check_migrate_disable = 1;
> @@ -5193,6 +5194,8 @@ void tep_data_latency_format(struct tep_handle *tep,
>  	int migrate_disable = 0;
>  	int hardirq;
>  	int softirq;
> +	char lat_str[32];
> +	char str[8];

This may be a bit of overkill, but we could just add temporary struct
trace_seq here.

	struct trace_seq sq;

>  	void *data = record->data;
>  

	trace_seq_init(&sq);

>  	lat_flags = parse_common_flags(tep, data);
> @@ -5222,7 +5225,7 @@ void tep_data_latency_format(struct tep_handle *tep,
>  	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
>  	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
>  
> -	trace_seq_printf(s, "%c%c%c",
> +	snprintf(lat_str, 32, "%c%c%c",

Then we can keep all the trace_seq_printf() and friends, but just use
&sq instead.

>  	       (lat_flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
>  	       (lat_flags & TRACE_FLAG_IRQS_NOSUPPORT) ?
>  	       'X' : '.',
> @@ -5232,24 +5235,27 @@ void tep_data_latency_format(struct tep_handle *tep,
>  	       hardirq ? 'h' : softirq ? 's' : '.');
>  
>  	if (pc)
> -		trace_seq_printf(s, "%x", pc);
> +		snprintf(str, 8, "%x", pc);
>  	else
> -		trace_seq_putc(s, '.');
> +		snprintf(str, 8, ".");
> +	strcat(lat_str, str);
>  
>  	if (migrate_disable_exists) {
>  		if (migrate_disable < 0)
> -			trace_seq_putc(s, '.');
> +			snprintf(str, 8, ".");
>  		else
> -			trace_seq_printf(s, "%d", migrate_disable);
> +			snprintf(str, 8, "%d", migrate_disable);
> +		strcat(lat_str, str);
>  	}
>  
>  	if (lock_depth_exists) {
>  		if (lock_depth < 0)
> -			trace_seq_putc(s, '.');
> +			snprintf(str, 8, ".");
>  		else
> -			trace_seq_printf(s, "%d", lock_depth);
> +			snprintf(str, 8, "%d", lock_depth);
> +		strcat(lat_str, str);
>  	}
> -
> +	trace_seq_printf(s, format, lat_str);

Then here we would do:

	if (sq.state == TRACE_SEQ__MEM_ALLOC_FAILED) {
		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
		return;
	}	

	trace_seq_terminate(&sq);
	trace_seq_printf(s, format, sq.buffer);
>  	trace_seq_terminate(s);

Just a thought. But using the strcat also works. I figured this just
makes it more consistent.

>  }
>  
> @@ -5413,18 +5419,20 @@ int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline)
>  /**
>   * tep_event_info - parse the data into the print format
>   * @s: the trace_seq to write to
> + * @format: printf format string. If any precision is specified in the string,
> + *	    print in raw data format

I'm curious to why this is needed?

We can use a temp trace_seq like I mentioned above, and then apply the
format to it at the end.


>   * @event: the handle to the event
>   * @record: the record to read from
>   *
>   * This parses the raw @data using the given @event information and
>   * writes the print format into the trace_seq.
>   */
> -void tep_event_info(struct trace_seq *s, struct tep_event *event,
> -		    struct tep_record *record)
> +static void tep_event_info(struct trace_seq *s, char *format,
> +			   struct tep_event *event, struct tep_record *record)

Same thing. The comments for this static function can also be
simplified.


>  {
>  	int print_pretty = 1;
>  
> -	if (event->tep->print_raw || (event->flags & TEP_EVENT_FL_PRINTRAW))
> +	if (isdigit(*(format+1)) || (event->flags & TEP_EVENT_FL_PRINTRAW))
>  		tep_print_fields(s, record->data, record->size, event);
>  	else {
>  
> @@ -5439,20 +5447,6 @@ void tep_event_info(struct trace_seq *s, struct tep_event *event,
>  	trace_seq_terminate(s);
>  }
>  
> -static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
> -{
> -	if (!trace_clock || !use_trace_clock)
> -		return true;
> -
> -	if (!strcmp(trace_clock, "local") || !strcmp(trace_clock, "global")
> -	    || !strcmp(trace_clock, "uptime") || !strcmp(trace_clock, "perf")
> -	    || !strncmp(trace_clock, "mono", 4))
> -		return true;
> -
> -	/* trace_clock is setting in tsc or counter mode */
> -	return false;
> -}
> -
>  /**
>   * tep_find_event_by_record - return the event from a given record
>   * @tep: a handle to the trace event parser context
> @@ -5477,128 +5471,193 @@ tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record)
>  }
>  
>  /**
> - * tep_print_event_task - Write the event task comm, pid and CPU
> + * tep_print_event_time - Write the event timestamp
>   * @tep: a handle to the trace event parser context
>   * @s: the trace_seq to write to
> + * @format: a printf format string.
> + *	    Time divisor and precision can be specified as part of this format
> + *	    string: "%precision.divisord". Example:
> + *	    "%3.1000d" - divide the time by 1000 and print the first 3 digits
> + *	     before the dot. Thus, the timestamp "123456000" will be printed as
> + *	     "123.456"
>   * @event: the handle to the record's event
>   * @record: The record to get the event from
>   *
> - * Writes the tasks comm, pid and CPU to @s.
> + * Writes the timestamp of the record into @s.
>   */
> -void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
> -			  struct tep_event *event,
> -			  struct tep_record *record)

Again, we can simplify the comments for this function. Not make it less
informative, but remove the /** and make it just less official.

> +static void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
> +				 char *format, struct tep_event *event,
> +				 struct tep_record *record)
> +{
> +	unsigned long long time;
> +	char *divstr;
> +	int prec = 0, pr;
> +	int div = 0;
> +	int p10 = 1;
> +
> +	if (isdigit(*(format + 1)))
> +		prec = atoi(format + 1);
> +	divstr = strchr(format, '.');
> +	if (divstr && isdigit(*(divstr + 1)))
> +		div = atoi(divstr + 1);
> +	time = record->ts;
> +	if (div)
> +		time /= div;
> +	pr = prec;
> +	while (pr--)
> +		p10 *= 10;
> +
> +	if (p10 > 1 && p10 < time)
> +		trace_seq_printf(s, "%5llu.%0*llu", time / p10, prec, time % p10);
> +	else
> +		printf("%12llu\n", time);

Hmm, this should not print. I think you meant this to be
trace_seq_printf() not printf().

> +}
> +
> +struct print_event_type {
> +	enum {
> +		EVENT_TYPE_INT = 1,
> +		EVENT_TYPE_STRING,
> +		EVENT_TYPE_UNKNOWN,
> +	} type;
> +	char format[32];
> +};
> +
> +static void tep_print_string(struct tep_handle *tep, struct trace_seq *s,

Oh, and we should also remove the "tep_" from the names of the static
functions.

> +			     struct tep_record *record, struct tep_event *event,
> +			     const char *arg, struct print_event_type *type)
>  {
> -	void *data = record->data;
>  	const char *comm;
>  	int pid;
>  
> -	pid = parse_common_pid(tep, data);
> -	comm = find_cmdline(tep, pid);
> -
> -	if (tep->latency_format)
> -		trace_seq_printf(s, "%8.8s-%-5d %3d", comm, pid, record->cpu);
> -	else
> -		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
> +	if (strncmp(arg, TEP_PRINT_LATENCY, strlen(TEP_PRINT_LATENCY)) == 0) {
> +		tep_data_latency_format(tep, s, type->format, record);
> +	} else if (strncmp(arg, TEP_PRINT_COMM, strlen(TEP_PRINT_COMM)) == 0) {
> +		pid = parse_common_pid(tep, record->data);
> +		comm = find_cmdline(tep, pid);
> +		trace_seq_printf(s, type->format, comm);
> +	} else if (strncmp(arg, TEP_PRINT_INFO, strlen(TEP_PRINT_INFO)) == 0) {
> +		tep_event_info(s, type->format, event, record);
> +	} else if  (strncmp(arg, TEP_PRINT_NAME, strlen(TEP_PRINT_NAME)) == 0) {
> +		trace_seq_printf(s, type->format, event->name);
> +	}

Hmm, I wonder if we should add an else here.
	} else {
		trace_seq_printf(s, "[UNKNOWN TEP TYPE %s]", arg);
	}
?

>  }
>  
> -/**
> - * tep_print_event_time - Write the event timestamp
> - * @tep: a handle to the trace event parser context
> - * @s: the trace_seq to write to
> - * @event: the handle to the record's event
> - * @record: The record to get the event from
> - * @use_trace_clock: Set to parse according to the @tep->trace_clock
> - *
> - * Writes the timestamp of the record into @s.
> - */
> -void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
> -			  struct tep_event *event,
> -			  struct tep_record *record,
> -			  bool use_trace_clock)

Same thing about static functions here.

> +static void tep_print_int(struct tep_handle *tep, struct trace_seq *s,
> +			  struct tep_record *record, struct tep_event *event,
> +			  int arg, struct print_event_type *type)
>  {
> -	unsigned long secs;
> -	unsigned long usecs;
> -	unsigned long nsecs;
> -	int p;
> -	bool use_usec_format;
> +	int param;
>  
> -	use_usec_format = is_timestamp_in_us(tep->trace_clock, use_trace_clock);
> -	if (use_usec_format) {
> -		secs = record->ts / NSEC_PER_SEC;
> -		nsecs = record->ts - secs * NSEC_PER_SEC;
> +	switch (arg) {
> +	case TEP_PRINT_CPU:
> +		param = record->cpu;
> +		break;
> +	case TEP_PRINT_PID:
> +		param = parse_common_pid(tep, record->data);
> +		break;
> +	case TEP_PRINT_TIME:
> +		return tep_print_event_time(tep, s, type->format, event, record);
> +	default:
> +		return;
>  	}
> +	trace_seq_printf(s, type->format, param);
> +}
>  
> -	if (tep->latency_format) {
> -		tep_data_latency_format(tep, s, record);
> -	}
> +static int tep_print_event_param_type(char *format,
> +				      struct print_event_type *type)
> +{
> +	char *str = format + 1;
> +	int i = 1;
>  
> -	if (use_usec_format) {
> -		if (tep->flags & TEP_NSEC_OUTPUT) {
> -			usecs = nsecs;
> -			p = 9;
> -		} else {
> -			usecs = (nsecs + 500) / NSEC_PER_USEC;
> -			/* To avoid usecs larger than 1 sec */
> -			if (usecs >= USEC_PER_SEC) {
> -				usecs -= USEC_PER_SEC;
> -				secs++;
> -			}
> -			p = 6;
> +	type->type = EVENT_TYPE_UNKNOWN;
> +	while (*str) {
> +		switch (*str) {
> +		case 'd':
> +		case 'u':
> +		case 'i':
> +		case 'x':
> +		case 'X':
> +		case 'o':
> +			type->type = EVENT_TYPE_INT;
> +			break;
> +		case 's':
> +			type->type = EVENT_TYPE_STRING;
> +			break;

Should this cover all printf types?

>  		}
> -
> -		trace_seq_printf(s, " %5lu.%0*lu:", secs, p, usecs);
> -	} else
> -		trace_seq_printf(s, " %12llu:", record->ts);
> +		str++;
> +		i++;
> +		if (type->type != EVENT_TYPE_UNKNOWN)
> +			break;
> +	}
> +	memset(type->format, 0, 32);
> +	memcpy(type->format, format, i < 32 ? i : 31);
> +	return i;
>  }
>  
>  /**
> - * tep_print_event_data - Write the event data section
> + * tep_print_event - Write various event information
>   * @tep: a handle to the trace event parser context
>   * @s: the trace_seq to write to
> - * @event: the handle to the record's event
>   * @record: The record to get the event from
> - *
> - * Writes the parsing of the record's data to @s.
> + * @format: a printf format string. Supported event fileds:
> + *	TEP_PRINT_PID, "%d" - event PID
> + *	TEP_PRINT_CPU, "%d" - event CPU
> + *	TEP_PRINT_COMM, "%s" - event command string
> + *	TEP_PRINT_NAME, "%s" - event name
> + *	TEP_PRINT_LATENCY, "%s" - event latency
> + *	TEP_PRINT_TIME, %d - event time stamp. A divisor and precision
> + *			can be specified as part of this format string:
> + *			"%precision.divisord". Example:
> + *			"%3.1000d" - divide the time by 1000 and print the first
> + *			3 digits before the dot. Thus, the time stamp
> + *			"123456000" will be printed as "123.456"
> + *	TEP_PRINT_INFO, "%s" - event information. If any width is specified in
> + *			the format string, the event information will be printed
> + *			in raw format.
> + * Writes the specified event information into @s.
>   */
> -void tep_print_event_data(struct tep_handle *tep, struct trace_seq *s,
> -			  struct tep_event *event,
> -			  struct tep_record *record)
> -{
> -	static const char *spaces = "                    "; /* 20 spaces */
> -	int len;
> -
> -	trace_seq_printf(s, " %s: ", event->name);
> -
> -	/* Space out the event names evenly. */
> -	len = strlen(event->name);
> -	if (len < 20)
> -		trace_seq_printf(s, "%.*s", 20 - len, spaces);
> -
> -	tep_event_info(s, event, record);
> -}
> -
>  void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
> -		     struct tep_record *record, bool use_trace_clock)
> -{
> +		     struct tep_record *record, const char *fmt, ...)
> +{
> +	struct print_event_type type;
> +	char *format = strdup(fmt);

Need to test if strdup succeeded.

> +	char *current = format;
> +	char *str = format;
> +	int offset;
> +	va_list args;
>  	struct tep_event *event;
>  
>  	event = tep_find_event_by_record(tep, record);
> -	if (!event) {
> -		int i;
> -		int type = trace_parse_common_type(tep, record->data);
> -
> -		do_warning("ug! no event found for type %d", type);
> -		trace_seq_printf(s, "[UNKNOWN TYPE %d]", type);
> -		for (i = 0; i < record->size; i++)
> -			trace_seq_printf(s, " %02x",
> -					 ((unsigned char *)record->data)[i]);
> -		return;
> -	}
> +	va_start(args, fmt);
> +	while (*current) {
> +		current = strchr(str, '%');
> +		if (!current) {
> +			trace_seq_puts(s, str);
> +			break;
> +		}
> +		memset(&type, 0, sizeof(type));
> +		offset = tep_print_event_param_type(current, &type);
> +		*current = '\0';
> +		trace_seq_puts(s, str);
> +		current += offset;
> +		switch (type.type) {
> +		case EVENT_TYPE_STRING:
> +			tep_print_string(tep, s, record, event,
> +					 va_arg(args, char*), &type);
> +			break;
> +		case EVENT_TYPE_INT:
> +			tep_print_int(tep, s, record, event,
> +				      va_arg(args, int), &type);
> +			break;
> +		case EVENT_TYPE_UNKNOWN:
> +		default:

Should we add a trace_seq_printf("[UNKNOWN TYPE]") or something here?

-- Steve


> +			break;
> +		}
> +		str = current;
>  
> -	tep_print_event_task(tep, s, event, record);
> -	tep_print_event_time(tep, s, event, record, use_trace_clock);
> -	tep_print_event_data(tep, s, event, record);
> +	}
> +	va_end(args);
> +	free(format);
>  }
>  
>  static int events_id_cmp(const void *a, const void *b)
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 642f68ab5fb2..5ed5107a4ec4 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -442,18 +442,17 @@ int tep_register_print_string(struct tep_handle *tep, const char *fmt,
>  			      unsigned long long addr);
>  bool tep_is_pid_registered(struct tep_handle *tep, int pid);
>  
> -void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
> -			  struct tep_event *event,
> -			  struct tep_record *record);
> -void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
> -			  struct tep_event *event,
> -			  struct tep_record *record,
> -			  bool use_trace_clock);
> -void tep_print_event_data(struct tep_handle *tep, struct trace_seq *s,
> -			  struct tep_event *event,
> -			  struct tep_record *record);
> +#define TEP_PRINT_INFO		"INFO"
> +#define TEP_PRINT_COMM		"COMM"
> +#define TEP_PRINT_LATENCY	"LATENCY"
> +#define TEP_PRINT_NAME		"NAME"
> +#define TEP_PRINT_PID		1U
> +#define TEP_PRINT_TIME		2U
> +#define TEP_PRINT_CPU		3U
> +
>  void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
> -		     struct tep_record *record, bool use_trace_clock);
> +		     struct tep_record *record, const char *fmt, ...)
> +	__attribute__ ((format (printf, 4, 5)));
>  
>  int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
>  			  int long_size);
> @@ -525,8 +524,6 @@ tep_find_event_by_name(struct tep_handle *tep, const char *sys, const char *name
>  struct tep_event *
>  tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record);
>  
> -void tep_data_latency_format(struct tep_handle *tep,
> -			     struct trace_seq *s, struct tep_record *record);
>  int tep_data_type(struct tep_handle *tep, struct tep_record *rec);
>  int tep_data_pid(struct tep_handle *tep, struct tep_record *rec);
>  int tep_data_preempt_count(struct tep_handle *tep, struct tep_record *rec);
> @@ -541,8 +538,6 @@ void tep_print_field(struct trace_seq *s, void *data,
>  		     struct tep_format_field *field);
>  void tep_print_fields(struct trace_seq *s, void *data,
>  		      int size __maybe_unused, struct tep_event *event);
> -void tep_event_info(struct trace_seq *s, struct tep_event *event,
> -		    struct tep_record *record);
>  int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
>  		 char *buf, size_t buflen);
>  
> @@ -566,12 +561,9 @@ bool tep_is_file_bigendian(struct tep_handle *tep);
>  void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);
>  bool tep_is_local_bigendian(struct tep_handle *tep);
>  void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian);
> -bool tep_is_latency_format(struct tep_handle *tep);
> -void tep_set_latency_format(struct tep_handle *tep, int lat);
>  int tep_get_header_page_size(struct tep_handle *tep);
>  int tep_get_header_timestamp_size(struct tep_handle *tep);
>  bool tep_is_old_format(struct tep_handle *tep);
> -void tep_set_print_raw(struct tep_handle *tep, int print_raw);
>  void tep_set_test_filters(struct tep_handle *tep, int test_filters);
>  
>  struct tep_handle *tep_alloc(void);
> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> index 9e5e60898083..6f9b15ee252e 100644
> --- a/tools/perf/builtin-kmem.c
> +++ b/tools/perf/builtin-kmem.c
> @@ -749,7 +749,8 @@ static int parse_gfp_flags(struct perf_evsel *evsel, struct perf_sample *sample,
>  	}
>  
>  	trace_seq_init(&seq);
> -	tep_event_info(&seq, evsel->tp_format, &record);
> +	tep_print_event(evsel->tp_format->tep,
> +			&seq, &record, "%s", TEP_PRINT_INFO);
>  
>  	str = strtok_r(seq.buffer, " ", &pos);
>  	while (str) {
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 5d2518e89fc4..55a20bbbe236 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -711,7 +711,8 @@ static char *get_trace_output(struct hist_entry *he)
>  		tep_print_fields(&seq, he->raw_data, he->raw_size,
>  				 evsel->tp_format);
>  	} else {
> -		tep_event_info(&seq, evsel->tp_format, &rec);
> +		tep_print_event(evsel->tp_format->tep,
> +				&seq, &rec, "%s", TEP_PRINT_INFO);
>  	}
>  	/*
>  	 * Trim the buffer, it starts at 4KB and we're not going to
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index b3982e1bb4c5..3c5fef614d89 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -110,7 +110,7 @@ void event_format__fprintf(struct tep_event *event,
>  	record.data = data;
>  
>  	trace_seq_init(&s);
> -	tep_event_info(&s, event, &record);
> +	tep_print_event(event->tep, &s, &record, "%s", TEP_PRINT_INFO);
>  	trace_seq_do_fprintf(&s, fp);
>  	trace_seq_destroy(&s);
>  }

