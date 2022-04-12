Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE763C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Apr 2022 12:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiDLMeg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 08:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352940AbiDLMd3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 08:33:29 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1EC5C375
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Apr 2022 04:52:25 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id u3so27371419wrg.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Apr 2022 04:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uyffwv8HIqK7M8QTRlEkhikxPrldxRlmnGT07o+eeAY=;
        b=qRzBQMxGN8KK1csoLDOGWwFSUZ9R41/2LO4Zzo+PoMvs5bmqsA/c3t2JeFbR5SuHJN
         XpOzX/bJ/NPai3zVC4zyce3qcaZwGDGzRUFjjBCofv7A5a3rtzmZxWxiyXqZhgqqPgHp
         0ooTUBD88oe5VB7pE+/SXA/s8NDDpd5KFqmM9wx8HQ2RLyXX7GH3ljrRQG9+ldjOQOuN
         1utG05AZy4haPiD2rFtLJJMj5LGfd1uDjoCqp6iM9mmyC3J6qpH3xBYxhKkNzjoA5ju/
         bXaBGyuQov8LCNwlf3rLY62RUK2Ew/c2JwS3jvhN2RizUsJmW0vkfVG67k4Ydw1k9Uw/
         st7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uyffwv8HIqK7M8QTRlEkhikxPrldxRlmnGT07o+eeAY=;
        b=XqJMhE7JsCwg/y7PaE+9hvTn6wDkh67BZ9uwVxiPWIsFigmMcBLAT+JjO9WrgCLHGP
         +/jqS9Od41lqkySmekbHJA5PMnjutZxFM/DpjtL6GXSIFZJ+WXM3l+/1DPjGqEuRhMAz
         mmAZNz8ibhUdg+SBai3JOWlYWx5HdPLCywvn1EhTzAZ1+DSu7crB9DmPgf45ApeeKbZ9
         32Bx6je9mbMvHfb1Fe/LbVU9Gm1yklnWP0V/0/EOPR51sn4vU5oBaFhVdQev213C4qsu
         i34vznV54QwBpGqrP0vzM48qFWTnu033raFmntTmtxX73sJtA9oYthzIhpp+FpZlwThy
         1pcg==
X-Gm-Message-State: AOAM531yzDVdhYhI3vkg891O7znre1Bpe+yn22EbZ7fN4YZ9eNNSKcvg
        hkt0bVNiou0D+zLWWerQhkBQAR+EGlk=
X-Google-Smtp-Source: ABdhPJz7jnt2KhfXVo4AufA1jANlBj1aQyGMsfzuFxF2x1iboU/9DNceq2rSRNlcL51UdwLfa0mGOA==
X-Received: by 2002:a5d:468b:0:b0:207:a1c9:391c with SMTP id u11-20020a5d468b000000b00207a1c9391cmr11433370wrq.331.1649764343325;
        Tue, 12 Apr 2022 04:52:23 -0700 (PDT)
