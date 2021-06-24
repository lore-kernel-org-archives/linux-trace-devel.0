Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AABAC49EA6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 16:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44EEE613D8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jun 2021 16:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhFXQsD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Jun 2021 12:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFXQsD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Jun 2021 12:48:03 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2538613D8;
        Thu, 24 Jun 2021 16:45:43 +0000 (UTC)
Date:   Thu, 24 Jun 2021 12:45:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] libtracefs: Add APIs for data streaming
Message-ID: <20210624124542.5ca75fe3@oasis.local.home>
In-Reply-To: <20210624145101.87233-1-y.karadz@gmail.com>
References: <20210624145101.87233-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 24 Jun 2021 17:51:01 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The new APIs can be used to dump the content of "trace_pipe" into a
> file or directly to "stdout". The "splice" system call is used to
> moves the data without copying. The new functionality is essentially
> identical to what 'trace-cmd show -p' does.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> 

So I did some investigations here, and found that splice() is not
guaranteed to work on a terminal output.

To overcome this, I decided to have the print create another pipe, and
pass that to the stream code. The if something was read, it would read
the pipe.

It required changing the return of the functions to return the amount
transferred, so that I can differentiate between "EOF" with nothing
read, and something read. Because I couldn't get the pipe to not block
on read if there was no content in it. :-/

Anyway, I submitted a v4 with the changes I made, and it appears to
work. I haven't tested it that much, so it may still have bugs.

We could optimize it to just use the splice output first (stream
first), and if that returns with EINVAL, which is the expected error on
a non functioning stdout, we could then switch to this alternate method.

Although, the stream would have read some of the pipe and lost the
data, which is not what we want, so a test of stdout would need to be
made with splice first. :-/

-- Steve
