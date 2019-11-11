Return-Path: <SRS0=zoIR=ZD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E44C43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Nov 2019 23:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F73D2184C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Nov 2019 23:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfKKXC1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 18:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbfKKXC0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 18:02:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33AF6214DB;
        Mon, 11 Nov 2019 23:02:26 +0000 (UTC)
Date:   Mon, 11 Nov 2019 18:02:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     vincent.donnefort@arm.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Add support for built-in plugins
Message-ID: <20191111180224.2992867b@gandalf.local.home>
In-Reply-To: <1573126532-373130-1-git-send-email-vincent.donnefort@arm.com>
References: <1573126532-373130-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Vincent,

On Thu,  7 Nov 2019 11:35:32 +0000
vincent.donnefort@arm.com wrote:

> From: Vincent Donnefort <vincent.donnefort@arm.com>
> 
> When building trace-cmd with the -static option, plugins might not work, if
> the shared version for the Glibc is not available on the system. To still
> give a chance to have plugins, a new built-in mechanism is introduced.
> 
> The built-in build support for a plugin can be easily enabled with the
> declaration:
> 
>  TEP_PLUGIN(plugin_name)
>  {
>          plugin_init()
>  }
> 
>  /* optional */
>  TEP_PLUGIN(plugin_name)
>  {
>          plugin_exit()
>  }
> 
> Enabling as a first step, blk and sched_switch plugins as built-in.

I don't have a problem with the idea of this patch. My concern is that
the code in lib/traceevent will soon be obsoleted by using the
libtraceevent library in the Linux kernel under tools/lib/traceevent.

That means when we transition to the libtraceevent library, this work
will be lost.

Instead, could this be added to tools/lib/traceevent in the Linux
kernel somehow, and instead of building it into the executable, perhaps
make it part of the libtraceevent.a file (the static version of the
libary).

Thoughts?

-- Steve


