Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D792C31E45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E122206BB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfFMPgY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:36:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41131 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfFMKS4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 06:18:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so20123450wrm.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jun 2019 03:18:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HdVXgUBaoULxe84wXc62kK/7Aag1BXan4TPwIWTsbIA=;
        b=nE1hU8PuG6eC8yqdujT8ZoNuG6ZH2IiqipAmz5Dejr1265ciEfFLfdc/9Phyh5UF9l
         n2b082LS0MtfGORq42RIghr6+8nnTl4atoske7Ht2IEAhJh2ibro3x+fSGgOZCeuyQ9N
         eZ3doPl3p33uUXu8kWa+2HLUf4Wb0hDLNQiClUQpuOmGEp1NwjE8AXgU+bH2iK3nMdb3
         AH2FIk8ZCsjSKoyfTUUG296hq2usvgV6oL98rBzywWEfinneMf6az9s9UKldssrMLWW+
         LsV7WOjqW4mh95m9rrLXh9wAEWH3BMvbs9SD67BZBihh/mPO3uhBN6een7+s2tPapzP7
         Qmww==
X-Gm-Message-State: APjAAAV2P3KyvM/TXHn9NiY6muLuzyWSIkKtv/+WpnkUR3E0D6R1P9CC
        ZWFmw/uHDahHhyHHJYATLLReAfT1
X-Google-Smtp-Source: APXvYqwCTvQCIsbSPZqD8E6WC+YI7R/KWRSA/sB00UqIr0kc3AyzXxfyo7yUDhVajhtkECXlfX3Qdw==
X-Received: by 2002:a5d:4ac1:: with SMTP id y1mr6536205wrs.183.1560421133732;
        Thu, 13 Jun 2019 03:18:53 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s9sm2712198wmc.11.2019.06.13.03.18.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 03:18:52 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 2/2] tools/lib/traceevent: Man pages for tep plugins APIs
Date:   Thu, 13 Jun 2019 13:18:51 +0300
Message-Id: <20190613101851.22811-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613101851.22811-1-tstoyanov@vmware.com>
References: <20190613101851.22811-1-tstoyanov@vmware.com>
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
index 000000000000..b8c0525c7312
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
+	- User's plugin directory, located at _~/.config/traceevent/plugins_
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

