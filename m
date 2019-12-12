Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0974FC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D32112464B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcZMEG2b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfLLJDI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:03:08 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39807 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbfLLJDI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 04:03:08 -0500
Received: by mail-lf1-f66.google.com with SMTP id y1so1086607lfb.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 01:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gC9y5Vi2lQqNZJf6Se2uz2rT5mhaFKhXP+phl5JdvNA=;
        b=QcZMEG2bnC/SUmm9tzYbMlM0DK9YcxJhXpfdRpgDLpGcwaGIJDJILDej8JQ5ub1b19
         rIxVpcOmzomD7G0nywYsJPT66E7Cn8PnTBTXWWrFoQ/xh5VBo9j7KMJ4DOR1lu5y+D5z
         6K0oXzoVc9P1PByrpnCBXQISOoiwibibw88DPWKDFdXebSkER+Pxn7Rnf2IMRymOGx+t
         fb+6NFRUQG2MZjE3CNlMIruPrvmj5ezOGNwlZh9QQwNHD9N8ogPa0mzAUazL+DDFrLzp
         FyzjOnFZ76CtooFOnDCkUZFFbAOvmxCdBvoBcohv6qrNc00Ggd5Q++TizZ3f1EN4YHHm
         UpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gC9y5Vi2lQqNZJf6Se2uz2rT5mhaFKhXP+phl5JdvNA=;
        b=Se78ZqVR9zk//FNSMgqTN3rKU5rqPplx6i9b5kCt6AY7Q66APXGUpKSW5bYsgu6jGR
         i6LGQJbBWvb2QHQBsO1X/1FklOJUFaotnW9Q1MNcKcNe54zEQeEJSzFgZnh1xp7sxxaj
         oFmqbJPA4DeJeLYOq0eucB8hQ8+zaUy7NJMBBPYLnz7n4NlCSASwlGBjE5YPReJygObc
         tQbSqwJs9NiUd0ZtbQujIDddEDdQrT8cushEZg7QzKDKh7HU9o2/cC5glHgwQy2Ua8aQ
         DkZk7Fr4k9cLDHFR0TFiY78t9STSlDQ1+QVjLfvcH/7dRZW71jh2rY0UHFCeXQsHxAhm
         Whsg==
X-Gm-Message-State: APjAAAW+ErQoEhO0PeFdkkR140T0m8HOa2/x/7k9aYcIYcogsaGOFNTE
        1Ii6SLLAcA6lJyKaIoFREKzepR2T
X-Google-Smtp-Source: APXvYqyolVADbiAYiwaeMlwsSQDhMPAajCcz0weC/TnR4nq/eZ1gQStfVBEK86JNWUo9VHJUWevjpA==
X-Received: by 2002:ac2:5444:: with SMTP id d4mr5163131lfn.49.1576141386163;
        Thu, 12 Dec 2019 01:03:06 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u16sm2849908lfi.36.2019.12.12.01.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 01:03:05 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Valentin.Schneider@arm.com,
        douglas.raillard@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/5] Adapt the sched_wakeup.py example script to use the new tracecruncher module
Date:   Thu, 12 Dec 2019 11:02:32 +0200
Message-Id: <20191212090232.24236-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212090232.24236-1-y.karadz@gmail.com>
References: <20191212090232.24236-1-y.karadz@gmail.com>
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

