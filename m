Return-Path: <SRS0=4xj7=42=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F97CC10F27
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 15:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E75920578
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 15:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCIPoL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 11:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbgCIPoK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 11:44:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE2620578;
        Mon,  9 Mar 2020 15:44:09 +0000 (UTC)
Date:   Mon, 9 Mar 2020 11:44:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] KernelShark2.0: Use libtracefs APIs to access
 tracefs
Message-ID: <20200309114408.14440fff@gandalf.local.home>
In-Reply-To: <4aab233c-6f5b-59a7-564b-e520ed1f569f@gmail.com>
References: <20200306092902.48786-1-tz.stoyanov@gmail.com>
        <20200306151356.4bbeef14@gandalf.local.home>
        <20200306173411.783cccd0@gandalf.local.home>
        <4aab233c-6f5b-59a7-564b-e520ed1f569f@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 9 Mar 2020 11:17:44 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> > Just confirmed it. If I add kvm events to the guest, it synchronizes
> > automatically. Thus, it's a bug to expect the guest to have kvm events, as
> > there's no reason for them to do so.  
> 
> Is it possible that something else gets enabled during the recording of 
> the data, that actually makes the difference?
> Y.

Unfortunately, I blew away the files with the issue and tried to reproduce
it, and I can't :-/

Now even without the kvm events it appears to work. I may try one more
thing (which is to rebuild the guest without KVM at all), and see if I can
bring back the issue. But for now, I guess it's a "WORKS FOR ME" :-/

-- Steve
