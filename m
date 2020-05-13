Return-Path: <SRS0=4lCp=63=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FE6C433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 May 2020 20:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD31206A5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 May 2020 20:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390893AbgEMUQf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 May 2020 16:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390883AbgEMUQf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 May 2020 16:16:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F7132065C;
        Wed, 13 May 2020 20:16:35 +0000 (UTC)
Date:   Wed, 13 May 2020 16:16:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bijan Tabatabai <bijan311@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Bijan Tabatabai <bijan311@yahoo.com>
Subject: Re: [PATCH v3] trace-cmd: Stop recording when processes traced with
 -P exit
Message-ID: <20200513161633.0ef67ea2@gandalf.local.home>
In-Reply-To: <20200513170529.22605-1-bijan311@gmail.com>
References: <20200513170529.22605-1-bijan311@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 May 2020 12:05:29 -0500
Bijan Tabatabai <bijan311@gmail.com> wrote:

> From: Bijan Tabatabai <bijan311@yahoo.com>
> 
> When the -F flag is used in trace-cmd record, trace-cmd stops recording
> when the executable it is tracing terminates.
> This patch makes the -P flag act similarly.
> 
> Signed-off-by: Bijan Tabatabai <bijan311@yahoo.com>
> ---
>  This patch has changed to use the pidfd interface to determine if a process
>  has ended.
>  It also has changed to work with the patch "trace-cmd: Handle filtered PIDs per
>  ftarce instance" (5502bcef0f962cda).
> ---
>  tracecmd/include/trace-local.h |  2 +
>  tracecmd/trace-record.c        | 84 ++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+)
> 

Nice!

Although I just tried it out and noticed that if I run the following
command:

 # sleep 20& sleep 50&
[1] 2216
[2] 2218
 # trace-cmd record -e sched -P 2216 -B foo -e all -P 2218

It will exit out after the first sleep (20 second) and before the second is
done.

It appears to exit as soon as the first process is finished. We should want
to wait till the last one is finished.

-- Steve
