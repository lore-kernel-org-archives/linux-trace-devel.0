Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A904C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352525AbiASIeR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352524AbiASIeR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:34:17 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE312C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:34:16 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id j2so7618204edj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UY2OErqmuvLfMCnI94DmeB3XIGko+hRsbYbLsapuVAM=;
        b=hYBCMQr0RkeJqMh+GlFpgRjIjONCSikMY213QSH608SUFNfDi184DWv8Izjn5LfYVP
         dcMV70iTulDPtUb4jS8w+Tzlr9BBJWwZSGinec8ksu56CTjbuRQhRl805yAjCSa1Cl7B
         luJT37VZtaIQTZsEj4Q1EQ9G5b/jRELiMMnpya3w4dyozz12RaYifKzSLzdOF0wLtQhk
         1FzGle6ha8PlQG6OgxiXlTfMjSkKytuvyKuV0M3WOQEIotuWCVTobJeIxwPbyqHwjVKN
         iyTA0O/BRCAcbWWLeKXXluaXbLo1bMD4F5QpZwgC0f5s2K4B3e/QBVThWVKgVuJUcVg2
         Gagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UY2OErqmuvLfMCnI94DmeB3XIGko+hRsbYbLsapuVAM=;
        b=n3xTYttK2spcqP5dJUDR9MGb4SzRnOg2wEue0BIO/QuQaFGYV7I88v3eq92vszXnVo
         hpkugBZ2EJquUvBuQTKKGmhrFLAz8gma3uqtK4Dv90lmaNRuRWTRA1kiZXie3v+XGrQK
         E3Rd3oqv63iBB4EGumxCdCwpSSUsVQCMteriTtSUt65Cqcn97DEkhiT/NsUtl/xyJADu
         HD3JdgV6MjZJEUEQvD/qPj8GruIusOePg5UfeVD8WY1L3uqe+TmZcG/3STnp8xVbUfC5
         xWURXNxm5/TBCrywFss5bvB8+Te6hZM+1zKnYZR+6qdkgmh6A6LBM5d2jWxv9pP4tJtG
         86ZA==
X-Gm-Message-State: AOAM5339ud3lOyRJALxS2tgHoNGGE1H3ecFWNnbLz40Nz0VwDHja/N92
        CaIA9vbi7f/lE3Qb/HJ22WsgabsBkpg=
X-Google-Smtp-Source: ABdhPJwkJzT4nwwXiC8qTA288X41yqg2vzhyFCBUukeB/X6E4vyiMD+Zq18mUjfls5VPmR4s2DpxwQ==
X-Received: by 2002:a50:fb09:: with SMTP id d9mr1324967edq.300.1642581255350;
        Wed, 19 Jan 2022 00:34:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 10sm6177380ejy.174.2022.01.19.00.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:34:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 0/2] Get trace buffer page size from kernel
Date:   Wed, 19 Jan 2022 10:34:11 +0200
Message-Id: <20220119083413.246539-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace buffer page size is equal to the system memory page size in
the current ftrace implementation, but this may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

This patch set depends on:
 "[PATCH v7 0/4] trace-cmd documentation update for v7 files"
 https://lore.kernel.org/linux-trace-devel/20220119083219.246347-1-tz.stoyanov@gmail.com/

v5 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
v4 changes
 - Rebased on top of the latest master.
v3 changes
 - Rebased on top of the latest master.
v2 changes:
 - libtraceevent API is renamed, use the new version.
 - Rewrote get_trace_page_size() to use libtracefs APIs.
 - Cleanups in "trace-cmd dump" output, related to buffer page size print.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd library: Use the real trace buffer page size
  trace-cmd library: Introduce buffer page size per instance

 .../trace-cmd/trace-cmd.dat.v7.5.txt          |  1 +
 lib/trace-cmd/include/trace-cmd-local.h       |  4 +-
 lib/trace-cmd/trace-input.c                   | 11 ++-
 lib/trace-cmd/trace-output.c                  | 74 +++++++++++++++----
 tracecmd/trace-dump.c                         |  9 ++-
 5 files changed, 79 insertions(+), 20 deletions(-)

-- 
2.34.1

