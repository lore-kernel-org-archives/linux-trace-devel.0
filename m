Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D62C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E787560F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbhJHE1I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhJHE1I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:27:08 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EAAC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:25:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v18so31580882edc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JMYyFm+OgGHjz9dSb/AXMCy1+rPjG8LlbhrPGzCJRoM=;
        b=Sbng5xAvcwdYRZoBBe+Ew/0+ZXOMgPXe0zCO1REbTBugTokKSujrnAUP9GRc183qwH
         +GhXR0uzdlMgrEke8+58cNsK1buYJvpot3xLo2IzyJUzCRE99sB/Qov+jWi0jiYG9YsU
         iGwdXty3uj3cR36AqARRmFP+x8O/HejZbh8xvhz/RBHnb9MEz1YZfqZhhlovlcbdPYVf
         onCDmlRDGaeMvgTjI70c/1/7sHLH6S0B2sFSKdjE/rownXL0N/EGkCDddycW75FZyqBh
         J0mqDxkjR2EBcHDUKlxhB71lNOHLDxFD6Xq6quxxqjCmG4tf1zkfdktHMoKwEonAGS2+
         xQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JMYyFm+OgGHjz9dSb/AXMCy1+rPjG8LlbhrPGzCJRoM=;
        b=Ky/IVPTFfB4d3FpgVDNBBcEyhi06AyFeAcw7FmpOv2L0T+rVCmdKMEDhDJnT007++Q
         FzczK0b7K+d2LbrYZ49kAzMtyq7lM2j45xngE/UO+09O3rVexJ/eQDIokT9ohoTUJ6kY
         Rng+UHWh1zzy1zo6SZP5AIZTVkwdX63ZUxyFTVoIqPe+5xh5R9+/JgjOaDhOC6b5N64K
         xAunfbc/V0A0fIvnrwy9mQWGiUq+GkaoOUq+muvpg1X2wPUmi2v1Xm5HZ0Cf/+6IjeaK
         tKBLZ0wuRWxPAOkwC3+jqulqPtPyMT/IWDR5OVbahgGKRA1kapZh2tgHwUgy+0/AHuDj
         pgmA==
X-Gm-Message-State: AOAM53041VWIbJVxCK8CMroqsGjpmGPqwCMGG1HO67iK403nMTHJZLln
        1FX7XLHtO2IMgTxWYh+g4sI+rEeys1FRNw==
X-Google-Smtp-Source: ABdhPJx0ywMRFPUi4TR4aaR8JIB07co0ydE0IvvF0FZbTN1tdPCooxbNSzlcfnltIn034PMjx1mO+g==
X-Received: by 2002:a17:906:4f19:: with SMTP id t25mr1370180eju.176.1633667112140;
        Thu, 07 Oct 2021 21:25:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm506320edz.95.2021.10.07.21.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:25:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/8] trace-cmd convert
Date:   Fri,  8 Oct 2021 07:25:02 +0300
Message-Id: <20211008042510.978362-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
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

This patch-set depends on "PATCH v3 00/20] Trace file version 7 - compression",
should be applied on top of it:
 PATCH v3 00/20] Trace file version 7 - compression

v3 changes:
- Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd library: Use output handler when copying data from input
    file
  trace-cmd library: Handle version 7 files when copying headers between
    files
  trace-cmd library: Copy CPU count between trace files
  trace-cmd library: New API to copy buffer description between trace
    files
  trace-cmd library: New API to copy options between trace files
  trace-cmd library: New API to copy trace data between trace files
  trace-cmd library: Extend tracecmd_copy() API
  trace-cmd: Add new subcommand "convert"

 .../include/private/trace-cmd-private.h       |  15 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  13 +
 lib/trace-cmd/trace-input.c                   | 698 +++++++++++++++---
 lib/trace-cmd/trace-output.c                  | 122 ++-
 lib/trace-cmd/trace-util.c                    |   8 +-
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-convert.c                      | 106 +++
 tracecmd/trace-restore.c                      |   2 +-
 tracecmd/trace-split.c                        |   2 +-
 tracecmd/trace-usage.c                        |  13 +
 12 files changed, 879 insertions(+), 104 deletions(-)
 create mode 100644 tracecmd/trace-convert.c

-- 
2.31.1

