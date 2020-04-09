Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58549C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A77C208FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L7RoKlL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgDIN2v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:51 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]:44469 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgDIN2v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:51 -0400
Received: by mail-lf1-f47.google.com with SMTP id 131so7861373lfh.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K1Tc6I1b88bPnOBrjcWZ+5u5VPx/Ov21EEjwIHgavh4=;
        b=L7RoKlL7L6FhpBDLOMc3mCDOIMhERRSD0J3wBeEfaFAUWt+K8/9rHi0QghWUIakmJh
         29wRrkOySarq4SfWl1O9LlKSdEfjGpUPzTM6OE0unnZATmR5U+QmQ1GuyLMmNzeWPuuC
         sdjK42Vdx96mS/tuvXkZa+T4LhQBn8roJpP4vPuXzGBkjKK/2t8QRWyhUxCfRUpzdAuT
         imrBy/+9VbnDtyOuFEYjLc9ffGAAmEYelNaaRapOMUvkcEOwuwpkkSB/wdZao5PJb+Tw
         rKuPjZtvBVg1ddgJpnXgyDYK47ZWph3eIbEcw8lVXnTKTCwyu50eEhA4Ql2Fe//fwswS
         LQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K1Tc6I1b88bPnOBrjcWZ+5u5VPx/Ov21EEjwIHgavh4=;
        b=rJsKGkxWfd3HTiZCPiovuxYGaKouf4PgaGt0SjAWGUVi4vuPPVNidgTYSY331Ad51a
         vqx9hBM6KwrRftX3E87pOySZaw4An6M4aHSIK4F6JahN/s1/wCM9KQTAGHzNHFmK6dKG
         g1YwPiWVDqTOeHfXfo7MwbBmTwC1H+eEPlNyFDY6omNHauAVxNpaarhDaM6Q6ddfanEk
         OOeqWuLUfk1f8rba5kUxBc0WQggy78hdHf5kO3SdqzbmK0UJ3Gw4vJpgUKw0TKqLGbaY
         rt1wCkMVKwACkpk7SH5RX1aWd4hgNIVoU86/biHHQ8+PGV7r4yKJYkFpyzHuAdSuA0aR
         +RHg==
X-Gm-Message-State: AGi0PuY3UQNeGjxRIYHXKBJQHzSdst/+zaWsA5g/jP+vwC4udp08DY7v
        yAn+n1FxOOLkwK4rJa5TmPmojA8Tf1U=
X-Google-Smtp-Source: APiQypK4bsF4CJpaOiS7RdOlRN7kblbqxRk8AwBprNT4npnk9ZlMeCOU1+c1Q6PsCrkAsykI2/Shhg==
X-Received: by 2002:ac2:519c:: with SMTP id u28mr7717581lfi.17.1586438929611;
        Thu, 09 Apr 2020 06:28:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w16sm3716849lfk.49.2020.04.09.06.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/3] Timestamp offsets calculation per host CPU 
Date:   Thu,  9 Apr 2020 16:28:44 +0300
Message-Id: <20200409132847.79592-1-tz.stoyanov@gmail.com>
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

[
 v4 changes:
  - Remove all patches, not related directly to per host CPU timestamp
    offsets calculation, from the patch set.
 v3 changes:
  - Fix allocation of VCPU sched data array when reading sched data
    from host trace file.
]

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Time stamp offset per host CPU
  trace-cmd: Add a define to enable per CPU timestamps synchronization
  trace-cmd: Use per CPU synchronization data when calculating
    timestamps offsets

 include/trace-cmd/trace-cmd.h             |   6 +-
 lib/trace-cmd/include/trace-tsync-local.h |  16 +-
 lib/trace-cmd/trace-input.c               | 433 +++++++++++++++++++---
 lib/trace-cmd/trace-timesync.c            | 269 ++++++++++++--
 tracecmd/include/trace-local.h            |   4 +
 tracecmd/trace-dump.c                     |  60 ++-
 tracecmd/trace-record.c                   |  18 +
 tracecmd/trace-tsync.c                    | 144 ++++---
 8 files changed, 757 insertions(+), 193 deletions(-)

-- 
2.25.1

