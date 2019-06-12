Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347DCC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1504C20866
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 12:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438667AbfFLMLI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438666AbfFLMLI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 08:11:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F9C208C4;
        Wed, 12 Jun 2019 12:11:07 +0000 (UTC)
Date:   Wed, 12 Jun 2019 08:11:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Alan Mikhak <alanmikhak@gmail.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Alan Mikhak <amikhak@wirelessfabric.com>
Subject: Re: [PATCH] Fix compiler error in KsSession.cpp on Raspberry Pi 3
Message-ID: <20190612081105.064b66b6@gandalf.local.home>
In-Reply-To: <876ffbbd-1574-3b06-c856-8b1930013bde@vmware.com>
References: <20190612035902.16366-1-amikhak@wirelessfabric.com>
        <876ffbbd-1574-3b06-c856-8b1930013bde@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 Jun 2019 08:17:38 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> Hi Alan,
> 
> I just noticed that you created couple of issues in the issue tracker of 
> the Steven's mirror repo on GitHub. Please note that the official 
> repository of the project is here
>   https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
> 
> and that the issue tracker that we use is here
>  
> https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---
> 
> Also I would like to ask you to copy the content of the trace data 
> visualization issue in the official issue tracker, because I find your 
> investigations interesting, and I think that this information can be 
> useful for someone else having the same problem.

Thanks Yordan for pointing this out. I have disabled "Issues" from the
github repository.

-- Steve
