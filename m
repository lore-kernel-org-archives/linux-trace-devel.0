Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72ECDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbiDDPtq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiDDPtp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:49:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995B1261A
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3903AB816F4
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF95C2BBE4;
        Mon,  4 Apr 2022 15:47:46 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:47:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@google.com, Vineeth Pillai <vineethrp@google.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <20220404114744.283d4746@gandalf.local.home>
In-Reply-To: <CAEXW_YR5bSNxa_+NfMXqCNj4MvUbV=RX2NaSTasXU4NhqDUcQQ@mail.gmail.com>
References: <20220329191801.429691-1-joel@joelfernandes.org>
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
        <20220404113240.7c3368e5@gandalf.local.home>
        <CAEXW_YS+JsSPYu=8UoGZdwVMhF2cw9B9rODskFGfR4++dmDVVA@mail.gmail.com>
        <CAEXW_YR5bSNxa_+NfMXqCNj4MvUbV=RX2NaSTasXU4NhqDUcQQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 4 Apr 2022 11:41:58 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> > Agreed, so should I send a patch next to do memfd unless
> > not-compressed? Is there an easy way to do not-compressed?  
> 
> Sorry I meant "is there an easy way to detect, in this code path, that
> we are running in not compressed mode" ? I guess I could just check
> the argv but I haven't looked closely yet.

From that function not yet. We could add a flag.

I think we could just take this patch and then I could add a way to put
back the mktemp in compression = none mode.

I rather have it broken up into multiple patches anyway.

-- Steve
