Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3918BC3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 13:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF9A233A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 13:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfH1NGQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 09:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfH1NGQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 09:06:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 602EF2339E;
        Wed, 28 Aug 2019 13:06:15 +0000 (UTC)
Date:   Wed, 28 Aug 2019 09:06:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     stephen@brennan.io
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Provide parsing for quotation marks in
 Record command line
Message-ID: <20190828090614.1372a9a8@gandalf.local.home>
In-Reply-To: <20190828051018.GA5316@greed>
References: <20190827131418.18713-1-y.karadz@gmail.com>
        <20190828051018.GA5316@greed>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 27 Aug 2019 22:10:18 -0700
stephen@brennan.io wrote:

> It strikes me that this explicitly supports only a single set of quotes.
> This sort of behavior would be pretty surprising for people expecting shell
> quote support, and for people expecting just splitting on spaces.
> 
> I looked and couldn't really find any Qt utility for properly parsing shell
> quoting (similar to python's shlex module). I totally get that it's a lot
> of work to implement a correct shell quoting parser.
> 
> Maybe a compromise would be to add a checkbox to the capture dialog, which
> tells kernel-shark to pass the entire textbox contents, unmodified, to the
> shell implementation on the system. So, my example of:
> 
>     python -c 'print("hello world")'
> 
> Would get put into the third argument of the command:
> 
>     /bin/sh -c INSERT_TEXTBOX_CONTENTS_HERE
> 
> Then you could rely on /bin/sh doing the parsing for you. The downside is
> that it adds a whole new process. But you can't always get everything in
> life, right?
> 

I need to look at this a bit deeper. I've written lots of cases where I
had to capture single and double quotes and turn them into a single
command. This is definitely needed here.

I'm very reluctant to just use a simple /bin/sh, as this is being run
as root. Grant you, it is open to do anything, but I rather not just
make it into a root shell. Although we still allow you to run any
command. But once you add a full shell with the "sh -c" you now need to
deal with environment variables and such, which can cause more
unexpected side effects.

Basically, we want to be able to add single and double quotes, as well
as backslashes: my -c 'command\'s here' and '\\' this "too"

Thanks for the feedback.

-- Steve

