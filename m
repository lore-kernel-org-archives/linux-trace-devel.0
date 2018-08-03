Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbeHCR5t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 13:57:49 -0400
Date: Fri, 3 Aug 2018 12:00:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180803120052.2f1a0e64@gandalf.local.home>
In-Reply-To: <f89ed00a-2411-7540-bfea-8c40a6d3dcac@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
        <20180731135248.30587-4-y.karadz@gmail.com>
        <20180801144413.227e0dea@gandalf.local.home>
        <f89ed00a-2411-7540-bfea-8c40a6d3dcac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 3 Aug 2018 17:01:45 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steven,
> I have tried implementing this, but it becomes a bit ugly in the 
> following patches where the single request is transformed into a linked 
> list of requests.

OK. Then let's not implement it, and see if we can clean it up later
after most of the changes have been made. I was hoping that it would
make the later patches better, but if that's not the case, then let's
ditch the idea.

-- Steve
