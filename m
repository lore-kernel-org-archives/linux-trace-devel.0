Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00380C43334
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jul 2022 01:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiGHBmt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jul 2022 21:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbiGHBmt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jul 2022 21:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2828372EFE
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 18:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8631612C3
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 01:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1EBC341CD;
        Fri,  8 Jul 2022 01:42:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o9d14-002qLn-18;
        Thu, 07 Jul 2022 21:42:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Vineeth Pillai <vineethrp@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd: Fix mappings when kvm vcpus do not match the guests CPU numbers
Date:   Thu,  7 Jul 2022 21:42:42 -0400
Message-Id: <20220708014244.677826-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The guest CPU numbers may not match what the kvm enter/exit events show.
This will prevent trace-cmd from saving what host threads map to which guest
vcpu.

Luckily, it seems that the mappings are sorted. That is, the vcpuX of kvm
has the X in the same order as the CPUs numbers of the guest. And currently,
the guests see consecutive numbers (not sparse).

This adds a mapping between the vcpuX and the consective numbers that allows
trace-cmd to find the host threads that map to the guests.

Steven Rostedt (Google) (2):
  trace-cmd: Do not use KVM debug vcpu directories as the CPU mapping
  trace-cmd: Have the pid to vcpu mappings know about sparse maps

 lib/trace-cmd/trace-timesync-kvm.c | 104 ++++++++++++++++-------------
 tracecmd/trace-tsync.c             | 100 ++++++++++++++++++++++++++-
 2 files changed, 157 insertions(+), 47 deletions(-)

-- 
2.35.1

