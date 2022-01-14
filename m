Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E9FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 02:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbiANCGg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 21:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238679AbiANCGf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 21:06:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91248C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 18:06:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 480CCB821C9
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 02:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F842C36AEA;
        Fri, 14 Jan 2022 02:06:32 +0000 (UTC)
Date:   Thu, 13 Jan 2022 21:06:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Chen, Hongzhan" <hongzhan.chen@intel.com>
Cc:     "linux-trace-devel@vger.kernel.org>, Kiszka" 
        <linux-trace-devel@vger.kernel.org>,
        "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: Re: [Questions][trace-cmd/libtraceevent] how to correctly  parse
 info out from specifial format of event?
Message-ID: <20220113210631.5b07cf47@gandalf.local.home>
In-Reply-To: <MN2PR11MB428554E66740ACBEE4B29D74F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <MN2PR11MB428586156443A851B879867BF2539@MN2PR11MB4285.namprd11.prod.outlook.com>
        <20220113140952.34d0f937@gandalf.local.home>
        <MN2PR11MB428554E66740ACBEE4B29D74F2549@MN2PR11MB4285.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On Fri, 14 Jan 2022 01:37:08 +0000
"Chen, Hongzhan" <hongzhan.chen@intel.com> wrote:

From your other email:

> root@ecs-xenomai-isar:~# cat /sys/kernel/debug/tracing/events/cobalt_posix/cobalt_pthread_create/format
> name: cobalt_pthread_create
> ID: 628
> format:
>         field:unsigned short common_type;       offset:0;       size:2; signed:0;
>         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
>         field:int common_pid;   offset:4;       size:4; signed:1;
> 
>         field:unsigned long pth;        offset:8;       size:8; signed:0;
>         field:int policy;       offset:16;      size:4; signed:1;
>         field:__data_loc char[] param_ex;       offset:20;      size:4; signed:1;
> 
> print fmt: "pth=%p policy=%s param=' %s '", (void *)REC->pth, __print_symbolic(REC->policy, 
> {0, "normal"}, {1, "fifo"}, {2, "rr"}, {11, "tp"}, {12, "quota"}, {10, "sporadic"}, {42, "cobalt"}, 
> {43, "weak"}), cobalt_trace_parse_sched_params(p, REC->policy, (struct sched_param_ex *)(__get_dynamic_array(param_ex)))
> 
> [2]:
>  smokey-752     [000] d.~2  7970.727466: cobalt_pthread_getschedparam: pth=000000009bbc7fe0 policy=fifo param={ priority=50 }
>  smokey-762     [000] ....  7970.727492: cobalt_pthread_create: pth=00000000983468a5 policy=quota param={ priority=1, group=0 }



> Following is two dumps, please check:
> 
>           smokey-447   [000]   320.193156: cobalt_pthread_create: 74 02 00 00 bf 01 00 00  40 37 4b aa ab 7f 00 00  00 00 00 00 18 00 38 00  00 00 00 00 fe 7f 00 00  60 c3 24 90 ff ff ff ff  5c 81 21 90 ff ff ff ff  d8 bd 8c 80 90 c1 ff ff  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

common_type:		0x0274 = 628 (matches the ID)
common_flags:		00
common_preempt_count:	00
common_pid:		0x000001bf : 447

pth:			0x00007fabaa4b3f40 (whatever that is)
policy:			0x00000000
param_ex:		0x00180038 (offset = 0x38 (56) len=0x18 (24)

Hmm, the offset points to that set of zeros at the end.

How was this event created?

>           smokey-449   [000]   320.196623: cobalt_pthread_create: 74 02 00 00 c1 01 00 00  00 e7 6e a9 ab 7f 00 00  01 00 00 00 18 00 38 00  01 00 00 00 30 00 00 00  20 7c 82 77 fe 7f 00 00  60 7b 82 77 fe 7f 00 00  00 2b 89 18 55 a6 fa ba  40 37 4b aa ab 7f 00 00  3e 3d e2 00 7f 55 00 00  d0 7b 82 77 fe 7f 00 00

Although the above has content for that:

   "40 37 4b aa ab 7f 00 00  3e 3d e2 00 7f 55 00 00  d0 7b 82 77 fe 7f 00 00"

-- Steve
