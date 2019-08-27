Return-Path: <SRS0=NWyF=WX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89288C3A5A3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 23:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66B2D205C9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 23:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfH0X21 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 19:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfH0X21 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 19:28:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DDAD205C9;
        Tue, 27 Aug 2019 23:28:25 +0000 (UTC)
Date:   Tue, 27 Aug 2019 19:28:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] Add new trace-cmd record options: "--proc-map"
Message-ID: <20190827192824.2b882bed@gandalf.local.home>
In-Reply-To: <20190814084712.28188-10-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
        <20190814084712.28188-10-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Aug 2019 11:47:09 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> New options to trace-cmd record are added:
>   - "--proc-map" - Saves traced process(es) address map in trace.dat
>     file.
>   - "--user" - Executes the traced process as given user.
> 
> As "--proc-map" option uses trace-cmd ptrace logic, part of this code is
> rewritten. There were some leftovers related to this logic, the code is
> upadted.

Hi Tzvetomir,

For some reason, this patch series ended up as part of the: Separate
trace-cmd and libtracecmd code series.

-- Steve

> 
> [
>    v5 changes:
>         - Added new patch: 
>             "Extend ptrace logic to work with multiple filtered pids"
>           It resolves "filter_pid" leftover in ptrace related logic.
>         - "--proc-map" does not depend on option -F, it works with any command,
>           specified as trace-cmd argument or option -P.
>         - Renamed "mmap" to "proc-map" - the option name and the names of
>           the functions, variables and defines related to this feature.
>    v4 changes:
> 	- Added check for strdup() failure.
> 	- Made input user string argument of change_user() and run_cmd()
> 	 constant.
>         - Added description of the new "--mmap" trace-cmd option in the 
>           program's help and the man page. (Suggested by Slavomir Kaslev)
> 
>       Problems, reported by Yordan Karadzhov:
>         - Improved the parsing of /proc/<pid>/maps. Made it not so strict, as it
>           failed on some machines due to different size of fields. 
>         - Implemented trace_pid_mmap_free() cleanup function to free mmap
>           related resources at trace-cmd exit.
>         - Fixed potential problem with non-terminated string, returned by
>           readlink().
>         - Coding style fixes.
>    v3 changes:
>       - "--user" does not depend on option -F, it works with any command,
>         specified as trace-cmd argument.
>       - Changed tracecmd_search_task_mmap() API to return not only the library
>      name, but also the start and end memory addresses.
>       - Renamed *tracee* to *task*
>       - Improved resources cleanup, in case of an error.
>       - Removed (this) changelog from the commit message.
>    v2 changes:
>      - Check for errors in change_user(). If an error occurs while
>        changing the user, the message is printed and the traced 
>        process is not executed.
>      - Replaced usage of tracecmd_add_option_v() with tracecmd_add_option() API.
>      - Added checks to prevent buffer overflow when sscanf (... "%s", buf) is used.
>      - Return error in case memory allocation fails.
>      - Return error if option string is not in the expected format.
>      - Sort memory maps and use binary search to find matching library in the map.
> ]
> 
> Tzvetomir Stoyanov (VMware) (3):
>   trace-cmd: Extend ptrace logic to work with multiple filtered pids
>   trace-cmd: Save the tracee address map into the trace.dat file.
>   trace-cmd: Add option to execute traced process as given user
> 
>  Documentation/trace-cmd-record.1.txt |   6 +
>  include/trace-cmd/trace-cmd.h        |  10 +
>  lib/trace-cmd/trace-input.c          | 172 +++++++++++++++-
>  tracecmd/include/trace-local.h       |  10 +
>  tracecmd/trace-record.c              | 282 +++++++++++++++++++++++++--
>  tracecmd/trace-usage.c               |   2 +
>  6 files changed, 464 insertions(+), 18 deletions(-)
> 

