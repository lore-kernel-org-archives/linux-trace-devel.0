Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F40C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 22:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0A0B64FF4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 22:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhCDWbc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 17:31:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhCDWbb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 17:31:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1133164FEB;
        Thu,  4 Mar 2021 22:31:30 +0000 (UTC)
Date:   Thu, 4 Mar 2021 17:31:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Subject: Re: trace-cmd and host-guest tracing
Message-ID: <20210304173129.76fc3484@gandalf.local.home>
In-Reply-To: <1686fb51dbdee78d102796c68826a4837536db97.camel@suse.com>
References: <CAPpZLN4mySHF=z03gqGv1ZEa_a5Q4su6aP1F_MsG22e=GATyHQ@mail.gmail.com>
        <1686fb51dbdee78d102796c68826a4837536db97.camel@suse.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 04 Mar 2021 23:06:26 +0100
Dario Faggioli <dfaggioli@suse.com> wrote:

> If you don't mind, though, we'd still like to submit the patches he was
> working on, as RFC. Surely, the part of the code using the removed API
> would have to be ignored... But there's a couple of other things in
> those patches too, which we'd like, if possible, to have your feedback
> about. Let us know if this could be a problem...

As you said, "happens all the time in Open Source development", which is
true here as well.

No problem sending RFCs based on the old APIs. It may give us a better idea
of what you expect of this code as well.

Thanks,

-- Steve
