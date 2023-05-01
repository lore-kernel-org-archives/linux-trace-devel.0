Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA82C77B7C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 May 2023 20:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjEAUb7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 May 2023 16:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjEAUb6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 May 2023 16:31:58 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D67B1727
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 May 2023 13:31:57 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94f6c285d22so615968766b.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 May 2023 13:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682973115; x=1685565115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JjLCoFdijm82jldTP3+TXJHSAIJD3kOc30DcAm15764=;
        b=amQLJlp69qpxZ10ebI+auoYZWmfqt8FDCXgnlp6khCSRtx5TfkRHnD3FzAFrrVnHen
         ZvU0U29zYZPu3Cqt9IRhdzFjSZQKfzsoJ+QS9lnP0zcRTt0Wno46+gX0DjEQwMINR7sg
         pXDMNW8cNOz5afFb4RhPE4eDhNBd0aKP9NMo1nrVgAqhiq7IipxganmY+DPzTDDuGa5S
         VxvUIHhmHMnVNmrlDFUv+NuCKftfC5Irri4tq0UkSoeeZn9+j3vfMar3v1z5r8HXcuSK
         4s4WwTGS3JFxMRPiiUbHUSqNvOD+MD03K6gsPw6/LiIx5rAKZ1l+hREE8GZdLCxjMkZC
         xKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682973115; x=1685565115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JjLCoFdijm82jldTP3+TXJHSAIJD3kOc30DcAm15764=;
        b=SD7SF2wfWFyCLi4u0WW2vxr0UmlMIV2xNssU131tQQFr+iaZoduFYIJXP9rnzYYg7j
         i14oG7c2uWQ2OnpfMOyjJcwPwjNcVGm5T1HFAE2wjh1wNiNENhiru9q5+shApZIRNioK
         +R4XgjBvKHu8mFW1Von1WCOYmQwEqxXYyRnG5+s2Dy97BNYF+vkqZOlbeGD507y8V19o
         s4KcsRMv4j9+92sOiFAxOSbQVrsmr5TMOgMl90IZxNmXs2bNWyG0uEXUgvZjwHY+Agr8
         hjnIw5+ksNLpMXBTv0OWQfVXp1Gg7cCxdThosh3/2cilh67RluQ1MKzdj+IRxUDJc8Z8
         UyOg==
X-Gm-Message-State: AC+VfDzgkkW3lhiP1mhp0Q5m/v1QoGizcVmJakD+4l0h5E2E2xdTGWlV
        IRTgyhXBHa0ZnNFTEtT2p0JR+jeyEq0=
X-Google-Smtp-Source: ACHHUZ4Q0UmVKDO3lQI18IuUGTpAw6VDk13ZsbwOeRQwjQc/aNX1qhslad/0Bh3tbxfCGqOrmuHvTA==
X-Received: by 2002:a17:907:a04:b0:94a:474a:4dd5 with SMTP id bb4-20020a1709070a0400b0094a474a4dd5mr14310983ejc.9.1682973115325;
        Mon, 01 May 2023 13:31:55 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id i25-20020a170906851900b0094f1b8901e1sm15233933ejx.68.2023.05.01.13.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 13:31:55 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Avidan Borisov <avidanborisov@gmail.com>
Subject: [PATCH 0/3] trace-cmd record: Support daemonization after recording starts
Date:   Mon,  1 May 2023 23:31:15 +0300
Message-Id: <20230501203118.3105605-1-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Avidan Borisov <avidanborisov@gmail.com>

This patch series adds support for daemonizing trace-cmd record after tracing
has started. The motivation is to be able to use trace-cmd more easily
in automated setups.

The main reason to do this in trace-cmd itself, is that it allows us to do the daemonization
at the latest point possible. This has few advantages over daemonizing trace-cmd as a whole:

  1. We can cleanly fail if something failed during initialization, and signal
     it up to the caller normally with a status code. This is not possible if we
     daemonize trace-cmd as a whole, since the the error could happen after the
     daemonization, but at that point trace-cmd is already a background process,
     and it's cumbersome to check if it failed or not.

  2. The next thing that executes after trace-cmd exits will definitely be recorded
     in the trace, since we exit to the caller only after tracing has started. This
     is especially important when we trace guests as well, since the KVM/PTP time synchronization
     can take a while to complete, and we can't know for sure when the actual tracing
     starts. With --daemonize we know that once trace-cmd exits, the tracing has started.

Here's an example how naive daemonization fails:

$ sudo setsid trace-cmd record -p nop -e 'net:sched_process_exec' -A guest -p nop -e net & \
    > ping -c 1 10.20.1.2 &&
    > sudo kill -SIGINT $! &&
    > sudo trace-cmd report -i trace.dat -i trace-guest.dat | head
