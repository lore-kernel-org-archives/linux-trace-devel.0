Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD31C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49C260FF2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbhIMM3T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM3T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:19 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFB4C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:03 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d207-20020a1c1dd8000000b00307e2d1ec1aso691246wmd.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sgT6gCuCbbVZi0b0TVjTpnFcF134qBMD86Tji6YQ6Y0=;
        b=KAyyBYiQFlBF4aL0SEygpNhFakL13mjDxxi33X1ivwhAa/oidFJHM0DEajBK630Hx8
         nqmUJ40otiaF/U2o/+EBb7c0fEOt6OnKA93bRY7N9ijfEr3lUc1dyJ4awKtbDOsXcRHu
         bQcWwSD7+kAXm5fx8fx/BOwP2K3+ErKs0c/oj9EURKfryDRjG8ITjD3xvnpvVKvdBoll
         eEnlkdoGnIzb76+jprbYzoMJnrsWK7abLZN9oj3w9QNOrkDaft0aEe8fnvAlRSvcFTVx
         EAtf23AhU1KTPKElr5uljFPgn8B5VdZQ02YqaR0VB0H1quHZe6QojWvJA4AaZuVZHgqC
         PIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sgT6gCuCbbVZi0b0TVjTpnFcF134qBMD86Tji6YQ6Y0=;
        b=0wx9CNpDZKv8cobPRJUfNKMMkzel3yMe6y2S9iBf7m+VE2qtcefrQxzXyereBcu/ot
         OqLHYm3AFn5vb/i+Nzasdv9twTZMwsSKFikkZtYaYkNo49SOADh24sBiEQHtPsMwZCzq
         0N0Iqk6OrhoNptFLpyVKW6wiIpcA2S6qx81fD/BMGH2vP0IcvYBW1qDYArCJln1CKzzl
         Z6+kRMbRRG8eYuHS9eNAEZCnHzI6bnNn0lGPExbECVySdZsm+1dAVqUoyZUjwNiZLCBs
         O33FU2rTG4PqhPeV/VJcJopB3gu0kzM+ax4Vc+bcT+mDJK+xERBJIwUeTzzm5TF3zV+X
         dSag==
X-Gm-Message-State: AOAM532PKT8aLzvdjZRn+sBplo8AVR/wOcgpFDDYfuinWVL2Mo0y+oAA
        cUjeSnb+4xCazXpfxfsqpqCFn5Vvs28=
X-Google-Smtp-Source: ABdhPJxRCM4wAVHxIhnfHO9zUDnyU/LFXYBc5eL5bB+Q4lP1xHe+1f1FhSU5pqOOrctC5k5g9XQlTA==
X-Received: by 2002:a1c:28a:: with SMTP id 132mr10887538wmc.101.1631536081869;
        Mon, 13 Sep 2021 05:28:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 00/21] trace-cmd fixes and clean-ups
Date:   Mon, 13 Sep 2021 15:27:38 +0300
Message-Id: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Various trace-cmd application and library fixes, clean-ups and internal
refactoring, needed for trace file version 7 and compression changes.

This patch-set supersedes "[v2,00/87] Trace file version 7":
   https://lore.kernel.org/linux-trace-devel/20210729050959.12263-1-tz.stoyanov@gmail.com/

v2 changes:
 - more cleanups, forgotten in the first version

Tzvetomir Stoyanov (VMware) (21):
  trace-cmd library: Read option id with correct endian
  trace-cmd report: Fix typos in error messages
  trace-cmd library: Fix version string memory leak
  trace-cmd library: Fixed a memory leak on input handler close
  trace-cmd library: Do not pass guests list to a buffer instance
  trace-cmd library: Set long size to the input tep handler when it is
    read from the file
  trace-cmd library: Do not use local variables when reading CPU stat
    option
  trace-cmd library: Reuse within the library the function that checks
    file state.
  trace-cmd library: Fix possible memory leak in read_ftrace_files()
  trace-cmd library: Fix possible memory leak in read_event_files()
  trace-cmd library: Fix possible memory leak in read_proc_kallsyms()
  trace-cmd library: Fix possible memory leak in read_ftrace_printk()
  trace-cmd library: Fix possible memory leak in
    read_and_parse_cmdlines()
  trace-cmd library: Set input handler default values in allocation
    function
  trace-cmd library: Track maximum CPUs count in input handler
  trace-cmd report: Close input file handlers on exit
  trace-cmd report: Do not print empty buffer name
  trace-cmd library: Set correct CPU to the record, retrieved with
    tracecmd_peek_data
  trace-cmd library: Refactor APIs for creating output handler
  trace-cmd library: Refactor the logic for writing trace data in the
    file
  trace-cmd report: Init the top trace instance earlier

 .../include/private/trace-cmd-private.h       |  35 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  19 +
 lib/trace-cmd/trace-input.c                   | 211 +++--
 lib/trace-cmd/trace-output.c                  | 777 +++++++++++-------
 lib/trace-cmd/trace-util.c                    |  28 +
 tracecmd/trace-listen.c                       |   2 +-
 tracecmd/trace-read.c                         |  21 +-
 tracecmd/trace-record.c                       |  73 +-
 tracecmd/trace-restore.c                      |  32 +-
 9 files changed, 782 insertions(+), 416 deletions(-)

-- 
2.31.1

