Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E07AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Apr 2022 19:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiDRTfw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 15:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiDRTfv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 15:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79F560DC
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 12:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A1F360F29
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 19:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F78AC385A1;
        Mon, 18 Apr 2022 19:33:10 +0000 (UTC)
Date:   Mon, 18 Apr 2022 15:33:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 1/9] trace-cmd record: Move port_type into instance
Message-ID: <20220418153308.75d8a786@gandalf.local.home>
In-Reply-To: <CAPpZLN6hbomCn5DUPvOKyVtzqWeoGjdT2OUc9XNBYNgekjRtdQ@mail.gmail.com>
References: <20220417184538.1044417-1-rostedt@goodmis.org>
        <20220417184538.1044417-2-rostedt@goodmis.org>
        <CAPpZLN6hbomCn5DUPvOKyVtzqWeoGjdT2OUc9XNBYNgekjRtdQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 18 Apr 2022 13:22:21 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > +++ b/tracecmd/include/trace-local.h
> > @@ -285,6 +285,7 @@ struct buffer_instance {
> >         int                     *fds;
> >         bool                    use_fifos;
> >
> > +       enum port_type          port_type;  
> 
> I would suggest setting the default value of port_type explicitly in
> allocate_instance(). Even though USE_UDP is 0, it is more clear. The
> first time when I went through these changes, I was wondering why UDP
> is not set at all. Then found that it was a static boolean in the
> previous implementation, defaulting to false.

I could add a comment. I purposely had USE_UDP to zero for this purpose.
This is a common trick to do in the kernel as well.

But it should have a comment stating that here. I'll update it in v3.

Thanks for the review.

-- Steve
