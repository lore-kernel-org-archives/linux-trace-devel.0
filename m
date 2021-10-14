Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F2E5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF74610CB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhJNPPH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbhJNPNK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 11:13:10 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C027C06177D
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t2so20456785wrb.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=33L1GCg6kjVAqov2Lo7FLFNaQJiDTxgNYWAFwhl78A8=;
        b=cNoKJJzC0fc/Rp94csaK4fY2HlVj6pOHZjhdNaakwQc13BOwu/+EiKteRmTUem6jOz
         dvM6eGQClCS407hZof4qATxnIk3YfzS3J6KxSi2jSjA/pq/kVQhbG0L9qk8cpGJUckcl
         yzpCifZ6P5AGV5wu9S4nBANLENnfJ5C5N1LSGwisPd01D9oNylCkdAw1617qosv6PZBJ
         ICPoJFwlH6aPQegXrOUAappG4XOBXcpMQYY9oaPzss5AB0LtEnoT45hDfBpK5LukCgHM
         v58482ebqPTHvY/GylMb4Wao+WO8GEzHl5YoJVenFH+7THsn/+WesjZrBhBCvFketkxn
         SnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=33L1GCg6kjVAqov2Lo7FLFNaQJiDTxgNYWAFwhl78A8=;
        b=aimih0oA0Hk4ps3hsBHLJzSKETMgte0OKDyF4MEZ2wg1zJ9Q4bKrHEVFOPd1tA6yw4
         R8uvSinq3qwo2xGsSE82sCqDgwWiaPKVRCBx6JwvwMdJd/3Lxfvm0P643qJO38pZIevI
         oUVbsa2U5vMXzsg6KPJA2YNbPnJuKcA51c/jQFfc65ZUH8g7YoI4xIdegWSznUMsUock
         uazzuw58fjAyc34c1Mqk+lo0q1B3BgelwUCAASi8Oy1MTeLuM6dHHMX/N3PUuKzbGWWn
         AG5O2bObc59Hqs6LWykQGImbuDHcyLBW5BZzxw4ld4VQKUgIvdtB7S45eTtj/C8rCgtn
         fw0A==
X-Gm-Message-State: AOAM531oHFO+mjPXMtBGM42bLEHJEASJqbph6FZzLK5UyzG9vXjqn/Im
        5vEATv70aub5fYe/g9Mhhm0=
X-Google-Smtp-Source: ABdhPJztpMnKiv4bBhhWOYLtA3WDNf8eIN548lT8sM5FfpAtQ/ZSHDLY/wTkPR3uV0xBLykUlOGZ/g==
X-Received: by 2002:a05:6000:c:: with SMTP id h12mr7103291wrx.378.1634223726992;
        Thu, 14 Oct 2021 08:02:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm2738065wro.25.2021.10.14.08.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:02:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4] trace-cmd: Align guest TSC calculation with the kernel
Date:   Thu, 14 Oct 2021 18:02:00 +0300
Message-Id: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The formula for calculating guest TSC clock, used in the kernel is:
 guest_tsc = tsc-offset + (host_tsc * tsc-scaling-ratio) >> tsc-scaling-ratio-frac-bits
Current trace-cmd implementation does not take into account fraction
bits, when calculating guest clock offset in case of a clock scaling.
Additional logic is added, to use the same formula in trace-cmd. The changes
are backward compatible with trace-cmd 2.9.

The changes are not tested with a kernel that has guest clock scaling enabled.
The goal of the patch set is to extend the time sync option, saved in the
guest trace.dat file, with all needed data used in the kernel for guest TSC
calculations.

v2 changes:
 - Use strcmp() instead of strncmp() when searching for KVM debug files.
 - Added more comments.
 - Code clean ups.

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd library: Do not use strncmp() when searching for KVM debug
    files
  trace-cmd library: Extend host-guest time sync with fraction bits
  trace-cmd library: Read and use fraction bits from
    TRACECMD_OPTION_TIME_SHIFT
  trace-cmd: Dump fraction bits from TRACECMD_OPTION_TIME_SHIFT

 .../include/private/trace-cmd-private.h       |   4 +-
 lib/trace-cmd/include/trace-tsync-local.h     |   7 +-
 lib/trace-cmd/trace-input.c                   |  79 +++++++-------
 lib/trace-cmd/trace-timesync-kvm.c            |  62 +++++++----
 lib/trace-cmd/trace-timesync-ptp.c            |   4 +-
 lib/trace-cmd/trace-timesync.c                |  55 ++++++++--
 tracecmd/trace-dump.c                         | 102 +++++++++++++-----
 7 files changed, 210 insertions(+), 103 deletions(-)

-- 
2.31.1

