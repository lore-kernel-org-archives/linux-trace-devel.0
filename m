Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED14C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 13:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7977C60F92
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 13:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352782AbhIINWz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 09:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355429AbhIINNm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 09:13:42 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E397606A5;
        Thu,  9 Sep 2021 12:35:30 +0000 (UTC)
Date:   Thu, 9 Sep 2021 08:35:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Keeping <john@metanate.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH/RFC] tracing: make trace_marker{,_raw} stream-like
Message-ID: <20210909083529.34ae09da@gandalf.local.home>
In-Reply-To: <20210909115734.3818711-1-john@metanate.com>
References: <20210909115734.3818711-1-john@metanate.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  9 Sep 2021 12:57:34 +0100
John Keeping <john@metanate.com> wrote:

> The tracing marker files are write-only streams with no meaningful
> concept of file position.  Using stream_open() to mark them as
> stream-link indicates this and has the added advantage that a single
> file descriptor can now be used from multiple threads without contention
> thanks to clearing FMODE_ATOMIC_POS.
> 
> Note that this has the potential to break existing userspace by since
> both lseek(2) and pwrite(2) will now return ESPIPE when previously lseek
> would have updated the stored offset and pwrite would have appended to
> the trace.  A survey of libtracefs and several other projects found to
> use trace_marker(_raw) [1][2][3] suggests that everyone limits
> themselves to calling write(2) and close(2) on these file descriptors so
> there is a good chance this will go unnoticed and the benefits of
> reduced overhead and lock contention seem worth the risk.
> 
> [1] https://github.com/google/perfetto
> [2] https://github.com/intel/media-driver/
> [3] https://w1.fi/cgit/hostap/
> 
> Signed-off-by: John Keeping <john@metanate.com>
> ---
> I'm marking this as RFC because it breaks the Prime Directive of Linux
> development, as explained above.  But I'm hoping this is one of the

The "Prime Directive of Linux development" is the tree falling in the
forest approach. If you break user space API but there's no user space
application around to notice the break, did you really break it? The answer
is "No".

> cases where we get away with it because this is a huge improvement for
> multi-threaded programs when doing the simple thing of opening a single
> trace_marker FD at startup and just writing to it from any thread.

I like the idea too.

> 
> After writing this, I realised that an alternative solution to my
> original problem would have been to use pwrite instead of write!  But I
> still think fixing this at the source would be better.

I'm fine with adding this. But I'm going to add it after the merge window
for the next release (5.16).

If someone complains that it broke their application, we may need to revert
it, but I doubt that will happen.

-- Steve
