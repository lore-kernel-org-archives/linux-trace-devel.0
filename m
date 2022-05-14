Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E94C43217
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiENCzZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DB934A37A
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EE6AB83258
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F17C34119;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XLw-8M;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 00/26] trace-cmd: Add agent proxy (agent on the host)
Date:   Fri, 13 May 2022 22:47:30 -0400
Message-Id: <20220514024756.1319681-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently the trace-cmd agent is expected to run on the guest with the host
running the recorder. There is a lot of assumptions throughout the code that
expects this. Rearrange the code and allow the guest to be the recorder and
the host act as an agent via the -P (proxy) option. The guest record can
call the agent proxy on the host with the --proxy option.

Currently this does not handle the host being a proxy for other guests, but
that will come later. For now, this code will allow the host to run the
agent and handle the time synchronizations needed between the two (and pass
the data back up to the guest). The siblings will be another project, but
for now we at least have the host agent working with the guest and having
the timings all in sync.

Joel Fernandes (1):
  trace-cmd: Move trace_msg cache file to memfd

Steven Rostedt (Google) (25):
  trace-cmd record: Make start_threads() static
  trace-cmd: Move add_guest_info() into trace-vm.c
  trace-cmd: Simplify add_guest()
  trace-cmd: Move find_pid_by_cid() into add_guest()
  trace-cmd: Move find_tasks() into add_guest()
  trace-cmd Makefile: Change test-build to link as well
  trace-cmd agent: Test if memfd_create() is available
  trace-cmd: Add kernel-doc to trace_record_agent()
  trace-cmd: Move selecting tsync protocol out of tracecmd_tsync_with_host()
  trace-cmd: Move accepting tsync connection out of tracecmd_tsync_with_host()
  trace-cmd: Have get_vsocket_params() cid and rcid parameters be optional
  trace-cmd agent: Add trace_tsync_as_guest() helper function
  trace-cmd record: Pass cpu_count instead of an instance to stop_mapping_vcpus()
  trace-cmd record: Add trace_tsync_as_host() helper
  trace-cmd: Move tsync as guest and host helpers into trace-tsync.c
  trace-cmd msg: Add PROXY communication
  trace-cmd: Add agent proxy communications between record and agent
  trace-cmd msg: Keep track of offset of flushed cache
  trace-cmd library: Add tracecmd_prepare_options()
  trace-cmd library: Add tracecmd_msg_flush_data()
  trace-cmd agent proxy: Allow agent to send more meta data after trace
  trace-cmd agent proxy: Add the remote guest cid to guest list
  trace-cmd agent-proxy: Send options at the end of the trace
  trace-cmd: Have the guest structure hold guest trace_id
  trace-cmd: Have the host agent proxy control the time synchronization

 Makefile                                      |  13 +-
 .../include/private/trace-cmd-private.h       |  35 +-
 lib/trace-cmd/include/trace-cmd-local.h       |   2 +
 lib/trace-cmd/trace-msg.c                     | 292 ++++++++++--
 lib/trace-cmd/trace-output.c                  | 243 +++++++++-
 lib/trace-cmd/trace-timesync.c                |  72 +--
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |  24 +-
 tracecmd/trace-agent.c                        | 130 ++++-
 tracecmd/trace-record.c                       | 444 +++++++-----------
 tracecmd/trace-tsync.c                        | 244 ++++++++++
 tracecmd/trace-vm.c                           | 138 +++++-
 tracecmd/trace-vsock.c                        |  32 +-
 13 files changed, 1205 insertions(+), 465 deletions(-)
 create mode 100644 tracecmd/trace-tsync.c

-- 
2.35.1

