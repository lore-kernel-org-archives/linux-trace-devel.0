Return-Path: <SRS0=4lCp=63=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.6 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BC3C2D0F8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 May 2020 01:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49D520753
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 May 2020 01:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731815AbgEMBOM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 May 2020 21:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731695AbgEMBOM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 May 2020 21:14:12 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3BC4206F5;
        Wed, 13 May 2020 01:14:10 +0000 (UTC)
Date:   Tue, 12 May 2020 21:14:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2] trace-cmd: Add support for more printk format
 specifiers
Message-ID: <20200512211409.63fb63c5@oasis.local.home>
In-Reply-To: <20200512155127.2310670-1-tz.stoyanov@gmail.com>
References: <20200512155127.2310670-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 12 May 2020 18:51:27 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> -static void print_ip4_addr(struct trace_seq *s, char i, unsigned char *buf)
> +static int parse_ip4_print_args(struct tep_handle *tep,
> +				const char *ptr, bool *reverse)
> +{
> +	int ret = 0;
> +
> +	*reverse = false;
> +
> +	/* hnbl */
> +	switch (*ptr) {
> +	case 'h':
> +		if (tep->file_bigendian)
> +			*reverse = false;
> +		else
> +			*reverse = true;
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
> +static void print_ip4_addr(struct trace_seq *s, char i, bool reverse, unsigned char *buf)

Need a space between the end bracket and the next function.

>  {
>  	const char *fmt;
>  
> @@ -4555,7 +4604,11 @@ static void print_ip4_addr(struct trace_seq *s, char i, unsigned char *buf)
>  	else
>  		fmt = "%d.%d.%d.%d";
>  
> -	trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3]);
> +	if (reverse)
> +		trace_seq_printf(s, fmt, buf[3], buf[2], buf[1], buf[0]);
> +	else
> +		trace_seq_printf(s, fmt, buf[0], buf[1], buf[2], buf[3]);
> +
>  }
>  


