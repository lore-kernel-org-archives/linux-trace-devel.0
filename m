Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FD9C3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 18:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77C6A206B9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 18:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgEDS6F (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 14:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgEDS6F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 14:58:05 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E8D92068E;
        Mon,  4 May 2020 18:58:04 +0000 (UTC)
Date:   Mon, 4 May 2020 14:58:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] kernel-shark: Make the "stop search" button
 always visible
Message-ID: <20200504145802.5bb2e0c6@gandalf.local.home>
In-Reply-To: <20200504174342.24615-4-y.karadz@gmail.com>
References: <20200504174342.24615-1-y.karadz@gmail.com>
        <20200504174342.24615-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  4 May 2020 20:43:42 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> So far the button was showing up only when we do a single-threaded
> search in the data. Stopping the multi-threaded searches became
> possible after the modification of the parallel search introduced
> in the previous commit. When the multi-threaded search is restarted
> (after being stopped) the label showing the number of matches found
> is reset to show nothing. It will show the count again when the
> search finishes or is stopped.
>

I'm pulling in this series. But more of an FYI, it's best to avoid
statements like "previous commit" because when developing with git, it may
not be a previous commit, when it goes into a tree. Especially if a commit
gets cherry-picked. 

Instead, use phrases like "With the parallel search changes that
were made, it is now possible to stop the multi-threaded searches and still
be at the correct percentage of the search that is displayed to the user".

It is frowned upon to mention "this commit" or "last commit" in change
logs. I catch myself doing it once in a while, and try to conform as
well ;-)

-- Steve
