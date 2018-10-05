Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbeJEXdg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 19:33:36 -0400
Date: Fri, 5 Oct 2018 12:34:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Colin McCabe <colin@cmccabe.xyz>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] tools/lib/traceevent: Replace str_error_r() with an
 open coded implementation
Message-ID: <20181005123405.60b3c9fe@gandalf.local.home>
In-Reply-To: <1538756836.4131485.1532106896.50BF1EF3@webmail.messagingengine.com>
References: <20181002175539.2ac894c7@gandalf.local.home>
        <20181005113056.55b23c31@gandalf.local.home>
        <1538756836.4131485.1532106896.50BF1EF3@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 05 Oct 2018 09:27:16 -0700
Colin McCabe <colin@cmccabe.xyz> wrote:

> Hmm.  Did you consider setting the ifdefs you can set to always get the POSIX version of strerror_r?
>

Actually, what we find the most convenient is to separate the function
out of the file completely, and undef _GNU_SOURCE, which forces glibc
to use the XSI-compliant one.

Here's the patch I used:

 https://lore.kernel.org/lkml/20181005121816.484e654f@gandalf.local.home/T/#u

-- Steve
