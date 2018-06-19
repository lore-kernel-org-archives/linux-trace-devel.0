Return-Path: <SRS0=01Tb=JF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754162AbeFSWyL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Jun 2018 18:54:11 -0400
Date: Tue, 19 Jun 2018 18:54:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-filter: Change the hashing function used
 when filtering
Message-ID: <20180619185408.58931c8f@gandalf.local.home>
In-Reply-To: <20180619132259.21387-2-y.karadz@gmail.com>
References: <20180619132259.21387-1-y.karadz@gmail.com>
        <20180619132259.21387-2-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 19 Jun 2018 16:22:59 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The hashing function used in trace-filter-hash is changed.
> The new hashing functions is based on the Donald E. Knuth's
> Multiplicative hashing, suggested in his book "The Art of
> Computer Programming". This improves the performance, but
> also removes the restrictions resulting  from using the
> Paul Hsieh's super fast hash, published under the terms of
> the GPL 2.0 license.
> 
> Paul Hsieh's hash function, defined in trace-hash-local.h,
> is still used in trace-graph.c, trace-plot.c, trace-plot-cpu.c
> and trace-plot-task.c. Because trace-hash-local.h is no longer
> included in trace-filter-hash.h, it has to be included
> explicitly in these four source files.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---

I've applied these but haven't pushed them out yet. Which files need to
be changed from GPL to LGPL? Now that we have removed the GPL code from
the filter hash.

-- Steve
