Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1284C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbiBJPX4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:23:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiBJPXz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:55 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E6ECE5
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:55 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id w11so10233536wra.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SdGHmMhu8+PJoMq3XEFDoZRg5SlrwLIDckWptD5n2BE=;
        b=gLtUNW9zS8EhLBPhB3Y3GhNGlrswFsfa67rJ89N34egOcJ59bjo44+8zohzA+GKTXf
         gbbH60ngMZY3s/fd66HXYONZWCvay69Jk3qERdzPVb52ySSv4TEfMPbfx23b39PlK8zy
         azYuK2m9W3HQZ1SjpGR5XHIMA83Yq1L7VmqN+tBAtNcPHHYg4f9BMIQxT9jaTmPKObTX
         qoTqPKNtD6syId/od4TjzeUlN6StwYykFz/HYjsw5I+5knYJyJ7KmsvIRflaQTICMiQm
         LiixfXCK43qVLBipYTgNpFdU/hr9a8ZPaxAjwZYFEQvst4zJYiHjmmicu8XNiixz3VaH
         UomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SdGHmMhu8+PJoMq3XEFDoZRg5SlrwLIDckWptD5n2BE=;
        b=Pxa3YFwIurRr+qzO6jlFryujs6GzHKl3m1Xyetlk8dK1SXnBBt6wHKNrVwbRL8Esjy
         gU2mLiOa+AnkRdwGqAH2ufYgvVUlxDHD7vB2+xg1jfEXZmAQjB3R0B7xRrLI5j3bRsi5
         ebCmrvBlfH+chpe80HM+ygWO+InEUp5pdbsQtAvCJbtzTI6d4rjgJ3G0qRCLfRBLEhbI
         +W69x1vAcR7g7H1cIJsv92NL78eL+QaYduoFDf5GKCa2uLgMJ1vd7nkCRK9PHc8RcjnF
         JhwOkA7exIHxWZEefQmnpG5R7D5ZYsDueVxrqB0iclxxP/tCu+Ih3Irn+AICmQe3JDxO
         UqDQ==
X-Gm-Message-State: AOAM531Nr5opGaPS+xmpDRI1UGWMHdvKNjhMsDMAhqYiT4HuMigtTd3a
        Qq+bFs3TkpeZfTozOV5Cq+FqG8aCP9g=
X-Google-Smtp-Source: ABdhPJyZ71+Pyw/zOKyl89WEIQbPb+umLaE0jqEle8e+9VA28pIbul6NvpLO/qSmCH71X5sTrPCRLQ==
X-Received: by 2002:a5d:4448:: with SMTP id x8mr6724498wrr.529.1644506633808;
        Thu, 10 Feb 2022 07:23:53 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:53 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/8] trace-cruncher: Prefix all python class names with 'tc_'
Date:   Thu, 10 Feb 2022 17:23:32 +0200
Message-Id: <20220210152339.363943-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210152339.363943-1-y.karadz@gmail.com>
References: <20220210152339.363943-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All classes defined by the high-level python APIs are renamed to
include 'tc_' prefix. This is done in order to avoid confusion with
the equivalent constructor methods, defined by the low-level APIs.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/hist_oop.py                          | 10 ++--
 examples/kprobe_open.py                       |  6 +-
 examples/synth_oop.py                         | 14 ++---
 tracecruncher/ft_utils.py                     | 47 ++++++++-------
 tracecruncher/ks_utils.py                     |  6 +-
 .../tests/1_unit/test_01_ftracepy_unit.py     | 58 +++++++++----------
 6 files changed, 74 insertions(+), 67 deletions(-)
 mode change 100644 => 100755 examples/hist_oop.py
 mode change 100644 => 100755 examples/synth_oop.py

diff --git a/examples/hist_oop.py b/examples/hist_oop.py
old mode 100644
new mode 100755
index 1a3aab6..578b699
--- a/examples/hist_oop.py
+++ b/examples/hist_oop.py
@@ -15,7 +15,7 @@ name = 'khist_example_oop'
 
 cmds = ['start', 'stop', 'show', 'continue', 'clear', 'close']
 
-evt = tc.event('kmem', 'kmalloc')
+evt = tc.tc_event('kmem', 'kmalloc')
 
 axes={'call_site': 'sym',
       'bytes_req': 'n'}
@@ -36,8 +36,8 @@ if __name__ == "__main__":
     arg1 = sys.argv[1]
     if arg1.isdigit() or arg1 == 'start':
         # Create the kernel tracing histogram.
