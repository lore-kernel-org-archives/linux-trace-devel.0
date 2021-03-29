Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDB2C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 17:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCA2361936
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 17:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhC2RpI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 13:45:08 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:59646 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhC2Rop (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 13:44:45 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru E295320D0DB8
Received: from LanCloud
Received: from LanCloud
Subject: Re: Mutual debugging of 2 processes can stuck in unkillable stopped
 state
To:     Oleg Nesterov <oleg@redhat.com>
CC:     <linux-trace-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <f2f32ffa-52ad-ff67-19d8-95305a70a6f8@omprussia.ru>
 <20210329164900.GB24849@redhat.com>
 <4124a89e-a62e-0c51-1f46-8409867a626a@omprussia.ru>
 <20210329173848.GC24849@redhat.com>
From:   Igor Zhbanov <i.zhbanov@omprussia.ru>
Message-ID: <c0131d23-fb09-7622-d51d-30e094d92136@omprussia.ru>
Date:   Mon, 29 Mar 2021 20:44:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210329173848.GC24849@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To LFEX15.lancloud.ru
 (fd00:f066::45)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Oleg,

On 29.03.2021 20:38, Oleg Nesterov wrote:
> Hi Igor,
> 
> So. As expected, they sleep in EVENT_EXIT _after_ you have already
> sent SIGKILL.

Here is the processes stack before sending any signals to them:

izh@suse2:~> sudo cat /proc/1751/stack
[<0>] ptrace_stop+0x14e/0x260
[<0>] ptrace_do_notify+0x91/0xb0
[<0>] ptrace_notify+0x4e/0x70
[<0>] syscall_slow_exit_work+0x90/0x150
[<0>] do_syscall_64+0x129/0x1f0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

izh@suse2:~> sudo cat /proc/1979/stack
[<0>] ptrace_stop+0x14e/0x260
[<0>] get_signal+0x4d5/0x840
[<0>] do_signal+0x30/0x6a0
[<0>] exit_to_usermode_loop+0x8b/0x120
[<0>] do_syscall_64+0x1c3/0x1f0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

> Igor, thanks for your report, but (I think) this has nothing to do
> with mutual debugging. I'll return to this problem in a couple of
> days, I'm a bit busy right now.

Sorry for inexact description. I said it from the user perspective when
the processes are stopped and can't be killed. :-)
