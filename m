Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EF5C4160E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2130664F16
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Mar 2021 00:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhCCACe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 19:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376894AbhCBOYv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 09:24:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1C6C60232;
        Tue,  2 Mar 2021 14:22:47 +0000 (UTC)
Date:   Tue, 2 Mar 2021 09:22:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 6/8] trace-cmd output: Set file_state of output handle
 after copy of headers
Message-ID: <20210302092246.1f6010bf@gandalf.local.home>
In-Reply-To: <CAPpZLN4JikLLKvVRAUCoxtHkBqF8FKK5fREMNxeXEK9uNsqpFw@mail.gmail.com>
References: <20210301143724.540985351@goodmis.org>
        <20210301143857.541050724@goodmis.org>
        <CAPpZLN4JikLLKvVRAUCoxtHkBqF8FKK5fREMNxeXEK9uNsqpFw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2 Mar 2021 10:10:24 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Why is the state overwritten here, isn't it more logical to be set in
> tracecmd_copy_headers(), by each function that copies a header to set
> the relevant state. The last call in tracecmd_copy_headers()
> is copy_command_lines(), which should set state to
> TRACECMD_FILE_CMD_LINES in case of success.
> The state is already TRACECMD_FILE_CMD_LINES
> in tracecmd_copy_headers(), but right before its exit it
> is overwritten to the old file state. And here again it is
> overwritten back to TRACECMD_FILE_CMD_LINES.
> May be I miss something here, cannot understand the logic.

Also, as I believe you noticed, I saved the state in
tracecmd_copy_headers() and restored it. But thinking about this more, I'm
not sure I like that, and was thinking of just leaving the state of the
input handle in the last state that it was updated in.

In other words, I wasn't sure the best way to handle this, and reset the
state because the original version didn't modify the state, and I was just
keeping that the same. But since the fd is now different, it may be a good
idea to change the state of the handle.

This was something that I wanted to discuss with you, and I'm glad you
brought it up, because I forgot about it ;-)

-- Steve