-        hist = tc.create_khist(name=name, event=evt, axes=axes, weights=weights,
-                               sort_keys=sort_keys, sort_dir=sort_dir)
+        hist = tc.create_hist(name=name, event=evt, axes=axes, weights=weights,
+                              sort_keys=sort_keys, sort_dir=sort_dir)
         # Start taking data.
         hist.start()
 
@@ -58,8 +58,8 @@ if __name__ == "__main__":
     else:
         # Try to find an existing histogram with the same definition.
         # The returned histogram is detached from the trace-cruncher module.
-        hist = tc.find_khist(name=name, event=evt, axes=axes, weights=weights,
-                             sort_keys=sort_keys, sort_dir=sort_dir)
+        hist = tc.find_hist(name=name, event=evt, axes=axes, weights=weights,
+                            sort_keys=sort_keys, sort_dir=sort_dir)
 
         if arg1 == 'stop':
             # Stop taking data.
diff --git a/examples/kprobe_open.py b/examples/kprobe_open.py
index 141df66..8ab5ae3 100755
--- a/examples/kprobe_open.py
+++ b/examples/kprobe_open.py
@@ -38,9 +38,9 @@ fields = tc.kprobe_add_ptr_arg(name='mode',
                                fields=fields)
 
 # Create the kprobe event.
-open_probe = tc.kprobe(name='open',
-                       func='do_sys_openat2',
-                       fields=fields)
+open_probe = tc.tc_kprobe(name='open',
+                          func='do_sys_openat2',
+                          fields=fields)
 
 tep = tc.local_tep()
 tc.short_kprobe_print(tep, [open_probe])
diff --git a/examples/synth_oop.py b/examples/synth_oop.py
old mode 100644
new mode 100755
index e95f796..201e4df
--- a/examples/synth_oop.py
+++ b/examples/synth_oop.py
@@ -14,25 +14,25 @@ import tracecruncher.ft_utils as tc
 
 # Get the static kernel event 'sched_waking' and 'sched_switch' from system
 # 'sched'. Those two events will be used to create the synthetic event.
-swaking = tc.event('sched', 'sched_waking')
-sswitch = tc.event('sched', 'sched_switch')
+swaking = tc.tc_event('sched', 'sched_waking')
+sswitch = tc.tc_event('sched', 'sched_switch')
 
 # Add to the synth. event two fields from the 'start' event (sched_waking). In the
 # synth. event, the field 'target_cpu' will be renamed to 'cpu'. Use the 'pid' field
 # for matching with the corresponding 'end' event.
-start = tc.ksynth_event_item(event=swaking, fields=['target_cpu', 'prio'], match='pid')
-start = tc.ksynth_field_rename(start, field='target_cpu', name='cpu')
+start = tc.synth_event_item(event=swaking, fields=['target_cpu', 'prio'], match='pid')
+start = tc.synth_field_rename(start, field='target_cpu', name='cpu')
 
 # Add to the synth. event one field from the 'end' event (sched_switch).
 # Use the 'next_pid' field for matching with the corresponding 'start' event.
-end = tc.ksynth_event_item(event=sswitch, fields=['prev_prio'], match='next_pid')
+end = tc.synth_event_item(event=sswitch, fields=['prev_prio'], match='next_pid')
 
 # Define a synthetic event. The 'match' value will be recorder as a field in the
 # synth. event using 'pid' as name. We also add to the synth. event a field that
 # measures the time-difference between the 'start' and 'end' events. This new field
 # will use 'hd' time resolution (nanoseconds).
-synth = tc.ksynth(name='synth_wakeup', start_event=start, end_event=end,
-                  synth_fields=[tc.ksynth_field_deltaT(hd=True)], match_name='pid')
+synth = tc.tc_synth(name='synth_wakeup', start_event=start, end_event=end,
+                    synth_fields=[tc.synth_field_deltaT(hd=True)], match_name='pid')
 
 # Create new instance of Ftrace.
 inst = ft.create_instance()
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 741887b..f4d1f05 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -37,7 +37,7 @@ def short_kprobe_print(tep, events):
             tep.short_kprobe_print(id=e.evt_id, system=e.system, event=e.name)
 
 
-class event:
+class tc_event:
     def __init__(self, system, name, static=True):
         """ Constructor.
         """
@@ -81,7 +81,7 @@ class event:
                               event=self.name)
 
 
