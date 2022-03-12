Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D06C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 23:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiCLXln (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 18:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiCLXlm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 18:41:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFC06B0B5
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 15:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A7560B14
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 23:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEBBC340EE;
        Sat, 12 Mar 2022 23:40:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nTBLe-000X7B-0n;
        Sat, 12 Mar 2022 18:40:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd library: Fix sparse cpu_data
Date:   Sat, 12 Mar 2022 18:40:30 -0500
Message-Id: <20220312234032.127108-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

I have a new box that has 128 logical CPUs, and when I do trace-cmd record, as
most of my CPUs are idle, they are not recorded into the CPU file.

I had a test run that only had 35 of the 128 CPUs have data, and trace-cmd
created a 35 cpu_data array to hold this information. But when I tried to load
this into KernelShark, it crashed.

It crashed because it uses the CPU number to retrieve information. Thus, when
it asked for CPU 45 and the internal trace-cmd library only had 35 cpu_data
items, it overlooked the array.

Make the array non sparse. That is, if there's only one CPU in the file, and
it's CPU 100, make an array of 101 (including CPU 0) where all the CPUs with
no data just have a cpu_data filled with zeros.

Also, fix tracecmd_read_cpu_first() return NULL if the CPU passed to it is
greater than the number of items in the cpu_data array. This is because it
would ask for cpu 64 but the last CPU with data in it was CPU 63, and
trace-cmd library only made an array of 64 (0-63) items.

Steven Rostedt (Google) (2):
  trace-cmd library: Make cpu_data[] match the cpus
  trace-cmd library: Do not read CPU greater than CPUs registered

 lib/trace-cmd/trace-input.c | 54 ++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 9 deletions(-)

-- 
2.35.1