[1] 3087529
PING 10.20.1.2 (10.20.1.2) 56(84) bytes of data.
64 bytes from 10.20.1.2: icmp_seq=1 ttl=64 time=0.233 ms
--- 10.20.1.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.233/0.233/0.233/0.000 ms
[1]+  Interrupt               sudo setsid trace-cmd record -p nop -e 'net:sched_process_exec' -A guest -p nop -e net
trace-cmd: No such file or directory
  opening 'trace.dat'

Here we have stopped trace-cmd too early, and no trace was generated. Now with --daemonize:

$ sudo trace-cmd record --daemonize -p nop -e 'sched:sched_process_exec' -A guest -p nop -e net &&
    > ping -c 1 10.20.1.2 &&
    > sudo start-stop-daemon --stop --signal INT --retry 20 --pidfile /var/run/trace-cmd-record.pid &&
    > sudo trace-cmd report -i trace.dat -i trace-guest.dat | head
Negotiated kvm time sync protocol with guest guest
Send SIGINT to pid 3071371 to stop recording
PING 10.20.1.2 (10.20.1.2) 56(84) bytes of data.
64 bytes from 10.20.1.2: icmp_seq=1 ttl=64 time=0.134 ms
--- 10.20.1.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.134/0.134/0.134/0.000 ms
CPU0 data recorded at offset=0x14f000
    229 bytes in size (4096 uncompressed)
....
      trace.dat: cpus=28
trace-guest.dat: cpus=1
      trace.dat:           ping-3071450 [013] 1196830.834258: sched_process_exec:     filename=/bin/ping pid=3071450 old_pid=3071450
trace-guest.dat:           <idle>-0     [000] 1196830.835990: napi_gro_receive_entry: dev=eth1 napi_id=0x2002 queue_mapping=1 skbaddr=0xffff95d051a5c400 vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=0 hash=0x00000000 l4_hash=0 len=84 data_len=0 truesize=768 mac_header_valid=1 mac_header=-14 nr_frags=0 gso_size=0 gso_type=0
trace-guest.dat:           <idle>-0     [000] 1196830.835997: napi_gro_receive_exit:  ret=3
trace-guest.dat:           <idle>-0     [000] 1196830.835998: netif_receive_skb:      dev=eth1 skbaddr=0xffff95d051a5c400x len=84
trace-guest.dat:           <idle>-0     [000] 1196830.836021: net_dev_queue:          dev=eth1 skbaddr=0xffff95d051a5c700x len=98
trace-guest.dat:           <idle>-0     [000] 1196830.836024: net_dev_start_xmit:     dev=eth1 queue_mapping=0 skbaddr=0xffff95d051a5c700 vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=0 len=98 data_len=0 network_offset=14 transport_offset_valid=1 transport_offset=34 tx_flags=0 gso_size=0 gso_segs=0 gso_type=0
trace-guest.dat:           <idle>-0     [000] 1196830.836069: net_dev_xmit:           dev=eth1 skbaddr=0xffff95d051a5c700 len=98 rc=0
      trace.dat:           sudo-3071451 [015] 1196830.838262: sched_process_exec:     filename=/usr/bin/sudo pid=3071451 old_pid=3071451

As for the implementation itself - unfortunately since daemon(3) calls fork(), we can't call it after
creating other processes/threads (if we call it after creating the recorder processes it'll mess up the
process hierarchy, and if after the tsync thread creation, it will mess up memory sharing).
However the point in time where we want to exit to the caller is after those processes/threads
have started, since that's when tracing actually starts.

Therefore, we implement the daemonization ourselves in the following way:
    1. We fork() early, and make the parent waitpid on the child.
    2. When the child finishes initializing everything, it detaches
       from the session and sends a signal to the parent.
    3. The parent can now exit, causing the entire process hierarchy
       of the child to be inherited by init.
    4. The daemonization is now complete, and the caller to trace-cmd
       now executes the next thing, which will be traced.

Avidan Borisov (3):
  trace-cmd record: Add --daemonize
  trace-cmd: export pidfile functions from trace-listen.c
  trace-cmd record: Create a pidfile when using --daemonize

 .../trace-cmd/trace-cmd-record.1.txt          |   4 +
 tracecmd/include/trace-local.h                |   4 +
 tracecmd/trace-listen.c                       |  32 ++--
 tracecmd/trace-record.c                       | 141 +++++++++++++++++-
 tracecmd/trace-usage.c                        |   3 +
 5 files changed, 164 insertions(+), 20 deletions(-)

-- 
2.25.1

