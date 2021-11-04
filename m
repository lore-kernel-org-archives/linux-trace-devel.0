Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A836EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 14:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8854E6109F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 14:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhKDOk3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 10:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhKDOk3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 10:40:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 214F6611C1;
        Thu,  4 Nov 2021 14:37:51 +0000 (UTC)
Date:   Thu, 4 Nov 2021 10:37:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] libtracefs: New APIs for dynamic events
Message-ID: <20211104103749.215d8098@gandalf.local.home>
In-Reply-To: <20211104111047.302660-2-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
        <20211104111047.302660-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Nov 2021 13:10:38 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static void init_devent_desc(void)
> +{
> +	int max = bit_index(TRACEFS_DYNEVENT_MAX);
> +	int i;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(dynevents) != max);
> +
> +	/* Use  ftrace dynamic_events, if available */
> +	if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
> +		for (i = 0; i < max; i++)
> +			dynevents[i].file = DYNEVENTS_EVENTS;
> +		return;
> +	}
> +
> +	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
> +		dynevents[bit_index(TRACEFS_DYNEVENT_KPROBE)].file = KPROBE_EVENTS;
> +		dynevents[bit_index(TRACEFS_DYNEVENT_KRETPROBE)].file = KPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
> +		dynevents[bit_index(TRACEFS_DYNEVENT_UPROBE)].file = UPROBE_EVENTS;
> +		dynevents[bit_index(TRACEFS_DYNEVENT_URETPROBE)].file = UPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
> +		dynevents[bit_index(TRACEFS_DYNEVENT_SYNTH)].file = SYNTH_EVENTS;
> +		dynevents[bit_index(TRACEFS_DYNEVENT_SYNTH)].prefix = "";
> +	}
> +

Nit. Remove the extra line.

-- Steve

> +}
> +
