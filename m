Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8602C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Sep 2022 21:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiI3VsY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Sep 2022 17:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiI3VsX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Sep 2022 17:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BF316F9D6
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Sep 2022 14:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD546251E
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Sep 2022 21:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA48C433D6;
        Fri, 30 Sep 2022 21:48:20 +0000 (UTC)
Date:   Fri, 30 Sep 2022 17:49:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     lijiazi <jqqlijiazi@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220930174934.7c5ec85f@gandalf.local.home>
In-Reply-To: <20220929091201.GA21685@Jiazi.Li>
References: <20220901111320.04b57cb7@gandalf.local.home>
        <20220902031717.GA27303@Jiazi.Li>
        <20220902085641.32ba1651@gandalf.local.home>
        <20220905030209.GA5577@Jiazi.Li>
        <20220906122542.1bab4663@gandalf.local.home>
        <20220907081358.GB24124@Jiazi.Li>
        <20220915081414.GA12602@Jiazi.Li>
        <20220928105443.1e7e4555@gandalf.local.home>
        <20220928105935.578b72b6@gandalf.local.home>
        <20220928162908.07b12250@gandalf.local.home>
        <20220929091201.GA21685@Jiazi.Li>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Sep 2022 17:12:01 +0800
lijiazi <jqqlijiazi@gmail.com> wrote:

> > Actually, that failed my testing (for other reasons), can you try this one?
> >   
> Sure, thank you.

Have you had a chance to test this yet?

The merge window is about to open, and I have it already tested through all
my tests. But I want to hold off pushing it to next until I have a
tested-by from you.

Thanks!

-- Steve
