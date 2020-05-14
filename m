Return-Path: <SRS0=AbPd=64=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642ECC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 02:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EECC206DA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 May 2020 02:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgENCXi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 May 2020 22:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgENCXh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 May 2020 22:23:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BBC2205CB;
        Thu, 14 May 2020 02:23:37 +0000 (UTC)
Date:   Wed, 13 May 2020 22:23:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Bijan Tabatabai <bijan311@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Bijan Tabatabai <bijan311@yahoo.com>
Subject: Re: [PATCH v3] trace-cmd: Stop recording when processes traced with
 -P exit
Message-ID: <20200513222335.1a4a1f5a@oasis.local.home>
In-Reply-To: <CAMvvPS5j1nGMiQKcayppfijkxjeyNQK0cUHq6LZAghVSLvA3mQ@mail.gmail.com>
References: <20200513170529.22605-1-bijan311@gmail.com>
        <20200513161633.0ef67ea2@gandalf.local.home>
        <CAMvvPS5j1nGMiQKcayppfijkxjeyNQK0cUHq6LZAghVSLvA3mQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 May 2020 20:25:46 -0500
Bijan Tabatabai <bijan311@gmail.com> wrote:

> I just tried that and discovered an interesting problem.
> After the first sleep ended, my computer completely locked up, and
> after a few minutes I decided to reset my computer.
> Then after rebooting, I checked out the master branch, recompiled, and
> tried running the same set of commands again.
> This time, my computer locked up shortly after I pressed Ctrl+C after
> both sleeps exited.
> I am running Ubuntu 20.04 with Ubuntu's version of the 5.4 kernel.
> 
> Is this a bug that has been reported before? If not, what is the
> process for "officially" reporting it?
> 

It's a kernel bug, and we just hit it a couple of weeks ago. The fix is here:

 https://lore.kernel.org/r/20200507173929.118079761@goodmis.org

It has been already added to Linus's tree and is filtering into the
stable branches (should soon be in your Ubuntu kernel).

The discussion around it is here (with the first attempted fix).

 https://lore.kernel.org/r/20200507173929.118079761@goodmis.org

The above is really just a work around, and the real fix is being
proposed and discussed here.

 https://lore.kernel.org/r/20200513152137.32426-1-joro@8bytes.org

-- Steve
