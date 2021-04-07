Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD42C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5415610D2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 20:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhDGUbH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 16:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233404AbhDGUbG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 16:31:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFEB61184;
        Wed,  7 Apr 2021 20:30:56 +0000 (UTC)
Date:   Wed, 7 Apr 2021 16:30:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH 0/3] libtracefs: Update filtering functions
Message-ID: <20210407163055.5fe73c25@gandalf.local.home>
In-Reply-To: <20210407202126.1870994-1-rostedt@goodmis.org>
References: <20210407202126.1870994-1-rostedt@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 7 Apr 2021 16:21:23 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Add tracefs_function_notrace() to set the functions not to trace.
> Create a per instance pthread mutex lock.
> 
> [ This is actually the first time I'm sending patches via
>   git send-email! Hopefully I dont' screw it up ;-) ]

Hmm, as I found that my gitconfig uses vmware's smtp server, and the
Receive-SPF does not match. It may be blocked by the mailing lists.

I may try a second time. :-/

-- Steve


> 
> Steven Rostedt (VMware) (3):
>   libtracefs: Move most functionality into helper function for
>     tracefs_function_filter()
>   libtracefs: Add tracefs_function_notrace() API
>   libtracefs: Add a pthread_mutex per instance
> 
>  Documentation/libtracefs-function-filter.txt |  19 ++-
>  include/tracefs-local.h                      |  12 +-
>  include/tracefs.h                            |   3 +
>  src/tracefs-instance.c                       |   6 +
>  src/tracefs-tools.c                          | 152 ++++++++++++-------
>  5 files changed, 131 insertions(+), 61 deletions(-)
> 

