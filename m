Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A36C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D1A2084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfDLNik (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42318 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfDLNij (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id g3so11971750wrx.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ishLnV8MI+ej7L98tC8iAM3HoVJtcTpCifJ1ELtu7UM=;
        b=ks/G+db42GAAFfAwrTcnxVK/RqQ615KG+D5zGdF2AEIEfwXjanVC1FZPW3QckXAH2R
         ksziGjOV5SyoLKGhIvsBVoncP6i5vTT7QxIEvYfZW8m7Z02dCS9Rh0DsbbfG9k1CnTHP
         PebioXcrD3nFguCA1MgPbx4G0pQev138Plb55sHDQCYJHTTNMK5/SxZTAivvv605zmaZ
         0Y34F1KIppAL3vHAwjvNsqekcZbc75yKtJxJwwuhQo25SDiFKusUN/MZ2kO5FWR5GJI7
         snF/euLaNK1LZKl8P1wg4+ehf9HXuwb8O+NpFHpz83UviE3Yq4dTNY8j8+5vuS+qHIIx
         iwzQ==
X-Gm-Message-State: APjAAAWweeW7miX75319R+/RDP+oOeCK0j049P1MyngIMnQCYUvXf3zd
        mijMNgcRtQCeZdtkvLvDptM=
X-Google-Smtp-Source: APXvYqxqdw9NBRTGB+d8ACzXCQzipvwlg7+0oRsvvQoIw2+RizlBTMv8erxbMy0uH+/vJv/lKY1Zzg==
X-Received: by 2002:a5d:6b04:: with SMTP id v4mr32867851wrw.69.1555076317989;
        Fri, 12 Apr 2019 06:38:37 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:37 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 27/30] tools/lib/traceevent: Man pages for tep plugins APIs
Date:   Fri, 12 Apr 2019 16:38:08 +0300
Message-Id: <20190412133811.15878-28-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_load_plugins(),
  tep_unload_plugin()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-plugins.txt   | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
new file mode 100644
index 000000000000..cecc7050c8f4
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
+	- User's plugin directory, located at _~/.traceevent/plugins_
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
2.20.1

