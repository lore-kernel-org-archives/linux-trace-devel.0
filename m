Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B42C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F1361075
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 May 2021 13:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhEENFL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 May 2021 09:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233040AbhEENFL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 May 2021 09:05:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D50A613BF;
        Wed,  5 May 2021 13:04:14 +0000 (UTC)
Date:   Wed, 5 May 2021 09:04:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nicolas Sterchele <nicolas@sterchelen.net>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: Record until a function call
Message-ID: <20210505090412.6618623e@gandalf.local.home>
In-Reply-To: <YJJJF6bu84uZ/B39@groot>
References: <YJJJF6bu84uZ/B39@groot>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 5 May 2021 09:28:23 +0200
Nicolas Sterchele <nicolas@sterchelen.net> wrote:

> Hi there,
> 
> I did not find any options permitting to record a trace until a function has been called.
> 
> For instance, you want to record every function calls of a specific
> process until a specific function has been called.
> Before doing this development, I would like to have your thoughts on
> this use case? Or if it is already possible?
> 
> thx.
> 

# trace-cmd start -p function -l '<stop-func>:traceoff '

Where "<stop-func>" is the function you want to stop at.

Note, when trying this out, I realized that there's a bug in the kernel
that it will ignore the "<stop-func>:traceoff" command if it doesn't have a
white space at the end. That's because its been tested with:

 # echo "<stop-func>:traceoff" > /sys/kernel/tracing/set_ftrace_filter

and the above command will write just the string, which the kernel will
think there's more to come, but not finish it if the file is closed. That
is:

 # echo -n "<stop-func>:traceoff" > /sys/kernel/tracing/set_ftrace_filter

will not work (the -n tells echo to not add a new line).

I'll have to fix that.

To clear it:

  # trace-cmd reset


-- Steve

