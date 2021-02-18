Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D8CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 17:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1067764EB3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 17:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhBRRq2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 12:46:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231495AbhBROYt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 09:24:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D5864EAE;
        Thu, 18 Feb 2021 14:23:55 +0000 (UTC)
Date:   Thu, 18 Feb 2021 09:23:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace-cmd: Add validation for reading and writing
 trace.dat files
Message-ID: <20210218092353.51fdc9e1@gandalf.local.home>
In-Reply-To: <CAPpZLN7L4Yg4ePE-dWQ+WHf6h_8gShcYBEBSGrxDrvV32DOv9w@mail.gmail.com>
References: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
        <20210217042341.1675546-2-tz.stoyanov@gmail.com>
        <20210217110045.71771e87@gandalf.local.home>
        <CAPpZLN4EoCES6CHo8uoyOoFr9nopOkQZKVF5voFPCYM4pnzyhg@mail.gmail.com>
        <20210217132749.70281f99@gandalf.local.home>
        <CAPpZLN7L4Yg4ePE-dWQ+WHf6h_8gShcYBEBSGrxDrvV32DOv9w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 18 Feb 2021 05:49:41 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> This works for the current structure of trace.dat file, we can have
> these assumptions
> and use state instead of a bitmask. But in the future, if we decide to
> add optional
> sections in the file, or more complex branches - assumptions could not
> be valid and
> state should be changed to something more flexible.

And why I think it's good to have both a state enumeration (for things that
must exist in a particular order) and flags for things that are optional
and you don't care about order.

> As this is not part of any external API, I'm OK to change bitmask to
> state. This easily
> can be redesigned in the future, if needed.

Yes, this can most definitely change in the future, and I like that you are
thinking about the future and ways to be flexible. But we also don't want
to make things too complex. Having a state enumeration (counter) and flags
together handles all cases, and I would recommend doing so as a counter.
If there's something that's optional, we can use the flags.

Care to send a v2?

Thanks!

-- Steve
