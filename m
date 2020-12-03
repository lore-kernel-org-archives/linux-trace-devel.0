Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D481C63777
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB8E1205ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgLCGDL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 01:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbgLCGDL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 01:03:11 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971DDC061A4E
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 22:02:29 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id b73so779067edf.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Dec 2020 22:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5kZRP0rblXjRAgjiJm2OWZfEeveor1YlmfbqqNhqOPA=;
        b=qOnW8vxIdvWCSNSHNYY+QXM/ddNPym9fXtFudNcOziTeW/0yZjCLSFc4CJWT8nWZFE
         sbY/QJoMURnFND7/+tdhu0xpKVTWnqTfSx23F56tScLOVoyYkvtivNTaa8LSQ62Ly7sK
         UmtsEBsitGdt7g/7mHb8ytMDWocdIxPhsG9/ZGchrjng4dOPUqXisYHToB7PZjYTmnj4
         B6V2MNEf4AamCbdwFXJ+B+sEp4Eo+kRI9N/xggUQQxrqzM4R4kwY8QaItauGEiMYtxkC
         B0RNWSvkM1VWk0/NgVNIGYI+2vYBmO0O9+KALALXB12h44TFE/ZAWeQ9qlN4RDArWDYL
         OEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5kZRP0rblXjRAgjiJm2OWZfEeveor1YlmfbqqNhqOPA=;
        b=Yvi8bVZj6s/du4M8/xktUtOT12jWh1I9LE+QBMSUz/be4jVHlX9QzNlHnLXv0xz4z5
         Ch/YSXMoRKnCR6JAs65HzT4u0PWneYXmzoXNvYXWIoSdowEKR3BwrUhgwCtDrgrW9lJ/
         i86Zf3KnHodcntuOIhvawo5IpIV+GfcDAxJIOHTGkZVXS0AKIOXSVa2/i0vak2VYj8XK
         IP8+hBLGKnO3nKO+4OKT3WSfQ4sGfhCEtGpuPjgGLYoheUPSPOFLaHYn19X8ELlAjacL
         8R/Klg2/UILpJsoEHoxPNsIKvSMbJwDxkWsjvNlpkdqB6nIq7efRXVzAhecwz7s0qdv/
         mZUw==
X-Gm-Message-State: AOAM533BeSqtwXoBfGBE/nPjo/+PMSDoS2TYqNQRMh4QK7uCLuCvUfe3
        0tHJ6+oAR6L6AP4aOCwUocYL67/E8VgayDZk
X-Google-Smtp-Source: ABdhPJz2VwsAiBIxOQ+KaHWo6u++aiYTMFSzqmaleBpXaWAcOHjG1jJBoBQnP/HJngIbLa2y8T4FcQ==
X-Received: by 2002:aa7:cdd8:: with SMTP id h24mr1366794edw.153.1606975348326;
        Wed, 02 Dec 2020 22:02:28 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d9sm388629edk.86.2020.12.02.22.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 22:02:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] Initial trace-cmd perf support
Date:   Thu,  3 Dec 2020 08:02:21 +0200
Message-Id: <20201203060226.476475-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementation of trace-cmd perf subcommand. It collects call traces
of a given PID and resolves collected addresses to function names. Still
work in progress.
What it has till now:
 - Configures and runs perf to collect call traces of the given PID.
 - Runs per CPU thread to read perf buffers and store traces in temp files.
 - Resolves collected addresses to function names (well, at least tries to do
   it). This includes also dynamic libraries, loaded runtime during the
   trace.
What should be implemented:
 - Store the results in a trace.dat file. Should think about how to extend
   its format to hold these traces.
 - Visualise the call stack from trace.dat file with trace-cmd report and
   KernelShark.

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Internal refactoring of pid address map logic
  trace-cmd: Make read_file_string() non static
  trace-cmd: New internal APIs for reading ELF header
  trace-cmd: Add a new option in trace.dat file for the address to
    function name mapping
  [WIP] trace-cmd: Add new subcomand "trace-cmd perf"

 Makefile                                      |  10 +
 .../include/private/trace-cmd-private.h       |   5 +
 lib/trace-cmd/trace-input.c                   | 144 +++
 tracecmd/Makefile                             |   2 +
 tracecmd/include/trace-local.h                |  46 +-
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-dump.c                         |   9 +-
 tracecmd/trace-obj-debug.c                    | 907 ++++++++++++++++++
 tracecmd/trace-perf.c                         | 726 ++++++++++++++
 tracecmd/trace-record.c                       | 107 +--
 10 files changed, 1841 insertions(+), 116 deletions(-)
 create mode 100644 tracecmd/trace-obj-debug.c
 create mode 100644 tracecmd/trace-perf.c

-- 
2.28.0

