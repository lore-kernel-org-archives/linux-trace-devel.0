Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f195.google.com ([209.85.128.195]:46886 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdLUPZs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Dec 2017 10:25:48 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 0/3] trace-cmd: Integrate stack tracer status in 'stat'
Date: Thu, 21 Dec 2017 17:25:17 +0200
Message-Id: <20171221152520.25867-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This short patch series makes trace-cmd stat aware of the stack tracer: now,
when the stack tracker is ON, the stat command will report that.

Vladislav Valtchev (VMware) (3):
  trace-cmd: Make read_proc() to return int status via OUT arg
  trace-cmd: Remove the die() call from read_proc()
  trace-cmd: Making stat to report when the stack tracer is ON

 trace-cmd.h   |  2 ++
 trace-stack.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 trace-stat.c  |  8 ++++++
 3 files changed, 79 insertions(+), 16 deletions(-)

-- 
2.14.1
