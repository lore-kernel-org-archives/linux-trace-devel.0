Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FBD7C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E9661264
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhDVVOO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236851AbhDVVOO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 17:14:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED84613E6;
        Thu, 22 Apr 2021 21:13:38 +0000 (UTC)
Date:   Thu, 22 Apr 2021 17:13:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nicolas Sterchele <nicolas@sterchelen.net>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd list: Add --full to show print fmt of an
 event
Message-ID: <20210422171336.4872ec20@gandalf.local.home>
In-Reply-To: <20210422165148.6d0ea90e@gandalf.local.home>
References: <20210416141720.57a7963d@gandalf.local.home>
        <YIHfki40RQf+J8/Y@hercule>
        <20210422165148.6d0ea90e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 22 Apr 2021 16:51:48 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> One way I could have caught this was by adding the printf attribute to the
> die() header, where things like this will cause warnings.
> 
> Thanks for the report. I'll fix it.

You'll probably notice that this fix is not in my "die" update. That's
simply because this fix is not in the tree yet. I had to update my other
list options, and I'll include the update to this patch as well in my v2
posting.

Thanks,

-- Steve
