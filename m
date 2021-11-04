Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C1CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 03:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9BC2610A8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 03:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhKDDJF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 23:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhKDDJE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 23:09:04 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA6BF60EB4;
        Thu,  4 Nov 2021 03:06:26 +0000 (UTC)
Date:   Wed, 3 Nov 2021 23:06:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 05/11] libtracefs: Change tracefs_kprobe_info API
Message-ID: <20211103230625.284fb344@rorschach.local.home>
In-Reply-To: <20211103154417.246999-6-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
        <20211103154417.246999-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  3 Nov 2021 17:44:11 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> -enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
> -					     char **type, char **addr, char **format)
> +enum tracefs_dynevent_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
> +					       char **system, char **event,
> +					       char **prefix, char **addr, char **format)
>  {
> -	enum tracefs_kprobe_type rtype = TRACEFS_ALL_KPROBES;
> -	char *saveptr;
> -	char *content;
> -	char *system;
> -	char *probe;
> -	char *ktype;
> -	char *kaddr;
> -	char *kfmt;
> -	int ret;
> -
> -	if (!group)
> -		group = KPROBE_DEFAULT_GROUP;
> -
> -	if (type)
> -		*type = NULL;
> +	if (system)
> +		*system = NULL;
> +	if (event)
> +		*event = NULL;
> +	if (prefix)
> +		*prefix = NULL;
>  	if (addr)
>  		*addr = NULL;
>  	if (format)
>  		*format = NULL;
>  
> -	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
> -	if (!content)
> -		return rtype;
> -
> -	ret = parse_kprobe(content, &saveptr, &ktype, &system, &probe,
> -			   &kaddr, &kfmt);
> -
> -	while (!ret) {
> -
> -		if (!strcmp(system, group) && !strcmp(probe, event)) {
> -			if (type)
> -				*type = strdup(ktype);
> -			if (addr)
> -				*addr = strdup(kaddr);
> -			if (format)
> -				*format = strdup(kfmt);
> +	if (!kprobe)
> +		return TRACEFS_DYNEVENT_MAX;
>  
> -			switch (*ktype) {
> -			case 'p': rtype = TRACEFS_KPROBE; break;
> -			case 'r': rtype = TRACEFS_KRETPROBE; break;
> -			}
> -			break;
> +	if (system) {
> +		if (kprobe->system) {
> +			*system = strdup(kprobe->system);
> +			if (!(*system))
> +				goto error;
>  		}
> -		ret = parse_kprobe(NULL, &saveptr, &ktype, &system, &probe,
> -				   &kaddr, &kfmt);
>  	}
> -	free(content);
> -	return rtype;
> +	if (event) {
> +		*event = strdup(kprobe->event);
> +		if (!(*event))
> +			goto error;
> +	}
> +	if (prefix) {
> +		*prefix = strdup(kprobe->prefix);
> +		if (!(*prefix))
> +			goto error;
> +	}
> +	if (addr && kprobe->address) {
> +		*addr = strdup(kprobe->address);
> +		if (!(*addr))
> +			goto error;
> +	}
> +	if (format && kprobe->format) {
> +		*format = strdup(kprobe->format);
> +		if (!(*format))
> +			goto error;
> +	}
> +
> +	return kprobe->type;
> +
> +error:
> +	if (system)
> +		free(*system);
> +	if (event)
> +		free(*event);
> +	if (prefix)
> +		free(*prefix);
> +	if (addr)
> +		free(*addr);
> +	if (format)
> +		free(*format);
> +	return TRACEFS_DYNEVENT_MAX;
>  }



The above can be shorten to just:

enum tracefs_dynevent_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
					       char **system, char **event,
					       char **prefix, char **addr, char **format)
{
	char **lvalues[] = { system, event, prefix, addr, format };
	char **rvalues[] = { &kprobe->system, &kprobe->event, &kprobe->prefix,
		&kprobe->address, &kprobe->format };
	int i;

	if (!kprobe)
		return TRACEFS_DYNEVENT_MAX;

	for (i = 0; i < 5; i++) {
		if (lvalues[i]) {
			if (*rvalues[i]) {
				*lvalues[i] = strdup(*rvalues[i]);
				if (!*lvalues[i])
					goto error;
			} else {
				*lvalues[i] = NULL;
			}
		}
	}

	return kprobe->type;

error:
	for (i--; i >= 0; i--) {
		if (lvalues[i])
			free(*lvalues[i]);
	}

	return TRACEFS_DYNEVENT_MAX;
}


 ;-)

-- Steve
