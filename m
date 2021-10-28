Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F77C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DE8260F90
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhJ1MLj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhJ1MLi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:38 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D867FC061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:11 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s1so23918603edd.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K1M2+AuSgIw+s1ScfPI9BoLT6TacZCOs4ZsM9bz37tI=;
        b=nTC4x4FXEjzq/ljf7CJVCXavUm0UYGr29zqDQcQmNDMNzYEQ+0WDMKNSqVscbdBOIp
         UqTkKcYhpJN3tBzC/U/EI5i/P+hZzLvWfDwvWCDaGMm6KMEOqktYZpivseyy9GqBaGlF
         BSRy81gaUmyps2vRo8rT+883w3eedg5/4c5fNL1stB+Bcf+PrD1sfrrhndweUAXlaKvo
         fRXyI894Gdj0ymNSX57l51jiOngX7AVcSwDrxr1IwTG9o1ZD2KfX4N2CVeTiHLV6lK4k
         0gnc0uGCo9FlR8Blgjwt3YBIBW9mD3JqJkMdXjKdwYBDedvtDuITBbdjiMi6rTSDZCUb
         Rrcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K1M2+AuSgIw+s1ScfPI9BoLT6TacZCOs4ZsM9bz37tI=;
        b=Mk3ssn0uNgR8Xxv86a2p+B30LZ7Uh5/24yF6Lcu5z8jkg0h7KfwvKThxrIUJUQv3jz
         BvfbD3NwnicLlWoAsK5h9tNApgAm6qqrrzKAjX24ga2rGX2qkQgG6fV+JWUkNGVz6aUa
         vEsIAY1rvk00U/L2NKNhAJcQuAUzOjqLz3J/nvhRXxpvS761vskVvrJyAbpz7FfvT9pr
         4zap3VU4HnmVDdwhzQ5Uo/Ysha81rjpyAYZQKPR1BMonDWBwmTNqsMALiHvLnTKkIZZi
         PqIb2DcX+0eK/vPfuQyugFNVNHbX3V34MW6HAAdGL0HhVXBdmQJY7PPdwz07ma1fTEDt
         cwcQ==
X-Gm-Message-State: AOAM533gYsf2S9Ls6AOWxc+wYzJ3CNrpV4YtLfGezNl61FC+vDB2iz62
        OpwHyQN6oVN+8ciQ6VdYEg8=
X-Google-Smtp-Source: ABdhPJxkm+/acdaGMKx0sz8A81hmLHaiExFZRUkqFMjE0h7RNo/1unPWmFYM5kiPwP9EdYpcAL83yw==
X-Received: by 2002:a17:906:64a:: with SMTP id t10mr5119221ejb.5.1635422950188;
        Thu, 28 Oct 2021 05:09:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/12] libtracefs dynamic events support
Date:   Thu, 28 Oct 2021 15:08:55 +0300
Message-Id: <20211028120907.101847-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs logic that works with ftrace dynamic events is unified and
capsulated into internal APIs. This change makes the code more consistent
and reusable. Also, adding future libtracefs support for uprobes and
eprobes dynamic events is simplified.
The existing library APIs for kprobes and synthetic events are reimplemented
using the new dynamic events helpers.

Tzvetomir Stoyanov (VMware) (12):
  libtracefs: Add new internal APIs for dynamic events
  libtracefs: Rename tracefs_get_kprobes API
  libtracefs: New kprobes APIs
  libtracefs: Remove redundant kprobes APIs
  libtracefs: Reimplement tracefs_kprobes_get API
  libtracefs: Change tracefs_kprobe_info API
  libtracefs: Reimplement kprobe raw APIs
  libtracefs: Extend kprobes unit test
  libtracefs: Update kprobes man pages
  libtracefs: Rename tracefs_synth_init API
  libtracefs: Use the internal dynamic events API when creating
    synthetic events
  libtracefs: Document tracefs_dynevent_list_free() API

 Documentation/libtracefs-kprobes.txt | 135 ++++---
 Documentation/libtracefs-synth.txt   |  20 +-
 Documentation/libtracefs-synth2.txt  |  10 +-
 Documentation/libtracefs-utils.txt   |   6 +-
 include/tracefs-local.h              |  34 ++
 include/tracefs.h                    |  38 +-
 src/Makefile                         |   1 +
 src/tracefs-dynevents.c              | 463 ++++++++++++++++++++++++
 src/tracefs-hist.c                   | 110 +++---
 src/tracefs-kprobes.c                | 523 +++++++++++++--------------
 src/tracefs-sqlhist.c                |   6 +-
 utest/tracefs-utest.c                | 414 ++++++++++++---------
 12 files changed, 1169 insertions(+), 591 deletions(-)
 create mode 100644 src/tracefs-dynevents.c

-- 
2.31.1

