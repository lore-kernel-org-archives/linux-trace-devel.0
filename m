Return-Path: <SRS0=2r2J=WL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB09C3A59C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Aug 2019 18:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C97C2089E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Aug 2019 18:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbfHOSlD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Aug 2019 14:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728818AbfHOSlD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Aug 2019 14:41:03 -0400
Received: from oasis.local.home (rrcs-76-79-140-27.west.biz.rr.com [76.79.140.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49FCF2083B;
        Thu, 15 Aug 2019 18:41:02 +0000 (UTC)
Date:   Thu, 15 Aug 2019 14:40:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v11 0/9]  trace-cmd: Timetamps sync between host and
 guest machines, relying on vsock events.
Message-ID: <20190815144059.39f5526e@oasis.local.home>
In-Reply-To: <20190425110531.8941-1-tstoyanov@vmware.com>
References: <20190425110531.8941-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Apr 2019 14:05:22 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> [
>  v11 changes:
>   - Rebased on top of Slavomir's v10 "Add VM kernel tracing over vsockets and FIFOs"
>   - Addressed Slavomir's commnents from version 10 of the patch series.
> 
>  v10 changes:
>   - Fixed broken compilation, call to timestamp_correction_calc() in timestamp_correct
>     was smashed.
>   - Replaced deprecated tep_data_event_from_type() API with tep_find_event().
>   - Fixed a warning on assignment const to non const.
> 
>  v9 changes:
>   - Fixed implementation of binary search algorithm in timestamp_correct()
> 
>  v8 changes:
>   - Added rmdir() call in tracecmd_remove_instance(), to completely remove the instance. 
>   However, there is an issue with deleting the instances using rmdir(), which is investigated.
>   - Few changes in read_qemu_guests_pids(), timestamp_correct(), tsync_offset_load() 
>  tracecmd_clock_context_new() and find_raw_events() suggested by Slavomir. 
> 
>  v7 changes:
>   - Added warning messages in case time synchronization cannot be negotiated or fails.
>   - Few optimizations and checks in read_qemu_guests_pids(), tsync_offset_load(),
>     and find_raw_events(), suggested by Slavomir Kaslev.
>   - Reworked timestamp_correct() to not use static variables.
>   - Check TRACECMD_OPTION_TIME_SHIFT before reading time sync samples from the trace.dat file
> 
>  v6 changes:
>   - Refactored tracecmd_msg_snd_time_sync() and tracecmd_msg_rcv_time_sync() functions:
>     removed any time sync calculations logic as separate functions in trace-timesync.c file
>   - Defined TSYNC_PROBE, TSYNC_REQ and TSYNC_RESP messages, in order to make the time sync
>     protocol comprehensible.
>   - Addressed Steven Rostedt comments.
>   - Addressed Slavomir Kaslev commnets.
> 
>  v5 changes:
>   - Rebased to Slavomir's v8 "Add VM kernel tracing over vsockets and FIFOs"
>     patch series.
>   - Implemented an algorithm for time drift correction.
>   - Addressed Slavomir's commnets.
>   - Refactored the code: moved all time sync specific implementation in trace-timesync.c
>   - Isolated all hardcoded event specific stuff in a structure, so it could be easily
>     moved to external plugins.
>   - Added a check for VSOCK support: do not perform vsock dependent time synchronisation
>     in case there is no VSOCK support.
> 
>  v4 changes:
>   - Removed the implementation of PTP-like algorithm. The current
>     logic relies on matching time stamps of kvm_exit/virtio_transport_recv_pkt
>     events on host to virtio_transport_alloc_pkt/vp_notify events on guest.
>   - Rebased to Slavomir's v7 "Add VM kernel tracing over vsockets and FIFOs"
>     patch series.
>   - Decreased the time synch probes from 5000 to 300.
>   - Addressed Steven Rostedt comments.
>   - Code cleanup.
> 
>  v3 changes:
>  - Removed any magic constants, used in the PTP-like algorithm,
>    as Slavomir Kaslev suggested.
>  - Implemented new algorithm, based on mapping kvm_exit events
>    in host context to vsock_send events in guest context,
>    suggested by Steven Rostedt.
> 
>  v2 changes:
>   - Addressed Steven Rostedt comments.
>   - Modified PTP-like timestamps sync algorithm to gain more accuracy, with the
>     help of Yordan Karadzhov and Slavomir Kaslev.
> ]
> 
> POC implementation of algorithm for timestamps sync between guest and host machines.
> The algorithm relies on matching time stamps of guest and host vsock events.
> 
> The patch series depends on Slavomir's changes, introduced by the v10 patch series
> "Add VM kernel tracing over vsockets and FIFOs"

Hi Ceco,

I did a bit of playing to get this working too, and even tried to see
events that map perfectly and found the connection not that reliable.
Partly because, there could be a drift in the clocks themselves, which
exact measurement may not be as accurate. And since vsocks has a lot of
overhead between the sending and receiving, it creates a much bigger
variance and difficultly to find the best events to compare with.

I'm thinking that we should go back to your P2P patches. Could you
rebase them tomorrow and resend them?

Don't worry about making them part of the plugin work. This is still
just prototype/demo for me ;-)

Thanks!

-- Steve


> 
> Tzvetomir Stoyanov (9):
>   trace-cmd: Implemented new lib API: tracecmd_local_events_system()
>   trace-cmd: Added support for negative time offsets in trace.dat file
>   trace-cmd: Fix tracecmd_read_page_record() to read more than one event
>   trace-cmd: Added implementation of htonll() and ntohll()
>   trace-cmd: Refactored few functions in trace-record.c
>   trace-cmd: Find and store pids of tasks, which run virtual CPUs of
>     given VM
>   trace-cmd: Implemented new API tracecmd_add_option_v()
>   trace-cmd: Implemented new option in trace.dat file:
>     TRACECMD_OPTION_TIME_SHIFT
>   trace-cmd [POC]: Implemented timestamps synch algorithm, using vsock
>     events.
> 
>  include/trace-cmd/trace-cmd.h    |  31 +-
>  include/traceevent/event-parse.h |   1 +
>  lib/trace-cmd/trace-input.c      | 145 +++++-
>  lib/trace-cmd/trace-util.c       |  98 ++--
>  tracecmd/Makefile                |   1 +
>  tracecmd/include/trace-local.h   |  43 +-
>  tracecmd/include/trace-msg.h     |  10 +
>  tracecmd/trace-agent.c           |  13 +-
>  tracecmd/trace-msg.c             | 209 +++++++-
>  tracecmd/trace-output.c          | 117 ++++-
>  tracecmd/trace-read.c            |   4 +-
>  tracecmd/trace-record.c          | 229 +++++++--
>  tracecmd/trace-timesync.c        | 808 +++++++++++++++++++++++++++++++
>  13 files changed, 1575 insertions(+), 134 deletions(-)
>  create mode 100644 tracecmd/trace-timesync.c
> 

