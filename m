Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35789 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbeAPHrw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 02:47:52 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v3 0/3] Integrate stack tracer status in 'stat'
Date: Tue, 16 Jan 2018 09:47:41 +0200
Message-Id: <20180116074744.5522-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This short patch series makes trace-cmd stat aware of the stack tracer: now,
when the stack tracker is ON, the command will report that.

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
