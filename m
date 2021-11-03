Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1D8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 17:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8447161101
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 17:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbhKCRF7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232946AbhKCRF7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 13:05:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE3061053;
        Wed,  3 Nov 2021 17:03:22 +0000 (UTC)
Date:   Wed, 3 Nov 2021 13:03:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] libtracefs: New APIs for dynamic events
Message-ID: <20211103130319.0c932fce@gandalf.local.home>
In-Reply-To: <20211103154417.246999-3-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
        <20211103154417.246999-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  3 Nov 2021 17:44:08 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
> +			     char *line, struct tracefs_dynevent **ret_dyn)
> +{
> +	struct tracefs_dynevent *dyn;
> +	char *format = NULL;
> +	char *address;
> +	char *system;
> +	char *prefix;
> +	char *event;
> +	char *sav;
> +
> +	if (strncmp(line, desc->prefix, strlen(desc->prefix)))
> +		return -1;
> +
> +	prefix = strtok_r(line, ":", &sav);
> +	if (!prefix)
> +		return -1;

What if the user adds a name for the event?

	p:name system/event

?

> +	system = strtok_r(NULL, "/", &sav);
> +	if (!system)
> +		return -1;
> +	event = strtok_r(NULL, " ", &sav);
> +	if (!event)
> +		return -1;
> +	address = strtok_r(NULL, " ", &sav);
> +	if (!address)
> +		address = event + strlen(event) + 1;
> +	else
> +		format = address + strlen(address) + 1;

I'm not sure this is what you want to do, as the above is dangerous. If we
have the following string:

  "p: system/event"

	event + strlen(event) = '\0'
	event + strlen(event) + 1 = out-of-bounds;

Note, strtok_r() does not need to find the delimiter if the token is the
last delimiter.

	char str[] = "first last";
	char *a, *b, *s;

	a = strtok_r(str, " ", &s);
	b = strtok_r(NULL, " ", &s);

Will result with: a = "first" and b = "last"

-- Steve
	

	

> +
> +	/* KPROBEs and UPROBEs share the same prefix, check the format */
> +	if (desc->type == TRACEFS_DYNEVENT_UPROBE || desc->type == TRACEFS_DYNEVENT_URETPROBE) {
> +		if (!strchr(address, '/'))
> +			return -1;
> +	}
> +	if (group && strcmp(group, system) != 0)
> +		return -1;
> +
> +	if (!ret_dyn)
> +		return 0;
> +
> +	dyn = calloc(1, sizeof(*dyn));
> +	if (!dyn)
> +		return -1;
> +
