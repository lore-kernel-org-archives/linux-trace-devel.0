Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5889EC77B73
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 May 2023 08:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjE3IUf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 May 2023 04:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjE3IUc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 May 2023 04:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB38107
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 01:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 229AD6146B
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 May 2023 08:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14C1C433EF;
        Tue, 30 May 2023 08:20:21 +0000 (UTC)
Date:   Tue, 30 May 2023 04:20:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH trace-cmd v2 0/3] trace-cmd filtering
Message-ID: <20230530042018.3abd4cae@rorschach.local.home>
In-Reply-To: <20230330185211.5604-1-krisman@suse.de>
References: <20230330185211.5604-1-krisman@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 30 Mar 2023 15:52:08 -0300
Gabriel Krisman Bertazi <krisman@suse.de> wrote:

> Hi Steve,

Hi Gabriel,

Sorry for taking so long. I finally got time to start looking at the
libtrace* trace-cmd code, and I queued this up for the next push.

Thanks Gabriel!

-- Steve


> 
> This implements my fix to restore single input filtering behavior
> (bz217038) and adds support for global filters, as you requested.
> 
> On another topic, a current behavior that seems weird in my opinion is
> that the following negates the second filter as well.
> 
>   "trace-cmd -i trace.dat.1 -v -F tp1 -i trace.dat.2 -F tp2"
> 
> I'd prefer that -v would apply only to the following -F. It'd allow me
> to do:
> 
>   "trace-cmd -v -F 'mm_page_alloc' -i trace.dat.1 -i trace.dat.2 ... \
>              -i trace.dat.10 -F 'mm_page_alloc:order==1'"
> 
> It obviously breaks the interface, so I didn't implement it here.  Would
> like to hear your input, though.  We could have a new syntax:
> 
>   "trace-cmd ! -F tp1 -F tp2 ! -F tp3"
> 
> Thanks,
> 
> Gabriel Krisman Bertazi (3):
>   trace-cmd report: Ensure filter is applied to single input file
>   trace-cmd-report: Support global filters
>   documentation: trace-cmd-report: Document filter scope
> 
>  .../trace-cmd/trace-cmd-report.1.txt          |  8 +++-
>  tracecmd/trace-read.c                         | 45 ++++++++++++-------
>  2 files changed, 34 insertions(+), 19 deletions(-)
> 

