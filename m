Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f50.google.com ([74.125.82.50]:42933 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964976AbeAJP64 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 10:58:56 -0500
Received: by mail-wm0-f50.google.com with SMTP id b141so27906558wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2018 07:58:55 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 0/6] trace-cmd: Make out-of-tree builds to work
Date: Wed, 10 Jan 2018 17:58:26 +0200
Message-Id: <20180110155832.15928-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This small series makes out-of-tree builds to work. In order to do that, it's
enough to set the 'O' variable while calling make like: make -O=build_dir.

NOTE[1]: this series has to be applied after the series called:
"trace-cmd: restructure the project's source tree"

Vladislav Valtchev (VMware) (6):
  trace-cmd: Make libtraceevent builable out-of-tree
  trace-cmd: Make the plugins buildable out-of-tree
  trace-cmd: Make libtracecmd buildable out-of-tree
  trace-cmd: Make the trace-cmd target buildable out-of-tree
  trace-cmd: Make the python targets buildable out-of-tree
  trace-cmd: Make the GUI targets buildable out-of-tree

 Makefile                | 57 ++++++++++++++++++++++---------------------------
 kernel-shark/Makefile   | 40 ++++++++++++++++++++++------------
 lib/trace-cmd/Makefile  | 27 +++++++++++++++--------
 lib/traceevent/Makefile | 25 +++++++++++++++-------
 plugins/Makefile        | 37 +++++++++++++++++++-------------
 python/Makefile         | 30 +++++++++++++++-----------
 scripts/utils.mk        |  2 +-
 tracecmd/Makefile       | 33 ++++++++++++++++++----------
 8 files changed, 148 insertions(+), 103 deletions(-)

-- 
2.14.1
