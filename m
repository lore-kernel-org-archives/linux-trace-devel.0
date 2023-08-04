Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315C8C001DE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 16:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjHDQPg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 12:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjHDQPg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 12:15:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FA3170F;
        Fri,  4 Aug 2023 09:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1493620A3;
        Fri,  4 Aug 2023 16:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933CDC433C7;
        Fri,  4 Aug 2023 16:15:33 +0000 (UTC)
Date:   Fri, 4 Aug 2023 12:15:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Lv Ying <lvying6@huawei.com>
Cc:     <linux-trace-users@vger.kernel.org>,
        <linux-trace-devel@vger.kernel.org>,
        "Fangxiuning (Jack, EulerOS)" <fangxiuning@huawei.com>
Subject: Re: How to solve the coupling between libtraceevent and kernel
 trace?
Message-ID: <20230804121531.06f7bf0e@gandalf.local.home>
In-Reply-To: <4767bcf3-589a-9dfb-5b45-9ac9279f08e6@huawei.com>
References: <4767bcf3-589a-9dfb-5b45-9ac9279f08e6@huawei.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 4 Aug 2023 17:52:48 +0800
Lv Ying <lvying6@huawei.com> wrote:

> Hi, all:
> 
> I am a rasdaemon developer which depeneds on libtraceevent to parse 
> kernel trace events. There is coupling between libtraceevnt and kernel 
> trace, if something in libtraceevent and kernel does not match, which 
> will cause libtraceevent parse wrong thing. e.g 
> https://github.com/mchehab/rasdaemon/pull/98
> 
> We also encounter similar problem:
> * libtrace(old) KBUFFER_TYPE_TIME_STAMP size = 12
> * kernel(new) KBUFFER_TYPE_TIME_STAMP size = 8
> Such mismatch will cause strange behavior when parsing trace events.

So what happened was the old 12 byte version of TIME_STAMP was never
actually implemented in the kernel. When we finally got around to
implementing it, we only needed 8 bytes for it, so it became 8 bytes.

I made the mistake of adding that code in kbuffer.c before it was ever
implemented in the kernel and said it would be 12 bytes.

> 
> So if libtraceevent is released out of(independent) kernel, how does 
> libtraceevnt to keep compatible with the running kernel(maybe not the 
> newest)?
> 

Now that it has been implemented, it's not going to change. 8 bytes is now
an API. Any more updates should not cause a problem with libtraceevent as
there's many more tools that depend on it working. And the fact that it is
no longer in the kernel, guarantees more that the interface will remain
stable.

rasdaemon should be using the external libtraceevent library because it
will be able to get more information out of any new data. Newer kernels
should not break existing libtracevent, but it may just skip over new
features.

-- Steve
