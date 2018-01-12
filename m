Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965001AbeALSJc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 13:09:32 -0500
Message-Id: <20180112180847.372748598@goodmis.org>
Date: Fri, 12 Jan 2018 13:08:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vladislav Valtchev <vladislav.valtchev@gmail.com>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 0/3] trace-cmd: A few fixes
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Some updates for trace-cmd

Steven Rostedt (VMware) (3):
      trace-cmd: Fix leaking of port_array memory
      trace-cmd msg: Set the min size of a message on init
      trace-cmd TAGS: Fix tags to not parse .pc directory of patch

----
 Makefile       | 11 ++++++++---
 trace-listen.c |  2 ++
 trace-msg.c    |  5 ++++-
 3 files changed, 14 insertions(+), 4 deletions(-)
