Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB52AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Feb 2022 15:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiBCPgK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 10:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiBCPgK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 10:36:10 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE7DC061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Feb 2022 07:36:09 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id f17so5825067wrx.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Feb 2022 07:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GOPe2C+yBstdFCIIOjRR0YQtS40jrgPlmkTwaNXrrgU=;
        b=luYDfgnJn3z9rp8yAtVfIr2vm6eUzR8bq+zqqCxYE0UrL721zT5+Fgwt6qSRCkQvRy
         x1mFtfsodtQSe0NcO44X2W2wWuEjCCO1h8c/QRLYfciJVRyd5fLQgVCcsQOG+G4n3LUf
         D1R+oZIFwF8aNYSjjABfKN4ceUzUJS+QhnvBjgl3hbyjEFXmZFLzenFJsTG15SLWlYQy
         XifBAroFVl2KC8LXnrQWpL9lMq0GYQ6zsJ1bnLlRKQ0cxIclhJKLS4Q+F5vfry6Av3zF
         HPxB/5A3eLY3vLIZsSlQ6/vpU6jOsgULzeWsGH1Ul+B2KTuAlAPNG/b1CbyP8puY2T3K
         t3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GOPe2C+yBstdFCIIOjRR0YQtS40jrgPlmkTwaNXrrgU=;
        b=K5irTITevTifFER0PX9q9pvdG5LZOuEomtJ3SSJP9m9MZxeEdTRrjkD5GpGrUkurp3
         dzgG3bdQAORmXI6v8DLvj5eDqyKRuMQbxOhj9gEz51XAccaxMSY0ntBLnCBD/+e9rdY4
         FF713dgxrXYbn+ZoObaf7iZue85YpWZvsz0rG1cxj3GayDns6eRKP5VMMgCQGcc36kMa
         +Z93R4HpAcYQP8D2ULAXu/Vg/l9+yvc1mQzOilZVUEyQ4VDg7ICaM7FhjywX4gxt/2UK
         e2EEubCpox8CIPoliaWATh3hr2G9NHNguJzgZDSlz02mYehc18ch2IOW9Pppu3w2OjzU
         /odg==
X-Gm-Message-State: AOAM533yVAkNgxdohFB9VJJjMjxv5415xEpNbhapNy98pilFbvrHKX1s
        9ehxG+DMHZBeY3XArRF2FqMzDeRHZnI=
X-Google-Smtp-Source: ABdhPJzZSImNZde4QlZJuDeTZ+XDp/e9dMu4ue0gbbTEOV6MwwRDrqJuGaVRZqbInrVnrvbGuq6nwA==
X-Received: by 2002:adf:de0c:: with SMTP id b12mr29039845wrm.26.1643902567958;
        Thu, 03 Feb 2022 07:36:07 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id z1sm7595762wmk.32.2022.02.03.07.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:36:07 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] trace-cruncher: Add ksynth class to ft_utiles
Date:   Thu,  3 Feb 2022 17:35:54 +0200
Message-Id: <20220203153556.26878-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Define a Python class and helper methods to be used for easy manipulation
of kernel synthetic events.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 119 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 26c06ec..26978f3 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -314,3 +314,122 @@ def find_khist(name, event, axes, instance=None,
         raise RuntimeError(msg) from err
 
     return hist
+
+class ksynth(event):
+    def __init__(self, name, start_event, end_event,
+                 synth_fields=None, match_name=ft.no_arg()):
+        """ Constructor.
+        """
+        super().__init__(system='synthetic', name=name, static=False)
+        self.synth = ft.synth(name,
+                              start_sys=start_event['event'].system,
+                              start_evt=start_event['event'].name,
+                              end_sys=end_event['event'].system,
+                              end_evt=end_event['event'].name,
+                              start_match=start_event['match'],
+                              end_match=end_event['match'],
+                              match_name=match_name)
+
+        start_fields = end_fields = []
+
+        if 'fields' in start_event:
+            start_fields = start_event['fields']
+
+        start_field_names = [None] * len(start_fields)
+        if 'field_names' in start_event:
+            start_field_names = start_event['field_names']
+
+        self.synth.add_start_fields(fields=start_fields,
+                                    names=start_field_names)
+
+        if 'fields' in end_event:
+            end_fields = end_event['fields']
+
+        end_field_names = [None] * len(end_fields)
+        if 'field_names' in end_event:
+            end_field_names = end_event['field_names']
+
+        self.synth.add_end_fields(fields=end_fields,
+                                  names=end_field_names)
+
+        if synth_fields is not None:
+            for f in synth_fields:
+                args = f.split(' ')
+                if args[0] == 'delta_t' and len(args) < 4:
+                    if len(args) == 1:
+                        self.synth.add_delta_T()
+                    elif len(args) == 3 and args[2] == 'hd':
+                        self.synth.add_delta_T(name=args[1], hd=True)
+                    elif args[1] == 'hd':
+                        self.synth.add_delta_T(hd=True)
+                    else:
+                        self.synth.add_delta_T(name=args[1])
+                elif args[0] == 'delta_start' and len(args) == 4:
+                    self.synth.add_delta_start(name=args[1],
+                                               start_field=args[2],
+                                               end_field=args[3])
+                elif args[0] == 'delta_end' and len(args) == 4:
+                    self.synth.add_delta_end(name=args[1],
+                                             start_field=args[2],
+                                             end_field=args[3])
+                elif args[0] == 'delta_start' and len(args) == 3:
+                    self.synth.add_sum(start_field=args[1], end_field=args[2])
+                else:
+                    raise ValueError('Invalid synth. field \'{0}\''.format(f))
+
+        self.synth.register()
+        self.evt_id = find_event_id(system=self.system, event=self.name)
+
+    def __repr__(self):
+        """ Read the descriptor of the synthetic event.
+        """
+        return self.synth.repr(event=True, hist_start=True, hist_end=True)
+
+
+def ksynth_event_item(event, match, fields=[]):
+    """ Create descriptor for an event item (component) of a synthetic event.
+        To be used as a start/end event.
+    """
+    sub_evt = {}
+    sub_evt['event'] = event
+    sub_evt['fields'] = fields
+    sub_evt['field_names'] = [None] * len(fields)
+    sub_evt['match'] = match
+
+    return sub_evt
+
+
+def ksynth_field_rename(event, field, name):
+    """ Change the name of a field in the event component of a synthetic event.
+    """
+    pos = event['fields'].index(field)
+    event['field_names'][pos] = name
+
+    return event
+
+
+def ksynth_field_deltaT(name='delta_T', hd=False):
+    """ Create descriptor for time-diference synthetic field.
+    """
+    if hd:
+        return 'delta_t {0} hd'.format(name)
+
+    return 'delta_t {0} hd'.format(name)
+
+
+def ksynth_field_delta_start(name, start_field, end_field):
+    """ Create descriptor for field diference (start - end) synthetic field.
+    """
+    return 'delta_start {0} {1} {2}'.format(name, start_field, end_field)
+
+
+def ksynth_field_delta_end(name, start_field, end_field):
+    """ Create descriptor for field diference (end - start)  synthetic field.
+    """
+    return 'delta_end {0} {1} {2}'.format(name, start_field, end_field)
+
+
+def ksynth_field_sum(name, start_field, end_field):
+    """ Create descriptor for field sum synthetic field.
+    """
+    return 'sum {0} {1} {2}'.format(name, start_field, end_field)
-- 
2.32.0

