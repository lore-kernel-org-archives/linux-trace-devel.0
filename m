Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5EEC07E9E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66FA261C5B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhGGNY4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhGGNYz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:24:55 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368C6C061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:22:15 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gn32so3276142ejc.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bdek54BxHStxo8oNaW3unHhknbTsCDJUVuc0kaxw3IY=;
        b=M98M8JXcz33/F9A8Rc1dsLP+C5/mcVux++XOc7JQoOLSzRL2MadGuprggpmYQiAZBK
         OcIIE9dAbXGrPCDGSOv1u8JPrjTNa1D0vDKSkQg34fyjBjqe7D9AWwLOD/ZI7lIfKJT7
         hZxKnT2kjQ14zF4dcW/s3Oh0x5Hgxq2YKF4xa6TenB9BiLrMtIwojd/s97AphKIvNsli
         97A/n0sqd3UZ5moIrPKq4Ruj7VCtZZmdJ01fxNJzY2JZeU1RtawdsbVi0tQpiC2VFlDD
         qdIzXd73Eigc53xBm4TXdY8JIDsUrZtCjQdtj8MdVA39qqGNWv8xlKqeE8uDUfkwGSFn
         3khQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bdek54BxHStxo8oNaW3unHhknbTsCDJUVuc0kaxw3IY=;
        b=FiuTSEU4ovvoekWsZ7cx83D51atvTmmvBWLxQ/+nDyFyRGbXNBA3/xsJ/lpBojPdKj
         xbbntNfP6zQv1W+0Zp/ADlWCuZCb2IDuwCIBhFXhhuRQ7FxOs07DuVQYPd2OLRx1YI0y
         v2MHPunsGcpSllrjt7S/n9iHErVRKMTjyHQSLVfmnQ6oXIUM0FCQP16olcx99qPV9x6f
         VsCahy36ln9nL7n+MktOoV+BQhj1O2wWBPS3lkY397KfCX8+nssWTjTHbVff7Zea93l+
         r5ZCFDAjAtlUKvV7M0X/+EAa1elnyq+i/BuQW7aYrNyF52JufpboMBbdr/cRHV++Tmv1
         Y/lA==
X-Gm-Message-State: AOAM530nP3i+9iRRguNSEA2omY6dPrOGpikIte/Hl6//VSN6dMJrrZSy
        mi1ofrq7MNfePeLRKPNdjuB/hAQ5TGM=
X-Google-Smtp-Source: ABdhPJykicg8UaIbh23mhwQFupt4xjHJAs5a2IE/okEIlQ8slROBCFHs17LprZpJKmwwCg93hS0Kcw==
X-Received: by 2002:a17:906:8252:: with SMTP id f18mr1161055ejx.261.1625664133378;
        Wed, 07 Jul 2021 06:22:13 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id eb9sm7064881ejc.32.2021.07.07.06.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:22:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 05/11] trace-cruncher: Refactor the examples
Date:   Wed,  7 Jul 2021 16:21:51 +0300
Message-Id: <20210707132158.68520-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210707132158.68520-1-y.karadz@gmail.com>
References: <20210707132158.68520-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For the moment we will keep only one example that is "sched_wakeup.py".
"gpareto_fit.py" gets removed because it doesn't really demonstrate
anything conceptually different compared to "sched_wakeup.py". The
difference comes from the more advanced statistical analysis of the data,
however this goes beyond the scope of trace-cruncher. "page_faults.py"
gets removed only temporally, because it requires some functionalities
that are not yet implemented in the ftrace libraries. Once those
functionalities are made available, the example will be added to
trace-cruncher again.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/gpareto_fit.py  | 328 ---------------------------------------
 examples/page_faults.py  | 120 --------------
 examples/sched_wakeup.py |  70 ++++-----
 3 files changed, 30 insertions(+), 488 deletions(-)
 delete mode 100755 examples/gpareto_fit.py
 delete mode 100755 examples/page_faults.py

