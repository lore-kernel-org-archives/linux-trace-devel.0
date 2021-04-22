Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 517A3C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 20:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1415D60C3E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 20:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhDVU0E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 16:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236969AbhDVU0C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 16:26:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4CEB61405;
        Thu, 22 Apr 2021 20:25:26 +0000 (UTC)
Date:   Thu, 22 Apr 2021 16:25:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Suppress trace library warnings
Message-ID: <20210422162525.495e2d17@gandalf.local.home>
In-Reply-To: <20210416100118.585d3865@gandalf.local.home>
References: <20210415080316.3482986-1-tz.stoyanov@gmail.com>
        <20210415093428.1a3a1678@gandalf.local.home>
        <CAPpZLN7ZvgSKoNVek+msCHarKY7F-dYUhKSuoKt_DF2qaE_rwg@mail.gmail.com>
        <20210416095908.258d4c96@gandalf.local.home>
        <20210416100118.585d3865@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 16 Apr 2021 10:01:18 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 16 Apr 2021 09:59:08 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > As for pr_stat(), I think we should rename it to tep_info() and tep_vinfo()
> > that acts just like tep_warning(), except it is for informational output
> > (stdout instead of stderr). This is similar to what the kernel has.
> > 
> > Since tep_vwarning() takes a name, so can tep_vinfo(), and I was thinking
> > that we should expose this string to the application.
> >   
> 
> Oh, and we could add a tep_critical() and tep_vcritical() which means that
> the error is something really bad happened, (like failed to allocate).

Any thoughts on this?

-- Steve
