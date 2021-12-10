Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13AEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbhLJLG2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhLJLG1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:06:27 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE78C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:02:52 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id o20so29030994eds.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsTqPUE0KzEnAmp8gBjGNmaGLeoxYBftRNPckDNLLo4=;
        b=k1uzPe0h/RBvrTnQMTJsG0Cq7F7rlxeNnhh9zxotffrahQcvl3kVoK3HWj9UAjYfJq
         nNVHQs1BZf9YEbIDw0foLVUYyDjuv1h/91Tbju/iygWfekvFqC/6JTPEuEZoYtz0Ozjc
         kTgyPW5UwJGMf+wbtvA182Wq/QgnHr5TlBNpLY4OGSAfGSsw5cAHiUr5WllHds+IKNqm
         +5DJew3fhWrgSrOVfrMtzpIg+UcjoQTsOCePRSYmk/p4KSYjqMx6fy4h7dLXHp2QdjWd
         u9cTWcPT27jdnN/myuOA/evcMl5HerfS2mHpEtPvC5vTkDFgn7W17suvp9ezyQfFlxkn
         xwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsTqPUE0KzEnAmp8gBjGNmaGLeoxYBftRNPckDNLLo4=;
        b=z5M0hUhNld4bLJRvdmAnv9XMd3RKEnj4dagps5MNQA2U0PlefThdqiL3oC7+OCwbLM
         he6ZxynE/ekywDoLo1mhaKR8dy1BLrXRzKEQNApjTgGzKqQA1o0/MJiiw9A7Wr2WQ1If
         L9EDpxIJYjD2AbeBfV5hBYMnjyPvH7d+w4K1JAW6BLSIu32oVAgfnz0DmLt5mElPc5AS
         r/yIj6GmA6RjHDj65Tme8jCtvJGuy3f3APrQfe3rHZRnHMyUK4fC0zSkfVVS7FKo13lb
         Y4O0Zt/6+YjnrsRKtOs/85OUTHMX/zvYL+Vlc+PbMj4P1CpDx26aB4+wiIG/ftGaLoDJ
         ra9A==
X-Gm-Message-State: AOAM530ID7tdRErWL3e+0E1DfGTppvBdMY4Gj/oIjmc1aBg0vChrSCiu
        YfdJk6Kw5emgEIZGxTNuMAs=
X-Google-Smtp-Source: ABdhPJySoRdTw0hc8z//4pxa5XY0MDrTy5QvKdamVpAttCsp3Yhp8GAviYJnn5LJSMfSS1At9OXT5A==
X-Received: by 2002:a05:6402:51d3:: with SMTP id r19mr37511972edd.271.1639134171063;
        Fri, 10 Dec 2021 03:02:51 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg39sm1275269ejc.66.2021.12.10.03.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:02:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 0/9] trace-cmd convert
Date:   Fri, 10 Dec 2021 13:02:40 +0200
Message-Id: <20211210110249.98583-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new trace-cmd subcommand is introduced:
 trace-cmd convert -i <input file> -o <output file>
The command converts trace file between different versions. There are two
parameters for controlling the type of the output file:
 --file-version < 6 / 7>
 --compression < none / any / name of the desired compression algorithm >

This patch-set depends on:
 "[PATCH v6 00/20] Trace file version 7 - compression"
 https://lore.kernel.org/linux-trace-devel/20211210105938.98250-1-tz.stoyanov@gmail.com/
 
v6 changes:
 - Rebased on top of the latest master.
 - Introduced new metadata strings section.
 - Use 8 bytes for section size.
v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
- Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (9):
  trace-cmd library: Use output handler when copying data from input
    file
  trace-cmd library: Handle version 7 files when copying headers between
    files
  trace-cmd library: Copy CPU count between trace files
  trace-cmd library: New API to copy buffer description between trace
    files
  trace-cmd library: New API to copy options between trace files
  trace-cmd library: New API to copy trace data between trace files
  trace-cmd library: Avoid memory leak when setting trace clock
  trace-cmd library: Extend tracecmd_copy() API
  trace-cmd: Add new subcommand "convert"

 .../include/private/trace-cmd-private.h       |  15 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  13 +
 lib/trace-cmd/trace-input.c                   | 698 +++++++++++++++---
 lib/trace-cmd/trace-output.c                  | 125 +++-
 lib/trace-cmd/trace-util.c                    |   8 +-
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-convert.c                      | 106 +++
 tracecmd/trace-restore.c                      |   2 +-
 tracecmd/trace-split.c                        |   2 +-
 tracecmd/trace-usage.c                        |  13 +
 12 files changed, 881 insertions(+), 105 deletions(-)
 create mode 100644 tracecmd/trace-convert.c

-- 
2.33.1

