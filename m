Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbeACRxg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:36 -0500
Message-Id: <20180103175202.044283643@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 00/38] trace-cmd: Simplify the msg handling
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The msg handling of trace-cmd for the listen and record code is
overly complex due to the multiplexing functions. Rewrite the code
such that it is easier to understand. This will allow us to extend
it in the future for the virt-server work.

-- Steve

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
trace-cmd

Head SHA1: 9420ffed51b5a1a28c175efc41fdd49507acda89


Steven Rostedt (Red Hat) (34):
      trace-cmd: Remove the creating of msg out of tracecmd_msg_send()
      trace-cmd: Move tracecmd_msg_send_and_wait_for_msg() into its only user
      trace-cmd: Turn tracecmd_msg data into an anonymous union
      trace-cmd: Remove unused structure tracecmd_msg_error
      trace-cmd: Move size and cmd in tracecmd_msg into its own header struct
      trace-cmd: Move the tracecmd_msg pointers into their own union
      trace-cmd: Just use the buf field for sending pointers
      trace-cmd: Use an array to map msg types and min sizes
      trace-cmd: Merge msg_do_write_check() into msg_write()
      trace-cmd: Simplify msg_free() by using min sizes
      trace-cmd: Add tracecmd_msg_init() helper function
      trace-cmd: Remove mulitplexer tracecmd_msg_create()
      trace-cmd: Simplify msg_read_extra()
      trace-cmd: Have msg_free() zero out msg contents
      trace-cmd: Verify RINIT was received after TINIT msg sent
      trace-cmd: Make send_metadata a flag in the output handle
      trace-cmd: Pass cpu count and port array to make_rinit()
      trace-cmd: Pass cpu_count instead of having it as a global
      trace-cmd: Pass in client_ports instead of using a global variable
      trace-cmd msg: Add debug prints of messages sent and received
      trace-cmd msg: Move the saved closing fd to the caller
      trace-cmd listen: Add better output on error of connections
      trace-cmd msg: Create a msg_handle to pass around for saved state
      trace-cmd msg: Add server structure of msg_handler
      trace-cmd: Remove global use_tcp variable
      trace-cmd: Move protocol version into msg_handler
      tracecmd: Clean up handling of cpu_count
      tracecmd listen: Have pagesize passed as return not parameter
      trace-cmd: Have cpu_count reside in instances and not be global
      trace-cmd: Add option CPUCOUNT to buffer instance options
      trace-cmd: Have msg_handle part of the buffer instance
      trace-cmd record: Allow instances to be recorded over the network
      trace-cmd: Have keep and profile be flags of buffer instance
      trace-cmd: Add network handle into buffer instance

Steven Rostedt (VMware) (4):
      trace-cmd recorder: Check if pipe_size was modified by fcntl(F_GETPIPE_SZ)
      pevent: Simplify pointer print logic and fix %pF
      pevent: Handle new pointer processing of bprint strings
      trace-cmd record: Fix clearing out the ctx->instance when used in for_all_instances()

----
 event-parse.c    |  43 ++++-
 trace-cmd.h      |  52 +++++-
 trace-input.c    |  27 ++++
 trace-listen.c   | 138 +++++++++++-----
 trace-local.h    |  15 +-
 trace-msg.c      | 486 ++++++++++++++++++++++++++++---------------------------
 trace-msg.h      |  10 --
 trace-output.c   |  38 ++++-
 trace-record.c   | 391 +++++++++++++++++++++++++++-----------------
 trace-recorder.c |   7 +-
 trace-stat.c     |   2 +-
 11 files changed, 741 insertions(+), 468 deletions(-)
