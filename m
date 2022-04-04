Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41423C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378590AbiDDPen (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378594AbiDDPel (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:34:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBE43ED15
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4C9DB8170E
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F9BC34117;
        Mon,  4 Apr 2022 15:32:41 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:32:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <20220404113240.7c3368e5@gandalf.local.home>
In-Reply-To: <20220404112758.3e32bd40@gandalf.local.home>
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
        <20220404112758.3e32bd40@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 4 Apr 2022 11:27:58 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Sure, if you compile it yourself, it may not be supported (which is what I
> hit), but at least we guarantee that it will be supported across machines
> using the same distro if we make it compile time dependent.

Not to mention, I have use cases where trace-cmd needs to be installed in
an environment with no dynamic libraries (nor using dlopen). Everything
will be built statically. trace-cmd report will not be used, but trace-cmd
agent will be.

Remember, trace-cmd is to be embedded friendly.

-- Steve
