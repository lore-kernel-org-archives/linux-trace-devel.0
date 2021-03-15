Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198FEC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E315264E46
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhCOGS6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhCOGSh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:37 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AF5C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:36 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ci14so64047743ejc.7
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LjZKMCNAOLyrEL9+3T30f39dgJ5/eW+1mlRZOvw+Fo=;
        b=lkP5tW5PMr76IqJtc1wbgRasfp4DKejroGQzk6SM8mFeJZDsl8SDfW1zABe5ShUlYH
         uNRX4MKekpgdU3+IsEeCBoOc2BAO3lAp5p+/rzMc9NwYYWK2SwQThLxl8K01qjTK2e/6
         OyRQmxFVy5S2rxrkJWkTamublsGEqsAU0Imm0rWgfcFpD7oJfIThmdLV1DI9GnxYSJ7P
         1jRgR7bCmstqcX0QW+aAow6LSI+nMNHwbjIYWrYRnXFn3VsLdODhdZtjWIGwG3eEU7IJ
         91bReA9LBs4cfwMVyjDdT2NLKE6aLNJdPm8Md0wW46UqEs/tscjcDdm+x80GA+KEGqLi
         /PrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LjZKMCNAOLyrEL9+3T30f39dgJ5/eW+1mlRZOvw+Fo=;
        b=hVa22HKJJeMjC1JpervJNcr0CSVcf5QRoxebNzKKjYwlz4awHIypa6yZNQbcoCYMLi
         24gBlObyoPGDAl1/XJF241WzU+a1SWJMqe6em7wNEzQFd9OFwmwzHpqkd40aV4GvkjBm
         4pqHEhso2mnF+wcvVW/JZc0zzEyyl9u3msbHnBkj768fct6PDfxeeZyWgS8OmM6AblXn
         QZpfJ1Jj/V/66+lTaGVZjGfXpBC1d9WHk0hF9wldpB9fVQCtv1kvH3tt8Ht5PCkFH6zY
         7dmn1mKYXXOAxtYbD2Vu3m9IXMStOBXR5TjIjMPwv5xpgrc8uoEQr2P0VSx3LyD+XG9E
         Yr/g==
X-Gm-Message-State: AOAM5316YQkMXK1gK98oFqYOU745+sBo8CmAN5KQYENE3BpgmCKpDzYK
        1esNJa7f/us6LQZwE034Zgg=
X-Google-Smtp-Source: ABdhPJw0GS8qySEBPYJkUIXspbTHguYKonRnm9/qeF1pRVJQa7gjB1R9qBoiDUqDZfNb7MB5qbELqA==
X-Received: by 2002:a17:906:5849:: with SMTP id h9mr22068516ejs.551.1615789115476;
        Sun, 14 Mar 2021 23:18:35 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/12] TSC trace clock to nanosecond conversion
Date:   Mon, 15 Mar 2021 08:18:20 +0200
Message-Id: <20210315061832.168495-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new logic for converting TSC event's timestamps to nanoseconds. This
trace clock is used by default in host-guest tracing session in combination
with KVM time sync plugin. The parameters for conversion are retrieved by
the perf kernel interface.
New option is added to "trace-cmd report" command to force displaying raw
time stamps from the trace file, without any corrections to the time stamps.

These changes depend on "Refactoring and improvements of time sync logic"
patch set.

Tzvetomir Stoyanov (VMware) (12):
  trace-cmd: Add initial perf interface in trace-cmd library
  trace-cmd: Add logic for TSC to nanosecond conversion
  trace-cmd: Append new options into guest trace file at the end of the
    tracing session
  trace-cmd: Add a new option in trace file metadata for tsc2nsec
    conversion
  trace-cmd: Save information for tsc to nanoseconds conversion in trace
    file
  trace-cmd: Read information for tsc to nanoseconds conversion from
    trace file
  trace-cmd: Remove unneeded multiply in events timestamp reading
  trace-cmd: Perform all timestamp corrections in a single function
  trace-cmd: Convert tsc timestamps to nanosecods when reading trace
    data from a file
  trace-cmd: Set order and priorities when applying timestamp
    corrections
  trace-cmd: Add a new flag to disable any timestamp corrections
  trace-cmd: Add new parameter "--raw-ts" to "trace-cmd report" command

 lib/trace-cmd/Makefile                        |   1 +
 .../include/private/trace-cmd-private.h       |  16 ++
 lib/trace-cmd/trace-input.c                   |  96 ++++++++---
 lib/trace-cmd/trace-perf.c                    | 105 ++++++++++++
 lib/trace-cmd/trace-timesync.c                |   1 -
 tracecmd/include/trace-local.h                |   7 +
 tracecmd/trace-dump.c                         |  18 ++
 tracecmd/trace-read.c                         |   9 +-
 tracecmd/trace-record.c                       | 155 +++++++++++++++---
 9 files changed, 358 insertions(+), 50 deletions(-)
 create mode 100644 lib/trace-cmd/trace-perf.c

-- 
2.29.2

