Return-Path: <SRS0=2N9E=BG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C9AC433E8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C4920672
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jJCxGWDI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgG0HS2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 03:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0HS1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 03:18:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F78C0619D2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:27 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 9so13121586wmj.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cm0dCN0FuaglTuhTtIbwh7Tzh1uTZb7qr7FlaTYPD1I=;
        b=jJCxGWDIrGP3iyaDiafayFMCSEY9FgRIX883yJb/waBiEkA5pCZ0FZv9uxyzxJZOZO
         Nwa1XYp2093dOjEtFJ1xGoUVp5KKynVVUaHHbHFzMDu1wzzO6mjDCJ2LxIKiMsjtdgAD
         EGNuMC9QEdjaBmmiECh14eA3ItLpSncaDvWafIJozmNdvJv4/dXhZALqIHRFLFfXy9e+
         AmkCYhaaIFlRKoSPEFgT6MV825kB3/cBac2qLHx2kPO3l2BgC6rZeXJKcBAj9kxMIwiG
         oeI3GWQfFsCd/vedxEh4ql4SBWDze6mARK9TVhmtn1eNoowXzYBiq/iNZtg9VuEclzLU
         3Z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cm0dCN0FuaglTuhTtIbwh7Tzh1uTZb7qr7FlaTYPD1I=;
        b=T4yeUTSNhsQT5bES8TVDjXvv5EqesEBO6oZN6NOEqxlDvM6lG8mqE5Dn1MQ22xJiG8
         klRjl1d5psZAI/WLRNaOxSUu9znOB5mUBg+G0W2cvnoQ23b1CaX+55joWQnURq2ZhLpz
         6LHlUrEm0IgDFd+wZt/W6D0NS/m4CCbS91LMvs0uVopnjzIact+c/4/MZ1/EcYn0npRZ
         Eg5jc9CoRPm2mwJvw06nM85HdWtd3832HMNFvUN1LwBL57H8tU1ECZKuZpV4WSNZc0Rg
         XkDYg41319bvFtdXuPF8bIvMIsqrQ/f8m+wYg8o9oeOhXuHWQaDZG6SCHMyjPnt5r54u
         iXHw==
X-Gm-Message-State: AOAM533vY6Fb1rjJDdB8sgpsoMSc4JgdHVH9FMx+0reQGu5rXaCXoq32
        x4nibJb2MCunlfP+Eb5K8larAT8ei7M=
X-Google-Smtp-Source: ABdhPJxCvQbzVqT5QfpQnVERjN1GBqWrVw2YyMAb6h3bOcgvEAJeLmiOTI6bktGUb7Ewc0NumHwSdg==
X-Received: by 2002:a1c:ed0b:: with SMTP id l11mr18942290wmh.121.1595834306272;
        Mon, 27 Jul 2020 00:18:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j24sm12312162wrb.49.2020.07.27.00.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 00:18:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] Add support for opening trace.dat files with multuiple buffers
Date:   Mon, 27 Jul 2020 10:18:18 +0300
Message-Id: <20200727071823.169962-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>

Ftrace supports parallel tracing in isolated ring buffers. Trace-cmd
also supprts this ftrace functionality, it saves the data from all
buffers into single trace.dat file. When such file is opened by
KernelShark, it loads the tracing data only from the top biffer.
Support for loading data from all buffers, located in a single trace.dat
file, is added. Each buffer is loaded as different KernelShark session.

Tzvetomir (VMware)  Stoyanov (5):
  KernelShark: Add stream name
  KernelShark: Fix compilation issues on  Fedora 32
  KernelShark: Fix combo plot plugin crash in case of multiple streams
  KernelShark: Load trace.dat file with ftrace sub-buffers
  KernelShark: New libkshark API for loading all entries from given file

 src/KsAdvFilteringDialog.cpp   |   2 +-
 src/KsPlotTools.cpp            |   1 +
 src/KsPlotTools.hpp            |   1 +
 src/KsUtils.cpp                |   4 +-
 src/KsUtils.hpp                |   4 +-
 src/KsWidgetsLib.cpp           |   6 +-
 src/libkshark-plugin.c         |   2 +-
 src/libkshark-tepdata.c        | 122 +++++++++++++++++++++++++--------
 src/libkshark.c                |  38 ++++++++--
 src/libkshark.h                |   6 ++
 src/plugins/KVMCombo.cpp       |  11 ++-
 src/plugins/event_field_plot.c |   2 +-
 src/plugins/latency_plot.c     |   4 +-
 13 files changed, 153 insertions(+), 50 deletions(-)

-- 
2.26.2

