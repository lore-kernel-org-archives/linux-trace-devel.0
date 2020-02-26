Return-Path: <SRS0=1BtL=4O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAC2C4BA18
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E98D206E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Feb 2020 16:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X7gv5741"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgBZQcE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 11:32:04 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:34995 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgBZQcE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 11:32:04 -0500
Received: by mail-lj1-f176.google.com with SMTP id q8so3832307ljb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Feb 2020 08:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r1GHfcF/tFV0Bbg0QpbyViYQLDk5PDaG9NjxDYpJe6k=;
        b=X7gv57411N0hDjrkfIE7LIU31RyTQhpPIvt4k9lkmU4pouqbzW99zBTo9VP+98SpRO
         nfjvc3P+JD1UV6ZAjCdPICKePgL7+xL74ZeO5NIwbwy1IvMJxx+qDhehUXQBoPVs4Cv7
         DKdCv4sn/D+hW8ti0a6R8gbnxGN6r4SSGBATV5OnCMbg5q/OtSD7SvphZezAwermCNAA
         YMkrDnTUj4nB8goG7eM9P5K4/MV30g38Y6Igiqni1ubS1uD3lSAAYVpgwWlZYmz2jqDa
         5nyrQ0uFCagBetRJJBOmgSIQtLfrm2KPmn9y79ufp+g6umDqxOH0N7qZTVOS3mZPnusH
         g5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r1GHfcF/tFV0Bbg0QpbyViYQLDk5PDaG9NjxDYpJe6k=;
        b=ihLi+9SKsnXyYyxJ4aOx6pBehg7+89gOhNFyp4dd9AkU5iKAg8QelL45aPIjvDQGtY
         QlQe3JQ3Tz0EuTiACkEWFPqnPc1VIOOFtHVPNmnHKxjmKXFoDFJg4b5xm0FjfIIIiPyb
         QbHEvjKBkI3UaHOb6LFLqB63x+d+TJ1gLvLW8aFkn7hN7gxRK/Quu3Y+T1oV26J/hSjG
         IF0225zTOkeW1BH3ry3h3cg/pEkZFwmlkcVR9lzqgHYZOfpHciCto9sdxkGOzo8F9aru
         8Qh77yao9KSiASW5V7a/6h/8zBQ1k8lAcj2i0xMRSa2+ROBtl1LeWlnXTo5VrOQFKWu5
         0YBA==
X-Gm-Message-State: APjAAAWA9r/Z6WSVwVdjSRBivbdfgjAtS7QTudfkRWmL0e3YVMXxHb8G
        sMuGVIGkIcOjaE0SV3cO8Gpm2YKytQ8=
X-Google-Smtp-Source: APXvYqx/7Eo42U6KmIF1RM2G7w2UP2qxwl4mZz0FBvYKdro7eFW7gkL53tL0jh+CCs9eiKbBtfTUqQ==
X-Received: by 2002:a05:651c:414:: with SMTP id 20mr3335799lja.165.1582734722055;
        Wed, 26 Feb 2020 08:32:02 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s2sm1264133lfd.67.2020.02.26.08.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:32:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/5] trace-cmd: SQL-like syntax for ftrace histograms configuration
Date:   Wed, 26 Feb 2020 18:31:54 +0200
Message-Id: <20200226163159.20232-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Configuration of complex ftrace histograms could be hard, using the existing ftrace interface.
The "--sql" option is implemented to simplify this task. It uses a sql-like syntax to define
the histograms and generates necessary ftrace syntetic events and triggers. Each ftrace event
represents a sql tible, while the fields of this event are rows in the table.

Few trace-cmd library APIs are introduced in this patch set, used in the
sql parser logic:
  in libtracefs: tracefs_instance_file_append()
  in libtraceevent: new flag to suppress parsing warnings

The patch set is based on Steven Rostedt's PoC implementation:
   https://github.com/rostedt/sqlhist

[
 v3 changes:
  - Do not allocate tep handler in sqlparser library, pass it as input
    parameter to sqlhist_parse() API. The tep handler, initialized with
    all required ftarce events must, be supplied by the API caller.
  - Add tep handler to common_record_context of trace-cmd record and
    similar commands. Add logic to initialize and destroy it.
  - Implemented new traceevent API to suppress parsing error while
    reading ftrace events.
 v2 changes:
  - Removed patches for trace-cmd reset sub command from this patch set, as
    they are not directly related to the SQL-like syntax implementation.
  - Fixed the use case with more than one "--sql" argument. Added logic to
    clean up the parser state before parsing a new string.
  - Implemented API for freeing all resources, allocated by the parser.
  - Fixed the use case with ftrace instances.
]

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Add new libtracefs API tracefs_instance_file_append()
  trace-cmd: Unit test for tracefs_instance_file_append() API
  trace-cmd: Add new libtraceevent flag to suppress parsing warnings
  trace-cmd: Suppress parsing warnings in tracefs_local_events() API
  trace-cmd: Add "--sql" option to trace-cmd start and record sub
    commands

 Documentation/trace-cmd-record.1.txt |   37 +
 Makefile                             |    1 +
 include/traceevent/event-parse.h     |    2 +
 include/tracefs/tracefs.h            |    2 +
 lib/traceevent/event-parse.c         |    6 +-
 lib/tracefs/tracefs-events.c         |    2 +-
 lib/tracefs/tracefs-instance.c       |   53 +-
 tracecmd/Makefile                    |   12 +-
 tracecmd/include/trace-local.h       |    4 +
 tracecmd/sqlparser/Makefile          |   52 +
 tracecmd/sqlparser/sqlhist-api.h     |   29 +
 tracecmd/sqlparser/sqlhist-parse.c   | 1526 ++++++++++++++++++++++++++
 tracecmd/sqlparser/sqlhist.h         |   34 +
 tracecmd/sqlparser/sqlhist.l         |   59 +
 tracecmd/sqlparser/sqlhist.y         |  175 +++
 tracecmd/trace-record.c              |  142 ++-
 tracecmd/trace-usage.c               |    2 +
 utest/tracefs-utest.c                |  106 +-
 18 files changed, 2202 insertions(+), 42 deletions(-)
 create mode 100644 tracecmd/sqlparser/Makefile
 create mode 100644 tracecmd/sqlparser/sqlhist-api.h
 create mode 100644 tracecmd/sqlparser/sqlhist-parse.c
 create mode 100644 tracecmd/sqlparser/sqlhist.h
 create mode 100644 tracecmd/sqlparser/sqlhist.l
 create mode 100644 tracecmd/sqlparser/sqlhist.y

-- 
2.24.1

