Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:42888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756492AbeASWCf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 17:02:35 -0500
Date: Fri, 19 Jan 2018 17:02:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        y.karadz@gmail.com
Subject: Re: [PATCH v4 1/3] trace-cmd: Make read_proc() to return int status
 via OUT arg
Message-ID: <20180119170232.4da3f768@gandalf.local.home>
In-Reply-To: <20180119165802.19daee80@gandalf.local.home>
References: <20180116195343.12800-1-vladislav.valtchev@gmail.com>
        <20180116195343.12800-2-vladislav.valtchev@gmail.com>
        <20180119165802.19daee80@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 19 Jan 2018 16:58:02 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Just to let you know. I accepted all three of your patches. I have one
> comment, (and changed this myself).

Anyway,

Great job so far! I think I'm all set to start getting trace-cmd 2.7
out now. Unfortunately, I don't think I'll be able to get to that
before I leave on my next trip.

-- Steve
