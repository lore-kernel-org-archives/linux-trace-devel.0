Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95BEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C10610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhINNNy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNNy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:13:54 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95741C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id u16so20141463wrn.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MCVrx5EWsYhXQ+aR+CAn7EHcZ21c6kWy5O20ZD23As4=;
        b=Y+mQojSQ4Oi1dKqr3Qhg3DHWLN/HpbzqqQ7kSb8RLSCdBtYqpfFyvRLl94WZQM1J8e
         IszJ7OzsnMFsX30mTH3JBK3LL3l2WVpuSqZ9HAn2Ozo3t+eo1v4HuUsIGKoIAxoA1+Tq
         ThsZe5em6lGiaUjIalDfXehMpyh6pwLLQTbCb5YDagzEwMGylbg5FdyosW2reIXHi2ed
         6+oQb1Vz/qvV14nPEVtoCfX6ufb9k97vZ/dFN1HKcdkATQOM6jIU4Z+ip3oC3Ycebr9m
         GNiKY1COBWlkBTM7hkhCvXVS6pE/XwswZkOSAR9AY8q0szD5jTq/1gT7pYl+LO1qagbo
         qOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MCVrx5EWsYhXQ+aR+CAn7EHcZ21c6kWy5O20ZD23As4=;
        b=SG++1d0WuIaIN6Ex2RFFN4qQ+Yf5ktZ7XZ7nS1H0fGUgDAl2hF5E0qhaPeplLX2zRe
         ye1wiI8aLLrTORmOSP7fE0ScgB9jz3WD8d3p/1YpsZkxzxg9S/TO4zla7t4wm6c4mwJQ
         Uw3zHMsOzLCrjU1fHMmc6byudY55ZX7tSaWrmEr32aBQmBrm+jiKfUZKSQdslJHN9v9R
         6z1O3vGUQuld7j7bBcjOLBTdmqVKzv8yNE6C11bRvRPRxD9j8QfBQtrqVNhz63QTZwYB
         z/ZkopHHleU9apMSRPmVXm/qcdLosS7hv3rrfgUBEcZpnrL8DjtzDT3h9KbhsUEcGm5H
         wwew==
X-Gm-Message-State: AOAM53327aoDF6XjfHj4sCUauwiKqa+otY1TJ+fmCqPW0HwjKJTuyHaH
        mML7IZey9EePiL2lKZ6KNfRNoiWizvk=
X-Google-Smtp-Source: ABdhPJysF+H6pORrUr+KTwXWBWZ5epuh+Ltyn/SP2LeQOClGT4iI4ygQrL46RMKgKOemQPCFr0HtBg==
X-Received: by 2002:adf:f545:: with SMTP id j5mr8985240wrp.9.1631625155085;
        Tue, 14 Sep 2021 06:12:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 00/21] trace-cmd fixes and clean-ups
Date:   Tue, 14 Sep 2021 16:12:11 +0300
Message-Id: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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

v3 changes:
 - fixed issues of split and convert commands with some corner cases
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
 lib/trace-cmd/trace-output.c                  | 779 +++++++++++-------
 lib/trace-cmd/trace-util.c                    |  28 +
 tracecmd/trace-listen.c                       |   2 +-
 tracecmd/trace-read.c                         |  21 +-
 tracecmd/trace-record.c                       |  73 +-
 tracecmd/trace-restore.c                      |  32 +-
 9 files changed, 783 insertions(+), 417 deletions(-)

-- 
2.31.1

