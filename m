Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6CDC43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 16:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CAA820651
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 16:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ay/aycSD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfECQQJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 12:16:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41174 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfECQQJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 12:16:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id c12so8569187wrt.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 09:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+1Yy4ye0+d/sq6fO78AAMHxRgQ7a0/dLnT57DWutGDQ=;
        b=ay/aycSDr3cY5uh+/a4ols/uuy9dXyOS2JnPWRHD4Kl5sTaGKDKuVKdXH+TEbUN9xy
         mkiiAtYjiLKxmrOHzGIOk+l8BC/0+h3WIoJQApWrC1O3muX7NB1oWaidWe+Rq0xhfS7l
         AjTnu/SJOLmL1Df8ZCUHizIGR+scloqTWDH3pJbGpaAWHejbOJlDlnviTWGwWdUMUWOE
         Yj2Zsv7vBg7Iev2LisITa811HxdKR3nSH8hHxVN0uIo/cTQk/Ygob1+11c8MYROUOJGE
         MOR28F56GFPdlO/P1E1E/aT/9C/lItyPC8Ia52qKyiZTR8xNCqBabAYjz1P28hW3ZYmY
         AfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=+1Yy4ye0+d/sq6fO78AAMHxRgQ7a0/dLnT57DWutGDQ=;
        b=jK9ZPj5Z6xHEIKlKSn3f23Jp3Rxi9m5zmVxV7mF2my+vKY1UwnfDqMhBGGs/uwQZ27
         wWy9RsyTwUTbtAuHbjzGXp4Ne6gOCMtNswkG+D/vcxEJBXlTHkC8d3R0urKbqhlx2B5h
         4A+Hsrnh7x3bSkUmYI+mjZIInRI/8stOikoGZU2CB1oBkmgV5VXJLHfz/bcgUCPf56h2
         74e2PsMyPPOUjFrtkLhhIyJLy7d/qbAWqcPzaDoigaNXRd4r8zerCm02b14u3V74SYwP
         IyXgtvjvJZnyRd6X7NZ3EQoaFM/gneqE0n81f3qBP1KggSjEugI084EZLGwco1WANyJ9
         RYcA==
X-Gm-Message-State: APjAAAX0u2l1UdR3M+5n2pISdlL7MG1ytHRFb9r+v4tn+5lNGKDOMC8k
        hH6Jxs3v3f1++hNAUujPMxlURfE1
X-Google-Smtp-Source: APXvYqx6+XrIrOQe1Q+Hz6aek3dSNHn+se5Wk1W6tl0vSmLM1MdVqk5xA2G6j+acquqedICyxCgXXA==
X-Received: by 2002:adf:fb4a:: with SMTP id c10mr7469338wrs.309.1556900166916;
        Fri, 03 May 2019 09:16:06 -0700 (PDT)
Received: from planxty.redhat.com ([31.18.33.111])
        by smtp.gmail.com with ESMTPSA id a4sm3460131wmf.45.2019.05.03.09.16.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 03 May 2019 09:16:06 -0700 (PDT)
From:   John Kacur <jkacur@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH] trace-cmd: python: Apply 2to3 print transformation to python files
Date:   Fri,  3 May 2019 18:15:41 +0200
Message-Id: <20190503161541.15773-1-jkacur@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In preperation for the python plugin to work with python3,
apply the 2to3 print transformation on the python files.

In python3 print is a function so needs to be bracketted.
This is safe to do because the syntax is compatible with python2 as well

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 python/event-viewer.py | 14 +++++++-------
 python/tracecmd.py     |  6 +++---
 python/tracecmdgui.py  | 12 ++++++------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/python/event-viewer.py b/python/event-viewer.py
index c7c50d16df14..e3b2edd49491 100755
--- a/python/event-viewer.py
+++ b/python/event-viewer.py
@@ -23,7 +23,7 @@ def timing(func):
       start = time.time()
       ret = func(*arg)
       end = time.time()
