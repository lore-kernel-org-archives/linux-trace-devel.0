Return-Path: <SRS0=0H5Y=CZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298C2C433E2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 20:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B2721655
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Sep 2020 20:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o3P3m43t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbgIPReW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 13:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbgIPRdp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:33:45 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732A2C0698DA
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Sep 2020 04:47:12 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x23so2456236wmi.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Sep 2020 04:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o0i+CTX/ECXues9JiO+xI6budck4V25k3Bpuwl4u1MM=;
        b=o3P3m43tJuAq8LpYicVU76J6XJJST2/Dnv0HJxyjR08LYFePktGSIBvRxNtwbt7e+7
         3qusT7waD93RI9LkPK6FPeUazwEdS1AH8bjEesY54+M2PVmLX2uYFmc4Drw+dqM1nLhT
         kSHaY9fB6N1JS2uvClyQEShqfmIxnxUlBHcl2WrPK9D9y/4PCB2xrT7SR46bpL4P4k/X
         twfcvhKNCuYzyEi/g88SQ4Y6ymUG9oZ7OCFBjdSC7kqxHVVLVMSIhYN4z14nl7aqRBnY
         EDoHpPJkCuhtmvjm/bACwVawzv5sXlo9+Dg03L8znoqXXnAbfSFyotSlJYkXnZ8CmZPF
         O2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o0i+CTX/ECXues9JiO+xI6budck4V25k3Bpuwl4u1MM=;
        b=qqPt6AZbMo1Cs+7BDEDF9jfNpURlFB0ZyybKb1QHpJ6XXnwVZY6lg6GOPN1A75qmKw
         AnNdXXXL2c5S8VSRTJxwhs5ACE6Xvd1ZIHD1bVkgzuv+NCPx9yp3wfV/UItLh/poCO8U
         +eFBR12vlwvs9jFg0W8NGuBgvCN80zVjq5Dk8hG9YygOQyGCvoizXPkvLOkhaBBXRgwW
         I1ui8iuc5Z9V2VPXQ2g9QsCa9Zf6QcCDwYRvinVOua2YZR/mZUERsbvgU+ov9D2o8BP2
         y7Q+ttjywkDZlLIATvWauq3fIG7379PTXkJ3KGl1eOKa1iqwRgseDQnHem0q6o2zIR+Y
         Kw2Q==
X-Gm-Message-State: AOAM532pfQTJQm8ejBNoU1a1s8NOvnLxbCS2PHQPDL5SbQ5FfGQlha9x
        7MgEbHRaGegNQB8lxOtPHH6+BTpaYa/ahw==
X-Google-Smtp-Source: ABdhPJwjwhQauBnKUj1d8NxCBo2p7i+TWwtwEz3iejMbKphe+O0i9KapZBdO4Qdm7CB0GXoYiI+C9g==
X-Received: by 2002:a7b:c4d1:: with SMTP id g17mr4133001wmk.167.1600256831178;
        Wed, 16 Sep 2020 04:47:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z13sm32042040wro.97.2020.09.16.04.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 04:47:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] Initial trace-cmd support for ftrace uprobes
Date:   Wed, 16 Sep 2020 14:47:06 +0300
Message-Id: <20200916114709.291533-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace supports uprobes - trace events on user space applications.
Trace-cmd cannot configure uprobes, in order to support it this new
functionality is introduced: 
 - Function name to file offset mapping, this information is extracted
  from the dwarf and ELF headers in the binary file.
 - New options are added to "trace-cmd record" for setting a uprobe:
    --uprobe file:function
    --uprobe-ret file:function

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Internal refactoring of pid address map logic
  trace-cmd: New internal APIs for reading ELF header
  trace-cmd: [POC] Add support for uprobes

 Makefile                       |  10 +
 include/trace-cmd/trace-cmd.h  |   9 +
 tracecmd/Makefile              |   2 +
 tracecmd/include/trace-local.h |  49 +-
 tracecmd/trace-obj-debug.c     | 823 +++++++++++++++++++++++++++++++++
 tracecmd/trace-record.c        | 193 ++++----
 tracecmd/trace-uprobes.c       | 221 +++++++++
 tracecmd/trace-usage.c         |   4 +
 8 files changed, 1197 insertions(+), 114 deletions(-)
 create mode 100644 tracecmd/trace-obj-debug.c
 create mode 100644 tracecmd/trace-uprobes.c

-- 
2.26.2

