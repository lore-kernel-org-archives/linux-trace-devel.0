Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D66C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Feb 2022 16:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiBGQyz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 11:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357091AbiBGQjR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 11:39:17 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D569C0401DB
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Feb 2022 08:39:16 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id p24so6114797ejo.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Feb 2022 08:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rpK1JshPl5/VxUVTUP9cBns8MPGKlzp5cv4pZGfXtOM=;
        b=IKHStMUPNsUG1PnWQM0stsTZo1DPtZPaTrDc5SqHeXwj7RhgCkWNExc3/hfIs4NYyR
         qMH/tza6r0/yNmRAuWAv01Kj5L7usxVFFNPldtq+XojpyfUJrIWr5E1nukSH6k1kYQDN
         iBWyW+xI5EW7Wbztas/QnlNJHJtzeSGMVkWt1WNKP5qnSb0C+4AhUAEUC+cjkcuDvPmh
         h75yIS1ujqVS3qRIjXa8EBaCgkVwpWoAeftrQnLgfUXWLE112850A4BX0cSViOPkK9kL
         /TEmvcdyo9qO4fzZqXViHSaMYiJqLed3aPwvQtCTdfJn1CaIk7b9tXwlRU/yNGj29Hmm
         uVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rpK1JshPl5/VxUVTUP9cBns8MPGKlzp5cv4pZGfXtOM=;
        b=pTvKx+13he1LFzPbZ/ZIKXk05SqpVEiL7ybMknNo/XRbjaP5EDOUWh8X35uoRsBjJ3
         iLNhAHfW/gmlRgyGVSRoYDMkw9I8Rw9DVW2/Tk2V3SnPGJ3ma4ZeqlTtdXwNhvBvk3tX
         YsDvRxD9WhcAldGeBAE0/4uWoJ5xDCgkaK49RVD7TMXkVQN4wL6J/XQe0gUJV31HH2WJ
         lottNe69OPkDm2SB6YyGsxMiVEeMdBxOHif8Tyi+LQHwU6iJPqjaFxjv9mb+p1xaZH+c
         d0PHY+hka1u0SQzwf1E5/wTaE36WwrKf7AanTS/SL+OrzyXtXGK7xBkmAMqNHcrBYWUJ
         JoVA==
X-Gm-Message-State: AOAM531WNNyqtCOCg38a6H7lulH9G8qujaAFCMI7ZCa+vo6I+o6MH2RH
        DqO5uMgZzi2NKnC85waPLhF0vwa5r9w=
X-Google-Smtp-Source: ABdhPJwCdynaeA3YHkwbNfUiKA0cr1I+1tKZeT/5s1bEpBdzXp2M4lR/PqXRvTgCL+xcqLgLS6DCpA==
X-Received: by 2002:a17:906:af63:: with SMTP id os3mr458198ejb.204.1644251954397;
        Mon, 07 Feb 2022 08:39:14 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b7sm5415814edv.58.2022.02.07.08.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 08:39:14 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/4] trace-cruncher: Update 'kprobe_open.py' example
Date:   Mon,  7 Feb 2022 18:39:00 +0200
Message-Id: <20220207163900.178524-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207163900.178524-1-y.karadz@gmail.com>
References: <20220207163900.178524-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The class kprobe has been refactored. Here we update the corresponding
example accordingly. We also add more comments, explaining the usage
of the APIs.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/kprobe_open.py | 45 ++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/examples/kprobe_open.py b/examples/kprobe_open.py
index dff4861..141df66 100755
--- a/examples/kprobe_open.py
+++ b/examples/kprobe_open.py
@@ -11,24 +11,42 @@ import sys
 import tracecruncher.ftracepy as ft
 import tracecruncher.ft_utils as tc
 
-open_probe = tc.kprobe(name='open', func='do_sys_openat2')
+# We will define a kprobe event, to be recorded every time the function
+# 'do_sys_openat2' in the kernrl is called.
 
-open_probe.add_string_arg(name='file', param_id=2)
+# Add to the kprobe event a string field 'file', that will record the second
+# argument of the function.
+fields = tc.kprobe_add_string_arg(name='file', param_id=2)
 
-open_probe.add_ptr_arg(name='flags',
-                       param_id=3,
-                       param_type='x64')
+# Add to the kprobe event a field 'flags'. This field will take the third
+# argument of the function, which is a pointer to an object and will convert
+# its starting address into hexadecimal integer. This will decode the first
+# data field of the object.
+fields = tc.kprobe_add_ptr_arg(name='flags',
+                               param_id=3,
+                               param_type='x64',
+                               fields=fields)
 
-open_probe.add_ptr_arg(name='mode',
-                       param_id=3,
-                       param_type='x64',
-                       offset=8)
+# Add to the kprobe event a field 'flags'. This field will take the third
+# argument of the function, which is a pointer to an object and will convert
+# its starting address plus offset of 8 into hexadecimal integer. This will
+# decode the second data field of the object.
+fields = tc.kprobe_add_ptr_arg(name='mode',
+                               param_id=3,
+                               param_type='x64',
+                               offset=8,
+                               fields=fields)
 
-open_probe.register()
+# Create the kprobe event.
+open_probe = tc.kprobe(name='open',
+                       func='do_sys_openat2',
+                       fields=fields)
 
 tep = tc.local_tep()
 tc.short_kprobe_print(tep, [open_probe])
 
+# Define a callback function that will print
+# a short human-readable version.
 def callback(event, record):
     print(tep.info(event, record))
 
@@ -38,6 +56,13 @@ if __name__ == "__main__":
         print('Usage: ', sys.argv[0], ' [PROCESS]')
         sys.exit(1)
 
+    # Create new Ftrace instance to work in. The tracing in this new instance
+    # is not going to be enabled yet.
     inst = ft.create_instance(tracing_on=False)
+
+    # Enable the probe.
     open_probe.enable(instance=inst)
+
+    # Subscribe for the kprobe event (using the default function name 'callback')
+    # and trace the user process.
     ft.trace_process(instance=inst, argv=sys.argv[1:])
-- 
2.32.0

