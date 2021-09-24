Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBA6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 04:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F2F5610CB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 04:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhIXEIw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 00:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229454AbhIXEIv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 00:08:51 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDCE2610C9;
        Fri, 24 Sep 2021 04:07:18 +0000 (UTC)
Date:   Fri, 24 Sep 2021 00:07:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] tracing: Have trace_pid_list be a sparse array
Message-ID: <20210924000717.310b492a@rorschach.local.home>
In-Reply-To: <20210924033547.939554938@goodmis.org>
References: <20210924033547.939554938@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 23 Sep 2021 23:35:47 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> The pid_mask will start out with 1024 entries for the first 10 MSB bits.
> This will cost 4K for 32 bit architectures and 8K for 64 bit. Each of
> these will have a 1024 array to store the next 10 bits of the pid (another
> 4 or 8K). These will hold an 512 byte bitmask (which will cover the LSB 12
>   bits or 4096 bits).

Thinking about this more, I should adjust this split.

Currently, this is a 10,10,12 split, but since the upper chunks are
arrays of pointers, and the lower chunk is a bitmask, and that pids
tend to be close together, I should make the lower split bigger.

As a 4K page is 32768 bits (2^15), the lower split should be 15 bits,
not 12. This will probably allocate better.

Of course 32 - 15 is 17. So maybe to keep it simple, by having the two
upper chunks still the same in size, I could have it be 14 bits for the
lower (2048 bytes). And since pid_max can only be 2^30, we don't even
need to cover the full 32 bits.

30 - 14 = 16 = 8 * 2.

Then I can make the upper chunks cover 8 bits (arrays of 256 pointers)
and the lower chunks cove 14 bits. This would coincidentally make all
chunks 2K in size (on 64 bit machines).

Hmm, in that case, I can make the lower and upper chunks use the same
memory and not separate them. They are unions after all. But that may
be unfair for 32 bit machines, as the upper chunks are only going to be
1K in size for them (256 * 4).

-- Steve

