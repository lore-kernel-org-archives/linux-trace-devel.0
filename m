Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2994C433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 17:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 926606191F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Mar 2021 17:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhC2RCE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 13:02:04 -0400
Received: from mxout03.lancloud.ru ([45.84.86.113]:47094 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhC2RBj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 13:01:39 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 199E920A8A20
Received: from LanCloud
Received: from LanCloud
Subject: Re: Mutual debugging of 2 processes can stuck in unkillable stopped
 state
To:     Oleg Nesterov <oleg@redhat.com>
CC:     <linux-trace-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <f2f32ffa-52ad-ff67-19d8-95305a70a6f8@omprussia.ru>
 <20210329164900.GB24849@redhat.com>
From:   Igor Zhbanov <i.zhbanov@omprussia.ru>
Message-ID: <4124a89e-a62e-0c51-1f46-8409867a626a@omprussia.ru>
Date:   Mon, 29 Mar 2021 20:01:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20210329164900.GB24849@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To LFEX15.lancloud.ru
 (fd00:f066::45)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Oleg!

I've tried both 5.3.18 and 5.10.0. The behavior is the same.
The important thing is to run "exec strace -p ..." on the second terminal
to create the loop A->B->A.

So the last line from the first strace we see is:
ptrace(PTRACE_SEIZE, 1990, NULL, PTRACE_O_TRACESYSGOOD|PTRACE_O_TRACEEXEC|PTRACE_O_TRACEEXIT

I.e. it printed the syscall prior to its execution and hanged after the
execution.

izh@suse2:~> ps awux|grep strace
izh       1891  0.0  0.0  24752  3828 pts/1    ts+  19:52   0:00 strace -p 1990
izh       1990  0.0  0.0  24752  3628 pts/0    t+   19:53   0:00 strace -p 1891

izh@suse2:~> kill 1990 1891
izh@suse2:~> kill -9 1990 1891

izh@suse2:~> sudo cat /proc/1891/stack
[sudo] password for root:
[<0>] ptrace_stop+0x14a/0x260
[<0>] ptrace_do_notify+0x91/0xb0
[<0>] ptrace_notify+0x4e/0x70
[<0>] do_exit+0x910/0xb70
[<0>] do_group_exit+0x3a/0xa0
[<0>] get_signal+0x124/0x800
[<0>] arch_do_signal_or_restart+0xa9/0x290
[<0>] exit_to_user_mode_prepare+0xe7/0x1a0
[<0>] syscall_exit_to_user_mode+0x18/0x40
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

izh@suse2:~> sudo cat /proc/1990/stack
[<0>] ptrace_stop+0x14a/0x260
[<0>] ptrace_do_notify+0x91/0xb0
[<0>] ptrace_notify+0x4e/0x70
[<0>] do_exit+0x910/0xb70
[<0>] do_group_exit+0x3a/0xa0
[<0>] get_signal+0x124/0x800
[<0>] arch_do_signal_or_restart+0xa9/0x290
[<0>] exit_to_user_mode_prepare+0xe7/0x1a0
[<0>] syscall_exit_to_user_mode+0x18/0x40
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

izh@suse2:~> cat /proc/1891/status
Name:   strace
Umask:  0022
State:  t (tracing stop)
Tgid:   1891
Ngid:   0
Pid:    1891
PPid:   1890
TracerPid:      1990
Uid:    1000    1000    1000    1000
Gid:    100     100     100     100
FDSize: 256
Groups: 100
NStgid: 1891
NSpid:  1891
NSpgid: 1891
NSsid:  1891
VmPeak:    24752 kB
VmSize:    24752 kB
VmLck:         0 kB
VmPin:         0 kB
VmHWM:      3828 kB
VmRSS:      3828 kB
RssAnon:             520 kB
RssFile:            3308 kB
RssShmem:              0 kB
VmData:      284 kB
VmStk:       132 kB
VmExe:      1108 kB
VmLib:      2828 kB
VmPTE:        80 kB
VmSwap:        0 kB
HugetlbPages:          0 kB
CoreDumping:    0
THP_enabled:    1
Threads:        1
SigQ:   4/15639
SigPnd: 0000000000000000
ShdPnd: 0000000000014100
SigBlk: 0000000000002000
SigIgn: 0000000000300000
SigCgt: 0000000180007007
CapInh: 0000000000000000
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: 000001ffffffffff
CapAmb: 0000000000000000
NoNewPrivs:     0
Seccomp:        0
Seccomp_filters:        0
Speculation_Store_Bypass:       vulnerable
SpeculationIndirectBranch:      always enabled
Cpus_allowed:   7
Cpus_allowed_list:      0-2
Mems_allowed:   00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001
Mems_allowed_list:      0
voluntary_ctxt_switches:        1561
nonvoluntary_ctxt_switches:     7

izh@suse2:~> cat /proc/1990/status
Name:   strace
Umask:  0022
State:  t (tracing stop)
Tgid:   1990
Ngid:   0
Pid:    1990
PPid:   1847
TracerPid:      1891
Uid:    1000    1000    1000    1000
Gid:    100     100     100     100
FDSize: 256
Groups: 100
NStgid: 1990
NSpid:  1990
NSpgid: 1990
NSsid:  1847
VmPeak:    24752 kB
VmSize:    24752 kB
VmLck:         0 kB
VmPin:         0 kB
VmHWM:      3628 kB
VmRSS:      3628 kB
RssAnon:             520 kB
RssFile:            3108 kB
RssShmem:              0 kB
VmData:      284 kB
VmStk:       132 kB
VmExe:      1108 kB
VmLib:      2828 kB
VmPTE:        88 kB
VmSwap:        0 kB
HugetlbPages:          0 kB
CoreDumping:    0
THP_enabled:    1
Threads:        1
SigQ:   4/15639
SigPnd: 0000000000000000
ShdPnd: 0000000000014100
SigBlk: 0000000000002000
SigIgn: 0000000000300000
SigCgt: 0000000180007007
CapInh: 0000000000000000
CapPrm: 0000000000000000
CapEff: 0000000000000000
CapBnd: 000001ffffffffff
CapAmb: 0000000000000000
NoNewPrivs:     0
Seccomp:        0
Seccomp_filters:        0
Speculation_Store_Bypass:       vulnerable
SpeculationIndirectBranch:      always enabled
Cpus_allowed:   7
Cpus_allowed_list:      0-2
Mems_allowed:   00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001
Mems_allowed_list:      0
voluntary_ctxt_switches:        180
nonvoluntary_ctxt_switches:     848

On 29.03.2021 19:49, Oleg Nesterov wrote:
> On 03/29, Igor Zhbanov wrote:
>>
>> Mutual debugging of 2 processes can stuck in unkillable stopped state
> 
> can't reproduce and can't understand...
> 
>> Hi!
>>
>> When one process, let's say "A", is tracing the another process "B", and the
>> process "B" is trying to attach to the process "A", then both of them are
>> getting stuck in the "t+" state. And they are ignoring all of the signals
>> including the SIGKILL,
> 
> Why do you think so? What is your kernel version?
> 
> "t" means TASK_TRACED, SIGKILL should wake it up and terminate.
> 
>> so it is not possible to terminate them without
>> a reboot.
>>
>> To reproduce:
>> 1) Run two terminals
>> 2) Attach with "strace -p ..." from the first terminal to the shell (bash) of
>>     the second terminal.
>> 3) In the second terminal run "exec strace -p ..." to attach to the PID of the
>>     first strace.
>>
>> Then you'll see that the second strace is hanging without any output. And the
>> first strace will output following and hang too:
>> ptrace(PTRACE_SEIZE, 11795, NULL,
>>         PTRACE_O_TRACESYSGOOD|PTRACE_O_TRACEEXEC|PTRACE_O_TRACEEXIT
>>
>> (The 11795 is the PID of the first strace itself.)
>>
>> And in the process list you will see following:
>> ps awux | grep strace
>> user   11776  0.0  0.0  24752  2248 pts/3    t+   13:53   0:00 strace -p 11795
>> user   11795  0.0  0.0  24752  3888 pts/1    t+   13:54   0:00 strace -p 11776
> 
> OK, may be they sleep in PTRACE_EVENT_EXIT? After you tried to send SIGKILL?
> 
> please show us the output from "cat /proc/{11795,11776}/stack". And
> "cat /proc/{11795,11776}/status" just in case.
