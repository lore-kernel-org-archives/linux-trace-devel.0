Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DDBC41513
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 01:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjHHBJm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Aug 2023 21:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHHBJl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Aug 2023 21:09:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA55B9E;
        Mon,  7 Aug 2023 18:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5800E62351;
        Tue,  8 Aug 2023 01:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A16C433C7;
        Tue,  8 Aug 2023 01:09:39 +0000 (UTC)
Date:   Mon, 7 Aug 2023 21:09:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Lv Ying <lvying6@huawei.com>
Cc:     <mchehab@kernel.org>, <linux-trace-users@vger.kernel.org>,
        <linux-trace-devel@vger.kernel.org>,
        "Fangxiuning (Jack, EulerOS)" <fangxiuning@huawei.com>
Subject: Re: How to solve the coupling between libtraceevent and kernel
 trace?
Message-ID: <20230807210937.3ece4d63@gandalf.local.home>
In-Reply-To: <47475eaa-229e-f1bd-dcc7-31427f130ca3@huawei.com>
References: <4767bcf3-589a-9dfb-5b45-9ac9279f08e6@huawei.com>
        <20230804121531.06f7bf0e@gandalf.local.home>
        <47475eaa-229e-f1bd-dcc7-31427f130ca3@huawei.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 5 Aug 2023 11:57:48 +0800
Lv Ying <lvying6@huawei.com> wrote:

> I find this kernel 
> patch(https://lore.kernel.org/all/477b362dba1ce7fab9889a1a8e885a62c472f041.1516069914.git.tom.zanussi@linux.intel.com/T/#u) 
> change TIME_STAMP to 8 bytes. Maybe this commit is the first time 
> RINGBUF_TYPE_TIME_STAMP is really implemented in the kernel.

Yes, I know what caused the breakage.

> 
> When rasdaemon use old libtrace(12 byte version of TIME_STAMP) on newer 
> kernel(8 bytes version of RINGBUF_TYPE_TIME_STAMP). Libtrace takes too 
> long to parse timestamp events and appends the first 4 bytes of the next 
> trace event as the last 4 bytes of the timestamp event. Such wrong 
> parsing will lead to completely wrong parsing of the adjacent trace 
> event field. For example, in rasdaemon we have a situation like this, 
> libtrace parse devlink_health_report trace event next timestamp trace 
> event as block_rq_complete trace event, which will cause coredump in 
> block_rq_complete rasdaemon handler.
> >>
> >> So if libtraceevent is released out of(independent) kernel, how does
> >> libtraceevnt to keep compatible with the running kernel(maybe not the
> >> newest)?
> >>  
> > 
> > Now that it has been implemented, it's not going to change. 8 bytes is now
> > an API. Any more updates should not cause a problem with libtraceevent as
> > there's many more tools that depend on it working. And the fact that it is
> > no longer in the kernel, guarantees more that the interface will remain
> > stable.
> >   
> I am worried similar libtraceevent-kernel compatibility problem. I think 
> it's a good way to sort out the interfaces that libtraceevent depends on 
> the kernel and add test cases to determine whether libtraceevent can run 
> on the current kernel, or to know which interfaces do not match.
> 
> > rasdaemon should be using the external libtraceevent library because it
> > will be able to get more information out of any new data. Newer kernels
> > should not break existing libtracevent, but it may just skip over new
> > features.
> > 
> > -- Steve
> > 
> > .
> >   
> rasdaemon now use the external libtraceevent, but rasdaemon will be 
> shipped in many version OS by OSV, so how to ensure that rasdaemon runs 
> correctly on various kernel versions using external libtraceevent needs 
> to be considered.
> 

The latest libtraceevent and libtracefs should work with all previous
versions of the kernel. TIMESTAMP was not implemented in the kernel when
kbuffer.c added it. That was my mistake and it will not happen again.

trace-cmd uses the latest libtracevent and libtracefs, and it works on
kernels back to 2.6.32 (when tracing was added). Using the latest
libtraceevent will work on all older kernels.

All should be good. What exactly are you worried about?

-- Steve