diff --git a/examples/gpareto_fit.py b/examples/gpareto_fit.py
deleted file mode 100755
index 4a2bb2a..0000000
--- a/examples/gpareto_fit.py
+++ /dev/null
@@ -1,328 +0,0 @@
-#!/usr/bin/env python3
-
-"""
-SPDX-License-Identifier: LGPL-2.1
-
-Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
-"""
-
-import sys
-import json
-
-import matplotlib.pyplot as plt
-import scipy.stats as st
-import numpy as np
-
-from scipy.stats import genpareto as gpareto
-from scipy.optimize import curve_fit as cfit
-
-from ksharksetup import setup
-# Always call setup() before importing ksharkpy!!!
-setup()
-
-import ksharkpy as ks
-
-def chi2_test(hist, n_bins, c, loc, scale, norm):
-    """ Simple Chi^2 test for the goodness of the fit.
-    """
-    chi2 = n_empty_bins = 0
-    for i in range(len(hist[0])):
-        if hist[0][i] == 0:
-            # Ignore this empty bin.
-            n_empty_bins += 1
-            continue
-
-        # Get the center of bin i.
-        x = (hist[1][i] + hist[1][i + 1]) / 2
-        fit_val = gpareto.pdf(x, c=c, loc=loc, scale=scale)
-        chi = (fit_val - hist[0][i]) / np.sqrt(hist[0][i])
-        chi2 += chi**2
-
-    return  norm * chi2 / (n_bins - n_empty_bins)
-
-def quantile(p, P, c, loc, scale):
-    """ The quantile function of the Generalized Pareto distribution.
-    """
-    return loc + scale / c * ((P / p)**(c) - 1)
-
-
-def dq_dscale(p, P, c, scale):
-    """ Partial derivative of the quantile function.
-    """
-    return ((P / p)**c - 1) / c
-
-
-def dq_dc(p, P, c, scale):
-    """ Partial derivative of the quantile function.
-    """
-    return (scale * (np.log(P / p) * (P / p)**c ) / c
-          - scale * ((P / p)**c - 1) / (c**2))
-
-
-def dq_dP(p, P, c, scale):
-    """ Partial derivative of the quantile function.
-    """
-    return scale / P * (P / p)**c
-
-
-def error_P(n, N):
-    return np.sqrt(n) / N
-
-
-def error(p, P, c, scale, err_P, err_c, err_scale):
-    return np.sqrt((dq_dP(p, P, c, scale) * err_P)**2
-                 + (dq_dc(p, P, c, scale) * err_c)**2
-                 + (dq_dscale(p, P, c, scale) * err_scale)**2)
-
-
-def quantile_conf_bound(p, P, n, c, loc, scale, err_P, err_c, err_scale):
-    return (quantile(p=p, P=P, c=c, loc=loc, scale=scale)
-          + n * error(p=p, P=P, c=c, scale=scale,
-                      err_P=err_P, err_c=err_c, err_scale=err_scale));
-
-
-def get_latency(t0, t1):
-    """ Get the value of the latency in microseconds
-    """
-    return (t1 - t0) / 1000 - 1000
-
-
-def get_cpu_data(data, task_pid, start_id, stop_id, threshold):
-    """ Loop over the tracing data for a given CPU and find all latencies bigger
-        than the specified threshold.
-    """
-    # Get the size of the data.
-    size = ks.data_size(data)
-    #print("data size:", size)
-
-    time_start = -1
-    dt_ot = []
-    tot = 0
-    i = 0
-    i_start = 0;
-
-    while i < size:
-        if data["pid"][i] == task_pid and data['event'][i] == start_id:
-            time_start = data['time'][i]
-            i_start = i;
-            i = i + 1
-
-            while i < size:
-                if data["pid"][i] == task_pid and data['event'][i] == stop_id:
-                    delta = get_latency(time_start, data['time'][i])
-
-                    if delta > threshold and tot != 0:
-                        print('lat. over threshold: ', delta, i_start, i)
-                        dt_ot.append([delta, i_start, i])               
-
-                    tot = tot + 1
-                    break
-
-                i = i + 1
-        i = i + 1
-
-    print(task_pid, 'tot:', len(dt_ot), '/', tot)
-    return dt_ot, tot
-
-
-def make_ks_session(fname, data, start, stop):
-    """ Save a KernelShark session descriptor file (Json).
-        The sessions is zooming around the maximum observed latency.
-    """
-    sname = 'max_lat.json'
-    ks.new_session(fname, sname)
-    i_start = int(start)
-    i_stop = int(stop)
-
-    with open(sname, 'r+') as s:
-        session = json.load(s)
-        session['TaskPlots'] = [int(data['pid'][i_start])]
-        session['CPUPlots'] = [int(data['cpu'][i_start])]
-
-        delta = data['time'][i_stop] - data['time'][i_start]
-        tmin = int(data['time'][i_start] - delta)
-        tmax = int(data['time'][i_stop] + delta)
-        session['Model']['range'] = [tmin, tmax]
-
-        session['Markers']['markA']['isSet'] = True
-        session['Markers']['markA']['row'] = i_start)
-
-        session['Markers']['markB']['isSet'] = True
-        session['Markers']['markB']['row'] = i_stop)
-
-        session['ViewTop'] = i_start) - 5
-
-        ks.save_session(session, s)
-
-
-fname = str(sys.argv[1])
-status = ks.open_file(fname)
-if not status:
-    print ("Failed to open file ", fname)
-    sys.exit()
-
-ks.register_plugin('reg_pid')
-data = ks.load_data()
-
-# Get the Event Ids of the hrtimer_start and print events.
-start_id = ks.event_id('timer', 'hrtimer_start')
-stop_id = ks.event_id('ftrace', 'print')
-print("start_id", start_id)
-print("stop_id", stop_id)
-
-tasks = ks.get_tasks()
-jdb_pids = tasks['jitterdebugger']
-print('jitterdeburrer pids:', jdb_pids)
-jdb_pids.pop(0)
-
-threshold = 10
-data_ot = []
-tot = 0
-
-for task_pid in jdb_pids:
-    cpu_data, cpu_tot = get_cpu_data(data=data,
-                                     task_pid=task_pid,
-                                     start_id=start_id,
-                                     stop_id=stop_id,
-                                     threshold=threshold)
-
-    data_ot.extend(cpu_data)
-    tot += cpu_tot
-
-ks.close()
-
-dt_ot = np.array(data_ot)
-np.savetxt('peak_over_threshold_loaded.txt', dt_ot)
-
-make_ks_session(fname=fname, data=data, i_start=int(dt_ot[i_max_lat][1]),
-                                        i_stop=int(dt_ot[i_max_lat][2]))
-
-P = len(dt_ot) / tot
-err_P = error_P(n=len(dt_ot), N=tot)
-print('tot:', tot, ' P =', P)
-
-lat = dt_ot[:,0]
-#print(lat)
-i_max_lat = lat.argmax()
-print('imax:', i_max_lat, int(dt_ot[i_max_lat][1]))
-
-print('max', np.amax(dt_ot))
-
-start = threshold
-stop = 31
-n_bins = (stop - start) * 2
-
-bin_size = (stop - start) / n_bins
-
-x = np.linspace(start=start + bin_size / 2,
-                stop=stop - bin_size / 2,
-                num=n_bins)
-
-bins_ot = np.linspace(start=start, stop=stop, num=n_bins + 1)
-#print(bins_ot)
-
-fig, ax = plt.subplots(nrows=2, ncols=2)
-fig.tight_layout()
-ax[-1, -1].axis('off')
-
-hist_ot = ax[0][0].hist(x=lat, bins=bins_ot, histtype='stepfilled', alpha=0.3)
-ax[0][0].set_xlabel('latency [\u03BCs]', fontsize=8)
-ax[0][0].set_yscale('log')
-#print(hist_ot[0])
-
-hist_ot_norm = ax[1][0].hist(x=lat, bins=bins_ot,
-                             density=True, histtype='stepfilled', alpha=0.3)
-
-# Fit using the fitter of the genpareto class (shown in red).
-ret = gpareto.fit(lat, loc=threshold)
-ax[1][0].plot(x, gpareto.pdf(x, c=ret[0],  loc=ret[1],  scale=ret[2]),
-              'r-', lw=1, color='red',  alpha=0.8)
-
-ax[1][0].set_xlabel('latency [\u03BCs]', fontsize=8)
-print(ret)
-print('\ngoodness-of-fit: ' + '{:03.3f}'.format(chi2_test(hist_ot_norm,
-                                                          n_bins=n_bins,
-                                                          c=ret[0],
-                                                          loc=ret[1],
-                                                          scale=ret[2],
-                                                          norm=len(lat))))
-
-print("\n curve_fit:")
-# Fit using the curve_fit fitter. Fix the value of the "loc" parameter.
-popt, pcov = cfit(lambda x, c, scale: gpareto.pdf(x, c=c, loc=threshold, scale=scale),
-                  x, hist_ot_norm[0],
-                  p0=[ret[0], ret[2]])
-
-print(popt)
-print(pcov)
-
-ax[1][0].plot(x, gpareto.pdf(x, c=popt[0], loc=threshold, scale=popt[1]),
-              'r-', lw=1, color='blue', alpha=0.8)
-
-fit_legend = str('\u03BE = ' + '{:05.3f}'.format(popt[0]) +
-                 ' +- ' + '{:05.3f}'.format(pcov[0][0]**0.5) +
-                 ' (' + '{:03.2f}'.format(pcov[0][0]**0.5 / abs(popt[0]) * 100) + '%)')
-
-fit_legend += str('\n\u03C3 = ' + '{:05.3f}'.format(popt[1]) +
-                  ' +- ' + '{:05.3f}'.format(pcov[1][1]**0.5) +
-                  ' (' + '{:03.2f}'.format(pcov[1][1]**0.5 / abs(popt[1]) * 100) + '%)')
-
-fit_legend += '\n\u03BC = ' + str(threshold) + ' (const)'
-
-fit_legend += '\ngoodness-of-fit: ' + '{:03.3f}'.format(chi2_test(hist_ot_norm,
-                                                        n_bins=n_bins,
-                                                        c=popt[0],
-                                                        loc=threshold,
-                                                        scale=popt[1],
-                                                        norm=len(lat)))
-print(fit_legend)
-
-ax[0][1].set_xscale('log')
-##ax[0][1].set_yscale('log')
-ax[0][1].set_xlabel('Return period', fontsize=8)
-ax[0][1].set_ylabel('Return level [\u03BCs]', fontsize=6)
-ax[0][1].grid(True, linestyle=":", which="both")
-
-y = np.linspace(200000, 5000000, 400)
-ax[0][1].plot(y,
-              quantile(1 / y,
-                       P=P,
-                       c=popt[0],
-                       loc=threshold,
-                       scale=popt[1]),
-              'r-', lw=1, color='blue', alpha=0.8)
-
-ax[0][1].plot(y,
-              quantile_conf_bound(1 / y,
-                                  P=P,
-                                  n=+1, 
-                                  c=popt[0],
-                                  loc=threshold,
-                                  scale=popt[1],
-                                  err_P=err_P,
-                                  err_c= pcov[0][0]**0.5,
-                                  err_scale=pcov[1][1]**0.5),
-              'r-', lw=1, color='green', alpha=0.8)
-
-ax[0][1].plot(y,
-              quantile_conf_bound(1 / y,
-                                  P=P,
-                                  n=-1, 
-                                  c=popt[0],
-                                  loc=threshold,
-                                  scale=popt[1],
-                                  err_P=err_P,
-                                  err_c= pcov[0][0]**0.5,
-                                  err_scale=pcov[1][1]**0.5),
-              'r-', lw=1, color='green', alpha=0.8)
-
-props = dict(boxstyle='round', color='black', alpha=0.05)
-
-ax[1][1].text(0.05, 0.85,
-              fit_legend,
-              fontsize=9,
-              verticalalignment='top',
-              bbox=props)
-
-plt.savefig('figfit-all-loaded.png')
-#plt.show()
diff --git a/examples/page_faults.py b/examples/page_faults.py
deleted file mode 100755
index 446b12d..0000000
--- a/examples/page_faults.py
+++ /dev/null
@@ -1,120 +0,0 @@
-#!/usr/bin/env python3
-
-"""
-SPDX-License-Identifier: LGPL-2.1
-
-Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
-"""
-
-import os
-import sys
-import subprocess as sp
-import json
-
-import pprint as pr
-import matplotlib.pyplot as plt
-import scipy.stats as st
-import numpy as np
-from collections import Counter
-from tabulate import tabulate
-
-from ksharksetup import setup
-# Always call setup() before importing ksharkpy!!!
-setup()
-
-import ksharkpy as ks
-
-def gdb_decode_address(obj_file, obj_address):
-    """ Use gdb to examine the contents of the memory at this
-        address.
-    """
-    result = sp.run(['gdb',
-                     '--batch',
-                     '-ex',
-                     'x/i ' + str(obj_address),
-                     obj_file],
-                    stdout=sp.PIPE)
-
-    symbol = result.stdout.decode("utf-8").splitlines()
-
-    if symbol:
-        func = [symbol[0].split(':')[0], symbol[0].split(':')[1]]
-    else:
-        func = [obj_address]
-
-    func.append(obj_file)
-
-    return func
-
-# Get the name of the tracing data file.
-fname = str(sys.argv[1])
-
-ks.open_file(fname)
-ks.register_plugin('reg_pid')
-
-data = ks.load_data()
-tasks = ks.get_tasks()
-#pr.pprint(tasks)
-
-# Get the Event Ids of the page_fault_user or page_fault_kernel events.
-pf_eid = ks.event_id('exceptions', 'page_fault_user')
-
-# Gey the size of the data.
-d_size = ks.data_size(data)
-
-# Get the name of the user program.
-prog_name = str(sys.argv[2])
-
-table_headers = ['N p.f.', 'function', 'value', 'obj. file']
-table_list = []
-
-# Loop over all tasks associated with the user program.
-for j in range(len(tasks[prog_name])):
-    count = Counter()
-    task_pid = tasks[prog_name][j]
-    for i in range(0, d_size):
-        if data['event'][i] == pf_eid and data['pid'][i] == task_pid:
-            address = ks.read_event_field(offset=data['offset'][i],
-                                          event_id=pf_eid,
-                                          field='address')
-            ip = ks.read_event_field(offset=data['offset'][i],
-                                     event_id=pf_eid,
-                                     field='ip')
-            count[ip] += 1
-
-    pf_list = count.items()
-
-    # Sort the counters of the page fault instruction pointers. The most
-    # frequent will be on top.
-    pf_list = sorted(pf_list, key=lambda cnt: cnt[1], reverse=True)
-
-    i_max = 25
-    if i_max > len(pf_list):
-        i_max = len(pf_list)
-
-    for i in range(0, i_max):
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
-                func_info = gdb_decode_address(instruction['obj_file'],
-                                               instruction['address'])
-            else:
-                func_info += ['', instruction['obj_file']]
-
-        else:
-            func_info = [func]
-
-        table_list.append([pf_list[i][1]] + func_info)
-
-ks.close()
-
-print("\n", tabulate(table_list,
-                     headers=table_headers,
-                     tablefmt='simple'))
diff --git a/examples/sched_wakeup.py b/examples/sched_wakeup.py
index 52f2688..acf3682 100755
--- a/examples/sched_wakeup.py
+++ b/examples/sched_wakeup.py
@@ -15,28 +15,20 @@ import matplotlib.pyplot as plt
 import scipy.stats as st
 import numpy as np
 
