Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34FBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352369AbiASIZM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352346AbiASIZL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:11 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE772C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:10 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c71so7586560edf.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1pQXBmqQlv019UlXAcNxi8odHrMXzUVPZSH6Npafg6o=;
        b=AV8kS3q4mE7mSnGVULVfDPx1w4+wLcesuCsO2JuRHEqhAi3hM4m8JXfr0o+oOy4x06
         gWxNMVvABPU4c9AYLv2Sm4WvVtt6Nk38fVh3uOFY41egu8iXfRMjc1YTeyqb6lp4XSBw
         eeXqLG985qe3rpP78PrG3eYhHwIp/wynjCAIW1rd6yfk4NsCsEcvL1P8d3qzFPzAJn1n
         Bxt0LCVCeJsy16MXiHDsFbB9E4DOk7kmZA7PkHkAgO+JM/LmsxWcmbAuM3BECNlY7cJx
         iOqXtPxt8TqFHl/xcJkA3PhfjlRj5q6oirjn3eaNwy8UMswtmX1YEnXZT6itZe4NPq+w
         eMbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1pQXBmqQlv019UlXAcNxi8odHrMXzUVPZSH6Npafg6o=;
        b=no30XycNzidDH/kS90M79HW8p+T71hcmab0bFq5Tt90AA+zHIPkrHr/AhMPjoqujCg
         CKafB+lJDRMYFqAW8O8Z+Aaqfbq0yt0pjc0d2XsfCTsxvcIWYWW8OxNzNfJs/s49Y6Ah
         AtQVWtcl+vrDWRen29M9n2dqE6Pp/V6q6N7+eQL5/8RqvCKJCYqokgvo4mnmcW9vypH1
         rgz/wZA59mGaTqWNdkkg7NglXikkfe1UE5Wz+Z7NTbT5a6PnnXDwtMy5RQLhTv8mCzBy
         /v12tfQ37eBne3IA23/yxB3GYcGerUxcivTc36gHGaIxhjc6ENO+HIxTupzhehDitIN+
         hECw==
X-Gm-Message-State: AOAM531jzmPBhiBKjIWeBIPvel7rx+z7RxPWxC+rjG9Yn/kclbExTTje
        3GlV3Kos9tk82T9SR5LhA0HypmAbvME=
X-Google-Smtp-Source: ABdhPJyrX5sXYEJjjkDdy9T+tRdV8BU4/cggz0wGOfkcJN80Ww/nYH39yR04MwtL5DGffkOsIZX6kw==
X-Received: by 2002:aa7:dc15:: with SMTP id b21mr28836037edu.237.1642580709507;
        Wed, 19 Jan 2022 00:25:09 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 00/25] Trace file version 7 - sections
Date:   Wed, 19 Jan 2022 10:24:42 +0200
Message-Id: <20220119082507.245600-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce the next version of the trace-cmd trace file - 7. Major changes
since version 6 is more flexible extendable structure of the file, based on
independent sections.

v8 changes:
 - Bug fixes.
 - Code cleanups.
 - Rebase.

v7 changes:
 - Rebased on top of the latest master.
 - Introduced new metadata strings section.
 - Use 8 bytes for section size. 
v6 changes:
 - Rebased on top of the latest master.
 - On trace file v7 close, write any unsaved options in the file - as
   a last section.
 - Removed the patch "Do not write CPUs with empty trace data" from the
   patch set. Empty CPUs are written in v7 trace files, the same way as in
   v6.
v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Rebased on top of the latest master.
v3 changes:
 - Fixed issues of split and convert commands with some corner cases.
v2 changes:
 - Code cleanups.

Tzvetomir Stoyanov (VMware) (25):
  trace-cmd library: Define trace file version 7
  trace-cmd library: Add cache functionality to network message handler
  trace-cmd library: New APIs to get and set version of output handler
  trace-cmd library: Add strings section in trace file version 7
  trace-cmd library: Add internal helper function for writing headers
    before file sections
  trace-cmd library: Write header before file sections
  trace-cmd library: Add multiple options sections in trace file version
    7
  trace-cmd library: Do not write CPU count section in trace files
    version 7
  trace-cmd library: Move CPU flyrecord trace metadata into the buffer
    option, for trace file version 7
  trace-cmd library: Add section header before flyrecord trace data
  trace-cmd library: Fit CPU latency trace data in the new trace file
    version 7 format
  trace-cmd library: Add macro to check file state on reading
  trace-cmd library: Introduce sections in trace file reading logic
  trace-cmd library: Initialize internal sections database on file read
  trace-cmd library: Use sections database when reading parts of the
    trace file
  trace-cmd library: Read headers from trace file version 7
  trace-cmd library: Read strings sections on file load
  trace-cmd library: Read extended BUFFER option
  trace-cmd library: Handle the extended DONE option
  trace-cmd library: Initialize CPU data for reading from version 7
    trace files
  trace-cmd library: Handle latency trace in version 7 files
  trace-cmd library: Handle buffer trace data init for version 7 files
  trace-cmd report: Use the new latency API to read data
  trace-cmd: Write buffers metadata in trace files version 6
  trace-cmd record: Add new parameter for trace file version

 include/trace-cmd/trace-cmd.h                 |   5 +
 .../include/private/trace-cmd-private.h       |  29 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  17 +-
 lib/trace-cmd/trace-input.c                   | 836 ++++++++++++++----
 lib/trace-cmd/trace-msg.c                     | 127 ++-
 lib/trace-cmd/trace-output.c                  | 691 ++++++++++++---
 lib/trace-cmd/trace-util.c                    |  12 +-
 tracecmd/trace-listen.c                       |   3 +
 tracecmd/trace-read.c                         |  18 +-
 tracecmd/trace-record.c                       |  30 +-
 tracecmd/trace-usage.c                        |   2 +-
 11 files changed, 1463 insertions(+), 307 deletions(-)

-- 
2.34.1

