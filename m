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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE68C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2674208C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WcYUM5+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgAGREI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:04:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45670 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgAGREI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:04:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id j26so280628ljc.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kd63WDXUZjvgY/3SLZ07Y3f2YcGuPCcgpMgK39TKhk8=;
        b=WcYUM5+hVuxEBpvcFKDXtSK1r+DwGw9in7AL6iLZOJhqo8ngDQUkgmQS8JIfLFPrEW
         WqkP+sV11nZUI1lAJgheURTel4oBYBtGluE3AYGn1v17Usg/PO/XIqq2pkxg4SMB3Pu6
         FwbKd68iQxCuXUjbVveRKZ9bq7EC1m26Ia9f5v3ayUrUsimO5JYA7X/TTBeaEe0e7H5+
         hlPgFQX+Y/9pgtHd0hBSTvRgb4/3kpgcxOOB13zdc7jWQu508pomhMDVJY/Q87lfUUsu
         0Mxw9S6fkjXJ2GuVitn7ieGTAqw+p6tTEUd4pBq0Vu8RMQQkwezKUMVrw4Lc3DdWlFHH
         2HqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kd63WDXUZjvgY/3SLZ07Y3f2YcGuPCcgpMgK39TKhk8=;
        b=gVGOsn4udBu+R8ojrUUzvwq8kolmqxrNdLcOK44kzAj4xju69WYFeGdNbVDKNdBIAo
         tLbqIzsvevlEsAV9Ma24hCrJtCzkLjraoojIXXaR113JvvfyXyT8c9O8Xl1/u7eh1alI
         Z+37iVWt/TChzFHTrY4/KJl6g7kl1GFso0YN83c2rVbq18pP8O2z8mKhH9fNXzylFc5Z
         DPZrSxk3ha2ok8OE8AFoI5nJZisagDsAvh6Tvy8R52tk3Ig2shjbvBgDb0zWY3zUj3O4
         oFrTdozd5A0Eb11V93f1+oVCaA1AR8GO1+H3HFoUiXuPaTg4inoDOznzSpxFvs6YpFLu
         Lthw==
X-Gm-Message-State: APjAAAU0sFIlJjV7ecxmFH4VB/+/i7tWEUj0N4fuy5TbfPtpFO+6UHm5
        W9lW6ZKPnYCrLA3kSjd6jHZ972Oo
X-Google-Smtp-Source: APXvYqwWz5qGBdkDn6DxSvbp6+RZFjSjgsyI7GrHVEmJvMJu/RPgLa1gxeR3ZvtGnvs3UQdLZaqgQg==
X-Received: by 2002:a2e:b010:: with SMTP id y16mr295298ljk.238.1578416645009;
        Tue, 07 Jan 2020 09:04:05 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:04:04 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 08/12] trace-cruncher: Adapt page_faults.py to use the new module
Date:   Tue,  7 Jan 2020 19:03:08 +0200
Message-Id: <20200107170312.27116-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch contains some debugging as well.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/page_faults.py | 64 ++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 36 deletions(-)

diff --git a/examples/page_faults.py b/examples/page_faults.py
index 446b12d..e0ce4e2 100755
--- a/examples/page_faults.py
+++ b/examples/page_faults.py
@@ -9,20 +9,14 @@ Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
 import os
 import sys
 import subprocess as sp
-import json
-
 import pprint as pr
-import matplotlib.pyplot as plt
-import scipy.stats as st
-import numpy as np
 from collections import Counter
 from tabulate import tabulate
 
-from ksharksetup import setup
-# Always call setup() before importing ksharkpy!!!
-setup()
-
-import ksharkpy as ks
+from tracecruncher import datawrapper as dw
+from tracecruncher import ksharkpy as ks
+from tracecruncher import ftracepy as ft
+import tracecruncher.utils as tc
 
 def gdb_decode_address(obj_file, obj_address):
     """ Use gdb to examine the contents of the memory at this
@@ -33,7 +27,7 @@ def gdb_decode_address(obj_file, obj_address):
                      '-ex',
                      'x/i ' + str(obj_address),
                      obj_file],
-                    stdout=sp.PIPE)
+                     stdout=sp.PIPE)
 
     symbol = result.stdout.decode("utf-8").splitlines()
 
@@ -49,35 +43,35 @@ def gdb_decode_address(obj_file, obj_address):
 # Get the name of the tracing data file.
 fname = str(sys.argv[1])
 
-ks.open_file(fname)
+ks.open(fname)
 ks.register_plugin('reg_pid')
 
-data = ks.load_data()
+data = dw.load()
 tasks = ks.get_tasks()
 #pr.pprint(tasks)
 
 # Get the Event Ids of the page_fault_user or page_fault_kernel events.
-pf_eid = ks.event_id('exceptions', 'page_fault_user')
+pf_eid = ft.event_id('exceptions', 'page_fault_user')
 
 # Gey the size of the data.
-d_size = ks.data_size(data)
+d_size = tc.size(data)
 
 # Get the name of the user program.
 prog_name = str(sys.argv[2])
 
 table_headers = ['N p.f.', 'function', 'value', 'obj. file']
-table_list = []
 
 # Loop over all tasks associated with the user program.
 for j in range(len(tasks[prog_name])):
+    table_list = []
     count = Counter()
     task_pid = tasks[prog_name][j]
     for i in range(0, d_size):
         if data['event'][i] == pf_eid and data['pid'][i] == task_pid:
-            address = ks.read_event_field(offset=data['offset'][i],
+            address = ft.read_event_field(offset=data['offset'][i],
                                           event_id=pf_eid,
                                           field='address')
-            ip = ks.read_event_field(offset=data['offset'][i],
+            ip = ft.read_event_field(offset=data['offset'][i],
                                      event_id=pf_eid,
                                      field='ip')
             count[ip] += 1
@@ -92,29 +86,27 @@ for j in range(len(tasks[prog_name])):
     if i_max > len(pf_list):
         i_max = len(pf_list)
 
+    #print(pf_list[:25])
     for i in range(0, i_max):
-        func = ks.get_function(pf_list[i][0])
-        func_info = [func]
-        if func.startswith('0x'):
-            # The name of the function cannot be determined. We have an
-            # instruction pointer instead. Most probably this is a user-space
-            # function.
-            address = int(func, 0)
-            instruction = ks.map_instruction_address(task_pid, address)
-
-            if instruction['obj_file'] != 'UNKNOWN':
+        func_info = []
+        address = int(pf_list[i][0])
+        func = ft.get_function(address)
+        if not func :
+            # The name of the function cannot be determined. Most probably
+            # this is a user-space function.
+            instruction = ft.map_instruction_address(pid=task_pid,
+                                                     proc_addr=address)
+            if instruction:
                 func_info = gdb_decode_address(instruction['obj_file'],
                                                instruction['address'])
             else:
-                func_info += ['', instruction['obj_file']]
-
-        else:
-            func_info = [func]
+                func_info = ['addr: ' + hex(address), 'UNKNOWN']
 
         table_list.append([pf_list[i][1]] + func_info)
 
-ks.close()
+    print('\n{}-{}\n'.format(prog_name, task_pid),
+          tabulate(table_list,
+                   headers=table_headers,
+                   tablefmt='simple'))
 
-print("\n", tabulate(table_list,
-                     headers=table_headers,
-                     tablefmt='simple'))
+ks.close()
-- 
2.20.1

