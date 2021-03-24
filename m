Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC08FC433E5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 12:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68EDE61A0A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 12:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhCXMPk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 08:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232625AbhCXMPh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 08:15:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 566A661A05;
        Wed, 24 Mar 2021 12:15:36 +0000 (UTC)
Date:   Wed, 24 Mar 2021 08:15:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 14/18] trace-cmd: Add a new flag to disable any
 timestamp corrections
Message-ID: <20210324081534.14455de8@gandalf.local.home>
In-Reply-To: <CAPpZLN66C=MuwPqzE4VkTbjC3Z=XYHhkt-eWj2z4Y4fcDAra4A@mail.gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
        <20210322095945.259300-15-tz.stoyanov@gmail.com>
        <20210323214928.0c47e295@oasis.local.home>
        <CAPpZLN66C=MuwPqzE4VkTbjC3Z=XYHhkt-eWj2z4Y4fcDAra4A@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 14:10:56 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > And why did we change the code for IGNORE_DATE here too?  
> 
> When we discuss the priorities of the various time sync options, I
> understood that the "--nodate" should affect the "--date" option only.
> For all other time sync options, the new flag should be used. That's
> why I changed IGNORE_DATE to RAW_TS in these two places.

I kind of remember that, but as it's unrelated to this patch, let's make
that a separate change, as it doesn't match the change log.

Thanks!

-- Steve