-class _kprobe_base(event):
+class _kprobe_base(tc_event):
     def __init__(self, name, func):
         """ Constructor.
         """
@@ -96,7 +96,8 @@ class _kprobe_base(event):
         self.kp.register()
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
-class kprobe(_kprobe_base):
+
+class tc_kprobe(_kprobe_base):
     def __init__(self, name, func, fields):
         """ Constructor.
         """
@@ -106,24 +107,28 @@ class kprobe(_kprobe_base):
         self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe)
         self.register()
 
+
 def kprobe_add_raw_field(name, probe, fields={}):
     """ Add a raw definition of a data field to the probe descriptor.
     """
     fields[str(name)] = str(probe)
     return fields
 
+
 def kprobe_add_arg(name, param_id, param_type, fields={}):
     """ Add a function parameter data field to the probe descriptor.
     """
     probe = '$arg{0}:{1}'.format(param_id, param_type)
     return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
 
+
 def kprobe_add_ptr_arg(name, param_id, param_type, offset=0, fields={}):
     """ Add a pointer function parameter data field to the probe descriptor.
     """
     probe = '+{0}($arg{1}):{2}'.format(offset, param_id, param_type)
     return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
 
+
 def kprobe_add_array_arg(name, param_id, param_type, offset=0,
                          size=-1, fields={}):
     """ Add an array function parameter data field to the probe descriptor.
@@ -138,6 +143,7 @@ def kprobe_add_array_arg(name, param_id, param_type, offset=0,
         probe += '($arg{0})):{1}'.format(param_id, param_type)
         return kprobe_add_raw_field(name=field_name, probe=probe, fields=fields)
 
+
 def kprobe_add_string_arg(name, param_id, offset=0, usr_space=False, fields={}):
     """ Add a string function parameter data field to the probe descriptor.
     """
@@ -148,6 +154,7 @@ def kprobe_add_string_arg(name, param_id, offset=0, usr_space=False, fields={}):
                               offset=offset,
                               fields=fields)
 
+
 def kprobe_add_string_array_arg(name, param_id, offset=0, usr_space=False,
                                 size=-1, fields={}):
     """ Add a string array function parameter data field to the probe descriptor.
@@ -160,6 +167,7 @@ def kprobe_add_string_array_arg(name, param_id, offset=0, usr_space=False,
                                 size=size,
                                 fields=fields)
 
+
 def kprobe_parse_record_array_field(event, record, field, size=-1):
     """ Parse the content of an array function parameter data field.
     """
@@ -177,7 +185,7 @@ def kprobe_parse_record_array_field(event, record, field, size=-1):
     return arr
 
 
-class kretval_probe(_kprobe_base):
+class tc_kretval_probe(_kprobe_base):
     def __init__(self, name, func):
         """ Constructor.
         """
@@ -186,7 +194,7 @@ class kretval_probe(_kprobe_base):
         self.kp.register()
 
 
-class khist:
+class tc_hist:
     def __init__(self, name, event, axes, weights=[],
                  sort_keys=[], sort_dir={}, find=False):
         """ Constructor.
@@ -282,13 +290,12 @@ class khist:
         return self.data()
 
 
-def create_khist(name, event, axes, weights=[],
-                 sort_keys=[], sort_dir={}):
+def create_hist(name, event, axes, weights=[], sort_keys=[], sort_dir={}):
     """ Create new kernel histogram.
     """
     try:
-        hist = khist(name=name, event=event, axes=axes, weights=weights,
-                     sort_keys=sort_keys, sort_dir=sort_dir, find=False)
+        hist = tc_hist(name=name, event=event, axes=axes, weights=weights,
+                       sort_keys=sort_keys, sort_dir=sort_dir, find=False)
     except Exception as err:
         msg = 'Failed to create histogram \'{0}\''.format(name)
         raise RuntimeError(msg) from err
@@ -296,20 +303,20 @@ def create_khist(name, event, axes, weights=[],
     return hist
 
 
-def find_khist(name, event, axes, instance=None,
-               weights=[], sort_keys=[], sort_dir={}):
+def find_hist(name, event, axes, weights=[], sort_keys=[], sort_dir={}):
     """ Find existing kernel histogram.
     """
     try:
-        hist = khist(name=name, event=event, axes=axes, weights=weights,
-                     sort_keys=sort_keys, sort_dir=sort_dir, find=True)
+        hist = tc_hist(name=name, event=event, axes=axes, weights=weights,
+                       sort_keys=sort_keys, sort_dir=sort_dir, find=True)
     except Exception as err:
         msg = 'Failed to find histogram \'{0}\''.format(name)
         raise RuntimeError(msg) from err
 
     return hist
 
-class ksynth(event):
+
+class tc_synth(tc_event):
     def __init__(self, name, start_event, end_event,
                  synth_fields=None, match_name=ft.no_arg()):
         """ Constructor.
