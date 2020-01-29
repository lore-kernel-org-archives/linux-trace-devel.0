Return-Path: <SRS0=ilnn=3S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616D6C33CB2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 12:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 311CF2070E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 Jan 2020 12:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="llNZ2FZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgA2MFs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 07:05:48 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37648 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2MFr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 07:05:47 -0500
Received: by mail-lf1-f67.google.com with SMTP id b15so11703749lfc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Jan 2020 04:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cfkmpgBjkccVaMnnjqgLwz481tujzrF5eq3yZb1o9U8=;
        b=llNZ2FZR0zUJQlYiFMIIr2nsDSQfrnpXDsw9rXtKClhbE1h3A5wjhLtrr/fZewVSdC
         yjkx+OLmTFGtObQ1fMAf+GvD0NhL4uIbGlBPP6XWzWX54sW2i8fcQ1QdB9evl/auTMK6
         POy5kpuJIDrhZV71ch6szFtkulEIyU7FmAt9UO33RKyZtHmmWYGihmzsfjjX29jyTiMY
         Rjunw6apVxaiuH5BFARPPjZwWsXxCGqBcWAeTjBOso0ZdNwiyFNHyWDGE2m7gHd3F8lY
         GzqJ5rvjWgUPdgteGqUyy+ZQH8fRbqiKYa9tkrwNj3fO34HMRgzTb11gy38tblW+F6MQ
         E73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cfkmpgBjkccVaMnnjqgLwz481tujzrF5eq3yZb1o9U8=;
        b=Bel2At7VQU6/4q4Jd7ay08w/rA2LzSWUAVjhoK10v/4BbRriOAn6DJeh5qB/R+Lcdg
         rjm0G7EoINHh+drh4YteEB6IKCoY1YxM89rZTbWt4+859S9JzEbWx6Y+VGbTWub4H4od
         kGK7901oOaJDvCiJXn8tu4Sfr2sp3eLe7EY1y8vqaU/bcXjXfP8Xn9S7oVoEgrSshtEs
         XsLOZsoLsglD7YHnvAdDkzq/zFCO8F+yCXNvFuHxYx5yhM+QUQyGFoVZz3LRf4rCFRg8
         o6x/Ku5/s7udxVi/NhyHzOe16LyjOJSUvb5odoJ/7rVvNqMwvZx//wmLPCZ44SHXoz1y
         k2Bw==
X-Gm-Message-State: APjAAAVpQf8V5NvVh7QxzLhAhgUiHDgJYpGXPWqeKY/AFpJB17GWQhlL
        41UA52nCSCmXr6GnbJN+OdgvKOJu
X-Google-Smtp-Source: APXvYqy4TIlP+8rOhgUzlDShkiXbG6MVRI8RLRwsXpM6PKcsjhyzxTgCB51HACb2J7bnwoDjXhknmQ==
X-Received: by 2002:a19:2351:: with SMTP id j78mr5341369lfj.173.1580299545439;
        Wed, 29 Jan 2020 04:05:45 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u16sm828857ljl.34.2020.01.29.04.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 04:05:44 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Man page for trace-cmd agent
Date:   Wed, 29 Jan 2020 14:05:43 +0200
Message-Id: <20200129120543.890847-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A man page, describing trace-cmd agent sub command.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-agent.1.txt | 75 +++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 Documentation/trace-cmd-agent.1.txt

diff --git a/Documentation/trace-cmd-agent.1.txt b/Documentation/trace-cmd-agent.1.txt
new file mode 100644
index 0000000..a803d36
--- /dev/null
+++ b/Documentation/trace-cmd-agent.1.txt
@@ -0,0 +1,75 @@
+TRACE-CMD-AGENT(1)
+==================
+
+NAME
+----
+trace-cmd-agent - run trace-cmd in an agent mode
+
+SYNOPSIS
+--------
+*trace-cmd agent* ['OPTIONS']
+
+DESCRIPTION
+-----------
+The trace-cmd(1) can be used to gather simultaneously tracing information from
+host and guests virtual machines, running on that host. The trace-cmd(1) agent
+runs in the guest context, listening for incoming tracing requests from
+the host. When a request is received, the agent starts the tracing, reads the
+tracing data and streams them to the host. The host gathers tracing data from
+all guests and stores it in trace.dat files, one for each guest.
+The communication between host and guest is through VSOCKs, so the OS must
+support for it.
+
+OPTIONS
+-------
+*-p* 'port'::
+    Listen for incoming tracing requests on the specified port. The option is
+    not mandatory, by default the agent listens on port 823.
+
+*-D*::
+    Run the agent in daemon mode.
+
+*--debug*::
+    Run the agent in debug mode:
+       - no fork(), the tracing is performed in the main process
+       - no timeout when waiting for an incoming control message, wait forever
+       - print information about every sent and received control messages
+
+EXAMPLES
+--------
+
+Run the agent on the guest:
+------------------------------
+ # trace-cmd agend -D
+------------------------------
+
+Run the tracing on the host for kvm and sched events and reguest guest tracing
+for all events. The guest is addressed by its name, GuestName in this example:
+------------------------------
+# trace-cmd record -e kvm -e sched -A GuestName -e all
+------------------------------
+
+As a result of this tracing session, two trace files will be generated:
+------------------------------
+trace.dat - host tracing data
+trace-GuestName.dat - guest tracing data
+------------------------------
+
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd-record(1), trace-cmd-listen(1)
+
+AUTHOR
+------
+Written by Steven Rostedt, <rostedt@goodmis.org>
+
+RESOURCES
+---------
+git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+
+COPYING
+-------
+Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
-- 
2.24.1

