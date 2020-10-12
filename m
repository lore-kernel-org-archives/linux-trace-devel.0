Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD87C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 17:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A549820797
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 17:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390821AbgJLR6J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 13:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390820AbgJLR6J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 13:58:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90D4A205CA;
        Mon, 12 Oct 2020 17:58:06 +0000 (UTC)
Date:   Mon, 12 Oct 2020 13:58:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zamir SUN <sztsian@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: libtraceevent: make doc-install tries different file names than
 generated
Message-ID: <20201012135804.2489f70e@gandalf.local.home>
In-Reply-To: <b592e388-5af1-5269-37ce-8ca9e91c84dd@gmail.com>
References: <7cdec98e-3184-4ddc-e78c-867a9650e636@gmail.com>
        <20201009104954.0fd440b5@gandalf.local.home>
        <b592e388-5af1-5269-37ce-8ca9e91c84dd@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Oct 2020 20:35:20 +0800
Zamir SUN <sztsian@gmail.com> wrote:

> Hi Steve,
> 
> I just tried compiling the document. IIUC with this patch, the man pages 
> are generated. Most of them still have tep_ prefix. Not sure if this is 
> intended so I'm posting the list of generated man page in gist as it's a 
> bit long.
> https://gist.github.com/sztsian/442db46a48c1d1ec3500b161a1232a0a
> 
> OTOH, I notice that a lot of generation tasks was executing during the 
> doc-install phase. I'm really not familiar with man page compiling, so 
> can you check if this is an intended way? I posted the doc-install log 
> in the following link.
> 
> https://gist.github.com/sztsian/6d1588272c07c7b2c3bed14a049b7df2
> 

Bah, I'm not sure how the documentation build system here works. Ideally,
we want to make sure that "man tep_.." works, and people don't need to
state "man libtraceevent_...", as the tep_* commands are what will be used.

Let me investigate this.

Thanks!

-- Steve
