Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553C9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AFF861361
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239880AbhKHWIk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:08:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:57096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231330AbhKHWIk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 17:08:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD02B61361;
        Mon,  8 Nov 2021 22:05:54 +0000 (UTC)
Date:   Mon, 8 Nov 2021 17:05:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/10] user_events: Handle matching arguments from
 dyn_events
Message-ID: <20211108170553.2d2a84b6@gandalf.local.home>
In-Reply-To: <20211104170433.2206-5-beaub@linux.microsoft.com>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-5-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Nov 2021 10:04:27 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Ensures that when dynamic events requests a match with arguments that
> they match what is in the user_event.
> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> ---
>  kernel/trace/trace_events_user.c | 67 +++++++++++++++++++++++++++++++-
>  1 file changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index 479a9ced3281..cd78cc481557 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -662,13 +662,78 @@ static int user_event_free(struct dyn_event *ev)
>  	return destroy_user_event(user);
>  }
>  
> +static int user_field_match(struct ftrace_event_field *field, int argc,
> +			    const char **argv, int *iout)
> +{
> +	char field_name[256];
> +	char arg_name[256];

I'm a bit nervous about allocating that much on the stack. This isn't a
critical function. I think it is best to just kmalloc it, and fail in the
unlikely event that the kmalloc fails. It should never fail unless there's
major memory issues with the system.

-- Steve


> +	int len, pos, i = *iout;
> +	bool colon = false;
> +
> +	if (i >= argc)
> +		return false;
> +
> +	len = sizeof(arg_name);
> +	pos = 0;
> +
> +	for (; i < argc; ++i) {
> +		if (i != *iout)
> +			pos += snprintf(arg_name + pos, len - pos, " ");
> +
> +		pos += snprintf(arg_name + pos, len - pos, argv[i]);
> +
> +		if (strchr(argv[i], ';')) {
> +			++i;
> +			colon = true;
> +			break;
> +		}
> +	}
> +
> +	len = sizeof(field_name);
> +	pos = 0;
> +
> +	pos += snprintf(field_name + pos, len - pos, field->type);
> +	pos += snprintf(field_name + pos, len - pos, " ");
> +	pos += snprintf(field_name + pos, len - pos, field->name);
> +
> +	if (colon)
> +		pos += snprintf(field_name + pos, len - pos, ";");
> +
> +	*iout = i;
> +
> +	return strcmp(arg_name, field_name) == 0;
> +}
> +
> +static bool user_fields_match(struct user_event *user, int argc,
> +			      const char **argv)
> +{
> +	struct ftrace_event_field *field, *next;
> +	struct list_head *head = &user->fields;
> +	int i = 0;
> +
> +	list_for_each_entry_safe_reverse(field, next, head, link)
> +		if (!user_field_match(field, argc, argv, &i))
> +			return false;
> +
> +	if (i != argc)
> +		return false;
> +
> +	return true;
> +}
> +
>  static bool user_event_match(const char *system, const char *event,
>  			     int argc, const char **argv, struct dyn_event *ev)
>  {
>  	struct user_event *user = container_of(ev, struct user_event, devent);
> +	bool match;
>  
> -	return strcmp(EVENT_NAME(user), event) == 0 &&
> +	match = strcmp(EVENT_NAME(user), event) == 0 &&
>  		(!system || strcmp(system, USER_EVENTS_SYSTEM) == 0);
> +
> +	if (match && argc > 0)
> +		match = user_fields_match(user, argc, argv);
> +
> +	return match;
>  }
>  
>  static struct dyn_event_operations user_event_dops = {

