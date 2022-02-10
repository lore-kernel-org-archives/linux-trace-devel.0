Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5692DC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbiBJPYB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:24:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243607AbiBJPYA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:24:00 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA52CE5
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:24:01 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id k41so2525320wms.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HykkqswBVdir0IJZX/zR16m0Vnc1XWPwNOVGT3uu2Ow=;
        b=C2OlM9+qTHjCxYUF7wV7wd8HjlaEJO9LP8c+anNptef5AEmYP2f7Ris5ZQn0mqlA6/
         KItVhS0LCJ3xyi+EVaY0Esz4m5Y9/sLObXPtphCiNigVU9/IAfG5mdTf9plDHOG6fNND
         omw6WIPE0JsieT6Mhak0M/dkeBpVvNNmOsPHm662IQqm2MuFu3XILfin4hoLTsQxoVqf
         JhfzU63h25NHb/8+1a784oiGmlTIAygSiMkxjRWEl9yvZcSC8bAJ382M4ZvMp31ylTSZ
         4aLIY2TNLJeBf2B6Sz/eNpjZMbTdltoZ4YYb/k552NoLol4M50vECrBmuvOU9XIiAFbl
         qSuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HykkqswBVdir0IJZX/zR16m0Vnc1XWPwNOVGT3uu2Ow=;
        b=7AO+SDBbz2QOHIJJxI3HbK84LArZQpKwFY+NHcC2B9umeSZDUQK0ZsTQzXMr0hJnvX
         XEzHZRi/XCgptHAMOlkw7J7OL7LzS6IIlgWio6t4V1jA1i4BpFEDqY+hctu3KhDLocN3
         dThEASv5UypMjpCGPxK3XJfEkqlzFQfPl5EZHNzAkrwDWwJT9Ty/nqZmeFSfoXJgeJRR
         w3YHEqVj+S7nYq36p33ahYPipXUkOS/I8ncTQTvhwhAciH9lCSr1ikpUGSW2rFD2kCxI
         fBzx/HS7DqDYPabrBvNPhiAFvg9kQeCYe0bJp2dxxwrN/RceuxyPC5HbXsw0sYuKuHlg
         sjwA==
X-Gm-Message-State: AOAM532NTNMPbdNuT275Jyv1ucMNHHMr/QqVZf1QElQ1o7REdgJijGkP
        oBOBrmqdKJL1qsqv0Dbiyw5rqcsFirQ=
X-Google-Smtp-Source: ABdhPJwGlMYafXxsAFdd8m3Kn6DbAXWAW5WLwDIPxJyIis9WNxK2kaCxZ8KGAfQFl1/ttIGPQ0hE4g==
X-Received: by 2002:a7b:c085:: with SMTP id r5mr2634558wmh.97.1644506639560;
        Thu, 10 Feb 2022 07:23:59 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:59 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 8/8] trace-cruncher: Add more comments to the examples
Date:   Thu, 10 Feb 2022 17:23:39 +0200
Message-Id: <20220210152339.363943-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210152339.363943-1-y.karadz@gmail.com>
References: <20220210152339.363943-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The changes aim to ease the understanding of the examples.
No functional changes are introduced.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/eprobe.py        | 10 +++++++++-
 examples/hist.py          | 32 ++++++++++++++++++++++++++++++++
 examples/hist_oop.py      | 14 +++++++++++---
 examples/syscall_trace.py |  2 +-
 4 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/examples/eprobe.py b/examples/eprobe.py
index a8be907..44fc7cd 100755
--- a/examples/eprobe.py
+++ b/examples/eprobe.py
@@ -11,21 +11,29 @@ import sys
 import tracecruncher.ftracepy as ft
 import tracecruncher.ft_utils as tc
 
+# Create an 'eprobe' that will be attached to the static event 'sys_enter_openat'
+# from system 'syscalls'. The probe will decode the string field of the event
+# called 'filename' and will record its content using the name 'file'.
 fields = tc.eprobe_add_string_field(name='file', target_field='filename',
                                     usr_space=True)
 event = tc.tc_event('syscalls', 'sys_enter_openat')
 eprobe = tc.tc_eprobe(name='sopen_in', target_event=event, fields=fields)
 
-tep = tc.local_tep()
+# Define a callback function that will print
+# a short human-readable version of the 'eprobe'.
 
+tep = tc.local_tep()
 def callback(event, record):
     print(tep.info(event, record))
 
+
 if __name__ == "__main__":
     if len(sys.argv) < 2:
         print('Usage: ', sys.argv[0], ' [PROCESS]')
         sys.exit(1)
 
+    # Create new Ftrace instance to work in. The tracing in this new instance
+    # is not going to be enabled yet.
     inst = ft.create_instance(tracing_on=False)
 
     # Enable the probe.
