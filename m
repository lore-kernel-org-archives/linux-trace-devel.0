Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAD5C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 14:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 683E761465
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 14:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhENOCL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 10:02:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232467AbhENOCL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 10:02:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E60A61463;
        Fri, 14 May 2021 14:00:59 +0000 (UTC)
Date:   Fri, 14 May 2021 10:00:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] trace-cmd: Trace timesync to find pids that map
 vCPUs
Message-ID: <20210514100057.4d266a79@gandalf.local.home>
In-Reply-To: <CAPpZLN6cBt6aqL1QP9KxC1e8DqB8DWTVeT=5weF6guOvmdM7vQ@mail.gmail.com>
References: <20210513204315.1206204-1-rostedt@goodmis.org>
        <20210513204315.1206204-3-rostedt@goodmis.org>
        <CAPpZLN6p2UgghB16=eqpacica6XEOLuCqTds+SdhFbZkPUZ0Hw@mail.gmail.com>
        <20210514091205.6b269474@gandalf.local.home>
        <CAPpZLN6cBt6aqL1QP9KxC1e8DqB8DWTVeT=5weF6guOvmdM7vQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 May 2021 16:38:29 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > What am I missing?  
> 
> cid is not updated between both checks, it always fails - even though
> read_qemu_guests() may succeed to find the VM with that name.

Ah, that's what I was missing. :-p

For some reason I thought it set the *cid, but I see that's obviously not
the case. You are correct, the second check is not needed because the code
to set *cid is right after it.

Thanks for pointing that out.

-- Steve