-from ksharksetup import setup
-# Always call setup() before importing ksharkpy!!!
-setup()
+import tracecruncher.ks_utils as tc
 
-import ksharkpy as ks
 # Get the name of the user program.
 if len(sys.argv) >= 2:
     fname = str(sys.argv[1])
 else:
     fname = input('choose a trace file: ')
 
-status = ks.open_file(fname)
-if not status:
-    print ("Failed to open file ", fname)
-    sys.exit()
-
-ks.register_plugin('reg_pid')
+f = tc.open_file(file_name=fname)
 
 # We do not need the Process Ids of the records.
 # Do not load the "pid" data.
-data = ks.load_data(pid_data=False)
-tasks = ks.get_tasks()
+data = f.load(pid_data=False)
+tasks = f.get_tasks()
 
 # Get the name of the user program.
 if len(sys.argv) >= 3:
@@ -48,11 +40,11 @@ else:
 task_pid = tasks[prog_name][0]
 
 # Get the Event Ids of the sched_switch and sched_waking events.
-ss_eid = ks.event_id('sched', 'sched_switch')
-w_eid = ks.event_id('sched', 'sched_waking')
+ss_eid = f.event_id(name='sched/sched_switch')
+w_eid = f.event_id(name='sched/sched_waking')
 
 # Gey the size of the data.
