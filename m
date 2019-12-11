Return-Path: <SRS0=a1Iv=2B=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A2AC00454
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 15:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEBDD2465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 15:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388270AbfLKPgA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 10:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbfLKPf7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAA8A22B48;
        Wed, 11 Dec 2019 15:35:58 +0000 (UTC)
Date:   Wed, 11 Dec 2019 10:35:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sven Schnelle <svens@stackframe.org>
Cc:     linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <zanussi@kernel.org>
Subject: Re: ftrace histogram sorting broken on BE architecures
Message-ID: <20191211103557.7bed6928@gandalf.local.home>
In-Reply-To: <20191211123316.GD12147@stackframe.org>
References: <20191211123316.GD12147@stackframe.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 11 Dec 2019 13:33:16 +0100
Sven Schnelle <svens@stackframe.org> wrote:

> Hi List,

Hi Sven,

> 
> i was looking into a ftracetest failure on s390:
> 
> # ./ftracetest test.d/trigger/trigger-hist.tc
> === Ftrace unit tests ===
> [1] event trigger - test histogram trigger	[FAIL]
> [2] (instance)  event trigger - test histogram trigger	[FAIL]
> 
> from the -vvv log: ++ fail 'sort param on sched_process_fork did not work'
> 
> # cat events/sched/sched_process_fork/hist
> 
> # event histogram
> #
> # trigger info: hist:keys=parent_pid,child_pid:vals=hitcount:sort=child_pid:size=2048 [active]
> #
> 
> { parent_pid:       1406, child_pid:       1428 } hitcount:          1
> { parent_pid:       1406, child_pid:       1430 } hitcount:          1
> { parent_pid:       1406, child_pid:       1427 } hitcount:          1
> { parent_pid:       1406, child_pid:       1432 } hitcount:          1
> { parent_pid:       1406, child_pid:       1431 } hitcount:          1
> { parent_pid:       1406, child_pid:       1429 } hitcount:          1
> 
> So the test is right, the entries are not sorted. After digging into the
> ftrace code i noticed that integer values always get extended to 64 bit
> in event_hist_trigger(), but cmp_entries_key() from tracing_map.c uses the
> type of the field (which is a pid_t, and therefore 4 bytes).
> 
> On Little Endian this doesn't hurt, but on BE s390 this makes the compare
> function compare 4 zero bytes, which is the reason why sorting doesn't
> work. As a test i forced the compare function used in cmp_entries_key() to
> tracing_map_cmp_s64(), which made the ftrace tests pass.
> 
> I also tested this on 64 bit parisc with the same results, so the architecture
> doesn't seem make a difference (besides LE vs. BE)
> 
> Any thoughts on how to fix this? I'm not sure whether i fully understand the
> ftrace maps... ;-)

Your analysis makes sense. I'll take a deeper look at it.

Thanks for reporting it!

-- Steve
