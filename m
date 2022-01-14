Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B664C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 04:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbiANEDu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 23:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbiANEDt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 23:03:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8376AC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 20:03:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03FE5B823A8
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 04:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C90BC36AEA;
        Fri, 14 Jan 2022 04:03:45 +0000 (UTC)
Date:   Thu, 13 Jan 2022 23:03:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Chen, Hongzhan" <hongzhan.chen@intel.com>
Cc:     "linux-trace-devel@vger.kernel.org>, Kiszka" 
        <linux-trace-devel@vger.kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: Re: [Questions][trace-cmd/libtraceevent] how to correctly  parse
 info out from specifial format of event?
Message-ID: <20220113230343.24e9d63e@rorschach.local.home>
In-Reply-To: <MN2PR11MB4285DF10ED4F820D69303162F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <MN2PR11MB428586156443A851B879867BF2539@MN2PR11MB4285.namprd11.prod.outlook.com>
        <20220113140952.34d0f937@gandalf.local.home>
        <MN2PR11MB428554E66740ACBEE4B29D74F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
        <20220113210631.5b07cf47@gandalf.local.home>
        <MN2PR11MB4285DF10ED4F820D69303162F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 Jan 2022 03:28:37 +0000
"Chen, Hongzhan" <hongzhan.chen@intel.com> wrote:
> >> Following is two dumps, please check:
> >> 
> >>           smokey-447   [000]   320.193156: cobalt_pthread_create: 74 02 00 00 bf 01 00 00  40 37 4b aa ab 7f 00 00  00 00 00 00 18 00 38 00  00 00 00 00 fe 7f 00 00  60 c3 24 90 ff ff ff ff  5c 81 21 90 ff ff ff ff  d8 bd 8c 80 90 c1 ff ff  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
> >
> >common_type:		0x0274 = 628 (matches the ID)
> >common_flags:		00
> >common_preempt_count:	00
> >common_pid:		0x000001bf : 447
> >
> >pth:			0x00007fabaa4b3f40 (whatever that is)
> >policy:			0x00000000
> >param_ex:		0x00180038 (offset = 0x38 (56) len=0x18 (24)  
> 
> Thanks for your quick reply. 😊
> 
> On my X86 platform , it is printed as  0x380018(offset should be 0x18
> len = 0x38).  It should point to the end of field param_ex

How did you get that? The above shows the 4 bytes are:


 field:__data_loc char[] param_ex;       offset:20;      size:4; signed:1;

And if you take the 4 bytes at offset 20 from above we get:

  18 00 38 00

And since this is little endian, that turns into:

  0x00380018

  
> (field:__data_loc char[] param_ex;       offset:20;      size:4;
> signed:1) where store its data per my understanding. Please correct
> me if I am wrong.
> 
> 


> >
> >Hmm, the offset points to that set of zeros at the end.
> >
> >How was this event created?  
> 
> The event definition please refer to https://gitlab.com/Xenomai/xenomai-hacker-space/-/blob/master/kernel/cobalt/trace/cobalt-posix.h
> 

That references other files. Are those other files taken from the Linux kernel?

Specifically:

#include <linux/tracepoint.h>
#include <linux/trace_seq.h>
#include <trace/define_trace.h>

-- Steve