@@ -380,7 +387,7 @@ class ksynth(event):
         return self.synth.repr(event=True, hist_start=True, hist_end=True)
 
 
-def ksynth_event_item(event, match, fields=[]):
+def synth_event_item(event, match, fields=[]):
     """ Create descriptor for an event item (component) of a synthetic event.
         To be used as a start/end event.
     """
@@ -393,7 +400,7 @@ def ksynth_event_item(event, match, fields=[]):
     return sub_evt
 
 
-def ksynth_field_rename(event, field, name):
+def synth_field_rename(event, field, name):
     """ Change the name of a field in the event component of a synthetic event.
     """
     pos = event['fields'].index(field)
@@ -402,7 +409,7 @@ def ksynth_field_rename(event, field, name):
     return event
 
 
-def ksynth_field_deltaT(name='delta_T', hd=False):
+def synth_field_deltaT(name='delta_T', hd=False):
     """ Create descriptor for time-diference synthetic field.
     """
     if hd:
@@ -411,19 +418,19 @@ def ksynth_field_deltaT(name='delta_T', hd=False):
     return 'delta_t {0} hd'.format(name)
 
 
-def ksynth_field_delta_start(name, start_field, end_field):
+def synth_field_delta_start(name, start_field, end_field):
     """ Create descriptor for field diference (start - end) synthetic field.
     """
     return 'delta_start {0} {1} {2}'.format(name, start_field, end_field)
 
 
-def ksynth_field_delta_end(name, start_field, end_field):
+def synth_field_delta_end(name, start_field, end_field):
     """ Create descriptor for field diference (end - start)  synthetic field.
     """
     return 'delta_end {0} {1} {2}'.format(name, start_field, end_field)
 
 
-def ksynth_field_sum(name, start_field, end_field):
+def synth_field_sum(name, start_field, end_field):
     """ Create descriptor for field sum synthetic field.
     """
     return 'sum {0} {1} {2}'.format(name, start_field, end_field)
diff --git a/tracecruncher/ks_utils.py b/tracecruncher/ks_utils.py
index 15c7835..90dca31 100644
--- a/tracecruncher/ks_utils.py
+++ b/tracecruncher/ks_utils.py
@@ -21,7 +21,7 @@ def size(data):
     raise Exception('Data size is unknown.')
 
 
-class trace_file_stream:
+class tc_file_stream:
     def __init__(self, file_name='', buffer_name='top'):
         """ Constructor.
         """
@@ -216,12 +216,12 @@ class ks_session:
 def open_file(file_name):
     """ Open a trace file for reading.
     """
-    return trace_file_stream(file_name)
+    return tc_file_stream(file_name)
 
 
 def open_buffer(file_name, buffer_name):
     """ Open a aprticular buffer in a trace file for reading.
     """