diff --git a/examples/hist.py b/examples/hist.py
index d668039..044be79 100755
--- a/examples/hist.py
+++ b/examples/hist.py
@@ -16,6 +16,20 @@ inst_name = 'khist_example'
 cmds = ['start', 'stop', 'show', 'continue', 'clear', 'close']
 
 def get_hist():
+    # From the event 'kmalloc' in system 'kmem', create a two-dimensional
+    # histogram, using the event fields 'call_site' and 'bytes_req'.
+    #
+    # The field 'call_site' will be displayed as a kernel symbol.
+    # The field 'bytes_req' will be displayed as normal field (wothout
+    # modifying the type).
+    #
+    # Instead of just recording the "hitcount" in each bin of the histogram,
+    # we will use the 'value' of 'bytes_alloc' as a weight of the individual
+    # histogram entries (events).
+    #
+    # The results will be ordered using 'bytes_req' as a primary and
+    # 'bytes_alloc' as a secondary sorting criteria. For 'bytes_req' we will
+    # use descending order.
     hist = ft.hist(name='h1',
                    system='kmem',
                    event='kmalloc',
@@ -37,30 +51,48 @@ if __name__ == "__main__":
 
     arg1 = sys.argv[1]
     if  arg1.isdigit() or arg1 == 'start':
+        # Create new Ftrace instance and a tracing histogram.
         inst = ft.create_instance(name=inst_name)
         hist = get_hist()
+
+        # Start taking data.
         hist.start(inst)
 
         if arg1.isdigit():
+            # Take data for a while, then stop, print the result, close
+            # the histogram and exit.
             time.sleep(int(arg1))
             hist.stop(inst)
             print(hist.read(inst))
             hist.close(inst)
         else:
+            # Detach the 'hist' object from the trace-cruncher module. This
+            # will prevent the kernel histogram from being destroyed when the
+            # module is closed (at exit).
             ft.detach(inst)
     else:
+        # Try to find existing Ftrace instance and histogram with the same
+        # definitions. The returned instancd is detached from the
+        # trace-cruncher module.
         inst = ft.find_instance(name=inst_name)
         hist = get_hist()
 
         if arg1 == 'stop':
+            # Stop taking data.
             hist.stop(inst)
         elif arg1 == 'show':
+            # Print the collected data.
             print(hist.read(inst))
         elif arg1 == 'continue':
+            # Continue taking data.
             hist.resume(inst)
         elif arg1 == 'clear':
+            # Reset the histogram.
             hist.clear(inst)
 
         if arg1 == 'close':
+            # Destroy the histogram in the kernel and attach the instance to
+            # the trace-cruncher module. This will ensure that the instance
+            # will be destroyed when the module is closed (at exit).
             ft.attach(inst)
             hist.close(inst)
diff --git a/examples/hist_oop.py b/examples/hist_oop.py
index 578b699..507269f 100755
--- a/examples/hist_oop.py
+++ b/examples/hist_oop.py
@@ -12,18 +12,26 @@ import time
 import tracecruncher.ft_utils as tc
 
 name = 'khist_example_oop'
-
 cmds = ['start', 'stop', 'show', 'continue', 'clear', 'close']
 
+# From the event 'kmalloc' in system 'kmem', create a two-dimensional
+# histogram, using the event fields 'call_site' and 'bytes_req'.
+# The field 'call_site' will be displayed as a kernel symbol.
+# The field 'bytes_req' will be displayed as normal field (wothout
+# modifying the type).
 evt = tc.tc_event('kmem', 'kmalloc')
-
 axes={'call_site': 'sym',
       'bytes_req': 'n'}
 
+# Instead of just recording the "hitcount" in each bin of the histogram,
+# we will use the 'value' of 'bytes_alloc' as a weight of the individual
+# histogram entries (events).
 weights=['bytes_alloc']
 
+# The results will be ordered using 'bytes_req' as a primary and
+# 'bytes_alloc' as a secondary sorting criteria. For 'bytes_req' we will
+# use descending order.
 sort_keys=['bytes_req', 'bytes_alloc']
-
 sort_dir={'bytes_req': 'desc'}
 
 if __name__ == "__main__":
diff --git a/examples/syscall_trace.py b/examples/syscall_trace.py
index bfa56ed..1117fab 100755
--- a/examples/syscall_trace.py
+++ b/examples/syscall_trace.py
@@ -19,7 +19,7 @@ args = 'file=+0($file):ustring delta_T=$delta_T:s64'
 # In order to trace a system call, we will create a synthetic event that
 # combines the 'sys_enter_XXX' and 'sys_exit_XXX' static events. A dynamic
 # 'eprobe' will be attached to this synthetic event in order to decode the
-# pointer argument of the system and to calculate the time spend between
+# pointer argument of the system call and to calculate the time spent between
 # 'sys_enter_XXX' and 'sys_exit_XXX' (syscall duration).
 
 eprobe = ft.eprobe(event=eprobe_evt,
-- 
2.32.0

