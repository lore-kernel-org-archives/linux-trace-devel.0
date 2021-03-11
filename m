Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90297C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 17:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C4664FE9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 17:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCKRyX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 12:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhCKRx4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 12:53:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B68464F9C;
        Thu, 11 Mar 2021 17:53:55 +0000 (UTC)
Date:   Thu, 11 Mar 2021 12:53:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC] Open multiple trace files and, if possible, pair them
Message-ID: <20210311125353.0b8e21dc@gandalf.local.home>
In-Reply-To: <20210311125040.25339858@gandalf.local.home>
References: <20210305062807.2734-1-stefano.devenuto99@gmail.com>
        <CAPpZLN4iz6cEPBYGwk-hQwB+=XrZ=qXosZyZp6i+BFKp8gF04Q@mail.gmail.com>
        <7439b1cf24293f4af1674783c3c6ebf337652713.camel@suse.com>
        <20210311125040.25339858@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Mar 2021 12:50:40 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> As trace-cmd already merges by time stamp of multiple trace files, I'm not
> sure there would be anything more to do once we implement the new API.

That said, we are hoping to have the new API out shortly, and it would be
fantastic if you could start testing it!

Thanks,

-- Steve
