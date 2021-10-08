Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B82C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 188A660F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhJHEPT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEPT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:19 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC57C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:24 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v18so31498405edc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aOyI+m54ZTrLHoVp/FlGIURDVSqkx+CBE+Q9q/N47co=;
        b=boZOUFG8iooqdD/COaYYLDS1hl4NutSH03uQGJpiYnqgypRkJIrGtoYaoCYSeLkMbu
         ctxIutKVOCuUMCvj8/heN2NUG9XJnaja1RdDkOuKQrTe9pKaY/a8G0OY/G9JRSuhEnv8
         ma85j+fUKoDWcgaDNt2BhtaaKmwkq2LXZ5pSQbSV4yaMkbzguQUE2OJXfTjxLF4m32DE
         2NVjH5a0OGULsZ5nGbSTOYJ2NO2A+4TvQKNbtBzrlNhO4mNqS732QLyNqxlbOZOQICfs
         934Sn+z2YL4ybLrcaF//d8OdEmG/8qzoIVdXNn21hEOamEb5+w1JIfjBEvbSIquSlzie
         DVcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aOyI+m54ZTrLHoVp/FlGIURDVSqkx+CBE+Q9q/N47co=;
        b=bAtIfPaIDv8iMZQ+zLtbpHXH0K4FlfrLRLI6Mcj5suRpDcfDy4kRxylU7Bl8Tcisax
         k0u13mG2MQMzyfA+vgxePE5WTU6S4vPRjAqe441QI8AXF0DDd/i3rbVrHeQjPCWuC5MP
         18aQZpvzkzQ8aP12pQsqXCwzX66B+90xQYqNa0pannt+Kw82BBMbuz4edgm2vim4Guxv
         WWxiH6IBSBxbUPCWWlIGjxz8sJHgSyNPd1NU6mjCSFKgwFk9V2019Cj30mTASad40k5n
         pKhcUouedwJt/9M6lItqU0RdFlnP0oy+PKJ3i+VmGurXcppqJcW69Dqi5Ug6V9pFf4T4
         rRiw==
X-Gm-Message-State: AOAM530O8lnmOqi+f23bII7Yw3s15hqak2uS4+QToHrYtQIP5u9B2J3w
        ut6EsGcF+ap4/f1K7Vg3JcyJEI1aAcabtQ==
X-Google-Smtp-Source: ABdhPJxv4oXsHdvLKEtPTgqTw2y5qnhD6LJdPJJgq94ZlhxHlTq28aHpmz6O56eLEmGhz+9ENxDZPA==
X-Received: by 2002:a50:8d85:: with SMTP id r5mr11773868edh.312.1633666403057;
        Thu, 07 Oct 2021 21:13:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/10] Refactor APIs for creating output handler
Date:   Fri,  8 Oct 2021 07:13:11 +0300
Message-Id: <20211008041321.973755-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the trace-cmd library there are various APIs for allocating and
initializing output handler to a trace file. The existing APIs are use
case oriented, with a lot of parameters. Extending them for new use
cases, adding more input parameters, will make the library more complex
and not easy to use.
Almost all use case oriented APIs for output handler creation are
removed and replaced with new flow, which is easier to be extended with
new parameters.

Removed APIs:
 tracecmd_create_init_fd_msg()
 tracecmd_create_init_file_glob()
 tracecmd_create_init_fd_glob()
 tracecmd_create_init_file_override()

New APIs:
 tracecmd_output_allocate()
 tracecmd_output_set_msg()
 tracecmd_output_set_trace_dir()
 tracecmd_output_set_kallsyms()
 tracecmd_output_set_from_input()
 tracecmd_output_write_init()
 tracecmd_output_write_headers()

The new tracecmd_output_allocate() API allocates memory and performs
minimal initialization of an output handler to a trace file. No data
is written in the file.
The tracecmd_output_set_...() APIs can be used to set various
parameters to the newly allocated output handler, that affect the way
the data is written into the file.
When the output handler is configured for the desired use case, the
tracecmd_output_write_init() is used to start writing to the file, it
writes initial magic bytes.
The tracecmd_output_write_headers() API is used to write the initial
headers into the file.


This patch-set depends on "[PATCH v4 0/6] trace-cmd fixes and clean-ups",
should be applied on top of it:
  https://lore.kernel.org/linux-trace-devel/20211008041124.972956-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (10):
  trace-cmd library: New API for allocating an output handler
  trace-cmd library: New API for setting a message context to an output
    handler
  trace-cmd library: New API for setting a custom trace directory to an
    output handler
  trace-cmd library: New API for setting a custom kallsyms to an output
    handler
  trace-cmd library: New API to inherit parameters from an existing
    trace file
  trace-cmd library: New API tracecmd_output_write_init
  trace-cmd library: New API to write headers of a trace file
  trace-cmd library: Use the new flow when creating output handler
  trace-cmd: Use the new flow when creating output handler
  trace-cmd library: Remove deprecated APIs for creating an output
    handler

 .../include/private/trace-cmd-private.h       |  25 +-
 lib/trace-cmd/trace-output.c                  | 397 +++++++++++-------
 tracecmd/trace-record.c                       |  55 ++-
 tracecmd/trace-restore.c                      |  32 +-
 4 files changed, 347 insertions(+), 162 deletions(-)

-- 
2.31.1

