Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D4EC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74A132084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfDLNxl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:53:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfDLNxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:53:41 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EDB1C0828DB;
        Fri, 12 Apr 2019 13:53:35 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 160CB18A26;
        Fri, 12 Apr 2019 13:53:35 +0000 (UTC)
Date:   Fri, 12 Apr 2019 09:53:33 -0400
From:   Phil Auld <pauld@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: trace-cmd fails with many cpus
Message-ID: <20190412135333.GB6201@pauld.bos.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 12 Apr 2019 13:53:40 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

I was trying to get some sched traces on a 160 cpu box yesterday. Trace-cmd 
failed with 

# ./tracecmd/trace-cmd record -e "sched:*" sleep 2
none
trace-cmd: Invalid argument
  Failed filter of /sys/kernel/tracing/events/sched/sched_switch/filter

trace-cmd: No such file or directory
  can not stat 'trace.dat.cpu0'
#


Which can be seen better with strace

[pid 97653] open("/sys/kernel/tracing/events/sched/sched_swap_numa/filter", O_WRONLY|O_TRUNC) = 5
[pid 97653] write(5, "(common_pid!=97652)&&(common_pid"..., 3358) = 3358
[pid 97653] close(5)                    = 0
[pid 97653] open("/sys/kernel/tracing/events/sched/sched_switch/filter", O_WRONLY|O_TRUNC) = 5
[pid 97653] write(5, "(common_pid!=97652)&&(common_pid"..., 6398) = -1 EINVAL (Invalid argument)
[pid 97653] close(5)                    = 0

The filter file can only take a max write of length PAGE_SIZE. 

The extra pid filtering added for "next_pid"  more or less doubles length
and pushes it over the 4k limit. 

WRITE: /sys/kernel/tracing/events/sched/sched_switch/filter, len 6718, data "(common_pid!=100199)&&(common_pid!=100198)&&(common_pid!=100197)&&(common_pid!=100196)&&(common_pid!=100195)&&(common_pid!=100194)&&(common_pid!=100193)&&(common_pid!=100192)&&(common_pid!=100191) ... 160 of these ...
&&(common_pid!=100040)||(next_pid!=100199)&&(next_pid!=100198)&&(next_pid!=100197)&&(next_pid!=100196)&&(next_pid!=100195)&&(next_pid!=100194)&&(next_pid!=100193)&&(next_pid!=100192)...  160 of these...


I suppose the answer is don't run on a system with that many cpus  :)

But I wonder if it would be possible to have the threads each handle say 8 cpu
files or something.

Or maybe have the kernel filter accept an "all_pid" that covered common_pid, next_pid, pid to reduce
the number of items needed in there? 



Thanks,

Phil



-- 
