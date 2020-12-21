Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EFEAC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6603D22513
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgLUGEC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbgLUGEC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:04:02 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4647DC0611CE
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:04 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ce23so11785889ejb.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QsqMVQCfhuTivF9IcYxjxO3F76SUYIobWK4h1GVmQUA=;
        b=uDnLG3++V3HZ4KvrkmWLN9IXljxXlrO/I0XGF4UYpHzWHx9Kt+SFQn5GiowpiA9U8w
         1T06mDKXScP/intS+PhcUzXYxY6P/LWfxPGvj6yKTarXmcxoSSNwSzpG0NaxWKb9n2qy
         RDUDXKQ6ExgXBYxyutjBeLN4BILGUiqKPv8dMJBBM1BviPF1ucj7Oihm42ZUKfv48Bz5
         ZZkiuXzCOJKosy80Q9id2H1Jmj1rChhQsWdx69S1r1WXBVif1mWTi0QPobJmlW+zfT+b
         /Mcxygmn/09Ct45R7Gsfi8LDKAgkR9WA1Tve7dkblmkTR2dNd0a+pqf4XWbUpF91UC26
         0PEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QsqMVQCfhuTivF9IcYxjxO3F76SUYIobWK4h1GVmQUA=;
        b=GWLiIFaC0Q38q06UDMCJ6LD7SazEJ2LPP8UeASCbuWMWSIvXQWXBWdC22CXQXY1tr5
         6ksmfK2P0QTxkktLUQFIOFZev/RZIz35tLTuyyr2mK0mqp/AfU6MlACltZvOYjMASoQI
         NXUuEREa/H6De+KwTizl7b69vp4Qj7aH6JoFXCBYYxapnj4xwp1J+VTfzMGN3FWsX8rp
         6zMyoA4ueBcqeNac8NypUEMNAvLNJJ/1Alf2akLz4ZSk/vxVoEWYxP+NcLGwQIfZEWCQ
         Szt6miko9cHlpCeVikWkGS4Cj3e/LUkVHdCFf4HdFzR0O6c1WKqK8lPbuRd+eP96SkgX
         eM+Q==
X-Gm-Message-State: AOAM530WjUz4zPV03adZ5h1wUm245zQ3MSvg2XFLCXWUbkgr8QFSa+O0
        1vh07DA3XR/IwcXhqjl4gRX7Qoej+ozvktyV
X-Google-Smtp-Source: ABdhPJxqyh1SAAYkfBoDhsuXdshrAkR16ylV16jU3GGFGM7AK3lT5zFHiSNYuseVanu0TDR9/A9HFw==
X-Received: by 2002:a17:906:168f:: with SMTP id s15mr13703268ejd.180.1608530583065;
        Sun, 20 Dec 2020 22:03:03 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z10sm8560885ejl.30.2020.12.20.22.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:03:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 6/8] libtracefs man pages: helper APIs for working with trace instances.
Date:   Mon, 21 Dec 2020 08:02:50 +0200
Message-Id: <20201221060252.177890-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201221060252.177890-1-tz.stoyanov@gmail.com>
References: <20201221060252.177890-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_instance_get_name()
tracefs_instances_walk()
tracefs_instance_exists()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-utils.txt | 112 +++++++++++++++++++
 1 file changed, 112 insertions(+)
 create mode 100644 Documentation/libtracefs-instances-utils.txt

diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
new file mode 100644
index 0000000..aa5efbd
--- /dev/null
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -0,0 +1,112 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_instance_get_name, tracefs_instances_walk, tracefs_instance_exists -
+Helper functions for working with tracing instances.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
+int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
+bool *tracefs_instance_exists*(const char pass:[*]_name_);
+
+--
+
+DESCRIPTION
+-----------
+Helper functions for working with trace instances.
+
+The _tracefs_instance_get_name()_ function returns the name of the given _instance_.
+Note that the top instance has no name, the function returns NULL for it.
+
+The _tracefs_instances_walk()_ function walks through all configured tracing
+instances in the system and calls _callback_ for each one of them. The _context_
+argument is passed to the _callback_, together with the instance name. If the
+_callback_ returns non-zero, the iteration stops. Note, the _callback_ is not
+called for the top top instance.
+
+The _tracefs_instance_exists()_ function checks if an instance with the given
+_name_ exists in the system.
+
+RETURN VALUE
+------------
+The _tracefs_instance_get_name()_ returns a string or NULL in case of the top
+instance. The returned string must _not_ be freed.
+
+The _tracefs_instances_walk()_ function returns 0, if all instances were iterated, 1
+if the iteration was stopped by the _callback_, or -1 in case of an error.
+
+The _tracefs_instance_exists()_ returns true if an instance with the given name
+exists in the system or false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+struct tracefs_instance *inst;
+....
+char *name = tracefs_instance_get_name(inst);
+
+	if(name) {
+		/* Got name of the instance */
+	}
+
+...
+static int instance_walk(char *name, void *context)
+{
+	/* Got instance with name */
+	return 0;
+}
+...
+	if (tracefs_instances_walk(instance_walk, NULL) < 0) {
+		/* Error walking through the instances */
+	}
+...
+	if (tracefs_instance_exists("foo")) {
+		/* There is instance with name foo in the system */
+	} else {
+		/* There is no instance with name foo in the system */
+	}
+--
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
\ No newline at end of file
-- 
2.28.0

