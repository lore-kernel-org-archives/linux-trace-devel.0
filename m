Return-Path: <SRS0=JN9e=RH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E96DC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Mar 2019 10:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6204C2082F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Mar 2019 10:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfCDKBl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 05:01:41 -0500
Received: from s30320.gliwa.com ([148.251.52.238]:33486 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbfCDKBl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 05:01:41 -0500
Received: by mail.gliwa.com (Postfix, from userid 992)
        id C6B96340BF0; Mon,  4 Mar 2019 11:01:39 +0100 (CET)
X-Virus-Checker-Version: ClamAV 0.101.1/25377/Sun Mar 3 11:37:14 2019
X-Virus-Status: OK
Received: from [192.168.2.102] (dslb-178-003-217-045.178.003.pools.vodafone-ip.de [178.3.217.45])
        by mail.gliwa.com (Postfix) with ESMTPSA id 934B3340BD1;
        Mon,  4 Mar 2019 11:01:39 +0100 (CET)
To:     joel@joelfernandes.org
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, Chunyu Hu <chuhu@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
From:   Claudio <claudio.fontana@gliwa.com>
Subject: make TGID available also in binary ring buffer?
Message-ID: <6e61f5ff-5302-ad96-66d3-38347bf3cf69@gliwa.com>
Date:   Mon, 4 Mar 2019 11:01:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hello all,

I am currently facing the issue of having to efficiently read the events
from a user-space application for tracing for programmatic use in automotive
(AUTOSAR AP).

It is for programmatically reacting to events on the system,
and I am currently using the trace_pipe_raw to do that, to reduce the
overhead compared with parsing the textual output of trace_pipe.

After merging the sorted streams from all cpus, in order to reconstruct
the task state, we are still way more CPU-efficient compared with using the
textual output.

I would like to make use of the implemented support for recording tgids,

commit d914ba37d714 ("tracing: Add support for recording tgid of tasks")
commit 441dae8f2f29 ("tracing: Add support for display of tgid in trace output")

but it seems to me that, while for COMM recording there is explicit support in
the binary events for the information, it seems that tgid is not stored in the
binary format.

Is such an extension of the binary format a possibility for sched-class
events, that takes into account backward compatibility, or is there some
better way to do it? Is this problem addressed by libtracevent / trace-cmd?

Currently I was thinking to look into the NETLINK interface to get the task
information, however the issue is the race condition between the time of
tracing and the time of reading the trace, to be fully correct, but if
nothing else is possible I will have to accept the compromise.

Thank you for any hints on this.

Ciao,

Claudio
