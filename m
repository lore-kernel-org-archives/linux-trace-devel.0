Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C22AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 May 2022 00:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbiEVAjl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 May 2022 20:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbiEVAjl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 May 2022 20:39:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410B646652
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 17:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02587B80ACC
        for <linux-trace-devel@vger.kernel.org>; Sun, 22 May 2022 00:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3D6C385A9;
        Sun, 22 May 2022 00:39:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nsZdA-000p8j-Ot;
        Sat, 21 May 2022 20:39:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] trace-cmd: Fix up kvm time synchronization
Date:   Sat, 21 May 2022 20:39:31 -0400
Message-Id: <20220522003935.196466-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Fix the kvm time synchronization so that it works with the agent proxy. That
includes using "stat()" instead of just reading the content of the file to
see if they exist. Have the kvm time sync functions test for a valid VM
instead of just seeing if there are no failures, as no VMs or VCPUs would
pass when it should not. Set the proper role for the agent proxy.

Finally, mount the debugfs file system if it is not already mounted,
otherwise it will say that KVM time synchronization is not supported when it
actually is.

Steven Rostedt (Google) (4):
  trace-cmd kvm timesync: Use stat() in kvm_scaling_check_vm_cpu()
  trace-cmd kvm timesync: Check for one valid VM
  trace-cmd record: Set the proper role when connected to a proxy
  trace-cmd: Mount debugfs if needed for KVM data

 Makefile                           |  2 +-
 lib/trace-cmd/trace-timesync-kvm.c | 99 ++++++++++++++++++++++--------
 tracecmd/trace-record.c            |  6 +-
 3 files changed, 80 insertions(+), 27 deletions(-)

-- 
2.35.1

