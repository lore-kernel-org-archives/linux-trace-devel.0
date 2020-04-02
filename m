Return-Path: <SRS0=JQUT=5S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C07AC43331
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 10:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC4E206F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 10:58:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u7U89NtN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388001AbgDBK6h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 06:58:37 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41753 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgDBK6h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 06:58:37 -0400
Received: by mail-lf1-f66.google.com with SMTP id z23so2322383lfh.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Apr 2020 03:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eVJyzQDGe9UUbNeskvEeC8VjFZ251RWC85W0OO+0dfM=;
        b=u7U89NtNs0yi6Wa40q16lOo1jZ8L40zVlULeZHfC0TwOX2HE1knz87fyjFcZlbGjzz
         1QB201EVY1NvH1o0xMgMtcraACJ85K/prE5WsYX+2hs2OjGmTRMr2h7beC+pvDxYMASk
         h45KO6B8HDv3tpp8WfLkZbpMIIlGB8phGm44HUFIx4HARooZHpIQMptyz/vlJIp9sBjj
         re6IpR9GWgQRO2lN6wrEOqqa/FqryH34VwyENURScoxwRTIlJTy7rYjZVMMy+3v0Pf+/
         8n1Gb6s/yjNSHct7sKaY2+vRDCbtCTu33cLsN4rDTkD+K0JBa7S8Kv5Du4Eq8j5cfwSn
         uBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eVJyzQDGe9UUbNeskvEeC8VjFZ251RWC85W0OO+0dfM=;
        b=SxaTQdibN7NNGoJ4NmYGelzNBLb5RE44wtg3/BtBpkqD9QmhBt7dlWzDXZ8RZUT30F
         6C8iBDIIaTX915wp9WIza/u3jJNRC90rs3WDe0AtyOSSxGG3veWwp8O07U6kiM4iwoVK
         dWnhyIs33iokFepFbbpyzOfdwE60VR3B8GUKD6rWx+rAoYfjrFI9Jh70SgV6nynzAcP7
         omlOAaOJP1ub5TnSIPNv8oXvMR/4FwWm6AJfWtXccmlMSb7W8afMUWVXocLYPWLH8p7B
         nqA01BNOc6AnzupkrQN117cIOZKPCRqSLQfvuLRAQFK9OM1JnW3U2BbZ51RJGdevERqK
         eN1g==
X-Gm-Message-State: AGi0PuaTqlQXuUEr3kp+qogZmCu+Qc2Gfcm9OiZi+53ssgB2xrWFx63C
        T47YEqOBN3etjBxvaxK2uDBBHXWFK2o=
X-Google-Smtp-Source: APiQypJ2+oY0km7JPOrFa3pkNjyT+3nm6F6QFIIQiku/5engqJ6IJvlehLSu5f5/wQ+zZ/v8KW7SHg==
X-Received: by 2002:a05:6512:3b7:: with SMTP id v23mr1737904lfp.66.1585825114603;
        Thu, 02 Apr 2020 03:58:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c2sm3779803lfb.43.2020.04.02.03.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 03:58:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/5] Timestamp offsets calculation per host CPU 
Date:   Thu,  2 Apr 2020 13:58:26 +0300
Message-Id: <20200402105831.263753-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The clock, used for trace time stamps, can vary between CPUs.
When synchronizing host and guest trace time stamps, these
variations could introduce inaccuracy.
The algorithm for host - guest trace time stamps synchronization
is modified to calculate the offset per each host CPU, depending
on the CPU affinity of host tasks, running the guest's VCPUs.
The calculated array per CPU is stored in the trace.dat file, using
TRACECMD_OPTION_TIME_SHIFT option.
The "trace-cmd dump --options" command and tracecmd_init_data() API
are adjusted to read the new format of this option.

In order this per CPU synchronization data to be used when host and
guest files are merged, information about guest VCPUs migration
between host CPUs is needed. This information is extracted from
host trace data, thus the host trace must be recored with "-e sched"
option.

A new API tracecmd_open_merge() is introduced, which triggers this
per CPU calculations when opening tracing files. This API must be
used by KernelShark when opening host and guest files. There is a
separate patch for this, not part of the series. 

[
 v3 changes:
  - Fix allocation of VCPU sched data array when reading sched data
    from host trace file.
]

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Time stamp offset per host CPU
  trace-cmd: Fix reading of the traceid option from trace.dat file
  trace-cmd: Add new API to merge two trace files
  trace-cmd: Add a define to enable per CPU timestamps synchronization
  trace-cmd: Use per CPU synchronization data when calculating
    timestamps offsets

 include/trace-cmd/trace-cmd.h             |   7 +-
 lib/trace-cmd/include/trace-tsync-local.h |  16 +-
 lib/trace-cmd/trace-input.c               | 516 +++++++++++++++++++---
 lib/trace-cmd/trace-timesync.c            | 269 +++++++++--
 tracecmd/include/trace-local.h            |   4 +
 tracecmd/trace-dump.c                     |  60 ++-
 tracecmd/trace-record.c                   |  18 +
 tracecmd/trace-tsync.c                    | 144 +++---
 8 files changed, 832 insertions(+), 202 deletions(-)

-- 
2.25.1

