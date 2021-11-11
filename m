Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CDEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D92AA60E75
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhKKPPX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhKKPPU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:20 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E46C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:31 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id f4so25353301edx.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kU8o9yNqRoNLRfM1jxVCMjLU5s9VVO1rNiR/3JgOxc=;
        b=VFtXIHUDnrUCsI5ojUIy+6Ws9kl4LvM+uEXU09Xs0lHvUHmmxatl8a4ZiTejH/7beB
         /kKXW4uHdZn06VhWovzRskRIFlQp6396mxTJ/lhi+6ZX7vywDNNWACvetZy1FwXi+wCC
         bXqk1+HEGmqEq8HGrGvuWoNXlK3VHfivtHr8OC9ed2/grHoGOqPs+hBoIAhtAN5f8/RJ
         3XxdlxpNqtWuxglwYfSP5dN870ynGWro6z4Z3yHxpDQ4hoMoPqm4iXozyGm6MMqlHxqW
         8tzWMha3Pa0UEf0jne80apWOZAK/3nrCt+Wfxp9zmq+WphVG+vmi2oH/AROAS42jt+CC
         a1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6kU8o9yNqRoNLRfM1jxVCMjLU5s9VVO1rNiR/3JgOxc=;
        b=vprw74HU8kk9GvBHTFbEj6NAT0VkF7X8kM1k2YbvTWnlpuzXcH/CYwcHb2fUAzTJuk
         jOCssoXAV2lyXciQBvO0Msbe1qevbuIEauYQ0TPyDKakm+cECGd4fCp9SOJUtoStAKS2
         VhFPdPMv2REECvzcwEaRYey8YYkrvqIwByuzylYZ1/9Q5kMPudlW8OytC3lr3n+MxJqz
         fvXwLd0UoqjUGf9pVirmGu9e1YmPKlLob3c12cvfZeei47M6NIdssSox+DkIF6ayLasw
         OcTQ0S/+PYZHc83/xa6BxTwpE7ywTZ8J3bk18t0tkOwPS5zKq3UhunnsFV+m0ra2CgJ1
         hGzQ==
X-Gm-Message-State: AOAM533NwjN9IVuC1jXWPKZdyMfHiXt7BEYWVhpW86kCkN56GraqQoYu
        /72WAF+RLkvFIKpIoB0y2PZjnNHphGquiA==
X-Google-Smtp-Source: ABdhPJz5vsqGQVnx29jZn05rxa2m09HrHLgp+nkiORMSDVjMGgUNmRkfUBhCnbmVLzTJzTWM0B8jqQ==
X-Received: by 2002:a50:d50c:: with SMTP id u12mr10688712edi.118.1636643550112;
        Thu, 11 Nov 2021 07:12:30 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dk5sm1686835edb.20.2021.11.11.07.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/8] trace-cmd convert
Date:   Thu, 11 Nov 2021 17:12:20 +0200
Message-Id: <20211111151228.86922-1-tz.stoyanov@gmail.com>
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
"trace-cmd fixes and clean-ups" patch set.
"Refactor APIs for creating output handler" patch set.
"Refactor the logic for writing trace data in the file" patch set.
"Trace file version 7 - sections" patch set.
"Trace file version 7 - compression" patch set.

v4 changes:
 - Rebased on top of the latest master.
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
2.33.1

