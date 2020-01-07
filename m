Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571A8C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29ACA208C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+7QBwXU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgAGREC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:04:02 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43363 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgAGREB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:04:01 -0500
Received: by mail-lf1-f68.google.com with SMTP id 9so229214lfq.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gC9y5Vi2lQqNZJf6Se2uz2rT5mhaFKhXP+phl5JdvNA=;
        b=g+7QBwXUVS72jS8dghZZlozsq6nrF7hyD2JDCqnJpToHLZYDFR0fmrrHRulVZclBIy
         J8qqP3gQxOcaDT5h63auCQz4i1kTD48QSUKU9UGdL22isSO9iqZJB6wOfyq0BcZs8YdL
         ijDRASR/SrGmtHcbwG720AcRyS8sgkrJvxl4JpDU/z4qB9AxgwPKOOqo5wGD1WoQPcyv
         M/MThascrRshpqjgJvfQPHgpzkYI3XsGXvbWLiHOkSt8mL6SAd/39cyIanSpZdfLvY0z
         CKzvHTJj9BiJrJgTk57ld1VD1h8CtexQajaR9Cbm0yJ+HSj9RUQk/wUdNWb+K4F5kbhQ
         qLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gC9y5Vi2lQqNZJf6Se2uz2rT5mhaFKhXP+phl5JdvNA=;
        b=MXrCzCMHIyOHyKq30jNzr2/EMfou4Y/B+tqQhnfNkOE+9kp3WpF3fCvTBUUNLUoR5s
         n6GRAEu6k1HyEdX+khVZ/9lWKaa4k7kAWd0+smLa2peCTvC3JYwBIi7DKMQOnUp/Rlo7
         grUp9kQqzq9czJXcqupQMH+3jaqox4ENuiMbbUUL1QMbYgqvReIUz7FW27l36S8aZ7TV
         bKPQCaMqJpMmSRUMRiMU1MKO9Xnm8EEhD8bj80CvmVMTrLgtJP7uXDUw0FwpqeCgGe/P
         p6FjC95li6wqXm3uedcnjpAPLjuRSGXTrT/uLbR5nGIOrBBX4rofc/VdoVfz6dIFCOPG
         WT6g==
X-Gm-Message-State: APjAAAUkIePBPGdbpU0pGoN0MrfSqxrm20NsFQ87ic8xBzG+Mkabj/JF
        ntlmziBPXT4FlmmyyRSCQwNAYXwa
X-Google-Smtp-Source: APXvYqxWxvYxBCrFk/NY6fjXmvWz/bkyJbZ4zE8Bm0CBpBF+6arWaSpdG6r0vHJPKdQ2vLaMw9xSnw==
X-Received: by 2002:a19:7401:: with SMTP id v1mr245386lfe.129.1578416639164;
        Tue, 07 Jan 2020 09:03:59 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:03:58 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 05/12] trace-cruncher: Adapt sched_wakeup.py to use the new module
Date:   Tue,  7 Jan 2020 19:03:05 +0200
Message-Id: <20200107170312.27116-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/sched_wakeup.py | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/examples/sched_wakeup.py b/examples/sched_wakeup.py
index 52f2688..41e0c9c 100755
--- a/examples/sched_wakeup.py
+++ b/examples/sched_wakeup.py
@@ -15,18 +15,18 @@ import matplotlib.pyplot as plt
 import scipy.stats as st
 import numpy as np
 
-from ksharksetup import setup
-# Always call setup() before importing ksharkpy!!!
-setup()
+import tracecruncher.datawrapper as dw
+import tracecruncher.ksharkpy as ks
+import tracecruncher.ftracepy as ft
+import tracecruncher.utils as tc
 
-import ksharkpy as ks
 # Get the name of the user program.
 if len(sys.argv) >= 2:
     fname = str(sys.argv[1])
 else:
     fname = input('choose a trace file: ')
 
-status = ks.open_file(fname)
+status = ks.open(fname)
 if not status:
     print ("Failed to open file ", fname)
     sys.exit()
@@ -35,7 +35,7 @@ ks.register_plugin('reg_pid')
 
 # We do not need the Process Ids of the records.
 # Do not load the "pid" data.
-data = ks.load_data(pid_data=False)
+data = dw.load(pid_data=False)
 tasks = ks.get_tasks()
 
 # Get the name of the user program.
@@ -48,8 +48,8 @@ else:
 task_pid = tasks[prog_name][0]
 
 # Get the Event Ids of the sched_switch and sched_waking events.
-ss_eid = ks.event_id('sched', 'sched_switch')
-w_eid = ks.event_id('sched', 'sched_waking')
+ss_eid = ft.event_id('sched', 'sched_switch')
+w_eid = ft.event_id('sched', 'sched_waking')
 
 # Gey the size of the data.
 i = data['offset'].size
@@ -60,7 +60,7 @@ delta_max = i_ss_max = i_sw_max = 0
 while i > 0:
     i = i - 1
     if data['event'][i] == ss_eid:
-        next_pid = ks.read_event_field(offset=data['offset'][i],
+        next_pid = ft.read_event_field(offset=data['offset'][i],
                                        event_id=ss_eid,
                                        field='next_pid')
 
@@ -77,9 +77,9 @@ while i > 0:
                         break
 
                 if data['event'][i] == ss_eid:
-                    next_pid = ks.read_event_field(offset=data['offset'][i],
-                                       event_id=ss_eid,
-                                       field='next_pid')
+                    next_pid = ft.read_event_field(offset=data['offset'][i],
+                                                   event_id=ss_eid,
+                                                   field='next_pid')
                     if next_pid == task_pid:
                         # Second sched_switch for the same task. ?
                         time_ss = data['time'][i]
@@ -89,7 +89,7 @@ while i > 0:
                     continue
 
                 if (data['event'][i] == w_eid):
-                    waking_pid = ks.read_event_field(offset=data['offset'][i],
+                    waking_pid = ft.read_event_field(offset=data['offset'][i],
                                                      event_id=w_eid,
                                                      field='pid')
 
@@ -120,7 +120,7 @@ ax.hist(dt, bins=(100), histtype='step')
 plt.show()
 
 sname = 'sched.json'
-ks.new_session(fname, sname)
+tc.new_gui_session(fname, sname)
 
 with open(sname, 'r+') as s:
     session = json.load(s)
@@ -143,6 +143,6 @@ with open(sname, 'r+') as s:
 
     session['ViewTop'] = int(i_sw_max) - 5
 
-    ks.save_session(session, s)
+    tc.save_session(session, s)
 
 ks.close()
-- 
2.20.1

