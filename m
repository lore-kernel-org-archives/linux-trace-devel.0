Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756594AbeASV6F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 16:58:05 -0500
Date: Fri, 19 Jan 2018 16:58:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com
Subject: Re: [PATCH v4 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
Message-ID: <20180119165802.19daee80@gandalf.local.home>
In-Reply-To: <20180116195343.12800-2-vladislav.valtchev@gmail.com>
References: <20180116195343.12800-1-vladislav.valtchev@gmail.com>
        <20180116195343.12800-2-vladislav.valtchev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Just to let you know. I accepted all three of your patches. I have one
comment, (and changed this myself).

On Tue, 16 Jan 2018 21:53:41 +0200
"Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com> wrote:

> file and then parse it as an integer using strtol(). Then, it makes the function

This line is 80 characters. For commit logs, we recommend no more than
76 characters (some people suggest 74). The reason is that a git show
will add 4 characters, to each line of the log, and this will cause an
overflow like this:

commit 68f00f512883fa7f1d04a7d88defff5e687bd98f
Author: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
Date:   Tue Jan 16 21:53:41 2018 +0200

    trace-cmd: Make read_proc() to return int status via OUT arg

    This patch changes both the implementation and the interface of read_proc()
    in trace-stack.c. First, it makes the function to read a string from the pro
c
    file and then parse it as an integer using strtol(). Then, it makes the func
tion
    to return the integer read from the proc file using the int *status OUT
    parameter, in order to make possible its return value to be used by the call
er
    to check if the operation succeeded.

    This new implementation relaxes the external contraints the function relies
on,
    making it possible to be used by trace stat. The point is that 'stat' should
 not
    fail in case there is something wrong with the stack tracer. Only the call t
o
    die() in case the file is empty has been left in this patch: it will be remo
ved
    as well in a separate commit.


When editing a git log with the vim editor, I usually do :set tw=76

Thanks!

-- Steve
