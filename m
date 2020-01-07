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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1ACC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31056208C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/rYJdjz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgAGREG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:04:06 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43369 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgAGREF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:04:05 -0500
Received: by mail-lf1-f67.google.com with SMTP id 9so229381lfq.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7IIbVKzhWdBWpkcjTkJRiMPVbHdowzRUWhx3/gulk7c=;
        b=F/rYJdjzTGYG7AjJIWm4YcRmAl7IpXJSC3Jb+2ZA7nraXmcusj9K9E+VL5kMq7rVnX
         42aTlJ1nzirzqyeefem6+nS3rV3DzgHAZQw3NZi9fXWIxXUsEnSAzVyMwYYQn5zs1w5A
         7nUiYCjcSDxQ01CBfPjqPBuj1GQOa5uK6nwi0taWGCHex0aCib5K+H6TvMzO6IHhunpt
         5ZkhapNtuUecYropuBADG0LK3Yd9dRl3w357hy1OeeK0OIvKiwPhGp3ywiq9nj07AumB
         lX+EIWi9TEfcMin1ZFF2A70jRQyuRH4UeyYPVSwonYxIcYt704ufixRZdY3IC8Myh6ID
         /EFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7IIbVKzhWdBWpkcjTkJRiMPVbHdowzRUWhx3/gulk7c=;
        b=t3yeR6m4u/oW/2oNweeh9hJO3C2QEbw8S1yLtq6KziYJso8nVvLbA1/+5UUuXlHseI
         zmlC6tKk/09sFch4IKk4HYy0ocO2Sn3fXJ5xaFb+e8SZpmMkbchvi2TdTAuY5KLknv8d
         BAF90pv4MGq18gcVUkFLiB9KnPmLEGJBBURdg/AI4KpH39rj2lzxMneMFuAHhLtG3A4H
         74gz09IOZS05xcWEgf0ce6O441ivUlYwLwmrmlWyjKmc6k7WyO30dJdelRr60l2e7dyL
         gNk6RmA16IIWnKfPz07ASzdxLFXZFhCggaLaxor/J6dGhNbVSJge4H/tP+Ib0mLm3nwY
         i3kQ==
X-Gm-Message-State: APjAAAVcwcgN8kBoqvRZToJagGHlyyGdWRJe96memVlt5YqkC5SboiUY
        b8DL6G5voIM1qM9XpzXMejWXgi/J
X-Google-Smtp-Source: APXvYqztXaOmt7Hq8PBa0/luR+/nTdrnjwMFYYDHoFevBZ7eNZ4ogf6dJ4FUaJEUZ6wS106oH63r5Q==
X-Received: by 2002:ac2:51a4:: with SMTP id f4mr301494lfk.76.1578416643077;
        Tue, 07 Jan 2020 09:04:03 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:04:02 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 07/12] trace-cruncher: Adapt gpareto_fit.py to use the new module
Date:   Tue,  7 Jan 2020 19:03:07 +0200
Message-Id: <20200107170312.27116-8-y.karadz@gmail.com>
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
 examples/gpareto_fit.py | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/examples/gpareto_fit.py b/examples/gpareto_fit.py
index 4a2bb2a..eece064 100755
--- a/examples/gpareto_fit.py
+++ b/examples/gpareto_fit.py
@@ -16,11 +16,10 @@ import numpy as np
 from scipy.stats import genpareto as gpareto
 from scipy.optimize import curve_fit as cfit
 
-from ksharksetup import setup
-# Always call setup() before importing ksharkpy!!!
-setup()
-
-import ksharkpy as ks
+import tracecruncher.datawrapper as dw
+import tracecruncher.ksharkpy as ks
+import tracecruncher.ftracepy as ft
+import tracecruncher.utils as tc
 
 def chi2_test(hist, n_bins, c, loc, scale, norm):
     """ Simple Chi^2 test for the goodness of the fit.
@@ -92,7 +91,7 @@ def get_cpu_data(data, task_pid, start_id, stop_id, threshold):
         than the specified threshold.
     """
     # Get the size of the data.
-    size = ks.data_size(data)
+    size = tc.size(data)
     #print("data size:", size)
 
     time_start = -1
@@ -130,7 +129,7 @@ def make_ks_session(fname, data, start, stop):
         The sessions is zooming around the maximum observed latency.
     """
     sname = 'max_lat.json'
-    ks.new_session(fname, sname)
+    tc.new_gui_session(fname, sname)
     i_start = int(start)
     i_stop = int(stop)
 
@@ -145,28 +144,28 @@ def make_ks_session(fname, data, start, stop):
         session['Model']['range'] = [tmin, tmax]
 
         session['Markers']['markA']['isSet'] = True
-        session['Markers']['markA']['row'] = i_start)
+        session['Markers']['markA']['row'] = i_start
 
         session['Markers']['markB']['isSet'] = True
-        session['Markers']['markB']['row'] = i_stop)
+        session['Markers']['markB']['row'] = i_stop
 
-        session['ViewTop'] = i_start) - 5
+        session['ViewTop'] = i_start - 5
 
-        ks.save_session(session, s)
+        tc.save_session(session, s)
 
 
 fname = str(sys.argv[1])
-status = ks.open_file(fname)
+status = ks.open(fname)
 if not status:
     print ("Failed to open file ", fname)
     sys.exit()
 
 ks.register_plugin('reg_pid')
-data = ks.load_data()
+data = dw.load()
 
 # Get the Event Ids of the hrtimer_start and print events.
-start_id = ks.event_id('timer', 'hrtimer_start')
-stop_id = ks.event_id('ftrace', 'print')
+start_id = ft.event_id('timer', 'hrtimer_start')
+stop_id = ft.event_id('ftrace', 'print')
 print("start_id", start_id)
 print("stop_id", stop_id)
 
@@ -194,9 +193,6 @@ ks.close()
 dt_ot = np.array(data_ot)
 np.savetxt('peak_over_threshold_loaded.txt', dt_ot)
 
-make_ks_session(fname=fname, data=data, i_start=int(dt_ot[i_max_lat][1]),
-                                        i_stop=int(dt_ot[i_max_lat][2]))
-
 P = len(dt_ot) / tot
 err_P = error_P(n=len(dt_ot), N=tot)
 print('tot:', tot, ' P =', P)
@@ -208,6 +204,9 @@ print('imax:', i_max_lat, int(dt_ot[i_max_lat][1]))
 
 print('max', np.amax(dt_ot))
 
+make_ks_session(fname=fname, data=data, start=dt_ot[i_max_lat][1],
+                                        stop=dt_ot[i_max_lat][2])
+
 start = threshold
 stop = 31
 n_bins = (stop - start) * 2
-- 
2.20.1

