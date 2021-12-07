Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB605C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 14:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbhLGOdA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 09:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbhLGOb6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 09:31:58 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639E0C061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 06:28:28 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a18so29908481wrn.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Dec 2021 06:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0rwERsXcH4VdwhRrb/6skyu/4OuGYgnx09R8tENKlOs=;
        b=RFauAyp94HbgP7gUg/9ZdBZQN+0mQYwHqmYRA9UqzaY7TVHepMCYhbAN9x902zThqZ
         uZ8CjUgNIi31A5/FQl/A0G1IQkexDrZkavhp1hNAh7P/Iqfozip2b1mPqOWzX2kliSu9
         xTYCaD5kVKj+37ZMcVqZY1J5mLsmEUgZbZhNm5y6NDw5Kf0MX+tdze+E3MOk7zZW1rDT
         FF1ji2s7fJTnS6UGSpPq+5b59Ip8yUkcQ5tBLbYAOsiwNvMH1LCmGCNLbcJ8JL8exe9M
         zLcH540ncGLPfA0eVOTarB1zzOk/RW5dlcOQTQBioVTPs70PS1+g+MSTsgF+XATDIjxo
         hpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0rwERsXcH4VdwhRrb/6skyu/4OuGYgnx09R8tENKlOs=;
        b=m8bbGrmL73yMYGFBKDztNQplJYsZRLfGdF+vOSKoRFw2wo1KISkqcR+rrQL1xWRqHx
         dYHFkxXQa/3gyz6JUiIvxGkuFNR+DT+CSR19I8sAwCoPrVU8dObXqHHwVlwVyajZrxJu
         63nhXdW6F43KHeZjRjeGM8TL5wIDToX8VciGAhZw5LXjoegN+sivWYWmIUhIC8N99q1O
         Bvi7i5nyKsUC+iBSFTfy+Dixg1fK1dUg4c1dVUmRNFOYrAMd4cJMcF0B88NLtvDNwSH/
         R3osjvIrf+p/wva768G5hM/KOuZZ8VrbRXZM4ruLfnBZUFxQDTAtx9o+V0XA9RjNAEEn
         JaHg==
X-Gm-Message-State: AOAM531Mz+BGJ2QMXTTs1+PBumQxbEOhSYMIkmThTP146Z5FCrBJYLkq
        6BBKH0Ggk2uH1uoMV3PAqTJ/achSwkQ=
X-Google-Smtp-Source: ABdhPJyHfO/4nrPYH37/ZHuho1GlS2xh8Rkjso73/yj2kIU7sBdAOzH82igdjXn2h3OlVKIfgYFOvw==
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr51566679wrd.33.1638887306851;
        Tue, 07 Dec 2021 06:28:26 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l4sm14301428wrv.94.2021.12.07.06.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:28:26 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/5] trace-cruncher: Add kernel histogram example
Date:   Tue,  7 Dec 2021 16:28:11 +0200
Message-Id: <20211207142811.398929-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207142811.398929-1-y.karadz@gmail.com>
References: <20211207142811.398929-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a very basic possible example, demonstration the usage of
the new APIs for kernel histograms.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/hist.py | 66 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100755 examples/hist.py

diff --git a/examples/hist.py b/examples/hist.py
new file mode 100755
index 0000000..d668039
--- /dev/null
+++ b/examples/hist.py
@@ -0,0 +1,66 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import sys
+import time
+
+import tracecruncher.ftracepy as ft
+
+inst_name = 'khist_example'
+
+cmds = ['start', 'stop', 'show', 'continue', 'clear', 'close']
+
+def get_hist():
+    hist = ft.hist(name='h1',
+                   system='kmem',
+                   event='kmalloc',
+                   axes={'call_site': 'sym',
+                         'bytes_req': 'n'})
+
+    hist.add_value(value='bytes_alloc')
+    hist.sort_keys(keys=['bytes_req', 'bytes_alloc'])
+    hist.sort_key_direction(sort_key='bytes_req', direction='desc')
+
+    return hist
+
+if __name__ == "__main__":
+    if len(sys.argv) != 2:
+        sys.exit(1)
+
+    if not sys.argv[1].isdigit() and not sys.argv[1] in cmds:
+        sys.exit(1)
+
+    arg1 = sys.argv[1]
+    if  arg1.isdigit() or arg1 == 'start':
+        inst = ft.create_instance(name=inst_name)
+        hist = get_hist()
+        hist.start(inst)
+
+        if arg1.isdigit():
+            time.sleep(int(arg1))
+            hist.stop(inst)
+            print(hist.read(inst))
+            hist.close(inst)
+        else:
+            ft.detach(inst)
+    else:
+        inst = ft.find_instance(name=inst_name)
+        hist = get_hist()
+
+        if arg1 == 'stop':
+            hist.stop(inst)
+        elif arg1 == 'show':
+            print(hist.read(inst))
+        elif arg1 == 'continue':
+            hist.resume(inst)
+        elif arg1 == 'clear':
+            hist.clear(inst)
+
+        if arg1 == 'close':
+            ft.attach(inst)
+            hist.close(inst)
-- 
2.32.0

