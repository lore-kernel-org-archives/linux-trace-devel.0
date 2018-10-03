Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbeJDBFX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 21:05:23 -0400
Date: Wed, 3 Oct 2018 14:15:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Some more updates for KernelShark
Message-ID: <20181003141552.1600bfa9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Yordan,

I'm using your latest KS for doing some real work (sched_deadline patch
review so it's perfect). Two nits:

In the event description window, instead of "Cpu" it should be "CPU" as
it is a proper acronym.

Second, can you do the same thing in the task plot view that you did in
the CPU view. That is, when the mouse is not over an event, the
description should show what CPU the task is on, like you did for the
CPU plot, where it showed what task the mouse is over.

Thanks!

-- Steve
