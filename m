Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4462AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhLJK61 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbhLJK60 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:26 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D377C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:52 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id v1so28963757edx.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEAu/6EO4U7H4mvBK0LBhpaD1DnSJHsaxL+2KoGbfgs=;
        b=BHfzf9ZOrkX7w3OtwPLgjvjjxTVY/ot8K5o/DJq5taKQ+OT9trOQIlg/e15/6+xsih
         hXamWDOAq8BP8rb7916xCK5uMqdQSOca7M4lNg9jNZ/AwMwKbPwPr6R/wYDyU78K6K7C
         xLY32Qxw76XaVZAu3EW42Pkp7NF7PvcgJ71qu/42tol0/OYxp0mpvj71bu8dKRpg3r2e
         KFvebVI7iB2YaAEIWiLeC5IUBD5S9ImjkgMNBpoL+u+236Wk6aL4qcgdXiTpyUswlhlG
         Lmgv4u7rmDJLB97A8k6ejhRN9E3Y6eURAdd/XfBR9BOamaqcQctsPfm1tg+MS8WY3+rh
         9xvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LEAu/6EO4U7H4mvBK0LBhpaD1DnSJHsaxL+2KoGbfgs=;
        b=6XmxBokCy1SboqdehIYPiG8G7T/lEJOjLpQ67uxbFPQ/w06UuJgepnAcf5C/tJUwPY
         04qLo4vVtAnOwaevyrrg3/SE4ENM6NU4WJF5EMEhF0U4dAMDBGf5jsbyofQgERNcRxV1
         4P1jGIYqiTs1ofLl4ItQ1ChVd8NdRj+erresU3rejow7mRpgiq6QXgfJhCGt7UNE41Qv
         +peG15eOXzsUwvYj1r4QoXifqCjx0/3JoM6EVfaCS6EUiCaMcI2fRZQID5evbbXrCBJ0
         JEzBIBZdilWMYqy1hn2XsXat7KjhOLSc5kzXY7UllLOvmOvC5aG4ZSddxXxIYi3ZWzuR
         x2hw==
X-Gm-Message-State: AOAM532HiOhFIbxYapCK0rC1HEMAhpA4DLBm6sur1qVTDT5+aNRqpAP2
        jcdKLuCD95nQ8wyyb0oMjoEHX6YDmbI=
X-Google-Smtp-Source: ABdhPJxMq0n35CXuiZPHfyEbMdU0UhVMaFRTURyFTPlYXj2oLT7PXI6vaVdELKE53YV2ImI2gW0QSQ==
X-Received: by 2002:a17:907:1c15:: with SMTP id nc21mr23313269ejc.260.1639133690562;
        Fri, 10 Dec 2021 02:54:50 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 00/25] Trace file version 7 - sections
Date:   Fri, 10 Dec 2021 12:54:23 +0200
Message-Id: <20211210105448.97850-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Introduce the next version of the trace-cmd trace file - 7. Major changes
since version 6 is more flexible extendable structure of the file, based on
independent sections.

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
  trace-cmd report: Add new parameter for trace file version

 include/trace-cmd/trace-cmd.h                 |   5 +
 .../include/private/trace-cmd-private.h       |  29 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  17 +-
 lib/trace-cmd/trace-input.c                   | 824 ++++++++++++++----
 lib/trace-cmd/trace-msg.c                     | 127 ++-
 lib/trace-cmd/trace-output.c                  | 677 +++++++++++---
 lib/trace-cmd/trace-util.c                    |  12 +-
 tracecmd/trace-listen.c                       |   3 +
 tracecmd/trace-read.c                         |  18 +-
 tracecmd/trace-record.c                       |  32 +-
 tracecmd/trace-usage.c                        |   2 +-
 11 files changed, 1438 insertions(+), 308 deletions(-)

-- 
2.33.1

