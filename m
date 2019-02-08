Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57480C169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BD3520869
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfBHNtX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:49:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46300 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726679AbfBHNtW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 08:49:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id l9so3584254wrt.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Feb 2019 05:49:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NFjIREWtYMJtPnpyT3VKA3ZkK5VKawCaiHhz1N6vkLA=;
        b=HLF/3rC9JdXQnEdSEnTX25XF6VmXop6cMRqiGNtNh2cl+9dwgtDUSuE5lrR6de65Ip
         XWArN19gtlzZe9QDwfHn56DAktJsHg4QdaXxt5aHc6Z1fR6QBiQelX9IpqObF7K7GI1k
         9w+3WkSM/nnYZc37QmqlaHsQxLpz3JFm4s4TVi/nL9sjmbpA6IIkgt4kA4mGRr0ByWCJ
         IdnC715oObTbHsmBQdBK9xDUw2xjHfmA2E7kcQW7krZjfU3RnaD95k70YQfgvgPjFG8M
         0E+PYk/gRtuhb8ntX4+rY/IaxgMaz9S1xYKPwHt2WdVbBsP34DbjoZaUtUYOPSztI9JH
         7BUQ==
X-Gm-Message-State: AHQUAubwl6wBlHunWp1Vqx3BjtnFaLpgImZCj/hWdTcaWIP+bulVhwu9
        Y469Xem08ghl718UX19/P3LtZyBT
X-Google-Smtp-Source: AHgI3IY1kpCx1ktdllbQK+CXuh8LsPXYAth2F0jNBTkekDijYkjFtGbMBDJYfeCoLes9t48zy1gj9w==
X-Received: by 2002:adf:9123:: with SMTP id j32mr17647735wrj.122.1549633761027;
        Fri, 08 Feb 2019 05:49:21 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a184sm2534796wmh.37.2019.02.08.05.49.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 05:49:20 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/7][POC] trace-cmd: Timetamps sync using PTP-like algorithm, relying on vsock events.
Date:   Fri,  8 Feb 2019 15:49:11 +0200
Message-Id: <20190208134918.5618-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ V3 changes: 
 - Removed any magic constants, used in the PTP-like algorithm, 
   as Slavomir Kaslev suggested.
 - Implemented new algorithm, based on mapping kvm_exit events 
   in host context to vsock_send events in guest context, 
   suggested by Steven Rostedt. 
]

This patch series is a POC for timestamps sync between guest and host machines.
It implelents two algorithms: 
    - PTP-like algorithm, using vsock events for getting the current time.
    - algorithm based on mapping kvm_exit events in host context to vsock_send 
      events in guest context.
Both algorithms run simultaneously, so the results can be easily compared.
The "#if" directive at the end of tracecmd_msg_snd_time_sync() can be used 
to swith between the results of the both algorithms - which one of them to be 
written in the trace file.

The patch series depends on Slavomir's changes, introduced by the patch series
"Add VM kernel tracing over vsockets and FIFOs"


Tzvetomir Stoyanov (7):
  trace-cmd: Implemented new lib API: tracecmd_local_events_system()
  trace-cmd: Added support for negative time offsets in trace.dat file
  trace-cmd: Fixed logic in tracecmd_read_page_record()
  trace-cmd: Added implementation of htonll() and ntohll()
  trace-cmd: Refactored make_instances() and tracecmd_remove_instances()
  trace-cmd: Find and store pids of tasks, which run virtual CPUs of
    given VM
  trace-cmd [POC]: Implemented timestamps synch PTP-like algorithm,
    using vsock events.

 include/trace-cmd/trace-cmd.h  |   8 +-
 lib/trace-cmd/trace-input.c    |  18 +-
 lib/trace-cmd/trace-util.c     |  99 ++++--
 tracecmd/include/trace-local.h |   9 +
 tracecmd/include/trace-msg.h   |  10 +
 tracecmd/trace-listen.c        |   3 +
 tracecmd/trace-msg.c           | 543 ++++++++++++++++++++++++++++++++-
 tracecmd/trace-read.c          |   4 +-
 tracecmd/trace-record.c        | 465 ++++++++++++++++++++++------
 9 files changed, 1020 insertions(+), 139 deletions(-)

-- 
2.20.1

