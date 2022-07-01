Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B9EC43334
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Jul 2022 15:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiGAPi6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Jul 2022 11:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiGAPi5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Jul 2022 11:38:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922602E0A2;
        Fri,  1 Jul 2022 08:38:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD7E62480;
        Fri,  1 Jul 2022 15:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEA2C3411E;
        Fri,  1 Jul 2022 15:38:53 +0000 (UTC)
Date:   Fri, 1 Jul 2022 11:38:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Gabriele Paoloni <gpaoloni@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V4 18/20] rv/monitor: Add safe watchdog monitor
Message-ID: <20220701113851.3167403e@gandalf.local.home>
In-Reply-To: <56166be5-e30f-8f2a-e85a-09b993c7a8f0@roeck-us.net>
References: <cover.1655368610.git.bristot@kernel.org>
        <6366fdc89d65b8d9b14ccd1e42fa0d793fbe9f73.1655368610.git.bristot@kernel.org>
        <168af019-70d1-3237-dc9c-56a82beb5990@roeck-us.net>
        <04ca385b-47dc-5535-419e-1b814a383d1a@kernel.org>
        <CA+wEVJbvcMZbCroO2_rdVxLvYkUo-ePxCwsp5vbDpoqys4HGWQ@mail.gmail.com>
        <17ade9e2-8fbe-ea80-93c1-9f1e291805b6@roeck-us.net>
        <20220628153256.65dc84dd@gandalf.local.home>
        <56166be5-e30f-8f2a-e85a-09b993c7a8f0@roeck-us.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 1 Jul 2022 07:45:50 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> > Do not confuse this with static analyzers or other general purpose tooling
> > to find bugs. This is not the purpose of the run time verify. It is just to
> > prove that certain use cases will perform as expected, given a limited
> > input.
> >   
> 
> ... this is, unfortunately, not explained in the patch. I would have much less
> of a problem with the series if those details were included.

It's one of those cases where developers get so involved in their code that
they leave out the things that are so obvious to them, but not obvious to
others ;-)

My new saying is: "We work in a field where the obvious seldom is".

Hmm, I think I'll go tweet that :-)

> 
> Not that I would mind such a verifier, if it was possible to define one,
> but it would have to be tested with a large number of watchdog drivers
> to ensure that it addresses all use cases, or at least with a substantial
> percentage of use cases. It would also require that the state machine is
> readable to give people a chance to fix it if turns out to be broken.
> It would also have to be robust, meaning it would have to reject invalid
> (unsupported) settings from the start and not only during runtime.

I would agree than any module would need to state up front exactly what it
is modeling. In safety critical systems, all the components that are used
are defined up front. Not sure if we can have the model not load if the
required drivers to test are not loaded or ones not part of the model are
(Daniel?).

Anyway, thanks for the feedback.

-- Steve
