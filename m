Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBF5C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B421722E03
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390266AbhALJVJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390583AbhALJVJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 04:21:09 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C9DC061786
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:28 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id t16so2428704ejf.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W8Secle2yeigFS/ZYnsO78bP6d9eRjf2xewENBCjsr0=;
        b=hXIgtshn5IDhVXAC7GqWLLukAgLzP7brzlsebkznfMsgbfuG6+OeWtTZsaODzbwLzb
         OblD/KWMC9cA2IkuDPD/jPHp8Ia0ORX5GNYZYhNWhW5GArJkr3iTPTkxPOyS6UfbkY4Z
         n6CWUkB4qFz1rWEWmBEIniNCg9VRhmOGMQHvMXJawwni5AD32dovEoAjgRajrISIh2ss
         +d3pM/m+vpHXvcObMbAujqERjXMgqcymPF69t3Vy2Kfmt7SKU+Ky0NnVvEMvesWml6Qz
         xFFAmHgIpx8KCqtHq6+1NeXzKRebYhg0+WVC1VvWYs5RumCRCqh6KDfdBKBrc2NvZj/J
         U2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W8Secle2yeigFS/ZYnsO78bP6d9eRjf2xewENBCjsr0=;
        b=Iaopbizvd6tzHwkZbtoA5cZOkd0AmsZKwdok9+A9tg6sVGxq5SAtgdQJOhR8SKheKD
         ZJLe4rcmd3+vlNWYGmBu70nzRb9rGfn49g3xTB0GkgeV+AUCADLDiNRi8udyWKRSFMGV
         8u92Mb7vPjwcFocy/WE7KOpRqpF3BUhRuoXkTkcvb08X5f6buUu4YBS3sx5gYuClx9sm
         Pnnx/E+98T2hUgotdRSekRlKIYa3kPq9cMziGVs8auYnvmfUWHMjB5zMgNWeJXMFK/Y+
         GBD9tTRd4eFomJ4sA0LndyZoikHRySEUjK3q+tkJFi9+zh2mr/U8Sgy8zA4j+xpGO10C
         KMkw==
X-Gm-Message-State: AOAM533rxVWIDRJRNIcJhuJmqDNs1HwARp/hHlVDYvaJTIpzeebvRgEc
        NUVWePpY5OEYz4+/e2Z60B/+ZU62nxHBN5uZ
X-Google-Smtp-Source: ABdhPJwQfHHuMpjS0nTcNuoqCqa4bF0uWAVFwpSV5M3GjRSLKNhWa1cEtPfV03qDDisyJDi5JMOd+Q==
X-Received: by 2002:a17:906:7f0b:: with SMTP id d11mr2575320ejr.7.1610443227015;
        Tue, 12 Jan 2021 01:20:27 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rl7sm929187ejb.107.2021.01.12.01.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:20:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/7] New libtracefs APIs
Date:   Tue, 12 Jan 2021 11:20:17 +0200
Message-Id: <20210112092024.605705-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new APIs to tracefs library and updated man pages and unit tests:
  tracefs_instance_file_read_number();
  tracefs_instance_file_open();
  tracefs_trace_is_on();
  tracefs_trace_on();
  tracefs_trace_off();
  tracefs_trace_on_get_fd()p;
  tracefs_trace_on_fd();
  tracefs_trace_off_fd();

v2 changes:
 - Renamed tracefs_instance_file_read_int() to tracefs_instance_file_read_number().
 - Added new tracefs_trace_on_get_fd() API.
 - Better error checking of tracefs_instance_file_read_number() API.
 - A few code clean-ups, suggested by Steven.

Tzvetomir Stoyanov (VMware) (7):
  libtracefs: tracefs_instance_file_read() get a const file name
  libtracefs: New APIs for opening and reading ftrace files
  libtracefs: New APIs for enable / disable tracing
  libtracefs: Documentation for the new APIs for opening and reading
    ftrace files
  libtracefs: Documentation for enable / disable tracing APIs
  libtracefs: Unit tests for the new APIs for opening and reading ftrace
    files
  libtracefs: Unit tests for enable / disable tracing APIs

 Documentation/libtracefs-instances-files.txt |  47 +++++-
 Documentation/libtracefs-traceon.txt         | 151 +++++++++++++++++++
 Documentation/libtracefs.txt                 |  10 +-
 include/tracefs.h                            |  24 ++-
 src/Makefile                                 |   1 +
 src/tracefs-instance.c                       |  62 +++++++-
 src/tracefs-tools.c                          | 109 +++++++++++++
 utest/tracefs-utest.c                        | 137 ++++++++++++++++-
 8 files changed, 532 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/libtracefs-traceon.txt
 create mode 100644 src/tracefs-tools.c

-- 
2.29.2

