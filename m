Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31727C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B09361054
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbhKHWGh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:06:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231330AbhKHWGg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 17:06:36 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C1E561054;
        Mon,  8 Nov 2021 22:03:51 +0000 (UTC)
Date:   Mon, 8 Nov 2021 17:03:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 03/10] user_events: Add print_fmt generation support
 for basic types
Message-ID: <20211108170349.66db0f58@gandalf.local.home>
In-Reply-To: <20211104170433.2206-4-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-4-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Nov 2021 10:04:26 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Addes print_fmt format generation for basic types that are supported for
> user processes. Only supports sizes that are the same on 32 and 64 bit.
> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> ---
>  kernel/trace/trace_events_user.c | 108 ++++++++++++++++++++++++++++++-
>  1 file changed, 106 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index a68017ad7fdd..479a9ced3281 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -329,6 +329,107 @@ static int user_event_parse_fields(struct user_event *user, char *args)
>  	return ret;
>  }
>  
> +static char *user_field_format(const char *type)

Should be const char *

> +{
> +	if (strcmp(type, "s64") == 0)
> +		return "%lld";
> +	if (strcmp(type, "u64") == 0)
> +		return "%llu";
> +	if (strcmp(type, "s32") == 0)
> +		return "%d";
> +	if (strcmp(type, "u32") == 0)
> +		return "%u";
> +	if (strcmp(type, "int") == 0)
> +		return "%d";
> +	if (strcmp(type, "unsigned int") == 0)
> +		return "%u";
> +	if (strcmp(type, "s16") == 0)
> +		return "%d";
> +	if (strcmp(type, "u16") == 0)
> +		return "%u";
> +	if (strcmp(type, "short") == 0)
> +		return "%d";
> +	if (strcmp(type, "unsigned short") == 0)
> +		return "%u";
> +	if (strcmp(type, "s8") == 0)
> +		return "%d";
> +	if (strcmp(type, "u8") == 0)
> +		return "%u";
> +	if (strcmp(type, "char") == 0)
> +		return "%d";
> +	if (strcmp(type, "unsigned char") == 0)
> +		return "%u";
> +	if (strstr(type, "char[") != 0)
> +		return "%s";
> +
> +	/* Unknown, likely struct, allowed treat as 64-bit */
> +	return "%llu";
> +}
> +
> +static bool user_field_is_dyn_string(const char *type)
> +{
> +	if (strstr(type, "__data_loc ") == type ||
> +	    strstr(type, "__rel_loc ") == type) {

Use str_has_prefix().

-- Steve


> +		if (strstr(type, "char[") != 0)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +#define LEN_OR_ZERO (len ? len - pos : 0)
> +static int user_event_set_print_fmt(struct user_event *user, char *buf, int len)
> +{
> +	struct ftrace_event_field *field, *next;
> +	struct list_head *head = &user->fields;
> +	int pos = 0, depth = 0;
> +
> +	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"");
> +
> +	list_for_each_entry_safe_reverse(field, next, head, link) {
> +		if (depth != 0)
> +			pos += snprintf(buf + pos, LEN_OR_ZERO, " ");
> +
> +		pos += snprintf(buf + pos, LEN_OR_ZERO, "%s=%s",
> +				field->name, user_field_format(field->type));
> +
> +		depth++;
> +	}
> +
> +	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"");
> +
> +	list_for_each_entry_safe_reverse(field, next, head, link) {
> +		if (user_field_is_dyn_string(field->type))
> +			pos += snprintf(buf + pos, LEN_OR_ZERO,
> +					", __get_str(%s)", field->name);
> +		else
> +			pos += snprintf(buf + pos, LEN_OR_ZERO,
> +					", REC->%s", field->name);
> +	}
> +
> +	return pos + 1;
> +}
> +#undef LEN_OR_ZERO
> +
> +static int user_event_create_print_fmt(struct user_event *user)
> +{
> +	char *print_fmt;
> +	int len;
> +
> +	len = user_event_set_print_fmt(user, NULL, 0);
> +
> +	print_fmt = kmalloc(len, GFP_KERNEL);
> +
> +	if (!print_fmt)
> +		return -ENOMEM;
> +
> +	user_event_set_print_fmt(user, print_fmt, len);
> +
> +	user->call.print_fmt = print_fmt;
> +
> +	return 0;
> +}
> +
>  static struct trace_event_fields user_event_fields_array[] = {
>  	{}
>  };
> @@ -366,6 +467,7 @@ static int destroy_user_event(struct user_event *user)
>  	clear_bit(user->index, page_bitmap);
>  	hash_del(&user->node);
>  
> +	kfree(user->call.print_fmt);
>  	kfree(EVENT_NAME(user));
>  	kfree(user);
>  
> @@ -637,8 +739,10 @@ static int user_event_parse(char *name, char *args, char *flags,
>  	if (ret)
>  		goto put_user;
>  
> -	/* Minimal print format */
> -	user->call.print_fmt = "\"\"";
> +	ret = user_event_create_print_fmt(user);
> +
> +	if (ret)
> +		goto put_user;
>  
>  	user->call.data = user;
>  	user->call.class = &user->class;

