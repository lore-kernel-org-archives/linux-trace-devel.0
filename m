Return-Path: <SRS0=9gE1=5R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F621C2D0F2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B552082F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vWet9JM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388930AbgDAQo7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:44:59 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38994 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389142AbgDAQo7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 12:44:59 -0400
Received: by mail-lj1-f196.google.com with SMTP id i20so166207ljn.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Apr 2020 09:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZqYDGrh/w5aaGhJ1iufI+VgF3dR5X61/0WwYSUuq7U=;
        b=vWet9JM4WvaX0GxoPQRAamYkTTggcJEy5jpmqEuWnnBU/lGXQWCNXb+CtbNQ7dqEOp
         bNa4PFPR9qmq/qxKYZI6L1X1d7h88G6j6zAOlqjFXQFq25DcnjE0ubf1LAfJqW3Do9dl
         gq0bUMIlr7QqVqdJV+qHhOXIgC3LknQJzwGcEMTebFJ6ner8/6jlKKUCFkieG1hJ7Wo+
         5mYVy8cWu8CmWzCahxdmjyuSi+BdZXqUdS17zYjNaaQluRfaIt5YVOZDIGW7tYp7ao9C
         zOiod1F6dum6UPYQiVDaOX8tt/tjEa2zYMbDfnvE8GEqLAaMSd/cGWV5hEcjnKM3LX6P
         BXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZqYDGrh/w5aaGhJ1iufI+VgF3dR5X61/0WwYSUuq7U=;
        b=aoYxM5lQwCMbI7wrWZDjFaut9EfUiKd+koyzwchbcBRm26OR99dTWzbL6k9n3D+Lnk
         ni/y9ic5ZL4RyaFR2S90d8wxRtu824hN8UF05HQN4uFu2AXTO63Z9owEXKe30ZJApsgR
         gyvf9wRzr3pa0wRGvYbi3yXmfRk0d99yLW6OvUK9dEJ+3qGUkSMWaAMFvEfXISXGPuAX
         tDI/XzxAoM+wEEjKBlJtpa1JjCW+JsaadYahcZ3g0nY79XOidr17lbe1c1ApPpzT2R9e
         uEuewOM0bpgmmALO7C/DQNer/4yOUgstEu9mJyWEdfLNTDdyh8ZeiEv309b5Hm9Bq6hJ
         zbOA==
X-Gm-Message-State: AGi0PuYBOIqvcenCs5sCNAtgbba9xepBcFKo/iEpcMLEL4vJnZOMadCI
        qS1hQxstoDsbs5GYsXNYBEbga3zvuzg=
X-Google-Smtp-Source: APiQypJjKiPbXm/Mufz4zmMylpMLJkRJFtvWYILSgGEomw03fjChTe6VBFYqRjWeEOOnE7/ueu79xw==
X-Received: by 2002:a05:651c:50e:: with SMTP id o14mr13253045ljp.241.1585759495423;
        Wed, 01 Apr 2020 09:44:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e4sm1982499lfn.80.2020.04.01.09.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 09:44:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/5] Timestamp offsets calculation per host CPU 
Date:   Wed,  1 Apr 2020 19:44:46 +0300
Message-Id: <20200401164451.191425-1-tz.stoyanov@gmail.com>
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

