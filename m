Return-Path: <SRS0=uIOE=MH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:51576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbeIYWmO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Sep 2018 18:42:14 -0400
Date: Tue, 25 Sep 2018 12:33:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Some issues I found with KernelShark 1.0 prototype
Message-ID: <20180925123320.71d0d580@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Yordan,

While writing my presentation I found a few slight issues that we need
to address.

 1. Need to show the task in the info window when hovering over the CPU
    plot between events, but not idle

 2. Is there a way to do a quick zoom out. When I zoom in with a lot of
    data, I find that it's quite slow to zoom back out to the original
    screen.

 3. We need a "File exists, do you want to overwrite" type dialog box
    when saving a session over a file that already exists.

 4. When restoring a session, the full path of the file being loaded
    should be shown. I noticed this because I was loading a trace.dat
    file from a different directory, and I wasn't sure which file it
    found, as I have several trace.dat files.

 5. I noticed a glitch when loading a session with both the A and B
    markers are set here only one marker was shown in the list view.
    I can put the session and trace.dat file someplace that you can
    test this if you want.

But so far it looks great! Tomorrow I'll be presenting my talk at 11am
your time. It will hopefully be live streamed if they don't have the
issues that they had at Embedded Recipes. I'll email the list the link
when I have it.

-- Steve
