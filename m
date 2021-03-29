Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25D8C433C1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 15:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5FD861968
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 15:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhC2Pfp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 11:35:45 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:41752 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhC2PfT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 11:35:19 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Mar 2021 11:35:18 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 0ECD720F79E8
Received: from LanCloud
Received: from LanCloud
To:     <linux-trace-devel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
From:   Igor Zhbanov <i.zhbanov@omprussia.ru>
Subject: Mutual debugging of 2 processes can stuck in unkillable stopped state
Message-ID: <f2f32ffa-52ad-ff67-19d8-95305a70a6f8@omprussia.ru>
Date:   Mon, 29 Mar 2021 18:28:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To LFEX15.lancloud.ru
 (fd00:f066::45)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Mutual debugging of 2 processes can stuck in unkillable stopped state

Hi!

When one process, let's say "A", is tracing the another process "B", and the
process "B" is trying to attach to the process "A", then both of them are
getting stuck in the "t+" state. And they are ignoring all of the signals
including the SIGKILL, so it is not possible to terminate them without
a reboot.

To reproduce:
1) Run two terminals
2) Attach with "strace -p ..." from the first terminal to the shell (bash) of
    the second terminal.
3) In the second terminal run "exec strace -p ..." to attach to the PID of the
    first strace.

Then you'll see that the second strace is hanging without any output. And the
first strace will output following and hang too:
ptrace(PTRACE_SEIZE, 11795, NULL,
        PTRACE_O_TRACESYSGOOD|PTRACE_O_TRACEEXEC|PTRACE_O_TRACEEXIT

(The 11795 is the PID of the first strace itself.)

And in the process list you will see following:
ps awux | grep strace
user   11776  0.0  0.0  24752  2248 pts/3    t+   13:53   0:00 strace -p 11795
user   11795  0.0  0.0  24752  3888 pts/1    t+   13:54   0:00 strace -p 11776

I suppose that there should be some way to break the deadlocked debug. And the
system administrator must be able to terminate non-privileged processes.

Thank you.
