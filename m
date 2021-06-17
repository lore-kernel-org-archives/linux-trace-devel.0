Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E556AC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 19:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6690613E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 19:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFQUAj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:00:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhFQUAi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 16:00:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E25613D6;
        Thu, 17 Jun 2021 19:58:30 +0000 (UTC)
Date:   Thu, 17 Jun 2021 15:58:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Claire Jensen <cjense@google.com>
Cc:     eranian@google.com, irogers@google.com, tz.stoyanov@gmail.com,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] libtraceevent: Add eof checks.
Message-ID: <20210617155828.4e9c7f45@gandalf.local.home>
In-Reply-To: <20210617194326.2107129-1-cjense@google.com>
References: <20210617194326.2107129-1-cjense@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Jun 2021 19:43:25 +0000
Claire Jensen <cjense@google.com> wrote:

Hi Claire,

Thanks for sending the patches, I'll try to get some time to look at them
(note, that I have a lot of other duties that I need to finish before I can
get to this).

> Added checking for __read_char and peek_char to make sure value is not at end
> of file.
> 
> This issue was found while fuzz testing. One of the test cases created an infinite loop because __read_token had reached end of file. Checking was added to all cases where this may occur.

You don't need to fix this now, but for future reference, we follow the
Linux guidelines on submitting patches which includes having line breaks at
74 (although I use 76) bytes, for the change log.

This makes the change logs easier to read.

Thanks!

-- Steve


> 
> Signed-off-by: Claire Jensen <cjense@google.com>
>
