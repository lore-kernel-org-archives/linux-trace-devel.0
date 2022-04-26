Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE2CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Apr 2022 14:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241439AbiDZOGd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 10:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351105AbiDZOGc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 10:06:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A9DA194B3B
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Apr 2022 07:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650981802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EnkiOUcs/X4QjCPx55WSovEKwpXp0pSig3QcgoHeTyo=;
        b=GZka7ofbukNsw9rS2hPNTYwjcjYeBAcpGxE5I2axbK+oimEkg/P93puYQ0S1dOC4nGqFqs
        XisnHEq6OnR6srv/ZIsX4XGz6whIFjrMg3Sv1Jkubs7vpkw0IhyOjTWJDbhNX/zegeuQZs
        dWyTUFSDViobdEKcq2SVxF2I7CQmp2w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-lUpV6nwcPzaTl2wqcGR1xA-1; Tue, 26 Apr 2022 10:03:20 -0400
X-MC-Unique: lUpV6nwcPzaTl2wqcGR1xA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B8901815CFE
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Apr 2022 14:03:20 +0000 (UTC)
Received: from localhost (unknown [10.74.8.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE6E2C2812C;
        Tue, 26 Apr 2022 14:03:19 +0000 (UTC)
From:   vnagare@redhat.com
To:     linux-trace-devel@vger.kernel.org
Cc:     vnagare@redhat.com
Subject: [PATCH] trace-cmd: manpage: Added missing options
Date:   Tue, 26 Apr 2022 19:33:18 +0530
Message-Id: <20220426140318.221339-1-vnagare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Vaibhav Nagare <vnagare@redhat.com>

Added multiple missing options which can be found in -h, help page.

Signed-off-by: Vaibhav Nagare <vnagare@redhat.com>
---
 Documentation/trace-cmd/trace-cmd.1.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd.1.txt b/Documentation/trace-cmd/trace-cmd.1.txt
index 27c6e973..7e161273 100644
--- a/Documentation/trace-cmd/trace-cmd.1.txt
+++ b/Documentation/trace-cmd/trace-cmd.1.txt
@@ -23,9 +23,15 @@ COMMANDS
   record  - record a live trace and write a trace.dat file to the
             local disk or to the network.
 
+  set     - set a ftrace configuration parameter.
+
   report  - reads a trace.dat file and converts the binary data to a
             ASCII text readable format.
 
+  stream  - Start tracing and read the output directly
+
+  profile - Start profiling and read the output directly
+
   hist    - show a histogram of the events.
 
   stat    - show tracing (ftrace) status of the running system
@@ -42,17 +48,27 @@ COMMANDS
   extract - extract the data from the kernel buffer and create a trace.dat
             file.
 
+  show    - display the contents of one of the Ftrace Linux kernel tracing files
+
   reset   - disables all tracing and gives back the system performance.
             (clears all data from the kernel buffers)
 
+  clear   - clear the content of the Ftrace ring buffers.
+
   split   - splits a trace.dat file into smaller files.
 
   list    - list the available plugins or events that can be recorded.
 
   listen  - open up a port to listen for remote tracing connections.
 
+  agent   - listen on a vsocket for trace clients
+
+  setup-guest - create FIFOs for tracing guest VMs
+
   restore - restore the data files of a crashed run of trace-cmd record
 
+  snapshot- take snapshot of running trace
+
   stack   - run and display the stack tracer
 
   check-events - parse format strings for all trace events and return
@@ -60,6 +76,8 @@ COMMANDS
 
   convert   - convert trace files
 
+  dump    - read out the meta data from a trace file
+
 OPTIONS
 -------
 
-- 
2.27.0

