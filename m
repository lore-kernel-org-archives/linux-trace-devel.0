Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD19C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 16:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52CF92075C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 16:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfCSQtR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 12:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbfCSQtQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 12:49:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F2120700;
        Tue, 19 Mar 2019 16:49:15 +0000 (UTC)
Date:   Tue, 19 Mar 2019 12:49:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v7 6/9] trace-cmd: Find and store pids of tasks, which
 run virtual CPUs of given VM
Message-ID: <20190319124914.43ddec4b@gandalf.local.home>
In-Reply-To: <CAE0o1NtR+bEXYUP_suHJMfAXnXmtSPPMzSZrunoP5mp5VeNL_A@mail.gmail.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
        <20190319155536.19381-7-tstoyanov@vmware.com>
        <CAE0o1NtR+bEXYUP_suHJMfAXnXmtSPPMzSZrunoP5mp5VeNL_A@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 19 Mar 2019 16:35:28 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> > +
> > +       snprintf(path, sizeof(path), "/proc/%s/task", guest_task);
> > +       dir = opendir(path);
> > +       if (!dir)
> > +               return;
> > +
> > +       for (entry_t = readdir(dir); entry_t; entry_t = readdir(dir)) {  
> 
> Nit:  `while ((entry = readdir(dir))) {` is more common throughout the code.

Agreed. Although in a lot of cases I prefer for() over while(), in this
case, when the initialization is identical to the next iteration, the
while() is preferred.

-- Steve
