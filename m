Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70752C2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 18:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ADB222464
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 18:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgKTSrt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbgKTSrt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 13:47:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34B352245F;
        Fri, 20 Nov 2020 18:47:48 +0000 (UTC)
Date:   Fri, 20 Nov 2020 13:47:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Philippe Duplessis-Guindon <pduplessis@efficios.com>
Cc:     linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Duplicate fields in event format of `regcache_sync `
Message-ID: <20201120134746.61626e57@gandalf.local.home>
In-Reply-To: <53fe53a9-0589-2bc6-1883-6f696fdee9ac@efficios.com>
References: <53fe53a9-0589-2bc6-1883-6f696fdee9ac@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 20 Nov 2020 12:50:33 -0500
Philippe Duplessis-Guindon <pduplessis@efficios.com> wrote:

> Hi,
> 
> I am doing an ftrace plugin for Babeltrace 2 [1], and while I was 
> parsing the event fields I had an error saying that `regcache_sync` has 
> 2 fields named `type`. The problem seems to come from the 
> drivers/base/regmap/trace.h file [2]. This is the patch where this was 
> added: [3]. The `int field` type is not assigned, so I was wondering if 
> it is normal that the field is there.
> 
> This is the format of this event:
> 
> $ sudo cat /sys/kernel/debug/tracing/events/regmap/regcache_sync/format
> name: regcache_sync
> ID: 1216
> format:
>    field:unsigned short common_type;    offset:0;    size:2;    signed:0;
>    field:unsigned char common_flags;    offset:2;    size:1;    signed:0;
>    field:unsigned char common_preempt_count; offset:3; size:1;signed:0;
>    field:int common_pid;    offset:4;    size:4;    signed:1;
> 
>    field:__data_loc char[] name;    offset:8;    size:4;    signed:1;
>    field:__data_loc char[] status;    offset:12;    size:4;    signed:1;
>    field:__data_loc char[] type;    offset:16;    size:4;    signed:1;
>    field:int type;    offset:20;    size:4;    signed:1;
> 
>    print fmt: "%s type=%s status=%s", __get_str(name), __get_str(type), 
> __get_str(status)
> 

It looks like dumb luck that this ever worked. :-/

The correct fix is to nuke that "int type" field. It's not even assigned.

Thanks for pointing this out.

-- Steve


> Thank you,
> 
> Philippe
> 
> 
> [1] https://babeltrace.org/
> 
> [2] 
> https://github.com/torvalds/linux/blob/master/drivers/base/regmap/trace.h#L129
> 
> [3] 
> https://github.com/torvalds/linux/commit/593600890110c02eb471cf844649dee213870416

