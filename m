Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444E3C388F7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 14:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E68B52223C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Nov 2020 14:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgKMOtC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Nov 2020 09:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgKMOtC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Nov 2020 09:49:02 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB6F221D79;
        Fri, 13 Nov 2020 14:49:01 +0000 (UTC)
Date:   Fri, 13 Nov 2020 09:49:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 04/20] kernel-shark: Introduce Data streams
Message-ID: <20201113094900.594bb761@gandalf.local.home>
In-Reply-To: <164442c9-0732-2fda-d6d2-96077d6f170e@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
        <20201112142358.36821-5-y.karadz@gmail.com>
        <20201112155051.18e226e9@gandalf.local.home>
        <164442c9-0732-2fda-d6d2-96077d6f170e@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 13 Nov 2020 15:47:04 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > I wonder if this should be a string value that gets registered? Otherwise
> > we will have to be the registry of every new stream format added.
> > 
> > This is the approach that Tzvetomir took for protocol ids, because that way
> > we don't need to keep track of them:
> > 
> >   https://lore.kernel.org/r/20201029111816.247241-2-tz.stoyanov@gmail.com
> >   
> 
> I wonder how we can avoid name collisions, especially in the case when 
> some of the data readout plugins will be proprietary.
> Also I don't think we can expect more than a dozen of distinct data 
> formats to be supported.

A plugin would need to register a name on load. If two plugins were to
collide, the register would fail letting the plugin know why. Then the
plugin could retry with a different name "SCHED_TRACE2". Kind of like when
you try to add a user name in a website, and that name already exists.
Perhaps we shouldn't even bother with a hard coded name or ID. Perhaps
simply ask for an id, and save it into some global variable for that code,
and have all the checks test to make sure it matches the id that it
received.

In any case, seeing the VMware SchedTrace there makes that stick out as a
big RED flag to me. I don't see why kernelshark needs to have anywhere in
its code IDs for proprietary systems. That would be NAK'd in any other open
source project.

-- Steve
