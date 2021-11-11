Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05B0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4F8761354
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhKKPGO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbhKKPGN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:06:13 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD53C061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:24 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c8so24965147ede.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Im2J9DgTrqYZfFM7MjVclRVqbYvB0lFs2MPIN0koP0=;
        b=c2q4FMjGdefaEBPF/M+YSot5EF+KEI7JHdp64YTqyX1t5pryLMhctGA7UxBKpi6I8N
         waf1fPfilX/rwNUw3VoMBp3snt9OgqQRMpxxL5uIzc4I5zwrREvlmGCcvdW2U8vPJLO8
         Di95P0C1Y+0XGkjLOEKx93M1LjQh8dSqq3JnmkHWTSAKgdeGMOIJn3NQXsl4onzB6UDt
         sUbzh0MxurgvPLkHn/3+3MloGt3U7MP0p8I3ZOHFn94RKW5iAohujQ7pKGEz4ptRNfwx
         jQTUoLyx3EpYvYtROdkwFL3LtgxETTGosMe+CjCL8hbvPJrjc312+7CZ9/tXxwlSkzjE
         HU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Im2J9DgTrqYZfFM7MjVclRVqbYvB0lFs2MPIN0koP0=;
        b=iMUWTNN1Qn1ThZ/C/+qAWoyhqFkzxK7JSLj3nQufc5bWTlASjeiwbbEd4FGQ9oph51
         js8Ez1XbHU7iQHC4M+aEroMsn5BrguvwWk8jsRGD0SZ3CI7YatRlBhIhoFUcddzdNLzW
         FjOTOo5mOlhkeIlhepKNychd0TAVQCU4HryURYTkGRu4OYHK0VMaLsg9oejHajkuqNa7
         UtLPsztdLE4oVcc5ONEnIG3Z7WSSWwoHtpQ5CN3BD0ji6ETkynhACW19qMncD0IHTa0p
         9QA66F6NchLsboa7FiJZuwqkHSCftfv3hDE5IlzgY3N6V5zxnMmZic/XJO9CCZ6vejWB
         2Z/Q==
X-Gm-Message-State: AOAM532y+LzEAQS2wnj+ifafHjuhygLw7fUZvFKlnFvuqEhqvr5qfoqo
        /LiI7ScCDDojFXylFqjVwZ4OkXB9CtAOTg==
X-Google-Smtp-Source: ABdhPJwYLTF1YL2vdfQkffM6SeAYXxFyftmXelU1PvXIuwn93k0uF2i2PQRktabGUog6SgEvSA83kA==
X-Received: by 2002:a17:906:e283:: with SMTP id gg3mr10174838ejb.403.1636643003128;
        Thu, 11 Nov 2021 07:03:23 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d13sm1656128edv.29.2021.11.11.07.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 00/10] Refactor APIs for creating output handler
Date:   Thu, 11 Nov 2021 17:03:11 +0200
Message-Id: <20211111150321.85979-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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

This patch-set depends on:
  "trace-cmd fixes and clean-ups" patch set.

v2 changes:
 - Rebased on top of the latest master.

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
2.33.1

