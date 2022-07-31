Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF0CC00140
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Jul 2022 16:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbiGaQse (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 31 Jul 2022 12:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGaQsd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 31 Jul 2022 12:48:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15209E02F;
        Sun, 31 Jul 2022 09:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A55BC60F1F;
        Sun, 31 Jul 2022 16:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AC6C433C1;
        Sun, 31 Jul 2022 16:48:31 +0000 (UTC)
Date:   Sun, 31 Jul 2022 12:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
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
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V9 01/16] rv: Add Runtime Verification (RV) interface
Message-ID: <20220731124824.6d065b86@rorschach.local.home>
In-Reply-To: <e9c88889-3523-0466-cf52-71f04cb468b8@kernel.org>
References: <cover.1659052063.git.bristot@kernel.org>
        <a4bfe038f50cb047bfb343ad0e12b0e646ab308b.1659052063.git.bristot@kernel.org>
        <YuU7TGxm5pzmBFTx@geo.homenetwork>
        <0197dd47-ea15-4d8b-5fc7-e466d8a501a7@kernel.org>
        <YuaadlzgSJLtzOUw@geo.homenetwork>
        <e9c88889-3523-0466-cf52-71f04cb468b8@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 31 Jul 2022 17:56:27 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> > Yeah, this is not that clear from my above words expression. I said the return
> > value of da_monitor_init_*() will be 0, but it is not right. Global and per-cpu
> > monitor will return 0, per-task monitor may return a positive value when the
> > slot is equal or greater than RV_PER_TASK_MONITOR_INIT(how possible this will
> > happen I do know yet). This is from reading the current code implementation.
> > I just want to say that there may be a bug here.  
> 
> goto my previous email;

If you increment RV_PER_TASK_MONITORS to 2, I believe Tao is correct.

-- Steve
