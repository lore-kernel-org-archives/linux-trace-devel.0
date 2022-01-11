Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DF0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbiAKPWI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:22:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47832 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239531AbiAKPWH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:22:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5BA7B81B61
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 15:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F29C36AEB;
        Tue, 11 Jan 2022 15:22:04 +0000 (UTC)
Date:   Tue, 11 Jan 2022 10:22:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cruncher: Add API to set tracing CPU affinity
Message-ID: <20220111102203.13c91049@rorschach.local.home>
In-Reply-To: <0f79933c-6851-da46-8e2c-5606b35cfd03@gmail.com>
References: <20211217182619.13db88f0@gandalf.local.home>
        <87b5f204-8132-a8dc-321a-f0928eef3710@gmail.com>
        <20220110102010.5c41b336@gandalf.local.home>
        <ddda1b3a-c626-8733-5d74-0d29d768e7a5@gmail.com>
        <20220111090035.3cf11479@rorschach.local.home>
        <0f79933c-6851-da46-8e2c-5606b35cfd03@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 11 Jan 2022 16:38:01 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Hmm, I am not 100% sure, but I still think this is the case.
> In your link, if you go down a bit you have
> 
> "If you’re not sure if you want to use Python threading, asyncio, or multiprocessing, then you can check out Speed Up 
> Your Python Program With Concurrency."
> 
> where " Speed Up Your Python Program With Concurrency" is a link to here:
> https://realpython.com/python-concurrency/
> 
> and here if you scroll down to the first table, you will see that multiprocessing is the only real way to run Python on 
> multiple CPUs.
> 
> You can have a look also here
> https://docs.python.org/3/library/threading.html
> 
> "In CPython, due to the Global Interpreter Lock, only one thread can execute Python code at once (even though certain 
> performance-oriented libraries might overcome this limitation). If you want your application to make better use of the 
> computational resources of multi-core machines, you are advised to use multiprocessing or 
> concurrent.futures.ProcessPoolExecutor. However, threading is still an appropriate model if you want to run multiple 
> I/O-bound tasks simultaneously."

Well, it doesn't affect the API so we can always change it in the future.

-- Steve