> +int  guid_index[16] = {3, 2, 1, 0, 5, 4, 7, 6, 8, 9, 10, 11, 12, 13, 14, 15};
> +int  uuid_index[16] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
> +static int print_uuid_arg(struct trace_seq *s, const char *ptr,

Add a space between the variables and the function.

Also, make them static const:

static const int [gu]id_index[16] = ...

> +			void *data, int size, struct tep_event *event,
> +			struct tep_print_arg *arg)
> +{
> +	int *index = uuid_index;
> +	char *format = "%02x";
> +	int ret = 0;
> +	char *buf;
> +	int i;
> +
> +	switch (*(ptr + 1)) {
> +	case 'L':
> +		format = "%02X";
> +		/* fall through */
> +	case 'l':
> +		index = guid_index;
> +		ret++;
> +		break;
> +	case 'B':
> +		format = "%02X";
> +		/* fall through */
> +	case 'b':
> +		ret++;
> +		break;
> +	}
> +
> +	if (arg->type == TEP_PRINT_FUNC) {
> +		process_defined_func(s, data, size, event, arg);
> +		return ret;
> +	}
> +
> +	if (arg->type != TEP_PRINT_FIELD) {
> +		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
> +		return ret;
> +	}
> +
> +	if (!arg->field.field) {
> +		arg->field.field =
> +			tep_find_any_field(event, arg->field.name);
> +		if (!arg->field.field) {
> +			do_warning("%s: field %s not found",
> +				   __func__, arg->field.name);
> +			return ret;
> +		}
> +	}
> +
> +	if (arg->field.field->size != 16) {
> +		trace_seq_printf(s, "INVALIDUUID");
> +		return ret;
> +	}
> +
> +	buf = data + arg->field.field->offset;
> +
> +	for (i = 0; i < 16; i++) {
> +		trace_seq_printf(s, format, buf[index[i]] & 0xff);
> +		switch (i) {
> +		case 3:
> +		case 5:
> +		case 7:
> +		case 9:
> +			trace_seq_printf(s, "-");
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int print_raw_buff_arg(struct trace_seq *s, const char *ptr,
> +			      void *data, int size, struct tep_event *event,
> +			      struct tep_print_arg *arg, int print_len)
> +{
> +	int plen = print_len;
> +	char *delim = " ";
> +	int ret = 0;
> +	char *buf;
> +	int i;
> +	unsigned long offset;
> +	int arr_len;
> +
> +	switch (*(ptr + 1)) {
> +	case 'C':
> +		delim = ":";
> +		ret++;
> +		break;
> +	case 'D':
> +		delim = "-";
> +		ret++;
> +		break;
> +	case 'N':
> +		delim = "";
> +		ret++;
> +		break;
> +	}
> +
> +	if (arg->type == TEP_PRINT_FUNC) {
> +		process_defined_func(s, data, size, event, arg);
> +		return ret;
> +	}
> +
> +	if (arg->type != TEP_PRINT_DYNAMIC_ARRAY) {
> +		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
> +		return ret;

Hmm, shouldn't this also be able to work with a constant array?

> +	}
> +
> +	offset = tep_read_number(event->tep,
> +				 data + arg->dynarray.field->offset,
> +				 arg->dynarray.field->size);
> +	arr_len = (unsigned long long)(offset >> 16);
> +	buf = data + (offset & 0xffff);
> +
> +	if (arr_len < plen)
> +		plen = arr_len;
> +
> +	if (plen < 1)
> +		return ret;
> +
> +	trace_seq_printf(s, "%02x", buf[0] & 0xff);
> +	for (i = 1; i < plen; i++)
> +		trace_seq_printf(s, "%s%02x", delim, buf[i] & 0xff);
> +
> +	return ret;
> +}
> +
>  static int is_printable_array(char *p, unsigned int len)
>  {
>  	unsigned int i;
> @@ -4952,6 +5136,71 @@ void tep_print_fields(struct trace_seq *s, void *data,
>  	}
>  }
>  
> +static int print_function(struct trace_seq *s, const char *format,
> +			  void *data, int size, struct tep_event *event,
> +			  struct tep_print_arg *arg)
> +{
> +	struct func_map *func;
> +	unsigned long long val;
> +
> +	val = eval_num_arg(data, size, event, arg);
> +	func = find_func(event->tep, val);
> +	if (func) {
> +		trace_seq_puts(s, func->func);
> +		if (*format == 'F' || *format == 'S')
> +			trace_seq_printf(s, "+0x%llx", val - func->addr);
> +	} else {
> +		if (event->tep->long_size == 4)
> +			trace_seq_printf(s, "0x%lx", (long)val);
> +		else
> +			trace_seq_printf(s, "0x%llx", (long long)val);
> +	}
> +
> +	return 0;
> +}
> +
> +static int print_pointer(struct trace_seq *s, const char *format, int plen,
> +			 void *data, int size,
> +			 struct tep_event *event, struct tep_print_arg *arg)
> +{
> +	unsigned long long val;
> +	int ret = 1;
> +
> +	switch (*format) {
> +	case 'F':
> +	case 'f':
> +	case 'S':
> +	case 's':
> +		ret += print_function(s, format, data, size, event, arg);
> +		break;
> +	case 'M':
> +	case 'm':
> +		ret += print_mac_arg(s, format, data, size, event, arg);
> +		break;
> +	case 'I':
> +	case 'i':
> +		ret += print_ip_arg(s, format, data, size, event, arg);
> +		break;
> +	case 'U':
> +		ret += print_uuid_arg(s, format, data, size, event, arg);
> +		break;
> +	case 'h':
> +		ret += print_raw_buff_arg(s, format, data, size, event, arg, plen);
> +		break;
> +	default:
> +		ret = 0;
> +		val = eval_num_arg(data, size, event, arg);
> +		if (event->tep->long_size == 4)
> +			trace_seq_printf(s, "0x%lx", (long)val);
> +		else
> +			trace_seq_printf(s, "0x%llx", (long long)val);
> +		break;
> +	}
> +
> +	return ret;
> +
> +}
> +
>  static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event *event)
>  {
>  	struct tep_handle *tep = event->tep;
> @@ -4960,16 +5209,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
>  	struct tep_print_arg *args = NULL;
>  	const char *ptr = print_fmt->format;
>  	unsigned long long val;
> -	struct func_map *func;
>  	const char *saveptr;
>  	struct trace_seq p;
>  	char *bprint_fmt = NULL;
>  	char format[32];
> -	int show_func;
>  	int len_as_arg;
>  	int len_arg = 0;
>  	int len;
>  	int ls;
> +	int ret;
>  
>  	if (event->flags & TEP_EVENT_FL_FAILED) {
>  		trace_seq_printf(s, "[FAILED TO PARSE]");
> @@ -5008,7 +5256,6 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
>  
>  		} else if (*ptr == '%') {
>  			saveptr = ptr;
> -			show_func = 0;
>  			len_as_arg = 0;
>   cont_process:
>  			ptr++;
> @@ -5046,39 +5293,19 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
>  			case '-':
>  				goto cont_process;
>  			case 'p':
> -				if (tep->long_size == 4)
> -					ls = 1;
> -				else
> -					ls = 2;
> -
> -				if (isalnum(ptr[1]))
> -					ptr++;
> -
>  				if (arg->type == TEP_PRINT_BSTRING) {

This will still need the above check. As this is for trace_printk() in
the kernel. And that will record the pointer conversion (except for
functions) into the buffer as a string (hence why it only prints the
string). But that said, the format still needs to be passed, otherwise
it is printed. We should (not in this patch), probably do the full
logic of parsing the format as well, as the check for isalnum() is not
enough.

-- Steve


>  					trace_seq_puts(s, arg->string.string);
>  					arg = arg->next;
>  					break;
>  				}
> -
> -				if (*ptr == 'F' || *ptr == 'f' ||
> -				    *ptr == 'S' || *ptr == 's') {
> -					show_func = *ptr;
> -				} else if (*ptr == 'M' || *ptr == 'm') {
> -					print_mac_arg(s, *ptr, data, size, event, arg);
> -					arg = arg->next;
> -					break;
> -				} else if (*ptr == 'I' || *ptr == 'i') {
> -					int n;
> -
> -					n = print_ip_arg(s, ptr, data, size, event, arg);
> -					if (n > 0) {
> -						ptr += n - 1;
> -						arg = arg->next;
> -						break;
> -					}
> -				}
> -
> -				/* fall through */
> +				ret = print_pointer(s, ptr + 1,
> +						    len_as_arg ? len_arg : 1,
> +						    data, size,
> +						    event, arg);
> +				arg = arg->next;
> +				if (ret > 0)
> +					ptr += ret;
> +				break;
>  			case 'd':
>  			case 'u':
>  			case 'i':
> @@ -5107,17 +5334,6 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
>  				val = eval_num_arg(data, size, event, arg);
>  				arg = arg->next;
>  
> -				if (show_func) {
> -					func = find_func(tep, val);
> -					if (func) {
> -						trace_seq_puts(s, func->func);
> -						if (show_func == 'F')
> -							trace_seq_printf(s,
> -							       "+0x%llx",
> -							       val - func->addr);
> -						break;
> -					}
> -				}
>  				if (tep->long_size == 8 && ls == 1 &&
>  				    sizeof(long) != 8) {
>  					char *p;
> @@ -5125,8 +5341,6 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
>  					/* make %l into %ll */
>  					if (ls == 1 && (p = strchr(format, 'l')))
>  						memmove(p+1, p, strlen(p)+1);
> -					else if (strcmp(format, "%p") == 0)
> -						strcpy(format, "0x%llx");
>  					ls = 2;
>  				}
>  				switch (ls) {

