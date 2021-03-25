Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD079C433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 13:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF5C61A1F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 13:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhCYNle (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 09:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229869AbhCYNlW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 09:41:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1837D61A1E;
        Thu, 25 Mar 2021 13:41:22 +0000 (UTC)
Date:   Thu, 25 Mar 2021 09:41:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 21/23] trace-cmd: Get current clock for host-guest
 tracing session
Message-ID: <20210325094120.1b4e597e@gandalf.local.home>
In-Reply-To: <CAPpZLN7Cj9Bzwmnc52jWFnGZHTAeTk+0v=oxHZ-+iJLmfJ4XEA@mail.gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-22-tz.stoyanov@gmail.com>
        <20210324171556.47b8065f@gandalf.local.home>
        <CAPpZLN7Cj9Bzwmnc52jWFnGZHTAeTk+0v=oxHZ-+iJLmfJ4XEA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Mar 2021 07:13:55 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > So we want to test the first instance, not the top one.  
> 
> I assume that if the top instance supports "x86-tsc" clock, then any
> instance should support it also ? Is it possible that supported clocks
> can be different in each instance ?

Probably not, but I don't want to assume that is the case. It could be that
the top instance supports more clocks than the created ones, if someone
were to add some kind of magical clock.

-- Steve