Received: from crow.. (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d6d0e000000b002078ea4f6bdsm14148750wrq.75.2022.04.12.04.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 04:52:22 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Add documentation for tracecruncher.ft_utils
Date:   Tue, 12 Apr 2022 14:51:50 +0300
Message-Id: <20220412115150.513744-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220412115150.513744-1-y.karadz@gmail.com>
References: <20220412115150.513744-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Python style documentation for the 'ft_utils' submodule is added.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile                  |   1 +
 tracecruncher/ft_utils.py | 625 +++++++++++++++++++++++++++++++++++---
 2 files changed, 578 insertions(+), 48 deletions(-)

diff --git a/Makefile b/Makefile
index ff9979b..52428c0 100644
--- a/Makefile
+++ b/Makefile
@@ -39,6 +39,7 @@ doc:
 	@ echo ${CYAN}Buildinging trace-cruncher documentation:${NC};
 	@ python3 $(DOCDIR)/setup.py builtins
 	@ sudo python3 $(DOCDIR)/setup.py tracecruncher.ftracepy $(UID) $(GID)
+	@ sudo python3 $(DOCDIR)/setup.py tracecruncher.ft_utils $(UID) $(GID)
 
 clean_doc:
 	@ rm -f $(DOCDIR)/*.html
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index f0bed95..38d5acb 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -12,7 +12,13 @@ from . import ftracepy as ft
 
 
 def local_tep():
-    """ Get the "tep" event of the current system (local).
+    """
+    Get the "tep" event of the current system (local).
+
+    Returns
+    -------
+    object : PyTep
+        Local tep handle.
     """
     tep = ft.tep_handle()
     tep.init_local(dir=ft.dir())
@@ -21,7 +27,20 @@ def local_tep():
 
 
 def find_event_id(system, event):
-    """ Get the unique identifier of a trace event.
+    """
+    Get the unique identifier of a trace event.
+
+    Parameters
+    ----------
+    system : string
+        The system of the event.
+    event : string
+        The name of the event.
+
+    Returns
+    -------
+    id : int
+        Id number.
     """
     tep = ft.tep_handle()
     tep.init_local(dir=ft.dir(), systems=[system])
@@ -30,7 +49,15 @@ def find_event_id(system, event):
 
 
 def short_kprobe_print(tep, events):
-    """ Register short (no probe address) print for these kprobe events.
+    """
+    Register short (no probe address) print for these kprobe events.
+
+    Parameters
+    ----------
+    tep : PyTep
+        Local tep handle.
+    events : list of PyTepEvent
+        List of kprobe events.
     """
     for e in events:
         if len(e.fields):
@@ -38,8 +65,30 @@ def short_kprobe_print(tep, events):
 
 
 class tc_event:
+    """
+    A class used to represent a tracing event.
+
+    Attributes
+    ----------
+    system : string
+        The system of the event.
+    event:
+        The name of the event.
+    id : int
+        The unique Id of the event.
+    """
     def __init__(self, system, name, static=True):
-        """ Constructor.
+        """
+        Constructor
+
+        Parameters
+        ----------
+        system : string
+            The system of the event.
+        event : string
+            The name of the event.
+        static : bool
+            Is it a static or dynamic event.
         """
         self.system = system
         self.name = name
@@ -51,22 +100,43 @@ class tc_event:
             self.evt_id = -1
 
     def id(self):
-        """ Retrieve the unique ID of the event.
+        """
+        Retrieve the unique ID of the event.
         """
         return int(self.evt_id)
 
     def enable(self, instance=ft.no_arg()):
-        """ Enable this event.
+        """
+        Enable this event.
+
+        Parameters
+        ----------
+        instance : PyTfsInstance (optional)
+            The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.
         """
         ft.enable_event(instance=instance, system=self.system, event=self.name)
 
     def disable(self, instance=ft.no_arg()):
-        """ Disable this event.
+        """
+        Disable this event.
+
+        Parameters
+        ----------
+        instance : PyTfsInstance (optional)
+            The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.
         """
         ft.disable_event(instance=instance,system=self.system, event=self.name)
 
     def set_filter(self, filter, instance=ft.no_arg()):
-        """ Define a filter for this event.
+        """
+        Define a filter for this event.
+
+        Parameters
+        ----------
+        filter : string
+            The filter descriptor.
+        instance : PyTfsInstance (optional)
+            The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.
         """
         ft.set_event_filter(instance=instance,
                             system=self.system,
@@ -74,7 +144,13 @@ class tc_event:
                             filter=filter)
 
     def clear_filter(self, instance=ft.no_arg()):
-        """ Clear the filter for this event.
+        """
+        Clear the filter for this event.
+
+        Parameters
+        ----------
+        instance : PyTfsInstance (optional)
+            The Ftrace instance. This argument is optional. If not provided, the 'top' instance is used.
         """
         ft.clear_event_filter(instance=instance,
                               system=self.system,
@@ -82,41 +158,104 @@ class tc_event:
 
 
 class _dynevent(tc_event):
+    """
+    A class used to represent a dynamic tracing event.
+
+    Attributes
+    ----------
+    evt : PyDynevent
+        Low-level dynamic event object.
+    fields : dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
+    """
     def __init__(self, name):
-        """ Constructor.
+        """
+        Constructor
+
+        Parameters
+        ----------
+        name : string
+            The name of the event.
         """
         super().__init__(system=ft.tc_event_system(), name=name, static=False)
         self.evt = None
+        self.fields = None
         self.evt_id = -1
 
     def register(self):
-        """ Register this probe to Ftrace.
+        """
+        Register this probe to Ftrace.
         """
         self.evt.register()
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
 class _kprobe_base(_dynevent):
+    """
+    Base class used to represent a kprobe or kretval probe.
+
+    Attributes
+    ----------
+    func : string
+        Name of a function or address to attach the probe to.
+    """
     def __init__(self, name, func):
-        """ Constructor.
+        """
+        Constructor.
+
+        Parameters
+        ----------
+        name : string
+            The name of the kprobe event.
+        func: string
+            Name of a function or address.
         """
         super().__init__(name=name)
         self.func = func
 
 
 class tc_kprobe(_kprobe_base):
+    """
+    A class used to represent a kprobe event.
+    """
     def __init__(self, name, func, fields):
-        """ Constructor.
+        """
+        Constructor
+
+        Parameters
+        ----------
+        name : string
+            The name of the kprobe event.
+        func: string
+            Name of a function or address.
+        fields: dictionary (string : string)
+            Key - kprobe field name, value - definition of the probe.
         """
         super().__init__(name, func)
         self.fields = fields
-        probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
+        probe = ' '.join('{!s}={!s}'.format(key, val) for (key, val) in self.fields.items())
         self.evt = ft.kprobe(event=self.name, function=self.func, probe=probe)
         self.register()
 
 
 def kprobe_add_raw_field(name, probe, fields=None):
-    """ Add a raw definition of a data field to the probe descriptor.
+    """
+    Add a raw definition of a data field to the probe descriptor.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kprobe event.
+    probe : string
+        Definition of the probe.
+    fields : dictionary (string : string)
+        Input location for a probe descriptor. If provided, the new field will be added to it.
+        Otherwise new probe descriptor will be generated.
+
+    Returns
+    -------
+    fields: dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
     """
     if fields is None:
         fields = {}
@@ -126,14 +265,58 @@ def kprobe_add_raw_field(name, probe, fields=None):
 
 
 def kprobe_add_arg(name, param_id, param_type, fields=None):
-    """ Add a function parameter data field to the probe descriptor.
+    """
+    Add a function parameter data field to the probe descriptor.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kprobe event.
+    param_id : int
+        The number of the function parameter to be recorded.
+    param_type : string
+        The type of the function parameter to be recorded. Following types are supported:
+           * Basic types (u8/u16/u32/u64/s8/s16/s32/s64)
+           * Hexadecimal types (x8/x16/x32/x64)
+           * "string" and "ustring"
+    fields : dictionary (string : string)
+        Input location for a probe descriptor. If provided, the new field will be added to it.
+        Otherwise new probe descriptor will be generated.
+
+    Returns
+    -------
+    fields: dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
     """
     probe = '$arg{0}:{1}'.format(param_id, param_type)
     return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
 
 
 def kprobe_add_ptr_arg(name, param_id, param_type, offset=0, fields=None):
-    """ Add a pointer function parameter data field to the probe descriptor.
+    """
+    Add a pointer function parameter data field to the probe descriptor.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kprobe event.
+    param_id : int
+        The number of the function parameter to be recorded.
+    param_type : string
+        The type of the function parameter to be recorded. Following types are supported:
+           * Basic types (u8/u16/u32/u64/s8/s16/s32/s64)
+           * Hexadecimal types (x8/x16/x32/x64)
+           * "string" and "ustring"
+    offset : int
+        Memory offset of the function parameter's field.
+    fields : dictionary (string : string)
+        Input location for a probe descriptor. If provided, the new field will be added to it.
+        Otherwise new probe descriptor will be generated.
+
+    Returns
+    -------
+    fields: dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
     """
     probe = '+{0}($arg{1}):{2}'.format(offset, param_id, param_type)
     return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
@@ -141,7 +324,32 @@ def kprobe_add_ptr_arg(name, param_id, param_type, offset=0, fields=None):
 
 def kprobe_add_array_arg(name, param_id, param_type, offset=0,
                          size=-1, fields=None):
-    """ Add an array function parameter data field to the probe descriptor.
+    """
+    Add an array function parameter data field to the probe descriptor.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kprobe event.
+    param_id : int
+        The number of the function parameter to be recorded.
+    param_type : string
+        The type of the function parameter to be recorded. Following types are supported:
+           * Basic types (u8/u16/u32/u64/s8/s16/s32/s64)
+           * Hexadecimal types (x8/x16/x32/x64)
+           * "string" and "ustring"
+    offset : int
+        Memory offset of the function parameter's field.
+    size : int
+        The size of the array. If not provided, 10 array elements are recorded.
+    fields : dictionary (string : string)
+        Input location for a probe descriptor. If provided, the new field will be added to it.
+        Otherwise new probe descriptor will be generated.
+
+    Returns
+    -------
+    fields: dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
     """
     if size < 0:
         size = 10
@@ -155,7 +363,27 @@ def kprobe_add_array_arg(name, param_id, param_type, offset=0,
 
 
 def kprobe_add_string_arg(name, param_id, offset=0, usr_space=False, fields=None):
-    """ Add a string function parameter data field to the probe descriptor.
+    """
+    Add a string function parameter data field to the probe descriptor.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kprobe event.
+    param_id : int
+        The number of the function parameter to be recorded.
+    offset : int
+        Memory offset of the function parameter's field.
+    usr_space : bool
+        Is this a 'user space' or a 'kernel space' parameter.
+    fields : dictionary (string : string)
+        Input location for a probe descriptor. If provided, the new field will be added to it.
+        Otherwise new probe descriptor will be generated.
+
+    Returns
+    -------
+    fields: dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
     """
     p_type = 'ustring' if usr_space else 'string'
     return kprobe_add_ptr_arg(name=name,
@@ -167,7 +395,29 @@ def kprobe_add_string_arg(name, param_id, offset=0, usr_space=False, fields=None
 
 def kprobe_add_string_array_arg(name, param_id, offset=0, usr_space=False,
                                 size=-1, fields=None):
-    """ Add a string array function parameter data field to the probe descriptor.
+    """
+    Add a string array function parameter data field to the probe descriptor.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kprobe event.
+    param_id : int
+        The number of the function parameter to be recorded.
+    offset : int
+        Memory offset of the function parameter's field.
+    usr_space : bool
+        Is this a 'user space' or a 'kernel space' parameter.
+    size : int
+        The size of the array. If not provided, 10 array elements are recorded.
+    fields : dictionary (string : string)
+        Input location for a probe descriptor. If provided, the new field will be added to it.
+        Otherwise new probe descriptor will be generated.
+
+    Returns
+    -------
+    fields: dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
     """
     p_type = 'ustring' if usr_space else 'string'
     return kprobe_add_array_arg(name=name,
@@ -179,7 +429,20 @@ def kprobe_add_string_array_arg(name, param_id, offset=0, usr_space=False,
 
 
 def kprobe_parse_record_array_field(event, record, field, size=-1):
-    """ Parse the content of an array function parameter data field.
+    """
+    Parse the content of an array function parameter data field.
+
+    Parameters
+    ----------
+    event : PyTepEvent
+        The event descriptor.
+    record : PyTepRecord
+        The record.
+
+    Returns
+    -------
+    fields : list of int or string
+        The values of the array field.
     """
     if size < 0:
         size = 10
@@ -196,8 +459,19 @@ def kprobe_parse_record_array_field(event, record, field, size=-1):
 
 
 class tc_kretval_probe(_kprobe_base):
+    """
+    A class used to represent a kretval probe.
+    """
     def __init__(self, name, func):
-        """ Constructor.
+        """
+        Constructor.
+
+        Parameters
+        ----------
+        name : string
+            The name of the kprobe event.
+        func: string
+            Name of a function or address.
         """
         super().__init__(name, func)
         self.evt = ft.kprobe(event=self.name, function=self.func)
@@ -205,8 +479,26 @@ class tc_kretval_probe(_kprobe_base):
 
 
 class tc_eprobe(_dynevent):
+    """
+    A class used to represent an event probe.
+
+    Attributes
+    ----------
+    target_event : tc_event
+        The event to attach the probe to.
+    """
     def __init__(self, name, target_event, fields):
-        """ Constructor.
+        """
+        Constructor.
+
+        Parameters
+        ----------
+        name : string
+            The name of the kprobe event.
+        target_event : tc_event
+            The event to attach the probe to.
+        fields : dictionary (string : string)
+            Key - eprobe field name, value - definition of the probe.
         """
         super().__init__(name=name)
         self.target_event = target_event
@@ -220,14 +512,55 @@ class tc_eprobe(_dynevent):
 
 
 def eprobe_add_ptr_field(name, target_field, field_type, offset=0, fields=None):
-    """ Add a pointer data field to the eprobe descriptor.
+    """
+    Add a pointer data field to the eprobe descriptor.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kprobe event.
+    param_id : int
+        The number of the function parameter to be recorded.
+    field_type : string
+        The type of the event field to be recorded. Following types are supported:
+           * Basic types (u8/u16/u32/u64/s8/s16/s32/s64)
+           * Hexadecimal types (x8/x16/x32/x64)
+           * "string" and "ustring"
+    offset : int
+        Memory offset of the function parameter's field.
+    fields : dictionary (string : string)
+        Input location for a probe descriptor. If provided, the new field will be added to it.
+        Otherwise new probe descriptor will be generated.
+
+    Returns
+    -------
+    fields: dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
     """
     probe = '+{0}(${1}):{2}'.format(offset, target_field, field_type)
     return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
 
 
 def eprobe_add_string_field(name, target_field, offset=0, usr_space=False, fields=None):
-    """ Add a string data field to the eprobe descriptor.
+    """
+    Add a string data field to the eprobe descriptor.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kprobe event.
+    param_id : int
+        The number of the function parameter to be recorded.
+    offset : int
+        Memory offset of the function parameter's field.
+    fields : dictionary (string : string)
+        Input location for a probe descriptor. If provided, the new field will be added to it.
+        Otherwise new probe descriptor will be generated.
+
+    Returns
+    -------
+    fields: dictionary (string : string)
+        Key - kprobe field name, value - definition of the probe.
     """
     f_type = 'ustring' if usr_space else 'string'
     return eprobe_add_ptr_field(name=name,
@@ -238,9 +571,54 @@ def eprobe_add_string_field(name, target_field, offset=0, usr_space=False, field
 
 
 class tc_hist:
+    """
+    A class used to represent a kernel histogram.
+
+    Attributes
+    ----------
+    name:
+        The name of the histogram.
+    inst : PyTfsInstance
+        The unique Ftrace instance used by the histogram.
+    attached : bool
+        Is this object attached to the Python module.
+    hist : PyTraceHist
+        Low-level kernel histogram object.
+    trigger : string
+        Path to the trigger file of the histogram.
+    """
     def __init__(self, name, event, axes, weights,
                  sort_keys, sort_dir, find=False):
-        """ Constructor.
+        """
+        Constructor.
+
+        Parameters
+        ----------
+        name : string
+            The name of the kernel histogram.
+        event : tc_event
+            The event to attach the histogram to.
+        axes : dictionary (string : string or int) (optional)
+            Definition of the histogram.
+            Key - name of a field from the histogram's event.
+            Value - the type of the probe. The following types are supported:
+                'normal', 'n' or 0 for displaying a number;
+                'hex', 'h' or 1 for displaying a number as a hex value;
+                'sym' or 2 for displaying an address as a symbol;
+                'sym_offset', 'so' or 3 for displaying an address as a symbol and offset;
+                'syscall', 'sc' or 4 for displaying a syscall id as a system call name;
+                'execname', 'e' or 5 for displaying a common_pid as a program name;
+                'log', 'l' or 6 for displaying log2 value rather than raw number;
+        weights : string
+            Event field name, to be used as a weight of the individual histogram entries.
+        sort_keys : string or list of strings
+            The keys to sort.
+        sort_dir : dictionary (string :int or string )
+            Key - histogram's key to set sort direction, val - direction.
+                Use 0, 'a', 'asc' or 'ascending' for sorting in ascending direction.
+                Use 1, 'd', 'desc' or 'descending' for sorting in descending direction.
+        find : bool
+            Find an existing histogram or create a new one.
         """
         self.name = name
         self.inst = None
@@ -272,69 +650,109 @@ class tc_hist:
                                                            event.name)
 
         if not find:
-            # Put the kernel histogram on 'standby'
+            # Put the kernel histogram on 'standby'.
             self.hist.stop(self.inst)
 
     def __del__(self):
-        """ Destructor.
+        """
+        Destructor.
         """
         if self.inst and self.attached:
             self.clear()
 
     def start(self):
-        """ Start accumulating data.
+        """
+        Start accumulating data.
         """
         self.hist.resume(self.inst)
 
     def stop(self):
-        """ Stop accumulating data.
+        """
+        Stop accumulating data.
         """
         self.hist.stop(self.inst)
 
     def resume(self):
-        """ Continue accumulating data.
+        """
+        Continue accumulating data.
         """
         self.hist.resume(self.inst)
 
     def data(self):
-        """ Read the accumulated data.
+        """
+        Read the accumulated data.
         """
         return self.hist.read(self.inst)
 
     def clear(self):
-        """ Clear the accumulated data.
+        """
+        Clear the accumulated data.
         """
         self.hist.clear(self.inst)
 
     def detach(self):
-        """ Detach the object from the Python module.
+        """
+        Detach the object from the Python module.
         """
         ft.detach(self.inst)
         self.attached = False
 
     def attach(self):
-        """ Attach the object to the Python module.
+        """
+        Attach the object to the Python module.
         """
         ft.attach(self.inst)
         self.attached = True
 
     def is_attached(self):
-        """ Check if the object is attached to the Python module.
+        """
+        Check if the object is attached to the Python module.
         """
         return self.attached
 
     def __repr__(self):
-        """ Read the descriptor of the histogram.
+        """
+        Read the descriptor of the histogram.
         """
         with open(self.trigger) as f:
             return f.read().rstrip()
 
     def __str__(self):
+        """
+        Read the accumulated data.
+        """
         return self.data()
 
 
 def create_hist(name, event, axes, weights=None, sort_keys=None, sort_dir=None):
-    """ Create new kernel histogram.
+    """
+    Create new kernel histogram.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kernel histogram.
+    event : tc_event
+        The event to attach the histogram to.
+    axes : dictionary (string : string or int) (optional)
+        Definition of the histogram.
+        Key - name of a field from the histogram's event.
+        Value - the type of the probe. The following types are supported:
+            'normal', 'n' or 0 for displaying a number;
+            'hex', 'h' or 1 for displaying a number as a hex value;
+            'sym' or 2 for displaying an address as a symbol;
+            'sym_offset', 'so' or 3 for displaying an address as a symbol and offset;
+            'syscall', 'sc' or 4 for displaying a syscall id as a system call name;
+            'execname', 'e' or 5 for displaying a common_pid as a program name;
+            'log', 'l' or 6 for displaying log2 value rather than raw number;
+    weights : string
+        Event field name, to be used as a weight of the individual histogram entries.
+    sort_keys : string or list of strings
+        The keys to sort.
+    sort_dir : dictionary (string :int or string )
+        Key - histogram's key to set sort direction, val - direction.
+            Use 0, 'a', 'asc' or 'ascending' for sorting in ascending direction.
+            Use 1, 'd', 'desc' or 'descending' for sorting in descending direction.
     """
     if weights is None:
         weights = []
@@ -356,7 +774,34 @@ def create_hist(name, event, axes, weights=None, sort_keys=None, sort_dir=None):
 
 
 def find_hist(name, event, axes, weights=None, sort_keys=None, sort_dir=None):
-    """ Find existing kernel histogram.
+    """
+    Find existing kernel histogram.
+
+    Parameters
+    ----------
+    name : string
+        The name of the kernel histogram.
+    event : tc_event
+        The event to attach the histogram to.
+    axes : dictionary (string : string or int) (optional)
+        Definition of the histogram.
+        Key - name of a field from the histogram's event.
+        Value - the type of the probe. The following types are supported:
+            'normal', 'n' or 0 for displaying a number;
+            'hex', 'h' or 1 for displaying a number as a hex value;
+            'sym' or 2 for displaying an address as a symbol;
+            'sym_offset', 'so' or 3 for displaying an address as a symbol and offset;
+            'syscall', 'sc' or 4 for displaying a syscall id as a system call name;
+            'execname', 'e' or 5 for displaying a common_pid as a program name;
+            'log', 'l' or 6 for displaying log2 value rather than raw number;
+    weights : string
+        Event field name, to be used as a weight of the individual histogram entries.
+    sort_keys : string or list of strings
+        The keys to sort.
+    sort_dir : dictionary (string :int or string )
+        Key - histogram's key to set sort direction, val - direction.
+            Use 0, 'a', 'asc' or 'ascending' for sorting in ascending direction.
+            Use 1, 'd', 'desc' or 'descending' for sorting in descending direction.
     """
     if weights is None:
         weights = []
@@ -378,9 +823,35 @@ def find_hist(name, event, axes, weights=None, sort_keys=None, sort_dir=None):
 
 
 class tc_synth(tc_event):
+    """
+    A class used to represent a kernel histogram.
+
+    Attributes
+    ----------
+    synth:
+        Low-level synthetic event object.
+    """
     def __init__(self, name, start_event, end_event,
                  synth_fields=None, match_name=ft.no_arg()):
-        """ Constructor.
+        """
+        Constructor.
+
+        Parameters
+        ----------
+        name : string
+            The name of the synthetic event.
+        start_event : dictionary
+            Start event descriptor. To be generated using synth_event_item().
+        end_event : dictionary
+            End event descriptor. To be generated using synth_event_item().
+        synth_fields : list of strings
+            Synthetic field descriptors. Each of the descriptors be generated using:
+                - synth_field_deltaT()
+                - synth_field_delta_start()
+                - synth_field_delta_end()
+                - synth_field_sum()
+        match_name : string
+            If used, the match value will be recorded as a field, using the name provided.
         """
         super().__init__(system='synthetic', name=name, static=False)
         self.synth = ft.synth(name,
@@ -448,14 +919,25 @@ class tc_synth(tc_event):
         self.evt_id = find_event_id(system=self.system, event=self.name)
 
     def __repr__(self):
-        """ Read the descriptor of the synthetic event.
+        """
+        Read the descriptor of the synthetic event.
         """
         return self.synth.repr(event=True, hist_start=True, hist_end=True)
 
 
 def synth_event_item(event, match, fields=None):
-    """ Create descriptor for an event item (component) of a synthetic event.
-        To be used as a start/end event.
+    """
+    Create descriptor for an event item (component) of a synthetic event.
+    To be used as a start/end event.
+
+    Parameters
+    ----------
+    event : tc_event
+        An event to attach the synthetic event to.
+    match : string
+        Field from the event to be used for matching.
+    fields : list of strings
+        Fields from the event to be recorded.
     """
     if fields is None:
         fields = []
@@ -470,7 +952,15 @@ def synth_event_item(event, match, fields=None):
 
 
 def synth_field_rename(event, field, name):
-    """ Change the name of a field in the event component of a synthetic event.
+    """
+    Change the name of a field in the event component of a synthetic event.Parameters
+    ----------
+    event : dictionary
+        Event descriptor, generated using synth_event_item().
+    field : string
+        The original name of the field to be renamed.
+    name : string
+        New name for the field.
     """
     pos = event['fields'].index(field)
     event['field_names'][pos] = name
@@ -479,25 +969,64 @@ def synth_field_rename(event, field, name):
 
 
 def synth_field_deltaT(name='delta_T', hd=False):
-    """ Create descriptor for time-diference synthetic field.
+    """
+    Create descriptor for time-diference (end - start) synthetic field.
+    The default time resolution is in microseconds.
+
+    Parameters
+    ----------
+    name : string
+        The name of the new synthetic field.
+    hd : bool
+        If True, use 'hd' time resolution (nanoseconds).
     """
     d = 'delta_t {0}'.format(name)
     return (d, d+' hd')[hd]
 
 
 def synth_field_delta_start(name, start_field, end_field):
-    """ Create descriptor for field diference (start - end) synthetic field.
+    """
+    Create descriptor for field diference (start - end) synthetic field.
+
+    Parameters
+    ----------
+    name : string
+        The name of the new synthetic field.
+    start_field : string
+        A field from the start event.
+    end_field : string
+        A field from the end event.
     """
     return 'delta_start {0} {1} {2}'.format(name, start_field, end_field)
 
 
 def synth_field_delta_end(name, start_field, end_field):
-    """ Create descriptor for field diference (end - start)  synthetic field.
+    """
+    Create descriptor for field diference (end - start)  synthetic field.
+
+    Parameters
+    ----------
+    name : string
+        The name of the new synthetic field.
+    start_field : string
+        A field from the start event.
+    end_field : string
+        A field from the end event
     """
     return 'delta_end {0} {1} {2}'.format(name, start_field, end_field)
 
 
 def synth_field_sum(name, start_field, end_field):
-    """ Create descriptor for field sum synthetic field.
+    """
+    Create descriptor for field sum (start + end) synthetic field.
+
+    Parameters
+    ----------
+    name : string
+        The name of the new synthetic field.
+    start_field : string
+        A field from the start event.
+    end_field : string
+        A field from the end event
     """
     return 'sum {0} {1} {2}'.format(name, start_field, end_field)
-- 
2.32.0

