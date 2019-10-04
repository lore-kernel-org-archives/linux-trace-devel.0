Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEF3C4360C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 14:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 511B3215EA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 14:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389445AbfJDOqv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389043AbfJDOqu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 10:46:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E28D20659;
        Fri,  4 Oct 2019 14:46:50 +0000 (UTC)
Date:   Fri, 4 Oct 2019 10:46:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Remove redundant trace-cmd plugin handling logic
Message-ID: <20191004104648.64c42b28@gandalf.local.home>
In-Reply-To: <20191004133647.27759-1-tz.stoyanov@gmail.com>
References: <20191004133647.27759-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  4 Oct 2019 16:36:42 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Currently there are no trace-cmd related plugins, all of them
> are designed to be used with libtraceeevnt. As both libtraceevent
> and trace-cmd have logic for managing plugins, the one in trace-cmd
> is redundant. Those redundant code is removed and replaced with calls
> to libtraceeevnt plugin APIs. When trace-cmd has to load any plugins,
> it uses libtraceeevnt to do the job.
> 
> All existing plugins are moved from plugins/ to lib/traceevent/plugins
> directory, as all of them are designed to be used with the traceevent
> library.
> 
> An initial infrastructure for trace-cmd specific plugins is added - 
> new lib/trace-cmd/plugins directory and an initial set of APIs
> for working with trace-cmd plugins.
> 
> Tzvetomir Stoyanov (1):
>   trace-cmd: Change plugin install directories
> 
> Tzvetomir Stoyanov (VMware) (4):
>   trace-cmd: Move libtraceevent plugins in its own directory.
>   trace-cmd: Rename plugin_python to plugin_python_loader.
>   trace-cmd: Load libtraceevent plugins from build folder, if exists.
>   trace-cmd: Add initial infrastructure for trace-cmd specific plugins.
> 
> 

Hi Tzvetomir,

Not sure if you noticed, but I pulled in parts of this patch series as
they were not dependent on the patches is question.

I'll take a look at the patches not yet in the series.

Thanks!

-- Steve
