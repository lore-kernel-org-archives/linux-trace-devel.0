Return-Path: <SRS0=ZWpJ=OI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbeK2NVp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 08:21:45 -0500
Date: Wed, 28 Nov 2018 21:17:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: KernelShark enhancement request
Message-ID: <20181128211800.61aa8de6@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Yordan,

Like I told you, I'm using KernelShark for actual work. One thing that
I need, is a way to undo a "hide event" or task without having to clear
all filters.

I picked an event to hide, and then after finding what I was looking
for, I wanted that event back on. But I couldn't find a way to do that
without clearing all filters.

It would be nice if the pop up menu had (perhaps at the bottom) a list
of hidden events, and the menu state something like "unhide <event>".

Would that be too hard to implement?

Thanks!

-- Steve
