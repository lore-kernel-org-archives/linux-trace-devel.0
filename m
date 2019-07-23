Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D08C7618F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 01:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36D1821955
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 01:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387747AbfGWBRn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 21:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbfGWBRm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 21:17:42 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A76821955;
        Tue, 23 Jul 2019 01:17:41 +0000 (UTC)
Date:   Mon, 22 Jul 2019 21:17:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Troy Engel <troyengel@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Update home url for trace-cmd and kernelshark
Message-ID: <20190722211740.54493d12@oasis.local.home>
In-Reply-To: <CAO7q0mnKAAv9u+vGrzvnu=w4GBRvw7Aq+43BFmE6YKkY_XzP-A@mail.gmail.com>
References: <20190722150359.79e66a77@gandalf.local.home>
        <CAO7q0mnKAAv9u+vGrzvnu=w4GBRvw7Aq+43BFmE6YKkY_XzP-A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Jul 2019 18:26:16 -0500
Troy Engel <troyengel@gmail.com> wrote:

> Hi Steven,
> 
> Can do -- right now we have the stable pinned at 2.7 which doesn't exist in
> the new upstream repo, it appears the tags started with 2.8. I edited the

Right. I just pushed trace-cmd-v2.7 tag to the new repo ;-)

> build file locally but it's probably a dead end with 2.7 (it'll die out
> naturally) - 2.7 is pinned because we have the older GTK kernelshark binary
> in there, trace-cmd 2.8.x will release with KS 1.0 to supply a clean
> upgrade to users. It's also a good clean break if those Python 3 patches
> merge, we use the new hotness to introduce that change as well (gtk -> qt,
> py2 -> py3, 1pkg -> 2pkgs).

I need to push the patches. Haven't done that yet. I will tomorrow.

> 
> For the trace-cmd-git package working off HEAD, now that trace-cmd has to

Note, please use the trace-cmd-stable-v2.8 branch. HEAD for master will
soon be holding development code for 2.9, and will be quite unstable.

> be installed first to compile kernelshark 1.0 we need to break this apart
> into two separate packages which I just haven't done yet; I have it also

It's good to have the separation. We plan on working on splitting
KernelShark out of the trace-cmd git repo soon. But I don't think it's
a good idea to make the build of KernelShark depend on trace-cmd being
installed.


> edited locally in the master build file - once y'all tag KS 1.0 then we
> split this single/monolithic version we've been working with out into two
> packages solving the current chicken & egg problem, which then gets pushed
> to stable (non-git). Based on your projections in the other email, within a
> week or so but no pressure.

:-)  Last year I said KernelShark 1.0 will be released by August.
August came and went and people asked me where KernelShark 1.0 is? I
told them, I did not specify *which* August ;-) But I better not let
that happen again.

> 
> tl;dr - will do, just can't push the commits right away; we'll get the URL
> changed with the packaging split/rebuild needed for trace-cmd 2.8.x / KS
> 1.0 happening soon.

With a trace-cmd-v2.7 tag in the main repo, can you make the update?

Thanks Troy!

-- Steve
