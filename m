Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D24DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Sep 2021 22:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31AD16101A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Sep 2021 22:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238072AbhI0WEw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 18:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237918AbhI0WEP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 18:04:15 -0400
Received: from oasis.local.home (unknown [209.210.2.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCE1C6101A;
        Mon, 27 Sep 2021 22:02:36 +0000 (UTC)
Date:   Mon, 27 Sep 2021 18:02:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] libtraceevent: Fix for print_field
Message-ID: <20210927180236.27544b59@oasis.local.home>
In-Reply-To: <CAP-5=fXsCqgKBPQxhJZ6a8QMk4Tw7TnQ4M_c=qfktqRaoMpMXw@mail.gmail.com>
References: <20210920183715.33377-1-irogers@google.com>
        <CAP-5=fXsCqgKBPQxhJZ6a8QMk4Tw7TnQ4M_c=qfktqRaoMpMXw@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 27 Sep 2021 14:17:58 -0700
Ian Rogers <irogers@google.com> wrote:

> Ping. Thanks,
> Ian

Hi Ian,

I'm currently traveling, but when I get back, I'll be going through the queue.

Your patch is in the queue, and you can check the status here:

   https://patchwork.kernel.org/project/linux-trace-devel/patch/20210920183715.33377-1-irogers@google.com/

Thanks!

-- Steve
