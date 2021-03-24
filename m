Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA17EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7F9619A4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbhCXPVP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236605AbhCXPUw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 11:20:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0376D619A4;
        Wed, 24 Mar 2021 15:20:51 +0000 (UTC)
Date:   Wed, 24 Mar 2021 11:20:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 16/23] trace-cmd: Add a new flag to disable any
 timestamp corrections
Message-ID: <20210324112050.57255e27@gandalf.local.home>
In-Reply-To: <20210324102424.17b34779@gandalf.local.home>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-17-tz.stoyanov@gmail.com>
        <20210324102424.17b34779@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 10:24:24 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 24 Mar 2021 15:04:11 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
> > @@ -2601,7 +2605,8 @@ static int handle_options(struct tracecmd_input *handle)
> >  			 * gtod. It is stored as ASCII with '0x'
> >  			 * appended.
> >  			 */
> > -			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
> > +			if (handle->flags &
> > +			    (TRACECMD_FL_IGNORE_DATE || TRACECMD_FL_RAW_TS))  
> 
> Needs to be a binary 'or' "|", not a logical 'or' "||", as the above is the
> same as:  if (handle->flags & 1)
> 
> If I don't find anything else wrong in this series, I'll fix this myself.
> 

As I'm finding more things to fix, please do this update in your next
revision.

-- Steve