-      print '@%s took %0.3f s' % (func.func_name, (end-start))
+      print('@%s took %0.3f s' % (func.func_name, (end-start)))
       return ret
   return wrapper
 
@@ -63,7 +63,7 @@ class EventStore(gtk.GenericTreeModel):
 
     @timing
     def _load_trace(self):
-        print "Building trace index..."
+        print("Building trace index...")
         index = 0
         for cpu in range(0, trace.cpus):
             rec = tracecmd_read_data(self.trace._handle, cpu)
@@ -73,7 +73,7 @@ class EventStore(gtk.GenericTreeModel):
                 self.refs.append(self.EventRef(index, ts, offset, cpu))
                 index = index + 1
                 rec = tracecmd_read_data(self.trace._handle, cpu)
-        print "Loaded %d events from trace" % (index)
+        print("Loaded %d events from trace" % (index))
 
     @timing
     def _sort(self):
@@ -217,7 +217,7 @@ class EventView(gtk.TreeView):
         elif data == "comm":
             cell.set_property("markup", ev.comm)
         else:
-            print "Unknown Column:", data
+            print("Unknown Column:", data)
             return False
 
         return True
@@ -264,9 +264,9 @@ if __name__ == "__main__":
     else:
         filename = "trace.dat"
 
-    print "Initializing trace..."
+    print("Initializing trace...")
     trace = Trace(filename)
-    print "Initializing app..."
+    print("Initializing app...")
     app = EventViewerApp(trace)
-    print "Go!"
+    print("Go!")
     gtk.main()
diff --git a/python/tracecmd.py b/python/tracecmd.py
index 677c0f2ff6c3..4d481576b9f9 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -242,13 +242,13 @@ class Trace(object):
 # Basic builtin test, execute module directly
 if __name__ == "__main__":
     t = Trace("trace.dat")
-    print "Trace contains data for %d cpus" % (t.cpus)
+    print("Trace contains data for %d cpus" % (t.cpus))
 
     for cpu in range(0, t.cpus):
-        print "CPU %d" % (cpu)
+        print("CPU %d" % (cpu))
         ev = t.read_event(cpu)
         while ev:
-            print "\t%s" % (ev)
+            print("\t%s" % (ev))
             ev = t.read_event(cpu)
 
 
diff --git a/python/tracecmdgui.py b/python/tracecmdgui.py
index 3a9f8a530414..01bfd614f1cd 100644
--- a/python/tracecmdgui.py
+++ b/python/tracecmdgui.py
@@ -48,7 +48,7 @@ def timing(func):
       start = time.time()
       ret = func(*arg)
       end = time.time()
-      print '@%s took %0.3f s' % (func.func_name, (end-start))
+      print('@%s took %0.3f s' % (func.func_name, (end-start)))
       return ret
   return wrapper
 
@@ -62,7 +62,7 @@ class EventStore(gtk.GenericTreeModel):
         self.cstore = trace_view_store_new(trace.handle)
         self.gtk_cstore = trace_view_store_as_gtk_tree_model(self.cstore)
         num_rows = trace_view_store_num_rows_get(self.cstore)
-        print "Loaded %d events from trace" % (num_rows)
+        print("Loaded %d events from trace" % (num_rows))
 
     def on_get_flags(self):
         return trace_view_store_get_flags(self.gtk_cstore)
@@ -196,7 +196,7 @@ class EventView(gtk.TreeView):
         elif data == "comm":
             cell.set_property("markup", ev.comm)
         else:
-            print "Unknown Column:", data
+            print("Unknown Column:", data)
             return False
 
         return True
@@ -231,9 +231,9 @@ if __name__ == "__main__":
     else:
         filename = "trace.dat"
 
-    print "Initializing trace..."
+    print("Initializing trace...")
     trace = Trace(filename)
-    print "Initializing app..."
+    print("Initializing app...")
     app = EventViewerApp(trace)
-    print "Go!"
+    print("Go!")
     gtk.main()
-- 
2.20.1

