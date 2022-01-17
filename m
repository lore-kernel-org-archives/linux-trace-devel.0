Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AF3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jan 2022 16:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbiAQQTF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 11:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbiAQQTB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 11:19:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EC4C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 08:19:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71A176117A
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 16:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF1BC36AE7;
        Mon, 17 Jan 2022 16:18:59 +0000 (UTC)
Date:   Mon, 17 Jan 2022 11:18:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 17/25] trace-cmd library: Read strings sections on
 file load
Message-ID: <20220117111857.1ab6820e@rorschach.local.home>
In-Reply-To: <CAPpZLN58EfUYk7uik0YWERcpvFXA=D_EpXdjjn-RTsQuYRNpnQ@mail.gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-18-tz.stoyanov@gmail.com>
        <20220115110445.6ea63c4a@gandalf.local.home>
        <CAPpZLN58EfUYk7uik0YWERcpvFXA=D_EpXdjjn-RTsQuYRNpnQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 Jan 2022 18:11:38 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > Hmm, I don't remember in our conversations. Did we say we would have more
> > than one string section? Or allow it to be broken up? How do offsets work
> > in such cases?
> >
> > I was thinking that we could simply mmap the string section, but that won't
> > work if there's more than one.
> >  
> 
> The first implementation was with a single string section at the end
> of the file. But when I tested that design with the trace-cmd
> guest-host tracing, I realized it is impossible to work without major
> changes in the host-guest protocol. The problem is that in the current
> host-guest tracing logic, part of the guest metadata file is written
> in the guest context, part in the host context. Each of these parts
> can put strings in the string section. That will change the way guest
> metadata is written. That's why decided to use multiple string
> sections in the file. On file read the strings from all sections are
> stored into one memory block, and string offset is the offset in that
> block. As these sections are compressed usually, simple mmap will not
> work even in case of single section.

OK, then we'll just keep it as is.

Thanks,

-- Steve
