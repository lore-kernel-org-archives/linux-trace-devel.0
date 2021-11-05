Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC6DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E825603E8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhKEPFy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229680AbhKEPFx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 11:05:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE98860EBC;
        Fri,  5 Nov 2021 15:03:13 +0000 (UTC)
Date:   Fri, 5 Nov 2021 11:03:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 01/12] libtracefs: New APIs for dynamic events
Message-ID: <20211105110310.429d58e8@gandalf.local.home>
In-Reply-To: <20211105121624.398717-2-tz.stoyanov@gmail.com>
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
        <20211105121624.398717-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  5 Nov 2021 14:16:13 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static void init_devent_desc(void)
> +{
> +	int i;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(dynevents) != max_dyn_index);
> +
> +	/* Use  ftrace dynamic_events, if available */
> +	if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
> +		for (i = 0; i < max_dyn_index; i++)
> +			dynevents[i].file = DYNEVENTS_EVENTS;
> +		return;
> +	}
> +
> +	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
> +		dynevents[ffs(TRACEFS_DYNEVENT_KPROBE) - 1].file = KPROBE_EVENTS;
> +		dynevents[ffs(TRACEFS_DYNEVENT_KRETPROBE) - 1].file = KPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
> +		dynevents[ffs(TRACEFS_DYNEVENT_UPROBE) - 1].file = UPROBE_EVENTS;
> +		dynevents[ffs(TRACEFS_DYNEVENT_URETPROBE) - 1].file = UPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
> +		dynevents[ffs(TRACEFS_DYNEVENT_SYNTH) - 1].file = SYNTH_EVENTS;
> +		dynevents[ffs(TRACEFS_DYNEVENT_SYNTH) - 1].prefix = "";
> +	}
> +}
> +

I would have kept your bit_index() function to simplify the above. I just
meant to use ffs in that function.

static inline bit_index(unsigned int bits)
{
	return ffs(bits) - 1;
}

-- Steve

