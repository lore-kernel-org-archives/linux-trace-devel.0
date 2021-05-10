Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C029C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 19:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EC6E615FF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 19:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhEJTY5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 15:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhEJTY4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 15:24:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0375C61585;
        Mon, 10 May 2021 19:23:50 +0000 (UTC)
Date:   Mon, 10 May 2021 15:23:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
Message-ID: <20210510152349.3de97b82@gandalf.local.home>
In-Reply-To: <cc7b594f-194e-9d2e-81e2-49f60f6c6eab@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
        <20210428134730.187533-4-y.karadz@gmail.com>
        <20210506141151.2f31f263@gandalf.local.home>
        <6c352db2-1f2a-4442-1832-1810d4d6a1a2@gmail.com>
        <20210510142537.2628c47b@gandalf.local.home>
        <cc7b594f-194e-9d2e-81e2-49f60f6c6eab@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 10 May 2021 21:50:57 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 10.05.21 г. 21:25, Steven Rostedt wrote:
> > On Mon, 10 May 2021 14:53:08 +0300
> > Yordan Karadzhov <y.karadz@gmail.com> wrote:
> >   
> >>> Can you show me how you see this error, because this solution does not make
> >>> any sense.  
> >>
> >> The problem is that some plugins can build from multiple source files.
> >> For example in the case when part of the plugin is written in C and
> >> another part in C++. In those cases we cannot have the functions being
> >> static.  
> > 
> > So it's because its a mixture of C and C++ code? And you can't make them
> > static?  
> 
> No, this has no direct connection with C++. The static functions are the 
> same in C++.
> It became an issue if you have multiple source files. If this is the 
> case you have to put the macro in a header file, so that you can use the 
> functions defined in the macro in all your source files. But this does 
> not work, because the macro defines some global variables as well. To 
> solve this I defined second macro to be used only in the header, but 
> then the functions can't be static.
> 

Still does not make sense. Obviously, I'm missing something to connect the
dots.

Can you show me the error message that you are fixing.

Thanks,

-- Steve
