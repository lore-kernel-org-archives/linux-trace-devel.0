Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F40DC4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC0D207C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgI2Nk2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgI2Nk2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:40:28 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 776DE208FE;
        Tue, 29 Sep 2020 13:40:25 +0000 (UTC)
Date:   Tue, 29 Sep 2020 09:40:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     arnaldo.melo@gmail.com, linux-trace-devel@vger.kernel.org,
        ben@decadent.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools lib traceevent: Hide non API functions
Message-ID: <20200929094022.05e4ef5b@oasis.local.home>
In-Reply-To: <20200929033413.209399-1-tz.stoyanov@gmail.com>
References: <20200929033413.209399-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 29 Sep 2020 06:34:13 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There are internal library functions, which are not decalred as a static.

Typo for "declared"

> They are used inside the library from different files. Hide them from
> the library users, as they are not part of the API.
> These functions are made hidden and are renamed without the prefix "tep_":
>  tep_free_plugin_paths
>  tep_peek_char
>  tep_buffer_init
>  tep_get_input_buf_ptr
>  tep_get_input_buf
>  tep_read_token
>  tep_free_token
>  tep_free_event
>  tep_free_format_field

I would include:

Link: https://lore.kernel.org/r/e4afdd82deb5e023d53231bb13e08dca78085fb0.camel@decadent.org.uk

