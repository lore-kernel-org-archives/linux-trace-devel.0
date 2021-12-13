Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC03C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Dec 2021 10:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbhLMKAe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 05:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbhLMJ60 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 04:58:26 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2506CC08EB1E
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 01:48:29 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x10so32680496edd.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 01:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y3llglAG/QBXlrOohy7DNl8rTplFFww+TbNuCuMvTd0=;
        b=Npyycw5JR9w1RNItcq9OkY11SGl2ExEpQ1fFAnGMC8Dprct8W6VyvvSkStNCkF3hAg
         KFaNMnKULvo0ZyhN7FE9bVkt1frOcaGUwXGgR1FrluzP1/TEFnqczZtQVfGXvHeCLL6A
         ItlUi+Pty1rK84i7c0TdmuKhie8BZ2dPY7/CcsaMHYgwCCMcQVBd5XqtbHFSBxpoWoGb
         EoIXKTVGPLJrxGgvHl3F7JgHXbhi1ZSlikUHMIizxWUTOBQGYnbo8KBk0g1+6FXcC/d5
         Fp/9nqVxoehUXrB3lvKF2l2BPwStG6DRyJ7+zppSwk6quzZIg9hwyXRy1FvsoOVYaJUJ
         SlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y3llglAG/QBXlrOohy7DNl8rTplFFww+TbNuCuMvTd0=;
        b=cyOLZvGQz+FFvKGcAeQNx7N39DMYqRAWJkIc1FwVTXeN47OBU1YtPDVJYPXTyf86kC
         tFOrJtRRdpggYdFYKGUKNiCZDBXE1ABadgXG0q2q+czLv4F3z+pBLMELMn95WfQxoks8
         o/tnI1/D5otpv9J48BE2/tKnLzow5oa1+KgibFIQaWl/V6b8MCyNeKsHs3ixR8aFdMOY
         5Tc4oT4gLpk2RFUlQfWELeX5FnNf4qRAnMY12b5v55A8r7lgeNwaJWlW/MictociWj8s
         V+2VvoB9aYkRn26NbKTMnUqGqojRh1yUpI4SK6IxFwooBl4VujKj/Hyd/kMkHE+IOEUg
         7Hog==
X-Gm-Message-State: AOAM5313P9pd1RMTVWByVe4OBbJax7icnaJZUKdjBELo6Of77/TYBb/J
        zA2B8KhnjYwDlvLtkOiaWNm3H05C9jc=
X-Google-Smtp-Source: ABdhPJwNn2NwMVP+mjkgJY76QqE0qyXhm08P6w1v864QFUdAeVP6QWBkTqnzqFCKpnVrHSYef529sw==
X-Received: by 2002:a17:907:d89:: with SMTP id go9mr43407569ejc.330.1639388907734;
        Mon, 13 Dec 2021 01:48:27 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id yd20sm5465748ejb.47.2021.12.13.01.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 01:48:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/5] tracing: Introduce configurable ring sub buffer size
Date:   Mon, 13 Dec 2021 11:48:20 +0200
Message-Id: <20211213094825.61876-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tstoyanov@vmware.com>

Currently the size of one sub buffer page is global for all buffers and it
is hard coded to one system page. The patch set introduces configurable
ring buffer sub page size, per ring buffer. A new user space interface is
introduced, which allows to change the sub page size of the ftrace buffer, per
ftrace instance.

v4 changes:
 - Do not change the sub buffer size of the temp event buffer per CPU,
   trace_buffered_event. That size if fixed to one system page.
v3 changes:
 - Fixed ring buffer readers and writers to work with custom sub buffer page
   size.
v2 changes:
 - Split code refactoring in a separate patch.
 - Changed the logic to work with order of system pages, instead of page
   size.
 - Fix freeing of the allocated pages, to take into account the actual order.
 - Code clean ups.
 - Bug fixes.

Tzvetomir Stoyanov (VMware) (5):
  [RFC] tracing: Refactor ring buffer implementation
  [RFC] tracing: Page size per ring buffer
  [RFC] tracing: Add interface for configuring trace sub buffer size
  [RFC] tracing: Set new size of the ring buffer sub page
  [RFC] tracing: Read and write to ring buffers with custom sub buffer
    size

 include/linux/ring_buffer.h          |  17 +-
 kernel/trace/ring_buffer.c           | 345 ++++++++++++++++++++-------
 kernel/trace/ring_buffer_benchmark.c |  10 +-
 kernel/trace/trace.c                 |  84 +++++--
 kernel/trace/trace.h                 |   1 +
 kernel/trace/trace_events.c          |  50 +++-
 6 files changed, 392 insertions(+), 115 deletions(-)

-- 
2.31.1

