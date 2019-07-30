Return-Path: <SRS0=vd9q=V3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACB6C433FF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E16592089E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:50:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iH+LI8CK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbfG3Mup (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:50:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35793 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfG3Mup (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:50:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so56513353wmg.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 30 Jul 2019 05:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lA3uFN6ZnlK4+vSfg9i7DR+EKMOp88h+1TTFC/uja0w=;
        b=iH+LI8CKv/jLv6XiRAHn2rWXGLsY/ux0VpMLqOI1teeQJSeiLP5NIOAXQwh1ri/Sv/
         BbEmTJn/QJKJZX/bcEnbt6H79/C96Il186T02yfOVAKWjsr2Yz+XV1e5pIepiYBL7VyS
         4EuzojChczMiWFHR2teyV08Pi7pJam1Fa5lztQbvxAROissNT0nya+fZe4yGV0VoxH6A
         Xwsd9hGqPVo8heCuUVArJgnwCMntr0PNtuWrPDi2hhjB5CipBIKarbXJLzucOEgYCBA+
         pqdf9vd9xTA9kl43jrqT6npUUJS4GdcrUZjaq8fACq3qknlg45x2cLmkCGGmv1OR4ALN
         VZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lA3uFN6ZnlK4+vSfg9i7DR+EKMOp88h+1TTFC/uja0w=;
        b=bh5ECraBtwY/G4079PCfH84Tn+C7CqiZMJIQM34YmHFor1jwZBUQ/U8fkvx8pnOFrz
         MSDFwHtw7MtADR5M5BSTDTUsj5APztohWNllXuem3LZ+XeHaWOYoLp3zsj9sCx1ZiRnp
         uUA0nhe0+pAa4vp+t8B7SxHRKfSvoNbGWIVl/ByCqR0QgkNbdpClBVwrnSI4bSZSQNMv
         YXfqfJRFv8R7P0qkvs8m6v1KT78fn/CMAi9ILqQ/Tw0XCf2IRudaFgGziihuk8LNta7f
         URI7ZAKlwCz84FhaMLV5VIfWV7Txdxts7UVQCdRVBS8hMvlCxNZnwZUuKNsrc5w3Iu0Z
         wCHQ==
X-Gm-Message-State: APjAAAWpfOfVlFoJXqlFQZhc5VlyIqABtyLxJqCNFznbtd9ZJG7y/uYx
        uqoR+vLh9bbrHMwf+gIghx/hf54klpM=
X-Google-Smtp-Source: APXvYqxsXtwxRxtHu5mbFSIejZqGjqeJ0Tgpq+WQ9jq1hLyEcm3ht8uXFMM2UeUlJAuXQoCC+02pWg==
X-Received: by 2002:a1c:d10c:: with SMTP id i12mr105447175wmg.152.1564491043253;
        Tue, 30 Jul 2019 05:50:43 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 4sm146962355wro.78.2019.07.30.05.50.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 05:50:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8] tools/lib/traceevent: Man pages for tep plugins APIs
Date:   Tue, 30 Jul 2019 15:50:40 +0300
Message-Id: <20190730125040.24864-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for libtraceevent APIs:
  tep_load_plugins(),
  tep_unload_plugin()

Suggested-by: Patrick McLean <chutzpah@gentoo.org>
Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
[
 v8 changes:
   - the user's plugin directory changed from 
 ~/.config/traceevent/plugins/ to ~/.local/lib/traceevent/plugins/, 
 as suggested by Patrick McLean.
 https://lore.kernel.org/linux-trace-devel/20190313144206.41e75cf8@patrickm/
]

 .../Documentation/libtraceevent-plugins.txt   | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
new file mode 100644
index 000000000000..ce0288719939
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
@@ -0,0 +1,98 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_load_plugins, tep_unload_plugins - Load / unload traceevent plugins.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
+void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+The _tep_load_plugins()_ function loads all plugins, located in the plugin
+directories. The _tep_ argument is trace event parser context.
+The plugin directories are :
+[verse]
+--
+	- System's plugin directory, defined at the library compile time. It
+	  depends on the library installation prefix and usually is
+	  _(install_preffix)/lib/traceevent/plugins_
+	- Directory, defined by the environment variable _TRACEEVENT_PLUGIN_DIR_
+	- User's plugin directory, located at _~/.local/lib/traceevent/plugins_
+--
+Loading of plugins can be controlled by the _tep_flags_, using the
+_tep_set_flag()_ API:
+[verse]
+--
+	_TEP_DISABLE_SYS_PLUGINS_	- do not load plugins, located in
+					the system's plugin directory.
+	_TEP_DISABLE_PLUGINS_		- do not load any plugins.
+--
+The _tep_set_flag()_ API must be called before _tep_load_plugins()_.
+
+The _tep_unload_plugins()_ function unloads the plugins, previously loaded by
+_tep_load_plugins()_. The _tep_ argument is trace event parser context. The
+_plugin_list_ is the list of loaded plugins, returned by
+the _tep_load_plugins()_ function.
+
+RETURN VALUE
+------------
+The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
+or NULL in case no plugins are loaded.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_plugin_list *plugins = tep_load_plugins(tep);
+if (plugins == NULL) {
+	/* no plugins are loaded */
+}
+...
+tep_unload_plugins(plugins, tep);
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_, _tep_set_flag(3)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.21.0

