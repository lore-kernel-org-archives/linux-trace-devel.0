Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B53C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49723613D6
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhEGJyg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhEGJyf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:54:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E21C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:53:35 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y26so9510797eds.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=knMOfYr5/9PuS5Z5SE4xqQWY9lGwpVyYWfiwYrs+kjE=;
        b=G8mytFsSrtoQcNTQeN1wu1gwtkrft9Ssl/MjUlmYNlknSIBX7PZGXPNr/5s0GYK/yG
         bxqqTCTFPhIWGkZqHqM88Kc2kNbKB32ZJWJXpy0OfEG4mcsNov5h7nRa9QBOp+inYViC
         kpWYQ5IIRYu2yxc+wpIQQXwiLKoHpwGrISpFRbQaYz+q7awwz5uUuwLGlihnKW1b0Uh2
         uYIPJGvyHB7Ju2HOGUA4v8dZGzxG2SK9zKML7foVdj770gm2/lgE5EkW5EwsEsDarrjq
         2NHBi1LZQcgOoM4+WR9R/zTL09Lnp4n3/UVuKQ/9BImz33DgisOL3O49OdXJikTCqaSv
         qGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=knMOfYr5/9PuS5Z5SE4xqQWY9lGwpVyYWfiwYrs+kjE=;
        b=GvDVMPZjCj0ty/YVg12fL8nE9T05UlSxLNMTF/h0a5YCbbAiO29QgfaRZFPGT17SpN
         WvjuRqfvX1ls6aUgqh91mPWOsm4dqGTyRtmiqUZ7+CBhdr/FI3/S5jmdfVx6Kl3RWjDe
         fj12z6tlTv+bbj1OnlH7giBeXoKIGWIe4dT9GKYx34z0nGY4bQKMgrnU+V/ZippNEOmw
         8kFl4SDduUXgdHGKwLeGAxVmjQErqJrEPlTcmWjuu406026ymEkJ7JvxUjJUvhdqRmkX
         FEXqYrVISfhKPg/FVzk8kIBtT7lGNTMvMk6VBcLqmTq//2DsawEdiL21j1+VjKxkIzlk
         qtRA==
X-Gm-Message-State: AOAM532NjjA1VazoE87XuU78DQvHvER2I4QjlNJNck8g45pM0I8sGIi3
        JTpGYQj96aozgGCGF4d86FO23mrPMOvbtw==
X-Google-Smtp-Source: ABdhPJypd7Ss+do7tG4x89hmLUu99MZBEwkCp9+RDJ0G+1rDcWmjJgto+eX91LAzh76UB4ZELJCDgg==
X-Received: by 2002:a05:6402:31a7:: with SMTP id dj7mr10167135edb.314.1620381214598;
        Fri, 07 May 2021 02:53:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id cr21sm3105812ejc.2.2021.05.07.02.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:53:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/8] Changes to trace-cmd logs
Date:   Fri,  7 May 2021 12:53:25 +0300
Message-Id: <20210507095333.1080910-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Recently changes in traceevent and tracefs libraries were introduced: log
levels and new APIs to modify them. As trace-cmd library uses traceevent
and tracefs libraries, those changes affect trace-cmd as well.

These changes depend on:
"[PATCH v2 0/3] Add API to set severity to tracefs library logs"
https://lore.kernel.org/linux-trace-devel/20210507095154.1080202-1-tz.stoyanov@gmail.com/

v2 changes:
  - Add a parameter to tep_vprint() for errno printing, insted of using the log
    level.

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd library: Use tep_vprint() for logs
  trace-cmd library: Add tracecmd_info() log function
  trace-cmd library: Add log levels
  trace-cmd library: Document the API for log levels
  trace-cmd library: Renamed tracecmd_fatal() to tracecmd_critical()
  trace-cmd library: Set debug log level in debug mode
  trace-cmd report: Set the log level with -V and -q options
  trace-cmd: Add new function to set log level

 Documentation/libtracecmd/libtracecmd-log.txt | 78 +++++++++++++++++++
 Documentation/libtracecmd/libtracecmd.txt     |  3 +
 include/trace-cmd/trace-cmd.h                 |  2 +
 lib/trace-cmd/include/trace-cmd-local.h       |  4 +-
 lib/trace-cmd/trace-input.c                   | 14 ++--
 lib/trace-cmd/trace-plugin.c                  |  2 +-
 lib/trace-cmd/trace-util.c                    | 47 +++++++++--
 python/ctracecmd.i                            | 13 +---
 tracecmd/include/trace-local.h                |  2 +
 tracecmd/trace-cmd.c                          | 55 +++++++++----
 tracecmd/trace-read.c                         |  2 +
 tracecmd/trace-record.c                       | 14 ++++
 12 files changed, 194 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/libtracecmd/libtracecmd-log.txt

-- 
2.31.1

