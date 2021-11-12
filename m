Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A56C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 13:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04BB261054
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 13:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhKLNn0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Nov 2021 08:43:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231436AbhKLNn0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Nov 2021 08:43:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B24ED60F5B;
        Fri, 12 Nov 2021 13:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636724435;
        bh=ztcUkw48Ye/+FvbdMM0UM+MUCAZ6dfJ3uXhKIbYP1eY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ech7FxGHVm4omq2oazqo6LDdjMWV+EAKov69QuUY7Dza8qkr8jDq14gYg8sFwscJc
         VvrqLqDn4xDvizgQ4tOzvvZ1wiWG4Vmozsi/txKgwJTBrN8Z7+LqGarBukHTaxgNcg
         XlauOfbgQo9kwKxLfdmxrtmObnMWSCIEoOAWI4TdvfG1dBHyC61uVazf020wgH3G7H
         HSa2XWW7XQfFRfNPNLhSGzekGLUO6lr0Qr4VGNtma2RU8Dkbt1rhhKxMv7Wts+J82v
         mO987zj79x+iqj6YUZP7ihcM2quOYYzzt2s2j9zVzRq0Yv1neQg6Ym2nfzAV1IITen
         L5XQQGwWhg1HA==
Date:   Fri, 12 Nov 2021 22:40:32 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-Id: <20211112224032.f3b3f43002c28d3c8613b4fa@kernel.org>
In-Reply-To: <20211111173334.GA1433@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
        <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
        <20211109190844.GA1529@kbox>
        <20211110225630.babcd70ec85f97e369b0e446@kernel.org>
        <20211111173334.GA1433@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 09:33:34 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Wed, Nov 10, 2021 at 10:56:30PM +0900, Masami Hiramatsu wrote:
> > On Tue, 9 Nov 2021 11:08:44 -0800
> > Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > I would like to keep verifying in writer side then we can ensure the
> > data on ring buffer (of perf and of ftrace) is sane. If you add the unsafe
> > flag, you have to change all the code which access the ring buffer, not only
> > the filter but also eprobes, histograms, perf-tools, and other user-space
> > tracing tools which reads the tracing buffer directly.
> > 
> > > It sounded like Steven wanted to think about this a bit, so I'll wait a
> > > bit before poking again for consensus :)
> > > 
> > > Do you have any strong feelings about where it goes?
> > 
> > I recommend you to start verifying the writer side, it should make the
> > change as small as possible. Unsafe flag idea may involve many other
> > tools. And it is not fundamentary required for user-events.
> > 
> > Thank you,
> > 
> > -- 
> > Masami Hiramatsu <mhiramat@kernel.org>
> 
> Ok, I will start there.
> 
> Are static string buffers required as well for the null check?
> 
> Or is this only for dyn strings that require the check?

Good question! The dynamic strings is ensured to be null-terminated,
but the static string is not because the size is fixed (at least
event filter checked that.)

BTW, I found that the hist_triger_elt_update() doesn't check the
field size for fixed-size string (only use STR_VAR_LEN_MAX to limit.)
It seems buggy if the fixed-size char [] field is not null terminated.
(e.g. it is used for storing array-data)
Let me fix that.

> Also, I am assuming that __rel_loc offset is based after the __rel_loc
> payload, IE: Offset 0 of __rel_loc is immediately after the 4 byte
> __rel_loc description?

Yes, so if the field is the last one, the offset can be 0.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
