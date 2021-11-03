Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85898C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 22:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BAF460EB4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 22:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhKCWVe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 18:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231182AbhKCWVb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 18:21:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92702610EA;
        Wed,  3 Nov 2021 22:18:53 +0000 (UTC)
Date:   Wed, 3 Nov 2021 18:18:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 02/11] libtracefs: New APIs for dynamic events
Message-ID: <20211103181847.4e4ea8d1@gandalf.local.home>
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

> +
> +struct dyn_events_desc {
> +	enum tracefs_dynevent_type type;
> +	const char *file;
> +	const char *prefix;
> +	int (*dyn_events_del)(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn);
> +	int (*dyn_events_parse)(struct dyn_events_desc *desc, const char *group,
> +				char *line, struct tracefs_dynevent **ret_dyn);

BTW, there's no reason to have such a long field name for the function
pointer. Why not call it:

	int (*del)(...);
	int (*parse)(...);

?

It will make using it much easier and more readable.

-- Steve


> +} dynevents[] = {
> +	{TRACEFS_DYNEVENT_KPROBE, NULL, "p", dyn_generic_del, dyn_generic_parse},
> +	{TRACEFS_DYNEVENT_KRETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
> +	{TRACEFS_DYNEVENT_UPROBE, NULL, "p", dyn_generic_del, dyn_generic_parse},
> +	{TRACEFS_DYNEVENT_URETPROBE, NULL, "r", dyn_generic_del, dyn_generic_parse},
> +	{TRACEFS_DYNEVENT_EPROBE, NULL, "e", dyn_generic_del, dyn_generic_parse},
> +	{TRACEFS_DYNEVENT_SYNTH, NULL, "s", dyn_synth_del, dyn_synth_parse},
> +};
> +
