Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184BDC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 11:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E530361058
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 11:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhHLLbi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 07:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhHLLbi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 07:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA72560E9B;
        Thu, 12 Aug 2021 11:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628767873;
        bh=+NPBGnE+XEJoBmWXOgkcLntjyxblYos6pjANaetYmj4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O1xGm+uyQ971q/HIRx9e8EET3EfILrW6nl/7i3fdEFDyKc9DMjp6fmjLSDveVgxt1
         8fDzzTOjKyDr2+lmw7GYJo9TbTPVwnaUu8dEK0f0nYxvCqjonnhhKeJgypOv8yO4Yg
         DNJZIEf/f4mOtmwna0oHON0DdemWB06lHSzkJ2iuJeHkjNCmvfapEZ/VkHFUvbocCs
         nbSzUZNxbJqXFhVi/Hgcz3oRKdjoZvMgzWY5CEaXG4aHIKBASHHJ8t6UeQ9GfcVfBy
         Cia6uv0CKO39sjV55QnccsKGNpyggmYql+IEZAfvjVqXzOZPVBRtXwxs65q6LG5mEM
         s1/7PpEKgWiMQ==
Date:   Thu, 12 Aug 2021 20:31:10 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-Id: <20210812203110.3c82c040104e0fb488912ee1@kernel.org>
In-Reply-To: <20210812102735.5ac09a88aa6149a239607fd0@kernel.org>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
        <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
        <20210811112249.555463f2@oasis.local.home>
        <20210812102735.5ac09a88aa6149a239607fd0@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 10:27:35 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> 
> > Currently, we don't see any real use case to allow synthetic events to
> > attach to an eprobe, but if there is, we can change the code to allow
> > it, but we need to keep track of how many are attached, and limit them,
> > and we need to find a way to check for loops.
> 
> Yes, anyway we need a way to find loops on histogram/eprobe at last.

BTW, what about using similar machanism of "current_kprobe()" to detect
the reccursion? As an easy way, prepare a static per-cpu pointer which sets
the current eprobe and if the eprobe handler detects that is already set,
it may warn (or silently ignore) and reject it.
(Of course it is better to detect the loop when user sets the hist-trigger
by reverse link)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
