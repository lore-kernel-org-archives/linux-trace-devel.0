Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D29C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350490AbiASIaZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiASIaX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:23 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE150C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:22 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id c71so7645105edf.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NrrbYGtZCLwzotmbddvQFtKCpaXy/BNkMbwG+l1lZUw=;
        b=SBF5e5DiECznyjZtOmFArNdUrgafCKOnC+WkFzjxV39NiqwoJmbIMG2C/6faf68QNb
         KIRgMjkUQ1x9s1h61fV1T+YjCBH0B+YVdex442i06J2Nq3G5Ap7kOhN1zlstGlyrg0zc
         cdAA5BNwz4yVo9Y4IETTfzwHQbQok7ZunneAozjkHVfJlIJULa6hU4mPlssE8Jvz3XWS
         q+uDxr1MLL9PYmh/leuOB8u3jvOV3Ei/VvqOGExgXUs4coRAXQovDj9H1yMsveuC9V+V
         rxKmspIJ8RwAd6GFPs48xiVupoJsRDIJdkySMTyvkBQaJu2AHgSKvsIBgxKM28i4R1J7
         hsjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NrrbYGtZCLwzotmbddvQFtKCpaXy/BNkMbwG+l1lZUw=;
        b=D23WNL80fTQOj11khOaHdAKcheBVB8e5MxJKe9uPZMh3HxUvq8Lq3/sAXx6xYpfCKB
         oIL9iCpHibL1EHkJ8zV0xfSDMaIs7um13CM0rIR/jdqPBjvTl9PNK11CUCnunvPtaI4o
         uHF4Cl7d6kdWOoOpCSzdHdPPNexrXfW1sh2fp2htNrrUuobNUpB0aKE87LFkWV94tXKp
         pilvtpRya2orTCD6n4H2WAoUKdXVjlZoYUEkuLa3bLlb86mtjcJDw0d8I53gymxepU/7
         VAsk5pZZR7tFn3XlbKT2XlmNipti4hTkPPGBeYWgs18j4BfILdV9crsHxXNuU7KWu2PE
         WTGg==
X-Gm-Message-State: AOAM530xw5m/V00Z25NRguhTUbp5tY2yYlytrwSl4/JdFrmUSDO0tRev
        sqdrzB9xRcaoDbH/8Id7jYk=
X-Google-Smtp-Source: ABdhPJzTVBpnHPT1lrGtFzI+YcZ6YEcfPxnlSRYYlINyjhQ7tpbhVJtxL7z/ghVTvhYQqDfIIbvguw==
X-Received: by 2002:a17:907:2da1:: with SMTP id gt33mr23618150ejc.590.1642581021276;
        Wed, 19 Jan 2022 00:30:21 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:20 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 00/11] trace-cmd dump - v7 update
Date:   Wed, 19 Jan 2022 10:30:08 +0200
Message-Id: <20220119083019.246153-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the "trace-cmd dump" subcommand to work with trace files version 7.

This patch-set depends on:
 "[PATCH v7 0/9] trace-cmd convert"
 https://lore.kernel.org/linux-trace-devel/20220119082845.245993-1-tz.stoyanov@gmail.com/

v7 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.
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

Tzvetomir Stoyanov (VMware) (11):
  trace-cmd dump: Add helpers for processing trace file version 7
  trace-cmd dump: Print compression header
  trace-cmd dump: Add helpers for processing trace file sections
  trace-cmd dump: Read recursively all options sections
  trace-cmd dump: Read extended BUFFER option
  trace-cmd dump: Dump sections
  trace-cmd dump: Dump trace file version 7
  trace-cmd dump: Read strings sections from v7 trace files
  trace-cmd dump: Dump sections content
  trace-cmd dump: Add new argument --sections
  trace-cmd dump: Align better the output of flyrecord dump

 tracecmd/trace-dump.c | 549 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 504 insertions(+), 45 deletions(-)

-- 
2.34.1

