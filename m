Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C51C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 18:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 606B264E62
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 18:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbhBQS2d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 13:28:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhBQS2b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 13:28:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18DC464E5F;
        Wed, 17 Feb 2021 18:27:51 +0000 (UTC)
Date:   Wed, 17 Feb 2021 13:27:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace-cmd: Add validation for reading and writing
 trace.dat files
Message-ID: <20210217132749.70281f99@gandalf.local.home>
In-Reply-To: <CAPpZLN4EoCES6CHo8uoyOoFr9nopOkQZKVF5voFPCYM4pnzyhg@mail.gmail.com>
References: <20210217042341.1675546-1-tz.stoyanov@gmail.com>
        <20210217042341.1675546-2-tz.stoyanov@gmail.com>
        <20210217110045.71771e87@gandalf.local.home>
        <CAPpZLN4EoCES6CHo8uoyOoFr9nopOkQZKVF5voFPCYM4pnzyhg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Feb 2021 18:33:32 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> >
> > Why did you use bits, and not just a number?
> >

> 
> I use these flags to track what is in the file, not just a state. The
> state is the most significant bit which is set,
> but that way there is information for all passed states. I use the
> same logic when reading the file, to verify if
> all required information is in the file.

Of course if this is done via states, entering one state assumes that all
previous states have been entered (and thus must be set). For cases of
FLYRECORD and LATENCY, those two would diverge in states (basically like
branches in a tree), but still maintain that being in any given state,
stores the information that all previous states have been hit.

Or do you know of a situation where that is not the case?

-- Steve
