Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8A3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243837AbiDDP36 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349937AbiDDP35 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:29:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F326433365
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:28:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78F4F61630
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E101C3410F;
        Mon,  4 Apr 2022 15:28:00 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:27:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <20220404112758.3e32bd40@gandalf.local.home>
In-Reply-To: <CAPpZLN6h5RaVdGoA9LfXn67bvdhfb4VZoipjiv1wJzCpdSTPPA@mail.gmail.com>
References: <20220329191801.429691-1-joel@joelfernandes.org>
        <20220401153737.7c444426@gandalf.local.home>
        <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
        <20220401190629.32564bd2@gandalf.local.home>
        <Ykm1jBpdD0+NjsTW@google.com>
        <CAPpZLN44k=2j7AsrNz72_74JkXQZvJH2sh61o2-ZRib=b4nyKA@mail.gmail.com>
        <CAPpZLN7LXehf7==O6bi2CDfs0HvAexAvQ1qv92MT5DYVgW7iGQ@mail.gmail.com>
        <CAEXW_YSUTdtELA+ZVmUsybuSMuZ0OAQy4d6834soj3a-R40v1Q@mail.gmail.com>
        <CAPpZLN5MHicswQqgH6vKYOCwPczNTyz2OcMf5CG4CKV6y8Q2jw@mail.gmail.com>
        <20220404103525.1ec0b246@gandalf.local.home>
        <CAPpZLN71si6G5=O=sM5suNp+NtXYz=0U+=3O2XCCWmqhp8M-Tg@mail.gmail.com>
        <20220404110424.78f14d9e@gandalf.local.home>
        <CAPpZLN6h5RaVdGoA9LfXn67bvdhfb4VZoipjiv1wJzCpdSTPPA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 4 Apr 2022 18:15:42 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> The current approach to use the best available compression algorithm
> by default is good enough, but personally I prefer the logic with
> dynamically loading of these libraries. That way we can use the same
> binary, which will simplify the trace-cmd packaging. And the first PoC
> implementation of compression support was that way :)

I disagree. How does it make it easier for packaging? Then you have the
nightmare of having different compression algorithms on different machines
depending on what is installed at run time. Because we pass around
trace.dat files, and now you may not be able to read it if the other
machine doesn't support it. I already hit this, and it is annoying.

If the compressions are compile time dependent, then they will likely be
added in the distro packaging. Which is what we want. That way, when people
are not compiling their own trace-cmd, then all the trace-cmd of the same
version they have will be able to create and read the trace.dat files that
are passed around.

If you make it a run time dependency, it will be a nightmare to keep it
straight for the average user. And I don't want to deal with bug reports
saying "I ran trace-cmd v3.1.3 on one machine, and trace-cmd v3.1.3 on
another machine can't read the file".

Sure, if you compile it yourself, it may not be supported (which is what I
hit), but at least we guarantee that it will be supported across machines
using the same distro if we make it compile time dependent.

-- Steve
