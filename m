Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC390C10F13
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 21:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9030320821
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 21:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfDPVsN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 17:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbfDPVsN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 17:48:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D5D320868;
        Tue, 16 Apr 2019 21:48:11 +0000 (UTC)
Date:   Tue, 16 Apr 2019 17:48:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: Re: [PATCH v3 1/2] trace-cmd: Optimize how pid filters are
 expressed
Message-ID: <20190416174810.50d8a88d@gandalf.local.home>
In-Reply-To: <20190415230016.13932-2-kaslevs@vmware.com>
References: <20190415230016.13932-1-kaslevs@vmware.com>
        <20190415230016.13932-2-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 16 Apr 2019 02:00:15 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

>  static char *make_pid_filter(char *curr_filter, const char *field)
>  {
> +	int curr_len = 0, last_exclude = -1;

Small nit. Usually when adding multiple variables on one line like
this, the variables should be related. Because curr_len and
last_exclude are not related, it is best to keep them separate.

> +	int start_pid = -1, last_pid = -1;

start_pid and last_pid are fine on the same line or separate.

> +	char *filter = NULL, *save;


Note, It's better to keep variables separate. It makes it easier to see
them and also when code changes and you get the "variable x is not
used" warnings from gcc, it's easier to remove them. In emacs it brings
you to the warning and places the cursor on the problem line. Then a
simple "delete line" works well.

save could also be moved below.

>  	struct filter_pids *p;
> -	char *filter;
> -	char *orit;
> -	char *match;
> -	char *str;
> -	int curr_len = 0;
> -	int len;
>  
>  	/* Use the new method if possible */
>  	if (have_set_event_pid)
>  		return NULL;
>  
> -	len = len_filter_pids + (strlen(field) + strlen("(==)||")) * nr_filter_pids;
> -
> -	if (curr_filter) {
> -		curr_len = strlen(curr_filter);
> -		filter = realloc(curr_filter, curr_len + len + strlen("(&&())"));
> -		if (!filter)
> -			die("realloc");
> -		memmove(filter+1, curr_filter, curr_len);
> -		filter[0] = '(';
> -		strcat(filter, ")&&(");
> -		curr_len = strlen(filter);
> -	} else
> -		filter = malloc(len);
> -	if (!filter)
> -		die("Failed to allocate pid filter");
> -
> -	/* Last '||' that is not used will cover the \0 */
> -	str = filter + curr_len;
> +	if (!filter_pids)
> +		return curr_filter;
>  
>  	for (p = filter_pids; p; p = p->next) {
> -		if (p->exclude) {
> -			match = "!=";
> -			orit = "&&";
> -		} else {
> -			match = "==";
> -			orit = "||";
> +		/* PIDs are inserted in `filter_pids` from the front and that's

Comment notation should be:

		/*
		 * PIDs are inserted in ...

Only the Networking folks are allowed to do it that way in the
kernel ;-)

> +		 * why we expect them in descending order here.
> +		 */
> +		if (p->pid == last_pid - 1 && p->exclude == last_exclude) {
> +			last_pid = p->pid;
> +			continue;
>  		}
> -		if (p == filter_pids)
> -			orit = "";
>  
> -		len = sprintf(str, "%s(%s%s%d)", orit, field, match, p->pid);
> -		str += len;
> +		if (start_pid != -1)
> +			append_filter_pid_range(&filter, &curr_len, field,
> +						last_pid, start_pid,
> +						last_exclude);
> +
> +		start_pid = last_pid = p->pid;
> +		last_exclude = p->exclude;
> +
>  	}
> +	append_filter_pid_range(&filter, &curr_len, field,
> +				last_pid, start_pid, last_exclude);
>  
> -	if (curr_len)
> -		sprintf(str, ")");
> +	if (curr_filter) {

As save is only used here, we could have:

		char *save = filter;

> +		save = filter;
> +		asprintf(&filter, "(%s)&&(%s)", curr_filter, filter);
> +		free(save);
> +	}
>  
>  	return filter;
>  }

-- Steve
