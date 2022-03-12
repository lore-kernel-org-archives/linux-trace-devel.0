Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2ABC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 05:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiCLFHS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 00:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiCLFHR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 00:07:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EA523F9DB
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 21:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8446960AF3
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 05:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82480C340EB;
        Sat, 12 Mar 2022 05:06:10 +0000 (UTC)
Date:   Sat, 12 Mar 2022 00:06:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: Issue with trace-cmd 3 and kernelshark
Message-ID: <20220312000608.58342480@gandalf.local.home>
In-Reply-To: <20220311235044.6e416b48@gandalf.local.home>
References: <20220311221825.536d849e@gandalf.local.home>
        <20220311235044.6e416b48@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 11 Mar 2022 23:50:44 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 11 Mar 2022 22:18:25 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > It appears that it doesn't like the fact that the file is compressed. This
> > was my worry about compressing date :-/  
> 
> Actually, it doesn't look like this is an issue with compression, but the
> fact that the cpu involved doesn't have any data, and we no longer save
> anything for that case.
> 
> The problem data is here: 
>   https://rostedt.org/private/trace-data/gentoo/trace.dat
>   https://rostedt.org/private/trace-data/gentoo/trace-gentoo.dat
> 
> And do a: kernelshark trace.dat -a trace-gentoo.dat
> 

Actually, it's just the trace.dat file that crashes in kernelshark.

As the number of CPUs that have data is only 35 (and thus handle->cpus is
just 35) but the box I ran this on has 128 CPUs.

There needs to be a generic way to map the actual CPU to the one saved in
the file. the cpu_data[cpu] won't work if the cpu_data array does not
contain CPUs that exist on the machine.

-- Steve

