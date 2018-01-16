Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35628 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbeAPTyu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 14:54:50 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v4 0/3] Integrate stack tracer status in 'stat'
Date: Tue, 16 Jan 2018 21:53:40 +0200
Message-Id: <20180116195343.12800-1-vladislav.valtchev@gmail.com>
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
