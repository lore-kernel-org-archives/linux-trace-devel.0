Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8B7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 15:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 846176024A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 15:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhC3PO3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 11:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231951AbhC3POT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 11:14:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412326024A;
        Tue, 30 Mar 2021 15:14:19 +0000 (UTC)
Date:   Tue, 30 Mar 2021 11:14:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH 13/13 v2] libtracefs: Add CONTINUE to
 tracefs_function_filter()
Message-ID: <20210330111417.2d904cea@gandalf.local.home>
In-Reply-To: <20210330105250.0a7105a1@gandalf.local.home>
References: <20210330005123.151740983@goodmis.org>
        <20210330005249.118764252@goodmis.org>
        <CAPpZLN57JrvSNTCGJTe7A9_x9Z4rSsH54jQu5C8wqodii=np4w@mail.gmail.com>
        <20210330105250.0a7105a1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Mar 2021 10:52:50 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> And closing the file can cause issues. If we were to go this way, I would
> make it that if the file is open and RESET is set, it would return an error
> EBUSY.
> 
> But no, closing the file just because RESET is set is dangerous.

So, I'm going to keep the patches going as is, and build on top of them
with updates.

Thinking about this some more, I believe I'll go with returning 1 with
errno = EBUSY if RESET is passed in and the file descriptor is opened.

-- Steve