-    s = trace_file_stream()
+    s = tc_file_stream()
     s.open_buffer(file_name, buffer_name)
     return s
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 70f5d29..aea29db 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -664,8 +664,8 @@ tgr_file = '{0}/instances/{1}_inst/events/{2}/{3}/trigger'.format(ft.dir(), hist
 
 class HistOopTestCase(unittest.TestCase):
     def test_hist_create(self):
-        evt = tc.event(evt_sys, evt_name)
-        hist = tc.create_khist(name=hist_name, event=evt, axes=axes, weights=weights,
+        evt = tc.tc_event(evt_sys, evt_name)
+        hist = tc.create_hist(name=hist_name, event=evt, axes=axes, weights=weights,
                                sort_keys=sort_keys, sort_dir=sort_dir)
         f = open(tgr_file)
         h_buff = f.read()
@@ -677,8 +677,8 @@ class HistOopTestCase(unittest.TestCase):
         f.close()
 
     def test_hist_ctrl(self):
-        evt = tc.event(evt_sys, evt_name)
-        hist = tc.create_khist(name=hist_name, event=evt, axes=axes, weights=weights,
+        evt = tc.tc_event(evt_sys, evt_name)
+        hist = tc.create_hist(name=hist_name, event=evt, axes=axes, weights=weights,
                                sort_keys=sort_keys, sort_dir=sort_dir)
         f = open(tgr_file)
         h_buff = f.read()
@@ -715,32 +715,32 @@ class HistOopTestCase(unittest.TestCase):
         f.close()
 
     def test_1_detach(self):
-        evt = tc.event(evt_sys, evt_name)
-        hist = tc.create_khist(name=hist_name, event=evt, axes=axes, weights=weights,
-                               sort_keys=sort_keys, sort_dir=sort_dir)
+        evt = tc.tc_event(evt_sys, evt_name)
+        hist = tc.create_hist(name=hist_name, event=evt, axes=axes, weights=weights,
+                              sort_keys=sort_keys, sort_dir=sort_dir)
         self.assertTrue(hist.is_attached())
         hist.detach()
         self.assertFalse(hist.is_attached())
 
     def test_2_attach(self):
-        evt = tc.event(evt_sys, evt_name)
-        hist = tc.find_khist(name=hist_name, event=evt, axes=axes, weights=weights,
-                             sort_keys=sort_keys, sort_dir=sort_dir)
+        evt = tc.tc_event(evt_sys, evt_name)
+        hist = tc.find_hist(name=hist_name, event=evt, axes=axes, weights=weights,
+                            sort_keys=sort_keys, sort_dir=sort_dir)
         self.assertFalse(hist.is_attached())
         hist.attach()
         self.assertTrue(hist.is_attached())
 
     def test_hist_err(self):
-        evt = tc.event(evt_sys, evt_name)
+        evt = tc.tc_event(evt_sys, evt_name)
 
         err = 'Failed to find histogram'
         with self.assertRaises(Exception) as context:
-            hist = tc.find_khist(name=hist_name, event=evt, axes=axes, weights=weights,
-                                 sort_keys=sort_keys, sort_dir=sort_dir)
+            hist = tc.find_hist(name=hist_name, event=evt, axes=axes, weights=weights,
+                                sort_keys=sort_keys, sort_dir=sort_dir)
         self.assertTrue(err in str(context.exception))
 
 
-class SyntTestCase(unittest.TestCase):
+class SynthTestCase(unittest.TestCase):
     def test_synt_create(self):
         synth = ft.synth(name='wakeup_lat',
                          start_sys='sched', start_evt='sched_waking',
@@ -825,32 +825,32 @@ class SyntTestCase(unittest.TestCase):
         self.assertEqual('none', synth.get_filter())
         synth.unregister()
 
-swaking = tc.event('sched', 'sched_waking')
-sswitch = tc.event('sched', 'sched_switch')
+swaking = tc.tc_event('sched', 'sched_waking')
+sswitch = tc.tc_event('sched', 'sched_switch')
 
-class SyntTestCase(unittest.TestCase):
+class SynthOopTestCase(unittest.TestCase):
     def test_synt_create(self):
-        start = tc.ksynth_event_item(event=swaking,
-                                     fields=['target_cpu', 'prio'],
-                                     match='pid')
+        start = tc.synth_event_item(event=swaking,
+                                    fields=['target_cpu', 'prio'],
+                                    match='pid')
         self.assertEqual(start['fields'], ['target_cpu', 'prio'])
         self.assertEqual(start['match'], 'pid')
         self.assertEqual(start['field_names'], [None, None])
 
-        start = tc.ksynth_field_rename(start,
-                                       field='target_cpu', name='cpu')
+        start = tc.synth_field_rename(start,
+                                      field='target_cpu', name='cpu')
         self.assertEqual(start['field_names'], ['cpu', None])
 
-        end = tc.ksynth_event_item(event=sswitch,
-                                   fields=['prev_prio'],
-                                   match='next_pid')
+        end = tc.synth_event_item(event=sswitch,
+                                  fields=['prev_prio'],
+                                  match='next_pid')
         self.assertEqual(end['fields'], ['prev_prio'])
         self.assertEqual(end['match'], 'next_pid')
 
-        synth = tc.ksynth(name='synth_wakeup',
-                          start_event=start, end_event=end,
-                          synth_fields=[tc.ksynth_field_deltaT(hd=True)],
-                          match_name='pid')
+        synth = tc.tc_synth(name='synth_wakeup',
+                            start_event=start, end_event=end,
+                            synth_fields=[tc.synth_field_deltaT(hd=True)],
+                            match_name='pid')
 
         synth_str = synth.__repr__().split('\n')
         event = synth_str[0]
-- 
2.32.0