> 
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> v1 of the patch is here: https://lore.kernel.org/r/20200924070609.100771-2-tz.stoyanov@gmail.com
> v2 changes:
>   - Removed leading underscores from the names of newly hidden internal
>     functions.
> 
>  tools/lib/traceevent/event-parse-api.c   |  8 +-
>  tools/lib/traceevent/event-parse-local.h | 24 ++++--
>  tools/lib/traceevent/event-parse.c       | 96 ++++++------------------
>  tools/lib/traceevent/event-parse.h       |  8 --
>  tools/lib/traceevent/event-plugin.c      |  2 +-
>  tools/lib/traceevent/parse-filter.c      | 23 +++---
>  6 files changed, 56 insertions(+), 105 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
> index 4faf52a65791..f8361e45d446 100644
> --- a/tools/lib/traceevent/event-parse-api.c
> +++ b/tools/lib/traceevent/event-parse-api.c
> @@ -92,7 +92,7 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
>  	return false;
>  }
>  
> -unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
> +__hidden unsigned short data2host2(struct tep_handle *tep, unsigned short data)
>  {
>  	unsigned short swap;
>  
> @@ -105,7 +105,7 @@ unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
>  	return swap;
>  }
>  
> -unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
> +__hidden unsigned int data2host4(struct tep_handle *tep, unsigned int data)
>  {
>  	unsigned int swap;
>  
> @@ -120,8 +120,8 @@ unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
>  	return swap;
>  }
>  
> -unsigned long long
> -tep_data2host8(struct tep_handle *tep, unsigned long long data)
> +__hidden  unsigned long long
> +data2host8(struct tep_handle *tep, unsigned long long data)
>  {
>  	unsigned long long swap;
>  
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index d805a920af6f..fd4bbcfbb849 100644
> --- a/tools/lib/traceevent/event-parse-local.h
> +++ b/tools/lib/traceevent/event-parse-local.h
> @@ -15,6 +15,8 @@ struct event_handler;
>  struct func_resolver;
>  struct tep_plugins_dir;
>  
> +#define __hidden __attribute__((visibility ("hidden")))
> +
>  struct tep_handle {
>  	int ref_count;
>  
> @@ -102,12 +104,20 @@ struct tep_print_parse {
>  	struct tep_print_arg		*len_as_arg;
>  };
>  
> -void tep_free_event(struct tep_event *event);
> -void tep_free_format_field(struct tep_format_field *field);
> -void tep_free_plugin_paths(struct tep_handle *tep);
> -
> -unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
> -unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
> -unsigned long long tep_data2host8(struct tep_handle *tep, unsigned long long data);
> +void free_tep_event(struct tep_event *event);
> +void free_tep_format_field(struct tep_format_field *field);
> +void free_tep_plugin_paths(struct tep_handle *tep);
> +
> +unsigned short data2host2(struct tep_handle *tep, unsigned short data);
> +unsigned int data2host4(struct tep_handle *tep, unsigned int data);
> +unsigned long long data2host8(struct tep_handle *tep, unsigned long long data);
> +
> +/* access to the internal parser */
> +int peek_char(void);
> +void init_input_buf(const char *buf, unsigned long long size);
> +unsigned long long get_input_buf_ptr(void);
> +const char *get_input_buf(void);
> +enum tep_event_type read_token(char **tok);
> +void free_token(char *tok);
>  
>  #endif /* _PARSE_EVENTS_INT_H */
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 5acc18b32606..032ecb22cde9 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -54,19 +54,19 @@ static int show_warning = 1;
>  			warning(fmt, ##__VA_ARGS__);		\
>  	} while (0)
>  
> -static void init_input_buf(const char *buf, unsigned long long size)
> +__hidden void init_input_buf(const char *buf, unsigned long long size)
>  {
>  	input_buf = buf;
>  	input_buf_siz = size;
>  	input_buf_ptr = 0;
>  }
>  
> -const char *tep_get_input_buf(void)
> +__hidden const char *get_input_buf(void)
>  {
>  	return input_buf;
>  }
>  
> -unsigned long long tep_get_input_buf_ptr(void)
> +__hidden unsigned long long get_input_buf_ptr(void)
>  {
>  	return input_buf_ptr;
>  }
> @@ -100,26 +100,13 @@ process_defined_func(struct trace_seq *s, void *data, int size,
>  
>  static void free_func_handle(struct tep_function_handler *func);
>  
> -/**
> - * tep_buffer_init - init buffer for parsing
> - * @buf: buffer to parse
> - * @size: the size of the buffer
> - *
> - * For use with tep_read_token(), this initializes the internal
> - * buffer that tep_read_token() will parse.
> - */

I wouldn't delete the kerneldoc of functions. It's useful to have this
documentation for internal functions as well. We just don't need to
make a man page for it. Just move the comment to init_input_buf().
Note, comments like this are usually recommended for all non static
functions (this goes for the kernel too), although it's not always
done. But where it is done, let's not delete it ;-)

> -void tep_buffer_init(const char *buf, unsigned long long size)
> -{
> -	init_input_buf(buf, size);
> -}
> -
>  void breakpoint(void)
>  {
>  	static int x;
>  	x++;
>  }
>  
> -struct tep_print_arg *alloc_arg(void)
> +static struct tep_print_arg *alloc_arg(void)
>  {
>  	return calloc(1, sizeof(struct tep_print_arg));
>  }
> @@ -962,7 +949,7 @@ static int __read_char(void)
>  	return input_buf[input_buf_ptr++];
>  }
>  
> -static int __peek_char(void)
> +__hidden  int peek_char(void)
>  {
>  	if (input_buf_ptr >= input_buf_siz)
>  		return -1;
> @@ -970,16 +957,6 @@ static int __peek_char(void)
>  	return input_buf[input_buf_ptr];
>  }
>  
> -/**
> - * tep_peek_char - peek at the next character that will be read
> - *
> - * Returns the next character read, or -1 if end of buffer.
> - */

Same for this comment.

> -int tep_peek_char(void)
> -{
> -	return __peek_char();
> -}
> -
>  static int extend_token(char **tok, char *buf, int size)
>  {
>  	char *newtok = realloc(*tok, size);
> @@ -1033,7 +1010,7 @@ static enum tep_event_type __read_token(char **tok)
>  	case TEP_EVENT_OP:
>  		switch (ch) {
>  		case '-':
> -			next_ch = __peek_char();
> +			next_ch = peek_char();
>  			if (next_ch == '>') {
>  				buf[i++] = __read_char();
>  				break;
> @@ -1045,7 +1022,7 @@ static enum tep_event_type __read_token(char **tok)
>  		case '>':
>  		case '<':
>  			last_ch = ch;
> -			ch = __peek_char();
> +			ch = peek_char();
>  			if (ch != last_ch)
>  				goto test_equal;
>  			buf[i++] = __read_char();
> @@ -1068,7 +1045,7 @@ static enum tep_event_type __read_token(char **tok)
>  		return type;
>  
>   test_equal:
> -		ch = __peek_char();
> +		ch = peek_char();
>  		if (ch == '=')
>  			buf[i++] = __read_char();
>  		goto out;
> @@ -1122,7 +1099,7 @@ static enum tep_event_type __read_token(char **tok)
>  		break;
>  	}
>  
> -	while (get_type(__peek_char()) == type) {
> +	while (get_type(peek_char()) == type) {
>  		if (i == (BUFSIZ - 1)) {
>  			buf[i] = 0;
>  			tok_size += BUFSIZ;
> @@ -1191,13 +1168,13 @@ static enum tep_event_type force_token(const char *str, char **tok)
>  	return type;
>  }
>  
> -static void free_token(char *tok)
> +__hidden void free_token(char *tok)
>  {
>  	if (tok)
>  		free(tok);
>  }
>  
> -static enum tep_event_type read_token(char **tok)
> +__hidden enum tep_event_type read_token(char **tok)
>  {
>  	enum tep_event_type type;
>  
> @@ -1214,29 +1191,6 @@ static enum tep_event_type read_token(char **tok)
>  	return TEP_EVENT_NONE;
>  }
>  
> -/**
> - * tep_read_token - access to utilities to use the tep parser
> - * @tok: The token to return
> - *
> - * This will parse tokens from the string given by
> - * tep_init_data().
> - *
> - * Returns the token type.
> - */
> -enum tep_event_type tep_read_token(char **tok)
> -{
> -	return read_token(tok);
> -}
> -
> -/**
> - * tep_free_token - free a token returned by tep_read_token
> - * @token: the token to free
> - */

Same for the above two comments.

> -void tep_free_token(char *token)
> -{
> -	free_token(token);
> -}
> -
>  /* no newline */
>  static enum tep_event_type read_token_item(char **tok)
>  {
> @@ -3459,12 +3413,12 @@ unsigned long long tep_read_number(struct tep_handle *tep,
>  	case 1:
>  		return *(unsigned char *)ptr;
>  	case 2:
> -		return tep_data2host2(tep, *(unsigned short *)ptr);
> +		return data2host2(tep, *(unsigned short *)ptr);
>  	case 4:
> -		return tep_data2host4(tep, *(unsigned int *)ptr);
> +		return data2host4(tep, *(unsigned int *)ptr);
>  	case 8:
>  		memcpy(&val, (ptr), sizeof(unsigned long long));
> -		return tep_data2host8(tep, val);
> +		return data2host8(tep, val);
>  	default:
>  		/* BUG! */
>  		return 0;
> @@ -4190,7 +4144,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  			f = tep_find_any_field(event, arg->string.string);
>  			arg->string.offset = f->offset;
>  		}
> -		str_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->string.offset));
> +		str_offset = data2host4(tep, *(unsigned int *)(data + arg->string.offset));
>  		str_offset &= 0xffff;
>  		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
>  		break;
> @@ -4208,7 +4162,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  			f = tep_find_any_field(event, arg->bitmask.bitmask);
>  			arg->bitmask.offset = f->offset;
>  		}
> -		bitmask_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
> +		bitmask_offset = data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
>  		bitmask_size = bitmask_offset >> 16;
>  		bitmask_offset &= 0xffff;
>  		print_bitmask_to_seq(tep, s, format, len_arg,
> @@ -6762,9 +6716,9 @@ static int find_event_handle(struct tep_handle *tep, struct tep_event *event)
>   *
>   * /sys/kernel/debug/tracing/events/.../.../format
>   */
> -enum tep_errno __tep_parse_format(struct tep_event **eventp,
> -				  struct tep_handle *tep, const char *buf,
> -				  unsigned long size, const char *sys)
> +__hidden enum tep_errno __tep_parse_format(struct tep_event **eventp,
> +					   struct tep_handle *tep, const char *buf,
> +					   unsigned long size, const char *sys)

Hmm,  I don't see this function used outside of event-parse.c. I think
we can just make it a static, and perhaps rename it to "__parse_format"?

-- Steve


>  {
>  	struct tep_event *event;
>  	int ret;
> @@ -6897,7 +6851,7 @@ __parse_event(struct tep_handle *tep,
>  	return 0;
>  
>  event_add_failed:
> -	tep_free_event(event);
> +	free_tep_event(event);
>  	return ret;
>  }
>  
> @@ -7490,7 +7444,7 @@ int tep_get_ref(struct tep_handle *tep)
>  	return 0;
>  }
>  
> -void tep_free_format_field(struct tep_format_field *field)
> +__hidden void free_tep_format_field(struct tep_format_field *field)
>  {
>  	free(field->type);
>  	if (field->alias != field->name)
> @@ -7505,7 +7459,7 @@ static void free_format_fields(struct tep_format_field *field)
>  
>  	while (field) {
>  		next = field->next;
> -		tep_free_format_field(field);
> +		free_tep_format_field(field);
>  		field = next;
>  	}
>  }
> @@ -7516,7 +7470,7 @@ static void free_formats(struct tep_format *format)
>  	free_format_fields(format->fields);
>  }
>  
> -void tep_free_event(struct tep_event *event)
> +__hidden void free_tep_event(struct tep_event *event)
>  {
>  	free(event->name);
>  	free(event->system);
> @@ -7602,7 +7556,7 @@ void tep_free(struct tep_handle *tep)
>  	}
>  
>  	for (i = 0; i < tep->nr_events; i++)
> -		tep_free_event(tep->events[i]);
> +		free_tep_event(tep->events[i]);
>  
>  	while (tep->handlers) {
>  		handle = tep->handlers;
> @@ -7613,7 +7567,7 @@ void tep_free(struct tep_handle *tep)
>  	free(tep->events);
>  	free(tep->sort_events);
>  	free(tep->func_resolver);
> -	tep_free_plugin_paths(tep);
> +	free_tep_plugin_paths(tep);
>  
>  	free(tep);
>  }
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index c29b693e31ee..a67ad9a5b835 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -578,14 +578,6 @@ void tep_ref(struct tep_handle *tep);
>  void tep_unref(struct tep_handle *tep);
>  int tep_get_ref(struct tep_handle *tep);
>  
> -/* access to the internal parser */
> -void tep_buffer_init(const char *buf, unsigned long long size);
> -enum tep_event_type tep_read_token(char **tok);
> -void tep_free_token(char *token);
> -int tep_peek_char(void);
> -const char *tep_get_input_buf(void);
> -unsigned long long tep_get_input_buf_ptr(void);
> -
>  /* for debugging */
>  void tep_print_funcs(struct tep_handle *tep);
>  void tep_print_printk(struct tep_handle *tep);
> diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
> index e7c2acb8680f..e7f93d5fe4fd 100644
> --- a/tools/lib/traceevent/event-plugin.c
> +++ b/tools/lib/traceevent/event-plugin.c
> @@ -676,7 +676,7 @@ int tep_add_plugin_path(struct tep_handle *tep, char *path,
>  	return 0;
>  }
>  
> -void tep_free_plugin_paths(struct tep_handle *tep)
> +__hidden void free_tep_plugin_paths(struct tep_handle *tep)
>  {
>  	struct tep_plugins_dir *dir;
>  
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index c271aeeb227d..368826bb5a57 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -38,8 +38,8 @@ static void show_error(char *error_buf, const char *fmt, ...)
>  	int len;
>  	int i;
>  
> -	input = tep_get_input_buf();
> -	index = tep_get_input_buf_ptr();
> +	input = get_input_buf();
> +	index = get_input_buf_ptr();
>  	len = input ? strlen(input) : 0;
>  
>  	if (len) {
> @@ -57,25 +57,20 @@ static void show_error(char *error_buf, const char *fmt, ...)
>  	va_end(ap);
>  }
>  
> -static void free_token(char *token)
> -{
> -	tep_free_token(token);
> -}
> -
> -static enum tep_event_type read_token(char **tok)
> +static enum tep_event_type filter_read_token(char **tok)
>  {
>  	enum tep_event_type type;
>  	char *token = NULL;
>  
>  	do {
>  		free_token(token);
> -		type = tep_read_token(&token);
> +		type = read_token(&token);
>  	} while (type == TEP_EVENT_NEWLINE || type == TEP_EVENT_SPACE);
>  
>  	/* If token is = or ! check to see if the next char is ~ */
>  	if (token &&
>  	    (strcmp(token, "=") == 0 || strcmp(token, "!") == 0) &&
> -	    tep_peek_char() == '~') {
> +	    peek_char() == '~') {
>  		/* append it */
>  		*tok = malloc(3);
>  		if (*tok == NULL) {
> @@ -85,7 +80,7 @@ static enum tep_event_type read_token(char **tok)
>  		sprintf(*tok, "%c%c", *token, '~');
>  		free_token(token);
>  		/* Now remove the '~' from the buffer */
> -		tep_read_token(&token);
> +		read_token(&token);
>  		free_token(token);
>  	} else
>  		*tok = token;
> @@ -959,7 +954,7 @@ process_filter(struct tep_event *event, struct tep_filter_arg **parg,
>  
>  	do {
>  		free(token);
> -		type = read_token(&token);
> +		type = filter_read_token(&token);
>  		switch (type) {
>  		case TEP_EVENT_SQUOTE:
>  		case TEP_EVENT_DQUOTE:
> @@ -1185,7 +1180,7 @@ process_event(struct tep_event *event, const char *filter_str,
>  {
>  	int ret;
>  
> -	tep_buffer_init(filter_str, strlen(filter_str));
> +	init_input_buf(filter_str, strlen(filter_str));
>  
>  	ret = process_filter(event, parg, error_str, 0);
>  	if (ret < 0)
> @@ -1243,7 +1238,7 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
>  static void filter_init_error_buf(struct tep_event_filter *filter)
>  {
>  	/* clear buffer to reset show error */
> -	tep_buffer_init("", 0);
> +	init_input_buf("", 0);
>  	filter->error_buffer[0] = '\0';
>  }
>  