-i = data['offset'].size
+i = tc.size(data)
 
 dt = []
 delta_max = i_ss_max = i_sw_max = 0
@@ -60,7 +52,7 @@ delta_max = i_ss_max = i_sw_max = 0
 while i > 0:
     i = i - 1
     if data['event'][i] == ss_eid:
-        next_pid = ks.read_event_field(offset=data['offset'][i],
+        next_pid = f.read_event_field(offset=data['offset'][i],
                                        event_id=ss_eid,
                                        field='next_pid')
 
@@ -73,13 +65,13 @@ while i > 0:
                 i = i - 1
 
                 if data['event'][i] < 0 and cpu_ss == data['cpu'][i]:
-			# Ring buffer overflow. Ignore this case and continue.
+                        # Ring buffer overflow. Ignore this case and continue.
                         break
 
                 if data['event'][i] == ss_eid:
-                    next_pid = ks.read_event_field(offset=data['offset'][i],
-                                       event_id=ss_eid,
-                                       field='next_pid')
+                    next_pid = f.read_event_field(offset=data['offset'][i],
+                                                  event_id=ss_eid,
+                                                  field='next_pid')
                     if next_pid == task_pid:
                         # Second sched_switch for the same task. ?
                         time_ss = data['time'][i]
@@ -89,7 +81,7 @@ while i > 0:
                     continue
 
                 if (data['event'][i] == w_eid):
-                    waking_pid = ks.read_event_field(offset=data['offset'][i],
+                    waking_pid = f.read_event_field(offset=data['offset'][i],
                                                      event_id=w_eid,
                                                      field='pid')
 
@@ -107,6 +99,7 @@ while i > 0:
 desc = st.describe(np.array(dt))
 print(desc)
 
+# Plot the latency distribution.
 fig, ax = plt.subplots(nrows=1, ncols=1)
 fig.set_figheight(6)
 fig.set_figwidth(7)
@@ -119,30 +112,27 @@ ax.set_xlabel('latency [$\mu$s]')
 ax.hist(dt, bins=(100), histtype='step')
 plt.show()
 
-sname = 'sched.json'
-ks.new_session(fname, sname)
+# Prepare a session description for KernelShark.
+s = tc.ks_session('sched')
 
-with open(sname, 'r+') as s:
-    session = json.load(s)
-    session['TaskPlots'] = [task_pid]
-    session['CPUPlots'] = [int(data['cpu'][i_sw_max])]
+delta = data['time'][i_ss_max] - data['time'][i_sw_max]
+tmin = data['time'][i_sw_max] - delta
+tmax = data['time'][i_ss_max] + delta
 
-    if data['cpu'][i_ss_max] != data['cpu'][i_sw_max]:
-        session['CPUPlots'].append(int(data['cpu'][i_ss_max]))
+s.set_time_range(tmin=tmin, tmax=tmax)
 
-    delta = data['time'][i_ss_max] - data['time'][i_sw_max]
-    tmin = int(data['time'][i_sw_max] - delta)
-    tmax = int(data['time'][i_ss_max] + delta)
-    session['Model']['range'] = [tmin, tmax]
+cpu_plots = [data['cpu'][i_sw_max]]
+if data['cpu'][i_ss_max] != data['cpu'][i_sw_max]:
+    cpu_plots.append(data['cpu'][i_ss_max])
 
-    session['Markers']['markA']['isSet'] = True
-    session['Markers']['markA']['row'] = int(i_sw_max)
+s.set_cpu_plots(f, cpu_plots)
+s.set_task_plots(f, [task_pid])
 
-    session['Markers']['markB']['isSet'] = True
-    session['Markers']['markB']['row'] = int(i_ss_max)
+s.set_marker_a(i_sw_max)
+s.set_marker_b(i_ss_max)
 
-    session['ViewTop'] = int(i_sw_max) - 5
+s.set_first_visible_row(i_sw_max - 5)
 
-    ks.save_session(session, s)
+s.add_plugin(stream=f, plugin='sched_events')
 
-ks.close()
+s.save()
-- 
2.27.0

