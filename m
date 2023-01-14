Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290AEC3DA78
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 Jan 2023 14:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjANOnc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 14 Jan 2023 09:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjANOnb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 14 Jan 2023 09:43:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BA85242
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 Jan 2023 06:43:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8781560BBF
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 Jan 2023 14:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8E8C433EF;
        Sat, 14 Jan 2023 14:43:29 +0000 (UTC)
Date:   Sat, 14 Jan 2023 09:43:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: open code execvp routine to avoid
 multiple execve syscalls
Message-ID: <20230114094326.14b8b92c@rorschach.local.home>
In-Reply-To: <20230114005105.166d54fe@rorschach.local.home>
References: <20230105220727.0660a0e4@gandalf.local.home>
        <Y8HiIR9IrfWFG+MY@mail.google.com>
        <20230114005105.166d54fe@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 14 Jan 2023 00:51:05 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
> Hi Paulo,
> 
> A couple of nits about submitting a follow up patch.
> 
> 1) A second patch should always start a new thread. It's easier to find
> in inboxes.
> 
> If you want, you could add a link to the first thread in the "changes"
> section (see below).

And I forgot to update that "see below" comment.

[..]

> > Open code the libc's execvp routine into trace-cmd so ftrace will only
> > start recording once the command is found when it needs to be found in
> > PATH.
> > 
> > Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
> > ---
> > Changelog:
> > 
> > - v2: open code execvp routine into trace-cmd. (Req. Steve Rostedt)
> > - v1: https://lore.kernel.org/linux-trace-devel/Y7dUo6woh9Y31cdl@mail.google.com/

Because you did what I was going to say and I did not update the
previous statement ;-)

-- Steve


