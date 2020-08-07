Return-Path: <SRS0=Thka=BR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345F8C433E1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0737D22CF8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="US7BQoNz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgHGMHO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Aug 2020 08:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgHGMHB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Aug 2020 08:07:01 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E798FC061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 Aug 2020 05:07:00 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d190so1516738wmd.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Aug 2020 05:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ggRZtNhJVr77X/j4J7urcsbWXbslkDt6H5WlNc3uANk=;
        b=US7BQoNzLXQz9xIgl9nAEY1X08zukJElRCwPtWnvp10S/M79hI5wEt37kBu5YclDwe
         +QeUrrBR+dNbnsr3bl9sY0yfW++gOXVh7lKBAoLq0X0o07Ul+fG2BgLm7r1a+VTDU3La
         CND2ISe9NceCV7/tZJymW/vFVHSDWGCZupLusjUpDl1AH3r0b7+7KUEhY2Nbnnz2lV/+
         Kq2f8fZA0X24WA/W5Ds2Xz5/9SzVKkV0/i5HaCbfX4qNzakeg/RUswlOHgLcFvSaqgu1
         TdBwYGwqk/w41X1TePl6jFOcSqxWchVxrk883hIVgZxdbv2ablnchHkt8Bkb5E47tl60
         7uEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ggRZtNhJVr77X/j4J7urcsbWXbslkDt6H5WlNc3uANk=;
        b=qE8oAgZPtajQFuaU8yPJNGLjg4iPvfkkTdUHJzCEUTn4vBneSju1yjtTV1vOGxSESK
         O7f+wwyTipY62UHxYqnb89rC1uD7+kYH7H1yxVJXiiEd6Zs4YzhxShOCURxX96xlGLt8
         NN1K1YwnkS3ROqs6D0Z4+iP03UU51NPRn2RcGE2MFaXoHfV9MzwoYXgjdooyiO4XXya8
         jCAPy7O7KxeDnufgpnBPRkL7jgmz/PhVk89xSWxaUXJVCquneCrTLPdOALJORuwaf7H+
         PLahU8clp9pVD6hLhlOsOsHpfKho/wWpfWteNEII4k8nM1UTl6kcISjpEhs8dGTOYFAU
         u9Ug==
X-Gm-Message-State: AOAM533nDmDgqiTIdCEKYFmPU1Dj0uvm/vw9EpqOxa8OCrvBwSQAp0+X
        rNBoc+z1zq2ibXLY4fPA1tPJpkYR5xo=
X-Google-Smtp-Source: ABdhPJyQo4qU+v7Pa78hXbxM4OiWydtOPRF2D1CW37Phs/WEz3QMjRVZb+KzL72hZg1acYjVX0flzw==
X-Received: by 2002:a1c:df02:: with SMTP id w2mr13663213wmg.137.1596802018563;
        Fri, 07 Aug 2020 05:06:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm10485303wmg.0.2020.08.07.05.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 05:06:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4][WiP] trace-cmd: Add "perf" sub command
Date:   Fri,  7 Aug 2020 15:06:51 +0300
Message-Id: <20200807120655.797084-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new "trace-cmd perf" sub command is implemented, to collect performance
information about a user space program, using perf. The command has one
argumemnt, mandatory, using to specify a PID of running userspace process:
 trace-cmd perf --pid <PID>
This is a work in progress, not completed yet.

What is implemented:
 - Initial infrastructure for configuring perf, using its kernel interface,
 and running per CPU threads for reading collected perf data. Perf is used 
 to collect periodically CALLCHAINs (values of IP register) of the requested
 PID.
 - trace-cmd internal APIs, wrapper around libbfd, for parsing an ELF header.
 - Resolving collected IP values to function names, using the binary file of
   the running application and all libraries that it uses.
 - New trace.dat file option for storing address to function name mapping
   and a new API for address to name resolving using stored information.

What is not yet implemented:
 - There are problems reading the perf mmap pages with collected data,
   currently only the first few records from each CPU page are read correctly.
 - Assemble the trace.dat file with all mandatory headers. Think about a new
   type of trace data in the file and its format. This should be designed
   flexible, to be able to store various perf data, not only CALLCHAINs.
 - Add support in "trace-dat report" for reporting the new data.
 - Add APIs in libtracecmd for reading the new data.
 - Enable collecting of kernel functions in the CALLCHAIN and implement
   resolving of kernel address to a kernel function name.
 - Formatting and beautifying the code.
 - A lot of testing and bug fixing.

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Internal refactoring of pid address map logic
  trace-cmd: New internal APIs for reading ELF header
  trace-cmd: Add a new option in trace.dat file for the address to
    function name mapping
  trace-cmd: Add new subcomand "trace-cmd perf"

 Makefile                       |  10 +
 include/trace-cmd/trace-cmd.h  |  13 +
 lib/trace-cmd/trace-input.c    | 144 ++++++
 tracecmd/Makefile              |   2 +
 tracecmd/include/trace-local.h |  33 +-
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-dump.c          |   3 +
 tracecmd/trace-obj-debug.c     | 770 +++++++++++++++++++++++++++++++++
 tracecmd/trace-perf.c          | 540 +++++++++++++++++++++++
 tracecmd/trace-record.c        | 107 +----
 10 files changed, 1510 insertions(+), 113 deletions(-)
 create mode 100644 tracecmd/trace-obj-debug.c
 create mode 100644 tracecmd/trace-perf.c

-- 
2.26.2

